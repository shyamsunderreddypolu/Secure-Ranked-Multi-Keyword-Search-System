<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>RBDC – Rankable Boolean Dynamic Cloud Search</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --blue-dark:   #042C53;
      --blue-mid:    #185FA5;
      --blue-light:  #E6F1FB;
      --blue-border: #B5D4F4;
      --teal-bg:     #E1F5EE;
      --teal-mid:    #0F6E56;
      --purple-bg:   #EEEDFE;
      --purple-mid:  #534AB7;
      --amber-bg:    #FAEEDA;
      --amber-mid:   #854F0B;
      --gray-bg:     #F5F5F3;
      --gray-mid:    #888780;
      --text-main:   #1A1A18;
      --text-muted:  #5F5E5A;
      --text-faint:  #A0A09A;
      --border:      rgba(0,0,0,0.09);
      --white:       #ffffff;
      --radius-sm:   6px;
      --radius-md:   10px;
      --radius-lg:   14px;
    }

    body {
      font-family: 'DM Sans', sans-serif;
      background: #F7F6F3;
      color: var(--text-main);
      min-height: 100vh;
    }

    /* ─── NAV ─────────────────────────────────────────── */
    nav {
      background: var(--white);
      border-bottom: 1px solid var(--border);
      padding: 0 40px;
      height: 60px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      position: sticky;
      top: 0;
      z-index: 100;
    }

    .logo {
      display: flex;
      align-items: center;
      gap: 10px;
      text-decoration: none;
    }

    .logo-icon {
      width: 36px;
      height: 36px;
      background: var(--blue-dark);
      border-radius: var(--radius-md);
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .logo-icon svg { width: 18px; height: 18px; }

    .logo-text {
      font-size: 15px;
      font-weight: 600;
      color: var(--text-main);
      line-height: 1.2;
    }

    .logo-sub {
      font-size: 11px;
      color: var(--text-muted);
      font-family: 'DM Mono', monospace;
    }

    .nav-right {
      display: flex;
      align-items: center;
      gap: 28px;
    }

    .nav-link {
      font-size: 13px;
      color: var(--text-muted);
      text-decoration: none;
      transition: color 0.15s;
    }

    .nav-link:hover { color: var(--text-main); }

    .btn-primary {
      background: var(--blue-mid);
      color: #fff;
      border: none;
      padding: 8px 18px;
      border-radius: var(--radius-md);
      font-size: 13px;
      font-weight: 500;
      font-family: 'DM Sans', sans-serif;
      cursor: pointer;
      text-decoration: none;
      display: inline-block;
      transition: background 0.15s;
    }

    .btn-primary:hover { background: var(--blue-dark); }

    /* ─── HERO ────────────────────────────────────────── */
    .hero {
      background: var(--white);
      border-bottom: 1px solid var(--border);
      padding: 64px 40px 48px;
      text-align: center;
    }

    .badge {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      background: var(--blue-light);
      color: var(--blue-mid);
      border: 1px solid var(--blue-border);
      border-radius: 999px;
      padding: 5px 14px;
      font-size: 12px;
      font-weight: 500;
      margin-bottom: 22px;
    }

    .badge svg { width: 13px; height: 13px; }

    .hero h1 {
      font-size: 36px;
      font-weight: 600;
      color: var(--text-main);
      line-height: 1.25;
      max-width: 580px;
      margin: 0 auto 16px;
    }

    .hero h1 span { color: var(--blue-mid); }

    .hero p {
      font-size: 15px;
      color: var(--text-muted);
      max-width: 460px;
      margin: 0 auto 36px;
      line-height: 1.65;
    }

    .hero-stats {
      display: flex;
      justify-content: center;
      gap: 0;
      border: 1px solid var(--border);
      border-radius: var(--radius-lg);
      overflow: hidden;
      max-width: 480px;
      margin: 0 auto;
      background: var(--white);
    }

    .stat {
      flex: 1;
      padding: 16px 12px;
      text-align: center;
      border-right: 1px solid var(--border);
    }

    .stat:last-child { border-right: none; }

    .stat-num {
      font-size: 15px;
      font-weight: 600;
      color: var(--text-main);
      font-family: 'DM Mono', monospace;
    }

    .stat-label {
      font-size: 11px;
      color: var(--text-muted);
      margin-top: 3px;
    }

    /* ─── ROLES ───────────────────────────────────────── */
    .section {
      max-width: 920px;
      margin: 0 auto;
      padding: 40px 24px;
    }

    .section-title {
      font-size: 11px;
      font-weight: 500;
      color: var(--text-faint);
      text-transform: uppercase;
      letter-spacing: 0.08em;
      margin-bottom: 18px;
    }

    .roles-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 14px;
    }

    .role-card {
      background: var(--white);
      border: 1px solid var(--border);
      border-radius: var(--radius-lg);
      padding: 22px 18px;
      cursor: pointer;
      text-decoration: none;
      display: block;
      transition: box-shadow 0.18s, border-color 0.18s, transform 0.18s;
    }

    .role-card:hover {
      border-color: var(--blue-border);
      box-shadow: 0 4px 20px rgba(24,95,165,0.10);
      transform: translateY(-2px);
    }

    .role-card.featured {
      border: 2px solid var(--blue-mid);
    }

    .featured-badge {
      display: inline-block;
      background: var(--blue-light);
      color: var(--blue-mid);
      font-size: 10px;
      font-weight: 600;
      padding: 3px 9px;
      border-radius: 999px;
      margin-bottom: 12px;
      font-family: 'DM Mono', monospace;
      text-transform: uppercase;
      letter-spacing: 0.05em;
    }

    .role-icon {
      width: 40px;
      height: 40px;
      border-radius: var(--radius-md);
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 14px;
    }

    .role-icon svg { width: 20px; height: 20px; }

    .role-name {
      font-size: 14px;
      font-weight: 600;
      color: var(--text-main);
      margin-bottom: 6px;
    }

    .role-desc {
      font-size: 12px;
      color: var(--text-muted);
      line-height: 1.55;
    }

    .role-action {
      margin-top: 16px;
      font-size: 12px;
      font-weight: 500;
      color: var(--blue-mid);
      display: flex;
      align-items: center;
      gap: 4px;
    }

    /* ─── HOW IT WORKS ────────────────────────────────── */
    .steps-wrap {
      background: var(--white);
      border-top: 1px solid var(--border);
      border-bottom: 1px solid var(--border);
    }

    .steps-inner {
      max-width: 920px;
      margin: 0 auto;
      padding: 40px 24px;
    }

    .steps-grid {
      display: grid;
      grid-template-columns: repeat(5, 1fr);
      gap: 0;
      border: 1px solid var(--border);
      border-radius: var(--radius-lg);
      overflow: hidden;
    }

    .step {
      padding: 20px 16px;
      border-right: 1px solid var(--border);
      position: relative;
    }

    .step:last-child { border-right: none; }

    .step-num {
      font-size: 10px;
      font-family: 'DM Mono', monospace;
      color: var(--text-faint);
      margin-bottom: 10px;
    }

    .step-icon {
      width: 32px;
      height: 32px;
      border-radius: var(--radius-sm);
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 10px;
    }

    .step-icon svg { width: 16px; height: 16px; }

    .step-title {
      font-size: 13px;
      font-weight: 600;
      color: var(--text-main);
      margin-bottom: 4px;
    }

    .step-sub {
      font-size: 11px;
      color: var(--text-muted);
      line-height: 1.5;
    }

    /* ─── ALGORITHM PILLS ─────────────────────────────── */
    .algo-section {
      max-width: 920px;
      margin: 0 auto;
      padding: 32px 24px 40px;
    }

    .algo-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 12px;
    }

    .algo-card {
      background: var(--white);
      border: 1px solid var(--border);
      border-radius: var(--radius-lg);
      padding: 18px 16px;
    }

    .algo-tag {
      display: inline-block;
      font-family: 'DM Mono', monospace;
      font-size: 11px;
      font-weight: 500;
      padding: 3px 10px;
      border-radius: 999px;
      margin-bottom: 10px;
    }

    .algo-name {
      font-size: 13px;
      font-weight: 600;
      color: var(--text-main);
      margin-bottom: 5px;
    }

    .algo-desc {
      font-size: 11px;
      color: var(--text-muted);
      line-height: 1.5;
    }

    /* ─── FOOTER ──────────────────────────────────────── */
    footer {
      background: var(--white);
      border-top: 1px solid var(--border);
      padding: 18px 40px;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    .footer-left {
      font-size: 12px;
      color: var(--text-faint);
      font-family: 'DM Mono', monospace;
    }

    .footer-right {
      font-size: 12px;
      color: var(--text-faint);
    }

    /* ─── MODAL ───────────────────────────────────────── */
    .modal-overlay {
      display: none;
      position: fixed;
      inset: 0;
      background: rgba(0,0,0,0.35);
      z-index: 200;
      align-items: center;
      justify-content: center;
    }

    .modal-overlay.active { display: flex; }

    .modal {
      background: var(--white);
      border-radius: var(--radius-lg);
      padding: 32px 28px;
      width: 360px;
      border: 1px solid var(--border);
      position: relative;
    }

    .modal-title {
      font-size: 17px;
      font-weight: 600;
      color: var(--text-main);
      margin-bottom: 4px;
    }

    .modal-sub {
      font-size: 13px;
      color: var(--text-muted);
      margin-bottom: 24px;
    }

    .form-group { margin-bottom: 16px; }

    .form-label {
      display: block;
      font-size: 12px;
      font-weight: 500;
      color: var(--text-muted);
      margin-bottom: 6px;
    }

    .form-input {
      width: 100%;
      padding: 10px 12px;
      border: 1px solid var(--border);
      border-radius: var(--radius-md);
      font-size: 14px;
      font-family: 'DM Sans', sans-serif;
      color: var(--text-main);
      background: var(--gray-bg);
      transition: border-color 0.15s;
      outline: none;
    }

    .form-input:focus { border-color: var(--blue-mid); background: var(--white); }

    .form-select {
      width: 100%;
      padding: 10px 12px;
      border: 1px solid var(--border);
      border-radius: var(--radius-md);
      font-size: 14px;
      font-family: 'DM Sans', sans-serif;
      color: var(--text-main);
      background: var(--gray-bg);
      outline: none;
      cursor: pointer;
    }

    .btn-full {
      width: 100%;
      padding: 11px;
      background: var(--blue-mid);
      color: #fff;
      border: none;
      border-radius: var(--radius-md);
      font-size: 14px;
      font-weight: 500;
      font-family: 'DM Sans', sans-serif;
      cursor: pointer;
      margin-top: 6px;
      transition: background 0.15s;
    }

    .btn-full:hover { background: var(--blue-dark); }

    .modal-close {
      position: absolute;
      top: 14px;
      right: 16px;
      background: none;
      border: none;
      font-size: 22px;
      color: var(--text-muted);
      cursor: pointer;
      line-height: 1;
    }

    @media (max-width: 720px) {
      .roles-grid { grid-template-columns: 1fr 1fr; }
      .algo-grid  { grid-template-columns: 1fr 1fr; }
      .steps-grid { grid-template-columns: 1fr 1fr; }
      .hero h1    { font-size: 26px; }
      nav         { padding: 0 20px; }
      .hero       { padding: 40px 20px 32px; }
    }
  </style>
</head>
<body>

<!-- ═══ NAV ═══════════════════════════════════════════ -->
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
  <div class="nav-right">
    <a href="#how-it-works" class="nav-link">How it works</a>
    <a href="#algorithms" class="nav-link">Algorithms</a>
    <a href="#" class="btn-primary" onclick="openModal()">Login</a>
  </div>
</nav>

<!-- ═══ HERO ═══════════════════════════════════════════ -->
<section class="hero">
  <div class="badge">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
    </svg>
    Secure · Encrypted · Searchable
  </div>
  <h1>Search your encrypted cloud files <span>without exposing your data</span></h1>
  <p>A rankable Boolean searchable encryption scheme that supports dynamic updates. Upload encrypted files, search with multiple keywords, and receive ranked results — all while the server never sees plaintext.</p>
  <div class="hero-stats">
    <div class="stat">
      <div class="stat-num">TF-IDF</div>
      <div class="stat-label">Ranked results</div>
    </div>
    <div class="stat">
      <div class="stat-num">AND / OR</div>
      <div class="stat-label">Boolean search</div>
    </div>
    <div class="stat">
      <div class="stat-num">Dynamic</div>
      <div class="stat-label">Index updates</div>
    </div>
    <div class="stat">
      <div class="stat-num">Zero</div>
      <div class="stat-label">Plaintext leakage</div>
    </div>
  </div>
</section>

<!-- ═══ ROLES ═══════════════════════════════════════════ -->
<div class="section">
  <div class="section-title">Login as your role</div>
  <div class="roles-grid">

    <!-- Admin -->
   <a href="CloudControllerLogin.jsp" class="role-card">
      <div class="role-icon" style="background:#F1EFE8;">
        <svg viewBox="0 0 24 24" fill="none" stroke="#5F5E5A" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/>
        </svg>
      </div>
      <div class="role-name">Admin</div>
      <div class="role-desc">Manage all users, monitor cloud activity and oversee the entire system.</div>
      <div class="role-action">Login as Admin →</div>
    </a>

    <!-- Data Owner -->
   <a href="DOLogin.jsp" class="role-card featured">
      <div class="featured-badge">Primary Role</div>
      <div class="role-icon" style="background:var(--teal-bg);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#0F6E56" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/>
        </svg>
      </div>
      <div class="role-name">Data Owner</div>
      <div class="role-desc">Encrypt files, build keyword indices and upload securely to the cloud server.</div>
      <div class="role-action" style="color:var(--teal-mid);">Login as Data Owner →</div>
    </a>

    <!-- Data Consumer -->
   <a href="DCLogin.jsp" class="role-card">
      <div class="role-icon" style="background:var(--amber-bg);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#854F0B" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
        </svg>
      </div>
      <div class="role-name">Data Consumer</div>
      <div class="role-desc">Submit Boolean keyword trapdoors and receive TF-IDF ranked file results.</div>
      <div class="role-action" style="color:var(--amber-mid);">Login as Consumer →</div>
    </a>

    <!-- PKG -->
    <a href="PKGLogin.jsp" class="role-card">
      <div class="role-icon" style="background:var(--purple-bg);">
        <svg viewBox="0 0 24 24" fill="none" stroke="#534AB7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 11-7.778 7.778 5.5 5.5 0 017.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"/>
        </svg>
      </div>
      <div class="role-name">PKG</div>
      <div class="role-desc">Private Key Generator — issues and manages cryptographic keys for all users.</div>
      <div class="role-action" style="color:var(--purple-mid);">Login as PKG →</div>
    </a>

  </div>
</div>

<!-- ═══ HOW IT WORKS ════════════════════════════════════ -->
<div class="steps-wrap" id="how-it-works">
  <div class="steps-inner">
    <div class="section-title">How a search works</div>
    <div class="steps-grid">

      <div class="step">
        <div class="step-num">STEP 01</div>
        <div class="step-icon" style="background:var(--teal-bg);">
          <svg viewBox="0 0 24 24" fill="none" stroke="#0F6E56" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/>
          </svg>
        </div>
        <div class="step-title">Owner encrypts &amp; uploads</div>
        <div class="step-sub">Files are encrypted using GM + Paillier. Keyword index is built and sent to cloud.</div>
      </div>

      <div class="step">
        <div class="step-num">STEP 02</div>
        <div class="step-icon" style="background:var(--purple-bg);">
          <svg viewBox="0 0 24 24" fill="none" stroke="#534AB7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 11-7.778 7.778 5.5 5.5 0 017.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"/>
          </svg>
        </div>
        <div class="step-title">PKG issues private key</div>
        <div class="step-sub">Consumer contacts PKG with their identity and receives a unique private key.</div>
      </div>

      <div class="step">
        <div class="step-num">STEP 03</div>
        <div class="step-icon" style="background:var(--amber-bg);">
          <svg viewBox="0 0 24 24" fill="none" stroke="#854F0B" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="5" y="11" width="14" height="10" rx="2"/><path d="M8 11V7a4 4 0 018 0v4"/>
          </svg>
        </div>
        <div class="step-title">Trapdoor is generated</div>
        <div class="step-sub">Consumer creates an encrypted search trapdoor using their private key. No keyword is revealed.</div>
      </div>

      <div class="step">
        <div class="step-num">STEP 04</div>
        <div class="step-icon" style="background:var(--blue-light);">
          <svg viewBox="0 0 24 24" fill="none" stroke="#185FA5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="2" y="3" width="20" height="14" rx="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/>
          </svg>
        </div>
        <div class="step-title">Cloud searches &amp; ranks</div>
        <div class="step-sub">Cloud Server runs the trapdoor against encrypted indices and returns TF-IDF ranked files.</div>
      </div>

      <div class="step">
        <div class="step-num">STEP 05</div>
        <div class="step-icon" style="background:#EAF3DE;">
          <svg viewBox="0 0 24 24" fill="none" stroke="#3B6D11" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/>
          </svg>
        </div>
        <div class="step-title">Consumer decrypts &amp; downloads</div>
        <div class="step-sub">Consumer downloads matching files and decrypts with their private key to get original data.</div>
      </div>

    </div>
  </div>
</div>

<!-- ═══ ALGORITHMS ══════════════════════════════════════ -->
<div class="algo-section" id="algorithms">
  <div class="section-title">Core algorithms &amp; techniques</div>
  <div class="algo-grid">

    <div class="algo-card">
      <div class="algo-tag" style="background:var(--purple-bg); color:var(--purple-mid);">Encryption</div>
      <div class="algo-name">Paillier Algorithm</div>
      <div class="algo-desc">Homomorphic encryption that allows addition on encrypted numbers. Used to build secure keyword indices.</div>
    </div>

    <div class="algo-card">
      <div class="algo-tag" style="background:var(--blue-light); color:var(--blue-mid);">Encryption</div>
      <div class="algo-name">GM (Goldwasser-Micali)</div>
      <div class="algo-desc">Probabilistic public-key encryption for constructing Boolean keyword indices with XOR-based operations.</div>
    </div>

    <div class="algo-card">
      <div class="algo-tag" style="background:var(--teal-bg); color:var(--teal-mid);">Ranking</div>
      <div class="algo-name">TF-IDF Scoring</div>
      <div class="algo-desc">Term Frequency × Inverse Document Frequency. Scores each file's relevance to rank search results by importance.</div>
    </div>

    <div class="algo-card">
      <div class="algo-tag" style="background:var(--amber-bg); color:var(--amber-mid);">Indexing</div>
      <div class="algo-name">Bloom Filter</div>
      <div class="algo-desc">Probabilistic data structure for sub-linear search time. Quickly checks if a keyword exists in a file's index.</div>
    </div>

  </div>
</div>

<!-- ═══ FOOTER ══════════════════════════════════════════ -->
<footer>
  <div class="footer-left">MJDM04 &nbsp;·&nbsp; Java Web Application &nbsp;·&nbsp; Tomcat 7.0 &nbsp;·&nbsp; MySQL</div>
  <div class="footer-right">Privacy-Preserving Secure Cloud Search Platform</div>
</footer>

<!-- ═══ LOGIN MODAL ═════════════════════════════════════ -->
<div class="modal-overlay" id="loginModal">
  <div class="modal">
    <button class="modal-close" onclick="closeModal()">&#215;</button>
    <div class="modal-title">Login to RBDC</div>
    <div class="modal-sub">Select your role and enter credentials</div>

    <form action="LoginServlet" method="post">
      <div class="form-group">
        <label class="form-label">Role</label>
        <select name="role" class="form-select" required>
          <option value="">Select role...</option>
          <option value="admin">Admin</option>
          <option value="dataowner">Data Owner</option>
          <option value="dataconsumer">Data Consumer</option>
          <option value="pkg">Private Key Generator (PKG)</option>
        </select>
      </div>
      <div class="form-group">
        <label class="form-label">Email Address</label>
        <input type="email" name="email" class="form-input" placeholder="Enter your email address" required />
      </div>
      <div class="form-group">
        <label class="form-label">Password</label>
        <input type="password" name="password" class="form-input" placeholder="Enter your password" required />
      </div>
      <button type="submit" class="btn-full">Login →</button>
    </form>
  </div>
</div>

<script>
  function openModal() {
    document.getElementById('loginModal').classList.add('active');
  }
  function closeModal() {
    document.getElementById('loginModal').classList.remove('active');
  }
  document.getElementById('loginModal').addEventListener('click', function(e) {
    if (e.target === this) closeModal();
  });
</script>

</body>
</html>
