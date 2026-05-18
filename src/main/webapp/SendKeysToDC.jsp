<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.sql.*" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("pkgemail") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String pkgName = (String) s.getAttribute("pkgname");

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
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
    :root {
      --purple-mid:#534AB7; --purple-light:#EEEDFE; --purple-bdr:#C5C2F5;
      --amber-bg:#FAEEDA; --amber-mid:#854F0B;
      --teal-bg:#E1F5EE; --teal-mid:#0F6E56;
      --text-main:#1A1A18; --text-muted:#5F5E5A; --text-faint:#A0A09A;
      --border:rgba(0,0,0,0.09); --white:#ffffff; --gray-bg:#F7F6F3;
      --radius-md:10px; --radius-lg:14px;
    }
    body { font-family:'DM Sans',sans-serif; background:var(--gray-bg); color:var(--text-main); }
    nav { background:var(--white); border-bottom:1px solid var(--border); padding:0 32px; height:60px; display:flex; align-items:center; justify-content:space-between; }
    .nav-left { display:flex; align-items:center; gap:10px; }
    .nav-icon { width:36px; height:36px; background:var(--purple-mid); border-radius:var(--radius-md); display:flex; align-items:center; justify-content:center; }
    .nav-icon svg { width:18px; height:18px; }
    .nav-title { font-size:15px; font-weight:600; }
    .nav-sub   { font-size:11px; color:var(--text-muted); font-family:'DM Mono',monospace; }
    .btn-back  { font-size:12px; padding:6px 14px; background:var(--gray-bg); border:1px solid var(--border); border-radius:var(--radius-md); text-decoration:none; color:var(--text-muted); }
    .btn-back:hover { border-color:var(--purple-mid); color:var(--purple-mid); }

    .page-wrap { max-width:960px; margin:32px auto; padding:0 24px; }
    .page-header { margin-bottom:24px; }
    .page-header h2 { font-size:20px; font-weight:600; }
    .page-header p  { font-size:13px; color:var(--text-muted); margin-top:4px; }

    .table-card { background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); overflow:hidden; margin-bottom:28px; }
    .table-top  { padding:16px 20px; border-bottom:1px solid var(--border); display:flex; justify-content:space-between; align-items:center; }
    .table-top-title { font-size:14px; font-weight:600; }
    .table-top-sub   { font-size:12px; color:var(--text-muted); font-family:'DM Mono',monospace; }
    table { width:100%; border-collapse:collapse; }
    thead th { padding:10px 16px; text-align:left; font-size:11px; font-weight:500; color:var(--text-faint); text-transform:uppercase; letter-spacing:0.06em; background:var(--gray-bg); border-bottom:1px solid var(--border); }
    tbody tr { border-bottom:1px solid var(--border); transition:background 0.12s; }
    tbody tr:last-child { border-bottom:none; }
    tbody tr:hover { background:#FAFAF8; }
    tbody td { padding:12px 16px; font-size:13px; vertical-align:middle; }
    .mono { font-family:'DM Mono',monospace; font-size:12px; color:var(--text-muted); }
    .label-badge { display:inline-block; font-size:11px; padding:2px 9px; border-radius:999px; background:var(--amber-bg); color:var(--amber-mid); font-weight:500; }

    /* DC SELECT DROPDOWN */
    .dc-select { padding:7px 10px; border:1px solid var(--border); border-radius:var(--radius-md); font-size:12px; font-family:'DM Sans',sans-serif; background:var(--gray-bg); color:var(--text-main); outline:none; min-width:160px; }
    .dc-select:focus { border-color:var(--purple-mid); }

    .btn-send {
      font-size:12px; font-weight:500; background:var(--purple-mid);
      color:#fff; border:none; padding:7px 16px;
      border-radius:var(--radius-md); cursor:pointer;
      font-family:'DM Sans',sans-serif; text-decoration:none;
      transition:background 0.15s; white-space:nowrap;
    }
    .btn-send:hover { background:#2D2785; }
    .empty-row td { text-align:center; padding:32px; color:var(--text-faint); font-size:13px; }
  </style>
</head>
<body>

<nav>
  <div class="nav-left">
    <div class="nav-icon">
      <svg viewBox="0 0 24 24" fill="none" stroke="#C5C2F5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <line x1="22" y1="2" x2="11" y2="13"/>
        <polygon points="22 2 15 22 11 13 2 9 22 2"/>
      </svg>
    </div>
    <div>
      <div class="nav-title">Send Master Key to DC</div>
      <div class="nav-sub">PKG Module · SecureRank</div>
    </div>
  </div>
  <a href="PKGHome.jsp" class="btn-back">← Dashboard</a>
</nav>

<div class="page-wrap">
  <div class="page-header">
    <h2>Send Master Key to Data Consumer</h2>
    <p>Select a Data Consumer for each file and click Send Key. The DC will use this Master Key to decrypt the file after downloading from Cloud Server.</p>
  </div>

  <%-- Build DC options once for reuse in every row --%>
  <%
    StringBuilder dcOptions = new StringBuilder();
    dcOptions.append("<option value=''>-- Select DC --</option>");
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
    <div class="table-top">
      <div class="table-top-title">Uploaded Encrypted Files</div>
      <div class="table-top-sub">ukeys table · fid / doid / uid / key1</div>
    </div>
    <table>
      <thead>
        <tr>
          <th>File ID</th>
          <th>File Name</th>
          <th>Data Owner</th>
          <th>Label</th>
          <th>Select DC</th>
          <th>Action</th>
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
          <td><strong><%= filename %></strong></td>
          <td class="mono"><%= doEmail %></td>
          <td><span class="label-badge"><%= label != null ? label : "—" %></span></td>
          <td>
            <select class="dc-select" id="dc_<%= fid %>">
              <%= dcOpts %>
            </select>
          </td>
          <td>
            <button class="btn-send"
              onclick="sendKey('<%= fid %>','<%= doEmail %>')">
              Send Key
            </button>
          </td>
        </tr>
        <%
            }
          }
          if (!hasFiles) {
        %>
        <tr class="empty-row">
          <td colspan="6">No files uploaded yet. Data Owners must upload files first.</td>
        </tr>
        <% } %>
      </tbody>
    </table>
  </div>
</div>

<script>
  function sendKey(fid, doid) {
    var sel = document.getElementById('dc_' + fid);
    var uid = sel.value;
    if (!uid) {
      alert('Please select a Data Consumer first.');
      return;
    }
    window.location = 'SendKeysToDC?fid=' + fid + '&uid=' + uid + '&doid=' + doid;
  }
</script>

<%
  try { if (rsFiles != null) rsFiles.close(); } catch (Exception ignored) {}
  try { if (rsDC   != null) rsDC.close();    } catch (Exception ignored) {}
  try { if (st     != null) st.close();      } catch (Exception ignored) {}
  try { if (st2    != null) st2.close();     } catch (Exception ignored) {}
  try { if (con    != null) con.close();     } catch (Exception ignored) {}
%>
</body>
</html>
