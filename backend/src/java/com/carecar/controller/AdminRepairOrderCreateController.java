package com.carecar.controller;

import com.carecar.dal.CarDAO;
import com.carecar.dal.CustomerDAO;
import com.carecar.dal.RepairOrderDAO;
import com.carecar.dal.ServiceDAO;
import com.carecar.dal.UserDAO;
import com.carecar.model.Car;
import com.carecar.model.Customer;
import com.carecar.model.RepairOrder;
import com.carecar.model.ServiceItem;
import com.carecar.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;
import java.text.SimpleDateFormat;

@WebServlet(name = "AdminRepairOrderCreateController", urlPatterns = {"/admin/repair-order-create"})
public class AdminRepairOrderCreateController extends HttpServlet {

    private CustomerDAO customerDAO = new CustomerDAO();
    private CarDAO carDAO = new CarDAO();
    private UserDAO userDAO = new UserDAO();
    private RepairOrderDAO repairOrderDAO = new RepairOrderDAO();
    private ServiceDAO serviceDAO = new ServiceDAO();

    private boolean checkOrderCreatePermission(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null || (!currentUser.isAdmin() && !currentUser.isReceptionist())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=access_denied");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!checkOrderCreatePermission(request, response)) {
            return;
        }

        List<Customer> customers = customerDAO.getAllCustomers();
        List<Car> cars = carDAO.getAllCars();
        List<User> mechanics = userDAO.getMechanics();
        List<ServiceItem> allServices = serviceDAO.getActiveServices();

        // Kiểm tra lịch làm việc hiện tại của các kỹ thuật viên
        Timestamp now = new Timestamp(System.currentTimeMillis());
        SimpleDateFormat timeFormat = new SimpleDateFormat("dd/MM HH:mm");
        for (User m : mechanics) {
            RepairOrder conflict = repairOrderDAO.getConflictingOrderByMechanic(m.getUserId(), now, null, 0);
            if (conflict != null) {
                m.setBusy(true);
                String timeStr = (conflict.getEntryDate() != null ? timeFormat.format(conflict.getEntryDate()) : "") +
                        (conflict.getExpectedFinishDate() != null ? " - " + timeFormat.format(conflict.getExpectedFinishDate()) : "");
                m.setScheduleNote(conflict.getOrderCode() + " [" + conflict.getCarLicensePlate() + "] " + timeStr);
            } else {
                m.setBusy(false);
                m.setScheduleNote("Sẵn sàng");
            }
        }

        request.setAttribute("customers", customers);
        request.setAttribute("cars", cars);
        request.setAttribute("mechanics", mechanics);
        request.setAttribute("allServices", allServices);
        request.getRequestDispatcher("/WEB-INF/views/admin/repair-order-create.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!checkOrderCreatePermission(request, response)) {
            return;
        }

