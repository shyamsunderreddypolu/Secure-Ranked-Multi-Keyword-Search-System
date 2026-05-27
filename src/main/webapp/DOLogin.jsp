<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Data Owner Login — SecureRank</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
    :root {
      --teal-mid:#0F6E56; --teal-light:#E1F5EE; --teal-bdr:#A8DFC9;
      --text-main:#1A1A18; --text-muted:#5F5E5A;
      --border:rgba(0,0,0,0.09); --white:#fff; --gray-bg:#F7F6F3;
      --radius-md:10px; --radius-lg:14px;
    }
    body { font-family:'DM Sans',sans-serif; background:var(--gray-bg); min-height:100vh; display:flex; flex-direction:column; }
    nav  { background:var(--white); border-bottom:1px solid var(--border); padding:0 40px; height:60px; display:flex; align-items:center; justify-content:space-between; }
    .logo { display:flex; align-items:center; gap:10px; text-decoration:none; }
    .logo-icon { width:36px; height:36px; background:var(--teal-mid); border-radius:var(--radius-md); display:flex; align-items:center; justify-content:center; }
    .logo-icon svg { width:18px; height:18px; }
    .logo-text { font-size:15px; font-weight:600; color:var(--text-main); }
    .logo-sub  { font-size:11px; color:var(--text-muted); font-family:'DM Mono',monospace; }
    .btn-home  { font-size:13px; color:var(--text-muted); text-decoration:none; }
    .btn-home:hover { color:var(--teal-mid); }
    .page-wrap { flex:1; display:flex; align-items:center; justify-content:center; padding:40px 20px; }
    .form-card { width:380px; background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); padding:36px 32px; }
    .card-top  { display:flex; align-items:center; gap:14px; margin-bottom:28px; }
    .card-icon { width:44px; height:44px; background:var(--teal-light); border-radius:var(--radius-md); display:flex; align-items:center; justify-content:center; }
    .card-icon svg { width:22px; height:22px; stroke:var(--teal-mid); }
    .card-title { font-size:18px; font-weight:600; }
    .card-sub   { font-size:12px; color:var(--text-muted); margin-top:2px; }
    .form-group { margin-bottom:16px; }
    .form-label { display:block; font-size:12px; font-weight:500; color:var(--text-muted); margin-bottom:6px; }
    .form-input { width:100%; padding:10px 12px; border:1px solid var(--border); border-radius:var(--radius-md); font-size:14px; font-family:'DM Sans',sans-serif; background:var(--gray-bg); outline:none; transition:border-color 0.15s; }
    .form-input:focus { border-color:var(--teal-mid); background:var(--white); }
    .btn-login { width:100%; padding:11px; background:var(--teal-mid); color:#fff; border:none; border-radius:var(--radius-md); font-size:14px; font-weight:500; font-family:'DM Sans',sans-serif; cursor:pointer; transition:background 0.15s; }
    .btn-login:hover { background:#0A4F3C; }
    .divider { border:none; border-top:1px solid var(--border); margin:20px 0; }
    .register-link { text-align:center; font-size:13px; color:var(--text-muted); }
    .register-link a { color:var(--teal-mid); text-decoration:none; font-weight:500; }
    .back-link { text-align:center; font-size:13px; color:var(--text-muted); margin-top:12px; }
    .back-link a { color:var(--teal-mid); text-decoration:none; font-weight:500; }
  </style>
</head>
<body>
<nav>
  <a href="index.jsp" class="logo">
    <div class="logo-icon">
      <svg viewBox="0 0 24 24" fill="none" stroke="#A8DFC9" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/>
        <polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/>
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
          <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/>
          <polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/>
        </svg>
      </div>
      <div>
        <div class="card-title">Data Owner Login</div>
        <div class="card-sub">Encrypt &amp; Upload Files</div>
      </div>
    </div>
    <form action="DOLogin" method="post">
      <div class="form-group">
        <label class="form-label">Email Address</label>
        <input type="email" name="email" class="form-input" placeholder="alice@securerank.com" required />
      </div>
      <div class="form-group">
        <label class="form-label">Password</label>
        <input type="password" name="password" class="form-input" placeholder="Enter password" required />
      </div>
      <button type="submit" class="btn-login">Login as Data Owner →</button>
    </form>
    <hr class="divider" />
    <div class="register-link">New here? <a href="DORegister.jsp">Register as Data Owner</a></div>
    <div class="back-link"><a href="index.jsp">← Back to Home</a></div>
  </div>
</div>
</body>
</html>
