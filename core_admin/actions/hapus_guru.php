<?php
session_start();
require_once '../../config/database.php';
require_once '../includes/session_check.php';

requireAdminStrict();

$id_guru = $_GET['id'] ?? null;

if (!$id_guru) {
    $_SESSION['error_message'] = '❌ ID guru tidak valid';
    header('Location: ../views/data_guru.php');
    exit;
}

try {
    // Cek apakah guru pernah input pelanggaran
    $cek_transaksi = fetchOne("
        SELECT COUNT(*) as total 
        FROM tb_pelanggaran_header 
        WHERE id_guru = :id
    ", ['id' => $id_guru]);
    
    if ($cek_transaksi['total'] > 0) {
        // Abaikan throw exception, langsung kita update saja.
    }
    
    // Soft Delete: Ganti status jadi Non-Aktif (Jangan dihapus pakai DELETE FROM)
    executeQuery("UPDATE tb_guru SET status = 'Non-Aktif' WHERE id_guru = :id", ['id' => $id_guru]);
    
    $_SESSION['success_message'] = '✅ Guru berhasil di non-aktifkan / diarsipkan!';
    
} catch (Exception $e) {
    $_SESSION['error_message'] = '❌ Gagal: ' . $e->getMessage();
}

header('Location: ../views/data_guru.php');
exit;
?>
