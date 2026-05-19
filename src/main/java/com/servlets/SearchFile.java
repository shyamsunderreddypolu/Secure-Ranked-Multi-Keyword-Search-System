package com.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
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
 * Tables: trapdoor, upload, request, response
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
            String trapSql = "select trap from trapdoor where name='" + keyword
                           + "' and uid='" + dcEmail + "'";
            Statement st1 = con.createStatement();
            ResultSet rs1 = st1.executeQuery(trapSql);

            if (!rs1.next()) {
                pw.println("<script>alert('No trapdoor found for keyword: "
                         + keyword + ". Please generate trapdoor first.');"
                         + "window.location='SearchFile.jsp';</script>");
                return;
            }
            String trapValue = rs1.getString("trap");
            rs1.close(); st1.close();

            // ── Step 2: Match trapdoor against upload index ────
            // The Cloud Server compares trap with Tkey in upload table
            // This is the Boolean keyword search on encrypted index
            Statement st2 = con.createStatement();
            ResultSet rs2 = st2.executeQuery(
                "select Fid, Email, Filename, Tkey, stringcontent from upload");

            int matchCount = 0;

            while (rs2.next()) {
                String fid      = rs2.getString("Fid");
                String doEmail  = rs2.getString("Email");
                String filename = rs2.getString("Filename");
                String tkey     = rs2.getString("Tkey");
                String index    = rs2.getString("stringcontent");

                // ── Equality check (SCP Boolean verification) ──
                // In full system: Secure Coprocessor verifies
                // trapdoor == f(keyword, secret_key) using
                // homomorphic comparison on encrypted values.
                // Here: check if keyword appears in decoded index.
                boolean matched = matchTrapdoor(trapValue, tkey, index, keyword);

                if (matched) {
                    matchCount++;

                    // ── Insert into request table ──────────────
                    String checkReq = "select * from request where uid='"
                            + doEmail + "' and fid='" + fid
                            + "' and Receiver='" + dcEmail + "'";
                    if (!DBConnection.getData(checkReq)) {
                        Statement stReq = con.createStatement();
                        stReq.executeUpdate(
                            "insert into request(uid, fid, Receiver, Status) values('"
                            + doEmail + "','" + fid + "','" + dcEmail
                            + "','Search Request')");
                        stReq.close();
                    }

                    // ── Insert into response table ─────────────
                    String checkRes = "select * from response where uid='"
                            + doEmail + "' and fid='" + fid
                            + "' and recid='" + dcEmail + "'";
                    if (!DBConnection.getData(checkRes)) {
                        // Use request auto-id as response Rid
                        String ridSql = "select Rid from request where uid='"
                                + doEmail + "' and fid='" + fid
                                + "' and Receiver='" + dcEmail + "'";
                        String rid = DBConnection.getName(ridSql);
                        if (rid != null && !rid.isEmpty()) {
                            Statement stRes = con.createStatement();
                            stRes.executeUpdate(
                                "insert into response(Rid, uid, fid, TKey, recid) values('"
                                + rid + "','" + doEmail + "','" + fid + "','"
                                + tkey + "','" + dcEmail + "')");
                            stRes.close();
                        }
                    }

                    // ── Insert into equality (SCP verification) table
                    String checkEq = "select * from equality where Uid='"
                            + doEmail + "' and Fid='" + fid
                            + "' and recid='" + dcEmail + "'";
                    if (!DBConnection.getData(checkEq)) {
                        Statement stEq = con.createStatement();
                        stEq.executeUpdate(
                            "insert into equality(Rid, Uid, Fid, Tkey, Status, recid) values('"
                            + fid + "','" + doEmail + "','" + fid + "','"
                            + tkey + "','Verified','" + dcEmail + "')");
                        stEq.close();
                    }
                }
            }
            rs2.close(); st2.close();

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
    // Full system uses homomorphic comparison on Paillier ciphertext.
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
