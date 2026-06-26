<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login — SecureRank Cloud Search</title>
  
  <!-- Font and Icon Resources -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <link rel="stylesheet" href="css/style.css">
</head>
<body style="background-color: var(--bg-main); overflow-x: hidden;">

  <div class="split-container">
    
    <!-- Left Column: Branding / Security Illustration -->
    <div class="split-banner-side">
      <div class="split-banner-content">
        <!-- Logo -->
        <a href="index.jsp" style="display: flex; align-items: center; gap: 10px; text-decoration: none; color: #ffffff; margin-bottom: 48px;">
          <div class="public-logo-icon" style="background-color: var(--primary);">
            <i class="bi bi-shield-lock-fill"></i>
          </div>
          <div>
            <div class="public-logo-title" style="font-size: 18px; color: #ffffff;">SecureRank Cloud</div>
            <div class="public-logo-sub" style="color: #94a3b8; font-size: 11px;">Encrypted Search Engine</div>
          </div>
        </a>
        
        <h2 class="split-banner-title">Enterprise Security &amp; Homomorphic Search</h2>
        <p class="split-banner-desc">
          Outsource sensitive assets securely. This console implements searchable encryption algorithms, preventing administrators or external threats from gaining raw plaintext insights.
        </p>
        
        <div class="split-banner-features">
          <div class="split-banner-feat">
            <div class="split-banner-feat-icon"><i class="bi bi-shield-fill-check"></i></div>
            <div class="split-banner-feat-text">Probabilistic Goldwasser-Micali (GM) local file encryption.</div>
          </div>
          <div class="split-banner-feat">
            <div class="split-banner-feat-icon"><i class="bi bi-cpu-fill"></i></div>
            <div class="split-banner-feat-text">Paillier Cryptosystem additive homomorphic searchable index vectors.</div>
          </div>
          <div class="split-banner-feat">
            <div class="split-banner-feat-icon"><i class="bi bi-bar-chart-fill"></i></div>
            <div class="split-banner-feat-text">TF-IDF keyword-relevance sorting handled directly in ciphertext domains.</div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Right Column: Login Forms -->
    <div class="split-form-side">
      
      <!-- Back to Home -->
      <div style="width: 100%; max-width: 420px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
        <a href="index.jsp" class="btn btn-secondary btn-sm" style="border: 1px solid var(--border);"><i class="bi bi-arrow-left"></i> Back to Home</a>
        <button class="theme-toggle" aria-label="Toggle Dark Mode"></button>
      </div>

      <!-- Role Tabs Panel -->
      <div style="width: 100%; max-width: 420px; margin-bottom: 20px;">
        <span style="font-size: 11px; font-weight: 600; color: var(--text-faint); text-transform: uppercase; letter-spacing: 0.1em; display: block; margin-bottom: 8px;">Select System Role</span>
        
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 8px; margin-bottom: 8px;">
          <button class="btn btn-outline btn-sm active" id="btn-owner" onclick="selectRole('dataowner', this)" style="justify-content: flex-start; padding: 10px;">
            <i class="bi bi-person-fill-up"></i> Data Owner
          </button>
          <button class="btn btn-outline btn-sm" id="btn-consumer" onclick="selectRole('dataconsumer', this)" style="justify-content: flex-start; padding: 10px;">
            <i class="bi bi-person-fill-lock"></i> Data Consumer
          </button>
        </div>
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 8px;">
          <button class="btn btn-outline btn-sm" id="btn-pkg" onclick="selectRole('pkg', this)" style="justify-content: flex-start; padding: 10px;">
            <i class="bi bi-key-fill"></i> Key Gen (PKG)
          </button>
          <button class="btn btn-outline btn-sm" id="btn-admin" onclick="selectRole('admin', this)" style="justify-content: flex-start; padding: 10px;">
            <i class="bi bi-hdd-network-fill"></i> Cloud Admin
          </button>
        </div>
      </div>

      <!-- Login Form Card -->
      <div class="card" style="width: 100%; max-width: 420px; box-shadow: var(--shadow-md);">
        <h2 id="formTitle" style="font-size: 18px; font-weight: 600;">Data Owner Login</h2>
        <p id="formSub" style="font-size: 12px; color: var(--text-muted); margin-bottom: 20px; margin-top: 2px;">Enter credentials to encrypt and upload files</p>
        
        <form action="LoginServlet" method="post">
          <input type="hidden" name="role" id="roleField" value="dataowner" />
          
          <div class="form-group">
            <label class="form-label" for="email">Email Address</label>
            <div class="input-wrapper">
              <i class="bi bi-envelope-fill"></i>
              <input type="email" id="email" name="email" class="form-input" placeholder="name@securerank.com" required />
            </div>
          </div>
          
          <div class="form-group">
            <label class="form-label" for="password">Password</label>
            <div class="input-wrapper">
              <i class="bi bi-lock-fill"></i>
              <input type="password" id="password" name="password" class="form-input" placeholder="••••••••" required />
            </div>
          </div>
          
          <!-- Remember Me and Forgot Password Option -->
          <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; font-size: 12px;">
            <label style="display: flex; align-items: center; gap: 6px; cursor: pointer; color: var(--text-muted);">
              <input type="checkbox" name="remember" style="accent-color: var(--primary);" /> Remember Me
            </label>
            <a href="#" onclick="showToast('Password reset link is disabled for deployment security.', 'info')" style="color: var(--primary); text-decoration: none; font-weight: 500;">Forgot Password?</a>
          </div>
          
          <button type="submit" class="btn btn-primary" id="submitBtn" style="width: 100%; padding: 11px;">
            Login as Data Owner &rarr;
          </button>
        </form>
        
        <hr style="border: none; border-top: 1px solid var(--border); margin: 20px 0;" />
        
        <div id="registerLine" style="text-align: center; font-size: 13px; color: var(--text-muted);">
          New Data Owner? <a href="register.jsp?role=dataowner" style="color: var(--primary); text-decoration: none; font-weight: 500;">Register here</a>
        </div>
      </div>
      
    </div>
    
  </div>

  <script src="js/theme.js"></script>
  <script>
    // Role metadata for dynamic updates
    var roles = {
      dataowner: { 
        title: "Data Owner Login", 
        sub: "Enter credentials to encrypt and upload files", 
        btn: "Login as Data Owner \u2192", 
        reg: "New Data Owner? <a href='register.jsp?role=dataowner' style='color: var(--primary); text-decoration: none; font-weight: 500;'>Register here</a>" 
      },
      dataconsumer: { 
        title: "Data Consumer Login", 
        sub: "Enter credentials to search and download files", 
        btn: "Login as Data Consumer \u2192", 
        reg: "New Data Consumer? <a href='register.jsp?role=dataconsumer' style='color: var(--primary); text-decoration: none; font-weight: 500;'>Register here</a>" 
      },
      pkg: { 
        title: "PKG Login", 
        sub: "Private Key Generator Administrator credentials", 
        btn: "Login as PKG \u2192", 
        reg: null 
      },
      admin: { 
        title: "Admin / Cloud Server Login", 
        sub: "Cloud Server infrastructure credentials required", 
        btn: "Login as Admin \u2192", 
        reg: null 
      }
    };

    function selectRole(role, el) {
      // Toggle button states
      document.querySelectorAll('.split-form-side button.btn-outline').forEach(function(b){ b.classList.remove('active'); });
      el.classList.add('active');

      // Update Form properties
      var r = roles[role];
      document.getElementById('roleField').value = role;
      document.getElementById('formTitle').textContent = r.title;
      document.getElementById('formSub').textContent = r.sub;
      document.getElementById('submitBtn').textContent = r.btn;
      document.getElementById('registerLine').innerHTML = r.reg
          ? r.reg
          : '<span style="color:var(--text-faint);font-size:12px;"><i class="bi bi-info-circle"></i> Contact main administrator for access setup</span>';
    }

    // Pre-select role from URL param
    var params = new URLSearchParams(window.location.search);
    var roleParam = params.get('role');
    if (roleParam && roles[roleParam]) {
      var targetId = 'btn-' + (roleParam === 'dataowner' ? 'owner' : (roleParam === 'dataconsumer' ? 'consumer' : roleParam));
      var btn = document.getElementById(targetId);
      if (btn) selectRole(roleParam, btn);
    }
  </script>
</body>
</html>
