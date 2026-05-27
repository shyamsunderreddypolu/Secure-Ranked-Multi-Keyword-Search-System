package com.servlets;

import java.io.IOException;
import java.io.OutputStream;
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
 * DownloadFile
 * ─────────────────────────────────────────────────────────────
 * Phase 6 — Data Consumer Module
 * Project: SecureRank-Cloud-Dynamic-Multi-Keyword-Search-over-Encrypted-Data
 *
 * Handles file download requests from Data Consumers (DC).
 *
 * Flow:
 *   1. DC clicks Download link in DCResults.jsp (DownloadFile?fid=1&uid=bob@securerank.com)
 *   2. Check if the DC has received the master key for this file (ukeys table)
 *   3. If not yet sent:
 *      - Check if a decryption key request exists in keyreq table
 *      - If no request exists → insert new request with status='Pending'
 *      - Alert DC that request has been submitted and redirect to DCResults.jsp
 *      - If request exists → alert DC of its current status ('Pending' or 'Approved')
 *   4. If key is already distributed:
 *      - Fetch file bytes (Photo) and filename from upload table
 *      - Write bytes directly to response OutputStream (triggers file download in browser)
 *
 * URL: /DownloadFile
 * Tables: ukeys, keyreq, upload
 * ─────────────────────────────────────────────────────────────
 */
@WebServlet("/DownloadFile")
public class DownloadFile extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public DownloadFile() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("dcemail") == null) {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter pw = response.getWriter();
            pw.println("<script>alert('Session expired. Please login again.');"
                     + "window.location='DCLogin.jsp';</script>");
            return;
        }

        String fid = request.getParameter("fid");
        String uid = request.getParameter("uid");

        if (fid == null || uid == null || fid.trim().isEmpty() || uid.trim().isEmpty()) {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter pw = response.getWriter();
            pw.println("<script>alert('Invalid request parameters.');"
                     + "window.location='DCResults.jsp';</script>");
            return;
        }

        Connection con = DBConnection.connect();
        if (con == null) {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter pw = response.getWriter();
            pw.println("<script>alert('Database connection failed.');"
                     + "window.location='DCResults.jsp';</script>");
            return;
        }

        try {
            // ── Step 1: Check if DC has received the master key ──
            String ukeySql = "select key1 from ukeys where fid=? and uid=?";
            String masterKey = null;
            try (PreparedStatement psUkey = con.prepareStatement(ukeySql)) {
                psUkey.setString(1, fid);
                psUkey.setString(2, uid);
                try (ResultSet rsUkey = psUkey.executeQuery()) {
                    if (rsUkey.next()) {
                        masterKey = rsUkey.getString("key1");
                    }
                }
            }

            // ── Step 2: Handle cases where the key has NOT been sent yet ──
            if (masterKey == null) {
                // Check if a request already exists in keyreq table
                String keyreqSql = "select status1 from keyreq where fid=? and uid=?";
                String status = null;
                try (PreparedStatement psReq = con.prepareStatement(keyreqSql)) {
                    psReq.setString(1, fid);
                    psReq.setString(2, uid);
                    try (ResultSet rsReq = psReq.executeQuery()) {
                        if (rsReq.next()) {
                            status = rsReq.getString("status1");
                        }
                    }
                }

                response.setContentType("text/html;charset=UTF-8");
                PrintWriter pw = response.getWriter();

                if (status == null) {
                    // No request exists yet → Insert a new pending request
                    String insertSql = "insert into keyreq(uid, fid, status1) values(?,?,?)";
                    try (PreparedStatement psInsert = con.prepareStatement(insertSql)) {
                        psInsert.setString(1, uid);
                        psInsert.setString(2, fid);
                        psInsert.setString(3, "Pending");
                        psInsert.executeUpdate();
                    }
                    pw.println("<script>alert('Decryption key is required. A request has been submitted to the Admin for approval.');"
                             + "window.location='DCResults.jsp';</script>");
                } else if ("Pending".equalsIgnoreCase(status)) {
                    // Request is pending approval
                    pw.println("<script>alert('Your decryption key request is pending Admin approval.');"
                             + "window.location='DCResults.jsp';</script>");
                } else if ("Approved".equalsIgnoreCase(status)) {
                    // Request approved but PKG hasn't sent the key yet
                    pw.println("<script>alert('Key request approved by Admin. Please wait for the PKG to distribute the key.');"
                             + "window.location='DCResults.jsp';</script>");
                } else {
                    // Request rejected or other status
                    pw.println("<script>alert('Your key request status: " + status + ". Please contact support.');"
                             + "window.location='DCResults.jsp';</script>");
                }
                return;
            }

            // ── Step 3: Key is present! Serve file download ──
            String uploadSql = "select Filename, Photo from upload where Fid=?";
            String filename = null;
            byte[] fileBytes = null;

            try (PreparedStatement psUpload = con.prepareStatement(uploadSql)) {
                psUpload.setString(1, fid);
                try (ResultSet rsUpload = psUpload.executeQuery()) {
                    if (rsUpload.next()) {
                        filename = rsUpload.getString("Filename");
                        fileBytes = rsUpload.getBytes("Photo");
                    }
                }
            }

            if (filename == null || fileBytes == null) {
                response.setContentType("text/html;charset=UTF-8");
                PrintWriter pw = response.getWriter();
                pw.println("<script>alert('File content not found or empty.');"
                         + "window.location='DCResults.jsp';</script>");
                return;
            }

            // Set dynamic content type and attachment headers to trigger browser download
            response.setContentType("application/octet-stream");
            response.setContentLength(fileBytes.length);
            response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

            // Write raw decrypted bytes directly to response stream
            try (OutputStream os = response.getOutputStream()) {
                os.write(fileBytes);
                os.flush();
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter pw = response.getWriter();
            pw.println("<script>alert('Database error during download: " + e.getMessage() + "');"
                     + "window.location='DCResults.jsp';</script>");
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
