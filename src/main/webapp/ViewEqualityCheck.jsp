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

    Connection con = null;
    ResultSet  rs  = null;
    Statement  st  = null;
    int pendingDO = 0, pendingDC = 0;
    try {
        con = com.dao.DBConnection.connect();
        st = con.createStatement();
        
        // Fetch counts for badges
        Statement stCount = con.createStatement();
        ResultSet rsCount = stCount.executeQuery("select count(*) from doregister where status1='Pending'");
        if (rsCount.next()) pendingDO = rsCount.getInt(1);
        rsCount.close();
        rsCount = stCount.executeQuery("select count(*) from dcregister where status='Pending'");
        if (rsCount.next()) pendingDC = rsCount.getInt(1);
        rsCount.close();
        stCount.close();

        // Query equality check records
        rs = st.executeQuery("select Rid,Uid,Fid,Tkey,Status,recid from equality order by Rid desc");
    } catch (Exception e) { 
        e.printStackTrace(); 
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Equality Verification — SecureRank Admin</title>
  
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
          <a href="ViewUploadedFiles.jsp" class="sidebar-link">
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
          <a href="ViewEqualityCheck.jsp" class="sidebar-link active">
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
          <%= csName != null && csName.length() > 0 ? csName.substring(0, Math.min(csName.length(), 2)).toUpperCase() : "AD" %>
        </div>
        <div style="min-width: 0; flex: 1;">
          <div class="sidebar-user-name" title="<%= csName %>"><%= csName != null ? csName : "Admin" %></div>
          <div class="sidebar-user-role">Cloud Administrator</div>
        </div>
      </div>
    </aside>

    <!-- Main Content Area -->
    <main class="main-content">
      
      <!-- Topnav -->
      <header class="topnav">
        <div class="topnav-title">Secure Coprocessor Verifications</div>
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
          <h2 style="font-size: 20px; font-weight: 600;">SCP Equality Verification Records</h2>
          <p style="font-size: 13px; color: var(--text-muted); margin-top: 2px;">Audit the cryptographic verification outputs verified by the Secure Coprocessor (SCP) to confirm matching search tokens.</p>
        </div>

        <div class="table-card">
          <div class="table-header">
            <div class="table-title">Coprocessor Boolean Evaluation Log</div>
          </div>
          
          <table>
            <thead>
              <tr>
                <th style="width: 80px;">ID</th>
                <th>Data Owner</th>
                <th style="width: 100px;">File ID</th>
                <th>Trapdoor Key</th>
                <th>Data Consumer</th>
                <th style="width: 150px; text-align: center;">Evaluation Result</th>
              </tr>
            </thead>
            <tbody>
              <%
                boolean hasRows = false;
                if (rs != null) {
                  while (rs.next()) {
                    hasRows = true;
                    String rid      = rs.getString("Rid");
                    String uid      = rs.getString("Uid");
                    String fid      = rs.getString("Fid");
                    String tkey     = rs.getString("Tkey");
                    String status   = rs.getString("Status");
                    String recid    = rs.getString("recid");
                    
                    // Format trapdoor key preview
                    String tkeyPreview = "-";
                    if (tkey != null && !tkey.trim().isEmpty()) {
                      tkeyPreview = tkey.substring(0, Math.min(tkey.length(), 16)) + "...";
                    }
              %>
              <tr>
                <td class="mono"><%= rid %></td>
                <td class="mono" style="color: var(--text-muted);"><%= uid %></td>
                <td class="mono"><strong><%= fid %></strong></td>
                <td>
                  <div class="mono" style="color: var(--text-muted); max-width: 200px; text-overflow: ellipsis; overflow: hidden; white-space: nowrap;" title="<%= tkey %>">
                    <%= tkeyPreview %>
                  </div>
                </td>
                <td class="mono" style="color: var(--text-muted);"><%= recid %></td>
                <td style="text-align: center;">
                  <% if ("Success".equalsIgnoreCase(status) || "Verified".equalsIgnoreCase(status) || "Approved".equalsIgnoreCase(status)) { %>
                    <span class="badge badge-success"><i class="bi bi-check-circle-fill"></i> <%= status %></span>
                  <% } else { %>
                    <span class="badge badge-warning"><i class="bi bi-info-circle-fill"></i> <%= status %></span>
                  <% } %>
                </td>
              </tr>
              <%
                  }
                }
                if (!hasRows) {
              %>
              <tr class="empty-row">
                <td colspan="6">
                  <div style="text-align: center; padding: 40px; color: var(--text-faint);">
                    <i class="bi bi-clipboard-check" style="font-size: 28px; margin-bottom: 8px; display: inline-block;"></i>
                    <div style="font-weight: 500; color: var(--text-main);">No verification checks recorded</div>
                    <div style="font-size: 12px; margin-top: 4px;">No coprocessor equality checking runs have been logged.</div>
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
