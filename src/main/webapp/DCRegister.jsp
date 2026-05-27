<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><title>Data Consumer Register — SecureRank</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
  <style>
    *{box-sizing:border-box;margin:0;padding:0}
    :root{--c:#854F0B;--cl:#FAEEDA;--border:rgba(0,0,0,0.09);--white:#fff;--gray:#F7F6F3;--muted:#5F5E5A;--r:10px}
    body{font-family:'DM Sans',sans-serif;background:var(--gray);min-height:100vh;display:flex;flex-direction:column}
    nav{background:var(--white);border-bottom:1px solid var(--border);padding:0 40px;height:60px;display:flex;align-items:center;justify-content:space-between}
    .logo{display:flex;align-items:center;gap:10px;text-decoration:none}
    .li{width:36px;height:36px;background:var(--c);border-radius:var(--r);display:flex;align-items:center;justify-content:center}
    .lt{font-size:15px;font-weight:600;color:#1A1A18}.ls{font-size:11px;color:var(--muted)}
    .bh{font-size:13px;color:var(--muted);text-decoration:none}.bh:hover{color:var(--c)}
    .pw{flex:1;display:flex;align-items:center;justify-content:center;padding:40px 20px}
    .fc{width:460px;background:var(--white);border:1px solid var(--border);border-radius:14px;padding:36px 32px}
    h2{font-size:18px;font-weight:600;margin-bottom:4px}.sub{font-size:12px;color:var(--muted);margin-bottom:22px}
    .row{display:grid;grid-template-columns:1fr 1fr;gap:14px}
    .fg{margin-bottom:14px}
    label{display:block;font-size:12px;font-weight:500;color:var(--muted);margin-bottom:5px}
    input,textarea{width:100%;padding:10px 12px;border:1px solid var(--border);border-radius:var(--r);font-size:14px;font-family:'DM Sans',sans-serif;background:var(--gray);outline:none}
    input:focus,textarea:focus{border-color:var(--c);background:var(--white)}
    textarea{resize:vertical;min-height:70px}
    .ni{background:var(--cl);border:1px solid #F0C98A;border-radius:var(--r);padding:12px;font-size:12px;color:var(--c);margin-bottom:18px}
    .btn{width:100%;padding:11px;background:var(--c);color:#fff;border:none;border-radius:var(--r);font-size:14px;font-weight:500;font-family:'DM Sans',sans-serif;cursor:pointer}
    .btn:hover{background:#5c3708}
    .ll{text-align:center;font-size:13px;color:var(--muted);margin-top:16px}
    .ll a{color:var(--c);text-decoration:none;font-weight:500}
    @media(max-width:480px){.row{grid-template-columns:1fr}.fc{width:100%;padding:24px 18px}}
  </style>
</head>
<body>
<nav>
  <a href="index.jsp" class="logo">
    <div class="li"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#F0C98A" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg></div>
    <div><div class="lt">SecureRank</div><div class="ls">Cloud Search System</div></div>
  </a>
  <a href="DCLogin.jsp" class="bh">← Login</a>
</nav>
<div class="pw">
  <div class="fc">
    <h2>Register as Data Consumer</h2>
    <p class="sub">Search and download encrypted files from the cloud.</p>
    <div class="ni">After registration your account will be <strong>Pending</strong>. Admin must approve before you can login.</div>
    <form action="DCRegister" method="post">
      <div class="row">
        <div class="fg"><label>Full Name *</label><input type="text" name="name" placeholder="Your full name" required /></div>
        <div class="fg"><label>Mobile</label><input type="tel" name="mobile" placeholder="10-digit number" /></div>
      </div>
      <div class="fg"><label>Email Address *</label><input type="email" name="email" placeholder="you@example.com" required /></div>
      <div class="fg"><label>Password *</label><input type="password" name="password" placeholder="Minimum 6 characters" required minlength="6" /></div>
      <div class="fg"><label>Address</label><textarea name="address" placeholder="Your address (optional)"></textarea></div>
      <button type="submit" class="btn">Register as Data Consumer</button>
    </form>
    <div class="ll">Already registered? <a href="DCLogin.jsp">Login here</a></div>
  </div>
</div>
</body>
</html>
