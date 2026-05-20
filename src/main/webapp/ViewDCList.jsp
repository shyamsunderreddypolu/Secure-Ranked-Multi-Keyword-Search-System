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
        rs = st.executeQuery("select id,name,email,mobile,address,status from dcregister order by id desc");
    } catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Data Consumer List — SecureRank Admin</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
    :root {
      --amber-mid:#854F0B; --amber-bg:#FAEEDA; --amber-bdr:#F0C98A;
      --teal-mid:#0F6E56; --teal-bg:#E1F5EE;
      --red-mid:#B91C1C; --red-bg:#FEEAEA;
      --text-main:#1A1A18; --text-muted:#5F5E5A; --text-faint:#A0A09A;
      --border:rgba(0,0,0,0.09); --white:#fff; --gray-bg:#F7F6F3;
      --radius-md:10px; --radius-lg:14px;
    }
    body  { font-family:'DM Sans',sans-serif; background:var(--gray-bg); }
    nav   { background:var(--white); border-bottom:1px solid var(--border); padding:0 32px; height:60px; display:flex; align-items:center; justify-content:space-between; }
    .nav-title { font-size:15px; font-weight:600; }
    .nav-sub   { font-size:11px; color:var(--text-muted); font-family:'DM Mono',monospace; }
    .btn-back  { font-size:12px; padding:6px 14px; background:var(--gray-bg); border:1px solid var(--border); border-radius:var(--radius-md); text-decoration:none; color:var(--text-muted); }
    .btn-back:hover { border-color:var(--amber-mid); color:var(--amber-mid); }
    .page-wrap { max-width:960px; margin:32px auto; padding:0 24px; }
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
    .status-rejected { display:inline-block; font-size:11px; padding:3px 9px; border-radius:999px; background:var(--red-bg);   color:var(--red-mid);   font-weight:500; }
    .btn-approve { font-size:11px; font-weight:500; padding:5px 12px; background:var(--teal-mid); color:#fff; border:none; border-radius:var(--radius-md); text-decoration:none; margin-right:4px; }
    .btn-reject  { font-size:11px; font-weight:500; padding:5px 12px; background:var(--red-bg); color:var(--red-mid); border:1px solid var(--red-mid); border-radius:var(--radius-md); text-decoration:none; }
    .empty-row td { text-align:center; padding:40px; color:var(--text-faint); }
  </style>
</head>
<body>
<nav>
  <div>
    <div class="nav-title">Data Consumer Accounts</div>
    <div class="nav-sub">Admin · SecureRank</div>
  </div>
  <a href="CSHome.jsp" class="btn-back">← Dashboard</a>
</nav>
<div class="page-wrap">
  <div class="page-header">
    <h2>Manage Data Consumers</h2>
    <p>Approve or reject Data Consumer registrations. Only Approved DCs can login and search encrypted files.</p>
  </div>
  <div class="table-card">
    <div class="table-top">
      <div class="table-top-title">All Data Consumer Registrations</div>
      <div class="table-top-sub">dcregister table · status</div>
    </div>
    <table>
      <thead>
        <tr><th>#</th><th>Name</th><th>Email</th><th>Mobile</th><th>Status</th><th>Action</th></tr>
      </thead>
      <tbody>
        <%
          boolean hasRows = false; int cnt = 1;
          if (rs != null) {
            while (rs.next()) {
              hasRows = true;
              String dcName   = rs.getString("name");
              String dcEmail  = rs.getString("email");
              String dcMobile = rs.getString("mobile");
              String dcStatus = rs.getString("status");
        %>
        <tr>
          <td class="mono"><%= cnt++ %></td>
          <td><strong><%= dcName %></strong></td>
          <td class="mono"><%= dcEmail %></td>
          <td class="mono"><%= dcMobile != null ? dcMobile : "—" %></td>
          <td>
            <% if ("Approved".equals(dcStatus)) { %>
              <span class="status-approved">Approved</span>
            <% } else if ("Rejected".equals(dcStatus)) { %>
              <span class="status-rejected">Rejected</span>
            <% } else { %>
              <span class="status-pending">Pending</span>
            <% } %>
          </td>
          <td>
            <% if (!"Approved".equals(dcStatus)) { %>
              <a href="ApproveDC?email=<%= dcEmail %>&action=approve" class="btn-approve">Approve</a>
            <% } %>
            <% if (!"Rejected".equals(dcStatus)) { %>
              <a href="ApproveDC?email=<%= dcEmail %>&action=reject"  class="btn-reject">Reject</a>
            <% } %>
          </td>
        </tr>
        <% } }
          if (!hasRows) { %>
        <tr class="empty-row"><td colspan="6">No Data Consumers registered yet.</td></tr>
        <% } %>
      </tbody>
    </table>
  </div>
</div>
<% try{if(rs!=null)rs.close();}catch(Exception e){} try{if(st!=null)st.close();}catch(Exception e){} try{if(con!=null)con.close();}catch(Exception e){} %>
</body>
</html>
