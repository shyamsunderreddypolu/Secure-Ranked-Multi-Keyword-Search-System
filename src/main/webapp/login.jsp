<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login — RBDC Secure Cloud Search</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    :root {
      --blue-dark:  #042C53;
      --blue-mid:   #185FA5;
      --blue-light: #E6F1FB;
      --blue-bdr:   #B5D4F4;
      --teal-bg:    #E1F5EE;
      --teal-mid:   #0F6E56;
      --purple-bg:  #EEEDFE;
      --purple-mid: #534AB7;
      --amber-bg:   #FAEEDA;
      --amber-mid:  #854F0B;
      --gray-bg:    #F5F5F3;
      --text-main:  #1A1A18;
      --text-muted: #5F5E5A;
      --text-faint: #A0A09A;
      --border:     rgba(0,0,0,0.09);
      --white:      #ffffff;
      --radius-md:  10px;
      --radius-lg:  14px;
    }
    body {
      font-family: 'DM Sans', sans-serif;
      background: #F7F6F3;
      color: var(--text-main);
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }

    /* ─── NAV ──────────────────────────────── */
    nav {
      background: var(--white);
      border-bottom: 1px solid var(--border);
      padding: 0 40px;
      height: 60px;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
    .logo { display:flex; align-items:center; gap:10px; text-decoration:none; }
    .logo-icon {
      width:36px; height:36px; background:var(--blue-dark);
      border-radius:var(--radius-md); display:flex; align-items:center; justify-content:center;
    }
    .logo-icon svg { width:18px; height:18px; }
    .logo-text { font-size:15px; font-weight:600; color:var(--text-main); line-height:1.2; }
    .logo-sub  { font-size:11px; color:var(--text-muted); font-family:'DM Mono',monospace; }
    .nav-back  { font-size:13px; color:var(--text-muted); text-decoration:none; }
    .nav-back:hover { color:var(--text-main); }

    /* ─── MAIN ─────────────────────────────── */
    .page-wrap {
      flex:1; display:flex; align-items:center;
      justify-content:center; padding:40px 20px;
      gap:48px;
    }

    /* ─── ROLE PICKER ──────────────────────── */
    .role-panel { width:240px; }
    .panel-label {
      font-size:11px; font-weight:500; color:var(--text-faint);
      text-transform:uppercase; letter-spacing:0.08em;
      margin-bottom:14px;
    }
    .role-btn {
      width:100%; display:flex; align-items:center; gap:12px;
      padding:12px 14px; background:var(--white);
      border:1px solid var(--border); border-radius:var(--radius-md);
      margin-bottom:8px; cursor:pointer; text-align:left;
      transition:border-color 0.15s, box-shadow 0.15s;
      font-family:'DM Sans',sans-serif;
    }
    .role-btn:hover { border-color:var(--blue-bdr); }
    .role-btn.active {
      border-color:var(--blue-mid);
      box-shadow:0 0 0 3px rgba(24,95,165,0.12);
    }
    .role-dot {
      width:32px; height:32px; border-radius:8px;
      display:flex; align-items:center; justify-content:center; flex-shrink:0;
    }
    .role-dot svg { width:16px; height:16px; }
    .role-info { flex:1; }
    .role-title { font-size:13px; font-weight:600; color:var(--text-main); }
    .role-hint  { font-size:11px; color:var(--text-muted); margin-top:1px; }

    /* ─── FORM CARD ────────────────────────── */
    .form-card {
      width:360px; background:var(--white);
      border:1px solid var(--border); border-radius:var(--radius-lg);
      padding:32px 28px;
    }
    .card-title { font-size:20px; font-weight:600; color:var(--text-main); margin-bottom:4px; }
    .card-sub   { font-size:13px; color:var(--text-muted); margin-bottom:28px; }
    .form-group { margin-bottom:16px; }
    .form-label { display:block; font-size:12px; font-weight:500; color:var(--text-muted); margin-bottom:6px; }
    .form-input {
      width:100%; padding:10px 12px; border:1px solid var(--border);
      border-radius:var(--radius-md); font-size:14px;
      font-family:'DM Sans',sans-serif; color:var(--text-main);
      background:var(--gray-bg); outline:none;
      transition:border-color 0.15s, background 0.15s;
    }
    .form-input:focus { border-color:var(--blue-mid); background:var(--white); }
    .hidden-role { display:none; }

    .btn-submit {
      width:100%; padding:11px; background:var(--blue-mid);
      color:#fff; border:none; border-radius:var(--radius-md);
      font-size:14px; font-weight:500; font-family:'DM Sans',sans-serif;
      cursor:pointer; margin-top:4px; transition:background 0.15s;
    }
    .btn-submit:hover { background:var(--blue-dark); }

    .divider { border:none; border-top:1px solid var(--border); margin:20px 0; }

    .register-link {
      text-align:center; font-size:13px; color:var(--text-muted);
    }
    .register-link a { color:var(--blue-mid); text-decoration:none; font-weight:500; }
    .register-link a:hover { text-decoration:underline; }

    /* ─── ROLE COLOR MAP ───────────────────── */
    .dot-admin    { background:#F1EFE8; }
    .dot-do       { background:var(--teal-bg); }
    .dot-dc       { background:var(--amber-bg); }
    .dot-pkg      { background:var(--purple-bg); }
    .ic-admin     { stroke:#5F5E5A; }
    .ic-do        { stroke:#0F6E56; }
    .ic-dc        { stroke:#854F0B; }
    .ic-pkg       { stroke:#534AB7; }

    @media(max-width:700px){
      .page-wrap { flex-direction:column; align-items:stretch; }
      .role-panel{ width:100%; }
      .form-card { width:100%; }
    }
  </style>
</head>
<body>

<!-- NAV -->
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
  <a href="index.jsp" class="nav-back">← Back to Home</a>
</nav>

<!-- MAIN -->
<div class="page-wrap">

  <!-- LEFT: Role Picker -->
  <div class="role-panel">
    <div class="panel-label">Select your role</div>

    <button class="role-btn" onclick="selectRole('admin', this)">
      <div class="role-dot dot-admin">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="ic-admin">
          <circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/>
        </svg>
      </div>
      <div class="role-info">
        <div class="role-title">Admin / Cloud Server</div>
        <div class="role-hint">Manage users &amp; monitor system</div>
      </div>
    </button>

    <button class="role-btn active" onclick="selectRole('dataowner', this)">
      <div class="role-dot dot-do">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="ic-do">
          <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/>
          <polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/>
        </svg>
      </div>
      <div class="role-info">
        <div class="role-title">Data Owner</div>
        <div class="role-hint">Encrypt &amp; upload files</div>
      </div>
    </button>

    <button class="role-btn" onclick="selectRole('dataconsumer', this)">
      <div class="role-dot dot-dc">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="ic-dc">
          <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
        </svg>
      </div>
      <div class="role-info">
        <div class="role-title">Data Consumer</div>
        <div class="role-hint">Search &amp; download files</div>
      </div>
    </button>

    <button class="role-btn" onclick="selectRole('pkg', this)">
      <div class="role-dot dot-pkg">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="ic-pkg">
          <path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 11-7.778 7.778 5.5 5.5 0 017.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"/>
        </svg>
      </div>
      <div class="role-info">
        <div class="role-title">PKG</div>
        <div class="role-hint">Generate private keys</div>
      </div>
    </button>
  </div>

  <!-- RIGHT: Login Form -->
  <div class="form-card">
    <div class="card-title" id="formTitle">Data Owner Login</div>
    <div class="card-sub"  id="formSub">Enter your credentials to continue</div>

    <form action="LoginServlet" method="post">

      <!-- Hidden role field — updated by JS when role changes -->
      <input type="hidden" name="role" id="roleField" value="dataowner" />

      <div class="form-group">
        <label class="form-label" for="email">Email Address</label>
        <input type="email" id="email" name="email"
               class="form-input" placeholder="you@example.com" required />
      </div>

      <div class="form-group">
        <label class="form-label" for="password">Password</label>
        <input type="password" id="password" name="password"
               class="form-input" placeholder="Enter your password" required />
      </div>

      <button type="submit" class="btn-submit" id="submitBtn">
        Login as Data Owner →
      </button>
    </form>

    <hr class="divider" />

    <div class="register-link" id="registerLine">
      New Data Owner?
      <a href="register.jsp?role=dataowner">Register here</a>
    </div>
  </div>

</div>

<script>
  // Role metadata for dynamic UI updates
  var roles = {
    admin:        { title:"Admin / Cloud Server Login", sub:"Cloud Server credentials required", btn:"Login as Admin →",         reg:null },
    dataowner:    { title:"Data Owner Login",           sub:"Enter your credentials to continue", btn:"Login as Data Owner →",   reg:"New Data Owner? <a href='register.jsp?role=dataowner'>Register here</a>" },
    dataconsumer: { title:"Data Consumer Login",        sub:"Enter your credentials to continue", btn:"Login as Data Consumer →", reg:"New Data Consumer? <a href='register.jsp?role=dataconsumer'>Register here</a>" },
    pkg:          { title:"PKG Login",                  sub:"Private Key Generator credentials",  btn:"Login as PKG →",           reg:null }
  };

  function selectRole(role, el) {
    // Update active button
    document.querySelectorAll('.role-btn').forEach(function(b){ b.classList.remove('active'); });
    el.classList.add('active');

    // Update form
    var r = roles[role];
    document.getElementById('roleField').value   = role;
    document.getElementById('formTitle').textContent = r.title;
    document.getElementById('formSub').textContent   = r.sub;
    document.getElementById('submitBtn').textContent = r.btn;
    document.getElementById('registerLine').innerHTML = r.reg
        ? r.reg
        : '<span style="color:var(--text-faint);font-size:12px;">Contact Admin for account setup</span>';
  }
</script>

</body>
</html>
