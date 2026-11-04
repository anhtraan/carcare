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
import java.sql.Timestamp;
import java.util.List;

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

                Customer cust = new Customer();
                cust.setFullName(fullName);
                cust.setPhone(phone);
                cust.setEmail(email);
                cust.setAddress(address);
                customerId = customerDAO.insertCustomer(cust);

                String licensePlate = request.getParameter("newLicensePlate");
                String brand = request.getParameter("newCarBrand");
                String model = request.getParameter("newCarModel");
                String color = request.getParameter("newCarColor");

                Car car = new Car();
                car.setCustomerId(customerId);
                car.setLicensePlate(licensePlate != null ? licensePlate.toUpperCase().trim() : "");
                car.setBrand(brand != null ? brand : "Chưa xác định");
                car.setModel(model != null ? model : "");
                car.setColor(color);
                carId = carDAO.insertCar(car);

            } else {
                customerId = Integer.parseInt(request.getParameter("customerId"));
                String carOption = request.getParameter("carOption"); // existingCar OR newCarForExisting
                if ("newCarForExisting".equals(carOption)) {
                    String licensePlate = request.getParameter("licensePlateExistingCust");
                    String brand = request.getParameter("brandExistingCust");
                    String model = request.getParameter("modelExistingCust");

                    Car car = new Car();
                    car.setCustomerId(customerId);
                    car.setLicensePlate(licensePlate != null ? licensePlate.toUpperCase().trim() : "");
                    car.setBrand(brand);
                    car.setModel(model);
                    carId = carDAO.insertCar(car);
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

            HttpSession session = request.getSession(false);
            User currentUser = (User) session.getAttribute("currentUser");

            RepairOrder ro = new RepairOrder();
            ro.setCustomerId(customerId);
            ro.setCarId(carId);
            ro.setReceptionistId(currentUser != null ? currentUser.getUserId() : null);
            ro.setMechanicId(mechanicId);
            ro.setEntryDate(new Timestamp(System.currentTimeMillis()));
            ro.setEntryMileage(mileage);
            ro.setInitialDiagnosis(initialDiagnosis);
            ro.setOrderStatus("PENDING_INSPECTION");

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
