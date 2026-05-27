<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    // Session check — redirect to login if not logged in as PKG
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("pkgemail") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String pkgName  = (String) s.getAttribute("pkgname");
    String pkgEmail = (String) s.getAttribute("pkgemail");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>PKG Dashboard — SecureRank</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
    :root {
      --purple-dark:#2D2785; --purple-mid:#534AB7; --purple-light:#EEEDFE; --purple-bdr:#C5C2F5;
      --text-main:#1A1A18; --text-muted:#5F5E5A; --text-faint:#A0A09A;
      --border:rgba(0,0,0,0.09); --white:#ffffff; --gray-bg:#F7F6F3;
      --radius-md:10px; --radius-lg:14px;
    }
    body { font-family:'DM Sans',sans-serif; background:var(--gray-bg); color:var(--text-main); min-height:100vh; }

    /* NAV */
    nav { background:var(--white); border-bottom:1px solid var(--border); padding:0 32px; height:60px; display:flex; align-items:center; justify-content:space-between; }
    .nav-left { display:flex; align-items:center; gap:12px; }
    .nav-icon { width:36px; height:36px; background:var(--purple-mid); border-radius:var(--radius-md); display:flex; align-items:center; justify-content:center; }
    .nav-icon svg { width:18px; height:18px; }
    .nav-title { font-size:15px; font-weight:600; color:var(--text-main); }
    .nav-sub   { font-size:11px; color:var(--text-muted); font-family:'DM Mono',monospace; }
    .nav-right { display:flex; align-items:center; gap:20px; }
    .nav-user  { font-size:13px; color:var(--text-muted); }
    .nav-user span { color:var(--purple-mid); font-weight:500; }
    .btn-logout { font-size:12px; padding:6px 14px; background:var(--gray-bg); border:1px solid var(--border); border-radius:var(--radius-md); text-decoration:none; color:var(--text-muted); }
    .btn-logout:hover { border-color:var(--purple-mid); color:var(--purple-mid); }

    /* HEADER BANNER */
    .header-banner { background:var(--purple-mid); padding:28px 32px; }
    .header-banner h1 { font-size:22px; font-weight:600; color:#fff; margin-bottom:4px; }
    .header-banner p  { font-size:13px; color:var(--purple-light); }

    /* MAIN */
    .main { max-width:900px; margin:0 auto; padding:32px 24px; }
    .section-label { font-size:11px; font-weight:500; color:var(--text-faint); text-transform:uppercase; letter-spacing:0.08em; margin-bottom:14px; }

    /* ACTION CARDS */
    .cards-grid { display:grid; grid-template-columns:repeat(2,1fr); gap:14px; margin-bottom:32px; }
    .action-card { background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); padding:24px 20px; text-decoration:none; display:block; transition:border-color 0.15s, box-shadow 0.15s, transform 0.15s; }
    .action-card:hover { border-color:var(--purple-bdr); box-shadow:0 4px 20px rgba(83,74,183,0.10); transform:translateY(-2px); }
    .card-icon { width:44px; height:44px; background:var(--purple-light); border-radius:var(--radius-md); display:flex; align-items:center; justify-content:center; margin-bottom:14px; }
    .card-icon svg { width:22px; height:22px; stroke:var(--purple-mid); }
    .card-title { font-size:15px; font-weight:600; color:var(--text-main); margin-bottom:6px; }
    .card-desc  { font-size:12px; color:var(--text-muted); line-height:1.55; }
    .card-arrow { font-size:12px; color:var(--purple-mid); font-weight:500; margin-top:14px; }

    /* FLOW STEPS */
    .flow-box { background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); padding:20px; }
    .flow-row  { display:flex; align-items:flex-start; gap:14px; padding:12px 0; border-bottom:1px solid var(--border); }
    .flow-row:last-child { border-bottom:none; padding-bottom:0; }
    .flow-num  { width:28px; height:28px; background:var(--purple-light); border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:12px; font-weight:600; color:var(--purple-mid); flex-shrink:0; margin-top:1px; }
    .flow-text h4 { font-size:13px; font-weight:600; color:var(--text-main); margin-bottom:3px; }
    .flow-text p  { font-size:12px; color:var(--text-muted); line-height:1.5; }
    .flow-tag  { display:inline-block; font-family:'DM Mono',monospace; font-size:10px; background:var(--purple-light); color:var(--purple-mid); padding:2px 8px; border-radius:999px; margin-top:4px; }
  </style>
