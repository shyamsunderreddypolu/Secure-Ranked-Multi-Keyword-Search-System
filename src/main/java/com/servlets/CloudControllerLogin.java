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
 * CloudControllerLogin
 * ─────────────────────────────────────────────────────────────
 *— Admin / Cloud Server Module
 * Project: SecureRank-Cloud-Dynamic-Multi-Keyword-Search-over-Encrypted-Data
 *
 * Handles POST login for Cloud Server Admin (CS).
 * On success → session created → redirect to CSHome.jsp
 * On failure → JS alert → back to CloudControllerLogin.jsp
 *
 * URL   : /CloudControllerLogin  (POST)
 * Table : cloudserver (email, password, name)
 * ─────────────────────────────────────────────────────────────
 */
@WebServlet("/CloudControllerLogin")
public class CloudControllerLogin extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public CloudControllerLogin() { super(); }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("CloudControllerLogin.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        PrintWriter pw = response.getWriter();
        String email   = request.getParameter("email");
        String pwd     = request.getParameter("password");

        String sql = "select * from cloudserver where email='" + email
                   + "' and password='" + pwd + "'";
        boolean b  = DBConnection.getData(sql);

        HttpSession session = request.getSession();

        if (b == true) {
            session.setAttribute("csemail", email);
            String name = DBConnection.getName(
                "select name from cloudserver where email='" + email + "'");
            session.setAttribute("csname", name);
            response.sendRedirect("CSHome.jsp");
        } else {
            pw.println("<script type=\"text/javascript\">");
            pw.println("alert('Invalid credentials. Please try again.');");
            pw.println("window.location='CloudControllerLogin.jsp';</script>");
        }
    }
}
