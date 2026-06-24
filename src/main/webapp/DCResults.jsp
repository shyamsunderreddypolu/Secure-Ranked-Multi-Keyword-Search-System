<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession, java.sql.*" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("dcemail") == null) {
        response.sendRedirect("DCLogin.jsp");
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
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
    :root {
      --amber-mid:#854F0B; --amber-light:#FAEEDA; --amber-bdr:#F0C98A;
      --teal-bg:#E1F5EE; --teal-mid:#0F6E56;
      --blue-light:#E6F1FB; --blue-mid:#185FA5;
      --text-main:#1A1A18; --text-muted:#5F5E5A; --text-faint:#A0A09A;
      --border:rgba(0,0,0,0.09); --white:#fff; --gray-bg:#F7F6F3;
      --radius-md:10px; --radius-lg:14px;
    }
    body { font-family:'DM Sans',sans-serif; background:var(--gray-bg); }
    nav { background:var(--white); border-bottom:1px solid var(--border); padding:0 32px; height:60px; display:flex; align-items:center; justify-content:space-between; }
    .nav-title { font-size:15px; font-weight:600; }
    .nav-sub   { font-size:11px; color:var(--text-muted); font-family:'DM Mono',monospace; }
    .nav-actions { display:flex; gap:10px; }
    .btn-back  { font-size:12px; padding:6px 14px; background:var(--gray-bg); border:1px solid var(--border); border-radius:var(--radius-md); text-decoration:none; color:var(--text-muted); }
    .btn-search { font-size:12px; padding:6px 14px; background:var(--amber-mid); color:#fff; border:none; border-radius:var(--radius-md); text-decoration:none; font-weight:500; }

    .page-wrap { max-width:960px; margin:32px auto; padding:0 24px; }
    .page-header { margin-bottom:20px; }
    .page-header h2 { font-size:20px; font-weight:600; }
    .page-header p  { font-size:13px; color:var(--text-muted); margin-top:4px; }

    .table-card { background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); overflow:hidden; }
    .table-top  { padding:16px 20px; border-bottom:1px solid var(--border); display:flex; justify-content:space-between; align-items:center; }
    .table-top-title { font-size:14px; font-weight:600; }
    .table-top-sub   { font-size:12px; color:var(--text-muted); font-family:'DM Mono',monospace; }
    table { width:100%; border-collapse:collapse; }
    thead th { padding:10px 16px; text-align:left; font-size:11px; font-weight:500; color:var(--text-faint); text-transform:uppercase; background:var(--gray-bg); border-bottom:1px solid var(--border); letter-spacing:0.05em; }
    tbody tr { border-bottom:1px solid var(--border); transition:background 0.12s; }
    tbody tr:last-child { border-bottom:none; }
    tbody tr:hover { background:#FAFAF8; }
    tbody td { padding:14px 16px; font-size:13px; vertical-align:middle; }
    .mono  { font-family:'DM Mono',monospace; font-size:11px; color:var(--text-muted); }
    .label-badge { display:inline-block; font-size:11px; padding:3px 9px; border-radius:999px; background:var(--amber-light); color:var(--amber-mid); font-weight:500; }
    .enc-badge   { display:inline-block; font-size:11px; padding:3px 9px; border-radius:999px; background:var(--teal-bg); color:var(--teal-mid); font-weight:500; }
    .rank-badge  { display:inline-flex; align-items:center; gap:4px; font-size:11px; padding:3px 9px; border-radius:999px; background:var(--blue-light); color:var(--blue-mid); font-weight:500; font-family:'DM Mono',monospace; }
    .btn-download { font-size:12px; font-weight:500; color:var(--blue-mid); text-decoration:none; padding:5px 12px; border:1px solid var(--blue-mid); border-radius:var(--radius-md); transition:all 0.15s; white-space:nowrap; }
    .btn-download:hover { background:var(--blue-mid); color:#fff; }
    .empty-row td { text-align:center; padding:40px; color:var(--text-faint); font-size:13px; }
  </style>
</head>
<body>

<nav>
  <div>
    <div class="nav-title">Search Results</div>
    <div class="nav-sub">Data Consumer · <%= dcName %></div>
  </div>
  <div class="nav-actions">
    <a href="SearchFile.jsp" class="btn-search">New Search</a>
    <a href="DCHome.jsp"     class="btn-back">← Dashboard</a>
  </div>
</nav>

<div class="page-wrap">
  <div class="page-header">
    <h2>Ranked Search Results</h2>
    <p>Files matched by Boolean keyword search on the encrypted index. Results ranked by TF-IDF relevance score.</p>
  </div>

  <div class="table-card">
    <div class="table-top">
      <div class="table-top-title">Matched Encrypted Files</div>
      <div class="table-top-sub">response + upload tables</div>
    </div>
    <table>
      <thead>
        <tr>
          <th>Rank</th>
          <th>File ID</th>
          <th>File Name</th>
          <th>Data Owner</th>
          <th>Label</th>
          <th>Status</th>
          <th>Action</th>
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
          <td><span class="rank-badge">#<%= rank++ %></span></td>
          <td class="mono"><%= fid %></td>
          <td><strong><%= filename.isEmpty() ? "File_" + fid : filename %></strong></td>
          <td class="mono"><%= doEmail %></td>
          <td><span class="label-badge"><%= label.isEmpty() ? "Encrypted" : label %></span></td>
          <td><span class="enc-badge">GM Encrypted</span></td>
          <td>
            <a href="DownloadFile?fid=<%= fid %>&uid=<%= dcEmail %>"
               class="btn-download">Download</a>
          </td>
        </tr>
        <%
            }
          }
          if (!hasRows) {
        %>
        <tr class="empty-row">
          <td colspan="7">
            No results yet. Go to <a href="SearchFile.jsp"
            style="color:var(--amber-mid);font-weight:500;">Search Files</a>
            and submit a trapdoor to search.
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>
  </div>
</div>

<%
  try { if (rs  != null) rs.close();  } catch (Exception ignored) {}
  try { if (st  != null) st.close();  } catch (Exception ignored) {}
  try { if (stFallback != null) stFallback.close(); } catch (Exception ignored) {}
  try { if (con != null) con.close(); } catch (Exception ignored) {}
%>
</body>
</html>
