<?php
session_start();
require_once '../../config/database.php'; // Panggil config

// Validasi akses Ortu
if ($_SERVER['REQUEST_METHOD'] !== 'POST' || !isset($_SESSION['role']) || $_SESSION['role'] !== 'Ortu') {
    header("Location: ../../ortu/dashboard.php");
    exit;
}

$id_ortu = $_POST['id_ortu'] ?? '';
$no_induk = $_POST['no_induk'] ?? '';
$id_sp = !empty($_POST['id_sp']) ? $_POST['id_sp'] : null;
$id_transaksi = !empty($_POST['id_transaksi']) ? $_POST['id_transaksi'] : null;
$isi_feedback = $_POST['isi_feedback'] ?? '';

// Fallback URL
$redirect_url = $_SERVER['HTTP_REFERER'] ?? "../../ortu/tatib/detail_anak.php?induk=" . urlencode($no_induk);

// Cek form kosong
if (empty($id_ortu) || (empty($id_sp) && empty($id_transaksi)) || empty(trim($isi_feedback))) {
    $_SESSION['feedback_error'] = "Gagal mengirim pesan. Pastikan semua kolom terisi.";
    header("Location: " . $redirect_url);
    exit;
}

try {
    $isi_bersih = htmlspecialchars(trim($isi_feedback), ENT_QUOTES, 'UTF-8');

    // MENGGUNAKAN FUNGSI executeQuery() BAWAAN ANDA
    // REVISI POIN 3: Ditambahkan kolom id_transaksi (Soft Delete Audit Trail)
    executeQuery("
        INSERT INTO tb_feedback_ortu 
        (id_ortu, id_sp, id_transaksi, isi_feedback, status_baca) 
        VALUES (?, ?, ?, ?, 'Belum Dibaca')
    ", [$id_ortu, $id_sp, $id_transaksi, $isi_bersih]);

    // [BARU] Unifikasi ke Kelola Report: Tandai transaksi sebagai Pending Revisi agar muncul di panel Admin
    if ($id_transaksi) {
        executeQuery("UPDATE tb_pelanggaran_header SET status_revisi = 'Pending' WHERE id_transaksi = ?", [$id_transaksi]);
    }

    $_SESSION['feedback_success'] = "Pesan sanggahan Anda berhasil dikirim ke Admin Kedisiplinan. Akan segera diverifikasi.";
    header("Location: " . $redirect_url);
    exit;

} catch (Exception $e) {
    $_SESSION['feedback_error'] = "Terjadi kesalahan sistem: " . $e->getMessage();
    header("Location: " . $redirect_url);
    exit;
}
?>