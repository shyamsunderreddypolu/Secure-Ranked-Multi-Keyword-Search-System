package com.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.dao.DBConnection;

/**
 * LoginServlet
 * Handles POST login for all four RBDC roles:
 *   - admin        → CSHome.jsp
 *   - dataowner    → DOHome.jsp   (must be Approved in doregister)
 *   - dataconsumer → DCHome.jsp   (must be Approved in dcregister)
 *   - pkg          → PKGHome.jsp
 *
 * Support for GET logout:
 *   - /LoginServlet?action=logout → invalidates session and redirects
 *
 * Form fields expected:
 *   role, email, password
 *
 * URL: /LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public LoginServlet() {
        super();
    }

    /** GET — handles logout or redirects to login page */
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equalsIgnoreCase(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("login.jsp");
            return;
        }
        response.sendRedirect("login.jsp");
    }

    /** POST — validate credentials, create session, redirect */
    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter pw = response.getWriter();

        String role     = request.getParameter("role");
        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        // ── Basic validation ──────────────────────────────────────
        if (role == null || email == null || password == null
                || email.trim().isEmpty() || password.trim().isEmpty()) {
            sendAlert(pw, "Please fill in all fields.", "login.jsp");
            return;
        }

        HttpSession session = request.getSession(true);
        boolean valid       = false;
        String  redirect    = "login.jsp";
        String  name        = "";

        Connection con = DBConnection.connect();
        if (con == null) {
            sendAlert(pw, "Database connection failed. Please contact administrator.", "login.jsp");
            return;
        }

        try {
            switch (role.trim().toLowerCase()) {

                // ── Admin / Cloud Server ──────────────────────────────
                case "admin": {
                    String sql = "select name from cloudserver where email=? and password=?";
                    try (PreparedStatement ps = con.prepareStatement(sql)) {
                        ps.setString(1, email);
                        ps.setString(2, com.dao.AESCrypto.hashPassword(password));
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
                                valid = true;
                                name = rs.getString("name");
                                session.setAttribute("csemail", email);
                                session.setAttribute("csname", name);
                                redirect = "CSHome.jsp";
                            }
                        }
                    }
                    break;
                }

                // ── Data Owner ────────────────────────────────────────
                case "dataowner": {
                    // Only Approved accounts can login
                    String sql = "select name from doregister where email=? and password=? and status1='Approved'";
                    try (PreparedStatement ps = con.prepareStatement(sql)) {
                        ps.setString(1, email);
                        ps.setString(2, com.dao.AESCrypto.hashPassword(password));
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
                                valid = true;
                                name = rs.getString("name");
                                session.setAttribute("email", email);
                                session.setAttribute("name", name);
                                redirect = "DOHome.jsp";
                            }
                        }
                    }
                    break;
                }

                // ── Data Consumer ─────────────────────────────────────
                case "dataconsumer": {
                    // Only Approved accounts can login
                    String sql = "select name from dcregister where email=? and password=? and status='Approved'";
                    try (PreparedStatement ps = con.prepareStatement(sql)) {
                        ps.setString(1, email);
                        ps.setString(2, com.dao.AESCrypto.hashPassword(password));
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
                                valid = true;
                                name = rs.getString("name");
                                session.setAttribute("dcemail", email);
                                session.setAttribute("dcname", name);
                                redirect = "DCHome.jsp";
                            }
                        }
                    }
                    break;
                }

                // ── Private Key Generator ─────────────────────────────
                case "pkg": {
                    String sql = "select name from pkg where email=? and password=?";
                    try (PreparedStatement ps = con.prepareStatement(sql)) {
                        ps.setString(1, email);
                        ps.setString(2, com.dao.AESCrypto.hashPassword(password));
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
                                valid = true;
                                name = rs.getString("name");
                                session.setAttribute("pkgemail", email);
                                session.setAttribute("pkgname", name);
                                redirect = "PKGHome.jsp";
                            }
                        }
                    }
                    break;
                }

                default: {
                    sendAlert(pw, "Invalid role selected.", "login.jsp");
                    return;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            sendAlert(pw, "Database error: " + e.getMessage(), "login.jsp");
            return;
        } finally {
            try { con.close(); } catch (SQLException ignored) {}
        }

        if (valid) {
            session.setAttribute("role", role);
            response.sendRedirect(redirect);
        } else {
            sendAlert(pw, "Invalid credentials or account not yet approved by Admin.", "login.jsp");
        }
    }

    // ── Helper ────────────────────────────────────────────────────
    private void sendAlert(PrintWriter pw, String msg, String page) {
        pw.println("<script type=\"text/javascript\">");
        pw.println("alert('" + msg + "');");
        pw.println("window.location='" + page + "';");
        pw.println("</script>");
    }
}
