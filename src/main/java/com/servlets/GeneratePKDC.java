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

import com.dao.DBConnection;
import com.dao.PortNumber;

/**
 * GeneratePKDC
 * ─────────────────────────────────────────────────────────────
 * PKG Module — Servlet 1 of 2
 * Project: SecureRank-Cloud-Dynamic-Multi-Keyword-Search-over-Encrypted-Data
 *
 * Purpose:
 *   PKG generates a Secret Key (sk) for a specific Data Consumer (DC).
 *   The sk is stored in the `keygen` table linked to the DC's email.
 *   DC will later use this sk to generate trapdoors for encrypted search.
 *
 * Flow:
 *   1. PKG selects a DC email from the list (GeneratePKDC.jsp)
 *   2. Servlet checks if key already exists for that DC
 *   3. If not → generate sk using PortNumber.getSk()
 *   4. Insert into keygen table (sk, uid=dc_email)
 *   5. Alert success and redirect back
 *
 * URL     : /GeneratePKDC  (GET)
 * Table   : keygen (sk, mk, uid)
 * ─────────────────────────────────────────────────────────────
 */
@WebServlet("/GeneratePKDC")
public class GeneratePKDC extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public GeneratePKDC() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        PrintWriter  pw      = response.getWriter();
        String uid = request.getParameter("email");

        // Generate a new secret key for this DC
        String sk = PortNumber.getSk();
        String mk = PortNumber.getMk();

        System.out.println("[GeneratePKDC] Generating key for DC: " + uid);

        Connection con = DBConnection.connect();
        if (con == null) {
            pw.println("<script type=\"text/javascript\">");
            pw.println("alert('Database connection failed.');");
            pw.println("window.location='GeneratePKDC.jsp';</script>");
            return;
        }

        try {
            // Check if key already generated for this DC
            String checkSql = "select id from keygen where uid=?";
            boolean exists = false;
            try (PreparedStatement psCheck = con.prepareStatement(checkSql)) {
                psCheck.setString(1, uid);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) {
                        exists = true;
                    }
                }
            }

            if (exists) {
                pw.println("<script type=\"text/javascript\">");
                pw.println("alert('Key already generated for DC: " + uid + "');");
                pw.println("window.location='GeneratePKDC.jsp';</script>");
            } else {
                // Insert new key into keygen table
                String insertSql = "insert into keygen(sk, mk, uid) values(?,?,?)";
                int rows = 0;
                try (PreparedStatement psInsert = con.prepareStatement(insertSql)) {
                    psInsert.setString(1, sk);
                    psInsert.setString(2, mk);
                    psInsert.setString(3, uid);
                    rows = psInsert.executeUpdate();
                }

                if (rows > 0) {
                    pw.println("<script type=\"text/javascript\">");
                    pw.println("alert('Secret Key generated for DC (" + uid + ") successfully!');");
                    pw.println("window.location='GeneratePKDC.jsp';</script>");
                } else {
                    pw.println("<script type=\"text/javascript\">");
                    pw.println("alert('Key generation failed. Please try again.');");
                    pw.println("window.location='GeneratePKDC.jsp';</script>");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            pw.println("<script type=\"text/javascript\">");
            pw.println("alert('Database error: " + e.getMessage() + "');");
            pw.println("window.location='GeneratePKDC.jsp';</script>");
        } finally {
            try { con.close(); } catch (SQLException ignored) {}
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
