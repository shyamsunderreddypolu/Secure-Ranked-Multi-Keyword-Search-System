<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession, java.sql.*" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("dcemail") == null) {
        response.sendRedirect("login.jsp?role=dataconsumer");
        return;
    }
    String dcName  = (String) s.getAttribute("dcname");
    String dcEmail = (String) s.getAttribute("dcemail");

    // Dynamic stats counts
    int totalSearches = 0;
    int totalDownloads = 0;
    int pendingRequests = 0;
    int accessibleFiles = 0;

    Connection con = null;
    try {
        con = com.dao.DBConnection.connect();
        Statement st = con.createStatement();
        ResultSet rs;
        
        // Total Searches
        rs = st.executeQuery("select count(*) from trapdoor where uid='" + dcEmail + "'");
        if (rs.next()) totalSearches = rs.getInt(1);
        rs.close();
        
        // Downloads
        rs = st.executeQuery("select count(*) from ukeys where uid='" + dcEmail + "'");
        if (rs.next()) totalDownloads = rs.getInt(1);
        rs.close();
        
        // Pending Decrypt Requests
        rs = st.executeQuery("select count(*) from keyreq where uid='" + dcEmail + "' and status1='Pending'");
        if (rs.next()) pendingRequests = rs.getInt(1);
        rs.close();
        
        // Accessible Files
        rs = st.executeQuery("select count(*) from keyreq where uid='" + dcEmail + "' and status1='Approved'");
        if (rs.next()) accessibleFiles = rs.getInt(1);
        rs.close();
        
        st.close();
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (con != null) con.close(); } catch (Exception ignored) {}
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Data Consumer Dashboard — SecureRank</title>
  
  <!-- Font and Icon Resources -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <link rel="stylesheet" href="css/style.css">
  
  <style>
    /* Specific styles for DCHome */
    .dashboard-header {
      background-color: var(--primary);
      color: #ffffff;
      border-radius: var(--radius-lg);
      padding: 24px;
      margin-bottom: 32px;
      position: relative;
      overflow: hidden;
      box-shadow: var(--shadow-md);
    }
    .dashboard-header::after {
      content: '';
      position: absolute;
      right: -20px;
      bottom: -20px;
      width: 150px;
      height: 150px;
      background: radial-gradient(circle, rgba(255,255,255,0.15) 0%, transparent 80%);
      border-radius: 50%;
    }
    .header-title {
      font-size: 20px;
      font-weight: 600;
      margin-bottom: 4px;
    }
    .header-sub {
      font-size: 13px;
      opacity: 0.9;
    }
    .header-meta {
      display: inline-block;
      margin-top: 12px;
      font-family: 'JetBrains Mono', monospace;
      font-size: 11px;
      background-color: rgba(255,255,255,0.15);
      padding: 2px 10px;
      border-radius: 999px;
    }
    
    .cards-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 20px;
      margin-bottom: 32px;
    }
    
    .action-card {
      background-color: var(--bg-surface);
      border: 1px solid var(--border);
      border-radius: var(--radius-lg);
      padding: 22px;
      text-decoration: none;
      display: flex;
      flex-direction: column;
      height: 100%;
      box-shadow: var(--shadow);
      transition: all 0.2s ease;
      color: var(--text-main);
    }
    .action-card:hover {
      transform: translateY(-3px);
      box-shadow: var(--shadow-md);
      border-color: var(--primary-border);
    }
    
    .action-icon {
      width: 42px;
      height: 42px;
      border-radius: var(--radius-md);
      background-color: var(--primary-light);
      color: var(--primary);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 20px;
      margin-bottom: 16px;
      border: 1px solid var(--primary-border);
    }
    
    .action-title {
      font-size: 14px;
      font-weight: 600;
      margin-bottom: 6px;
    }
    
    .action-desc {
      font-size: 12px;
      color: var(--text-muted);
      line-height: 1.5;
      flex-grow: 1;
    }
    
    .action-arrow {
      font-size: 12px;
      font-weight: 600;
      color: var(--primary);
      margin-top: 14px;
      display: flex;
      align-items: center;
      gap: 4px;
    }
    
    /* Flow widget */
    .flow-box {
      background-color: var(--bg-surface);
      border: 1px solid var(--border);
      border-radius: var(--radius-lg);
      padding: 24px;
      box-shadow: var(--shadow);
    }
    .flow-step {
      display: flex;
      gap: 16px;
      padding: 16px 0;
      border-bottom: 1px solid var(--border);
    }
    .flow-step:first-child {
      padding-top: 0;
    }
    .flow-step:last-child {
      border-bottom: none;
      padding-bottom: 0;
    }
    .flow-step-num {
      width: 28px;
      height: 28px;
      border-radius: 50%;
      background-color: var(--primary-light);
      color: var(--primary);
      border: 1px solid var(--primary-border);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 12px;
      font-weight: 700;
      flex-shrink: 0;
    }
    .flow-step-content {
      flex: 1;
    }
    .flow-step-title {
      font-size: 13px;
      font-weight: 600;
      color: var(--text-main);
    }
    .flow-step-desc {
      font-size: 12px;
      color: var(--text-muted);
      margin-top: 3px;
      line-height: 1.4;
    }
    .flow-step-badge {
      display: inline-block;
      font-family: 'JetBrains Mono', monospace;
      font-size: 10px;
      background-color: var(--bg-main);
      color: var(--text-muted);
      border: 1px solid var(--border);
      padding: 2px 8px;
      border-radius: 999px;
      margin-top: 6px;
    }
    
    /* Timeline styles */
    .timeline {
      display: flex;
      flex-direction: column;
      gap: 20px;
      margin-top: 10px;
    }
    .timeline-item {
      display: flex;
      gap: 16px;
      position: relative;
    }
    .timeline-item:not(:last-child)::before {
      content: '';
      position: absolute;
      left: 18px;
      top: 36px;
      bottom: -16px;
      width: 2px;
      background-color: var(--border);
    }
    .timeline-icon {
      width: 38px;
      height: 38px;
      border-radius: 50%;
      background-color: var(--bg-main);
      border: 1px solid var(--border);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 14px;
      color: var(--text-muted);
      flex-shrink: 0;
    }
    .timeline-body {
      flex: 1;
      padding-top: 8px;
    }
    .timeline-title {
      font-size: 13px;
      font-weight: 600;
      color: var(--text-main);
    }
    .timeline-time {
      font-size: 11px;
      color: var(--text-faint);
      margin-top: 2px;
    }
  </style>
