<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("email") == null) {
        response.sendRedirect("DOLogin.jsp");
        return;
    }
    String doName = (String) s.getAttribute("name");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Upload Encrypted File — SecureRank</title>
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
    :root {
      --teal-mid:#0F6E56; --teal-light:#E1F5EE; --teal-bdr:#A8DFC9;
      --text-main:#1A1A18; --text-muted:#5F5E5A; --text-faint:#A0A09A;
      --border:rgba(0,0,0,0.09); --white:#fff; --gray-bg:#F7F6F3;
      --radius-md:10px; --radius-lg:14px;
    }
    body { font-family:'DM Sans',sans-serif; background:var(--gray-bg); color:var(--text-main); min-height:100vh; }
    nav { background:var(--white); border-bottom:1px solid var(--border); padding:0 32px; height:60px; display:flex; align-items:center; justify-content:space-between; }
    .nav-left { display:flex; align-items:center; gap:10px; }
    .nav-icon { width:36px; height:36px; background:var(--teal-mid); border-radius:var(--radius-md); display:flex; align-items:center; justify-content:center; }
    .nav-icon svg { width:18px; height:18px; }
    .nav-title { font-size:15px; font-weight:600; }
    .nav-sub   { font-size:11px; color:var(--text-muted); font-family:'DM Mono',monospace; }
    .btn-back  { font-size:12px; padding:6px 14px; background:var(--gray-bg); border:1px solid var(--border); border-radius:var(--radius-md); text-decoration:none; color:var(--text-muted); }
    .btn-back:hover { border-color:var(--teal-mid); color:var(--teal-mid); }

    .page-wrap { max-width:560px; margin:40px auto; padding:0 24px; }
    .page-header { margin-bottom:24px; }
    .page-header h2 { font-size:20px; font-weight:600; }
    .page-header p  { font-size:13px; color:var(--text-muted); margin-top:4px; }

    .form-card { background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); padding:32px 28px; }

    .notice { display:flex; gap:10px; background:var(--teal-light); border:1px solid var(--teal-bdr); border-radius:var(--radius-md); padding:12px 14px; margin-bottom:22px; }
    .notice svg  { width:16px; height:16px; stroke:var(--teal-mid); flex-shrink:0; margin-top:1px; }
    .notice-text { font-size:12px; color:var(--teal-mid); line-height:1.55; }

    .form-group { margin-bottom:16px; }
    .form-label { display:block; font-size:12px; font-weight:500; color:var(--text-muted); margin-bottom:6px; }
    .form-input { width:100%; padding:10px 12px; border:1px solid var(--border); border-radius:var(--radius-md); font-size:14px; font-family:'DM Sans',sans-serif; color:var(--text-main); background:var(--gray-bg); outline:none; transition:border-color 0.15s; }
    .form-input:focus { border-color:var(--teal-mid); background:var(--white); }
    .form-select { width:100%; padding:10px 12px; border:1px solid var(--border); border-radius:var(--radius-md); font-size:14px; font-family:'DM Sans',sans-serif; background:var(--gray-bg); outline:none; cursor:pointer; }
    textarea.form-input { resize:vertical; min-height:90px; }

    /* FILE DROP ZONE */
    .file-zone { border:2px dashed var(--teal-bdr); border-radius:var(--radius-md); padding:28px; text-align:center; background:var(--teal-light); cursor:pointer; transition:border-color 0.15s; margin-bottom:16px; }
    .file-zone:hover { border-color:var(--teal-mid); }
    .file-zone svg  { width:32px; height:32px; stroke:var(--teal-mid); margin-bottom:8px; }
    .file-zone-title { font-size:13px; font-weight:500; color:var(--teal-mid); margin-bottom:4px; }
    .file-zone-sub   { font-size:11px; color:var(--text-muted); }
    .file-zone input { display:none; }
    .file-name-display { font-size:12px; color:var(--teal-mid); font-family:'DM Mono',monospace; margin-top:8px; min-height:16px; }

    .btn-submit { width:100%; padding:12px; background:var(--teal-mid); color:#fff; border:none; border-radius:var(--radius-md); font-size:14px; font-weight:500; font-family:'DM Sans',sans-serif; cursor:pointer; margin-top:6px; transition:background 0.15s; }
    .btn-submit:hover { background:#0A4F3C; }
  </style>
</head>
<body>

<nav>
  <div class="nav-left">
    <div class="nav-icon">
      <svg viewBox="0 0 24 24" fill="none" stroke="#A8DFC9" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/>
        <polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/>
      </svg>
    </div>
    <div>
      <div class="nav-title">Upload Encrypted File</div>
      <div class="nav-sub">Data Owner · SecureRank</div>
    </div>
  </div>
  <a href="DOHome.jsp" class="btn-back">← Dashboard</a>
</nav>

<div class="page-wrap">
  <div class="page-header">
    <h2>Upload &amp; Encrypt File</h2>
    <p>Your file will be encrypted using the GM algorithm before being stored on the cloud server.</p>
  </div>

  <div class="form-card">
    <div class="notice">
      <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
      </svg>
      <div class="notice-text">File content is encrypted using <strong>GM homomorphic encryption</strong>. The cloud server stores only ciphertext — it never sees your plaintext data.</div>
    </div>

    <%-- enctype="multipart/form-data" required for file upload --%>
    <form action="UploadFile" method="post" enctype="multipart/form-data" id="uploadForm">

      <%-- File picker --%>
      <div class="file-zone" onclick="document.getElementById('photoInput').click()">
        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/>
          <polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/>
        </svg>
        <div class="file-zone-title">Click to select file</div>
        <div class="file-zone-sub">Any file type · Max 10 MB</div>
        <div class="file-name-display" id="fileNameDisplay">No file chosen</div>
        <input type="file" name="photo" id="photoInput" required
               onchange="document.getElementById('fileNameDisplay').textContent = this.files[0]?.name || 'No file chosen'" />
      </div>

      <div class="form-group">
        <label class="form-label">File Label / Classification *</label>
        <select name="label" class="form-select" required>
          <option value="">Select label...</option>
          <option value="Confidential">Confidential</option>
          <option value="Medical">Medical</option>
          <option value="Financial">Financial</option>
          <option value="Legal">Legal</option>
          <option value="Personal">Personal</option>
          <option value="General">General</option>
        </select>
      </div>

      <div class="form-group">
        <label class="form-label">Keywords / Content Description *
          <span style="font-weight:400;color:var(--text-faint);"> — used to build TF-IDF search index</span>
        </label>
        <textarea name="content" class="form-input"
          placeholder="e.g. medical report diabetes doctor prescription 2024"
          required></textarea>
      </div>

      <button type="submit" class="btn-submit">
        Encrypt &amp; Upload File →
      </button>
    </form>
  </div>
</div>

</body>
</html>
