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
import javax.servlet.http.HttpSession;

import com.dao.DBConnection;
import com.dao.RandomeString;


/**
 * GenerateTrapdoor
 * ─────────────────────────────────────────────────────────────
 * Phase 6 — Data Consumer Module
 * Project: SecureRank-Cloud-Dynamic-Multi-Keyword-Search-over-Encrypted-Data
 *
 * DC generates an encrypted trapdoor for a search keyword.
 * The trapdoor is sent to the Cloud Server for index matching
 * without revealing the actual keyword (Boolean search).
 *
 * Flow:
 *   1. DC enters keyword in GenerateTrapdoor.jsp
 *   2. Servlet encrypts keyword using RandomeString.getPublicKey()
 *      (simulates elliptic curve / GM-based trapdoor generation)
 *   3. Trapdoor inserted into trapdoor table (name, uid, trap)
 *   4. Alert success and redirect back
 *
 * URL   : /GenerateTrapdoor  (POST)
 * Table : trapdoor (name, uid, trap)
 * ─────────────────────────────────────────────────────────────
 */
@WebServlet("/GenerateTrapdoor")
public class GenerateTrapdoor extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public GenerateTrapdoor() { super(); }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("GenerateTrapdoor.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        PrintWriter pw   = response.getWriter();
        HttpSession s    = request.getSession(false);

        if (s == null || s.getAttribute("dcemail") == null) {
            pw.println("<script>alert('Session expired.');"
                     + "window.location='DCLogin.jsp';</script>");
            return;
        }

        String uid     = (String) s.getAttribute("dcemail");
        String keyword = request.getParameter("keyword");

        if (keyword == null || keyword.trim().isEmpty()) {
            pw.println("<script>alert('Please enter a keyword.');"
                     + "window.location='GenerateTrapdoor.jsp';</script>");
            return;
        }

        keyword = keyword.trim().toLowerCase();

        // ── Generate trapdoor using public key (GM simulation) ─
        // In full system: uses elliptic curve private key to
        // produce an encrypted token that matches the index
        // without revealing the keyword to the cloud server.
        String publicKey = RandomeString.getPublicKey();
        String trapdoor  = generateTrapdoor(keyword, publicKey);

        // ── Check database connection ──────────────────────────
        Connection con = DBConnection.connect();
        if (con == null) {
            pw.println("<script>alert('Database connection failed.');"
                     + "window.location='GenerateTrapdoor.jsp';</script>");
            return;
        }

        boolean exists = false;
        String checkSql = "select id from trapdoor where name=? and uid=?";
        try (PreparedStatement psCheck = con.prepareStatement(checkSql)) {
            psCheck.setString(1, keyword);
            psCheck.setString(2, uid);
            try (java.sql.ResultSet rs = psCheck.executeQuery()) {
                if (rs.next()) {
                    exists = true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (exists) {
            try { con.close(); } catch (SQLException ignored) {}
            pw.println("<script type=\"text/javascript\">");
            pw.println("alert('Trapdoor already generated for keyword: " + keyword + "');");
            pw.println("window.location='GenerateTrapdoor.jsp';</script>");
            return;
        }

        // ── Insert trapdoor into DB ────────────────────────────
        String sql = "insert into trapdoor(name, uid, trap) values(?,?,?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, keyword);
            ps.setString(2, uid);
            ps.setString(3, trapdoor);
            int i = ps.executeUpdate();
            if (i > 0) {
                pw.println("<script type=\"text/javascript\">");
                pw.println("alert('Trapdoor generated successfully for keyword: " + keyword + "');");
                pw.println("window.location='GenerateTrapdoor.jsp';</script>");
            } else {
                pw.println("<script>alert('Trapdoor generation failed.');"
                         + "window.location='GenerateTrapdoor.jsp';</script>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            pw.println("<script>alert('Database error: " + e.getMessage() + "');"
                     + "window.location='GenerateTrapdoor.jsp';</script>");
        } finally {
            try { con.close(); } catch (SQLException ignored) {}
        }
    }

    // ─────────────────────────────────────────────────────────
    // generateTrapdoor(keyword, key)
    // Simulates GM/Paillier trapdoor generation.
    // XOR-encodes keyword with public key, then Base64-encodes.
    // In full system: uses elliptic curve private key operations.
    // ─────────────────────────────────────────────────────────
    private String generateTrapdoor(String keyword, String key) {
        StringBuilder sb = new StringBuilder();
        char[] kc = key.toCharArray();
        char[] wc = keyword.toCharArray();
        for (int i = 0; i < wc.length; i++) {
            sb.append((char)(wc[i] ^ kc[i % kc.length]));
        }
        return java.util.Base64.getEncoder()
                               .encodeToString(sb.toString().getBytes());
    }
}
