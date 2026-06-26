<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession,java.sql.*" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("email") == null) {
        response.sendRedirect("login.jsp?role=dataowner");
        return;
    }
    String doEmail = (String) s.getAttribute("email");
    String doName  = (String) s.getAttribute("name");

    Connection con = com.dao.DBConnection.connect();
    ResultSet  rs  = null;
    Statement  st  = null;
    try {
        st = con.createStatement();
        rs = st.executeQuery(
            "select Fid, Filename, Label, Tkey from upload "
          + "where Email='" + doEmail + "' order by Fid desc");
    } catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Files — SecureRank</title>
  
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
          <div class="sidebar-logo-sub">Data Owner Panel</div>
        </div>
      </div>
      
      <ul class="sidebar-menu">
        <li>
          <a href="DOHome.jsp" class="sidebar-link">
            <i class="bi bi-grid-fill"></i> Dashboard
          </a>
        </li>
        <li>
          <a href="DOUpload.jsp" class="sidebar-link">
            <i class="bi bi-cloud-arrow-up-fill"></i> Upload File
          </a>
        </li>
        <li>
          <a href="ViewMyFiles.jsp" class="sidebar-link active">
            <i class="bi bi-folder-fill"></i> My Uploaded Files
          </a>
        </li>
        <li>
          <a href="ViewRequests.jsp" class="sidebar-link">
            <i class="bi bi-key-fill"></i> Search Requests
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
          <%= doName.substring(0, Math.min(doName.length(), 2)).toUpperCase() %>
        </div>
        <div style="min-width: 0; flex: 1;">
          <div class="sidebar-user-name" title="<%= doName %>"><%= doName %></div>
          <div class="sidebar-user-role">Data Owner</div>
        </div>
      </div>
    </aside>

    <!-- Main Content Area -->
    <main class="main-content">
      
      <!-- Topnav -->
      <header class="topnav">
        <div class="topnav-title">Document Repository</div>
        <div class="topnav-actions">
          <button class="theme-toggle" aria-label="Toggle Dark Mode"></button>
          <div style="font-size: 13px; color: var(--text-muted);">
            Logged in: <strong style="color: var(--text-main);"><%= doEmail %></strong>
          </div>
        </div>
      </header>
      
      <!-- Content Body -->
      <div class="content-body">
        
        <div style="margin-bottom: 24px;">
          <h2 style="font-size: 20px; font-weight: 600;">My Encrypted Documents</h2>
          <p style="font-size: 13px; color: var(--text-muted); margin-top: 2px;">Review local documents uploaded to the remote server and inspect their index trapdoors</p>
        </div>

        <div class="table-card">
          <div class="table-header">
            <div class="table-title">Uploaded Files</div>
            <a href="DOUpload.jsp" class="btn btn-primary btn-sm"><i class="bi bi-plus-lg"></i> Upload New File</a>
          </div>
          
          <table>
            <thead>
              <tr>
                <th style="width: 80px;">File ID</th>
                <th>File Name</th>
                <th style="width: 140px;">Classification</th>
                <th style="width: 140px;">State</th>
                <th>Trapdoor Key (Tkey)</th>
                <th style="width: 120px;">Timestamp</th>
              </tr>
            </thead>
            <tbody>
              <%
                boolean hasRows = false;
                if (rs != null) {
                  while (rs.next()) {
                    hasRows = true;
                    String fid      = rs.getString("Fid");
                    String filename = rs.getString("Filename");
                    String label    = rs.getString("Label");
                    String tkey     = rs.getString("Tkey");
                    String upTime   = "N/A";
              %>
              <tr>
                <td class="mono"><%= fid %></td>
                <td style="max-width: 260px; overflow-wrap: break-word; word-break: break-all;">
                  <strong><%= filename %></strong>
                </td>
                <td>
                  <span class="badge badge-warning"><%= label != null ? label : "General" %></span>
                </td>
                <td>
                  <span class="badge badge-success"><i class="bi bi-lock-fill"></i> GM Encrypted</span>
                </td>
                <td class="mono" style="color: var(--text-muted);">
                  <%= tkey != null ? tkey.substring(0, Math.min(tkey.length(), 16)) + "..." : "—" %>
                </td>
                <td class="mono" style="color: var(--text-faint);"><%= upTime %></td>
              </tr>
              <%
                  }
                }
                if (!hasRows) {
              %>
              <tr class="empty-row">
                <td colspan="6">
                  <div class="empty-state">
                    <div class="empty-icon"><i class="bi bi-folder-x"></i></div>
                    <div class="empty-title">No files found</div>
                    <div class="empty-desc">You have not uploaded any encrypted files yet. Get started by selecting a file to deploy.</div>
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
