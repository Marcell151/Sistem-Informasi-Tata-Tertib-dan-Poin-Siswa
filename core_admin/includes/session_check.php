<?php
/**
 * PORTAL SEKOLAH - Session Security Check (Core)
 */

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

function checkLogin() {
    if (!isset($_SESSION['user_id']) || !isset($_SESSION['role'])) {
        // Deteksi kedalaman folder untuk redirect ke index portal utama (sitapsi2 root)
        $current_path = $_SERVER['PHP_SELF'];
        $redirect_path = (strpos($current_path, '/views/') !== false || strpos($current_path, '/actions/') !== false) ? "../../index.php" : "../index.php";
        header('Location: ' . $redirect_path);
        exit;
    }
    
    $timeout = 2 * 60 * 60; 
    if (isset($_SESSION['login_time']) && (time() - $_SESSION['login_time'] > $timeout)) {
        session_destroy();
        $current_path = $_SERVER['PHP_SELF'];
        $redirect_path = (strpos($current_path, '/views/') !== false || strpos($current_path, '/actions/') !== false) ? "../../index.php" : "../index.php";
        header('Location: ' . $redirect_path . '?timeout=1');
        exit;
    }
    $_SESSION['login_time'] = time();
}

function checkRole($allowed_roles = []) {
    checkLogin();
    if (!in_array($_SESSION['role'], $allowed_roles)) {
        http_response_code(403);
        die("Akses Ditolak: Anda tidak memiliki hak akses ke halaman ini.");
    }
}

/**
 * DISESUAIKAN: Hanya Role 'Admin' (Master) yang boleh akses
 */
function requireAdminPusat() {
    checkRole(['AdminPusat']);
}

/**
 * Strict Access (Admin Only) - Mencegah Kepsek akses file CRUD
 */
function requireAdminStrict() {
    checkRole(['Admin', 'AdminPusat']);
}

/**
 * DISESUAIKAN: Admin Utama & Admin Tatib boleh akses modul Tatib
 */
function requireAdmin() {
    checkRole(['Admin', 'AdminPusat', 'KepalaSekolah']);
}

function requireGuru() {
    checkRole(['Guru']);
}

function getCurrentUser() {
    checkLogin();
    return [
        'id' => $_SESSION['user_id'],
        'username' => $_SESSION['username'] ?? '',
        'nama_lengkap' => $_SESSION['nama_lengkap'],
        'role' => $_SESSION['role'],
        'login_type' => $_SESSION['login_type'] ?? ''
    ];
}

/**
 * DISESUAIKAN: Cek apakah user termasuk kategori admin manapun
 */
function isAdmin() {
    return isset($_SESSION['role']) && in_array($_SESSION['role'], ['Admin', 'AdminTatib']);
}

function isGuru() {
    return isset($_SESSION['role']) && $_SESSION['role'] === 'Guru';
}

function isKepsek() {
    return isset($_SESSION['role']) && $_SESSION['role'] === 'KepalaSekolah';
}

checkLogin();
?>