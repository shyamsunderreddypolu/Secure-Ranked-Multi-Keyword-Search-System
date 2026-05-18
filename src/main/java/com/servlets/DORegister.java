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
 * DORegister
 * ─────────────────────────────────────────────────────────────
 * Phase 5 — Data Owner Module
 * Project: SecureRank-Cloud-Dynamic-Multi-Keyword-Search-over-Encrypted-Data
 *
 * Handles POST registration for a new Data Owner.
 * Inserts into doregister with status1='Pending'.
 * Admin (CS) must approve before DO can login.
 *
 * URL    : /DORegister  (POST)
 * Table  : doregister (name, email, password, mobile, address, status1)
 * ─────────────────────────────────────────────────────────────
 */
@WebServlet("/DORegister")
public class DORegister extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public DORegister() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("DORegister.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        PrintWriter pw = response.getWriter();

        String name    = request.getParameter("name");
        String email   = request.getParameter("email");
        String pwd     = request.getParameter("password");
        String mobile  = request.getParameter("mobile");
        String address = request.getParameter("address");

        // Check for duplicate email
        String checkSql = "select * from doregister where email='" + email + "'";
        if (DBConnection.getData(checkSql)) {
            pw.println("<script type=\"text/javascript\">");
            pw.println("alert('Email already registered. Please login.');");
            pw.println("window.location='DORegister.jsp';</script>");
            return;
        }

        Connection con = DBConnection.connect();
        if (con == null) {
            pw.println("<script type=\"text/javascript\">");
            pw.println("alert('Database connection failed. Try again.');");
            pw.println("window.location='DORegister.jsp';</script>");
            return;
        }

        String sql = "insert into doregister(name,email,password,mobile,address,status1) "
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
                pw.println("alert('Registration successful! Wait for Admin approval.');");
                pw.println("window.location='DOLogin.jsp';</script>");
            } else {
                pw.println("<script type=\"text/javascript\">");
                pw.println("alert('Registration failed. Please try again.');");
                pw.println("window.location='DORegister.jsp';</script>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            pw.println("<script type=\"text/javascript\">");
            pw.println("alert('Database error: " + e.getMessage() + "');");
            pw.println("window.location='DORegister.jsp';</script>");
        } finally {
            try { con.close(); } catch (SQLException ignored) {}
        }
    }
}
