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
 * DCDecryptRequest
 * ─────────────────────────────────────────────────────────────
 * Phase 6 — Data Consumer Module
 * Project: SecureRank-Cloud-Dynamic-Multi-Keyword-Search-over-Encrypted-Data
 *
 * Called by Admin (CS) when they approve a DC's decryption request.
 * Updates keyreq table: status1='Approved' for the given DC email.
 * After approval DC can access the master key and decrypt the file.
 *
 * Flow:
 *   1. DC submits decryption key request → inserted into keyreq
 *   2. Admin views pending requests in DCDecryptRequest.jsp
 *   3. Admin clicks Approve → this servlet updates status1='Approved'
 *   4. DC can now fetch master key from ukeys and decrypt file
 *
 * URL   : /DCDecryptRequest  (GET)
 * Table : keyreq (uid, fid, status1)
 * ─────────────────────────────────────────────────────────────
 */
@WebServlet("/DCDecryptRequest")
public class DCDecryptRequest extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public DCDecryptRequest() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("uid");
        String fid   = request.getParameter("fid");

        if (email != null && fid != null) {
            Connection con = DBConnection.connect();
            if (con != null) {
                String sql = "update keyreq set status1='Approved' where uid=? and fid=?";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, email);
                    ps.setString(2, fid);
                    ps.executeUpdate();
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    try { con.close(); } catch (SQLException ignored) {}
                }
            }
        }
        response.sendRedirect("DCDecryptRequest.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        // Not used
    }
}
