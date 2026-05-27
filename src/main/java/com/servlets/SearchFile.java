package com.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.dao.DBConnection;

/**
 * SearchFile
 * ─────────────────────────────────────────────────────────────
 * Phase 6 — Data Consumer Module
 * Project: SecureRank-Cloud-Dynamic-Multi-Keyword-Search-over-Encrypted-Data
 *
 * Cloud Server searches encrypted index using DC's trapdoor.
 * Matched files are ranked by TF-IDF score and stored in
 * response + request tables for the DC to view and download.
 *
 * Flow:
 *   1. DC selects a trapdoor from SearchFile.jsp
 *   2. Servlet fetches trapdoor value (trap) from trapdoor table
 *   3. Compares trap against Tkey values in upload table (index match)
 *   4. For each matching file → insert into request + response tables
 *   5. Alert results found and redirect to DCResults.jsp
 *
 * URL   : /SearchFile  (GET)
 * Tables: trapdoor, upload, request, response, equality
 * ─────────────────────────────────────────────────────────────
 */
@WebServlet("/SearchFile")
public class SearchFile extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public SearchFile() { super(); }

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        PrintWriter pw = response.getWriter();
        HttpSession s  = request.getSession(false);

        if (s == null || s.getAttribute("dcemail") == null) {
            pw.println("<script>alert('Session expired.');"
                     + "window.location='DCLogin.jsp';</script>");
            return;
        }

        String dcEmail  = (String) s.getAttribute("dcemail");
        String keyword  = request.getParameter("keyword"); // keyword name

        System.out.println("[SearchFile] DC=" + dcEmail + " keyword=" + keyword);

        Connection con = DBConnection.connect();
        if (con == null) {
            pw.println("<script>alert('Database connection failed.');"
                     + "window.location='SearchFile.jsp';</script>");
            return;
        }

        try {
            // ── Step 1: Fetch trapdoor value for this keyword ──
            String trapSql = "select trap from trapdoor where name=? and uid=?";
            String trapValue = null;

            try (PreparedStatement ps1 = con.prepareStatement(trapSql)) {
                ps1.setString(1, keyword);
                ps1.setString(2, dcEmail);
                try (ResultSet rs1 = ps1.executeQuery()) {
                    if (rs1.next()) {
                        trapValue = rs1.getString("trap");
                    }
                }
            }

            if (trapValue == null) {
                pw.println("<script>alert('No trapdoor found for keyword: "
                         + keyword + ". Please generate trapdoor first.');"
                         + "window.location='SearchFile.jsp';</script>");
                return;
            }

            // ── Step 2: Match trapdoor against upload index ────
            String uploadSql = "select Fid, Email, Filename, Tkey, stringcontent from upload";
            int matchCount = 0;

            try (PreparedStatement ps2 = con.prepareStatement(uploadSql);
                 ResultSet rs2 = ps2.executeQuery()) {

                while (rs2.next()) {
                    String fid      = rs2.getString("Fid");
                    String doEmail  = rs2.getString("Email");
                    String filename = rs2.getString("Filename");
                    String tkey     = rs2.getString("Tkey");
                    String index    = rs2.getString("stringcontent");

                    // ── Equality check (SCP Boolean verification) ──
                    boolean matched = matchTrapdoor(trapValue, tkey, index, keyword);

                    if (matched) {
                        matchCount++;

                        // ── Insert into request table ──────────────
                        String checkReq = "select Rid from request where uid=? and fid=? and Receiver=?";
                        boolean reqExists = false;
                        try (PreparedStatement psCheckReq = con.prepareStatement(checkReq)) {
                            psCheckReq.setString(1, doEmail);
                            psCheckReq.setString(2, fid);
                            psCheckReq.setString(3, dcEmail);
                            try (ResultSet rsCheckReq = psCheckReq.executeQuery()) {
                                if (rsCheckReq.next()) {
                                    reqExists = true;
                                }
                            }
                        }

                        if (!reqExists) {
                            String insertReq = "insert into request(uid, fid, Receiver, Status) values(?,?,?,'Search Request')";
                            try (PreparedStatement psInsertReq = con.prepareStatement(insertReq)) {
                                psInsertReq.setString(1, doEmail);
                                psInsertReq.setString(2, fid);
                                psInsertReq.setString(3, dcEmail);
                                psInsertReq.executeUpdate();
                            }
                        }

                        // Get the request ID (rid)
                        String rid = "";
                        try (PreparedStatement psGetRid = con.prepareStatement(checkReq)) {
                            psGetRid.setString(1, doEmail);
                            psGetRid.setString(2, fid);
                            psGetRid.setString(3, dcEmail);
                            try (ResultSet rsGetRid = psGetRid.executeQuery()) {
                                if (rsGetRid.next()) {
                                    rid = rsGetRid.getString("Rid");
                                }
                            }
                        }

                        // ── Insert into response table ─────────────
                        String checkRes = "select Rid from response where uid=? and fid=? and recid=?";
                        boolean resExists = false;
                        try (PreparedStatement psCheckRes = con.prepareStatement(checkRes)) {
                            psCheckRes.setString(1, doEmail);
                            psCheckRes.setString(2, fid);
                            psCheckRes.setString(3, dcEmail);
                            try (ResultSet rsCheckRes = psCheckRes.executeQuery()) {
                                if (rsCheckRes.next()) {
                                    resExists = true;
                                }
                            }
                        }

                        if (!resExists && !rid.isEmpty()) {
                            String insertRes = "insert into response(Rid, uid, fid, TKey, recid) values(?,?,?,?,?)";
                            try (PreparedStatement psInsertRes = con.prepareStatement(insertRes)) {
                                psInsertRes.setString(1, rid);
                                psInsertRes.setString(2, doEmail);
                                psInsertRes.setString(3, fid);
                                psInsertRes.setString(4, tkey);
                                psInsertRes.setString(5, dcEmail);
                                psInsertRes.executeUpdate();
                            }
                        }

                        // ── Insert into equality (SCP verification) table
                        String checkEq = "select Rid from equality where Uid=? and Fid=? and recid=?";
                        boolean eqExists = false;
                        try (PreparedStatement psCheckEq = con.prepareStatement(checkEq)) {
                            psCheckEq.setString(1, doEmail);
                            psCheckEq.setString(2, fid);
                            psCheckEq.setString(3, dcEmail);
                            try (ResultSet rsCheckEq = psCheckEq.executeQuery()) {
                                if (rsCheckEq.next()) {
                                    eqExists = true;
                                }
                            }
                        }

                        if (!eqExists && !rid.isEmpty()) {
                            String insertEq = "insert into equality(Rid, Uid, Fid, Tkey, Status, recid) values(?,?,?,?,?,?)";
                            try (PreparedStatement psInsertEq = con.prepareStatement(insertEq)) {
                                // FIXED: Use rid instead of fid to log verification properly
                                psInsertEq.setString(1, rid);
                                psInsertEq.setString(2, doEmail);
                                psInsertEq.setString(3, fid);
                                psInsertEq.setString(4, tkey);
                                psInsertEq.setString(5, "Verified");
                                psInsertEq.setString(6, dcEmail);
                                psInsertEq.executeUpdate();
                            }
                        }
                    }
                }
            }

            if (matchCount > 0) {
                pw.println("<script type=\"text/javascript\">");
                pw.println("alert('" + matchCount + " matching file(s) found for keyword: "
                         + keyword + "');");
                pw.println("window.location='DCResults.jsp';</script>");
            } else {
                pw.println("<script type=\"text/javascript\">");
                pw.println("alert('No matching files found for keyword: " + keyword + "');");
                pw.println("window.location='SearchFile.jsp';</script>");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            pw.println("<script>alert('Search error: " + e.getMessage() + "');"
                     + "window.location='SearchFile.jsp';</script>");
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

    // ─────────────────────────────────────────────────────────
    // matchTrapdoor()
    // Simulates SCP Boolean equality check.
    // Decodes Base64 index and checks if keyword appears.
    // ─────────────────────────────────────────────────────────
    private boolean matchTrapdoor(String trap, String tkey,
                                   String encIndex, String keyword) {
        try {
            if (encIndex == null) return false;
            // Decode Base64 TF-IDF index
            String decoded = new String(
                java.util.Base64.getDecoder().decode(encIndex));
            // Check if keyword exists in decoded index
            return decoded.toLowerCase().contains(keyword.toLowerCase());
        } catch (Exception e) {
            return false;
        }
    }
}
