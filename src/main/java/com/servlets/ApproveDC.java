package com.servlets;

import java.io.IOException;
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
 * ApproveDC
 * ─────────────────────────────────────────────────────────────
 * Admin / Cloud Server Module
 * Project: SecureRank-Cloud-Dynamic-Multi-Keyword-Search-over-Encrypted-Data
 *
 * Admin approves or rejects a Data Consumer registration.
 * Updates dcregister table: status = 'Approved' or 'Rejected'
 * After approval DC can login and start searching files.
 *
 * URL   : /ApproveDC  (GET)
 * Table : dcregister (email, status)
 * ─────────────────────────────────────────────────────────────
 */
@WebServlet("/ApproveDC")
public class ApproveDC extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public ApproveDC() { super(); }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        javax.servlet.http.HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("csemail") == null) {
            response.sendRedirect("CloudControllerLogin.jsp");
            return;
        }

        String email  = request.getParameter("email");
        String action = request.getParameter("action"); // approve / reject

        String status = "approve".equalsIgnoreCase(action)
                      ? "Approved" : "Rejected";

        Connection con = DBConnection.connect();
        if (con != null) {
            String sql = "update dcregister set status=? where email=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, status);
                ps.setString(2, email);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                try { con.close(); } catch (SQLException ignored) {}
            }
        }

        response.sendRedirect("ViewDCList.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