        try {
            String customerType = request.getParameter("customerType"); // existing OR new
            int customerId = 0;
            int carId = 0;

            if ("new".equals(customerType)) {
                String fullName = request.getParameter("newCustomerName");
                String phone = request.getParameter("newCustomerPhone");
                String email = request.getParameter("newCustomerEmail");
                String address = request.getParameter("newCustomerAddress");

                if (fullName == null || fullName.trim().isEmpty() || phone == null || phone.trim().isEmpty()) {
                    request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ tên và số điện thoại khách hàng!");
                    doGet(request, response);
                    return;
                }

                fullName = fullName.trim();
                phone = phone.trim();

                Customer existingCust = customerDAO.getCustomerByPhone(phone);
                if (existingCust != null) {
                    customerId = existingCust.getCustomerId();
                    existingCust.setFullName(fullName);
                    if (email != null && !email.trim().isEmpty()) existingCust.setEmail(email.trim());
                    if (address != null && !address.trim().isEmpty()) existingCust.setAddress(address.trim());
                    customerDAO.updateCustomer(existingCust);
                } else {
                    Customer cust = new Customer();
                    cust.setFullName(fullName);
                    cust.setPhone(phone);
                    cust.setEmail(email != null && !email.trim().isEmpty() ? email.trim() : null);
                    cust.setAddress(address != null && !address.trim().isEmpty() ? address.trim() : null);
                    customerId = customerDAO.insertCustomer(cust);
                    if (customerId <= 0) {
                        request.setAttribute("errorMessage", "Không thể lưu thông tin khách hàng mới. Vui lòng thử lại!");
                        doGet(request, response);
                        return;
                    }
                }

                String licensePlate = request.getParameter("newLicensePlate");
                String brand = request.getParameter("newCarBrand");
                String model = request.getParameter("newCarModel");
                String color = request.getParameter("newCarColor");

                if (licensePlate == null || licensePlate.trim().isEmpty()) {
                    request.setAttribute("errorMessage", "Vui lòng nhập biển số xe!");
                    doGet(request, response);
                    return;
                }

                licensePlate = licensePlate.toUpperCase().trim();
                Car existingCar = carDAO.getCarByLicensePlate(licensePlate);
                if (existingCar != null) {
                    carId = existingCar.getCarId();
                    if (brand != null && !brand.trim().isEmpty()) existingCar.setBrand(brand.trim());
                    if (model != null && !model.trim().isEmpty()) existingCar.setModel(model.trim());
                    if (color != null && !color.trim().isEmpty()) existingCar.setColor(color.trim());
                    carDAO.updateCar(existingCar);
                } else {
                    Car car = new Car();
                    car.setCustomerId(customerId);
                    car.setLicensePlate(licensePlate);
                    car.setBrand(brand != null && !brand.trim().isEmpty() ? brand.trim() : "Chưa xác định");
                    car.setModel(model != null && !model.trim().isEmpty() ? model.trim() : "");
                    car.setColor(color != null && !color.trim().isEmpty() ? color.trim() : "");
                    carId = carDAO.insertCar(car);
                    if (carId <= 0) {
                        request.setAttribute("errorMessage", "Không thể lưu thông tin xe mới. Vui lòng kiểm tra lại biển số xe!");
                        doGet(request, response);
                        return;
                    }
                }

            } else {
                customerId = Integer.parseInt(request.getParameter("customerId"));
                String carOption = request.getParameter("carOption"); // existingCar OR newCarForExisting
                if ("newCarForExisting".equals(carOption)) {
                    String licensePlate = request.getParameter("licensePlateExistingCust");
                    String brand = request.getParameter("brandExistingCust");
                    String model = request.getParameter("modelExistingCust");

                    if (licensePlate == null || licensePlate.trim().isEmpty()) {
                        request.setAttribute("errorMessage", "Vui lòng nhập biển số xe!");
                        doGet(request, response);
                        return;
                    }

                    licensePlate = licensePlate.toUpperCase().trim();
                    Car existingCar = carDAO.getCarByLicensePlate(licensePlate);
                    if (existingCar != null) {
                        carId = existingCar.getCarId();
                        if (brand != null && !brand.trim().isEmpty()) existingCar.setBrand(brand.trim());
                        if (model != null && !model.trim().isEmpty()) existingCar.setModel(model.trim());
                        carDAO.updateCar(existingCar);
                    } else {
                        Car car = new Car();
                        car.setCustomerId(customerId);
                        car.setLicensePlate(licensePlate);
                        car.setBrand(brand != null && !brand.trim().isEmpty() ? brand.trim() : "Chưa xác định");
                        car.setModel(model != null && !model.trim().isEmpty() ? model.trim() : "");
                        carId = carDAO.insertCar(car);
                        if (carId <= 0) {
                            request.setAttribute("errorMessage", "Không thể lưu thông tin xe mới. Vui lòng kiểm tra lại biển số xe!");
                            doGet(request, response);
                            return;
                        }
                    }
                } else {
                    carId = Integer.parseInt(request.getParameter("carId"));
                }
            }

            String mileageStr = request.getParameter("entryMileage");
            Integer mileage = (mileageStr != null && !mileageStr.trim().isEmpty()) ? Integer.parseInt(mileageStr) : null;
            if (mileage != null && carId > 0) {
                carDAO.updateMileage(carId, mileage);
            }

            String initialDiagnosis = request.getParameter("initialDiagnosis");
            String mechIdStr = request.getParameter("mechanicId");
            Integer mechanicId = (mechIdStr != null && !mechIdStr.trim().isEmpty()) ? Integer.parseInt(mechIdStr) : null;

            String finishStr = request.getParameter("expectedFinishDate");
            Timestamp expectedFinish = null;
            if (finishStr != null && !finishStr.trim().isEmpty()) {
                try {
                    expectedFinish = Timestamp.valueOf(finishStr.replace("T", " ") + ":00");
                } catch (IllegalArgumentException ignored) {
                }
            }

            // Kiểm tra chống trùng lịch thợ máy
            if (mechanicId != null) {
                Timestamp start = new Timestamp(System.currentTimeMillis());
                RepairOrder conflict = repairOrderDAO.getConflictingOrderByMechanic(mechanicId, start, expectedFinish, 0);
                if (conflict != null) {
                    User mech = userDAO.getUserById(mechanicId);
                    String mechName = (mech != null) ? mech.getFullName() : "Thợ máy #" + mechanicId;
                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                    String timeStr = (conflict.getEntryDate() != null ? sdf.format(conflict.getEntryDate()) : "") +
                            (conflict.getExpectedFinishDate() != null ? " đến " + sdf.format(conflict.getExpectedFinishDate()) : "");
                    request.setAttribute("errorMessage", 
                        "Không thể phân công: Kỹ thuật viên " + mechName + " đang có lịch sửa chữa cho lệnh " + 
                        conflict.getOrderCode() + " (" + conflict.getCarLicensePlate() + ") từ " + timeStr + ". Vui lòng chọn kỹ thuật viên khác!");
                    doGet(request, response);
                    return;
                }
            }

            HttpSession session = request.getSession(false);
            User currentUser = (User) session.getAttribute("currentUser");

            RepairOrder ro = new RepairOrder();
            ro.setCustomerId(customerId);
            ro.setCarId(carId);
            ro.setReceptionistId(currentUser != null ? currentUser.getUserId() : null);
            ro.setMechanicId(mechanicId);
            ro.setEntryDate(new Timestamp(System.currentTimeMillis()));
            ro.setExpectedFinishDate(expectedFinish);
            ro.setEntryMileage(mileage);
            ro.setInitialDiagnosis(initialDiagnosis);
            ro.setOrderStatus("PENDING_INSPECTION");
            ro.setTotalServiceCost(BigDecimal.ZERO);
            ro.setTotalPartCost(BigDecimal.ZERO);
            ro.setDiscountAmount(BigDecimal.ZERO);
            ro.setTaxVat(BigDecimal.ZERO);
            ro.setGrandTotal(BigDecimal.ZERO);

            int orderId = repairOrderDAO.createRepairOrder(ro);
            if (orderId > 0) {
                // If initial services were selected during reception, add them and auto-calculate totals
                String[] selectedServices = request.getParameterValues("selectedServices");
                if (selectedServices != null && selectedServices.length > 0) {
                    for (String svcIdStr : selectedServices) {
                        try {
                            int svcId = Integer.parseInt(svcIdStr.trim());
                            ServiceItem svc = serviceDAO.getServiceById(svcId);
                            if (svc != null) {
                                repairOrderDAO.addServiceToOrder(orderId, svcId, svc.getServiceName(), svc.getLaborCost(), 1, "Tiếp nhận ban đầu");
                            }
                        } catch (Exception ignored) {
                        }
                    }
                }

                response.sendRedirect(request.getContextPath() + "/admin/repair-order-detail?id=" + orderId + "&msg=created");
            } else {
                request.setAttribute("errorMessage", "Không thể tạo phiếu sửa chữa. Vui lòng kiểm tra lại thông tin!");
                doGet(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi dữ liệu không hợp lệ. Vui lòng kiểm tra lại thông tin!");
            doGet(request, response);
        }
    }
}
