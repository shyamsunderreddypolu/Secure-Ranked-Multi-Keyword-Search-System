<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register — SecureRank Cloud Search</title>
  
  <!-- Font and Icon Resources -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <link rel="stylesheet" href="css/style.css">
  
  <style>
    /* Wizard steps visibility */
    .form-step {
      display: none;
    }
    .form-step.active {
      display: block;
    }
    .step-indicator {
      display: flex;
      justify-content: space-between;
      margin-bottom: 24px;
      position: relative;
    }
    .step-indicator::before {
      content: '';
      position: absolute;
      top: 50%;
      left: 0;
      right: 0;
      height: 2px;
      background-color: var(--border);
      z-index: 1;
      transform: translateY(-50%);
    }
    .step-dot {
      width: 32px;
      height: 32px;
      border-radius: 50%;
      background-color: var(--bg-surface);
      border: 2px solid var(--border);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 13px;
      font-weight: 600;
      color: var(--text-muted);
      position: relative;
      z-index: 2;
      transition: all 0.2s ease;
    }
    .step-dot.active {
      border-color: var(--primary);
      background-color: var(--primary);
      color: #ffffff;
    }
    .step-dot.completed {
      border-color: var(--success);
      background-color: var(--success);
      color: #ffffff;
    }
  </style>
