<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession,java.sql.*" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("dcemail") == null) {
        response.sendRedirect("login.jsp?role=dataconsumer");
        return;
    }
    String dcEmail = (String) s.getAttribute("dcemail");
    String dcName  = (String) s.getAttribute("dcname");
    
    Connection con = com.dao.DBConnection.connect();
    ResultSet rs   = null;
    Statement st   = null;
    try {
        st = con.createStatement();
        rs = st.executeQuery("select id, name, trap from trapdoor where uid='" + dcEmail + "' order by id desc");
    } catch(Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Search Files — SecureRank</title>
  
  <!-- Font and Icon Resources -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <link rel="stylesheet" href="css/style.css">
  
  <style>
    .trap-val {
      font-family: 'JetBrains Mono', monospace;
      font-size: 11px;
      color: var(--primary);
      background-color: var(--bg-main);
      padding: 2px 8px;
      border-radius: var(--radius-sm);
      border: 1px solid var(--border);
      max-width: 320px;
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
          <a href="GenerateTrapdoor.jsp" class="sidebar-link">
            <i class="bi bi-fingerprint"></i> Generate Trapdoor
          </a>
        </li>
        <li>
          <a href="SearchFile.jsp" class="sidebar-link active">
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
        <div class="topnav-title">Run Encrypted Query Search</div>
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
          <h2 style="font-size: 20px; font-weight: 600;">Execute Search Trapdoor</h2>
          <p style="font-size: 13px; color: var(--text-muted); margin-top: 2px;">Submit a query trapdoor to the Cloud Server. Results will evaluate matching indices and return files sorted by relevance.</p>
        </div>

        <div class="table-card" style="padding: 20px;">
          
          <!-- Modern Search Bar & Suggestion Chips -->
          <div style="margin-bottom: 24px; display: flex; flex-direction: column; gap: 10px;">
            <label class="form-label" style="margin-bottom: 0; font-weight: 600;">Query Filter Console</label>
            <div class="input-wrapper">
              <i class="bi bi-search"></i>
              <input type="text" id="keywordFilter" class="form-input table-search-input" data-table="trapdoorTable" placeholder="Type a keyword to filter trapdoors..." style="padding-left: 36px;" />
            </div>
            
            <!-- Quick Chips suggestions -->
            <div class="keyword-chips-container" style="margin-top: 4px;">
              <span style="font-size: 11px; color: var(--text-faint); align-self: center; margin-right: 4px;">Suggestions:</span>
              <span class="keyword-chip" style="cursor: pointer;" onclick="applyFilter('medical')">medical</span>
              <span class="keyword-chip" style="cursor: pointer;" onclick="applyFilter('prescription')">prescription</span>
              <span class="keyword-chip" style="cursor: pointer;" onclick="applyFilter('report')">report</span>
              <span class="keyword-chip" style="cursor: pointer;" onclick="applyFilter('clinical')">clinical</span>
              <span class="keyword-chip" style="cursor: pointer;" onclick="applyFilter('legal')">legal</span>
              <span class="keyword-chip" style="cursor: pointer;" onclick="applyFilter('financial')">financial</span>
            </div>
          </div>

          <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border); padding-bottom: 12px; margin-bottom: 16px;">
            <div class="table-title">Your Stored Trapdoor Queries</div>
            <a href="GenerateTrapdoor.jsp" class="btn btn-primary btn-sm"><i class="bi bi-plus-lg"></i> Formulate New Trapdoor</a>
          </div>
          
          <table id="trapdoorTable" class="sortable">
            <thead>
              <tr>
                <th style="width: 80px;">#</th>
                <th style="width: 200px;">Search Keyword</th>
                <th>Encrypted Trapdoor Ciphertext</th>
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
                    String kw = rs.getString("name");
                    String tr = rs.getString("trap");
              %>
              <tr>
                <td class="mono"><%= count++ %></td>
                <td><strong><%= kw %></strong></td>
                <td>
                  <div class="trap-val" title="<%= tr %>"><%= tr %></div>
                </td>
                <td style="text-align: center;">
                  <button onclick="triggerSearch('<%= kw %>')" class="btn btn-primary btn-sm" style="width: 130px;">
                    <i class="bi bi-search"></i> Search Cloud &rarr;
                  </button>
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
                    <div class="empty-title">No trapdoors found</div>
                    <div class="empty-desc">You must generate a query trapdoor before running a search on the server.</div>
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

  <!-- Search Loader Overlay -->
  <div id="searchLoaderOverlay" style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background-color: rgba(15, 23, 42, 0.75); G-filter: blur(4px); backdrop-filter: blur(4px); z-index: 10000; align-items: center; justify-content: center; flex-direction: column;">
    <div style="background-color: var(--bg-surface); border: 1px solid var(--border); border-radius: var(--radius-lg); padding: 40px 30px; text-align: center; max-width: 380px; box-shadow: var(--shadow-lg);">
      <div style="font-size: 40px; color: var(--primary); margin-bottom: 20px; animation: spin 1.5s linear infinite;">
        <i class="bi bi-shield-slash-fill" style="display: inline-block;"></i>
      </div>
      <h3 style="font-size: 16px; font-weight: 600; color: var(--text-main); margin-bottom: 8px;">Secure Query Evaluation</h3>
      <div id="loaderStatusText" style="font-size: 12px; color: var(--text-muted); font-family: 'JetBrains Mono', monospace;">Decrypting search trapdoor...</div>
    </div>
  </div>

  <script src="js/theme.js"></script>
  <script>
    function applyFilter(kw) {
      var input = document.getElementById('keywordFilter');
      if (input) {
        input.value = kw;
        input.dispatchEvent(new Event('input')); // fire search update
      }
    }

    function triggerSearch(keyword) {
      var loader = document.getElementById('searchLoaderOverlay');
      if (loader) {
        loader.style.display = 'flex';
        var status = document.getElementById('loaderStatusText');
        
        setTimeout(function() {
          if (status) status.textContent = 'Evaluating index matches (Secure Coprocessor)...';
        }, 400);
        setTimeout(function() {
          if (status) status.textContent = 'Sorting result vectors via TF-IDF weights...';
        }, 900);
        
        setTimeout(function() {
          window.location.href = 'SearchFile?keyword=' + encodeURIComponent(keyword);
        }, 1400);
      } else {
        window.location.href = 'SearchFile?keyword=' + encodeURIComponent(keyword);
      }
    }
  </script>
</body>
</html>
<%
  try { if (rs != null) rs.close(); } catch (Exception ignored) {}
  try { if (st != null) st.close(); } catch (Exception ignored) {}
  try { if (con != null) con.close(); } catch (Exception ignored) {}
%>
