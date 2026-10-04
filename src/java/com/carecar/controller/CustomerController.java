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
import java.util.List;

@WebServlet(name = "CustomerController", urlPatterns = {"/customer/dashboard", "/customer/add-car"})
public class CustomerController extends HttpServlet {

    private CustomerDAO customerDAO = new CustomerDAO();
    private CarDAO carDAO = new CarDAO();
    private RepairOrderDAO repairOrderDAO = new RepairOrderDAO();
    private AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        Customer customer = customerDAO.getCustomerByUserId(currentUser.getUserId());
        if (customer == null) {
            customer = customerDAO.getCustomerByPhone(currentUser.getPhone());
        }

        if (customer != null) {
            List<Car> cars = carDAO.getCarsByCustomerId(customer.getCustomerId());
            List<RepairOrder> orders = repairOrderDAO.getOrdersByCustomerId(customer.getCustomerId());
            List<Appointment> appointments = appointmentDAO.getCustomerAppointments(customer.getCustomerId());

            request.setAttribute("customer", customer);
            request.setAttribute("cars", cars);
            request.setAttribute("orders", orders);
            request.setAttribute("appointments", appointments);
        }

        request.getRequestDispatcher("/WEB-INF/views/customer/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        Customer customer = customerDAO.getCustomerByUserId(currentUser.getUserId());
        if (customer == null) {
            customer = customerDAO.getCustomerByPhone(currentUser.getPhone());
        }

        if ("addCar".equals(action) && customer != null) {
            String licensePlate = request.getParameter("licensePlate");
            String brand = request.getParameter("brand");
            String model = request.getParameter("model");
            String yearStr = request.getParameter("yearManufactured");
            String color = request.getParameter("color");
            String vin = request.getParameter("vinNumber");
            String mileageStr = request.getParameter("currentMileage");

            Car car = new Car();
            car.setCustomerId(customer.getCustomerId());
            car.setLicensePlate(licensePlate != null ? licensePlate.toUpperCase().trim() : "");
            car.setBrand(brand);
            car.setModel(model);
            if (yearStr != null && !yearStr.trim().isEmpty()) {
                try {
                    car.setYearManufactured(Integer.parseInt(yearStr));
                } catch (NumberFormatException ignored) {
                }
            }
            car.setColor(color);
            car.setVinNumber(vin);
            if (mileageStr != null && !mileageStr.trim().isEmpty()) {
                try {
                    car.setCurrentMileage(Integer.parseInt(mileageStr));
                } catch (NumberFormatException ignored) {
                }
            }

            carDAO.insertCar(car);
            response.sendRedirect(request.getContextPath() + "/customer/dashboard?msg=car_added");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/customer/dashboard");
    }
}
