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
 * LoginServlet
 * Handles POST login for all four RBDC roles:
 *   - admin        → CSHome.jsp
 *   - dataowner    → DOHome.jsp   (must be Approved in doregister)
 *   - dataconsumer → DCHome.jsp   (must be Approved in dcregister)
 *   - pkg          → PKGHome.jsp
 *
 * Form fields expected:
 *   role, email, password
 *
 * URL: /LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public LoginServlet() {
        super();
    }

    /** GET — just redirect to login page */
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }

    /** POST — validate credentials, create session, redirect */
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter pw = response.getWriter();

        String role     = request.getParameter("role");
        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        // ── Basic validation ──────────────────────────────────────
        if (role == null || email == null || password == null
                || email.trim().isEmpty() || password.trim().isEmpty()) {
            sendAlert(pw, "Please fill in all fields.", "login.jsp");
            return;
        }

        HttpSession session = request.getSession();
        boolean valid       = false;
        String  redirect    = "login.jsp";

        switch (role.trim().toLowerCase()) {

            // ── Admin / Cloud Server ──────────────────────────────
            case "admin": {
                String sql = "select * from cloudserver where email='" + email
                           + "' and password='" + password + "'";
                valid = DBConnection.getData(sql);
                if (valid) {
                    session.setAttribute("csemail", email);
                    String name = DBConnection.getName(
                        "select name from cloudserver where email='" + email + "'");
                    session.setAttribute("csname", name);
                    redirect = "CSHome.jsp";
                }
                break;
            }

            // ── Data Owner ────────────────────────────────────────
            case "dataowner": {
                // Only Approved accounts can login (matches original DOLogin.java logic)
                String sql = "select * from doregister where email='" + email
                           + "' and password='" + password + "' and status1='Approved'";
                valid = DBConnection.getData(sql);
                if (valid) {
                    session.setAttribute("email", email);
                    String name = DBConnection.getName(
                        "select name from doregister where email='" + email + "'");
                    session.setAttribute("name", name);
                    redirect = "DOHome.jsp";
                }
                break;
            }

            // ── Data Consumer ─────────────────────────────────────
            case "dataconsumer": {
                String sql = "select * from dcregister where email='" + email
                           + "' and password='" + password + "' and status='Approved'";
                valid = DBConnection.getData(sql);
                if (valid) {
                    session.setAttribute("dcemail", email);
                    String name = DBConnection.getName(
                        "select name from dcregister where email='" + email + "'");
                    session.setAttribute("dcname", name);
                    redirect = "DCHome.jsp";
                }
                break;
            }

            // ── Private Key Generator ─────────────────────────────
            case "pkg": {
                String sql = "select * from pkg where email='" + email
                           + "' and password='" + password + "'";
                valid = DBConnection.getData(sql);
                if (valid) {
                    session.setAttribute("pkgemail", email);
                    String name = DBConnection.getName(
                        "select name from pkg where email='" + email + "'");
                    session.setAttribute("pkgname", name);
                    redirect = "PKGHome.jsp";
                }
                break;
            }

            default: {
                sendAlert(pw, "Invalid role selected.", "login.jsp");
                return;
            }
        }

        if (valid) {
            session.setAttribute("role", role);
            response.sendRedirect(redirect);
        } else {
            sendAlert(pw, "Invalid credentials or account not yet approved.", "login.jsp");
        }
    }

    // ── Helper ────────────────────────────────────────────────────
    private void sendAlert(PrintWriter pw, String msg, String page) {
        pw.println("<script type=\"text/javascript\">");
        pw.println("alert('" + msg + "');");
        pw.println("window.location='" + page + "';");
        pw.println("</script>");
    }
}
