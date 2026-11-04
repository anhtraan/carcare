package com.carecar.controller;

import com.carecar.dal.AppointmentDAO;
import com.carecar.dal.CarDAO;
import com.carecar.dal.CustomerDAO;
import com.carecar.dal.RepairOrderDAO;
import com.carecar.model.Appointment;
import com.carecar.model.Car;
import com.carecar.model.Customer;
import com.carecar.model.RepairOrder;
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

@WebServlet(name = "AdminAppointmentController", urlPatterns = {"/admin/appointments"})
public class AdminAppointmentController extends HttpServlet {

    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private CustomerDAO customerDAO = new CustomerDAO();
    private CarDAO carDAO = new CarDAO();
    private RepairOrderDAO repairOrderDAO = new RepairOrderDAO();

    private boolean checkAppointmentAccess(HttpServletRequest request, HttpServletResponse response) throws IOException {
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
        
        if (!checkAppointmentAccess(request, response)) {
            return;
        }

        String filterStatus = request.getParameter("status");
        List<Appointment> list = appointmentDAO.getAllAppointments();

        if (filterStatus != null && !filterStatus.trim().isEmpty() && !"ALL".equalsIgnoreCase(filterStatus)) {
            list = list.stream()
                    .filter(a -> filterStatus.equalsIgnoreCase(a.getStatus()))
                    .toList();
        }

        request.setAttribute("appointments", list);
        request.setAttribute("filterStatus", filterStatus);
        request.getRequestDispatcher("/WEB-INF/views/admin/appointments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!checkAppointmentAccess(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        String idStr = request.getParameter("appointmentId");

        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/appointments");
            return;
        }

        int appointmentId = Integer.parseInt(idStr);

        if ("updateStatus".equals(action)) {
            String newStatus = request.getParameter("newStatus");
            appointmentDAO.updateStatus(appointmentId, newStatus);
            response.sendRedirect(request.getContextPath() + "/admin/appointments?msg=status_updated");
            return;
        }

        if ("convertToOrder".equals(action)) {
            Appointment app = appointmentDAO.getAppointmentById(appointmentId);
            if (app != null) {
                // Ensure customer and car exist
                int customerId = (app.getCustomerId() != null && app.getCustomerId() > 0) ? app.getCustomerId() : 0;
                if (customerId == 0) {
                    Customer cust = customerDAO.getCustomerByPhone(app.getPhone());
                    if (cust != null) {
                        customerId = cust.getCustomerId();
                    } else {
                        Customer newC = new Customer();
                        newC.setFullName(app.getCustomerName());
                        newC.setPhone(app.getPhone());
                        customerId = customerDAO.insertCustomer(newC);
                    }
                }

                int carId = (app.getCarId() != null && app.getCarId() > 0) ? app.getCarId() : 0;
                if (carId == 0) {
                    Car car = carDAO.getCarByLicensePlate(app.getLicensePlate());
                    if (car != null) {
                        carId = car.getCarId();
                    } else {
                        Car newCar = new Car();
                        newCar.setCustomerId(customerId);
                        newCar.setLicensePlate(app.getLicensePlate());
                        newCar.setBrand(app.getCarBrandModel() != null ? app.getCarBrandModel() : "Chưa xác định");
                        newCar.setModel("");
                        carId = carDAO.insertCar(newCar);
                    }
                }

                HttpSession session = request.getSession(false);
                User currentUser = (User) session.getAttribute("currentUser");

                RepairOrder ro = new RepairOrder();
                ro.setCustomerId(customerId);
                ro.setCarId(carId);
                ro.setReceptionistId(currentUser != null ? currentUser.getUserId() : null);
                ro.setEntryDate(new Timestamp(System.currentTimeMillis()));
                ro.setInitialDiagnosis("Đặt từ lịch hẹn: " + app.getRequestedService() + (app.getNotes() != null ? " - " + app.getNotes() : ""));
                ro.setOrderStatus("PENDING_INSPECTION");

                int orderId = repairOrderDAO.createRepairOrder(ro);
                if (orderId > 0) {
                    appointmentDAO.updateStatus(appointmentId, "CONFIRMED");
                    response.sendRedirect(request.getContextPath() + "/admin/repair-order-detail?id=" + orderId + "&msg=created_from_appointment");
                    return;
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/appointments");
    }
}
