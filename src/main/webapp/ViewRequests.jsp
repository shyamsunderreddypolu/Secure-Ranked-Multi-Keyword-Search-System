<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession, java.sql.*" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("email") == null) {
        response.sendRedirect("login.jsp?role=dataowner");
        return;
    }
    String doEmail = (String) s.getAttribute("email");
    String doName  = (String) s.getAttribute("name");

    Connection con = null;
    ResultSet  rs  = null;
    Statement  st  = null;
    try {
        con = com.dao.DBConnection.connect();
        st = con.createStatement();
        rs = st.executeQuery("select Rid,fid,Receiver,Status from request where uid='" + doEmail + "' order by Rid desc");
    } catch (Exception e) { 
        e.printStackTrace(); 
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Search Requests — SecureRank DO</title>
  
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
          <a href="ViewMyFiles.jsp" class="sidebar-link">
            <i class="bi bi-folder-fill"></i> My Uploaded Files
          </a>
        </li>
        <li>
          <a href="ViewRequests.jsp" class="sidebar-link active">
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
          <%= doName != null && doName.length() > 0 ? doName.substring(0, Math.min(doName.length(), 2)).toUpperCase() : "DO" %>
        </div>
        <div style="min-width: 0; flex: 1;">
          <div class="sidebar-user-name" title="<%= doName %>"><%= doName != null ? doName : "Owner" %></div>
          <div class="sidebar-user-role">Data Owner</div>
        </div>
      </div>
    </aside>

    <!-- Main Content Area -->
    <main class="main-content">
      
      <!-- Topnav -->
      <header class="topnav">
        <div class="topnav-title">Data Owner Workspace</div>
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
          <h2 style="font-size: 20px; font-weight: 600;">Data Consumer Search Requests</h2>
          <p style="font-size: 13px; color: var(--text-muted); margin-top: 2px;">Incoming requests submitted by Data Consumers searching for keyword matches inside your uploaded file repository.</p>
        </div>

        <div class="table-card">
          <div class="table-header">
            <div class="table-title">File Match Authorizations Log</div>
          </div>
          
          <table>
            <thead>
              <tr>
                <th style="width: 100px;">Req ID</th>
                <th style="width: 120px;">File ID</th>
                <th>Data Consumer (Receiver)</th>
                <th style="width: 180px; text-align: center;">Evaluation Status</th>
              </tr>
            </thead>
            <tbody>
              <%
                boolean hasRows = false;
                if (rs != null) {
                  while (rs.next()) {
                    hasRows = true;
                    String rid      = rs.getString("Rid");
                    String fid      = rs.getString("fid");
                    String receiver = rs.getString("Receiver");
                    String status   = rs.getString("Status");
              %>
              <tr>
                <td class="mono"><%= rid %></td>
                <td class="mono"><strong><%= fid %></strong></td>
                <td class="mono" style="color: var(--text-muted);"><%= receiver %></td>
                <td style="text-align: center;">
                  <% if ("Success".equalsIgnoreCase(status) || "Approved".equalsIgnoreCase(status) || "Verified".equalsIgnoreCase(status)) { %>
                    <span class="badge badge-success"><i class="bi bi-check-circle-fill"></i> <%= status %></span>
                  <% } else if ("Pending".equalsIgnoreCase(status)) { %>
                    <span class="badge badge-warning"><i class="bi bi-clock-fill"></i> <%= status %></span>
                  <% } else { %>
                    <span class="badge badge-primary"><i class="bi bi-info-circle-fill"></i> <%= status %></span>
                  <% } %>
                </td>
              </tr>
              <%
                  }
                }
                if (!hasRows) {
              %>
              <tr class="empty-row">
                <td colspan="4">
                  <div style="text-align: center; padding: 40px; color: var(--text-faint);">
                    <i class="bi bi-envelope-open" style="font-size: 28px; margin-bottom: 8px; display: inline-block;"></i>
                    <div style="font-weight: 500; color: var(--text-main);">No request logs found</div>
                    <div style="font-size: 12px; margin-top: 4px;">Consumers have not queried files from your repository yet.</div>
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
  try { if (rs != null) rs.close(); } catch (Exception e) {}
  try { if (st != null) st.close(); } catch (Exception e) {}
  try { if (con != null) con.close(); } catch (Exception e) {}
%>
