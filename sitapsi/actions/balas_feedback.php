<?php
session_start();
require_once '../../config/database.php';
require_once '../includes/session_check.php';

requireAdminStrict();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: ../views/admin/manajemen_sp.php');
    exit;
}

try {
    $id_feedback = $_POST['id_feedback'];
    $balasan_admin = trim($_POST['balasan_admin']);
    
    if (empty($id_feedback) || empty($balasan_admin)) {
        throw new Exception('Data tidak lengkap');
    }
    
    executeQuery("
        UPDATE tb_feedback_ortu 
        SET balasan_admin = :balasan,
            waktu_balas = NOW(),
            status_baca = 'Sudah Dibaca'
        WHERE id_feedback = :id
    ", [
        'balasan' => $balasan_admin,
        'id' => $id_feedback
    ]);
    
    $_SESSION['success_message'] = '✅ Balasan berhasil dikirim ke Orang Tua!';
    
} catch (Exception $e) {
    $_SESSION['error_message'] = '❌ Gagal mengirim balasan: ' . $e->getMessage();
}

header('Location: ../views/admin/manajemen_sp.php');
exit;
?>
