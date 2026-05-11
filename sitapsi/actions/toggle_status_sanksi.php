<?php
session_start();
require_once '../../config/database.php';
require_once '../includes/session_check.php';

requireAdminStrict();

$id = $_GET['id'] ?? null;
$status = $_GET['status'] ?? null;

if (!$id || !$status) {
    $_SESSION['error_message'] = '❌ Parameter tidak lengkap';
    header('Location: ../views/admin/manajemen_aturan.php?tab=sanksi');
    exit;
}

try {
    $new_status = ($status === 'Aktif') ? 'Non-Aktif' : 'Aktif';
    executeQuery("UPDATE tb_sanksi_ref SET status = :status WHERE id_sanksi_ref = :id", [
        'status' => $new_status,
        'id' => $id
    ]);
    
    $_SESSION['success_message'] = '✅ Status sanksi berhasil diubah menjadi ' . $new_status;
} catch (Exception $e) {
    $_SESSION['error_message'] = '❌ Gagal mengubah status: ' . $e->getMessage();
}

header('Location: ../views/admin/manajemen_aturan.php?tab=sanksi');
exit;
?>

