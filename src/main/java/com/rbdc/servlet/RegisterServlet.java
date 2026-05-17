package com.rbdc.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.rbdc.dao.DBConnection;

/**
 * RegisterServlet
 * Handles new user self-registration for:
 *   - Data Owner    → inserts into doregister with status1='Pending'
 *   - Data Consumer → inserts into dcregister  with status='Pending'
 *
 * Admin (Cloud Server) must approve before user can login.
 *
 * Form fields: role, name, email, password, mobile, address
 * URL: /RegisterServlet
 */
@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public RegisterServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter pw = response.getWriter();

        String role     = request.getParameter("role");
        String name     = request.getParameter("name");
        String email    = request.getParameter("email");
        String password = request.getParameter("password");
        String mobile   = request.getParameter("mobile");
        String address  = request.getParameter("address");

        // ── Null / empty check ────────────────────────────────────
        if (name == null || email == null || password == null
                || name.trim().isEmpty() || email.trim().isEmpty()
                || password.trim().isEmpty()) {
            sendAlert(pw, "Name, Email and Password are required.", "register.jsp");
            return;
        }

        // Safe defaults
        if (mobile == null) mobile = "";
        if (address == null) address = "";

        Connection con = DBConnection.connect();
        if (con == null) {
            sendAlert(pw, "Database connection failed. Please try later.", "register.jsp");
            return;
        }

        try {
            if ("dataowner".equalsIgnoreCase(role)) {
                registerDO(con, pw, name, email, password, mobile, address);
            } else if ("dataconsumer".equalsIgnoreCase(role)) {
                registerDC(con, pw, name, email, password, mobile, address);
            } else {
                sendAlert(pw, "Invalid role selected.", "register.jsp");
            }
        } finally {
            try { con.close(); } catch (SQLException ignored) {}
        }
    }

    // ── Register Data Owner ───────────────────────────────────────
    private void registerDO(Connection con, PrintWriter pw,
            String name, String email, String password,
            String mobile, String address) throws IOException {

        // Check duplicate email
        if (DBConnection.getData("select * from doregister where email='" + email + "'")) {
            sendAlert(pw, "This email is already registered as Data Owner.", "register.jsp");
            return;
        }

        String sql = "insert into doregister(name,email,password,mobile,address,status1) "
                   + "values(?,?,?,?,?,'Pending')";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, mobile);
            ps.setString(5, address);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                sendAlert(pw,
                    "Data Owner registered! Wait for Admin approval to login.",
                    "login.jsp");
            } else {
                sendAlert(pw, "Registration failed. Please try again.", "register.jsp");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            sendAlert(pw, "Database error: " + e.getMessage(), "register.jsp");
        }
    }

    // ── Register Data Consumer ────────────────────────────────────
    private void registerDC(Connection con, PrintWriter pw,
            String name, String email, String password,
            String mobile, String address) throws IOException {

        // Check duplicate email
        if (DBConnection.getData("select * from dcregister where email='" + email + "'")) {
            sendAlert(pw, "This email is already registered as Data Consumer.", "register.jsp");
            return;
        }

        String sql = "insert into dcregister(name,email,password,mobile,address,status) "
                   + "values(?,?,?,?,?,'Pending')";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, mobile);
            ps.setString(5, address);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                sendAlert(pw,
                    "Data Consumer registered! Wait for Admin approval to login.",
                    "login.jsp");
            } else {
                sendAlert(pw, "Registration failed. Please try again.", "register.jsp");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            sendAlert(pw, "Database error: " + e.getMessage(), "register.jsp");
        }
    }

    // ── Helper ────────────────────────────────────────────────────
    private void sendAlert(PrintWriter pw, String msg, String page) {
        pw.println("<script type=\"text/javascript\">");
        pw.println("alert('" + msg.replace("'", "\\'") + "');");
        pw.println("window.location='" + page + "';");
        pw.println("</script>");
    }
}
