package com.servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dao.DBConnection;
import java.sql.*;

/**
 * ApproveDO
 * ─────────────────────────────────────────────────────────────
 * Phase 7 — Admin / Cloud Server Module
 * Project: SecureRank-Cloud-Dynamic-Multi-Keyword-Search-over-Encrypted-Data
 *
 * Admin approves or rejects a Data Owner registration.
 * Updates doregister table: status1 = 'Approved' or 'Rejected'
 * After approval DO can login using their credentials.
 *
 * URL   : /ApproveDO  (GET)
 * Table : doregister (email, status1)
 * ─────────────────────────────────────────────────────────────
 */
@WebServlet("/ApproveDO")
public class ApproveDO extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public ApproveDO() { super(); }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String email  = request.getParameter("email");
        String action = request.getParameter("action"); // approve / reject

        String status = "approve".equalsIgnoreCase(action)
                      ? "Approved" : "Rejected";

        Connection con = DBConnection.connect();
        try {
            Statement st = con.createStatement();
            st.executeUpdate(
                "update doregister set status1='" + status
                + "' where email='" + email + "'");
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (con != null) con.close(); } catch (SQLException ignored) {}
        }

        response.sendRedirect("ViewDOList.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
