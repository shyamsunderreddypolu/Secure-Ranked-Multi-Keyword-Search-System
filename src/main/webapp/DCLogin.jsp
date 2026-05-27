<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><title>Data Consumer Login — SecureRank</title>
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
    .fc{width:380px;background:var(--white);border:1px solid var(--border);border-radius:14px;padding:36px 32px}
    .ct{display:flex;align-items:center;gap:14px;margin-bottom:28px}
    .ci{width:44px;height:44px;background:var(--cl);border-radius:var(--r);display:flex;align-items:center;justify-content:center}
    .ci svg{width:22px;height:22px;stroke:var(--c)}
    h2{font-size:18px;font-weight:600}.sub{font-size:12px;color:var(--muted);margin-top:2px}
    .fg{margin-bottom:16px}
    label{display:block;font-size:12px;font-weight:500;color:var(--muted);margin-bottom:6px}
    input{width:100%;padding:10px 12px;border:1px solid var(--border);border-radius:var(--r);font-size:14px;font-family:'DM Sans',sans-serif;background:var(--gray);outline:none}
    input:focus{border-color:var(--c);background:var(--white)}
    .btn{width:100%;padding:11px;background:var(--c);color:#fff;border:none;border-radius:var(--r);font-size:14px;font-weight:500;font-family:'DM Sans',sans-serif;cursor:pointer}
    .btn:hover{background:#5c3708}
    hr{border:none;border-top:1px solid var(--border);margin:20px 0}
    .ll{text-align:center;font-size:13px;color:var(--muted)}
    .ll a{color:var(--c);text-decoration:none;font-weight:500}
  </style>
</head>
<body>
<nav>
  <a href="index.jsp" class="logo">
    <div class="li"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#F0C98A" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg></div>
    <div><div class="lt">SecureRank</div><div class="ls">Cloud Search System</div></div>
  </a>
  <a href="index.jsp" class="bh">← Home</a>
</nav>
<div class="pw">
  <div class="fc">
    <div class="ct">
      <div class="ci"><svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg></div>
      <div><h2>Data Consumer Login</h2><p class="sub">Search &amp; Download Encrypted Files</p></div>
    </div>
    <form action="DCLogin" method="post">
      <div class="fg"><label>Email Address</label><input type="email" name="email" placeholder="bob@securerank.com" required /></div>
      <div class="fg"><label>Password</label><input type="password" name="password" placeholder="Enter password" required /></div>
      <button type="submit" class="btn">Login as Data Consumer →</button>
    </form>
    <hr />
    <div class="ll">New here? <a href="DCRegister.jsp">Register as Data Consumer</a></div>
    <div class="ll" style="margin-top:10px"><a href="index.jsp">← Back to Home</a></div>
  </div>
</div>
</body>
</html>