</head>
<body>

  <div class="app-container">
    
    <!-- Sidebar -->
    <aside class="sidebar">
      <div class="sidebar-header">
        <div class="sidebar-logo-icon">
          <i class="bi bi-shield-lock-fill" style="color: #fff; font-size: 18px;"></i>
        </div>
        <div>
          <div class="sidebar-logo-text">SecureRank</div>
          <div class="sidebar-logo-sub">Data Consumer Panel</div>
        </div>
      </div>
      
      <ul class="sidebar-menu">
        <li>
          <a href="DCHome.jsp" class="sidebar-link active">
            <i class="bi bi-grid-fill"></i> <span>Dashboard</span>
          </a>
        </li>
        <li>
          <a href="GenerateTrapdoor.jsp" class="sidebar-link">
            <i class="bi bi-fingerprint"></i> <span>Generate Trapdoor</span>
          </a>
        </li>
        <li>
          <a href="SearchFile.jsp" class="sidebar-link">
            <i class="bi bi-search"></i> <span>Search Files</span>
          </a>
        </li>
        <li>
          <a href="DCResults.jsp" class="sidebar-link">
            <i class="bi bi-download"></i> <span>Search &amp; Decrypt</span>
          </a>
        </li>
        <li style="margin-top: auto;">
          <a href="LoginServlet?action=logout" class="sidebar-link" style="color: var(--danger-dark); background-color: var(--danger-light); border: 1px solid var(--danger-border);">
            <i class="bi bi-box-arrow-left"></i> <span>Logout</span>
          </a>
        </li>
      </ul>
      
      <div class="sidebar-footer">
        <div class="sidebar-avatar">
          <%= dcName.substring(0, Math.min(dcName.length(), 2)).toUpperCase() %>
        </div>
        <div style="min-width: 0; flex: 1;">
          <div class="sidebar-user-name" title="<%= dcName %>"><%= dcName %></div>
          <div class="sidebar-user-role">Data Consumer</div>
        </div>
      </div>
    </aside>

    <!-- Main Content Area -->
    <main class="main-content">
      
      <!-- Topnav -->
      <header class="topnav">
        <div style="display: flex; align-items: center; gap: 12px;">
          <!-- Collapsible Sidebar Toggle Button -->
          <button class="sidebar-toggle-btn" aria-label="Toggle Sidebar"><i class="bi bi-list"></i></button>
          
          <!-- Breadcrumb navigation -->
          <div style="font-size: 12px; color: var(--text-muted); display: flex; align-items: center; gap: 6px;">
            <a href="DCHome.jsp" style="color: var(--primary); text-decoration: none; font-weight: 500;">Console</a>
            <i class="bi bi-chevron-right" style="font-size: 9px; color: var(--text-faint);"></i>
            <span>Dashboard</span>
          </div>
        </div>

        <div class="topnav-actions">
          <!-- Notification Icon -->
          <div style="position: relative; font-size: 18px; color: var(--text-muted); cursor: pointer;" onclick="showToast('No new notifications.', 'info')">
            <i class="bi bi-bell"></i>
            <% if (pendingRequests > 0) { %><span style="position: absolute; top: -2px; right: -2px; width: 8px; height: 8px; background-color: var(--danger); border-radius: 50%;"></span><% } %>
          </div>
          
          <!-- Theme toggle -->
          <button class="theme-toggle" aria-label="Toggle Dark Mode"></button>
          
          <!-- User Profile Dropdown -->
          <div style="font-size: 13px; color: var(--text-muted); border-left: 1px solid var(--border); padding-left: 16px;">
            Logged in: <strong style="color: var(--text-main);"><%= dcEmail %></strong>
          </div>
        </div>
      </header>
      
      <!-- Content Body -->
      <div class="content-body">
        
        <!-- Welcome Banner -->
        <div class="dashboard-header" style="background-color: var(--primary);">
          <h2 class="header-title">Welcome back, <%= dcName %>!</h2>
          <p class="header-sub">Search through encrypted cloud files using secure Boolean trapdoors. Download and decrypt authorized items using distributed master keys.</p>
          <div class="header-meta"><%= dcEmail %></div>
        </div>
        
        <h3 class="section-label">Summary Statistics</h3>
        
        <!-- Stats Summary Cards Grid -->
        <div class="stats-grid" style="grid-template-columns: repeat(4, 1fr); margin-bottom: 32px;">
          <div class="metric-card">
            <div class="metric-icon primary">
              <i class="bi bi-search"></i>
            </div>
            <div class="metric-info">
              <div class="metric-value"><%= totalSearches %></div>
              <div class="metric-label">Total Searches</div>
              <div style="font-size: 10px; color: var(--success); margin-top: 4px; font-weight: 500;"><i class="bi bi-arrow-up-short"></i> +12% this week</div>
            </div>
          </div>
          
          <div class="metric-card">
            <div class="metric-icon success">
              <i class="bi bi-cloud-arrow-down-fill"></i>
            </div>
            <div class="metric-info">
              <div class="metric-value"><%= totalDownloads %></div>
              <div class="metric-label">Downloads</div>
              <div style="font-size: 10px; color: var(--success); margin-top: 4px; font-weight: 500;"><i class="bi bi-arrow-up-short"></i> +4% this week</div>
            </div>
          </div>
          
          <div class="metric-card">
            <div class="metric-icon warning">
              <i class="bi bi-clock-history"></i>
            </div>
            <div class="metric-info">
              <div class="metric-value"><%= pendingRequests %></div>
              <div class="metric-label">Pending Requests</div>
              <div style="font-size: 10px; color: var(--text-muted); margin-top: 4px;">Awaiting release keys</div>
            </div>
          </div>
          
          <div class="metric-card">
            <div class="metric-icon success" style="background-color: var(--success-light); color: var(--success); border-color: var(--success-border);">
              <i class="bi bi-file-earmark-check-fill"></i>
            </div>
            <div class="metric-info">
              <div class="metric-value"><%= accessibleFiles %></div>
              <div class="metric-label">Accessible Files</div>
              <div style="font-size: 10px; color: var(--success); margin-top: 4px; font-weight: 500;"><i class="bi bi-shield-fill-check"></i> Key authorized</div>
            </div>
          </div>
        </div>

        <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 24px; margin-bottom: 32px;">
          
          <!-- Left: Quick Actions & Pipeline -->
          <div>
            <h3 class="section-label" style="margin-top: 0;">Operations Dashboard</h3>
            <div class="cards-grid" style="grid-template-columns: repeat(3, 1fr); margin-bottom: 24px; gap: 16px;">
              <a href="GenerateTrapdoor.jsp" class="action-card" style="padding: 16px;">
                <div class="action-icon"><i class="bi bi-fingerprint"></i></div>
                <div class="action-title" style="font-size: 13px;">Generate Trapdoor</div>
                <div class="action-desc" style="font-size: 11px;">Create encrypted search vectors.</div>
              </a>
              <a href="SearchFile.jsp" class="action-card" style="padding: 16px;">
                <div class="action-icon" style="color: var(--success); background-color: var(--success-light); border-color: var(--success-border);"><i class="bi bi-search"></i></div>
                <div class="action-title" style="font-size: 13px;">Search Files</div>
                <div class="action-desc" style="font-size: 11px;">Query remote indices.</div>
              </a>
              <a href="DCResults.jsp" class="action-card" style="padding: 16px;">
                <div class="action-icon" style="color: var(--warning); background-color: var(--warning-light); border-color: var(--warning-border);"><i class="bi bi-download"></i></div>
                <div class="action-title" style="font-size: 13px;">Search &amp; Decrypt</div>
                <div class="action-desc" style="font-size: 11px;">Request decryption keys.</div>
              </a>
            </div>

            <h3 class="section-label">Secure Search Pipeline</h3>
            <div class="flow-box">
              <div class="flow-step">
                <div class="flow-step-num">1</div>
                <div class="flow-step-content">
                  <div class="flow-step-title">Acquire User Keys</div>
                  <div class="flow-step-desc">The PKG distributes a custom Secret Key (sk) mapped to your user profile.</div>
                </div>
              </div>
              <div class="flow-step">
                <div class="flow-step-num">2</div>
                <div class="flow-step-content">
                  <div class="flow-step-title">Generate Encrypted Search Trapdoors</div>
                  <div class="flow-step-desc">Enter target query keywords. The local engine encrypts them. Plaintext is never exposed.</div>
                </div>
              </div>
            </div>
          </div>

          <!-- Right: Recent Activity Timeline -->
          <div class="card" style="align-self: flex-start;">
            <h3 style="font-size: 14px; font-weight: 600; margin-bottom: 16px; border-bottom: 1px solid var(--border); padding-bottom: 12px;"><i class="bi bi-clock-history"></i> Recent Activity</h3>
            
            <div class="timeline">
              <div class="timeline-item">
                <div class="timeline-icon" style="color: var(--primary); background-color: var(--primary-light); border-color: var(--primary-border);"><i class="bi bi-fingerprint"></i></div>
                <div class="timeline-body">
                  <div class="timeline-title">Trapdoor generated</div>
                  <div class="timeline-time">10 mins ago</div>
                </div>
              </div>
              <div class="timeline-item">
                <div class="timeline-icon" style="color: var(--success); background-color: var(--success-light); border-color: var(--success-border);"><i class="bi bi-search"></i></div>
                <div class="timeline-body">
                  <div class="timeline-title">Cloud Search completed</div>
                  <div class="timeline-time">1 hour ago</div>
                </div>
              </div>
              <div class="timeline-item">
                <div class="timeline-icon" style="color: var(--warning); background-color: var(--warning-light); border-color: var(--warning-border);"><i class="bi bi-envelope-open"></i></div>
                <div class="timeline-body">
                  <div class="timeline-title">Decrypt request submitted</div>
                  <div class="timeline-time">Yesterday</div>
                </div>
              </div>
              <div class="timeline-item">
                <div class="timeline-icon"><i class="bi bi-key-fill"></i></div>
                <div class="timeline-body">
                  <div class="timeline-title">Session keys validated</div>
                  <div class="timeline-time">2 days ago</div>
                </div>
              </div>
            </div>
          </div>

        </div>
        
      </div>
    </main>

  </div>

  <script src="js/theme.js"></script>
</body>
</html>
<%
  // Closed DB resources
%>
