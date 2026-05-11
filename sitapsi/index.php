<?php


session_start();

// Cek apakah user sudah login
if (isset($_SESSION['user_id']) && isset($_SESSION['role'])) {
    // Redirect ke dashboard sesuai role
    if ($_SESSION['role'] === 'Admin' || $_SESSION['role'] === 'AdminPusat' || $_SESSION['role'] === 'KepalaSekolah') {
        header('Location: views/admin/dashboard.php');
    } else {
        header('Location: views/guru/input_pelanggaran.php');
    }
} else {
    // Redirect ke halaman login portal utama
    header('Location: ../index.php');
}

exit;
?>