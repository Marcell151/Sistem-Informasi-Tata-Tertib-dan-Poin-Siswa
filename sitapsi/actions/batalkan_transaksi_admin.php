<?php
session_start();
require_once '../../config/database.php';
require_once '../includes/session_check.php';
require_once '../includes/sp_helper.php';

requireAdminStrict();

$id_transaksi = $_GET['id'] ?? null;
$id_feedback = $_GET['id_feedback'] ?? null;
$alasan = $_GET['alasan'] ?? 'Dibatalkan oleh Admin (Sanggahan Ortu)';

if (!$id_transaksi) {
    die("Parameter tidak valid");
}

try {
    $pdo = getDBConnection();
    
    // 1. Ambil data transaksi
    $transaksi = fetchOne("SELECT id_anggota FROM tb_pelanggaran_header WHERE id_transaksi = :id", ['id' => $id_transaksi]);
    if (!$transaksi) throw new Exception("Transaksi tidak ditemukan");

    // 2. Update status pelanggaran (Soft Delete)
    executeQuery("
        UPDATE tb_pelanggaran_header 
        SET status_pelanggaran = 'Dibatalkan',
            keterangan_pembatalan = :alasan
        WHERE id_transaksi = :id
    ", [
        'alasan' => $alasan,
        'id' => $id_transaksi
    ]);

    // 3. Jika ada feedback, tandai sebagai sudah diproses/dibaca
    if ($id_feedback) {
        executeQuery("
            UPDATE tb_feedback_ortu 
            SET status_baca = 'Sudah Dibaca', 
                balasan_admin = 'Sanggahan Diterima. Data pelanggaran telah dibatalkan.',
                tanggal_balasan = NOW()
            WHERE id_feedback = :id
        ", ['id' => $id_feedback]);
    }

    // 4. Sinkronisasi Poin (Fungsi ini akan memicu recalculate SP juga)
    syncTotalPoinSiswa($transaksi['id_anggota']);
    
    $_SESSION['success_message'] = "✅ Sanggahan Diterima! Pelanggaran berhasil dibatalkan dan poin siswa telah disinkronkan kembali.";
} catch (Exception $e) {
    $_SESSION['error_message'] = "❌ Gagal: " . $e->getMessage();
}

// Redirect kembali ke halaman sebelumnya
$redirect = $_SERVER['HTTP_REFERER'] ?? '../views/admin/manajemen_sp.php';
header('Location: ' . $redirect);
exit;
?>