</head>
<body style="background-color: var(--bg-main); overflow-x: hidden;">

  <div class="split-container">
    
    <!-- Left Column: Registration Banner -->
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
        
        <h2 class="split-banner-title">Create Your Cybersecurity Workspace Profile</h2>
        <p class="split-banner-desc">
          Enroll as a Data Owner to encrypt and host file assets, or as a Data Consumer to run trapdoor evaluations and retrieve authorized database contents.
        </p>
        
        <div class="split-banner-features">
          <div class="split-banner-feat">
            <div class="split-banner-feat-icon" style="color: var(--success);"><i class="bi bi-check-lg"></i></div>
            <div class="split-banner-feat-text">Approved profiles gain local homomorphic encryption capabilities.</div>
          </div>
          <div class="split-banner-feat">
            <div class="split-banner-feat-icon" style="color: var(--success);"><i class="bi bi-check-lg"></i></div>
            <div class="split-banner-feat-text">Access verification auditable via the Secure Coprocessor (SCP).</div>
          </div>
          <div class="split-banner-feat">
            <div class="split-banner-feat-icon" style="color: var(--success);"><i class="bi bi-check-lg"></i></div>
            <div class="split-banner-feat-text">Automatic registration logs reported directly to Cloud Servers.</div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Right Column: Registration Card -->
    <div class="split-form-side">
      
      <!-- Back to Login -->
      <div style="width: 100%; max-width: 440px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
        <a href="login.jsp" class="btn btn-secondary btn-sm" style="border: 1px solid var(--border);"><i class="bi bi-arrow-left"></i> Back to Login</a>
        <button class="theme-toggle" aria-label="Toggle Dark Mode"></button>
      </div>

      <!-- Registration Form Card -->
      <div class="card" style="width: 100%; max-width: 440px; box-shadow: var(--shadow-md);">
        
        <!-- Header -->
        <div style="display: flex; align-items: center; gap: 14px; margin-bottom: 20px;">
          <div id="cardIcon" style="width: 42px; height: 42px; border-radius: var(--radius-md); background-color: var(--success-light); display: flex; align-items: center; justify-content: center; font-size: 20px; color: var(--success);">
            <i class="bi bi-person-fill-up"></i>
          </div>
          <div>
            <h2 id="cardTitle" style="font-size: 16px; font-weight: 600;">Create Data Owner Account</h2>
            <p id="cardSub" style="font-size: 11px; color: var(--text-muted); margin-top: 1px;">Register to start uploading encrypted files</p>
          </div>
        </div>

        <!-- Role Selector Tabs -->
        <div class="role-tabs" style="margin-bottom: 20px;">
          <button class="role-tab do active" onclick="switchRole('dataowner', this)" style="padding: 10px;">Data Owner</button>
          <button class="role-tab dc" onclick="switchRole('dataconsumer', this)" style="padding: 10px;">Data Consumer</button>
        </div>

        <!-- Step indicators -->
        <div class="step-indicator">
          <div class="step-dot active" id="dot-1">1</div>
          <div class="step-dot" id="dot-2">2</div>
        </div>

        <!-- Main Form -->
        <form action="RegisterServlet" method="post" id="regForm">
          <input type="hidden" name="role" id="roleField" value="dataowner" />

          <!-- Step 1: Personal details -->
          <div class="form-step active" id="step-1">
            <div class="form-group">
              <label class="form-label">Full Name *</label>
              <div class="input-wrapper">
                <i class="bi bi-person-fill"></i>
                <input type="text" id="nameField" name="name" class="form-input" placeholder="John Doe" required />
              </div>
            </div>
            
            <div class="form-group">
              <label class="form-label">Mobile Number</label>
              <div class="input-wrapper">
                <i class="bi bi-telephone-fill"></i>
                <input type="tel" name="mobile" class="form-input" placeholder="9876500000" />
              </div>
            </div>

            <div class="form-group">
              <label class="form-label">Address</label>
              <div class="input-wrapper">
                <i class="bi bi-geo-alt-fill" style="top: 14px;"></i>
                <textarea name="address" class="form-input" placeholder="Your residential address (optional)" style="padding-left: 36px; min-height: 70px;"></textarea>
              </div>
            </div>

            <button type="button" class="btn btn-primary" onclick="nextStep()" style="width: 100%; margin-top: 10px; padding: 11px;">
              Continue to Step 2 &rarr;
            </button>
          </div>

          <!-- Step 2: Credentials -->
          <div class="form-step" id="step-2">
            <div class="form-group">
              <label class="form-label">Email Address *</label>
              <div class="input-wrapper">
                <i class="bi bi-envelope-fill"></i>
                <input type="email" id="emailField" name="email" class="form-input" placeholder="name@securerank.com" required />
              </div>
            </div>

            <div class="form-group">
              <label class="form-label">Password *</label>
              <div class="input-wrapper">
                <i class="bi bi-lock-fill"></i>
                <input type="password" name="password" class="form-input password-meter" placeholder="Minimum 6 characters" required minlength="6" />
              </div>
            </div>

            <!-- Approval Notice -->
            <div class="badge badge-warning" style="display: flex; gap: 8px; font-size: 11px; padding: 10px; border-radius: var(--radius-md); line-height: 1.4; margin-bottom: 20px; width: 100%; text-align: left;">
              <i class="bi bi-exclamation-triangle-fill" style="font-size: 14px;"></i>
              <div>Your account status will remain <strong>Pending</strong> until approved by the Cloud Server Administrator.</div>
            </div>

            <div style="display: flex; gap: 8px; margin-top: 10px;">
              <button type="button" class="btn btn-secondary" onclick="prevStep()" style="flex: 1; padding: 11px;">
                &larr; Back
              </button>
              <button type="submit" class="btn btn-success" id="submitBtn" style="flex: 1.5; padding: 11px;">
                Register Profile &rarr;
              </button>
            </div>
          </div>
        </form>

        <hr style="border: none; border-top: 1px solid var(--border); margin: 20px 0;" />
        
        <div style="text-align: center; font-size: 13px; color: var(--text-muted);">
          Already have an account? <a href="login.jsp" style="color: var(--primary); text-decoration: none; font-weight: 500;">Login here</a>
        </div>
      </div>
      
    </div>
    
  </div>

  <script src="js/theme.js"></script>
  <script>
    // URL Pre-selection
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
      document.getElementById('cardSub').textContent = 'Register to start uploading encrypted files';
      document.getElementById('submitBtn').textContent = 'Register Profile \u2192';
      
      var btn = document.getElementById('submitBtn');
      btn.className = 'btn btn-success';
      
      var icon = document.getElementById('cardIcon');
      icon.style.backgroundColor = 'var(--success-light)';
      icon.style.color = 'var(--success)';
      icon.innerHTML = '<i class="bi bi-person-fill-up"></i>';
    }

    function setDCMode() {
      document.getElementById('roleField').value = 'dataconsumer';
      document.getElementById('cardTitle').textContent = 'Create Data Consumer Account';
      document.getElementById('cardSub').textContent = 'Register to search and retrieve files';
      document.getElementById('submitBtn').textContent = 'Register Profile \u2192';
      
      var btn = document.getElementById('submitBtn');
      btn.className = 'btn btn-primary';
      
      var icon = document.getElementById('cardIcon');
      icon.style.backgroundColor = 'var(--primary-light)';
      icon.style.color = 'var(--primary)';
      icon.innerHTML = '<i class="bi bi-person-fill-lock"></i>';
    }

    // Wizard Controls
    function nextStep() {
      // Basic validation for step 1
      var name = document.getElementById('nameField').value.trim();
      if (!name) {
        showToast('Please enter your full name', 'error');
        return;
      }
      
      document.getElementById('step-1').classList.remove('active');
      document.getElementById('step-2').classList.add('active');
      
      document.getElementById('dot-1').classList.add('completed');
      document.getElementById('dot-2').classList.add('active');
    }

    function prevStep() {
      document.getElementById('step-2').classList.remove('active');
      document.getElementById('step-1').classList.add('active');
      
      document.getElementById('dot-1').classList.remove('completed');
      document.getElementById('dot-2').classList.remove('active');
    }
  </script>
</body>
</html>
