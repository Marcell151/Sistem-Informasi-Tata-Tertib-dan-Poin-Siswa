<?php
session_start();
require_once '../../config/database.php';
require_once '../includes/session_check.php';

requireAdminStrict();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: ../views/data_guru.php');
    exit;
}

try {
    $nama_guru = trim($_POST['nama_guru']);
    $nip = trim($_POST['nip']);
    $pin_validasi = trim($_POST['pin_validasi']);
    $is_walikelas = $_POST['is_walikelas'] ?? 'Tidak';
    $id_kelas = ($is_walikelas === 'Ya' && !empty($_POST['id_kelas'])) ? (int)$_POST['id_kelas'] : null;
    $status = $_POST['status'] ?? 'Aktif';

    // Handle Mapel Array (REVISI POIN 2)
    $mapel_array = $_POST['mapel'] ?? [];
    $mapel_string = !empty($mapel_array) ? implode(', ', $mapel_array) : '-';
    
    if (empty($nama_guru) || empty($pin_validasi)) {
        throw new Exception('Nama guru dan PIN wajib diisi');
    }
    
    if (strlen($pin_validasi) !== 6 || !ctype_digit($pin_validasi)) {
        throw new Exception('PIN harus 6 digit angka');
    }
    
    // Cek apakah kelas sudah punya wali kelas
    if ($is_walikelas === 'Ya' && $id_kelas) {
        $cek_wali = fetchOne("SELECT id_guru, nama_guru FROM tb_guru WHERE id_kelas = :id_kelas AND id_guru != 0", ['id_kelas' => $id_kelas]);
        if ($cek_wali) {
            throw new Exception("Kelas ini sudah memiliki wali kelas: {$cek_wali['nama_guru']}");
        }
    }
    
    executeQuery("
        INSERT INTO tb_guru (nama_guru, nip, id_kelas, is_walikelas, pin_validasi, status, mapel) 
        VALUES (:nama_guru, :nip, :id_kelas, :is_walikelas, :pin_validasi, :status, :mapel)
    ", [
        'nama_guru' => $nama_guru,
        'nip' => $nip ?: null,
        'id_kelas' => $id_kelas,
        'is_walikelas' => $is_walikelas,
        'pin_validasi' => $pin_validasi,
        'status' => $status,
        'mapel' => $mapel_string
    ]);
    
    $_SESSION['success_message'] = '✅ Guru berhasil ditambahkan!';
    
} catch (Exception $e) {
    $_SESSION['error_message'] = '❌ Gagal: ' . $e->getMessage();
}

header('Location: ../views/data_guru.php');
exit;
?>
