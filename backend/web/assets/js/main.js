/**
 * CareCar - Main Frontend & Backend Scripts
 */
document.addEventListener('DOMContentLoaded', () => {
  // Context path detection for backend JSP
  const contextPath = window.CARECAR_CONTEXT_PATH || (window.location.pathname.startsWith('/CareCar') ? '/CareCar' : '');

  // 1. Auto-dismiss alerts after 5 seconds
  const alerts = document.querySelectorAll('.alert:not(.alert-permanent)');
  alerts.forEach(alert => {
    setTimeout(() => {
      alert.style.transition = 'opacity 0.5s ease';
      alert.style.opacity = '0';
      setTimeout(() => alert.remove(), 500);
    }, 5000);
  });

  // 2. Table search filter (Used in Backend Admin)
  const tableSearchInput = document.getElementById('tableSearchInput');
  if (tableSearchInput) {
    tableSearchInput.addEventListener('keyup', (e) => {
      const filter = e.target.value.toLowerCase();
      const rows = document.querySelectorAll('tbody tr');
      rows.forEach(row => {
        const text = row.textContent.toLowerCase();
        row.style.display = text.includes(filter) ? '' : 'none';
      });
    });
  }

  // 3. Print Invoice Trigger (Used in Backend)
  const printBtn = document.getElementById('printInvoiceBtn');
  if (printBtn) {
    printBtn.addEventListener('click', () => {
      window.print();
    });
  }

  // 4. Services Page: Search & Category Filter
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
      btn.addEventListener('click', () => {
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

  // 5. Landing Page: Interactive Cost Estimator
  const calcBrand = document.getElementById('calcBrand');
  const calcSegment = document.getElementById('calcSegment');
  const calcMileage = document.getElementById('calcMileage');
  const calcPriceValue = document.getElementById('calcPriceValue');
  const calcPackageName = document.getElementById('calcPackageName');
  const calcTimeEstimate = document.getElementById('calcTimeEstimate');
  const calcChecklist = document.getElementById('calcChecklist');
  const btnBookFromCalc = document.getElementById('btnBookFromCalc');

  const updateCostEstimate = () => {
    if (!calcBrand || !calcSegment || !calcMileage) return;

    const brand = calcBrand.value;
    const segment = calcSegment.value;
    const mileage = parseInt(calcMileage.value, 10);

    let basePrice = 250000;
    let packageName = 'Bảo Dưỡng Cấp 1 (Tiêu Chuẩn)';
    let timeEstimate = '45 - 60 phút';
    let checklist = [
      'Thay dầu máy cao cấp động cơ chính hãng',
      'Kiểm tra toàn diện 35 hạng mục an toàn gầm, lái, phanh',
      'Vệ sinh lọc gió động cơ & lọc gió điều hòa',
      'Bổ sung nước làm mát, nước rửa kính & dầu trợ lực',
      'Quét lỗi hệ thống điện tử toàn xe bằng máy OBD2'
    ];

    if (mileage === 10000) {
      basePrice = 450000;
      packageName = 'Bảo Dưỡng Cấp 2 (10.000 KM)';
      timeEstimate = '60 - 90 phút';
      checklist.push('Thay lọc dầu (lọc nhớt) chính hãng');
      checklist.push('Đảo lốp & kiểm tra độ mòn hoa lốp');
    } else if (mileage === 20000) {
      basePrice = 950000;
      packageName = 'Bảo Dưỡng Cấp 3 (20.000 KM - Trung Bình)';
      timeEstimate = '90 - 120 phút';
      checklist.push('Thay lọc dầu, thay lọc gió động cơ & điều hòa mới');
      checklist.push('Vệ sinh & bảo dưỡng bảo trì hệ thống phanh 4 bánh');
      checklist.push('Cân chỉnh góc đặt bánh xe 3D Hunter');
    } else if (mileage >= 40000) {
      basePrice = 1850000;
      packageName = 'Bảo Dưỡng Cấp 4 (40.000 KM - Lớn / Toàn Diện)';
      timeEstimate = '120 - 180 phút';
      checklist.push('Thay toàn bộ dầu phanh, dầu trợ lực, dầu hộp số');
      checklist.push('Vệ sinh kim phun, họng hút & buồng đốt công nghệ cao');
      checklist.push('Thay bugi đánh lửa & kiểm tra dây curoa tổng');
      checklist.push('Bảo hành kỹ thuật toàn diện 12 tháng');
    }

    let factor = 1.0;
    if (segment === 'SUV') factor = 1.25;
    if (segment === 'LUXURY') factor = 1.75;
    if (brand === 'MERCEDES' || brand === 'BMW' || brand === 'PORSCHE') factor = 2.0;

    const estimatedTotal = Math.round((basePrice * factor) / 10000) * 10000;

    if (calcPriceValue) {
      calcPriceValue.textContent = estimatedTotal.toLocaleString('vi-VN') + ' ₫';
    }
    if (calcPackageName) {
      calcPackageName.textContent = packageName;
    }
    if (calcTimeEstimate) {
      calcTimeEstimate.textContent = `Thời gian thực hiện ước tính: ~${timeEstimate}`;
    }
    if (calcChecklist) {
      calcChecklist.innerHTML = checklist.map(item => `
        <li><i class="fa-solid fa-circle-check"></i> <span>${item}</span></li>
      `).join('');
    }
    if (btnBookFromCalc) {
      const bookTarget = contextPath ? `${contextPath}/booking` : 'booking.html';
      btnBookFromCalc.href = `${bookTarget}?service=${encodeURIComponent(packageName)}&brand=${encodeURIComponent(brand)}`;
    }
  };

  if (calcBrand && calcSegment && calcMileage) {
    calcBrand.addEventListener('change', updateCostEstimate);
    calcSegment.addEventListener('change', updateCostEstimate);
    calcMileage.addEventListener('change', updateCostEstimate);
    updateCostEstimate();
  }

  // 6. Floating Scroll-To-Top Button
  const btnScrollTop = document.getElementById('btnScrollTop');
  if (btnScrollTop) {
    window.addEventListener('scroll', () => {
      if (window.scrollY > 350) {
        btnScrollTop.classList.add('show');
      } else {
        btnScrollTop.classList.remove('show');
      }
    });

    btnScrollTop.addEventListener('click', () => {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    });
  }

  // 7. Sticky Navbar Shadow on Scroll (Luôn cố định trên cùng, đổ bóng êm khi cuộn)
  const mainNavbar = document.getElementById('mainNavbar');
  if (mainNavbar) {
    window.addEventListener('scroll', () => {
      const currentScrollY = window.pageYOffset || document.documentElement.scrollTop;
      if (currentScrollY > 20) {
        mainNavbar.classList.add('navbar-scrolled');
      } else {
        mainNavbar.classList.remove('navbar-scrolled');
      }
    }, { passive: true });
  }
});
