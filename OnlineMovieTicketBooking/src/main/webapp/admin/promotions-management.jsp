<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Promotion Management Panel</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/modern-promotions.css">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="modern-ui bg-light">

    <!-- Top Navbar Placeholder -->
    <nav class="navbar navbar-expand-lg navbar-dark border-bottom" style="background: var(--text-main)">
        <div class="container-fluid px-4">
            <a class="navbar-brand fw-bold" href="#"><i class="fa-solid fa-film text-warning me-2"></i>CineBooking Admin</a>
            <div class="d-flex text-white opacity-75">
                Promotion Management System v1.0
            </div>
        </div>
    </nav>

    <div class="container-fluid py-4 px-lg-5">
        
        <!-- Header Actions -->
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h2 class="fw-bold m-0"><i class="fa-solid fa-tags text-primary me-2"></i>Promotions Dashboard</h2>
                <p class="text-muted mb-0">Create, edit, and manage discount campaigns</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/admin/promotions/analytics" class="btn btn-outline-secondary rounded-pill me-2">
                    <i class="fa-solid fa-chart-line me-2"></i>View Analytics
                </a>
                <button type="button" class="btn btn-modern px-4" data-bs-toggle="modal" data-bs-target="#promotionModal" onclick="openCreateModal()">
                    <i class="fa-solid fa-plus me-2"></i>Create Promotion
                </button>
            </div>
        </div>

        <!-- Alerts -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success alert-dismissible fade show glass-card border-success border-start border-4" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i><strong>Success!</strong> ${sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show glass-card border-danger border-start border-4" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i><strong>Error!</strong> ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <!-- Promotions Table -->
        <div class="table-responsive mt-3">
            <table class="table table-modern w-100 align-middle">
                <thead>
                    <tr>
                        <th scope="col" class="ps-3">Code / Type</th>
                        <th scope="col">Discount Value</th>
                        <th scope="col">Validity Period</th>
                        <th scope="col">Usage Limit</th>
                        <th scope="col">Min Booking Rs</th>
                        <th scope="col">Status</th>
                        <th scope="col" class="text-end pe-4">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty promotions}">
                            <tr>
                                <td colspan="7" class="text-center py-5 shadow-none bg-transparent">
                                    <h5 class="text-muted">No promotions found. Create one to get started!</h5>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="promo" items="${promotions}">
                                <tr>
                                    <td class="ps-4">
                                        <div class="fw-bold text-dark fs-5">${promo.promoCode}</div>
                                        <div class="badge bg-light text-secondary border">
                                            ${promo.promotionType} <c:if test="${promo.promotionType == 'SEASONAL'}">(${promo.seasonName})</c:if>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="fw-bold text-primary">
                                            <c:if test="${promo.promotionType == 'PERCENTAGE' || promo.promotionType == 'SEASONAL'}">${promo.discountValue}%</c:if>
                                            <c:if test="${promo.promotionType == 'FIXED'}">Rs ${promo.discountValue}</c:if>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="small">
                                            <i class="fa-regular fa-calendar text-muted me-1"></i> ${promo.startDate} <br>
                                            <i class="fa-regular fa-calendar-xmark text-muted me-1"></i> ${promo.endDate}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="progress" style="height: 6px; width: 80px; margin-bottom: 4px;">
                                            <div class="progress-bar ${promo.usageCount >= promo.usageLimit ? 'bg-danger' : 'bg-primary'}" role="progressbar" style="width: ${(promo.usageCount / promo.usageLimit) * 100}%;"></div>
                                        </div>
                                        <div class="small text-muted fw-bold">${promo.usageCount} / ${promo.usageLimit}</div>
                                    </td>
                                    <td>
                                        Rs ${promo.minimumAmount}
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${promo.active}">
                                                <span class="status-indicator status-active"></span><span class="fw-semibold text-success small">Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-indicator status-inactive"></span><span class="fw-semibold text-danger small">Inactive</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end pe-4">
                                        
                                        <!-- Actions Dropdown -->
                                        <div class="dropdown">
                                            <button class="btn btn-light btn-sm rounded-circle shadow-sm" type="button" data-bs-toggle="dropdown" aria-expanded="false" style="width: 32px; height: 32px;">
                                                <i class="fa-solid fa-ellipsis-vertical"></i>
                                            </button>
                                            <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 glass-card">
                                                <li>
                                                    <a class="dropdown-item py-2" href="#" 
                                                       onclick='openEditModal("${promo.promoCode}", "${promo.promotionType}", ${promo.discountValue}, "${promo.startDate}", "${promo.endDate}", ${promo.usageLimit}, ${promo.minimumAmount}, "${promo.promotionType == 'SEASONAL' ? promo.seasonName : ''}")'>
                                                       <i class="fa-regular fa-pen-to-square text-primary me-2"></i> Edit Promotion
                                                    </a>
                                                </li>
                                                <li>
                                                    <form action="${pageContext.request.contextPath}/admin/promotions" method="POST" class="m-0" onsubmit="return confirm('Are you sure you want to deactivate/activate this promotion?');">
                                                        <input type="hidden" name="action" value="toggle">
                                                        <input type="hidden" name="code" value="${promo.promoCode}">
                                                        <button type="submit" class="dropdown-item py-2 border-0 bg-transparent text-start w-100">
                                                            <i class="fa-solid fa-power-off ${promo.active ? 'text-warning' : 'text-success'} me-2"></i> ${promo.active ? 'Deactivate' : 'Activate'}
                                                        </button>
                                                    </form>
                                                </li>
                                                <li><hr class="dropdown-divider"></li>
                                                <li>
                                                    <form action="${pageContext.request.contextPath}/admin/promotions" method="POST" class="m-0" onsubmit="return confirm('Are you sure you want to delete this promotion?');">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="code" value="${promo.promoCode}">
                                                        <button type="submit" class="dropdown-item py-2 text-danger border-0 bg-transparent text-start w-100">
                                                            <i class="fa-regular fa-trash-can me-2"></i> Delete
                                                        </button>
                                                    </form>
                                                </li>
                                            </ul>
                                        </div>

                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>


    <!-- Create/Edit Modal -->
    <div class="modal fade" id="promotionModal" tabindex="-1" aria-labelledby="promotionModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content glass-card border-0">
          <div class="modal-header border-bottom-0">
            <h1 class="modal-title fs-4 fw-bold" id="promotionModalLabel">Create New Promotion</h1>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <form id="promotionForm" action="${pageContext.request.contextPath}/admin/promotions" method="POST">
              <div class="modal-body">
                <input type="hidden" name="action" id="formAction" value="create">
                
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold text-muted small text-uppercase">Promo Code</label>
                        <input type="text" class="form-control form-control-lg bg-light" id="promoCode" name="promoCode" required placeholder="e.g. SUMMER25">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold text-muted small text-uppercase">Promotion Type</label>
                        <select class="form-select form-select-lg bg-light" id="type" name="type" required onchange="handleTypeChange()">
                            <option value="PERCENTAGE">Percentage Discount (%)</option>
                            <option value="FIXED">Fixed Amount (Rs)</option>
                            <option value="SEASONAL">Seasonal Deal</option>
                        </select>
                    </div>

                    <div class="col-12" id="seasonalField" style="display: none;">
                        <label class="form-label fw-semibold text-muted small text-uppercase">Season / Event Name</label>
                        <input type="text" class="form-control bg-light" id="seasonName" name="seasonName" placeholder="e.g. Diwali Festival">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-semibold text-muted small text-uppercase">Discount Value</label>
                        <input type="number" class="form-control bg-light" id="discountValue" name="discountValue" step="0.01" required placeholder="e.g. 15">
                    </div>
                    
                    <div class="col-md-6">
                        <label class="form-label fw-semibold text-muted small text-uppercase">Min Booking Amount (Rs)</label>
                        <input type="number" class="form-control bg-light" id="minimumAmount" name="minimumAmount" step="1" required placeholder="e.g. 1000">
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-semibold text-muted small text-uppercase">Start Date</label>
                        <input type="date" class="form-control bg-light" id="startDate" name="startDate" required>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-semibold text-muted small text-uppercase">End Date</label>
                        <input type="date" class="form-control bg-light" id="endDate" name="endDate" required>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-semibold text-muted small text-uppercase">Max Usages</label>
                        <input type="number" class="form-control bg-light" id="usageLimit" name="usageLimit" required placeholder="e.g. 500">
                    </div>
                </div>

              </div>
              <div class="modal-footer border-top-0 pt-0">
                <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-modern px-5" id="submitBtn">Save Promotion</button>
              </div>
          </form>
        </div>
      </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function handleTypeChange() {
            var type = document.getElementById("type").value;
            var sf = document.getElementById("seasonalField");
            if(type === "SEASONAL") {
                sf.style.display = "block";
            } else {
                sf.style.display = "none";
            }
        }

        function openCreateModal() {
            document.getElementById("promotionModalLabel").innerText = "Create New Promotion";
            document.getElementById("formAction").value = "create";
            document.getElementById("promoCode").readOnly = false;
            document.getElementById("promotionForm").reset();
            handleTypeChange();
        }

        function openEditModal(code, type, value, start, end, limit, minAmt, season) {
            document.getElementById("promotionModalLabel").innerText = "Edit Promotion: " + code;
            document.getElementById("formAction").value = "update";
            
            document.getElementById("promoCode").value = code;
            document.getElementById("promoCode").readOnly = true; // Code cannot change
            
            document.getElementById("type").value = type;
            document.getElementById("discountValue").value = value;
            document.getElementById("startDate").value = start;
            document.getElementById("endDate").value = end;
            document.getElementById("usageLimit").value = limit;
            document.getElementById("minimumAmount").value = minAmt;
            
            if(type === "SEASONAL") {
                document.getElementById("seasonName").value = season;
            }
            
            handleTypeChange();
            
            var modal = new bootstrap.Modal(document.getElementById('promotionModal'));
            modal.show();
        }
    </script>
</body>
</html>
