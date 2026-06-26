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

    // Load all uploaded files with owner info
    Connection con = com.dao.DBConnection.connect();
    ResultSet rsFiles = null;
    ResultSet rsDC    = null;
    Statement st      = null;
    try {
        st      = con.createStatement();
        rsFiles = st.executeQuery(
            "select u.Fid, u.Filename, u.Email, u.Label from upload u");
    } catch (Exception e) { e.printStackTrace(); }

    // Load all approved DCs
    Statement st2 = null;
    try {
        st2 = con.createStatement();
        rsDC = st2.executeQuery(
            "select name, email from dcregister where status='Approved'");
    } catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Send Master Key to DC — SecureRank PKG</title>
  
  <!-- Font and Icon Resources -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <link rel="stylesheet" href="css/style.css">
  
  <style>
    /* Custom select adjustments */
    .dc-select {
      padding: 6px 12px;
      border: 1px solid var(--border);
      border-radius: var(--radius-md);
      font-size: 13px;
      background-color: var(--bg-main);
      color: var(--text-main);
      outline: none;
      min-width: 200px;
      font-family: inherit;
    }
    .dc-select:focus {
      border-color: var(--primary);
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
          <a href="GeneratePKDC.jsp" class="sidebar-link">
            <i class="bi bi-key-fill"></i> Generate Keys for DC
          </a>
        </li>
        <li>
          <a href="SendKeysToDC.jsp" class="sidebar-link active">
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
        <div class="topnav-title">Distribute Decryption Keys</div>
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
          <h2 style="font-size: 20px; font-weight: 600;">Distribute Master Key (mk)</h2>
          <p style="font-size: 13px; color: var(--text-muted); margin-top: 2px;">Assign specific file decryption permissions to validated consumers. This transfers the required key parameters for ciphertext downloads.</p>
        </div>

        <%-- Build DC options once for reuse in every row --%>
        <%
          StringBuilder dcOptions = new StringBuilder();
          dcOptions.append("<option value=''>-- Select Consumer --</option>");
          if (rsDC != null) {
            while (rsDC.next()) {
              String dcName  = rsDC.getString("name");
              String dcEmail = rsDC.getString("email");
              dcOptions.append("<option value='").append(dcEmail).append("'>")
                       .append(dcName).append(" (").append(dcEmail).append(")</option>");
            }
          }
          String dcOpts = dcOptions.toString();
        %>

        <div class="table-card">
          <div class="table-header">
            <div class="table-title">Uploaded Encrypted Repository</div>
          </div>
          
          <table>
            <thead>
              <tr>
                <th style="width: 80px;">File ID</th>
                <th>File Name</th>
                <th>Data Owner</th>
                <th style="width: 140px;">Classification</th>
                <th>Select Consumer (DC)</th>
                <th style="width: 150px; text-align: center;">Action</th>
              </tr>
            </thead>
            <tbody>
              <%
                boolean hasFiles = false;
                if (rsFiles != null) {
                  while (rsFiles.next()) {
                    hasFiles = true;
                    String fid       = rsFiles.getString("Fid");
                    String filename  = rsFiles.getString("Filename");
                    String doEmail   = rsFiles.getString("Email");
                    String label     = rsFiles.getString("Label");
              %>
              <tr>
                <td class="mono"><%= fid %></td>
                <td style="max-width: 200px; overflow-wrap: break-word; word-break: break-all;">
                  <strong><%= filename %></strong>
                </td>
                <td class="mono" style="color: var(--text-muted);"><%= doEmail %></td>
                <td>
                  <span class="badge badge-warning"><%= label != null ? label : "—" %></span>
                </td>
                <td>
                  <select class="dc-select" id="dc_<%= fid %>">
                    <%= dcOpts %>
                  </select>
                </td>
                <td style="text-align: center;">
                  <button class="btn btn-primary btn-sm" onclick="sendKey('<%= fid %>','<%= doEmail %>')">
                    <i class="bi bi-send-fill"></i> Send Key
                  </button>
                </td>
              </tr>
              <%
                  }
                }
                if (!hasFiles) {
              %>
              <tr class="empty-row">
                <td colspan="6">
                  <div class="empty-state">
                    <div class="empty-icon"><i class="bi bi-folder-x"></i></div>
                    <div class="empty-title">No files found</div>
                    <div class="empty-desc">Data Owners must upload encrypted files to the server before keys can be distributed.</div>
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
  <script>
    function sendKey(fid, doid) {
      var sel = document.getElementById('dc_' + fid);
      var uid = sel.value;
      if (!uid) {
        showToast('Please select a Data Consumer first.', 'error');
        return;
      }
      window.location = 'SendKeysToDC?fid=' + fid + '&uid=' + uid + '&doid=' + doid;
    }
  </script>
</body>
</html>
<%
  try { if (rsFiles != null) rsFiles.close(); } catch (Exception ignored) {}
  try { if (rsDC   != null) rsDC.close();    } catch (Exception ignored) {}
  try { if (st     != null) st.close();      } catch (Exception ignored) {}
  try { if (st2    != null) st2.close();     } catch (Exception ignored) {}
  try { if (con    != null) con.close();     } catch (Exception ignored) {}
%>
