package com.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.beans.UserKeyBean;
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
 *   3. If not → fetch mk from store table using getDOKeys()
 *   4. Insert into ukeys using sendKeys()
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

        String fid  = request.getParameter("fid");
        String uid  = request.getParameter("uid");
        String doid = request.getParameter("doid");

        System.out.println("fffffff" + uid);

        // ── Check if DC already received mk for this file ─────
        String sql = "select * from ukeys where fid='" + fid
                   + "' and uid='" + uid + "'";
        boolean b = DBConnection.getData(sql);

        if (b == true) {
            o.println("<script type=\"text/javascript\">");
            o.println("alert('DC Already Recieved MK Keys');");
            o.println("window.location='SendKeysToDC.jsp';</script>");
        } else {
            // ── Fetch master key from store table ─────────────
            sql = "select * from store where fid='" + fid + "'";
            String key1 = "";
            List<String> lt = DBConnection.getDOKeys(sql);
            Iterator<String> itr = lt.iterator();
            while (itr.hasNext()) {
                key1 = itr.next();
            }

            // ── Build bean and insert into ukeys ──────────────
            UserKeyBean kb = new UserKeyBean();
            kb.setFid(fid);
            kb.setDoid(doid);
            kb.setUid(uid);
            kb.setKey1(key1);

            sql = "insert into ukeys values(?,?,?,?)";
            int i = DBConnection.sendKeys(sql, kb);

            if (i > 0) {
                o.println("<script type=\"text/javascript\">");
                o.println("alert('MK Keys are sent to DC successfully');");
                o.println("window.location='SendKeysToDC.jsp';</script>");
            } else {
                o.println("<script type=\"text/javascript\">");
                o.println("alert('MK Keys are not sent to DC');");
                o.println("window.location='SendKeysToDC.jsp';</script>");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        // Not used
    }
}
