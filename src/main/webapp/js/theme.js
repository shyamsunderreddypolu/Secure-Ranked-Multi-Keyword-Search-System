/**
 * SecureRank Theme Controller & UI Utilities
 */

document.addEventListener('DOMContentLoaded', function() {
  // ─── THEME INITIALIZATION ──────────────────────────────────────
  const currentTheme = localStorage.getItem('theme') || 'light';
  if (currentTheme === 'dark') {
    document.body.classList.add('dark');
    updateThemeToggleIcons('dark');
  } else {
    document.body.classList.remove('dark');
    updateThemeToggleIcons('light');
  }

  // Bind theme toggles dynamically
  const toggles = document.querySelectorAll('.theme-toggle');
  toggles.forEach(btn => {
    btn.addEventListener('click', toggleTheme);
  });

  // ─── PASSWORD VISIBILITY TOGGLING ────────────────────────────────
  const pwdFields = document.querySelectorAll('input[type="password"]');
  pwdFields.forEach(field => {
    // Find parent wrapper or create visibility trigger if needed
    const wrapper = field.parentElement;
    if (wrapper && wrapper.classList.contains('input-wrapper')) {
      const toggleBtn = document.createElement('button');
      toggleBtn.type = 'button';
      toggleBtn.className = 'pwd-toggle';
      toggleBtn.innerHTML = '<i class="bi bi-eye"></i>';
      toggleBtn.addEventListener('click', function() {
        if (field.type === 'password') {
          field.type = 'text';
          toggleBtn.innerHTML = '<i class="bi bi-eye-slash"></i>';
        } else {
          field.type = 'password';
          toggleBtn.innerHTML = '<i class="bi bi-eye"></i>';
        }
      });
      wrapper.appendChild(toggleBtn);
    }
  });

  // ─── FORM LOADING STATE ON SUBMIT ──────────────────────────────
  const forms = document.querySelectorAll('form');
  forms.forEach(form => {
    form.addEventListener('submit', function() {
      const btn = form.querySelector('button[type="submit"]');
      if (btn) {
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner"></span> Processing...';
      }
    });
  });
});

// Toggle theme function
function toggleTheme() {
  if (document.body.classList.contains('dark')) {
    document.body.classList.remove('dark');
    localStorage.setItem('theme', 'light');
    updateThemeToggleIcons('light');
    showToast('Switched to Light Mode', 'info');
  } else {
    document.body.classList.add('dark');
    localStorage.setItem('theme', 'dark');
    updateThemeToggleIcons('dark');
    showToast('Switched to Dark Mode', 'info');
  }
}

// Update toggle buttons icons
function updateThemeToggleIcons(theme) {
  const toggles = document.querySelectorAll('.theme-toggle');
  toggles.forEach(btn => {
    if (theme === 'dark') {
      btn.innerHTML = '<i class="bi bi-sun-fill"></i>';
      btn.title = 'Switch to Light Mode';
    } else {
      btn.innerHTML = '<i class="bi bi-moon-fill"></i>';
      btn.title = 'Switch to Dark Mode';
    }
  });
}

// ─── TOAST NOTIFICATIONS ─────────────────────────────────────────
function showToast(message, type = 'info') {
  let container = document.querySelector('.toast-container');
  if (!container) {
    container = document.createElement('div');
    container.className = 'toast-container';
    document.body.appendChild(container);
  }

  const toast = document.createElement('div');
  toast.className = `toast toast-${type}`;
  
  let icon = '<i class="bi bi-info-circle-fill" style="color: var(--primary);"></i>';
  if (type === 'success') {
    icon = '<i class="bi bi-check-circle-fill" style="color: var(--success);"></i>';
  } else if (type === 'error') {
    icon = '<i class="bi bi-exclamation-triangle-fill" style="color: var(--danger);"></i>';
  }

  toast.innerHTML = `
    ${icon}
    <div style="flex: 1;">${message}</div>
  `;

  container.appendChild(toast);

  // Auto remove after 3.5 seconds
  setTimeout(() => {
    toast.style.animation = 'slideIn 0.2s reverse forwards';
    toast.addEventListener('animationend', () => {
      toast.remove();
      if (container.children.length === 0) {
        container.remove();
      }
    });
  }, 3500);
}

