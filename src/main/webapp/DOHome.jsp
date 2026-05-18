<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("email") == null) {
        response.sendRedirect("DOLogin.jsp");
        return;
    }
    String doName  = (String) s.getAttribute("name");
    String doEmail = (String) s.getAttribute("email");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Data Owner Dashboard — SecureRank</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
    :root {
      --teal-dark:#0A4F3C; --teal-mid:#0F6E56; --teal-light:#E1F5EE; --teal-bdr:#A8DFC9;
      --text-main:#1A1A18; --text-muted:#5F5E5A; --text-faint:#A0A09A;
      --border:rgba(0,0,0,0.09); --white:#fff; --gray-bg:#F7F6F3;
      --radius-md:10px; --radius-lg:14px;
    }
    body { font-family:'DM Sans',sans-serif; background:var(--gray-bg); color:var(--text-main); min-height:100vh; }
    nav { background:var(--white); border-bottom:1px solid var(--border); padding:0 32px; height:60px; display:flex; align-items:center; justify-content:space-between; }
    .nav-left { display:flex; align-items:center; gap:12px; }
    .nav-icon { width:36px; height:36px; background:var(--teal-mid); border-radius:var(--radius-md); display:flex; align-items:center; justify-content:center; }
    .nav-icon svg { width:18px; height:18px; }
    .nav-title { font-size:15px; font-weight:600; }
    .nav-sub   { font-size:11px; color:var(--text-muted); font-family:'DM Mono',monospace; }
    .nav-right { display:flex; align-items:center; gap:20px; }
    .nav-user  { font-size:13px; color:var(--text-muted); }
    .nav-user span { color:var(--teal-mid); font-weight:500; }
    .btn-logout { font-size:12px; padding:6px 14px; background:var(--gray-bg); border:1px solid var(--border); border-radius:var(--radius-md); text-decoration:none; color:var(--text-muted); }
    .btn-logout:hover { border-color:var(--teal-mid); color:var(--teal-mid); }

    .banner { background:var(--teal-mid); padding:28px 32px; }
    .banner h1 { font-size:22px; font-weight:600; color:#fff; margin-bottom:4px; }
    .banner p  { font-size:13px; color:var(--teal-light); }
    .banner-meta { font-size:12px; color:rgba(255,255,255,0.6); font-family:'DM Mono',monospace; margin-top:8px; }

    .main { max-width:900px; margin:0 auto; padding:32px 24px; }
    .section-label { font-size:11px; font-weight:500; color:var(--text-faint); text-transform:uppercase; letter-spacing:0.08em; margin-bottom:14px; }

    .cards-grid { display:grid; grid-template-columns:repeat(3,1fr); gap:14px; margin-bottom:32px; }
    .action-card { background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); padding:22px 18px; text-decoration:none; display:block; transition:border-color 0.15s, box-shadow 0.15s, transform 0.15s; }
    .action-card:hover { border-color:var(--teal-bdr); box-shadow:0 4px 20px rgba(15,110,86,0.10); transform:translateY(-2px); }
    .card-icon { width:40px; height:40px; background:var(--teal-light); border-radius:var(--radius-md); display:flex; align-items:center; justify-content:center; margin-bottom:12px; }
    .card-icon svg { width:20px; height:20px; stroke:var(--teal-mid); }
    .card-title { font-size:14px; font-weight:600; color:var(--text-main); margin-bottom:5px; }
    .card-desc  { font-size:12px; color:var(--text-muted); line-height:1.5; }
    .card-arrow { font-size:12px; color:var(--teal-mid); font-weight:500; margin-top:12px; }

    /* FLOW BOX */
    .flow-box { background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); padding:20px; }
    .flow-row  { display:flex; align-items:flex-start; gap:14px; padding:12px 0; border-bottom:1px solid var(--border); }
    .flow-row:last-child { border-bottom:none; padding-bottom:0; }
    .flow-num  { width:28px; height:28px; background:var(--teal-light); border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:12px; font-weight:600; color:var(--teal-mid); flex-shrink:0; }
    .flow-text h4 { font-size:13px; font-weight:600; color:var(--text-main); margin-bottom:3px; }
    .flow-text p  { font-size:12px; color:var(--text-muted); line-height:1.5; }
    .flow-tag { display:inline-block; font-family:'DM Mono',monospace; font-size:10px; background:var(--teal-light); color:var(--teal-mid); padding:2px 8px; border-radius:999px; margin-top:4px; }

    @media(max-width:600px){ .cards-grid { grid-template-columns:1fr; } }
  </style>
