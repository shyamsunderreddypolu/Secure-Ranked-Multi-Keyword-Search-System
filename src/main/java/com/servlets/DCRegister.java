package com.servlets;

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

import com.dao.DBConnection;

/**
 * DCRegister
 * ─────────────────────────────────────────────────────────────
 * Phase 6 — Data Consumer Module
 * Project: SecureRank-Cloud-Dynamic-Multi-Keyword-Search-over-Encrypted-Data
 *
 * Handles POST registration for new Data Consumer.
 * Inserts into dcregister with status='Pending'.
 * Admin (CS) must approve before DC can login.
 *
 * URL   : /DCRegister  (POST)
 * Table : dcregister (name, email, password, mobile, address, status)
 * ─────────────────────────────────────────────────────────────
 */
@WebServlet("/DCRegister")
public class DCRegister extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public DCRegister() { super(); }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("DCRegister.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        PrintWriter pw  = response.getWriter();
        String name     = request.getParameter("name");
        String email    = request.getParameter("email");
        String pwd      = request.getParameter("password");
        String mobile   = request.getParameter("mobile");
        String address  = request.getParameter("address");

        // Check duplicate email
        if (DBConnection.getData(
                "select * from dcregister where email='" + email + "'")) {
            pw.println("<script type=\"text/javascript\">");
            pw.println("alert('Email already registered. Please login.');");
            pw.println("window.location='DCRegister.jsp';</script>");
            return;
        }

        Connection con = DBConnection.connect();
        if (con == null) {
            pw.println("<script>alert('Database connection failed.');"
                     + "window.location='DCRegister.jsp';</script>");
            return;
        }

        String sql = "insert into dcregister(name,email,password,mobile,address,status) "
                   + "values(?,?,?,?,?,'Pending')";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, pwd);
            ps.setString(4, mobile  != null ? mobile  : "");
            ps.setString(5, address != null ? address : "");
            int i = ps.executeUpdate();
            if (i > 0) {
                pw.println("<script type=\"text/javascript\">");
                pw.println("alert('Registration Successful! Wait for Admin approval.');");
                pw.println("window.location='DCLogin.jsp';</script>");
            } else {
                pw.println("<script>alert('Registration failed. Try again.');"
                         + "window.location='DCRegister.jsp';</script>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            pw.println("<script>alert('Database error: " + e.getMessage() + "');"
                     + "window.location='DCRegister.jsp';</script>");
        } finally {
            try { con.close(); } catch (SQLException ignored) {}
        }
    }
}
