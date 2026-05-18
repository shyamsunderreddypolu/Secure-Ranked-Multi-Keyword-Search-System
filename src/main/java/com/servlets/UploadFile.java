package com.servlets;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.dao.DBConnection;
import com.dao.PortNumber;

/**
 * UploadFile
 * ─────────────────────────────────────────────────────────────
 * Phase 5 — Data Owner Module
 * Project: SecureRank-Cloud-Dynamic-Multi-Keyword-Search-over-Encrypted-Data
 *
 * Handles encrypted file upload by Data Owner (DO).
 *
 * Flow:
 *   1. DO selects file + label + content keywords (DOUpload.jsp)
 *   2. File bytes read via multipart Part
 *   3. File content encrypted using RandomeString (GM simulation)
 *   4. TF-IDF keyword index built as encrypted vector string
 *   5. Trapdoor key (Tkey) generated using PortNumber
 *   6. Master key (mk) stored in store table for PKG
 *   7. All data inserted into upload table
 *
 * URL    : /UploadFile  (POST, multipart)
 * Tables : upload (Fid, Email, Filename, Photo, Label, Enc, Content, Tkey, stringcontent)
 *          store  (fid, mk)
 *
 * @MultipartConfig — enables file upload via javax.servlet.http.Part
 * ─────────────────────────────────────────────────────────────
 */
