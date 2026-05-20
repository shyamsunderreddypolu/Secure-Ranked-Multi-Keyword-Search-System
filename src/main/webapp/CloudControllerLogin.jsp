<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Login — SecureRank</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
    :root {
      --blue-dark:#042C53; --blue-mid:#185FA5; --blue-light:#E6F1FB; --blue-bdr:#B5D4F4;
      --text-main:#1A1A18; --text-muted:#5F5E5A; --text-faint:#A0A09A;
      --border:rgba(0,0,0,0.09); --white:#fff; --gray-bg:#F7F6F3;
      --radius-md:10px; --radius-lg:14px;
    }
    body { font-family:'DM Sans',sans-serif; background:var(--gray-bg); min-height:100vh; display:flex; flex-direction:column; }
    nav  { background:var(--white); border-bottom:1px solid var(--border); padding:0 40px; height:60px; display:flex; align-items:center; justify-content:space-between; }
    .logo { display:flex; align-items:center; gap:10px; text-decoration:none; }
    .logo-icon { width:36px; height:36px; background:var(--blue-dark); border-radius:var(--radius-md); display:flex; align-items:center; justify-content:center; }
    .logo-icon svg { width:18px; height:18px; }
    .logo-text { font-size:15px; font-weight:600; color:var(--text-main); }
    .logo-sub  { font-size:11px; color:var(--text-muted); font-family:'DM Mono',monospace; }
    .btn-home  { font-size:13px; color:var(--text-muted); text-decoration:none; }
    .btn-home:hover { color:var(--blue-mid); }

    .page-wrap { flex:1; display:flex; align-items:center; justify-content:center; padding:40px 20px; }
    .form-card { width:380px; background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); padding:36px 32px; }

    .card-top  { display:flex; align-items:center; gap:14px; margin-bottom:28px; }
    .card-icon { width:44px; height:44px; background:var(--blue-light); border-radius:var(--radius-md); display:flex; align-items:center; justify-content:center; }
    .card-icon svg { width:22px; height:22px; stroke:var(--blue-mid); }
    .card-title { font-size:18px; font-weight:600; color:var(--text-main); }
    .card-sub   { font-size:12px; color:var(--text-muted); margin-top:2px; }

    .form-group { margin-bottom:16px; }
    .form-label { display:block; font-size:12px; font-weight:500; color:var(--text-muted); margin-bottom:6px; }
    .form-input { width:100%; padding:10px 12px; border:1px solid var(--border); border-radius:var(--radius-md); font-size:14px; font-family:'DM Sans',sans-serif; color:var(--text-main); background:var(--gray-bg); outline:none; transition:border-color 0.15s; }
    .form-input:focus { border-color:var(--blue-mid); background:var(--white); }
    .btn-login { width:100%; padding:11px; background:var(--blue-dark); color:#fff; border:none; border-radius:var(--radius-md); font-size:14px; font-weight:500; font-family:'DM Sans',sans-serif; cursor:pointer; margin-top:4px; transition:background 0.15s; }
    .btn-login:hover { background:var(--blue-mid); }

    .back-link { text-align:center; font-size:13px; color:var(--text-muted); margin-top:18px; }
    .back-link a { color:var(--blue-mid); text-decoration:none; font-weight:500; }
  </style>
</head>
<body>
<nav>
  <a href="index.jsp" class="logo">
    <div class="logo-icon">
      <svg viewBox="0 0 24 24" fill="none" stroke="#B5D4F4" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <rect x="5" y="11" width="14" height="10" rx="2"/>
        <path d="M8 11V7a4 4 0 018 0v4"/>
        <circle cx="12" cy="16" r="1" fill="#B5D4F4"/>
      </svg>
    </div>
    <div>
      <div class="logo-text">SecureRank</div>
      <div class="logo-sub">Cloud Search System</div>
    </div>
  </a>
  <a href="index.jsp" class="btn-home">← Home</a>
</nav>

<div class="page-wrap">
  <div class="form-card">
    <div class="card-top">
      <div class="card-icon">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <rect x="2" y="3" width="20" height="14" rx="2"/>
          <line x1="8" y1="21" x2="16" y2="21"/>
          <line x1="12" y1="17" x2="12" y2="21"/>
        </svg>
      </div>
      <div>
        <div class="card-title">Admin Login</div>
        <div class="card-sub">Cloud Server Controller</div>
      </div>
    </div>

    <form action="CloudControllerLogin" method="post">
      <div class="form-group">
        <label class="form-label">Email Address</label>
        <input type="email" name="email" class="form-input"
               placeholder="admin@securerank.com" required />
      </div>
      <div class="form-group">
        <label class="form-label">Password</label>
        <input type="password" name="password" class="form-input"
               placeholder="Enter admin password" required />
      </div>
      <button type="submit" class="btn-login">Login to Admin Panel →</button>
    </form>

    <div class="back-link">
      <a href="index.jsp">← Back to Home</a>
    </div>
  </div>
</div>
</body>
</html>
