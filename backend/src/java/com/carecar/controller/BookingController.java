package com.carecar.controller;

import com.carecar.dal.AppointmentDAO;
import com.carecar.dal.CarDAO;
import com.carecar.dal.CustomerDAO;
import com.carecar.dal.ServiceDAO;
import com.carecar.dal.UserDAO;
import com.carecar.model.Appointment;
import com.carecar.model.Car;
import com.carecar.model.Customer;
import com.carecar.model.ServiceItem;
import com.carecar.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "BookingController", urlPatterns = {"/booking"})
public class BookingController extends HttpServlet {

    private ServiceDAO serviceDAO = new ServiceDAO();
    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private CustomerDAO customerDAO = new CustomerDAO();
    private CarDAO carDAO = new CarDAO();

    private String sanitize(String input) {
        if (input == null) return null;
        return input.replace("<", "").replace(">", "").trim();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<ServiceItem> services = serviceDAO.getActiveServices();
        request.setAttribute("services", services);

        // Pre-fill if logged in customer
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            User u = (User) session.getAttribute("currentUser");
            if (u.isCustomer()) {
                Customer cust = customerDAO.getCustomerByUserId(u.getUserId());
                request.setAttribute("userCustomer", cust);
            }
        }

        String status = request.getParameter("status");
        if ("success".equals(status)) {
            request.getRequestDispatcher("/WEB-INF/views/booking-success.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String customerName = sanitize(request.getParameter("customerName"));
            String phone = sanitize(request.getParameter("phone"));
            String licensePlate = sanitize(request.getParameter("licensePlate"));
            String carBrandModel = sanitize(request.getParameter("carBrandModel"));
            String dateStr = sanitize(request.getParameter("appointmentDate"));
            String timeSlot = sanitize(request.getParameter("timeSlot"));
            String requestedService = sanitize(request.getParameter("requestedService"));
            String notes = sanitize(request.getParameter("notes"));

            if (customerName == null || phone == null || licensePlate == null || dateStr == null || timeSlot == null
                    || customerName.isEmpty() || phone.isEmpty() || licensePlate.isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng điền đầy đủ các thông tin bắt buộc (*)");
                doGet(request, response);
                return;
            }

            Date appDate = Date.valueOf(dateStr);

            // Check if customer exists in DB
            Customer existingCustomer = customerDAO.getCustomerByPhone(phone);
            Integer customerId = null;
            Integer carId = null;

            if (existingCustomer != null) {
                customerId = existingCustomer.getCustomerId();
            } else {
                Customer newCust = new Customer();
                newCust.setFullName(customerName);
                newCust.setPhone(phone);
                newCust.setNotes("Khách tạo từ lịch hẹn online");
                customerId = customerDAO.insertCustomer(newCust);
            }

            // Check if car exists
            Car existingCar = carDAO.getCarByLicensePlate(licensePlate);
            if (existingCar != null) {
                carId = existingCar.getCarId();
            } else if (customerId != null && customerId > 0) {
                Car newCar = new Car();
                newCar.setCustomerId(customerId);
                newCar.setLicensePlate(licensePlate.toUpperCase().trim());
                newCar.setBrand(carBrandModel != null ? carBrandModel : "Chưa xác định");
                newCar.setModel("");
                carId = carDAO.insertCar(newCar);
            }

            if (customerId != null && customerId <= 0) {
                customerId = null;
            }
            if (carId != null && carId <= 0) {
                carId = null;
            }

            Appointment app = new Appointment();
            app.setCustomerId(customerId);
            app.setCarId(carId);
            app.setCustomerName(customerName);
            app.setPhone(phone);
            app.setLicensePlate(licensePlate.toUpperCase().trim());
            app.setCarBrandModel(carBrandModel);
            app.setAppointmentDate(appDate);
            app.setTimeSlot(timeSlot);
            app.setRequestedService(requestedService);
            app.setNotes(notes);
            app.setStatus("PENDING");

            int appointmentId = appointmentDAO.insertAppointment(app);
            if (appointmentId > 0) {
                request.getSession().setAttribute("latestAppointmentId", appointmentId);
                response.sendRedirect(request.getContextPath() + "/booking?status=success");
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra trong quá trình đặt lịch. Vui lòng thử lại hoặc gọi Hotline!");
                doGet(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Dữ liệu nhập không hợp lệ. Vui lòng kiểm tra lại thông tin!");
            doGet(request, response);
        }
    }
}
