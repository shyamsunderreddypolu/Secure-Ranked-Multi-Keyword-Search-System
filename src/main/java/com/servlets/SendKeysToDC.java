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

/**
 * SendKeysToDC
 * ─────────────────────────────────────────────────────────────
 * PKG Module — Sends Master Key (mk) to a Data Consumer.
 * Project: SecureRank-Cloud-Dynamic-Multi-Keyword-Search-over-Encrypted-Data
 *
 * Flow:
 *   1. PKG picks a file + DC from SendKeysToDC.jsp
 *   2. Check if DC already received mk for this file (ukeys table)
 *   3. If not → fetch mk from store table using PreparedStatement
 *   4. Insert into ukeys using PreparedStatement
 *   5. Alert success and redirect
 *
 * URL    : /SendKeysToDC  (GET)
 * Tables : store (id, fid, mk)
 *          ukeys (fid, doid, uid, key1)
 * ─────────────────────────────────────────────────────────────
 */
@WebServlet("/SendKeysToDC")
public class SendKeysToDC extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public SendKeysToDC() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        PrintWriter o = response.getWriter();
        javax.servlet.http.HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("pkgemail") == null) {
            o.println("<script>alert('Session expired or access denied.');"
                     + "window.location='login.jsp';</script>");
            return;
        }

        String fid  = request.getParameter("fid");
        String uid  = request.getParameter("uid");
        String doid = request.getParameter("doid");

        System.out.println("[SendKeysToDC] fid=" + fid + " uid=" + uid + " doid=" + doid);

        Connection con = DBConnection.connect();
        if (con == null) {
            o.println("<script type=\"text/javascript\">");
            o.println("alert('Database connection failed.');");
            o.println("window.location='SendKeysToDC.jsp';</script>");
            return;
        }

        try {
            // ── Check if DC already received mk for this file ─────
            String checkSql = "select fid from ukeys where fid=? and uid=?";
            boolean keySent = false;
            try (PreparedStatement psCheck = con.prepareStatement(checkSql)) {
                psCheck.setString(1, fid);
                psCheck.setString(2, uid);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) {
                        keySent = true;
                    }
                }
            }

            if (keySent) {
                o.println("<script type=\"text/javascript\">");
                o.println("alert('DC Already Received MK Keys');");
                o.println("window.location='SendKeysToDC.jsp';</script>");
            } else {
                // ── Fetch master key from store table ─────────────
                String storeSql = "select mk from store where fid=?";
                String key1 = "";
                try (PreparedStatement psStore = con.prepareStatement(storeSql)) {
                    psStore.setString(1, fid);
                    try (ResultSet rs = psStore.executeQuery()) {
                        if (rs.next()) {
                            key1 = rs.getString("mk");
                        }
                    }
                }

                if (key1 == null || key1.isEmpty()) {
                    o.println("<script type=\"text/javascript\">");
                    o.println("alert('Master key not found in store table for this file.');");
                    o.println("window.location='SendKeysToDC.jsp';</script>");
                    return;
                }

                // ── Insert into ukeys ──────────────
                String insertSql = "insert into ukeys(fid, doid, uid, key1) values(?,?,?,?)";
                int rows = 0;
                try (PreparedStatement psInsert = con.prepareStatement(insertSql)) {
                    psInsert.setString(1, fid);
                    psInsert.setString(2, doid);
                    psInsert.setString(3, uid);
                    psInsert.setString(4, key1);
                    rows = psInsert.executeUpdate();
                }

                if (rows > 0) {
                    o.println("<script type=\"text/javascript\">");
                    o.println("alert('MK Keys are sent to DC successfully');");
                    o.println("window.location='SendKeysToDC.jsp';</script>");
                } else {
                    o.println("<script type=\"text/javascript\">");
                    o.println("alert('MK Keys are not sent to DC');");
                    o.println("window.location='SendKeysToDC.jsp';</script>");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            o.println("<script type=\"text/javascript\">");
            o.println("alert('Database error: " + e.getMessage() + "');");
            o.println("window.location='SendKeysToDC.jsp';</script>");
        } finally {
            try { con.close(); } catch (SQLException ignored) {}
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        // Not used
    }
}
