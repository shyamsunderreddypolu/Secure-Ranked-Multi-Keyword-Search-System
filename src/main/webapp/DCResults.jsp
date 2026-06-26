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

    // Load search results for this DC from response table
    Connection con = com.dao.DBConnection.connect();
    ResultSet  rs  = null;
    Statement  st  = null;
    Statement  stFallback = null;
    try {
        st = con.createStatement();
        rs = st.executeQuery(
            "select r.Rid, r.uid, r.fid, r.TKey, u.Filename, u.Label, u.Content "
          + "from response r join upload u on r.fid = u.Fid "
          + "where r.recid='" + dcEmail + "' order by r.score desc, r.Rid desc");
    } catch (Exception e) {
        // Fallback without join if column mismatch
        try {
            stFallback = con.createStatement();
            rs = stFallback.executeQuery(
                "select Rid, uid, fid, TKey, recid, score from response "
              + "where recid='" + dcEmail + "' order by score desc, Rid desc");
        } catch (Exception ex) { ex.printStackTrace(); }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Search Results — SecureRank</title>
  
  <!-- Font and Icon Resources -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <link rel="stylesheet" href="css/style.css">
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
          <a href="SearchFile.jsp" class="sidebar-link">
            <i class="bi bi-search"></i> Search Files
          </a>
        </li>
        <li>
          <a href="DCResults.jsp" class="sidebar-link active">
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
        <div class="topnav-title">Ranked Query Matches</div>
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
          <h2 style="font-size: 20px; font-weight: 600;">Evaluation Results</h2>
          <p style="font-size: 13px; color: var(--text-muted); margin-top: 2px;">Review matching documents sorted in descending order of TF-IDF relevance weights. Click Download to retrieve the file.</p>
        </div>

        <div class="table-card">
          <div class="table-header">
            <div class="table-title">Matched Encrypted Assets</div>
            <a href="SearchFile.jsp" class="btn btn-primary btn-sm"><i class="bi bi-search"></i> Run Another Query</a>
          </div>
          
          <table>
            <thead>
              <tr>
                <th style="width: 80px;">Rank</th>
                <th style="width: 80px;">File ID</th>
                <th>File Name</th>
                <th>Data Owner</th>
                <th style="width: 140px;">Classification</th>
                <th style="width: 140px;">Security State</th>
                <th style="width: 150px; text-align: center;">Action</th>
              </tr>
            </thead>
            <tbody>
              <%
                boolean hasRows = false;
                int rank = 1;
                if (rs != null) {
                  while (rs.next()) {
                    hasRows = true;
                    String fid      = rs.getString("fid");
                    String doEmail  = rs.getString("uid");
                    String tkey     = rs.getString("TKey");
                    String filename = "";
                    String label    = "";
                    try { filename = rs.getString("Filename"); } catch (Exception ignored) {}
                    try { label    = rs.getString("Label");    } catch (Exception ignored) {}
              %>
              <tr>
                <td><span class="badge badge-primary" style="font-family: 'JetBrains Mono', monospace;">#<%= rank++ %></span></td>
                <td class="mono"><%= fid %></td>
                <td style="max-width: 200px; overflow-wrap: break-word; word-break: break-all;">
                  <strong><%= filename.isEmpty() ? "File_" + fid : filename %></strong>
                </td>
                <td class="mono" style="color: var(--text-muted);"><%= doEmail %></td>
                <td>
                  <span class="badge badge-warning"><%= label.isEmpty() ? "Encrypted" : label %></span>
                </td>
                <td>
                  <span class="badge badge-success"><i class="bi bi-lock-fill"></i> GM Encrypted</span>
                </td>
                <td style="text-align: center;">
                  <a href="DownloadFile?fid=<%= fid %>&uid=<%= dcEmail %>" class="btn btn-primary btn-sm" style="width: 90px;">
                    <i class="bi bi-download"></i> Download
                  </a>
                </td>
              </tr>
              <%
                  }
                }
                if (!hasRows) {
              %>
              <tr class="empty-row">
                <td colspan="7">
                  <div class="empty-state">
                    <div class="empty-icon"><i class="bi bi-search"></i></div>
                    <div class="empty-title">No search matches</div>
                    <div class="empty-desc">No search results currently mapped. Go to "Search Files" and submit a trapdoor query first.</div>
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
  try { if (rs  != null) rs.close();  } catch (Exception ignored) {}
  try { if (st  != null) st.close();  } catch (Exception ignored) {}
  try { if (stFallback != null) stFallback.close(); } catch (Exception ignored) {}
  try { if (con != null) con.close(); } catch (Exception ignored) {}
%>
