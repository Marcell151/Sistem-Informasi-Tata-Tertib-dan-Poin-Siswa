<?php
session_start();
require_once '../../config/database.php';
require_once '../includes/session_check.php';
require_once '../includes/sp_helper.php';

requireAdminStrict();

$id_transaksi = $_GET['id'] ?? null;

if (!$id_transaksi) {
    $_SESSION['error_message'] = '❌ ID Transaksi tidak valid';
    header('Location: ../views/admin/audit_harian.php');
    exit;
}

try {
    $pdo = getDBConnection();
    
    // Ambil info transaksi
    $transaksi = fetchOne("SELECT id_anggota, status_pelanggaran FROM tb_pelanggaran_header WHERE id_transaksi = :id", ['id' => $id_transaksi]);
    
    if (!$transaksi) {
        throw new Exception('Data transaksi tidak ditemukan');
    }
    
    if ($transaksi['status_pelanggaran'] === 'Valid') {
        throw new Exception('Transaksi sudah berstatus Valid');
    }
    
    // Update status kembali ke Valid
    executeQuery("
        UPDATE tb_pelanggaran_header 
        SET status_pelanggaran = 'Valid',
            keterangan_pembatalan = NULL
        WHERE id_transaksi = :id
    ", ['id' => $id_transaksi]);
    
    // Sinkronisasi poin siswa (otomatis hitung ulang dari nol hanya yang Valid)
    syncTotalPoinSiswa($transaksi['id_anggota']);
    
    $_SESSION['success_message'] = "✅ Transaksi berhasil diaktifkan kembali! Poin siswa telah disinkronkan ulang.";
    
} catch (Exception $e) {
    $_SESSION['error_message'] = '❌ Gagal: ' . $e->getMessage();
}

header('Location: ../views/admin/audit_harian.php');
exit;
