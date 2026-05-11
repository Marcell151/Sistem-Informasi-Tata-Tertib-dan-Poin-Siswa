<?php


// Start session jika belum
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}


function checkLogin() {
    if (!isset($_SESSION['user_id']) || !isset($_SESSION['role'])) {
        // Redirect root portal
        $current_path = $_SERVER['PHP_SELF'];
        $redirect_path = (strpos($current_path, '/views/') !== false) ? "../../../index.php" : "../../index.php";
        header('Location: ' . $redirect_path);
        exit;
    }
    
    $timeout = 3600; // 1 jam
    if (isset($_SESSION['login_time']) && (time() - $_SESSION['login_time'] > $timeout)) {
        session_destroy();
        // Redirect expired
        $current_path = $_SERVER['PHP_SELF'];
        $redirect_path = (strpos($current_path, '/views/') !== false) ? "../../../index.php" : "../../index.php";
        header('Location: ' . $redirect_path . '?timeout=1');
        exit;
    }
    
    // Update last activity time
    $_SESSION['login_time'] = time();
}


function checkRole($allowed_roles = []) {
    checkLogin();
    
    if (!in_array($_SESSION['role'], $allowed_roles)) {
        // Akses ditolak
        http_response_code(403);
        die("Akses Ditolak: Anda tidak memiliki hak akses ke halaman ini.");
    }
}


function requireAdmin() {
    checkRole(['Admin', 'AdminPusat', 'KepalaSekolah']);
}

/**
 * Strict Access (Admin Only)
 */
function requireAdminStrict() {
    checkRole(['Admin', 'AdminPusat']);
}


function requireGuru() {
    checkRole(['Guru']);
}


function getCurrentUser() {
    checkLogin();
    return [
        'id' => $_SESSION['user_id'],
        'username' => $_SESSION['username'],
        'nama_lengkap' => $_SESSION['nama_lengkap'],
        'role' => $_SESSION['role'],
        'login_type' => $_SESSION['login_type']
    ];
}


function isKepsek() {
    return isset($_SESSION['role']) && $_SESSION['role'] === 'KepalaSekolah';
}

function isAdmin() {
    return isset($_SESSION['role']) && in_array($_SESSION['role'], ['Admin', 'AdminPusat']);
}

function isGuru() {
    return isset($_SESSION['role']) && $_SESSION['role'] === 'Guru';
}

// Auto check login saat file di-include
checkLogin();
?>