<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession,java.sql.*" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("csemail") == null) {
        response.sendRedirect("login.jsp?role=admin");
        return;
    }
    String csName = (String) s.getAttribute("csname");
    String csEmail = (String) s.getAttribute("csemail");
    
    int pendingDO = 0, pendingDC = 0;
    Connection con = com.dao.DBConnection.connect();
    ResultSet  rs  = null;
    Statement  st  = null;
    try {
        st = con.createStatement();
        rs = st.executeQuery(
            "select Fid, Email, Filename, Label, Content, Tkey from upload order by Fid desc");
            
        // Fetch pending counts for the menu badges
        Statement stPending = con.createStatement();
        ResultSet rsPending = stPending.executeQuery("select count(*) from doregister where status1='Pending'");
        if (rsPending.next()) pendingDO = rsPending.getInt(1);
        rsPending.close();
        rsPending = stPending.executeQuery("select count(*) from dcregister where status='Pending'");
        if (rsPending.next()) pendingDC = rsPending.getInt(1);
        rsPending.close();
        stPending.close();
    } catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Encrypted Files — SecureRank</title>
  
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
          <div class="sidebar-logo-sub">Cloud Admin Panel</div>
        </div>
      </div>
      
      <ul class="sidebar-menu">
        <li>
          <a href="CSHome.jsp" class="sidebar-link">
            <i class="bi bi-grid-fill"></i> Dashboard
          </a>
        </li>
        <li>
          <a href="ViewDOList.jsp" class="sidebar-link">
            <i class="bi bi-people-fill"></i> Manage Owners
            <% if (pendingDO > 0) { %><span class="badge badge-danger" style="margin-left:auto; font-size: 10px; padding: 2px 6px;"><%= pendingDO %></span><% } %>
          </a>
        </li>
        <li>
          <a href="ViewDCList.jsp" class="sidebar-link">
            <i class="bi bi-people-fill"></i> Manage Consumers
            <% if (pendingDC > 0) { %><span class="badge badge-danger" style="margin-left:auto; font-size: 10px; padding: 2px 6px;"><%= pendingDC %></span><% } %>
          </a>
        </li>
        <li>
          <a href="ViewUploadedFiles.jsp" class="sidebar-link active">
            <i class="bi bi-folder-fill"></i> View Encrypted Files
          </a>
        </li>
        <li>
          <a href="ViewSearchRequests.jsp" class="sidebar-link">
            <i class="bi bi-activity"></i> Search Activity
          </a>
        </li>
        <li>
          <a href="DCDecryptRequest.jsp" class="sidebar-link">
            <i class="bi bi-key-fill"></i> Decrypt Requests
          </a>
        </li>
        <li>
          <a href="ViewEqualityCheck.jsp" class="sidebar-link">
            <i class="bi bi-clipboard-check-fill"></i> Equality Verifications
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
        <div class="topnav-title">Audit Cloud Storage</div>
        <div class="topnav-actions">
          <button class="theme-toggle" aria-label="Toggle Dark Mode"></button>
          <div style="font-size: 13px; color: var(--text-muted);">
            Logged in: <strong style="color: var(--text-main);"><%= csEmail %></strong>
          </div>
        </div>
      </header>
      
      <!-- Content Body -->
      <div class="content-body">
        
        <div style="margin-bottom: 24px;">
          <h2 style="font-size: 20px; font-weight: 600;">Encrypted Repository Inventory</h2>
          <p style="font-size: 13px; color: var(--text-muted); margin-top: 2px;">Review details of files uploaded by Data Owners. Content payload is strictly kept in ciphertext form.</p>
        </div>

        <div class="table-card">
          <div class="table-header">
            <div class="table-title">Cloud Storage Data Records</div>
          </div>
          
          <table>
            <thead>
              <tr>
                <th style="width: 80px;">File ID</th>
                <th>Owner Email</th>
                <th>File Name</th>
                <th style="width: 140px;">Classification</th>
                <th style="width: 140px;">State</th>
                <th>Trapdoor Key</th>
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
                    String email    = rs.getString("Email");
                    String filename = rs.getString("Filename");
                    String label    = rs.getString("Label");
                    String tkey     = rs.getString("Tkey");
                    String upTime   = "N/A";
              %>
              <tr>
                <td class="mono"><%= fid %></td>
                <td class="mono" style="color: var(--text-muted);"><%= email %></td>
                <td style="max-width: 200px; overflow-wrap: break-word; word-break: break-all;">
                  <strong><%= filename %></strong>
                </td>
                <td>
                  <span class="badge badge-warning"><%= label != null ? label : "General" %></span>
                </td>
                <td>
                  <span class="badge badge-success"><i class="bi bi-lock-fill"></i> GM Encrypted</span>
                </td>
                <td class="mono" style="color: var(--text-muted);">
                  <%= tkey != null ? tkey.substring(0, Math.min(tkey.length(), 14)) + "..." : "—" %>
                </td>
                <td class="mono" style="color: var(--text-faint);"><%= upTime %></td>
              </tr>
              <%
                  }
                }
                if (!hasRows) {
              %>
              <tr class="empty-row">
                <td colspan="7">
                  <div class="empty-state">
                    <div class="empty-icon"><i class="bi bi-folder-x"></i></div>
                    <div class="empty-title">Cloud repository empty</div>
                    <div class="empty-desc">No encrypted files have been uploaded by Data Owners yet.</div>
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
