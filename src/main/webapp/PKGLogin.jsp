<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>PKG Login — SecureRank</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
    :root {
      --purple-dark:#2D2785; --purple-mid:#534AB7; --purple-light:#EEEDFE; --purple-bdr:#C5C2F5;
      --text-main:#1A1A18; --text-muted:#5F5E5A;
      --border:rgba(0,0,0,0.09); --white:#fff; --gray-bg:#F7F6F3;
      --radius-md:10px; --radius-lg:14px;
    }
    body { font-family:'DM Sans',sans-serif; background:var(--gray-bg); min-height:100vh; display:flex; flex-direction:column; }
    nav  { background:var(--white); border-bottom:1px solid var(--border); padding:0 40px; height:60px; display:flex; align-items:center; justify-content:space-between; }
    .logo { display:flex; align-items:center; gap:10px; text-decoration:none; }
    .logo-icon { width:36px; height:36px; background:var(--purple-mid); border-radius:var(--radius-md); display:flex; align-items:center; justify-content:center; }
    .logo-icon svg { width:18px; height:18px; }
    .logo-text { font-size:15px; font-weight:600; color:var(--text-main); }
    .logo-sub  { font-size:11px; color:var(--text-muted); font-family:'DM Mono',monospace; }
    .btn-home  { font-size:13px; color:var(--text-muted); text-decoration:none; }
    .btn-home:hover { color:var(--purple-mid); }
    .page-wrap { flex:1; display:flex; align-items:center; justify-content:center; padding:40px 20px; }
    .form-card { width:380px; background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); padding:36px 32px; }
    .card-top  { display:flex; align-items:center; gap:14px; margin-bottom:28px; }
    .card-icon { width:44px; height:44px; background:var(--purple-light); border-radius:var(--radius-md); display:flex; align-items:center; justify-content:center; }
    .card-icon svg { width:22px; height:22px; stroke:var(--purple-mid); }
    .card-title { font-size:18px; font-weight:600; }
    .card-sub   { font-size:12px; color:var(--text-muted); margin-top:2px; }
    .form-group { margin-bottom:16px; }
    .form-label { display:block; font-size:12px; font-weight:500; color:var(--text-muted); margin-bottom:6px; }
    .form-input { width:100%; padding:10px 12px; border:1px solid var(--border); border-radius:var(--radius-md); font-size:14px; font-family:'DM Sans',sans-serif; background:var(--gray-bg); outline:none; transition:border-color 0.15s; }
    .form-input:focus { border-color:var(--purple-mid); background:var(--white); }
    .btn-login { width:100%; padding:11px; background:var(--purple-mid); color:#fff; border:none; border-radius:var(--radius-md); font-size:14px; font-weight:500; font-family:'DM Sans',sans-serif; cursor:pointer; transition:background 0.15s; }
    .btn-login:hover { background:var(--purple-dark); }
    .back-link { text-align:center; font-size:13px; color:var(--text-muted); margin-top:18px; }
    .back-link a { color:var(--purple-mid); text-decoration:none; font-weight:500; }
  </style>
</head>
<body>
<nav>
  <a href="index.jsp" class="logo">
    <div class="logo-icon">
      <svg viewBox="0 0 24 24" fill="none" stroke="#C5C2F5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 11-7.778 7.778 5.5 5.5 0 017.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"/>
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
          <path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 11-7.778 7.778 5.5 5.5 0 017.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"/>
        </svg>
      </div>
      <div>
        <div class="card-title">PKG Login</div>
        <div class="card-sub">Private Key Generator</div>
      </div>
    </div>
    <form action="LoginServlet" method="post">
      <input type="hidden" name="role" value="pkg" />
      <div class="form-group">
        <label class="form-label">Email Address</label>
        <input type="email" name="email" class="form-input" placeholder="pkg@securerank.com" required />
      </div>
      <div class="form-group">
        <label class="form-label">Password</label>
        <input type="password" name="password" class="form-input" placeholder="Enter password" required />
      </div>
      <button type="submit" class="btn-login">Login as PKG →</button>
    </form>
    <div class="back-link"><a href="index.jsp">← Back to Home</a></div>
  </div>
</div>
</body>
</html>
