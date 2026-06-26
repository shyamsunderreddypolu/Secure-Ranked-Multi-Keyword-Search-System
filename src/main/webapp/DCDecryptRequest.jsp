<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession, java.sql.*" %>
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
    Statement  stFallback = null;
    try {
        st = con.createStatement();
        rs = st.executeQuery(
            "select k.id, k.uid, k.fid, k.status1, d.name "
          + "from keyreq k "
          + "left join dcregister d on k.uid = d.email "
          + "order by k.id desc");
          
        // Fetch pending counts for the menu badges
        Statement stPending = con.createStatement();
        ResultSet rsPending = stPending.executeQuery("select count(*) from doregister where status1='Pending'");
        if (rsPending.next()) pendingDO = rsPending.getInt(1);
        rsPending.close();
        rsPending = stPending.executeQuery("select count(*) from dcregister where status='Pending'");
        if (rsPending.next()) pendingDC = rsPending.getInt(1);
        rsPending.close();
        stPending.close();
    } catch (Exception e) {
        try {
            stFallback = con.createStatement();
            rs = stFallback.executeQuery(
                "select id, uid, fid, status1 from keyreq order by id desc");
        } catch (Exception ex) { ex.printStackTrace(); }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Decrypt Requests — SecureRank Admin</title>
  
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
          <a href="DCDecryptRequest.jsp" class="sidebar-link active">
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
        <div class="topnav-title">Manage Decryption Authorizations</div>
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
          <h2 style="font-size: 20px; font-weight: 600;">Data Consumer Decrypt Requests</h2>
          <p style="font-size: 13px; color: var(--text-muted); margin-top: 2px;">Approve or decline key release requests submitted by Data Consumers wishing to decrypt target database assets.</p>
        </div>

        <div class="table-card">
          <div class="table-header">
            <div class="table-title">Key Access Requests Queue</div>
          </div>
          
          <table>
            <thead>
              <tr>
                <th style="width: 80px;">#</th>
                <th>Consumer Name</th>
                <th>Consumer Email</th>
                <th style="width: 100px;">File ID</th>
                <th style="width: 150px;">Status</th>
                <th style="width: 160px; text-align: center;">Action</th>
              </tr>
            </thead>
            <tbody>
              <%
                boolean hasRows = false; int cnt = 1;
                if (rs != null) {
                  while (rs.next()) {
                    hasRows = true;
                    String uid     = rs.getString("uid");
                    String fid     = rs.getString("fid");
                    String status1 = rs.getString("status1");
                    String dcName  = "";
                    try { dcName = rs.getString("name"); } catch(Exception ignored){}
              %>
              <tr>
                <td class="mono"><%= cnt++ %></td>
                <td><strong><%= dcName != null && !dcName.isEmpty() ? dcName : "—" %></strong></td>
                <td class="mono" style="color: var(--text-muted);"><%= uid %></td>
                <td class="mono"><%= fid %></td>
                <td>
                  <% if ("Approved".equals(status1)) { %>
                    <span class="badge badge-success"><i class="bi bi-check-circle-fill"></i> Approved</span>
                  <% } else { %>
                    <span class="badge badge-warning"><i class="bi bi-clock-fill"></i> Pending</span>
                  <% } %>
                </td>
                <td style="text-align: center;">
                  <% if (!"Approved".equals(status1)) { %>
                    <a href="DCDecryptRequest?uid=<%= uid %>&fid=<%= fid %>" class="btn btn-primary btn-sm">
                      <i class="bi bi-check-lg"></i> Approve
                    </a>
                  <% } else { %>
                    <span style="font-size:12px; color: var(--text-faint); font-weight: 500;"><i class="bi bi-shield-fill-check"></i> Released</span>
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
                  <div class="empty-state">
                    <div class="empty-icon"><i class="bi bi-key"></i></div>
                    <div class="empty-title">Queue is empty</div>
                    <div class="empty-desc">No decrypt requests currently submitted by Data Consumers.</div>
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
  try { if (stFallback != null) stFallback.close(); } catch (Exception ignored) {}
  try { if (con != null) con.close(); } catch (Exception ignored) {}
%>