</head>
<body>

<!-- NAV -->
<nav>
  <div class="nav-left">
    <div class="nav-icon">
      <svg viewBox="0 0 24 24" fill="none" stroke="#C5C2F5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 11-7.778 7.778 5.5 5.5 0 017.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"/>
      </svg>
    </div>
    <div>
      <div class="nav-title">SecureRank — PKG Dashboard</div>
      <div class="nav-sub">Private Key Generator</div>
    </div>
  </div>
  <div class="nav-right">
    <div class="nav-user">Logged in as <span><%= pkgName %></span></div>
    <a href="LoginServlet?action=logout" class="btn-logout">Logout</a>
  </div>
</nav>

<!-- HEADER BANNER -->
<div class="header-banner">
  <h1>Welcome, <%= pkgName %></h1>
  <p>Generate secret keys for Data Consumers and send master keys for file access.</p>
</div>

<!-- MAIN -->
<div class="main">

  <div class="section-label">PKG Actions</div>
  <div class="cards-grid">

    <!-- Generate Key for DC -->
    <a href="GeneratePKDC.jsp" class="action-card">
      <div class="card-icon">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 11-7.778 7.778 5.5 5.5 0 017.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"/>
        </svg>
      </div>
      <div class="card-title">Generate Key for DC</div>
      <div class="card-desc">Select a Data Consumer and generate a unique Secret Key (sk). DC uses this key to create search trapdoors.</div>
      <div class="card-arrow">Generate Key →</div>
    </a>

    <!-- Send Master Key to DC -->
    <a href="SendKeysToDC.jsp" class="action-card">
      <div class="card-icon">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <line x1="22" y1="2" x2="11" y2="13"/>
          <polygon points="22 2 15 22 11 13 2 9 22 2"/>
        </svg>
      </div>
      <div class="card-title">Send Master Key to DC</div>
      <div class="card-desc">Send the Master Key (mk) for a specific file to a Data Consumer so they can decrypt the downloaded file.</div>
      <div class="card-arrow">Send Key →</div>
    </a>

  </div>

  <!-- How PKG Works -->
  <div class="section-label">How PKG Works in SecureRank</div>
  <div class="flow-box">
    <div class="flow-row">
      <div class="flow-num">1</div>
      <div class="flow-text">
        <h4>Data Consumer Registers</h4>
        <p>DC registers on the system and waits for Admin approval.</p>
        <span class="flow-tag">dcregister table</span>
      </div>
    </div>
    <div class="flow-row">
      <div class="flow-num">2</div>
      <div class="flow-text">
        <h4>PKG Generates Secret Key (sk)</h4>
        <p>PKG selects the DC's email and generates a unique Secret Key using the Paillier-based algorithm. Stored in keygen table.</p>
        <span class="flow-tag">keygen table → sk, mk, uid</span>
      </div>
    </div>
    <div class="flow-row">
      <div class="flow-num">3</div>
      <div class="flow-text">
        <h4>DC Uses sk to Generate Trapdoor</h4>
        <p>DC uses their secret key to create an encrypted trapdoor for a keyword. Sent to Cloud Server for search.</p>
        <span class="flow-tag">trapdoor table → trap</span>
      </div>
    </div>
    <div class="flow-row">
      <div class="flow-num">4</div>
      <div class="flow-text">
        <h4>PKG Sends Master Key (mk) to DC</h4>
        <p>After Cloud Server returns matched files, PKG sends the file's master key to DC so they can decrypt the result.</p>
        <span class="flow-tag">ukeys table → fid, uid, key1</span>
      </div>
    </div>
    <div class="flow-row">
      <div class="flow-num">5</div>
      <div class="flow-text">
        <h4>DC Decrypts and Downloads</h4>
        <p>DC uses the master key to decrypt and read the original file from the Cloud Server.</p>
        <span class="flow-tag">upload table → Enc, Tkey</span>
      </div>
    </div>
  </div>

</div>
</body>
</html>
