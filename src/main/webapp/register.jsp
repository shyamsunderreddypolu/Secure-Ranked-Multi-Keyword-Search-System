<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register — RBDC Secure Cloud Search</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
    :root {
      --blue-dark:#042C53; --blue-mid:#185FA5; --blue-light:#E6F1FB; --blue-bdr:#B5D4F4;
      --teal-bg:#E1F5EE; --teal-mid:#0F6E56;
      --amber-bg:#FAEEDA; --amber-mid:#854F0B;
      --gray-bg:#F5F5F3; --text-main:#1A1A18; --text-muted:#5F5E5A; --text-faint:#A0A09A;
      --border:rgba(0,0,0,0.09); --white:#ffffff;
      --radius-md:10px; --radius-lg:14px;
    }
    body { font-family:'DM Sans',sans-serif; background:#F7F6F3; color:var(--text-main); min-height:100vh; display:flex; flex-direction:column; }
    nav { background:var(--white); border-bottom:1px solid var(--border); padding:0 40px; height:60px; display:flex; align-items:center; justify-content:space-between; }
    .logo { display:flex; align-items:center; gap:10px; text-decoration:none; }
    .logo-icon { width:36px; height:36px; background:var(--blue-dark); border-radius:var(--radius-md); display:flex; align-items:center; justify-content:center; }
    .logo-icon svg { width:18px; height:18px; }
    .logo-text { font-size:15px; font-weight:600; color:var(--text-main); }
    .logo-sub  { font-size:11px; color:var(--text-muted); font-family:'DM Mono',monospace; }
    .nav-back  { font-size:13px; color:var(--text-muted); text-decoration:none; }
    .nav-back:hover { color:var(--text-main); }

    .page-wrap { flex:1; display:flex; align-items:center; justify-content:center; padding:40px 20px; }

    .form-card { width:480px; background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); padding:36px 32px; }
    .card-top  { display:flex; align-items:center; gap:16px; margin-bottom:28px; }
    .card-icon { width:44px; height:44px; border-radius:var(--radius-md); display:flex; align-items:center; justify-content:center; }
    .card-icon svg { width:22px; height:22px; }
    .card-title { font-size:20px; font-weight:600; color:var(--text-main); }
    .card-sub   { font-size:13px; color:var(--text-muted); margin-top:2px; }

    .role-tabs { display:flex; gap:8px; margin-bottom:24px; }
    .role-tab {
      flex:1; padding:9px; border:1px solid var(--border); border-radius:var(--radius-md);
      font-size:13px; font-weight:500; background:var(--gray-bg); color:var(--text-muted);
      cursor:pointer; text-align:center; font-family:'DM Sans',sans-serif; transition:all 0.15s;
    }
    .role-tab.active.do  { background:var(--teal-bg);  color:var(--teal-mid);  border-color:var(--teal-mid); }
    .role-tab.active.dc  { background:var(--amber-bg); color:var(--amber-mid); border-color:var(--amber-mid); }
    .role-tab:hover { border-color:var(--blue-bdr); }

    .form-row { display:grid; grid-template-columns:1fr 1fr; gap:14px; margin-bottom:14px; }
    .form-group { margin-bottom:14px; }
    .form-label { display:block; font-size:12px; font-weight:500; color:var(--text-muted); margin-bottom:6px; }
    .form-input { width:100%; padding:10px 12px; border:1px solid var(--border); border-radius:var(--radius-md); font-size:14px; font-family:'DM Sans',sans-serif; color:var(--text-main); background:var(--gray-bg); outline:none; transition:border-color 0.15s,background 0.15s; }
    .form-input:focus { border-color:var(--blue-mid); background:var(--white); }
    textarea.form-input { resize:vertical; min-height:76px; }

    .notice { display:flex; gap:10px; background:var(--blue-light); border:1px solid var(--blue-bdr); border-radius:var(--radius-md); padding:12px 14px; margin-bottom:18px; }
    .notice-icon { flex-shrink:0; margin-top:1px; }
    .notice-icon svg { width:16px; height:16px; stroke:var(--blue-mid); }
    .notice-text { font-size:12px; color:var(--blue-mid); line-height:1.55; }

    .btn-submit { width:100%; padding:11px; background:var(--blue-mid); color:#fff; border:none; border-radius:var(--radius-md); font-size:14px; font-weight:500; font-family:'DM Sans',sans-serif; cursor:pointer; transition:background 0.15s; }
    .btn-submit:hover { background:var(--blue-dark); }
    .btn-submit.do { background:var(--teal-mid); }
    .btn-submit.do:hover { background:#0a4f3c; }
    .btn-submit.dc { background:var(--amber-mid); }
    .btn-submit.dc:hover { background:#5c3708; }

    .login-link { text-align:center; font-size:13px; color:var(--text-muted); margin-top:18px; }
    .login-link a { color:var(--blue-mid); text-decoration:none; font-weight:500; }
    .login-link a:hover { text-decoration:underline; }

    @media(max-width:520px){ .form-card{width:100%;padding:24px 18px;} .form-row{grid-template-columns:1fr;} }
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
      <div class="logo-text">RBDC System</div>
      <div class="logo-sub">Secure Cloud Search</div>
    </div>
  </a>
  <a href="login.jsp" class="nav-back">← Back to Login</a>
</nav>

<div class="page-wrap">
  <div class="form-card">

    <div class="card-top">
      <div class="card-icon" id="cardIcon" style="background:var(--teal-bg);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#0F6E56" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/>
          <polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/>
        </svg>
      </div>
      <div>
        <div class="card-title" id="cardTitle">Create Data Owner Account</div>
        <div class="card-sub">Register to start uploading encrypted files</div>
      </div>
    </div>

    <!-- Role Tabs -->
    <div class="role-tabs">
      <button class="role-tab do active" onclick="switchRole('dataowner', this)">Data Owner</button>
      <button class="role-tab dc"        onclick="switchRole('dataconsumer', this)">Data Consumer</button>
    </div>

    <!-- Notice -->
    <div class="notice">
      <div class="notice-icon">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><circle cx="12" cy="16" r="0.5" fill="currentColor"/>
        </svg>
      </div>
      <div class="notice-text">After registration your account will be in <strong>Pending</strong> status. You can login only after the Admin approves your account.</div>
    </div>

    <!-- Registration Form -->
    <form action="RegisterServlet" method="post">
      <input type="hidden" name="role" id="roleField" value="dataowner" />

      <div class="form-row">
        <div class="form-group">
          <label class="form-label">Full Name *</label>
          <input type="text" name="name" class="form-input" placeholder="Your full name" required />
        </div>
        <div class="form-group">
          <label class="form-label">Mobile Number</label>
          <input type="tel" name="mobile" class="form-input" placeholder="10-digit number" />
        </div>
      </div>

      <div class="form-group">
        <label class="form-label">Email Address *</label>
        <input type="email" name="email" class="form-input" placeholder="you@example.com" required />
      </div>

      <div class="form-group">
        <label class="form-label">Password *</label>
        <input type="password" name="password" class="form-input" placeholder="Minimum 6 characters" required minlength="6" />
      </div>

      <div class="form-group">
        <label class="form-label">Address</label>
        <textarea name="address" class="form-input" placeholder="Your address (optional)"></textarea>
      </div>

      <button type="submit" class="btn-submit do" id="submitBtn">Register as Data Owner</button>
    </form>

    <div class="login-link">Already have an account? <a href="login.jsp">Login here</a></div>
  </div>
</div>

<script>
  // Pre-select role from URL param
  var params = new URLSearchParams(window.location.search);
  var roleParam = params.get('role');
  if (roleParam === 'dataconsumer') {
    document.querySelectorAll('.role-tab').forEach(function(t){ t.classList.remove('active'); });
    document.querySelector('.role-tab.dc').classList.add('active');
    setDCMode();
  }

  function switchRole(role, el) {
    document.querySelectorAll('.role-tab').forEach(function(t){ t.classList.remove('active'); });
    el.classList.add('active');
    if (role === 'dataowner') {
      setDOMode();
    } else {
      setDCMode();
    }
  }

  function setDOMode() {
    document.getElementById('roleField').value = 'dataowner';
    document.getElementById('cardTitle').textContent = 'Create Data Owner Account';
    document.getElementById('submitBtn').textContent = 'Register as Data Owner';
    document.getElementById('submitBtn').className = 'btn-submit do';
    document.getElementById('cardIcon').style.background = 'var(--teal-bg)';
    document.getElementById('cardIcon').querySelector('svg').setAttribute('stroke', '#0F6E56');
  }

  function setDCMode() {
    document.getElementById('roleField').value = 'dataconsumer';
    document.getElementById('cardTitle').textContent = 'Create Data Consumer Account';
    document.getElementById('submitBtn').textContent = 'Register as Data Consumer';
    document.getElementById('submitBtn').className = 'btn-submit dc';
    document.getElementById('cardIcon').style.background = 'var(--amber-bg)';
    document.getElementById('cardIcon').querySelector('svg').setAttribute('stroke', '#854F0B');
  }
</script>

</body>
</html>
