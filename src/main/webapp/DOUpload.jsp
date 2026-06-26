<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("email") == null) {
        response.sendRedirect("login.jsp?role=dataowner");
        return;
    }
    String doName = (String) s.getAttribute("name");
    String doEmail = (String) s.getAttribute("email");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Upload Encrypted File — SecureRank</title>
  
  <!-- Font and Icon Resources -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <link rel="stylesheet" href="css/style.css">
  
  <style>
    /* Specific styles for upload zone */
    .upload-container {
      max-width: 580px;
      margin: 0 auto;
    }
    
    .file-zone {
      border: 2px dashed var(--primary-border);
      border-radius: var(--radius-lg);
      padding: 32px 24px;
      text-align: center;
      background-color: var(--primary-light);
      cursor: pointer;
      transition: all 0.2s ease;
      margin-bottom: 20px;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
    }
    
    .file-zone:hover {
      border-color: var(--primary);
      background-color: var(--bg-surface);
    }
    
    .file-zone-icon {
      font-size: 36px;
      color: var(--primary);
      margin-bottom: 12px;
    }
    
    .file-zone-title {
      font-size: 14px;
      font-weight: 600;
      color: var(--text-main);
      margin-bottom: 4px;
    }
    
    .file-zone-sub {
      font-size: 11px;
      color: var(--text-muted);
    }
    
    .file-zone input {
      display: none;
    }
    
    .file-name-display {
      font-family: 'JetBrains Mono', monospace;
      font-size: 12px;
      color: var(--primary);
      margin-top: 12px;
      background-color: var(--bg-surface);
      border: 1px solid var(--border);
      padding: 4px 12px;
      border-radius: 999px;
      display: inline-block;
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
          <div class="sidebar-logo-sub">Data Owner Panel</div>
        </div>
      </div>
      
      <ul class="sidebar-menu">
        <li>
          <a href="DOHome.jsp" class="sidebar-link">
            <i class="bi bi-grid-fill"></i> Dashboard
          </a>
        </li>
        <li>
          <a href="DOUpload.jsp" class="sidebar-link active">
            <i class="bi bi-cloud-arrow-up-fill"></i> Upload File
          </a>
        </li>
        <li>
          <a href="ViewMyFiles.jsp" class="sidebar-link">
            <i class="bi bi-folder-fill"></i> My Uploaded Files
          </a>
        </li>
        <li>
          <a href="ViewRequests.jsp" class="sidebar-link">
            <i class="bi bi-key-fill"></i> Search Requests
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
          <%= doName.substring(0, Math.min(doName.length(), 2)).toUpperCase() %>
        </div>
        <div style="min-width: 0; flex: 1;">
          <div class="sidebar-user-name" title="<%= doName %>"><%= doName %></div>
          <div class="sidebar-user-role">Data Owner</div>
        </div>
      </div>
    </aside>

    <!-- Main Content Area -->
    <main class="main-content">
      
      <!-- Topnav -->
      <header class="topnav">
        <div class="topnav-title">Upload Core Documents</div>
        <div class="topnav-actions">
          <button class="theme-toggle" aria-label="Toggle Dark Mode"></button>
          <div style="font-size: 13px; color: var(--text-muted);">
            Logged in: <strong style="color: var(--text-main);"><%= doEmail %></strong>
          </div>
        </div>
      </header>
      
      <!-- Content Body -->
      <div class="content-body">
        
        <div class="upload-container">
          
          <div class="card">
            
            <div style="display: flex; align-items: center; gap: 14px; margin-bottom: 24px; border-bottom: 1px solid var(--border); padding-bottom: 16px;">
              <div style="width: 42px; height: 42px; border-radius: var(--radius-md); background-color: var(--primary-light); display: flex; align-items: center; justify-content: center; font-size: 20px; color: var(--primary);">
                <i class="bi bi-cloud-arrow-up-fill"></i>
              </div>
              <div>
                <h2 style="font-size: 16px; font-weight: 600;">Encrypt &amp; Upload Document</h2>
                <p style="font-size: 12px; color: var(--text-muted); margin-top: 1px;">Deploy secure encrypted records onto remote servers</p>
              </div>
            </div>

            <!-- Security Warning Alert -->
            <div class="badge badge-primary" style="display: flex; align-items: flex-start; gap: 10px; padding: 12px; border-radius: var(--radius-md); line-height: 1.5; margin-bottom: 24px; text-align: left; width: 100%;">
              <i class="bi bi-shield-fill-check" style="font-size: 16px;"></i>
              <div>File payload is encrypted locally using the <strong>Goldwasser-Micali (GM) Algorithm</strong> before outbound transmission. Plaintext remains protected.</div>
            </div>

            <!-- Main Upload Form -->
            <form action="UploadFile" method="post" enctype="multipart/form-data" id="uploadForm">
              
              <!-- Drag and Drop Custom Filezone -->
              <div class="file-zone" id="dropZone" onclick="document.getElementById('photoInput').click()">
                <div class="file-zone-icon">
                  <i class="bi bi-cloud-upload"></i>
                </div>
                <div class="file-zone-title">Drag &amp; Drop or click to browse</div>
                <div class="file-zone-sub">Text or Document assets up to 10MB</div>
                <span class="file-name-display" id="fileNameDisplay">No file chosen</span>
                <input type="file" name="photo" id="photoInput" required onchange="handleFileSelected(this)" />
              </div>

              <!-- Metadata File Preview Panel -->
              <div id="filePreviewCard" style="display: none; background-color: var(--bg-main); border: 1px solid var(--border); padding: 14px; border-radius: var(--radius-md); margin-bottom: 20px; align-items: center; gap: 12px;">
                <div style="font-size: 24px; color: var(--primary);"><i class="bi bi-file-earmark-lock-fill"></i></div>
                <div style="flex: 1; min-width: 0;">
                  <div id="previewFileName" style="font-size: 13px; font-weight: 600; color: var(--text-main); white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">document.txt</div>
                  <div id="previewFileSize" style="font-size: 11px; color: var(--text-muted);">0 KB</div>
                </div>
                <div id="previewEncBadge"><span class="badge badge-warning"><i class="bi bi-unlock"></i> Plaintext</span></div>
              </div>

              <!-- Classification label select -->
              <div class="form-group">
                <label class="form-label">Classification / Security Label *</label>
                <div class="input-wrapper">
                  <i class="bi bi-tag-fill"></i>
                  <select name="label" class="form-input" required style="padding-left: 36px;">
                    <option value="">Select label...</option>
                    <option value="Confidential">Confidential</option>
                    <option value="Medical">Medical</option>
                    <option value="Financial">Financial</option>
                    <option value="Legal">Legal</option>
                    <option value="Personal">Personal</option>
                    <option value="General">General</option>
                  </select>
                </div>
              </div>

              <!-- Keywords / Content textarea -->
              <div class="form-group">
                <label class="form-label">Search Keywords * <span style="font-weight: normal; color: var(--text-faint);">— separated by space</span></label>
                <div class="input-wrapper">
                  <i class="bi bi-search" style="top: 14px;"></i>
                  <textarea name="content" class="form-input" placeholder="e.g. prescription clinical audit diagnostic reports" required style="padding-left: 36px; min-height: 90px;"></textarea>
                </div>
              </div>

              <!-- Simulated Upload Progress Bar -->
              <div id="uploadProgressWrap" style="display: none; margin-bottom: 20px; background-color: var(--bg-main); border: 1px solid var(--border); padding: 14px; border-radius: var(--radius-md);">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
                  <span id="uploadStatusText" style="font-size: 12px; font-weight: 500; color: var(--primary);">Preparing cryptographic keys...</span>
                </div>
                <div class="progress-container">
                  <div class="progress-fill" id="uploadProgressFill"></div>
                </div>
              </div>

              <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px; margin-top: 10px;">
                <i class="bi bi-shield-lock-fill"></i> Encrypt &amp; Deploy Document &rarr;
              </button>
              
            </form>
          </div>
          
        </div>
        
      </div>
    </main>

  </div>

  <script src="js/theme.js"></script>
  <script>
    function handleFileSelected(input) {
      var file = input.files[0];
      if (file) {
        document.getElementById('fileNameDisplay').textContent = file.name;
        document.getElementById('previewFileName').textContent = file.name;
        
        // Calculate size representation
        var sizeKB = (file.size / 1024).toFixed(1);
        document.getElementById('previewFileSize').textContent = sizeKB + " KB";
        
        // Show Preview Card
        document.getElementById('filePreviewCard').style.display = 'flex';
        
        // Animate badge status transition on load
        setTimeout(function() {
          var badge = document.getElementById('previewEncBadge');
          badge.innerHTML = '<span class="badge badge-success"><i class="bi bi-lock-fill"></i> Ready to Encrypt</span>';
        }, 300);
      }
    }
  </script>
</body>
</html>
