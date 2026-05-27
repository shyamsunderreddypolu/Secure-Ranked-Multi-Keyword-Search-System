<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("dcemail") == null) {
        response.sendRedirect("DCLogin.jsp");
        return;
    }
    String dcName  = (String) s.getAttribute("dcname");
    String dcEmail = (String) s.getAttribute("dcemail");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Data Consumer Dashboard — SecureRank</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
    :root {
      --amber-mid:#854F0B; --amber-light:#FAEEDA; --amber-bdr:#F0C98A;
      --text-main:#1A1A18; --text-muted:#5F5E5A; --text-faint:#A0A09A;
      --border:rgba(0,0,0,0.09); --white:#fff; --gray-bg:#F7F6F3;
      --radius-md:10px; --radius-lg:14px;
    }
    body { font-family:'DM Sans',sans-serif; background:var(--gray-bg); color:var(--text-main); min-height:100vh; }
    nav { background:var(--white); border-bottom:1px solid var(--border); padding:0 32px; height:60px; display:flex; align-items:center; justify-content:space-between; }
    .nav-left { display:flex; align-items:center; gap:12px; }
    .nav-icon { width:36px; height:36px; background:var(--amber-mid); border-radius:var(--radius-md); display:flex; align-items:center; justify-content:center; }
    .nav-icon svg { width:18px; height:18px; }
    .nav-title { font-size:15px; font-weight:600; }
    .nav-sub   { font-size:11px; color:var(--text-muted); font-family:'DM Mono',monospace; }
    .nav-right { display:flex; align-items:center; gap:20px; }
    .nav-user  { font-size:13px; color:var(--text-muted); }
    .nav-user span { color:var(--amber-mid); font-weight:500; }
    .btn-logout { font-size:12px; padding:6px 14px; background:var(--gray-bg); border:1px solid var(--border); border-radius:var(--radius-md); text-decoration:none; color:var(--text-muted); }
    .btn-logout:hover { border-color:var(--amber-mid); color:var(--amber-mid); }

    .banner { background:var(--amber-mid); padding:28px 32px; }
    .banner h1 { font-size:22px; font-weight:600; color:#fff; margin-bottom:4px; }
    .banner p  { font-size:13px; color:var(--amber-light); }
    .banner-meta { font-size:12px; color:rgba(255,255,255,0.6); font-family:'DM Mono',monospace; margin-top:8px; }

    .main { max-width:900px; margin:0 auto; padding:32px 24px; }
    .section-label { font-size:11px; font-weight:500; color:var(--text-faint); text-transform:uppercase; letter-spacing:0.08em; margin-bottom:14px; }

    .cards-grid { display:grid; grid-template-columns:repeat(3,1fr); gap:14px; margin-bottom:32px; }
    .action-card { background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); padding:22px 18px; text-decoration:none; display:block; transition:border-color 0.15s, box-shadow 0.15s, transform 0.15s; }
    .action-card:hover { border-color:var(--amber-bdr); box-shadow:0 4px 20px rgba(133,79,11,0.10); transform:translateY(-2px); }
    .card-icon { width:40px; height:40px; background:var(--amber-light); border-radius:var(--radius-md); display:flex; align-items:center; justify-content:center; margin-bottom:12px; }
    .card-icon svg { width:20px; height:20px; stroke:var(--amber-mid); }
    .card-title { font-size:14px; font-weight:600; color:var(--text-main); margin-bottom:5px; }
    .card-desc  { font-size:12px; color:var(--text-muted); line-height:1.5; }
    .card-arrow { font-size:12px; color:var(--amber-mid); font-weight:500; margin-top:12px; }

    .flow-box { background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); padding:20px; }
    .flow-row  { display:flex; align-items:flex-start; gap:14px; padding:12px 0; border-bottom:1px solid var(--border); }
    .flow-row:last-child { border-bottom:none; padding-bottom:0; }
    .flow-num  { width:28px; height:28px; background:var(--amber-light); border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:12px; font-weight:600; color:var(--amber-mid); flex-shrink:0; }
    .flow-text h4 { font-size:13px; font-weight:600; color:var(--text-main); margin-bottom:3px; }
    .flow-text p  { font-size:12px; color:var(--text-muted); line-height:1.5; }
    .flow-tag { display:inline-block; font-family:'DM Mono',monospace; font-size:10px; background:var(--amber-light); color:var(--amber-mid); padding:2px 8px; border-radius:999px; margin-top:4px; }

    @media(max-width:600px){ .cards-grid { grid-template-columns:1fr; } }
  </style>
