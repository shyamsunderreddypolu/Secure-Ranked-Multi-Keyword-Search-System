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

        String sql = "select * from doregister where email='" + uid
                   + "' and password='" + pwd + "'and status1='Approved'";
        boolean b  = DBConnection.getData(sql);

        HttpSession session = request.getSession();

        if (b == true) {
            session.setAttribute("email", uid);
            sql = "select name from doregister where email='" + uid + "'";
            String name = DBConnection.getName(sql);
            session.setAttribute("name", name);
            response.sendRedirect("DOHome.jsp");
        } else {
            pw.println("<script type=\"text/javascript\">");
            pw.println("alert('Please enter valid Details');");
            pw.println("window.location='DOLogin.jsp';</script>");
        }
    }
}
