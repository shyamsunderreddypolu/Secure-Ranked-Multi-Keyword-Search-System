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

    // Load existing trapdoors for this DC
    Connection con = com.dao.DBConnection.connect();
    ResultSet  rs  = null;
    Statement  st  = null;
    try {
        st = con.createStatement();
        rs = st.executeQuery(
            "select id, name, trap from trapdoor where uid='"
            + dcEmail + "' order by id desc");
    } catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Generate Trapdoor — SecureRank</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
    :root {
      --amber-mid:#854F0B; --amber-light:#FAEEDA; --amber-bdr:#F0C98A;
      --teal-bg:#E1F5EE; --teal-mid:#0F6E56;
      --text-main:#1A1A18; --text-muted:#5F5E5A; --text-faint:#A0A09A;
      --border:rgba(0,0,0,0.09); --white:#fff; --gray-bg:#F7F6F3;
      --radius-md:10px; --radius-lg:14px;
    }
    body { font-family:'DM Sans',sans-serif; background:var(--gray-bg); }
    nav { background:var(--white); border-bottom:1px solid var(--border); padding:0 32px; height:60px; display:flex; align-items:center; justify-content:space-between; }
    .nav-title { font-size:15px; font-weight:600; }
    .nav-sub   { font-size:11px; color:var(--text-muted); font-family:'DM Mono',monospace; }
    .btn-back  { font-size:12px; padding:6px 14px; background:var(--gray-bg); border:1px solid var(--border); border-radius:var(--radius-md); text-decoration:none; color:var(--text-muted); }
    .btn-back:hover { border-color:var(--amber-mid); color:var(--amber-mid); }

    .page-wrap { max-width:820px; margin:32px auto; padding:0 24px; display:grid; grid-template-columns:1fr 1fr; gap:20px; }
    .page-wrap-full { max-width:820px; margin:0 auto; padding:0 24px 32px; }

    .form-card { background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); padding:28px 24px; }
    .card-title { font-size:16px; font-weight:600; margin-bottom:6px; }
    .card-sub   { font-size:12px; color:var(--text-muted); margin-bottom:22px; line-height:1.5; }
    .form-group { margin-bottom:16px; }
    .form-label { display:block; font-size:12px; font-weight:500; color:var(--text-muted); margin-bottom:6px; }
    .form-input { width:100%; padding:10px 12px; border:1px solid var(--border); border-radius:var(--radius-md); font-size:14px; font-family:'DM Sans',sans-serif; background:var(--gray-bg); outline:none; transition:border-color 0.15s; }
    .form-input:focus { border-color:var(--amber-mid); background:var(--white); }
    .btn-gen { width:100%; padding:11px; background:var(--amber-mid); color:#fff; border:none; border-radius:var(--radius-md); font-size:14px; font-weight:500; font-family:'DM Sans',sans-serif; cursor:pointer; transition:background 0.15s; }
    .btn-gen:hover { background:#5c3708; }

    .info-box { background:var(--teal-bg); border:1px solid #A8DFC9; border-radius:var(--radius-md); padding:14px; }
    .info-title { font-size:12px; font-weight:600; color:var(--teal-mid); margin-bottom:8px; }
    .info-row { font-size:11px; color:var(--teal-mid); line-height:1.8; }

    /* TABLE */
    .table-card { background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); overflow:hidden; }
    .table-top  { padding:14px 20px; border-bottom:1px solid var(--border); display:flex; justify-content:space-between; }
    .table-top-title { font-size:14px; font-weight:600; }
    .table-top-sub   { font-size:12px; color:var(--text-muted); font-family:'DM Mono',monospace; }
    table { width:100%; border-collapse:collapse; }
    thead th { padding:9px 16px; text-align:left; font-size:11px; font-weight:500; color:var(--text-faint); text-transform:uppercase; background:var(--gray-bg); border-bottom:1px solid var(--border); letter-spacing:0.05em; }
    tbody tr { border-bottom:1px solid var(--border); }
    tbody tr:last-child { border-bottom:none; }
    tbody tr:hover { background:#FAFAF8; }
    tbody td { padding:12px 16px; font-size:13px; }
    .mono { font-family:'DM Mono',monospace; font-size:11px; color:var(--text-muted); }
    .trap-val { max-width:200px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; font-family:'DM Mono',monospace; font-size:11px; color:var(--amber-mid); }
    .empty-row td { text-align:center; padding:32px; color:var(--text-faint); font-size:13px; }

    @media(max-width:600px){ .page-wrap{grid-template-columns:1fr;} }
  </style>
</head>
<body>

<nav>
  <div>
    <div class="nav-title">Generate Trapdoor</div>
    <div class="nav-sub">Data Consumer · <%= dcName %></div>
  </div>
  <a href="DCHome.jsp" class="btn-back">← Dashboard</a>
</nav>

<div class="page-wrap">
  <!-- LEFT: Generate form -->
  <div class="form-card">
    <div class="card-title">Generate Search Trapdoor</div>
    <div class="card-sub">Enter a keyword below. It will be encrypted using your Secret Key (sk) into a trapdoor — the Cloud Server uses this to search without seeing the actual keyword.</div>
    <form action="GenerateTrapdoor" method="post">
      <div class="form-group">
        <label class="form-label">Search Keyword *</label>
        <input type="text" name="keyword" class="form-input"
               placeholder="e.g. medical, diabetes, report"
               required autocomplete="off" />
      </div>
      <button type="submit" class="btn-gen">Generate Trapdoor →</button>
    </form>
  </div>

  <!-- RIGHT: Info box -->
  <div class="info-box">
    <div class="info-title">How trapdoor generation works</div>
    <div class="info-row">
      1. Your keyword is encrypted using your Secret Key (sk) issued by PKG.<br><br>
      2. The encrypted trapdoor is stored in the <strong>trapdoor</strong> table.<br><br>
      3. Cloud Server compares the trapdoor against the encrypted TF-IDF keyword index of all files.<br><br>
      4. Only files containing the keyword in their index will match — without the server seeing your keyword.<br><br>
      5. Matched files are ranked by TF-IDF relevance score.
    </div>
  </div>
</div>

<!-- TRAPDOOR LIST -->
<div class="page-wrap-full">
  <div class="table-card">
    <div class="table-top">
      <div class="table-top-title">Your Generated Trapdoors</div>
      <div class="table-top-sub">trapdoor table · name / uid / trap</div>
    </div>
    <table>
      <thead>
        <tr>
          <th>#</th>
          <th>Keyword</th>
          <th>Encrypted Trapdoor Value</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <%
          boolean hasRows = false;
          int count = 1;
          if (rs != null) {
            while (rs.next()) {
              hasRows = true;
              String kwName = rs.getString("name");
              String trap   = rs.getString("trap");
        %>
        <tr>
          <td class="mono"><%= count++ %></td>
          <td><strong><%= kwName %></strong></td>
          <td><div class="trap-val" title="<%= trap %>"><%= trap %></div></td>
          <td>
            <a href="SearchFile?keyword=<%= kwName %>"
               style="font-size:12px;font-weight:500;color:var(--amber-mid);text-decoration:none;">
              Search with this →
            </a>
          </td>
        </tr>
        <%
            }
          }
          if (!hasRows) {
        %>
        <tr class="empty-row">
          <td colspan="4">No trapdoors generated yet. Enter a keyword above to get started.</td>
        </tr>
        <% } %>
      </tbody>
    </table>
  </div>
</div>

<%
  try { if (rs != null) rs.close(); } catch (Exception ignored) {}
  try { if (st != null) st.close(); } catch (Exception ignored) {}
  try { if (con != null) con.close(); } catch (Exception ignored) {}
%>
</body>
</html>
