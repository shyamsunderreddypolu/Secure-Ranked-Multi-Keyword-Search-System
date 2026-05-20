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
            "select Fid, Email, Filename, Label, Content, Tkey, upload_time from upload order by Fid desc");
    } catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Uploaded Files — SecureRank Admin</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
    :root {
      --blue-mid:#185FA5; --blue-light:#E6F1FB;
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
    .btn-back:hover { border-color:var(--blue-mid); color:var(--blue-mid); }
    .page-wrap { max-width:1000px; margin:32px auto; padding:0 24px; }
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
    .label-badge { display:inline-block; font-size:11px; padding:3px 9px; border-radius:999px; background:var(--amber-bg); color:var(--amber-mid); font-weight:500; }
    .enc-badge   { display:inline-block; font-size:11px; padding:3px 9px; border-radius:999px; background:var(--teal-bg);   color:var(--teal-mid);  font-weight:500; }
    .empty-row td { text-align:center; padding:40px; color:var(--text-faint); }
  </style>
</head>
<body>
<nav>
  <div>
    <div class="nav-title">Encrypted Files on Cloud</div>
    <div class="nav-sub">Admin · SecureRank</div>
  </div>
  <a href="CSHome.jsp" class="btn-back">← Dashboard</a>
</nav>
<div class="page-wrap">
  <div class="page-header">
    <h2>All Encrypted Files</h2>
    <p>Files uploaded by Data Owners. Only encrypted content (ciphertext) is stored — plaintext is never on the server.</p>
  </div>
  <div class="table-card">
    <div class="table-top">
      <div class="table-top-title">Cloud Storage — Encrypted Index</div>
      <div class="table-top-sub">upload table</div>
    </div>
    <table>
      <thead>
        <tr><th>File ID</th><th>Owner Email</th><th>File Name</th><th>Label</th><th>Encryption</th><th>Trapdoor Key</th><th>Uploaded At</th></tr>
      </thead>
      <tbody>
        <%
          boolean hasRows = false;
          if (rs != null) {
            while (rs.next()) {
              hasRows = true;
              String fid      = rs.getString("Fid");
              String email    = rs.getString("Email");
              String filename = rs.getString("Filename");
              String label    = rs.getString("Label");
              String tkey     = rs.getString("Tkey");
              String upTime   = rs.getString("upload_time");
        %>
        <tr>
          <td class="mono"><%= fid %></td>
          <td class="mono"><%= email %></td>
          <td><strong><%= filename %></strong></td>
          <td><span class="label-badge"><%= label != null ? label : "General" %></span></td>
          <td><span class="enc-badge">GM Encrypted</span></td>
          <td class="mono"><%= tkey != null ? tkey.substring(0, Math.min(tkey.length(),14)) + "..." : "—" %></td>
          <td class="mono"><%= upTime != null ? upTime : "—" %></td>
        </tr>
        <% } }
          if (!hasRows) { %>
        <tr class="empty-row"><td colspan="7">No files uploaded yet.</td></tr>
        <% } %>
      </tbody>
    </table>
  </div>
</div>
<% try{if(rs!=null)rs.close();}catch(Exception e){} try{if(st!=null)st.close();}catch(Exception e){} try{if(con!=null)con.close();}catch(Exception e){} %>
</body>
</html>
