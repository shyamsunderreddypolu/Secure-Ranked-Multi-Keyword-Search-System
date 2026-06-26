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

        // Query the registrations
        rs = st.executeQuery("select id,name,email,mobile,address,status from dcregister order by id desc");
    } catch (Exception e) { 
        e.printStackTrace(); 
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Data Consumer List — SecureRank Admin</title>
  
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
          <a href="ViewDCList.jsp" class="sidebar-link active">
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
        <div class="topnav-title">Manage Data Consumers</div>
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
          <h2 style="font-size: 20px; font-weight: 600;">Data Consumer Accounts</h2>
          <p style="font-size: 13px; color: var(--text-muted); margin-top: 2px;">Approve or reject Data Consumer registrations. Only Approved DCs can login and search encrypted files.</p>
        </div>

        <div class="table-card">
          <div class="table-header">
            <div class="table-title">All Data Consumer Registrations</div>
          </div>
          
          <table>
            <thead>
              <tr>
                <th style="width: 80px;">#</th>
                <th>Name</th>
                <th>Email</th>
                <th>Mobile</th>
                <th style="width: 150px;">Status</th>
                <th style="width: 220px; text-align: center;">Action</th>
              </tr>
            </thead>
            <tbody>
              <%
                boolean hasRows = false; int cnt = 1;
                if (rs != null) {
                  while (rs.next()) {
                    hasRows = true;
                    String dcName   = rs.getString("name");
                    String dcEmail  = rs.getString("email");
                    String dcMobile = rs.getString("mobile");
                    String dcStatus = rs.getString("status");
              %>
              <tr>
                <td class="mono"><%= cnt++ %></td>
                <td><strong><%= dcName %></strong></td>
                <td class="mono" style="color: var(--text-muted);"><%= dcEmail %></td>
                <td class="mono"><%= dcMobile != null && !dcMobile.trim().isEmpty() ? dcMobile : "—" %></td>
                <td>
                  <% if ("Approved".equals(dcStatus)) { %>
                    <span class="badge badge-success"><i class="bi bi-check-circle-fill"></i> Approved</span>
                  <% } else if ("Rejected".equals(dcStatus)) { %>
                    <span class="badge badge-danger"><i class="bi bi-x-circle-fill"></i> Rejected</span>
                  <% } else { %>
                    <span class="badge badge-warning"><i class="bi bi-clock-fill"></i> Pending</span>
                  <% } %>
                </td>
                <td style="text-align: center;">
                  <% if (!"Approved".equals(dcStatus)) { %>
                    <a href="ApproveDC?email=<%= dcEmail %>&action=approve" class="btn btn-success btn-sm" style="margin-right: 4px;">
                      <i class="bi bi-check-lg"></i> Approve
                    </a>
                  <% } %>
                  <% if (!"Rejected".equals(dcStatus)) { %>
                    <a href="ApproveDC?email=<%= dcEmail %>&action=reject" class="btn btn-danger btn-sm">
                      <i class="bi bi-x-lg"></i> Reject
                    </a>
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
                    <i class="bi bi-people" style="font-size: 28px; margin-bottom: 8px; display: inline-block;"></i>
                    <div style="font-weight: 500; color: var(--text-main);">No registrations found</div>
                    <div style="font-size: 12px; margin-top: 4px;">No Data Consumers have registered yet.</div>
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