// Add CSS dynamically for submit spinner
const style = document.createElement('style');
style.textContent = `
  .spinner {
    display: inline-block;
    width: 12px;
    height: 12px;
    border: 2px solid rgba(255,255,255,0.3);
    border-radius: 50%;
    border-top-color: #fff;
    animation: spin 0.8s linear infinite;
    margin-right: 6px;
    vertical-align: middle;
  }
  @keyframes spin {
    to { transform: rotate(360deg); }
  }
`;
document.head.appendChild(style);

// ─── CLIENT-SIDE TABLE SEARCH ────────────────────────────────────
document.addEventListener('DOMContentLoaded', function() {
  const searchInputs = document.querySelectorAll('.table-search-input');
  searchInputs.forEach(input => {
    const targetTableId = input.getAttribute('data-table');
    const table = document.getElementById(targetTableId) || document.querySelector('table');
    if (table) {
      input.addEventListener('input', function() {
        const query = this.value.toLowerCase().trim();
        const rows = table.querySelectorAll('tbody tr:not(.empty-row)');
        let visibleCount = 0;
        rows.forEach(row => {
          const text = row.textContent.toLowerCase();
          if (text.includes(query)) {
            row.style.display = '';
            visibleCount++;
          } else {
            row.style.display = 'none';
          }
        });
        
        let emptyRow = table.querySelector('.empty-row');
        if (visibleCount === 0) {
          if (!emptyRow) {
            emptyRow = document.createElement('tr');
            emptyRow.className = 'empty-row';
            const colSpan = table.querySelectorAll('thead th').length || 6;
            emptyRow.innerHTML = `<td colspan="${colSpan}" style="text-align:center; padding:30px; color:var(--text-faint);">No matching records found</td>`;
            table.querySelector('tbody').appendChild(emptyRow);
          } else {
            emptyRow.style.display = '';
          }
        } else if (emptyRow) {
          emptyRow.style.display = 'none';
        }
      });
    }
  });

  // ─── CLIENT-SIDE TABLE SORTING ───────────────────────────────────
  const sortableHeaders = document.querySelectorAll('table.sortable thead th');
  sortableHeaders.forEach(th => {
    th.style.cursor = 'pointer';
    th.addEventListener('click', function() {
      const table = th.closest('table');
      const tbody = table.querySelector('tbody');
      const rows = Array.from(tbody.querySelectorAll('tr:not(.empty-row)'));
      const index = Array.from(th.parentElement.children).indexOf(th);
      const isAscending = th.classList.contains('sort-asc');
      
      th.parentElement.querySelectorAll('th').forEach(header => {
        header.classList.remove('sort-asc', 'sort-desc');
        header.innerHTML = header.innerHTML.replace(/ ▲| ▼/g, '');
      });

      rows.sort((rowA, rowB) => {
        const cellA = rowA.children[index].textContent.trim();
        const cellB = rowB.children[index].textContent.trim();
        
        const valA = parseFloat(cellA.replace(/[^0-9.-]+/g, ''));
        const valB = parseFloat(cellB.replace(/[^0-9.-]+/g, ''));
        
        if (!isNaN(valA) && !isNaN(valB)) {
          return isAscending ? valB - valA : valA - valB;
        }
        return isAscending 
          ? cellB.localeCompare(cellA) 
          : cellA.localeCompare(cellB);
      });

      if (isAscending) {
        th.classList.add('sort-desc');
        th.innerHTML += ' ▼';
      } else {
        th.classList.add('sort-asc');
        th.innerHTML += ' ▲';
      }

      rows.forEach(row => tbody.appendChild(row));
    });
  });

  // ─── DRAG AND DROP ZONE UTILITY ──────────────────────────────────
  const dropZones = document.querySelectorAll('.file-zone');
  dropZones.forEach(zone => {
    const input = zone.querySelector('input[type="file"]');
    if (input) {
      ['dragenter', 'dragover'].forEach(eventName => {
        zone.addEventListener(eventName, e => {
          e.preventDefault();
          zone.classList.add('dragover');
        }, false);
      });

      ['dragleave', 'drop'].forEach(eventName => {
        zone.addEventListener(eventName, e => {
          e.preventDefault();
          zone.classList.remove('dragover');
        }, false);
      });

      zone.addEventListener('drop', e => {
        const dt = e.dataTransfer;
        const files = dt.files;
        if (files.length) {
          input.files = files;
          const display = zone.querySelector('.file-name-display');
          if (display) display.textContent = files[0].name;
          showToast(`File "${files[0].name}" loaded successfully`, 'success');
        }
      });
    }
  });

  // ─── PASSWORD STRENGTH INDICATOR ─────────────────────────────────
  const passwordInputs = document.querySelectorAll('input.password-meter');
  passwordInputs.forEach(input => {
    const container = input.closest('.form-group');
    if (container) {
      let meter = container.querySelector('.strength-meter');
      if (!meter) {
        meter = document.createElement('div');
        meter.className = 'strength-meter';
        meter.innerHTML = '<div class="strength-bar"></div>';
        container.appendChild(meter);
        
        const label = document.createElement('span');
        label.className = 'strength-label';
        label.textContent = 'Password strength';
        container.appendChild(label);
      }
      
      const strengthBar = meter.querySelector('.strength-bar');
      const strengthLabel = container.querySelector('.strength-label');

      input.addEventListener('input', function() {
        const pwd = this.value;
        let score = 0;
        if (pwd.length >= 6) score++;
        if (/[A-Z]/.test(pwd)) score++;
        if (/[0-9]/.test(pwd)) score++;
        if (/[^A-Za-z0-9]/.test(pwd)) score++;

        let width = '0%';
        let color = 'var(--danger)';
        let labelText = 'Too Short';

        if (pwd.length === 0) {
          width = '0%';
          labelText = 'Password is required';
        } else if (score === 1) {
          width = '25%';
          color = 'var(--danger)';
          labelText = 'Weak (Needs numbers/uppercase)';
        } else if (score === 2) {
          width = '50%';
          color = 'var(--warning)';
          labelText = 'Medium (Add special characters)';
        } else if (score >= 3) {
          width = '100%';
          color = 'var(--success)';
          labelText = 'Strong Password';
        }
        
        strengthBar.style.width = width;
        strengthBar.style.backgroundColor = color;
        strengthLabel.textContent = labelText;
      });
    }
  });

  // ─── UPLOAD PROGRESS SIMULATION ──────────────────────────────────
  const uploadForm = document.getElementById('uploadForm');
  if (uploadForm) {
    uploadForm.addEventListener('submit', function(e) {
      e.preventDefault();
      const progressWrap = document.getElementById('uploadProgressWrap');
      const progressFill = document.getElementById('uploadProgressFill');
      const statusText = document.getElementById('uploadStatusText');
      const submitBtn = uploadForm.querySelector('button[type="submit"]');
      
      if (progressWrap && progressFill && statusText && submitBtn) {
        submitBtn.disabled = true;
        progressWrap.style.display = 'block';
        
        let progress = 0;
        const messages = [
          { threshold: 25, text: 'Encrypting payload locally (GM Cryptosystem)...' },
          { threshold: 50, text: 'Computing Paillier secure indices...' },
          { threshold: 75, text: 'Hashing multi-keyword trapdoors...' },
          { threshold: 95, text: 'Deploying encrypted block to Cloud Server...' }
        ];
        
        const interval = setInterval(() => {
          progress += 2;
          progressFill.style.width = `${progress}%`;
          
          const currentMsg = messages.find(m => progress <= m.threshold);
          if (currentMsg) {
            statusText.textContent = currentMsg.text;
          } else {
            statusText.textContent = 'Uploading ciphertext to database...';
          }
          
          if (progress >= 100) {
            clearInterval(interval);
            statusText.textContent = 'Upload complete! Finalizing storage...';
            setTimeout(() => {
              uploadForm.submit();
            }, 600);
          }
        }, 40);
      } else {
        uploadForm.submit();
      }
    });
  }

  // ─── COLLAPSIBLE SIDEBAR TOGGLER ─────────────────────────────────
  const sidebarToggles = document.querySelectorAll('.sidebar-toggle-btn');
  const appContainer = document.querySelector('.app-container');
  if (appContainer) {
    sidebarToggles.forEach(btn => {
      btn.addEventListener('click', function() {
        appContainer.classList.toggle('sidebar-collapsed');
      });
    });
  }
});

