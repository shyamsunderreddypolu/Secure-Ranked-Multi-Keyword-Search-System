package com.servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.dao.DBConnection;

/**
 * DCLogin
 * ─────────────────────────────────────────────────────────────
 * Phase 6 — Data Consumer Module
 * Project: SecureRank-Cloud-Dynamic-Multi-Keyword-Search-over-Encrypted-Data
 *
 * Handles POST login for Data Consumer (DC).
 * Only status='Approved' accounts can login.
 * On success → session created → redirect to DCHome.jsp
 * On failure → JS alert → redirect back to DCLogin.jsp
 *
 * URL   : /DCLogin  (POST)
 * Table : dcregister (email, password, status, name)
 * ─────────────────────────────────────────────────────────────
 */
@WebServlet("/DCLogin")
public class DCLogin extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public DCLogin() { super(); }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("DCLogin.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        PrintWriter pw  = response.getWriter();
        String uid      = request.getParameter("email");
        String pwd      = request.getParameter("password");

        java.sql.Connection con = DBConnection.connect();
        if (con == null) {
            pw.println("<script type=\"text/javascript\">");
            pw.println("alert('Database connection failed.');");
            pw.println("window.location='DCLogin.jsp';</script>");
            return;
        }

        boolean valid = false;
        String name   = "";

        String sql = "select name from dcregister where email=? and password=? and status='Approved'";
        try (java.sql.PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, uid);
            ps.setString(2, com.dao.AESCrypto.hashPassword(pwd));
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    valid = true;
                    name  = rs.getString("name");
                }
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        } finally {
            try { con.close(); } catch (java.sql.SQLException ignored) {}
        }

        HttpSession session = request.getSession();

        if (valid) {
            session.setAttribute("dcemail", uid);
            session.setAttribute("dcname", name);
            response.sendRedirect("DCHome.jsp");
        } else {
            pw.println("<script type=\"text/javascript\">");
            pw.println("alert('Please enter valid Details');");
            pw.println("window.location='DCLogin.jsp';</script>");
        }
    }
}
