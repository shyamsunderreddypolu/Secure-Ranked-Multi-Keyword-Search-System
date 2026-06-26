<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.sql.*" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("pkgemail") == null) {
        response.sendRedirect("login.jsp?role=pkg");
        return;
    }
    String pkgName = (String) s.getAttribute("pkgname");
    String pkgEmail = (String) s.getAttribute("pkgemail");

    // Load all Approved Data Consumers from DB
    Connection con = com.dao.DBConnection.connect();
    ResultSet rs = null;
    Statement st = null;
    try {
        st = con.createStatement();
        rs = st.executeQuery("select id, name, email, mobile from dcregister where status='Approved'");
    } catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Generate Key for DC — SecureRank PKG</title>
  
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
          <div class="sidebar-logo-sub">PKG Administrator</div>
        </div>
      </div>
      
      <ul class="sidebar-menu">
        <li>
          <a href="PKGHome.jsp" class="sidebar-link">
            <i class="bi bi-grid-fill"></i> Dashboard
          </a>
        </li>
        <li>
          <a href="GeneratePKDC.jsp" class="sidebar-link active">
            <i class="bi bi-key-fill"></i> Generate Keys for DC
          </a>
        </li>
        <li>
          <a href="SendKeysToDC.jsp" class="sidebar-link">
            <i class="bi bi-send-fill"></i> Send Master Keys
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
          <%= pkgName.substring(0, Math.min(pkgName.length(), 2)).toUpperCase() %>
        </div>
        <div style="min-width: 0; flex: 1;">
          <div class="sidebar-user-name" title="<%= pkgName %>"><%= pkgName %></div>
          <div class="sidebar-user-role">PKG Authority</div>
        </div>
      </div>
    </aside>

    <!-- Main Content Area -->
    <main class="main-content">
      
      <!-- Topnav -->
      <header class="topnav">
        <div class="topnav-title">Generate Consumer Search Key</div>
        <div class="topnav-actions">
          <button class="theme-toggle" aria-label="Toggle Dark Mode"></button>
          <div style="font-size: 13px; color: var(--text-muted);">
            Logged in: <strong style="color: var(--text-main);"><%= pkgEmail %></strong>
          </div>
        </div>
      </header>
      
      <!-- Content Body -->
      <div class="content-body">
        
        <div style="margin-bottom: 24px;">
          <h2 style="font-size: 20px; font-weight: 600;">Issue Secret Key (sk)</h2>
          <p style="font-size: 13px; color: var(--text-muted); margin-top: 2px;">Generate unique user-level keys. This permits consumers to execute encrypted search queries without exposing plaintext keywords.</p>
        </div>

        <div class="table-card">
          <div class="table-header">
            <div class="table-title">Approved Data Consumers</div>
          </div>
          
          <table>
            <thead>
              <tr>
                <th style="width: 60px;">#</th>
                <th>Name</th>
                <th>Email Address</th>
                <th style="width: 150px;">Mobile</th>
                <th style="width: 130px;">Verification</th>
                <th style="width: 160px; text-align: center;">Action</th>
              </tr>
            </thead>
            <tbody>
              <%
                boolean hasRows = false;
                int count = 1;
                if (rs != null) {
                  while (rs.next()) {
                    hasRows = true;
                    String dcName   = rs.getString("name");
                    String dcEmail  = rs.getString("email");
                    String dcMobile = rs.getString("mobile");
              %>
              <tr>
                <td><%= count++ %></td>
                <td><strong><%= dcName %></strong></td>
                <td class="mono" style="color: var(--text-muted);"><%= dcEmail %></td>
                <td class="mono"><%= dcMobile != null && !dcMobile.isEmpty() ? dcMobile : "—" %></td>
                <td>
                  <span class="badge badge-success"><i class="bi bi-patch-check-fill"></i> Approved</span>
                </td>
                <td style="text-align: center;">
                  <a href="GeneratePKDC?email=<%= dcEmail %>" class="btn btn-primary btn-sm">
                    <i class="bi bi-key-fill"></i> Generate Key
                  </a>
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
                    <div class="empty-icon"><i class="bi bi-people"></i></div>
                    <div class="empty-title">No consumers registered</div>
                    <div class="empty-desc">There are no approved Data Consumers on the system waiting for keys.</div>
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
