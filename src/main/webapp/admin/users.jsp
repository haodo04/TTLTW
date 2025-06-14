<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.11.5/css/jquery.dataTables.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <!-- DataTables Buttons CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.dataTables.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <!-- DataTables Buttons JavaScript -->
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.print.min.js"></script>
    <style> .sidebar {
        height: 100vh;
        position: fixed;
        top: 0;
        left: 0;
        width: 250px;
        background-color: #343a40;
        color: white;
        padding: 20px 10px;
    }

    .sidebar a {
        color: white;
        text-decoration: none;
        display: block;
        padding: 10px;
        margin-bottom: 5px;
    }

    .sidebar a:hover {
        background-color: #495057;
        border-radius: 5px;
    }

    .content {
        margin-left: 260px; /* Sidebar width + margin */
        padding: 20px;
    }
    </style>

</head>
<body>
<!-- Sidebar -->
<%@ include file="/admin/sidebar.jsp" %>
<div class="content">
    <div class="card mb-4">
        <div class="card-header bg-success text-white" style="background: #e7621b !important;">
            <h4>Người dùng</h4>
        </div>

        <div class="card-body">
            <table id="users" class="table table-bordered display">
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                    Thêm người dùng
                </button>
                <div style="padding-bottom: 10px">
                    <c:if test="${not empty message}">
                        <div class="alert alert-success">
                                ${message}
                        </div>
                    </c:if>
                </div>
                <thead>
                <tr>
                    <th>Mã người dùng</th>
                    <th>Tên đăng nhập</th>
                    <th>Tên đầy đủ</th>
                    <th>Email</th>
                    <th>Số điện thoại</th>
                    <th>Trạng thái</th>
                    <th>Quyền</th>
                    <th>Hành Động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="u" items="${users}">
                <tr>
                    <td>${u.id}</td>
                    <td>${u.username}</td>
                    <td>${u.fullName}</td>
                    <td>${u.email}</td>
                    <td>${u.phone}</td>
                    <td>${u.status}</td>
                    <td>
                    <c:forEach var="role" items="${u.roles}">
                        ${role.name}
                    </c:forEach>
                    </td>
                    <td>
                        <button class="btn btn-info btn-sm" data-bs-toggle="modal"
                                data-bs-target="#viewEditUserModal" data-user-id="${u.id}">
                            <i class="fas fa-eye"></i>
                        </button>
                        <button class="btn btn-danger btn-sm" data-bs-toggle="modal"
                                data-bs-target="#deleteUsersModal" data-user-id="${u.id}">
                            <i class="fas fa-trash-alt"></i>
                        </button>
                        <button class="btn btn-warning btn-sm change-password-btn"
                                data-bs-toggle="modal" data-bs-target="#changePasswordModal"
                                data-user-id="${u.id}">
                            <i class="fas fa-key"></i>
                        </button>
                    </td>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <%@ include file="/admin/rolesAndPermission.jsp" %>


    <div class="modal fade" id="deleteUsersModal" tabindex="-1" aria-labelledby="deleteUsersModalLabel"
         aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteArtistModalLabel">Xác nhận xóa</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form >
                    <div class="modal-body">
                        <p>Bạn có chắc chắn muốn xóa người dùng này?</p>
                        <input type="hidden" id="userIdToDelete" name="userId">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-danger">Xóa</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!--  view and edit -->
    <div class="modal fade" id="viewEditUserModal" tabindex="-1" aria-labelledby="userDetailModalLabel"
         aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="userDetailModalLabel">Thông Tin Chi Tiết Người Dùng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="messageE" class="error"></div>
                    <form id="userDetailForm">
                        <div class="row mb-3">
                            <input type="hidden" id="editUserId" name="id" value="">
                            <div class="col-md-6">
                                <label for="changUsername" class="form-label">Tên đăng nhập <span style="color: red;">*</span></label>
                                <input type="text" class="form-control" id="changUsername" name="username">
                                <div class="error" id="changUsernameError"></div>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="changeName" class="form-label">Tên Đầy Đủ <span style="color: red;">*</span></label>
                                <input type="text" class="form-control" id="changeName" name="fullName" required>
                                <div class="error" id="changeNameError"></div>
                            </div>
                            <div class="col-md-6">
                                <label for="changeEmail" class="form-label">Email <span style="color: red;">*</span></label>
                                <input type="email" class="form-control" id="changeEmail" name="email" required>
                                <div class="error" id="changeEmailError"></div>
                            </div>
                            <div class="col-md-6">
                                <label for="address" class="form-label">Địa chỉ</label>
                                <input type="text" class="form-control" id="address" name="address">
                            </div>
                        </div>
                        <div class="row mb-3">

                            <div class="col-md-6">
                                <label class="form-label">Available Roles</label>
                                <div id="availableRoles" class="role-list scrollable">
                                    <c:forEach var="r" items="${roles}">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" name="rolesIds"
                                                   id="new_role_${r.id}" value="${r.id}">
                                            <label class="form-check-label" for="new_role_${r.id}">
                                                    ${r.name} (ID: ${r.id})
                                            </label>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="changePhone" class="form-label">Số Điện Thoại</label>
                                <input type="tel" class="form-control" id="changePhone" name="phone" pattern="[0-9]{10}">
                                <div class="error" id="changePhoneError"></div>
                            </div>
                            <div class="col-md-6">
                                <label for="status" class="form-label">Trạng Thái</label>
                                <select class="form-control" id="status" name="status">
                                    <option value="Hoạt động">Hoạt động</option>
                                    <option value="Chưa kích hoạt">Chưa kích hoạt</option>
                                    <option value="Bị khóa">Bị khóa</option>
                                    <option value="Chờ xóa">Chờ xóa</option>
                                </select>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" form="userDetailForm" class="btn btn-primary">Lưu Thay Đổi</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Đổi Mật Khẩu -->
    <div class="modal fade" id="changePasswordModal" tabindex="-1" aria-labelledby="changePasswordModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <form id="changePasswordForm">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="changePasswordModalLabel">Đổi Mật Khẩu</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="changeUserId" name="userId">
                        <div class="mb-3">
                            <label for="newPassword" class="form-label">Mật khẩu mới</label>
                            <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                        </div>
                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">Nhập lại mật khẩu</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                            <div class="error" id="confirmPasswordE"></div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary">Xác nhận</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <!-- add người dùng-->


    <!-- Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1" aria-labelledby="registerModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="registerModalLabel">Thêm người dùng mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- Original Form -->
                    <form id="addUserForm">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="registerName" class="form-label">Họ và Tên <span style="color: red;">*</span></label>
                                <input type="text" class="form-control" id="registerName" name="fullName" placeholder="Nhập họ và tên của bạn">
                                <div class="error" id="fullNameError"></div>
                            </div>
                            <div class="col-md-6">
                                <label for="registerUsername" class="form-label">Tên đăng nhập <span style="color: red;">*</span></label>
                                <input type="text" class="form-control" id="registerUsername" name="username" placeholder="Nhập tên đăng nhập">
                                <div class="error" id="usernamergError"></div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="registerPhone" class="form-label">Số điện thoại</label>
                                <input type="text" class="form-control" id="registerPhone" name="phone" placeholder="Nhập số điện thoại">
                                <div class="error" id="phoneError"></div>
                            </div>
                            <div class="col-md-6">
                                <label for="registerEmail" class="form-label">Email <span style="color: red;">*</span></label>
                                <input type="email" class="form-control" id="registerEmail" name="email" placeholder="Nhập email của bạn">
                                <div class="error" id="emailError"></div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="registerAddress" class="form-label">Địa chỉ</label>
                                <input type="text" class="form-control" id="registerAddress" name="address" placeholder="Nhập địa chỉ của bạn">
                                <div class="error" id="addressError"></div>
                            </div>
                            <div class="col-md-6">
                                <label for="registerPassword" class="form-label">Mật khẩu <span style="color: red;">*</span></label>
                                <input type="password" class="form-control" id="registerPassword" name="password" placeholder="Tạo mật khẩu">
                                <div class="error" id="passwordrgError"></div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="ConfirmRegisterPassword" class="form-label">Nhập lại mật khẩu <span style="color: red;">*</span></label>
                                <input type="password" class="form-control" id="confirmRegisterPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu">
                                <div class="error" id="confirmPasswordError"></div>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-success w-100 login-btn">Đăng Ký</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <div class="card mb-4">
        <div class="card-header bg-success text-white" style="background: #e7621b !important;">
            <h4>Các tài khoản đã xóa</h4>
        </div>

        <div class="card-body">
            <table id="usersIdDelete" class="table table-bordered display">
                <div style="padding-bottom: 10px">
                    <c:if test="${not empty message}">
                        <div class="alert alert-success">
                                ${message}
                        </div>
                    </c:if>
                </div>
                <thead>
                <tr>
                    <th>Mã người dùng</th>
                    <th>Tên đăng nhập</th>
                    <th>Tên đầy đủ</th>
                    <th>Email</th>
                    <th>Số điện thoại</th>
                    <th>Trạng thái</th>
                    <th>quyền</th>
                    <th>Hành Động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="u" items="${uDelete}">
                <tr>
                    <td>${u.id}</td>
                    <td>${u.username}</td>
                    <td>${u.fullName}</td>
                    <td>${u.email}</td>
                    <td>${u.phone}</td>
                    <td>${u.status}</td>
                    <td>
                        <c:forEach var="role" items="${u.roles}">
                            ${role.name}
                        </c:forEach>
                    </td>
                    <td>
                        <button class="btn btn-success btn-sm restore-user-btn"
                                data-user-id="${u.id}">
                            <i class="fas fa-undo"></i> Khôi phục
                        </button>
                    </td>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>


</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    $(document).ready(function () {
        $('#users').DataTable({
            dom: '<"d-flex justify-content-between align-items-center"lfB>rtip',
            buttons: [
                { extend: 'copy', title: 'Danh sách người dùng' },
                { extend: 'csv', title: 'Danh sách người dùng' },
                { extend: 'excel', title: 'Danh sách người dùng' },
                { extend: 'pdf', title: 'Danh sách người dùng' },
                { extend: 'print', title: 'Danh sách người dùng' }
            ]
        });
        $('#usersIdDelete').DataTable({
        });
    });


    $(document).on('click', '[data-bs-target="#deleteUsersModal"]', function () {
        let userId = $(this).data('user-id');
        $('#userIdToDelete').val(userId);
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/assets/js/checkSession.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin/user.js"></script>

</body>
</html>
