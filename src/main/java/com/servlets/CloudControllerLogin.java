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
 * CloudControllerLogin
 * ─────────────────────────────────────────────────────────────
 *— Admin / Cloud Server Module
 * Project: SecureRank-Cloud-Dynamic-Multi-Keyword-Search-over-Encrypted-Data
 *
 * Handles POST login for Cloud Server Admin (CS).
 * On success → session created → redirect to CSHome.jsp
 * On failure → JS alert → back to CloudControllerLogin.jsp
 *
 * URL   : /CloudControllerLogin  (POST)
 * Table : cloudserver (email, password, name)
 * ─────────────────────────────────────────────────────────────
 */
@WebServlet("/CloudControllerLogin")
public class CloudControllerLogin extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public CloudControllerLogin() { super(); }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("CloudControllerLogin.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        PrintWriter pw = response.getWriter();
        String email   = request.getParameter("email");
        String pwd     = request.getParameter("password");

        Connection con = DBConnection.connect();
        if (con == null) {
            pw.println("<script type=\"text/javascript\">");
            pw.println("alert('Database connection failed.');");
            pw.println("window.location='CloudControllerLogin.jsp';</script>");
            return;
        }

        boolean valid = false;
        String name   = "";

        String sql = "select name from cloudserver where email=? and password=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, com.dao.AESCrypto.hashPassword(pwd));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    valid = true;
                    name  = rs.getString("name");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { con.close(); } catch (SQLException ignored) {}
        }

        HttpSession session = request.getSession();

        if (valid) {
            session.setAttribute("csemail", email);
            session.setAttribute("csname", name);
            response.sendRedirect("CSHome.jsp");
        } else {
            pw.println("<script type=\"text/javascript\">");
            pw.println("alert('Invalid credentials. Please try again.');");
            pw.println("window.location='CloudControllerLogin.jsp';</script>");
        }
    }
}