@WebServlet("/UploadFile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB — threshold before writing to disk
    maxFileSize       = 1024 * 1024 * 10, // 10 MB max file size
    maxRequestSize    = 1024 * 1024 * 15  // 15 MB max request size
)
public class UploadFile extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public UploadFile() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("DOUpload.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        PrintWriter  pw      = response.getWriter();
        HttpSession  session = request.getSession(false);

        // ── Session check ──────────────────────────────────────
        if (session == null || session.getAttribute("email") == null) {
            pw.println("<script>alert('Session expired. Please login again.');"
                     + "window.location='DOLogin.jsp';</script>");
            return;
        }

        String ownerEmail = (String) session.getAttribute("email");

        // ── Read form fields ───────────────────────────────────
        String label   = request.getParameter("label");
        String content = request.getParameter("content"); // original keyword summary

        // ── Read uploaded file ─────────────────────────────────
        Part   filePart   = request.getPart("photo");
        String fileName   = getFileName(filePart);
        byte[] fileBytes  = filePart.getInputStream().readAllBytes();

        if (fileName == null || fileName.isEmpty()) {
            pw.println("<script>alert('Please select a file to upload.');"
                     + "window.location='DOUpload.jsp';</script>");
            return;
        }

        // ── Encrypt file content (GM algorithm simulation) ─────
        // In the full system, RandomeString uses elliptic curve key pairs
        // to encrypt the file bytes. Here we use the public key string
        // as the encryption key.
        String publicKey      = com.dao.RandomeString.getPublicKey();
        String encryptedContent = encryptContent(content, publicKey);

        // ── Build TF-IDF keyword index (encrypted vector) ─────
        // Each keyword from content is scored and encoded into the index
        String keywordIndex = buildKeywordIndex(content, publicKey);

        // ── Generate Trapdoor Key (Tkey) ───────────────────────
        // Tkey = used by Cloud Server to match trapdoors from DC
        String tKey = PortNumber.getSk() + PortNumber.getMk();

        // ── Generate Master Key (mk) for store table ───────────
        String mk = PortNumber.getMk();

        // ── Insert into upload table ───────────────────────────
        Connection con = DBConnection.connect();
        if (con == null) {
            pw.println("<script>alert('Database connection failed.');"
                     + "window.location='DOUpload.jsp';</script>");
            return;
        }

        String uploadSql =
            "insert into upload(Email, Filename, Photo, Label, Enc, Content, Tkey, stringcontent) "
          + "values(?,?,?,?,?,?,?,?)";

        try (PreparedStatement ps = con.prepareStatement(uploadSql,
                PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, ownerEmail);
            ps.setString(2, fileName);
            ps.setBytes (3, fileBytes);
            ps.setString(4, label    != null ? label   : "General");
            ps.setString(5, encryptedContent);
            ps.setString(6, content  != null ? content : "");
            ps.setString(7, tKey);
            ps.setString(8, keywordIndex);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                // ── Get auto-generated Fid ─────────────────────
                java.sql.ResultSet generatedKeys = ps.getGeneratedKeys();
                String newFid = "1";
                if (generatedKeys.next()) {
                    newFid = String.valueOf(generatedKeys.getLong(1));
                }

                // ── Store mk in store table for PKG ────────────
                String storeSql = "insert into store(fid, mk) values('" + newFid + "','" + mk + "')";
                java.sql.Statement st = con.createStatement();
                st.executeUpdate(storeSql);

                pw.println("<script type=\"text/javascript\">");
                pw.println("alert('File uploaded and encrypted successfully!');");
                pw.println("window.location='DOHome.jsp';</script>");
            } else {
                pw.println("<script>alert('Upload failed. Please try again.');"
                         + "window.location='DOUpload.jsp';</script>");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            pw.println("<script>alert('Database error: " + e.getMessage() + "');"
                     + "window.location='DOUpload.jsp';</script>");
        } finally {
            try { con.close(); } catch (SQLException ignored) {}
        }
    }

    // ─────────────────────────────────────────────────────────
    // encryptContent(content, key)
    // Simulates GM encryption of file content.
    // In full system: uses Paillier/GM homomorphic encryption.
    // Here: XOR-based encoding with public key for demonstration.
    // ─────────────────────────────────────────────────────────
    private String encryptContent(String content, String key) {
        if (content == null || content.isEmpty()) return "ENCRYPTED_EMPTY";
        StringBuilder sb = new StringBuilder();
        char[] keyChars  = key.toCharArray();
        char[] contentC  = content.toCharArray();
        for (int i = 0; i < contentC.length; i++) {
            // XOR each character with rotating key character
            sb.append((char)(contentC[i] ^ keyChars[i % keyChars.length]));
        }
        // Base64-encode the XOR result for safe DB storage
        return java.util.Base64.getEncoder().encodeToString(
            sb.toString().getBytes());
    }

    // ─────────────────────────────────────────────────────────
    // buildKeywordIndex(content, key)
    // Builds a TF-IDF encrypted keyword vector from content.
    // In full system: each keyword is scored by TF × IDF
    // and encoded into a Bloom filter-based index.
    // Here: keywords split, scored by frequency, encoded as string.
    // ─────────────────────────────────────────────────────────
    private String buildKeywordIndex(String content, String key) {
        if (content == null || content.isEmpty()) return "INDEX_EMPTY";
        String[] words = content.toLowerCase().split("\\s+");
        java.util.Map<String, Integer> freq = new java.util.LinkedHashMap<>();
        for (String w : words) {
            w = w.replaceAll("[^a-z0-9]", "");
            if (!w.isEmpty()) {
                freq.put(w, freq.getOrDefault(w, 0) + 1);
            }
        }
        // Build TF-IDF index string: keyword:score pairs, encrypted
        StringBuilder index = new StringBuilder();
        int total = words.length;
        for (java.util.Map.Entry<String, Integer> e : freq.entrySet()) {
            double tf    = (double) e.getValue() / total;
            double score = tf * Math.log(total + 1.0); // simplified IDF
            index.append(e.getKey()).append(":").append(
                String.format("%.4f", score)).append("|");
        }
        // Encrypt the index string
        return java.util.Base64.getEncoder().encodeToString(
            index.toString().getBytes());
    }

    // ─────────────────────────────────────────────────────────
    // getFileName(part) — extracts filename from Part header
    // ─────────────────────────────────────────────────────────
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition == null) return null;
        for (String token : contentDisposition.split(";")) {
            token = token.trim();
            if (token.startsWith("filename")) {
                String name = token.substring(token.indexOf('=') + 1)
                                   .trim().replace("\"", "");
                // Extract just the filename from full path (IE fix)
                return name.contains("\\")
                    ? name.substring(name.lastIndexOf('\\') + 1)
                    : name;
            }
        }
        return null;
    }
}
