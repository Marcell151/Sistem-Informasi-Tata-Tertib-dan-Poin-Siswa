<?php


session_start();
require_once '../../config/database.php';
require_once '../includes/session_check.php';
require_once '../includes/sp_helper.php';

requireAdminStrict();

$id_transaksi = $_GET['id'] ?? null;
$redirect = $_GET['redirect'] ?? 'audit';
$id_anggota_redirect = $_GET['anggota'] ?? null;
$alasan_custom = $_GET['alasan'] ?? 'Dibatalkan secara manual oleh Admin melalui menu Audit Harian.';

if (!$id_transaksi) {
    $_SESSION['error_message'] = '❌ ID transaksi tidak valid';
    header('Location: ../views/admin/audit_harian.php');
    exit;
}

try {
    $pdo = getDBConnection();
    
    // 1. Ambil id_anggota terlebih dahulu
    $transaksi = fetchOne("SELECT id_anggota FROM tb_pelanggaran_header WHERE id_transaksi = :id", ['id' => $id_transaksi]);
    
    if (!$transaksi) {
        throw new Exception('Transaksi tidak ditemukan');
    }
    
    $id_anggota = $transaksi['id_anggota'];
    
    // 2. REVISI POIN 3: SOFT DELETE (Hanya Update Status)
    // Jangan menghapus data agar Story tetap ada (Audit Trail)
    executeQuery("
        UPDATE tb_pelanggaran_header 
        SET status_pelanggaran = 'Dibatalkan',
            keterangan_pembatalan = :alasan
        WHERE id_transaksi = :id
    ", [
        'id' => $id_transaksi,
        'alasan' => $alasan_custom
    ]);
    
    // 3. SINKRONISASI POIN OTOMATIS (Fungsi ini sudah termasuk recalculate SP)
    syncTotalPoinSiswa($id_anggota);
    
    $_SESSION['success_message'] = "✅ Transaksi berhasil dibatalkan (Soft Delete)! Jejak sejarah tetap tersimpan & poin telah disinkronkan kembali.";
    
} catch (Exception $e) {
    $_SESSION['error_message'] = '❌ Gagal membatalkan transaksi: ' . $e->getMessage();
}

// Redirect
if ($redirect === 'monitoring' && $id_anggota_redirect) {
    header("Location: ../views/admin/detail_siswa.php?id=$id_anggota_redirect");
} else {
    header('Location: ../views/admin/audit_harian.php');
}
exit;
?>