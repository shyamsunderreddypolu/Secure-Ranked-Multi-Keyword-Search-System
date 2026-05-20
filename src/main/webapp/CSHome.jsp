<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("csemail") == null) {
        response.sendRedirect("CloudControllerLogin.jsp");
        return;
    }
    String csName  = (String) s.getAttribute("csname");
    String csEmail = (String) s.getAttribute("csemail");

    // Quick counts for dashboard stats
    int doCount = 0, dcCount = 0, fileCount = 0, pendingDO = 0, pendingDC = 0;
    java.sql.Connection con = com.dao.DBConnection.connect();
    try {
        java.sql.Statement st = con.createStatement();
        java.sql.ResultSet rs;
        rs = st.executeQuery("select count(*) from doregister"); if(rs.next()) doCount = rs.getInt(1); rs.close();
        rs = st.executeQuery("select count(*) from dcregister"); if(rs.next()) dcCount = rs.getInt(1); rs.close();
        rs = st.executeQuery("select count(*) from upload");     if(rs.next()) fileCount = rs.getInt(1); rs.close();
        rs = st.executeQuery("select count(*) from doregister where status1='Pending'"); if(rs.next()) pendingDO = rs.getInt(1); rs.close();
        rs = st.executeQuery("select count(*) from dcregister where status='Pending'");  if(rs.next()) pendingDC = rs.getInt(1); rs.close();
        st.close();
    } catch(Exception e){ e.printStackTrace(); }
    finally { try{ if(con!=null) con.close(); }catch(Exception ignored){} }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard — SecureRank</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
    :root {
      --blue-dark:#042C53; --blue-mid:#185FA5; --blue-light:#E6F1FB; --blue-bdr:#B5D4F4;
      --teal-bg:#E1F5EE; --teal-mid:#0F6E56;
      --amber-bg:#FAEEDA; --amber-mid:#854F0B;
      --purple-bg:#EEEDFE; --purple-mid:#534AB7;
      --red-bg:#FEEAEA; --red-mid:#B91C1C;
      --text-main:#1A1A18; --text-muted:#5F5E5A; --text-faint:#A0A09A;
      --border:rgba(0,0,0,0.09); --white:#fff; --gray-bg:#F7F6F3;
      --radius-md:10px; --radius-lg:14px;
    }
    body { font-family:'DM Sans',sans-serif; background:var(--gray-bg); color:var(--text-main); min-height:100vh; }
    nav { background:var(--white); border-bottom:1px solid var(--border); padding:0 32px; height:60px; display:flex; align-items:center; justify-content:space-between; }
    .nav-left { display:flex; align-items:center; gap:12px; }
    .nav-icon  { width:36px; height:36px; background:var(--blue-dark); border-radius:var(--radius-md); display:flex; align-items:center; justify-content:center; }
    .nav-icon svg { width:18px; height:18px; }
    .nav-title { font-size:15px; font-weight:600; }
    .nav-sub   { font-size:11px; color:var(--text-muted); font-family:'DM Mono',monospace; }
    .nav-right { display:flex; align-items:center; gap:20px; }
    .nav-user  { font-size:13px; color:var(--text-muted); }
    .nav-user span { color:var(--blue-mid); font-weight:500; }
    .btn-logout { font-size:12px; padding:6px 14px; background:var(--gray-bg); border:1px solid var(--border); border-radius:var(--radius-md); text-decoration:none; color:var(--text-muted); }
    .btn-logout:hover { border-color:var(--blue-mid); color:var(--blue-mid); }

    .banner { background:var(--blue-dark); padding:28px 32px; }
    .banner h1 { font-size:22px; font-weight:600; color:#fff; margin-bottom:4px; }
    .banner p  { font-size:13px; color:var(--blue-light); }
    .banner-meta { font-size:12px; color:rgba(255,255,255,0.5); font-family:'DM Mono',monospace; margin-top:8px; }

    .main { max-width:960px; margin:0 auto; padding:32px 24px; }
    .section-label { font-size:11px; font-weight:500; color:var(--text-faint); text-transform:uppercase; letter-spacing:0.08em; margin-bottom:14px; }

    /* STAT CARDS */
    .stats-grid { display:grid; grid-template-columns:repeat(5,1fr); gap:12px; margin-bottom:32px; }
    .stat-card  { background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); padding:18px 16px; text-align:center; }
    .stat-num   { font-size:26px; font-weight:600; font-family:'DM Mono',monospace; }
    .stat-label { font-size:11px; color:var(--text-muted); margin-top:4px; }
    .stat-card.warn { border-color:#F0C98A; background:var(--amber-bg); }
    .stat-card.warn .stat-num { color:var(--amber-mid); }

    /* ACTION CARDS */
    .cards-grid { display:grid; grid-template-columns:repeat(3,1fr); gap:14px; margin-bottom:32px; }
    .action-card { background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); padding:20px 18px; text-decoration:none; display:block; transition:border-color 0.15s, box-shadow 0.15s, transform 0.15s; position:relative; }
    .action-card:hover { border-color:var(--blue-bdr); box-shadow:0 4px 20px rgba(24,95,165,0.10); transform:translateY(-2px); }
    .card-icon  { width:40px; height:40px; border-radius:var(--radius-md); display:flex; align-items:center; justify-content:center; margin-bottom:12px; }
    .card-icon svg { width:20px; height:20px; }
    .card-title { font-size:14px; font-weight:600; color:var(--text-main); margin-bottom:5px; }
    .card-desc  { font-size:12px; color:var(--text-muted); line-height:1.5; }
    .card-arrow { font-size:12px; font-weight:500; margin-top:12px; }
    .pending-dot { position:absolute; top:14px; right:14px; background:var(--amber-mid); color:#fff; font-size:10px; font-weight:600; font-family:'DM Mono',monospace; padding:2px 7px; border-radius:999px; }

    @media(max-width:700px){ .stats-grid{grid-template-columns:repeat(2,1fr);} .cards-grid{grid-template-columns:1fr;} }
  </style>
</head>
<body>

<nav>
  <div class="nav-left">
    <div class="nav-icon">
      <svg viewBox="0 0 24 24" fill="none" stroke="#B5D4F4" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <rect x="2" y="3" width="20" height="14" rx="2"/>
        <line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/>
      </svg>
    </div>
    <div>
      <div class="nav-title">SecureRank — Admin Dashboard</div>
      <div class="nav-sub">Cloud Server Controller</div>
    </div>
  </div>
  <div class="nav-right">
    <div class="nav-user">Logged in as <span><%= csName %></span></div>
    <a href="CloudControllerLogin.jsp" class="btn-logout">Logout</a>
  </div>
</nav>

<div class="banner">
  <h1>Welcome, <%= csName %></h1>
  <p>Manage user registrations, monitor encrypted file activity and oversee the entire SecureRank system.</p>
  <div class="banner-meta"><%= csEmail %></div>
</div>

<div class="main">

  <!-- STATS -->
  <div class="section-label">System Overview</div>
  <div class="stats-grid">
    <div class="stat-card">
      <div class="stat-num" style="color:var(--teal-mid);"><%= doCount %></div>
      <div class="stat-label">Data Owners</div>
    </div>
    <div class="stat-card">
      <div class="stat-num" style="color:var(--amber-mid);"><%= dcCount %></div>
      <div class="stat-label">Data Consumers</div>
    </div>
    <div class="stat-card">
      <div class="stat-num" style="color:var(--blue-mid);"><%= fileCount %></div>
      <div class="stat-label">Encrypted Files</div>
    </div>
    <div class="stat-card <%= pendingDO > 0 ? "warn" : "" %>">
      <div class="stat-num"><%= pendingDO %></div>
      <div class="stat-label">Pending DO</div>
    </div>
    <div class="stat-card <%= pendingDC > 0 ? "warn" : "" %>">
      <div class="stat-num"><%= pendingDC %></div>
      <div class="stat-label">Pending DC</div>
    </div>
  </div>

  <!-- ACTIONS -->
  <div class="section-label">Admin Actions</div>
  <div class="cards-grid">

    <a href="ViewDOList.jsp" class="action-card">
      <% if (pendingDO > 0) { %><div class="pending-dot"><%= pendingDO %> pending</div><% } %>
      <div class="card-icon" style="background:var(--teal-bg);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#0F6E56" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/>
          <circle cx="9" cy="7" r="4"/>
          <path d="M23 21v-2a4 4 0 00-3-3.87"/><path d="M16 3.13a4 4 0 010 7.75"/>
        </svg>
      </div>
      <div class="card-title">Manage Data Owners</div>
      <div class="card-desc">View all registered Data Owners. Approve or reject pending accounts.</div>
      <div class="card-arrow" style="color:var(--teal-mid);">View DO List →</div>
    </a>

    <a href="ViewDCList.jsp" class="action-card">
      <% if (pendingDC > 0) { %><div class="pending-dot"><%= pendingDC %> pending</div><% } %>
      <div class="card-icon" style="background:var(--amber-bg);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#854F0B" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
        </svg>
      </div>
      <div class="card-title">Manage Data Consumers</div>
      <div class="card-desc">View all registered Data Consumers. Approve or reject pending accounts.</div>
      <div class="card-arrow" style="color:var(--amber-mid);">View DC List →</div>
    </a>

    <a href="ViewUploadedFiles.jsp" class="action-card">
      <div class="card-icon" style="background:var(--blue-light);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#185FA5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/>
          <polyline points="14 2 14 8 20 8"/>
        </svg>
      </div>
      <div class="card-title">View Encrypted Files</div>
      <div class="card-desc">View all encrypted files uploaded by Data Owners to the cloud storage.</div>
      <div class="card-arrow" style="color:var(--blue-mid);">View Files →</div>
    </a>

    <a href="ViewSearchRequests.jsp" class="action-card">
      <div class="card-icon" style="background:var(--purple-bg);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#534AB7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
        </svg>
      </div>
      <div class="card-title">Search Activity</div>
      <div class="card-desc">Monitor all search requests submitted by Data Consumers against the cloud index.</div>
      <div class="card-arrow" style="color:var(--purple-mid);">View Activity →</div>
    </a>

    <a href="DCDecryptRequest.jsp" class="action-card">
      <div class="card-icon" style="background:var(--red-bg);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#B91C1C" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <rect x="5" y="11" width="14" height="10" rx="2"/>
          <path d="M8 11V7a4 4 0 018 0v4"/>
        </svg>
      </div>
      <div class="card-title">Decrypt Requests</div>
      <div class="card-desc">Approve DC requests for master key access to decrypt specific files.</div>
      <div class="card-arrow" style="color:var(--red-mid);">View Requests →</div>
    </a>

    <a href="ViewEqualityCheck.jsp" class="action-card">
      <div class="card-icon" style="background:#F0EBD8;">
        <svg viewBox="0 0 24 24" fill="none" stroke="#7C6514" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <polyline points="20 6 9 17 4 12"/>
        </svg>
      </div>
      <div class="card-title">Equality Verification</div>
      <div class="card-desc">View SCP Boolean equality check results — trapdoor verification records.</div>
      <div class="card-arrow" style="color:#7C6514;">View Checks →</div>
    </a>

  </div>
</div>
</body>
</html>
