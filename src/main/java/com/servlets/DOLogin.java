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
 * DOLogin
 * ─────────────────────────────────────────────────────────────
 * Phase 5 — Data Owner Module
 * Project: SecureRank-Cloud-Dynamic-Multi-Keyword-Search-over-Encrypted-Data
 *
 * Handles POST login for Data Owner (DO).
 * Checks doregister table — only status1='Approved' can login.
 * On success → creates session and redirects to DOHome.jsp
 * On failure → JS alert and redirect back to DOLogin.jsp
 *
 * URL    : /DOLogin  (POST)
 * Table  : doregister (email, password, status1, name)
 * ─────────────────────────────────────────────────────────────
 */
@WebServlet("/DOLogin")
public class DOLogin extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public DOLogin() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("DOLogin.jsp");
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
            pw.println("window.location='DOLogin.jsp';</script>");
            return;
        }

        boolean valid = false;
        String name   = "";

        String sql = "select name from doregister where email=? and password=? and status1='Approved'";
        try (java.sql.PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, uid);
            ps.setString(2, pwd);
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
            session.setAttribute("email", uid);
            session.setAttribute("name", name);
            response.sendRedirect("DOHome.jsp");
        } else {
            pw.println("<script type=\"text/javascript\">");
            pw.println("alert('Please enter valid Details');");
            pw.println("window.location='DOLogin.jsp';</script>");
        }
    }
}
