/**
 * CareCar - Main Frontend Scripts
 */
document.addEventListener('DOMContentLoaded', () => {
  // Auto-dismiss alerts after 5 seconds
  const alerts = document.querySelectorAll('.alert:not(.alert-permanent)');
  alerts.forEach(alert => {
    setTimeout(() => {
      alert.style.transition = 'opacity 0.5s ease';
      alert.style.opacity = '0';
      setTimeout(() => alert.remove(), 500);
    }, 5000);
  });

  /* ==========================================
     1. Services Page: Search & Category Filter
     ========================================== */
  const serviceSearchInput = document.getElementById('serviceSearchInput');
  const categoryFilters = document.querySelectorAll('.category-filter');
  const serviceCards = document.querySelectorAll('.service-card');

  if (categoryFilters.length > 0 && serviceCards.length > 0) {
    let currentCategory = 'ALL';
    let searchQuery = '';

    const filterServices = () => {
      serviceCards.forEach(card => {
        const cat = card.dataset.category;
        const text = card.textContent.toLowerCase();

        const matchCat = (currentCategory === 'ALL' || cat === currentCategory);
        const matchSearch = (!searchQuery || text.includes(searchQuery));

        if (matchCat && matchSearch) {
          card.style.display = '';
        } else {
          card.style.display = 'none';
        }
      });
    };

    categoryFilters.forEach(btn => {
      btn.addEventListener('click', (e) => {
        categoryFilters.forEach(b => {
          b.classList.remove('active', 'btn-primary');
          b.classList.add('btn-outline-secondary');
        });
        btn.classList.add('active', 'btn-primary');
        btn.classList.remove('btn-outline-secondary');
        currentCategory = btn.dataset.category;
        filterServices();
      });
    });

    if (serviceSearchInput) {
      serviceSearchInput.addEventListener('input', (e) => {
        searchQuery = e.target.value.toLowerCase().trim();
        filterServices();
      });
    }
  }

  /* ==========================================
     2. Booking Page: Form Validation & Submit
     ========================================== */
  const bookingForm = document.getElementById('bookingForm');
  const bookingModalEl = document.getElementById('bookingSuccessModal');
  const bookingSummaryCard = document.getElementById('bookingSummaryCard');

  if (bookingForm) {
    // Set default date to tomorrow
    const dateInput = document.getElementById('bookingDate');
    if (dateInput) {
      const tomorrow = new Date();
      tomorrow.setDate(tomorrow.getDate() + 1);
      const yyyy = tomorrow.getFullYear();
      const mm = String(tomorrow.getMonth() + 1).padStart(2, '0');
      const dd = String(tomorrow.getDate()).padStart(2, '0');
      dateInput.min = `${yyyy}-${mm}-${dd}`;
      dateInput.value = `${yyyy}-${mm}-${dd}`;
    }

    bookingForm.addEventListener('submit', (e) => {
      e.preventDefault();
      e.stopPropagation();

      if (!bookingForm.checkValidity()) {
        bookingForm.classList.add('was-validated');
        return;
      }

      const plate = document.getElementById('licensePlate').value.trim().toUpperCase();
      const car = document.getElementById('carModel').value.trim();
      const service = document.getElementById('serviceType').value;
      const branch = document.getElementById('branchLocation').value;
      const date = document.getElementById('bookingDate').value;
      const time = document.getElementById('bookingTime').value;
      const name = document.getElementById('customerName').value.trim();
      const phone = document.getElementById('customerPhone').value.trim();

      // Populate summary modal
      if (bookingSummaryCard) {
        bookingSummaryCard.innerHTML = `
          <div class="row g-2 small">
            <div class="col-6"><strong>Biển số xe:</strong> <span class="badge bg-primary">${plate}</span></div>
            <div class="col-6"><strong>Dòng xe:</strong> ${car}</div>
            <div class="col-12"><strong>Dịch vụ:</strong> ${service}</div>
            <div class="col-12"><strong>Thời gian:</strong> ${time} - Ngày ${date}</div>
            <div class="col-12"><strong>Địa điểm:</strong> ${branch}</div>
            <div class="col-12"><strong>Khách hàng:</strong> ${name} (${phone})</div>
          </div>
        `;
      }

      // Store into localStorage for demo
      const demoBooking = { plate, car, service, branch, date, time, name, phone, createdAt: new Date().toISOString() };
      localStorage.setItem('carecar_last_booking', JSON.stringify(demoBooking));

      if (bookingModalEl && window.bootstrap) {
        const modal = new bootstrap.Modal(bookingModalEl);
        modal.show();
      }

      bookingForm.reset();
      bookingForm.classList.remove('was-validated');
    });
  }

  /* ==========================================
     3. Track Page: Live Search Simulation
     ========================================== */
  const trackSearchForm = document.getElementById('trackSearchForm');
  const trackInput = document.getElementById('trackInput');
  const trackResultBox = document.getElementById('trackResultBox');
  const resPlate = document.getElementById('resPlate');

  if (trackSearchForm && trackInput) {
    trackSearchForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const query = trackInput.value.trim().toUpperCase();
      if (!query) return;

      if (trackResultBox) {
        trackResultBox.style.opacity = '0.4';
        setTimeout(() => {
          if (resPlate) {
            resPlate.textContent = `${query} - Xe Đang Bảo Dưỡng`;
          }
          trackResultBox.style.opacity = '1';
        }, 300);
      }
    });
  }

  /* ==========================================
     4. Login & Register Form Simulation
     ========================================== */
  const loginForm = document.getElementById('loginForm');
  if (loginForm) {
    loginForm.addEventListener('submit', (e) => {
      e.preventDefault();
      if (!loginForm.checkValidity()) {
        loginForm.classList.add('was-validated');
        return;
      }
      const user = document.getElementById('username').value.trim();
      const pass = document.getElementById('password').value;

      if (user === 'admin' && pass === '123456') {
        alert('Đăng nhập Quản trị viên (Admin) thành công!');
        // In local fullstack mode, redirect to backend admin:
        // window.location.href = 'http://localhost:8080/CareCar/admin/dashboard';
        window.location.href = 'index.html';
      } else {
        alert(`Đăng nhập thành công với tài khoản: ${user}!`);
        window.location.href = 'index.html';
      }
    });
  }

  const registerForm = document.getElementById('registerForm');
  if (registerForm) {
    registerForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const pass = document.getElementById('regPassword').value;
      const confirmPass = document.getElementById('regConfirmPassword').value;
      const confirmInput = document.getElementById('regConfirmPassword');

      if (pass !== confirmPass) {
        confirmInput.setCustomValidity('Mật khẩu không khớp');
      } else {
        confirmInput.setCustomValidity('');
      }

      if (!registerForm.checkValidity()) {
        registerForm.classList.add('was-validated');
        return;
      }

      alert('Đăng ký tài khoản thành viên thành công! Vui lòng đăng nhập.');
      window.location.href = 'login.html';
    });
  }
});