</head>
<body>

<nav>
  <div class="nav-left">
    <div class="nav-icon">
      <svg viewBox="0 0 24 24" fill="none" stroke="#F0C98A" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
      </svg>
    </div>
    <div>
      <div class="nav-title">SecureRank — Data Consumer</div>
      <div class="nav-sub">Search &amp; Download Encrypted Files</div>
    </div>
  </div>
  <div class="nav-right">
    <div class="nav-user">Logged in as <span><%= dcName %></span></div>
    <a href="LoginServlet?action=logout" class="btn-logout">Logout</a>
  </div>
</nav>

<div class="banner">
  <h1>Welcome, <%= dcName %></h1>
  <p>Search encrypted cloud files using Boolean keyword trapdoors. Download and decrypt authorised files.</p>
  <div class="banner-meta"><%= dcEmail %></div>
</div>

<div class="main">
  <div class="section-label">Data Consumer Actions</div>
  <div class="cards-grid">

    <a href="GenerateTrapdoor.jsp" class="action-card">
      <div class="card-icon">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <rect x="5" y="11" width="14" height="10" rx="2"/>
          <path d="M8 11V7a4 4 0 018 0v4"/>
        </svg>
      </div>
      <div class="card-title">Generate Trapdoor</div>
      <div class="card-desc">Encrypt a keyword into a search trapdoor using your secret key (sk) from PKG.</div>
      <div class="card-arrow">Generate →</div>
    </a>

    <a href="SearchFile.jsp" class="action-card">
      <div class="card-icon">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
        </svg>
      </div>
      <div class="card-title">Search Files</div>
      <div class="card-desc">Submit your trapdoor to the Cloud Server. Get TF-IDF ranked matching files.</div>
      <div class="card-arrow">Search →</div>
    </a>

    <a href="DCResults.jsp" class="action-card">
      <div class="card-icon">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/>
          <polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/>
        </svg>
      </div>
      <div class="card-title">Download Results</div>
      <div class="card-desc">View ranked search results. Request master key from PKG to decrypt files.</div>
      <div class="card-arrow">View Results →</div>
    </a>

  </div>

  <div class="section-label">How Secure Search Works</div>
  <div class="flow-box">
    <div class="flow-row">
      <div class="flow-num">1</div>
      <div class="flow-text">
        <h4>Get Secret Key from PKG</h4>
        <p>PKG generates a unique Secret Key (sk) for you. Used to create trapdoors for encrypted search.</p>
        <span class="flow-tag">keygen table → sk</span>
      </div>
    </div>
    <div class="flow-row">
      <div class="flow-num">2</div>
      <div class="flow-text">
        <h4>Generate Trapdoor for Keyword</h4>
        <p>Enter a keyword — it gets encrypted into a trapdoor using your sk. Cloud server never sees the keyword.</p>
        <span class="flow-tag">trapdoor table → trap</span>
      </div>
    </div>
    <div class="flow-row">
      <div class="flow-num">3</div>
      <div class="flow-text">
        <h4>Cloud Server Searches Index</h4>
        <p>Cloud Server compares your trapdoor against the encrypted TF-IDF index of all uploaded files.</p>
        <span class="flow-tag">upload table → stringcontent</span>
      </div>
    </div>
    <div class="flow-row">
      <div class="flow-num">4</div>
      <div class="flow-text">
        <h4>Ranked Results Returned</h4>
        <p>Matching files are ranked by TF-IDF relevance score. Results stored in request + response tables.</p>
        <span class="flow-tag">response table → TKey, fid</span>
      </div>
    </div>
    <div class="flow-row">
      <div class="flow-num">5</div>
      <div class="flow-text">
        <h4>Decrypt &amp; Download</h4>
        <p>Request Master Key (mk) from PKG. Use mk to decrypt the file and read the original content.</p>
        <span class="flow-tag">ukeys table → key1</span>
      </div>
    </div>
  </div>
</div>

</body>
</html>
