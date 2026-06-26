<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession, java.sql.*" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("dcemail") == null) {
        response.sendRedirect("login.jsp?role=dataconsumer");
        return;
    }
    String dcEmail = (String) s.getAttribute("dcemail");
    String dcName  = (String) s.getAttribute("dcname");

    // Load existing trapdoors for this DC
    Connection con = com.dao.DBConnection.connect();
    ResultSet  rs  = null;
    Statement  st  = null;
    try {
        st = con.createStatement();
        rs = st.executeQuery(
            "select id, name, trap from trapdoor where uid='"
            + dcEmail + "' order by id desc");
    } catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Generate Trapdoor — SecureRank</title>
  
  <!-- Font and Icon Resources -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <link rel="stylesheet" href="css/style.css">
  
  <style>
    /* Specific styles for GenerateTrapdoor page */
    .split-layout {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 24px;
      margin-bottom: 32px;
    }
    @media(max-width: 768px) {
      .split-layout {
        grid-template-columns: 1fr;
      }
    }
    .info-card {
      background-color: var(--primary-light);
      border: 1px solid var(--primary-border);
      border-radius: var(--radius-lg);
      padding: 24px;
      color: var(--primary);
    }
    .info-card-title {
      font-size: 15px;
      font-weight: 600;
      margin-bottom: 12px;
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .info-card-step {
      font-size: 12px;
      line-height: 1.5;
      margin-bottom: 12px;
    }
    .info-card-step:last-child {
      margin-bottom: 0;
    }
    .trap-val {
      font-family: 'JetBrains Mono', monospace;
      font-size: 11px;
      color: var(--primary);
      background-color: var(--bg-main);
      padding: 2px 8px;
      border-radius: var(--radius-sm);
      border: 1px solid var(--border);
      max-width: 250px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
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
          <a href="DCHome.jsp" class="sidebar-link">
            <i class="bi bi-grid-fill"></i> Dashboard
          </a>
        </li>
        <li>
          <a href="GenerateTrapdoor.jsp" class="sidebar-link active">
            <i class="bi bi-fingerprint"></i> Generate Trapdoor
          </a>
        </li>
        <li>
          <a href="SearchFile.jsp" class="sidebar-link">
            <i class="bi bi-search"></i> Search Files
          </a>
        </li>
        <li>
          <a href="DCResults.jsp" class="sidebar-link">
            <i class="bi bi-download"></i> Search &amp; Decrypt
          </a>
        </li>
        <li style="margin-top: auto;">
          <a href="LoginServlet?action=logout" class="sidebar-link" style="color: var(--danger-dark); background-color: var(--danger-light); border: 1px solid var(--danger-border);">
            <i class="bi bi-box-arrow-left"></i> Logout
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
        <div class="topnav-title">Generate Query Trapdoor</div>
        <div class="topnav-actions">
          <button class="theme-toggle" aria-label="Toggle Dark Mode"></button>
          <div style="font-size: 13px; color: var(--text-muted);">
            Logged in: <strong style="color: var(--text-main);"><%= dcEmail %></strong>
          </div>
        </div>
      </header>
      
      <!-- Content Body -->
      <div class="content-body">
        
        <div style="margin-bottom: 24px;">
          <h2 style="font-size: 20px; font-weight: 600;">Cryptographic Query Trapdoor</h2>
          <p style="font-size: 13px; color: var(--text-muted); margin-top: 2px;">Tag query keywords into dynamic secure trapdoors. The cloud server processes matches without learning plaintext values.</p>
        </div>

        <div class="split-layout">
          
          <!-- Left: Form -->
          <div class="card">
            <h3 style="font-size: 15px; font-weight: 600; margin-bottom: 6px;">Formulate Trapdoor</h3>
            <p style="font-size: 12px; color: var(--text-muted); margin-bottom: 20px;">Use your private key to encrypt the search tag.</p>
            
            <form action="GenerateTrapdoor" method="post">
              <div class="form-group">
                <label class="form-label">Search Keyword *</label>
                <div class="input-wrapper">
                  <i class="bi bi-fingerprint"></i>
                  <input type="text" name="keyword" class="form-input" placeholder="e.g. medical, prescription, report" required autocomplete="off" style="padding-left: 36px;" />
                </div>
              </div>
              
              <button type="submit" class="btn btn-primary" style="width: 100%; padding: 11px;">
                <i class="bi bi-gear-wide-connected"></i> Encrypt &amp; Generate Trapdoor &rarr;
              </button>
            </form>
          </div>

          <!-- Right: Info Panel -->
          <div class="info-card">
            <div class="info-card-title"><i class="bi bi-shield-fill-check"></i> Trapdoor Flowchart</div>
            <div class="info-card-step">
              <strong>Step 1:</strong> The keyword is encrypted locally using the Consumer Secret Key (sk) issued by the PKG module.
            </div>
            <div class="info-card-step">
              <strong>Step 2:</strong> The generated trapdoor ciphertext is stored securely in the <code>trapdoor</code> index.
            </div>
            <div class="info-card-step">
              <strong>Step 3:</strong> The Cloud Server runs a blind boolean test of this trapdoor against encrypted index fields without decrypting the data.
            </div>
          </div>
          
        </div>

        <!-- Trapdoor Records Table -->
        <div class="table-card">
          <div class="table-header">
            <div class="table-title">Your Generated Query Indexes</div>
          </div>
          
          <table>
            <thead>
              <tr>
                <th style="width: 80px;">#</th>
                <th>Search Keyword</th>
                <th>Encrypted Trapdoor String</th>
                <th style="width: 180px; text-align: center;">Action</th>
              </tr>
            </thead>
            <tbody>
              <%
                boolean hasRows = false;
                int count = 1;
                if (rs != null) {
                  while (rs.next()) {
                    hasRows = true;
                    String kwName = rs.getString("name");
                    String trap   = rs.getString("trap");
              %>
              <tr>
                <td class="mono"><%= count++ %></td>
                <td><strong><%= kwName %></strong></td>
                <td>
                  <div class="trap-val" title="<%= trap %>"><%= trap %></div>
                </td>
                <td style="text-align: center;">
                  <a href="SearchFile?keyword=<%= kwName %>" class="btn btn-outline btn-sm">
                    <i class="bi bi-search"></i> Execute Search &rarr;
                  </a>
                </td>
              </tr>
              <%
                  }
                }
                if (!hasRows) {
              %>
              <tr class="empty-row">
                <td colspan="4">
                  <div class="empty-state">
                    <div class="empty-icon"><i class="bi bi-fingerprint"></i></div>
                    <div class="empty-title">No trapdoors generated</div>
                    <div class="empty-desc">You have not created any search trapdoors yet. Formulate a keyword above to get started.</div>
                  </div>
                </td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
        
      </div>
    </main>

  </div>

  <script src="js/theme.js"></script>
</body>
</html>
<%
  try { if (rs != null) rs.close(); } catch (Exception ignored) {}
  try { if (st != null) st.close(); } catch (Exception ignored) {}
  try { if (con != null) con.close(); } catch (Exception ignored) {}
%>
