<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession, java.sql.*" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("csemail") == null) {
        response.sendRedirect("CloudControllerLogin.jsp");
        return;
    }
    Connection con = com.dao.DBConnection.connect();
    ResultSet  rs  = null;
    Statement  st  = null;
    try {
        st = con.createStatement();
        rs = st.executeQuery(
            "select k.id, k.uid, k.fid, k.status1, d.name "
          + "from keyreq k "
          + "left join dcregister d on k.uid = d.email "
          + "order by k.id desc");
    } catch (Exception e) {
        try {
            rs = con.createStatement().executeQuery(
                "select id, uid, fid, status1 from keyreq order by id desc");
        } catch (Exception ex) { ex.printStackTrace(); }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Decrypt Requests — SecureRank Admin</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
    :root {
      --red-mid:#B91C1C; --red-bg:#FEEAEA;
      --teal-mid:#0F6E56; --teal-bg:#E1F5EE;
      --amber-bg:#FAEEDA; --amber-mid:#854F0B;
      --text-main:#1A1A18; --text-muted:#5F5E5A; --text-faint:#A0A09A;
      --border:rgba(0,0,0,0.09); --white:#fff; --gray-bg:#F7F6F3;
      --radius-md:10px; --radius-lg:14px;
    }
    body { font-family:'DM Sans',sans-serif; background:var(--gray-bg); }
    nav  { background:var(--white); border-bottom:1px solid var(--border); padding:0 32px; height:60px; display:flex; align-items:center; justify-content:space-between; }
    .nav-title { font-size:15px; font-weight:600; }
    .nav-sub   { font-size:11px; color:var(--text-muted); font-family:'DM Mono',monospace; }
    .btn-back  { font-size:12px; padding:6px 14px; background:var(--gray-bg); border:1px solid var(--border); border-radius:var(--radius-md); text-decoration:none; color:var(--text-muted); }
    .btn-back:hover { border-color:var(--red-mid); color:var(--red-mid); }
    .page-wrap { max-width:900px; margin:32px auto; padding:0 24px; }
    .page-header { margin-bottom:20px; }
    .page-header h2 { font-size:20px; font-weight:600; }
    .page-header p  { font-size:13px; color:var(--text-muted); margin-top:4px; }
    .table-card { background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); overflow:hidden; }
    .table-top  { padding:16px 20px; border-bottom:1px solid var(--border); display:flex; justify-content:space-between; align-items:center; }
    .table-top-title { font-size:14px; font-weight:600; }
    .table-top-sub   { font-size:12px; color:var(--text-muted); font-family:'DM Mono',monospace; }
    table { width:100%; border-collapse:collapse; }
    thead th { padding:10px 14px; text-align:left; font-size:11px; font-weight:500; color:var(--text-faint); text-transform:uppercase; background:var(--gray-bg); border-bottom:1px solid var(--border); letter-spacing:0.05em; }
    tbody tr { border-bottom:1px solid var(--border); transition:background 0.12s; }
    tbody tr:last-child { border-bottom:none; }
    tbody tr:hover { background:#FAFAF8; }
    tbody td { padding:12px 14px; font-size:13px; vertical-align:middle; }
    .mono { font-family:'DM Mono',monospace; font-size:11px; color:var(--text-muted); }
    .status-approved { display:inline-block; font-size:11px; padding:3px 9px; border-radius:999px; background:var(--teal-bg);  color:var(--teal-mid);  font-weight:500; }
    .status-pending  { display:inline-block; font-size:11px; padding:3px 9px; border-radius:999px; background:var(--amber-bg); color:var(--amber-mid); font-weight:500; }
    .btn-approve { font-size:11px; font-weight:500; padding:5px 14px; background:var(--teal-mid); color:#fff; border:none; border-radius:var(--radius-md); text-decoration:none; }
    .empty-row td { text-align:center; padding:40px; color:var(--text-faint); }
  </style>
</head>
<body>
<nav>
  <div>
    <div class="nav-title">DC Decrypt Requests</div>
    <div class="nav-sub">Admin · SecureRank</div>
  </div>
  <a href="CSHome.jsp" class="btn-back">← Dashboard</a>
</nav>
<div class="page-wrap">
  <div class="page-header">
    <h2>Data Consumer Decrypt Requests</h2>
    <p>Approve requests from Data Consumers to access master keys for decrypting matched files.</p>
  </div>
  <div class="table-card">
    <div class="table-top">
      <div class="table-top-title">Key Access Requests</div>
      <div class="table-top-sub">keyreq table · status1</div>
    </div>
    <table>
      <thead>
        <tr><th>#</th><th>DC Name</th><th>DC Email</th><th>File ID</th><th>Status</th><th>Action</th></tr>
      </thead>
      <tbody>
        <%
          boolean hasRows = false; int cnt = 1;
          if (rs != null) {
            while (rs.next()) {
              hasRows = true;
              String uid     = rs.getString("uid");
              String fid     = rs.getString("fid");
              String status1 = rs.getString("status1");
              String dcName  = "";
              try { dcName = rs.getString("name"); } catch(Exception ignored){}
        %>
        <tr>
          <td class="mono"><%= cnt++ %></td>
          <td><strong><%= dcName != null && !dcName.isEmpty() ? dcName : "—" %></strong></td>
          <td class="mono"><%= uid %></td>
          <td class="mono"><%= fid %></td>
          <td>
            <% if ("Approved".equals(status1)) { %>
              <span class="status-approved">Approved</span>
            <% } else { %>
              <span class="status-pending">Pending</span>
            <% } %>
          </td>
          <td>
            <% if (!"Approved".equals(status1)) { %>
              <a href="DCDecryptRequest?uid=<%= uid %>" class="btn-approve">Approve</a>
            <% } else { %>
              <span style="font-size:12px;color:var(--text-faint);">Done</span>
            <% } %>
          </td>
        </tr>
        <% } }
          if (!hasRows) { %>
        <tr class="empty-row"><td colspan="6">No decrypt requests submitted yet.</td></tr>
        <% } %>
      </tbody>
    </table>
  </div>
</div>
<% try{if(rs!=null)rs.close();}catch(Exception e){} try{if(st!=null)st.close();}catch(Exception e){} try{if(con!=null)con.close();}catch(Exception e){} %>
</body>
</html>
