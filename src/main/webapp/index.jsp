<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SecureRank Cloud — Secure Multi-Keyword Search over Encrypted Cloud Data</title>
  
  <!-- Font and Icon Resources -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <link rel="stylesheet" href="css/style.css">
  
  <style>
    /* Specific styles for landing page components */
    .hero-section {
      padding: 100px 24px 80px;
      text-align: center;
      background: radial-gradient(circle at 50% 50%, var(--primary-light) 0%, transparent 75%);
      border-bottom: 1px solid var(--border);
    }
    
    .hero-badge {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      background-color: var(--primary-light);
      color: var(--primary);
      border: 1px solid var(--primary-border);
      font-size: 12px;
      font-weight: 500;
      padding: 6px 14px;
      border-radius: 999px;
      margin-bottom: 24px;
    }
    
    .hero-title {
      font-size: 46px;
      font-weight: 800;
      line-height: 1.2;
      max-width: 900px;
      margin: 0 auto 16px;
      color: var(--text-main);
      letter-spacing: -0.03em;
    }
    
    .hero-title span {
      background: linear-gradient(135deg, var(--primary) 0%, #1e1b4b 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
    
    .hero-subtitle {
      font-size: 16px;
      color: var(--text-muted);
      max-width: 680px;
      margin: 0 auto 36px;
      line-height: 1.6;
    }
    
    .hero-actions {
      display: flex;
      justify-content: center;
      gap: 16px;
      margin-bottom: 48px;
    }
    
    /* Grid wrapper */
    .section-wrap {
      max-width: 1140px;
      margin: 0 auto;
      padding: 80px 24px;
    }
    
    .section-header {
      text-align: center;
      margin-bottom: 56px;
    }
    
    .section-tag {
      font-size: 11px;
      font-weight: 600;
      color: var(--primary);
      text-transform: uppercase;
      letter-spacing: 0.15em;
      margin-bottom: 10px;
      display: block;
    }
    
    .section-heading {
      font-size: 28px;
      font-weight: 700;
      color: var(--text-main);
      letter-spacing: -0.02em;
    }
    
    /* Tech Stack Grid */
    .tech-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
      gap: 20px;
    }
    
    .tech-card {
      background-color: var(--bg-surface);
      border: 1px solid var(--border);
      border-radius: var(--radius-lg);
      padding: 24px 20px;
      text-align: center;
      transition: all 0.2s ease;
      box-shadow: var(--shadow-sm);
    }
    
    .tech-card:hover {
      transform: translateY(-4px);
      box-shadow: var(--shadow-md);
      border-color: var(--primary-border);
    }
    
    .tech-icon {
      font-size: 32px;
      color: var(--primary);
      margin-bottom: 12px;
      display: inline-block;
    }
    
    .tech-name {
      font-size: 14px;
      font-weight: 600;
      color: var(--text-main);
    }
    
    .tech-desc {
      font-size: 11px;
      color: var(--text-muted);
      margin-top: 4px;
    }
    
    /* Workflow Line */
    .flow-wrapper {
      background-color: var(--bg-surface);
      border-top: 1px solid var(--border);
      border-bottom: 1px solid var(--border);
      padding: 80px 24px;
    }
    
    .flow-steps {
      display: flex;
      flex-direction: column;
      max-width: 800px;
      margin: 0 auto;
      gap: 32px;
      position: relative;
    }
    
    .flow-steps::before {
      content: '';
      position: absolute;
      left: 28px;
      top: 0;
      bottom: 0;
      width: 2px;
      background-color: var(--border);
      z-index: 1;
    }
    
    .flow-item {
      display: flex;
      align-items: flex-start;
      gap: 24px;
      position: relative;
      z-index: 2;
    }
    
    .flow-badge {
      width: 58px;
      height: 58px;
      border-radius: 50%;
      background-color: var(--bg-surface);
      border: 2px solid var(--primary);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 20px;
      color: var(--primary);
      font-weight: 700;
      flex-shrink: 0;
      box-shadow: var(--shadow-md);
    }
    
    .flow-body {
      background-color: var(--bg-main);
      border: 1px solid var(--border);
      border-radius: var(--radius-lg);
      padding: 20px;
      flex: 1;
    }
    
    .flow-title {
      font-size: 15px;
      font-weight: 600;
      color: var(--text-main);
    }
    
    .flow-desc {
      font-size: 12px;
      color: var(--text-muted);
      margin-top: 4px;
      line-height: 1.5;
    }
    
    /* Architecture Grid */
    .arch-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 24px;
      margin-top: 32px;
    }
    
    .arch-card {
      background-color: var(--bg-surface);
      border: 1px solid var(--border);
      border-radius: var(--radius-lg);
      padding: 24px;
      box-shadow: var(--shadow-sm);
      display: flex;
      gap: 16px;
      transition: all 0.2s ease;
    }
    
    .arch-card:hover {
      transform: translateY(-3px);
      box-shadow: var(--shadow-md);
      border-color: var(--primary-border);
    }
    
    .arch-icon-box {
      width: 48px;
      height: 48px;
      border-radius: var(--radius-md);
      background-color: var(--primary-light);
      color: var(--primary);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 22px;
      flex-shrink: 0;
      border: 1px solid var(--primary-border);
    }
    
    /* Footer columns */
    .footer-columns {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 32px;
      text-align: left;
      max-width: 1140px;
      margin: 0 auto 32px;
    }
    
    .footer-col h4 {
      font-size: 14px;
      font-weight: 600;
      color: var(--text-main);
      margin-bottom: 16px;
      text-transform: uppercase;
      letter-spacing: 0.05em;
    }
    
    .footer-col p {
      font-size: 13px;
      color: var(--text-muted);
      line-height: 1.6;
    }
    
    .footer-col ul {
      list-style: none;
      padding: 0;
    }
    
    .footer-col ul li {
      margin-bottom: 10px;
    }
    
    .footer-col ul li a {
      font-size: 13px;
      color: var(--text-muted);
      text-decoration: none;
      transition: color 0.15s ease;
    }
    
    .footer-col ul li a:hover {
      color: var(--primary);
    }
    
    /* Modal styles */
    .modal-overlay {
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background-color: rgba(15, 23, 42, 0.6);
      backdrop-filter: blur(4px);
      display: flex;
      align-items: center;
      justify-content: center;
      z-index: 1000;
      opacity: 0;
      pointer-events: none;
      transition: opacity 0.2s ease;
    }
    
    .modal-overlay.active {
      opacity: 1;
      pointer-events: auto;
    }
    
    .modal-box {
      width: 100%;
      max-width: 400px;
      background-color: var(--bg-surface);
      border: 1px solid var(--border);
      border-radius: var(--radius-lg);
      box-shadow: var(--shadow-lg);
      overflow: hidden;
      transform: scale(0.95);
      transition: transform 0.2s ease;
    }
    
    .modal-overlay.active .modal-box {
      transform: scale(1);
    }
    
    .modal-hdr {
      padding: 20px 24px 16px;
      border-bottom: 1px solid var(--border);
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
    
    .modal-title {
      font-size: 16px;
      font-weight: 600;
    }
    
    .modal-close-btn {
      background: none;
      border: none;
      font-size: 20px;
      color: var(--text-muted);
      cursor: pointer;
      line-height: 1;
    }
    
    .modal-close-btn:hover {
      color: var(--text-main);
    }
    
    .modal-body {
      padding: 24px;
    }
  </style>
</head>
<body>

  <!-- Navigation -->
  <nav class="public-nav">
    <a href="index.jsp" class="public-logo">
      <div class="public-logo-icon">
        <i class="bi bi-shield-lock-fill"></i>
      </div>
      <div>
        <div class="public-logo-title">SecureRank Cloud</div>
        <div class="public-logo-sub">Encrypted Search Engine</div>
      </div>
    </a>
    <div class="public-nav-links">
      <a href="#features" class="public-nav-link">Features</a>
      <a href="#workflow" class="public-nav-link">Workflow</a>
      <a href="#tech-stack" class="public-nav-link">Technology</a>
      <a href="#architecture" class="public-nav-link">Architecture</a>
      <button class="theme-toggle" aria-label="Toggle Dark Mode"></button>
      <button class="btn btn-primary" onclick="openModal()">Get Started</button>
    </div>
  </nav>

  <!-- Hero Section -->
  <section class="hero-section">
    <div class="hero-badge">
      <i class="bi bi-shield-fill-check"></i> SecureRank Cloud Security Protocol
    </div>
    <h1 class="hero-title">
      Secure Multi-Keyword Search <br><span>over Encrypted Cloud Data</span>
    </h1>
    <p class="hero-subtitle">
      An enterprise-grade SaaS platform protecting data privacy in outsourced cloud databases.
      Search through fully encrypted records using Boolean trapdoors with TF-IDF relevance ranking.
    </p>
    <div class="hero-actions">
      <button class="btn btn-primary btn-lg" onclick="openModal()">
        <i class="bi bi-box-arrow-in-right"></i> Get Started
      </button>
      <a href="login.jsp" class="btn btn-secondary btn-lg">
        <i class="bi bi-person-fill"></i> Login
      </a>
      <a href="#features" class="btn btn-outline btn-lg">
        <i class="bi bi-list-stars"></i> View Features
      </a>
    </div>
    
    <!-- Hero Stats Grid -->
    <div class="stats-grid" style="max-width: 900px; margin: 40px auto 0; grid-template-columns: repeat(5, 1fr); gap: 16px;">
      <div class="metric-card" style="padding: 16px; flex-direction: column; gap: 4px; justify-content: center;">
        <div class="metric-value" style="font-size: 20px;">1,248</div>
        <div class="metric-label" style="font-size: 10px;">Documents Stored</div>
      </div>
      <div class="metric-card" style="padding: 16px; flex-direction: column; gap: 4px; justify-content: center;">
        <div class="metric-value" style="font-size: 20px;">84</div>
        <div class="metric-label" style="font-size: 10px;">Registered Users</div>
      </div>
      <div class="metric-card" style="padding: 16px; flex-direction: column; gap: 4px; justify-content: center;">
        <div class="metric-value" style="font-size: 20px;">4,892</div>
        <div class="metric-label" style="font-size: 10px;">Successful Searches</div>
      </div>
      <div class="metric-card" style="padding: 16px; flex-direction: column; gap: 4px; justify-content: center;">
        <div class="metric-value" style="font-size: 20px;">1,154</div>
        <div class="metric-label" style="font-size: 10px;">Encrypted Files</div>
      </div>
      <div class="metric-card" style="padding: 16px; flex-direction: column; gap: 4px; justify-content: center;">
        <div class="metric-value" style="font-size: 20px;">12</div>
        <div class="metric-label" style="font-size: 10px;">Active Sessions</div>
      </div>
    </div>
  </section>

  <!-- Key Features Grid -->
  <section class="section-wrap" id="features">
    <div class="section-header">
      <span class="section-tag">Core Capabilities</span>
      <h2 class="section-heading">Key Features</h2>
    </div>
    
    <div class="features-grid" style="grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 20px;">
      <div class="feature-card">
        <div class="feature-icon-box"><i class="bi bi-shield-lock-fill"></i></div>
        <div class="feature-title">Secure File Encryption</div>
        <div class="feature-desc">Outsourced files are fully encrypted before leaving local storage using state-of-the-art cryptographic algorithms.</div>
      </div>
      <div class="feature-card">
        <div class="feature-icon-box"><i class="bi bi-sort-down"></i></div>
        <div class="feature-title">Ranked Multi-Keyword Search</div>
        <div class="feature-desc">Relevance scoring is calculated inside the cloud environment using TF-IDF weights to return the most relevant documents first.</div>
      </div>
      <div class="feature-card">
        <div class="feature-icon-box"><i class="bi bi-fingerprint"></i></div>
        <div class="feature-title">Trapdoor Generation</div>
        <div class="feature-desc">Search queries are dynamically encrypted as secure trapdoors. Plaintext query keywords are never exposed to the cloud server.</div>
      </div>
      <div class="feature-card">
        <div class="feature-icon-box"><i class="bi bi-cloud-check-fill"></i></div>
        <div class="feature-title">Cloud Storage</div>
        <div class="feature-desc">Reliable storage framework suited for large enterprise files, providing scalable indexing systems and fast search performance.</div>
      </div>
      <div class="feature-card">
        <div class="feature-icon-box"><i class="bi bi-person-lock"></i></div>
        <div class="feature-title">Role-Based Access</div>
        <div class="feature-desc">Strict authorization flow separating Cloud Servers, Data Owners, Data Consumers, and PKG operators.</div>
      </div>
      <div class="feature-card">
        <div class="feature-icon-box"><i class="bi bi-lightning-charge-fill"></i></div>
        <div class="feature-title">Fast Document Retrieval</div>
        <div class="feature-desc">Highly optimized index matching logic guarantees sub-second response times for multi-keyword searches.</div>
      </div>
      <div class="feature-card">
        <div class="feature-icon-box"><i class="bi bi-key-fill"></i></div>
        <div class="feature-title">Secure Key Management</div>
        <div class="feature-desc">Granular key distribution handled by the Private Key Generator (PKG), securing decryption capabilities to authorized consumers only.</div>
      </div>
      <div class="feature-card">
        <div class="feature-icon-box"><i class="bi bi-check-circle-fill"></i></div>
        <div class="feature-title">Search Verification</div>
        <div class="feature-desc">Secure Coprocessor (SCP) audits matches to prevent deceptive search results from the cloud provider.</div>
      </div>
    </div>
  </section>

  <!-- How It Works Visual Workflow -->
  <section class="flow-wrapper" id="workflow">
    <div class="section-header">
      <span class="section-tag">Sequence Flow</span>
      <h2 class="section-heading">How It Works</h2>
    </div>
    
    <div class="flow-steps">
      <div class="flow-item">
        <div class="flow-badge">1</div>
        <div class="flow-body">
          <div class="flow-title">Data Owner Setup</div>
          <div class="flow-desc">Data Owner uploads documents and extracts search keywords mapping index parameters.</div>
        </div>
      </div>
      <div class="flow-item">
        <div class="flow-badge">2</div>
        <div class="flow-body">
          <div class="flow-title">Encrypt File Locally</div>
          <div class="flow-desc">The file is encrypted using homomorphic cryptosystems locally so plaintext is never exposed.</div>
        </div>
      </div>
      <div class="flow-item">
        <div class="flow-badge">3</div>
        <div class="flow-body">
          <div class="flow-title">Upload to Cloud</div>
          <div class="flow-desc">Encrypted index and payload are transferred securely to the remote Cloud Server.</div>
        </div>
      </div>
      <div class="flow-item">
        <div class="flow-badge">4</div>
        <div class="flow-body">
          <div class="flow-title">Generate Secure Trapdoor</div>
          <div class="flow-desc">Data Consumer generates encrypted trapdoors for multi-keyword search queries.</div>
        </div>
      </div>
      <div class="flow-item">
        <div class="flow-badge">5</div>
        <div class="flow-body">
          <div class="flow-title">Ranked Search Evaluation</div>
          <div class="flow-desc">Cloud Server evaluates the trapdoor against stored indices, calculates TF-IDF score, and ranks results.</div>
        </div>
      </div>
      <div class="flow-item">
        <div class="flow-badge">6</div>
        <div class="flow-body">
          <div class="flow-title">Secure Decryption and Download</div>
          <div class="flow-desc">Authorized Consumer requests keys, receives decryption authorization, and downloads the original document.</div>
        </div>
      </div>
    </div>
  </section>

  <!-- Why SecureRank? Section -->
  <section class="section-wrap" id="why">
    <div class="section-header">
      <span class="section-tag">Value Proposition</span>
      <h2 class="section-heading">Why SecureRank Cloud?</h2>
    </div>
    
    <div class="features-grid" style="grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px;">
      <div class="feature-card">
        <div class="feature-title">Data Privacy</div>
        <div class="feature-desc">Guarantees zero-knowledge privacy where neither the database nor the hosting cloud server can read plaintext contents.</div>
      </div>
      <div class="feature-card">
        <div class="feature-title">Confidential Cloud Storage</div>
        <div class="feature-desc">Files stored in the cloud are completely secure against cloud provider insider leaks.</div>
      </div>
      <div class="feature-card">
        <div class="feature-title">Efficient Ranked Search</div>
        <div class="feature-desc">Performs sorting operations over ciphertext domains without degrading security parameters.</div>
      </div>
      <div class="feature-card">
        <div class="feature-title">Strong Security</div>
        <div class="feature-desc">Employs advanced mathematical constructs (Goldwasser-Micali and Paillier Cryptosystems).</div>
      </div>
      <div class="feature-card">
        <div class="feature-title">Easy File Management</div>
        <div class="feature-desc">Manage files and authorize access credentials from a single dynamic, professional workspace.</div>
      </div>
    </div>
  </section>

  <!-- Technology Stack Section -->
  <section class="section-wrap" id="tech-stack" style="border-top: 1px solid var(--border); border-bottom: 1px solid var(--border); background-color: var(--bg-surface);">
    <div class="section-header">
      <span class="section-tag">Architecture Ingredients</span>
      <h2 class="section-heading">Technology Stack</h2>
    </div>
    
    <div class="tech-grid">
      <div class="tech-card">
        <div class="tech-icon"><i class="bi bi-filetype-java"></i></div>
        <div class="tech-name">Java</div>
        <div class="tech-desc">Core Backend Processing</div>
      </div>
      <div class="tech-card">
        <div class="tech-icon"><i class="bi bi-file-code"></i></div>
        <div class="tech-name">JSP</div>
        <div class="tech-desc">Dynamic Presentation</div>
      </div>
      <div class="tech-card">
        <div class="tech-icon"><i class="bi bi-gear-wide-connected"></i></div>
        <div class="tech-name">Servlets</div>
        <div class="tech-desc">Controller Layer Hooks</div>
      </div>
      <div class="tech-card">
        <div class="tech-icon"><i class="bi bi-database"></i></div>
        <div class="tech-name">MySQL</div>
        <div class="tech-desc">Data Persistence Engine</div>
      </div>
      <div class="tech-card">
        <div class="tech-icon"><i class="bi bi-filetype-html"></i></div>
        <div class="tech-name">HTML5</div>
        <div class="tech-desc">Semantic Document Layout</div>
      </div>
      <div class="tech-card">
        <div class="tech-icon"><i class="bi bi-filetype-css"></i></div>
        <div class="tech-name">CSS3</div>
        <div class="tech-desc">SaaS Style Tokens</div>
      </div>
      <div class="tech-card">
        <div class="tech-icon"><i class="bi bi-braces"></i></div>
        <div class="tech-name">JavaScript</div>
        <div class="tech-desc">Client Interaction Layer</div>
      </div>
      <div class="tech-card">
        <div class="tech-icon"><i class="bi bi-bootstrap"></i></div>
        <div class="tech-name">Bootstrap Icons</div>
        <div class="tech-desc">Premium Icons Set</div>
      </div>
      <div class="tech-card">
        <div class="tech-icon"><i class="bi bi-box-seam"></i></div>
        <div class="tech-name">Maven</div>
        <div class="tech-desc">Dependency Assembly</div>
      </div>
      <div class="tech-card">
        <div class="tech-icon"><i class="bi bi-server"></i></div>
        <div class="tech-name">Apache Tomcat</div>
        <div class="tech-desc">Local Web Application Server</div>
      </div>
    </div>
  </section>

  <!-- Architecture Diagram Section -->
  <section class="section-wrap" id="architecture">
    <div class="section-header">
      <span class="section-tag">System Blueprints</span>
      <h2 class="section-heading">System Architecture</h2>
    </div>
    
    <div class="arch-grid">
      <div class="arch-card">
        <div class="arch-icon-box"><i class="bi bi-person-workspace"></i></div>
        <div>
          <h3 style="font-size: 15px; font-weight:600;">Data Owner</h3>
          <p style="font-size: 12px; color: var(--text-muted); margin-top: 4px;">Encrypts and uploads files. Sets security labels and keyword indices.</p>
        </div>
      </div>
      <div class="arch-card">
        <div class="arch-icon-box"><i class="bi bi-key-fill"></i></div>
        <div>
          <h3 style="font-size: 15px; font-weight:600;">PKG (Private Key Generator)</h3>
          <p style="font-size: 12px; color: var(--text-muted); margin-top: 4px;">Responsible for public/private key pairs and master decryption key distributions.</p>
        </div>
      </div>
      <div class="arch-card">
        <div class="arch-icon-box"><i class="bi bi-cpu"></i></div>
        <div>
          <h3 style="font-size: 15px; font-weight:600;">Cloud Server</h3>
          <p style="font-size: 12px; color: var(--text-muted); margin-top: 4px;">Hosts the encrypted tables, receives trapdoors, and runs calculations on ciphertext.</p>
        </div>
      </div>
      <div class="arch-card">
        <div class="arch-icon-box"><i class="bi bi-people-fill"></i></div>
        <div>
          <h3 style="font-size: 15px; font-weight:600;">Data Consumer</h3>
          <p style="font-size: 12px; color: var(--text-muted); margin-top: 4px;">Queries the indexes via trapdoors and downloads files upon receiving authorization keys.</p>
        </div>
      </div>
      <div class="arch-card">
        <div class="arch-icon-box"><i class="bi bi-database-fill-check"></i></div>
        <div>
          <h3 style="font-size: 15px; font-weight:600;">Secure Database</h3>
          <p style="font-size: 12px; color: var(--text-muted); margin-top: 4px;">Persists registration files, logs, and cryptographic vectors safely.</p>
        </div>
      </div>
    </div>
  </section>

  <!-- Login Modal Overlay -->
  <div class="modal-overlay" id="loginModal">
    <div class="modal-box">
      <div class="modal-hdr">
        <div class="modal-title"><i class="bi bi-shield-lock"></i> System Access Portal</div>
        <button class="modal-close-btn" onclick="closeModal()">&times;</button>
      </div>
      <div class="modal-body">
        <form action="LoginServlet" method="post">
          <div class="form-group">
            <label class="form-label">System Role</label>
            <div class="input-wrapper">
              <i class="bi bi-person-badge-fill"></i>
              <select name="role" class="form-input" required style="padding-left: 36px;">
                <option value="">Select system role...</option>
                <option value="admin">Cloud Server (Admin)</option>
                <option value="dataowner">Data Owner</option>
                <option value="dataconsumer">Data Consumer</option>
                <option value="pkg">Private Key Generator (PKG)</option>
              </select>
            </div>
          </div>
          <div class="form-group">
            <label class="form-label">Email Address</label>
            <div class="input-wrapper">
              <i class="bi bi-envelope-fill"></i>
              <input type="email" name="email" class="form-input" placeholder="name@securerank.com" required />
            </div>
          </div>
          <div class="form-group">
            <label class="form-label">Password</label>
            <div class="input-wrapper">
              <i class="bi bi-key-fill"></i>
              <input type="password" name="password" class="form-input" placeholder="••••••••" required />
            </div>
          </div>
          <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 10px; padding: 10px;">
            Sign In &rarr;
          </button>
        </form>
        <div style="text-align: center; margin-top: 16px; font-size: 12px; color: var(--text-muted);">
          Don't have an account? <a href="register.jsp" style="color: var(--primary); text-decoration: none; font-weight: 500;">Register Here</a>
        </div>
      </div>
    </div>
  </div>

  <!-- Footer -->
  <footer style="padding: 60px 40px 30px; background-color: var(--bg-surface); border-top: 1px solid var(--border);">
    <div class="footer-columns">
      <div class="footer-col">
        <h4>About SecureRank</h4>
        <p>A cutting-edge SaaS platform implementing searchable encryption. Allows secure multi-keyword searches over encrypted datasets stored remotely in the cloud.</p>
      </div>
      <div class="footer-col">
        <h4>Technology Stack</h4>
        <ul>
          <li><a href="#tech-stack">Java &amp; Servlets</a></li>
          <li><a href="#tech-stack">JSP &amp; CSS3</a></li>
          <li><a href="#tech-stack">MySQL Database</a></li>
          <li><a href="#tech-stack">Homomorphic Cryptography</a></li>
        </ul>
      </div>
      <div class="footer-col">
        <h4>Project Assets</h4>
        <ul>
          <li><a href="https://github.com/shyamsunderpolu/Secure-Ranked-Multi-Keyword-Search-System" target="_blank"><i class="bi bi-github"></i> GitHub Repository</a></li>
          <li><a href="#architecture">Architecture Specification</a></li>
          <li><a href="#features">Key Features Log</a></li>
        </ul>
      </div>
      <div class="footer-col">
        <h4>Developer Info</h4>
        <p style="font-weight: 600; color: var(--text-main);">POLU SHYAM SUNDER REDDY</p>
        <p style="font-size: 12px; color: var(--text-muted); margin-top: 4px;">Full Stack Java Developer</p>
        <p style="margin-top: 10px; font-size: 13px;">
          <a href="https://github.com/shyamsunderpolu" target="_blank" style="color: var(--primary); text-decoration: none; font-weight: 500; display: inline-flex; align-items: center; gap: 6px;">
            <i class="bi bi-github"></i> GitHub Profile
          </a>
        </p>
      </div>
    </div>
    
    <div style="text-align: center; border-top: 1px solid var(--border); padding-top: 24px; color: var(--text-faint); font-size: 12px;">
      &copy; 2026 SecureRank Cloud Search System. All rights reserved.
    </div>
  </footer>

  <script src="js/theme.js"></script>
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
