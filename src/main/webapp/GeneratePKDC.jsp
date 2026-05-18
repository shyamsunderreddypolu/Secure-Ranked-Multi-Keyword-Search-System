<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.sql.*" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("pkgemail") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String pkgName = (String) s.getAttribute("pkgname");

    // Load all Approved Data Consumers from DB
    Connection con = com.dao.DBConnection.connect();
    ResultSet rs = null;
    Statement st = null;
    try {
        st = con.createStatement();
        rs = st.executeQuery("select id, name, email, mobile from dcregister where status='Approved'");
    } catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Generate Key for DC — SecureRank PKG</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
    :root {
      --purple-mid:#534AB7; --purple-light:#EEEDFE; --purple-bdr:#C5C2F5;
      --teal-bg:#E1F5EE; --teal-mid:#0F6E56;
      --text-main:#1A1A18; --text-muted:#5F5E5A; --text-faint:#A0A09A;
      --border:rgba(0,0,0,0.09); --white:#ffffff; --gray-bg:#F7F6F3;
      --radius-md:10px; --radius-lg:14px;
    }
    body { font-family:'DM Sans',sans-serif; background:var(--gray-bg); color:var(--text-main); }
    nav { background:var(--white); border-bottom:1px solid var(--border); padding:0 32px; height:60px; display:flex; align-items:center; justify-content:space-between; }
    .nav-left { display:flex; align-items:center; gap:10px; }
    .nav-icon { width:36px; height:36px; background:var(--purple-mid); border-radius:var(--radius-md); display:flex; align-items:center; justify-content:center; }
    .nav-icon svg { width:18px; height:18px; }
    .nav-title { font-size:15px; font-weight:600; }
    .nav-sub   { font-size:11px; color:var(--text-muted); font-family:'DM Mono',monospace; }
    .nav-right { display:flex; gap:12px; align-items:center; }
    .btn-back { font-size:12px; padding:6px 14px; background:var(--gray-bg); border:1px solid var(--border); border-radius:var(--radius-md); text-decoration:none; color:var(--text-muted); }
    .btn-back:hover { border-color:var(--purple-mid); color:var(--purple-mid); }

    .page-wrap { max-width:860px; margin:32px auto; padding:0 24px; }
    .page-header { margin-bottom:24px; }
    .page-header h2 { font-size:20px; font-weight:600; color:var(--text-main); }
    .page-header p  { font-size:13px; color:var(--text-muted); margin-top:4px; }

    /* TABLE */
    .table-card { background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); overflow:hidden; }
    .table-top  { padding:16px 20px; border-bottom:1px solid var(--border); display:flex; align-items:center; justify-content:space-between; }
    .table-top-title { font-size:14px; font-weight:600; color:var(--text-main); }
    .table-top-count { font-size:12px; color:var(--text-muted); font-family:'DM Mono',monospace; }
    table { width:100%; border-collapse:collapse; }
    thead th { padding:10px 20px; text-align:left; font-size:11px; font-weight:500; color:var(--text-faint); text-transform:uppercase; letter-spacing:0.06em; background:var(--gray-bg); border-bottom:1px solid var(--border); }
    tbody tr { border-bottom:1px solid var(--border); transition:background 0.12s; }
    tbody tr:last-child { border-bottom:none; }
    tbody tr:hover { background:#FAFAF8; }
    tbody td { padding:14px 20px; font-size:13px; color:var(--text-main); vertical-align:middle; }
    .email-cell { font-family:'DM Mono',monospace; font-size:12px; color:var(--text-muted); }
    .status-badge { display:inline-block; font-size:11px; padding:3px 10px; border-radius:999px; font-weight:500; }
    .status-approved { background:var(--teal-bg); color:var(--teal-mid); }

    /* GENERATE BUTTON */
    .btn-generate {
      display:inline-block; font-size:12px; font-weight:500;
      background:var(--purple-mid); color:#fff; border:none;
      padding:7px 16px; border-radius:var(--radius-md);
      text-decoration:none; cursor:pointer; font-family:'DM Sans',sans-serif;
      transition:background 0.15s;
    }
    .btn-generate:hover { background:#2D2785; }

    .empty-row td { text-align:center; padding:32px; color:var(--text-faint); font-size:13px; }
  </style>
</head>
<body>

<nav>
  <div class="nav-left">
    <div class="nav-icon">
      <svg viewBox="0 0 24 24" fill="none" stroke="#C5C2F5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 11-7.778 7.778 5.5 5.5 0 017.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"/>
      </svg>
    </div>
    <div>
      <div class="nav-title">Generate Key for DC</div>
      <div class="nav-sub">PKG Module · SecureRank</div>
    </div>
  </div>
  <div class="nav-right">
    <a href="PKGHome.jsp" class="btn-back">← Dashboard</a>
  </div>
</nav>

<div class="page-wrap">
  <div class="page-header">
    <h2>Generate Secret Key for Data Consumer</h2>
    <p>Select a Data Consumer from the list below and click Generate Key to issue their Secret Key (sk). This key allows them to create encrypted search trapdoors.</p>
  </div>

  <div class="table-card">
    <div class="table-top">
      <div class="table-top-title">Approved Data Consumers</div>
      <div class="table-top-count">keygen table · sk / mk / uid</div>
    </div>
    <table>
      <thead>
        <tr>
          <th>#</th>
          <th>Name</th>
          <th>Email</th>
          <th>Mobile</th>
          <th>Status</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <%
          boolean hasRows = false;
          int count = 1;
          if (rs != null) {
            while (rs.next()) {
              hasRows = true;
              String dcName   = rs.getString("name");
              String dcEmail  = rs.getString("email");
              String dcMobile = rs.getString("mobile");
        %>
        <tr>
          <td><%= count++ %></td>
          <td><strong><%= dcName %></strong></td>
          <td class="email-cell"><%= dcEmail %></td>
          <td><%= dcMobile %></td>
          <td><span class="status-badge status-approved">Approved</span></td>
          <td>
            <a href="GeneratePKDC?email=<%= dcEmail %>" class="btn-generate">
              Generate Key
            </a>
          </td>
        </tr>
        <%
            }
          }
          if (!hasRows) {
        %>
        <tr class="empty-row">
          <td colspan="6">No approved Data Consumers found. Ask Admin to approve DC accounts first.</td>
        </tr>
        <% } %>
      </tbody>
    </table>
  </div>
</div>

<%
  try { if (rs  != null) rs.close();  } catch (Exception ignored) {}
  try { if (st  != null) st.close();  } catch (Exception ignored) {}
  try { if (con != null) con.close(); } catch (Exception ignored) {}
%>
</body>
</html>