</head>
<body>

<nav>
  <div class="nav-left">
    <div class="nav-icon">
      <svg viewBox="0 0 24 24" fill="none" stroke="#A8DFC9" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/>
        <polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/>
      </svg>
    </div>
    <div>
      <div class="nav-title">SecureRank — Data Owner</div>
      <div class="nav-sub">Encrypt &amp; Upload Files</div>
    </div>
  </div>
  <div class="nav-right">
    <div class="nav-user">Logged in as <span><%= doName %></span></div>
    <a href="DOLogin.jsp" class="btn-logout">Logout</a>
  </div>
</nav>

<div class="banner">
  <h1>Welcome, <%= doName %></h1>
  <p>Encrypt your files and upload them securely to the cloud. Manage access for Data Consumers.</p>
  <div class="banner-meta"><%= doEmail %></div>
</div>

<div class="main">
  <div class="section-label">Data Owner Actions</div>
  <div class="cards-grid">

    <a href="DOUpload.jsp" class="action-card">
      <div class="card-icon">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/>
          <polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/>
        </svg>
      </div>
      <div class="card-title">Upload Encrypted File</div>
      <div class="card-desc">Encrypt your file using GM/Paillier algorithm and upload to cloud with TF-IDF keyword index.</div>
      <div class="card-arrow">Upload File →</div>
    </a>

    <a href="ViewMyFiles.jsp" class="action-card">
      <div class="card-icon">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/>
          <polyline points="14 2 14 8 20 8"/>
        </svg>
      </div>
      <div class="card-title">View My Files</div>
      <div class="card-desc">View all encrypted files you have uploaded to the cloud server.</div>
      <div class="card-arrow">View Files →</div>
    </a>

    <a href="ViewRequests.jsp" class="action-card">
      <div class="card-icon">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M18 8h1a4 4 0 010 8h-1"/><path d="M2 8h16v9a4 4 0 01-4 4H6a4 4 0 01-4-4V8z"/>
          <line x1="6" y1="1" x2="6" y2="4"/><line x1="10" y1="1" x2="10" y2="4"/><line x1="14" y1="1" x2="14" y2="4"/>
        </svg>
      </div>
      <div class="card-title">Search Requests</div>
      <div class="card-desc">View search requests submitted by Data Consumers for your encrypted files.</div>
      <div class="card-arrow">View Requests →</div>
    </a>

  </div>

  <div class="section-label">How File Upload Works</div>
  <div class="flow-box">
    <div class="flow-row">
      <div class="flow-num">1</div>
      <div class="flow-text">
        <h4>Select File &amp; Enter Keywords</h4>
        <p>Choose your file and enter keywords that describe its content. These become the searchable index.</p>
        <span class="flow-tag">DOUpload.jsp</span>
      </div>
    </div>
    <div class="flow-row">
      <div class="flow-num">2</div>
      <div class="flow-text">
        <h4>File Encrypted (GM Algorithm)</h4>
        <p>File content is encrypted using the GM/Paillier homomorphic encryption. Cloud server never sees plaintext.</p>
        <span class="flow-tag">UploadFile.java → Enc column</span>
      </div>
    </div>
    <div class="flow-row">
      <div class="flow-num">3</div>
      <div class="flow-text">
        <h4>TF-IDF Keyword Index Built</h4>
        <p>Keywords are scored using TF-IDF and encoded into an encrypted vector index for Boolean search matching.</p>
        <span class="flow-tag">stringcontent column</span>
      </div>
    </div>
    <div class="flow-row">
      <div class="flow-num">4</div>
      <div class="flow-text">
        <h4>Trapdoor Key (Tkey) Generated</h4>
        <p>A unique trapdoor key is generated for this file. Used by Cloud Server to match DC search trapdoors.</p>
        <span class="flow-tag">Tkey column · store table</span>
      </div>
    </div>
    <div class="flow-row">
      <div class="flow-num">5</div>
      <div class="flow-text">
        <h4>Uploaded to Cloud Server</h4>
        <p>Encrypted file + keyword index stored in upload table. PKG distributes master key to authorised DCs.</p>
        <span class="flow-tag">upload table · ukeys table</span>
      </div>
    </div>
  </div>
</div>

</body>
</html>
