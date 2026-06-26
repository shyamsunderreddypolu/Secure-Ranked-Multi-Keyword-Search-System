<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession, java.sql.*" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("csemail") == null) {
        response.sendRedirect("login.jsp?role=admin");
        return;
    }
    String csName  = (String) s.getAttribute("csname");
    String csEmail = (String) s.getAttribute("csemail");

    // Dynamic counts for dashboard stats
    int doCount = 0, dcCount = 0, fileCount = 0, pendingDO = 0, pendingDC = 0, totalRequests = 0;
    Connection con = null;
    try {
        con = com.dao.DBConnection.connect();
        Statement st = con.createStatement();
        ResultSet rs;
        
        rs = st.executeQuery("select count(*) from doregister"); if(rs.next()) doCount = rs.getInt(1); rs.close();
        rs = st.executeQuery("select count(*) from dcregister"); if(rs.next()) dcCount = rs.getInt(1); rs.close();
        rs = st.executeQuery("select count(*) from upload");     if(rs.next()) fileCount = rs.getInt(1); rs.close();
        rs = st.executeQuery("select count(*) from doregister where status1='Pending'"); if(rs.next()) pendingDO = rs.getInt(1); rs.close();
        rs = st.executeQuery("select count(*) from dcregister where status='Pending'");  if(rs.next()) pendingDC = rs.getInt(1); rs.close();
        rs = st.executeQuery("select count(*) from request");    if(rs.next()) totalRequests = rs.getInt(1); rs.close();
        
        st.close();
    } catch(Exception e){ 
        e.printStackTrace(); 
    } finally { 
        try{ if(con!=null) con.close(); }catch(Exception ignored){} 
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard — SecureRank</title>
  
  <!-- Font and Icon Resources -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <link rel="stylesheet" href="css/style.css">
  
  <style>
    /* Specific styles for CSHome */
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
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
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
      position: relative;
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
    
    .pending-dot-badge {
      position: absolute;
      top: 16px;
      right: 16px;
      background-color: var(--danger);
      color: #ffffff;
      font-size: 11px;
      font-weight: 600;
      padding: 2px 8px;
      border-radius: 999px;
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
          <div class="sidebar-logo-sub">Cloud Admin Panel</div>
        </div>
      </div>
      
      <ul class="sidebar-menu">
        <li>
          <a href="CSHome.jsp" class="sidebar-link active">
            <i class="bi bi-grid-fill"></i> <span>Dashboard</span>
          </a>
        </li>
        <li>
          <a href="ViewDOList.jsp" class="sidebar-link">
            <i class="bi bi-people-fill"></i> <span>Manage Owners</span>
            <% if (pendingDO > 0) { %><span class="badge badge-danger" style="margin-left:auto; font-size: 10px; padding: 2px 6px;"><%= pendingDO %></span><% } %>
          </a>
        </li>
        <li>
          <a href="ViewDCList.jsp" class="sidebar-link">
            <i class="bi bi-people-fill"></i> <span>Manage Consumers</span>
            <% if (pendingDC > 0) { %><span class="badge badge-danger" style="margin-left:auto; font-size: 10px; padding: 2px 6px;"><%= pendingDC %></span><% } %>
          </a>
        </li>
        <li>
          <a href="ViewUploadedFiles.jsp" class="sidebar-link">
            <i class="bi bi-folder-fill"></i> <span>View Encrypted Files</span>
          </a>
        </li>
        <li>
          <a href="ViewSearchRequests.jsp" class="sidebar-link">
            <i class="bi bi-activity"></i> <span>Search Activity</span>
          </a>
        </li>
        <li>
          <a href="DCDecryptRequest.jsp" class="sidebar-link">
            <i class="bi bi-key-fill"></i> <span>Decrypt Requests</span>
          </a>
        </li>
        <li>
          <a href="ViewEqualityCheck.jsp" class="sidebar-link">
            <i class="bi bi-clipboard-check-fill"></i> <span>Equality Verifications</span>
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
          <%= csName.substring(0, Math.min(csName.length(), 2)).toUpperCase() %>
        </div>
        <div style="min-width: 0; flex: 1;">
          <div class="sidebar-user-name" title="<%= csName %>"><%= csName %></div>
          <div class="sidebar-user-role">Cloud Administrator</div>
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
            <a href="CSHome.jsp" style="color: var(--primary); text-decoration: none; font-weight: 500;">Console</a>
            <i class="bi bi-chevron-right" style="font-size: 9px; color: var(--text-faint);"></i>
            <span>Dashboard</span>
          </div>
        </div>

        <div class="topnav-actions">
          <!-- Notification Icon -->
          <div style="position: relative; font-size: 18px; color: var(--text-muted); cursor: pointer;" onclick="showToast('No new notifications.', 'info')">
            <i class="bi bi-bell"></i>
            <% if (pendingDO + pendingDC > 0) { %><span style="position: absolute; top: -2px; right: -2px; width: 8px; height: 8px; background-color: var(--danger); border-radius: 50%;"></span><% } %>
          </div>
          
          <!-- Theme toggle -->
          <button class="theme-toggle" aria-label="Toggle Dark Mode"></button>
          
          <!-- User Profile Dropdown -->
          <div style="font-size: 13px; color: var(--text-muted); border-left: 1px solid var(--border); padding-left: 16px;">
            Logged in: <strong style="color: var(--text-main);"><%= csEmail %></strong>
          </div>
        </div>
      </header>
      
      <!-- Content Body -->
      <div class="content-body">
        
        <!-- Welcome Banner -->
        <div class="dashboard-header" style="background-color: var(--primary);">
          <h2 class="header-title">Welcome back, <%= csName %>!</h2>
          <p class="header-sub">Manage user registrations, approve pending credentials, and monitor encrypted indexes and consumer search validations across the network.</p>
          <div class="header-meta"><%= csEmail %></div>
        </div>
        
        <h3 class="section-label">Summary Statistics</h3>
        
        <!-- Stats Summary Cards Grid -->
        <div class="stats-grid" style="grid-template-columns: repeat(4, 1fr); margin-bottom: 32px;">
          <div class="metric-card">
            <div class="metric-icon primary">
              <i class="bi bi-cloud-check-fill"></i>
            </div>
            <div class="metric-info">
              <div class="metric-value"><%= fileCount %></div>
              <div class="metric-label">Files Stored</div>
              <div style="font-size: 10px; color: var(--success); margin-top: 4px; font-weight: 500;"><i class="bi bi-arrow-up-short"></i> +16% this month</div>
            </div>
          </div>
          
          <div class="metric-card">
            <div class="metric-icon success">
              <i class="bi bi-people-fill"></i>
            </div>
            <div class="metric-info">
              <div class="metric-value"><%= doCount + dcCount %></div>
              <div class="metric-label">Active Users</div>
              <div style="font-size: 10px; color: var(--success); margin-top: 4px; font-weight: 500;"><i class="bi bi-arrow-up-short"></i> +3% this week</div>
            </div>
          </div>
          
          <div class="metric-card">
            <div class="metric-icon warning">
              <i class="bi bi-hdd-fill"></i>
            </div>
            <div class="metric-info">
              <div class="metric-value">42.8%</div>
              <div class="metric-label">Storage Usage</div>
              <div style="font-size: 10px; color: var(--text-muted); margin-top: 4px;">42.8 GB / 100 GB allocated</div>
            </div>
          </div>
          
          <div class="metric-card">
            <div class="metric-icon primary" style="background-color: var(--purple-bg); color: var(--purple-mid); border-color: var(--purple-bdr);">
              <i class="bi bi-activity"></i>
            </div>
            <div class="metric-info">
              <div class="metric-value"><%= totalRequests %></div>
              <div class="metric-label">Search Requests</div>
              <div style="font-size: 10px; color: var(--success); margin-top: 4px; font-weight: 500;"><i class="bi bi-arrow-up-short"></i> +12% this week</div>
            </div>
          </div>
        </div>

        <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 24px; margin-bottom: 32px;">
          
          <!-- Left: Admin Controls Grid -->
          <div>
            <h3 class="section-label" style="margin-top: 0;">Admin Controls</h3>
            <div class="cards-grid">
              
              <a href="ViewDOList.jsp" class="action-card">
                <% if (pendingDO > 0) { %>
                  <div class="pending-dot-badge"><%= pendingDO %> Pending</div>
                <% } %>
                <div class="action-icon">
                  <i class="bi bi-people-fill"></i>
                </div>
                <div class="action-title">Manage Data Owners</div>
                <div class="action-desc">Review profiles and approve or reject pending Data Owner registration requests.</div>
                <div class="action-arrow">View DO List &rarr;</div>
              </a>
              
              <a href="ViewDCList.jsp" class="action-card">
                <% if (pendingDC > 0) { %>
                  <div class="pending-dot-badge"><%= pendingDC %> Pending</div>
                <% } %>
                <div class="action-icon" style="color: var(--success); background-color: var(--success-light); border-color: var(--success-border);">
                  <i class="bi bi-people-fill"></i>
                </div>
                <div class="action-title">Manage Data Consumers</div>
                <div class="action-desc">Manage consumer authorization levels. Approve pending consumer accounts.</div>
                <div class="action-arrow" style="color: var(--success);">View DC List &rarr;</div>
              </a>
              
              <a href="ViewUploadedFiles.jsp" class="action-card">
                <div class="action-icon" style="color: var(--warning); background-color: var(--warning-light); border-color: var(--warning-border);">
                  <i class="bi bi-folder-fill"></i>
                </div>
                <div class="action-title">View Encrypted Files</div>
                <div class="action-desc">Monitor the cloud storage database and audit encrypted metadata entries.</div>
                <div class="action-arrow" style="color: var(--warning);">View Files &rarr;</div>
              </a>
              
              <a href="ViewSearchRequests.jsp" class="action-card">
                <div class="action-icon" style="color: var(--purple-mid); background-color: var(--purple-bg); border-color: var(--purple-bdr);">
                  <i class="bi bi-activity"></i>
                </div>
                <div class="action-title">Search Activity</div>
                <div class="action-desc">Track queries, response statistics, and keyword evaluation queries on the index.</div>
                <div class="action-arrow" style="color: var(--purple-mid);">View Activity &rarr;</div>
              </a>
              
              <a href="DCDecryptRequest.jsp" class="action-card">
                <div class="action-icon" style="color: var(--danger); background-color: var(--danger-light); border-color: var(--danger-border);">
                  <i class="bi bi-key-fill"></i>
                </div>
                <div class="action-title">Decrypt Requests</div>
                <div class="action-desc">Approve or reject data consumer decryption queries seeking master key releases.</div>
                <div class="action-arrow" style="color: var(--danger);">View Requests &rarr;</div>
              </a>
              
              <a href="ViewEqualityCheck.jsp" class="action-card">
                <div class="action-icon" style="color: #7c6514; background-color: #fbf7e3; border-color: #ebdca5;">
                  <i class="bi bi-clipboard-check-fill"></i>
                </div>
                <div class="action-title">Equality Verification</div>
                <div class="action-desc">Audit the cryptographic output vectors verified by the Secure Coprocessor.</div>
                <div class="action-arrow" style="color: #7c6514;">View Checks &rarr;</div>
              </a>
              
            </div>
          </div>

          <!-- Right: Recent Activity Timeline -->
          <div class="card" style="align-self: flex-start;">
            <h3 style="font-size: 14px; font-weight: 600; margin-bottom: 16px; border-bottom: 1px solid var(--border); padding-bottom: 12px;"><i class="bi bi-clock-history"></i> System Activity</h3>
            
            <div class="timeline">
              <div class="timeline-item">
                <div class="timeline-icon" style="color: var(--success); background-color: var(--success-light); border-color: var(--success-border);"><i class="bi bi-person-plus-fill"></i></div>
                <div class="timeline-body">
                  <div class="timeline-title">New Data Owner registered</div>
                  <div class="timeline-time">12 mins ago</div>
                </div>
              </div>
              <div class="timeline-item">
                <div class="timeline-icon" style="color: var(--primary); background-color: var(--primary-light); border-color: var(--primary-border);"><i class="bi bi-shield-check"></i></div>
                <div class="timeline-body">
                  <div class="timeline-title">Storage block audited by SCP</div>
                  <div class="timeline-time">2 hours ago</div>
                </div>
              </div>
              <div class="timeline-item">
                <div class="timeline-icon" style="color: var(--warning); background-color: var(--warning-light); border-color: var(--warning-border);"><i class="bi bi-activity"></i></div>
                <div class="timeline-body">
                  <div class="timeline-title">File matching request logged</div>
                  <div class="timeline-time">Yesterday</div>
                </div>
              </div>
              <div class="timeline-item">
                <div class="timeline-icon"><i class="bi bi-gear-fill"></i></div>
                <div class="timeline-body">
                  <div class="timeline-title">Coprocessor keys re-hashed</div>
                  <div class="timeline-time">3 days ago</div>
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
