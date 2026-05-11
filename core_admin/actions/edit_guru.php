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
    $id_guru = (int)$_POST['id_guru'];
    $nama_guru = trim($_POST['nama_guru']);
    $nip = trim($_POST['nip']);
    $pin_validasi = trim($_POST['pin_validasi']);
    $is_walikelas = $_POST['is_walikelas'] ?? 'Tidak';
    $id_kelas = ($is_walikelas === 'Ya' && !empty($_POST['id_kelas'])) ? (int)$_POST['id_kelas'] : null;
    $status = $_POST['status'];

    // Handle Mapel Array (REVISI POIN 2)
    $mapel_array = $_POST['mapel'] ?? [];
    $mapel_string = !empty($mapel_array) ? implode(', ', $mapel_array) : '-';
    
    if (empty($nama_guru) || empty($pin_validasi)) {
        throw new Exception('Nama guru dan PIN wajib diisi');
    }
    
    if (strlen($pin_validasi) !== 6 || !ctype_digit($pin_validasi)) {
        throw new Exception('PIN harus 6 digit angka');
    }
    
    // Cek apakah kelas sudah punya wali kelas lain
    if ($is_walikelas === 'Ya' && $id_kelas) {
        $cek_wali = fetchOne("
            SELECT id_guru, nama_guru 
            FROM tb_guru 
            WHERE id_kelas = :id_kelas 
            AND id_guru != :id_guru
        ", [
            'id_kelas' => $id_kelas,
            'id_guru' => $id_guru
        ]);
        
        if ($cek_wali) {
            throw new Exception("Kelas ini sudah memiliki wali kelas: {$cek_wali['nama_guru']}");
        }
    }
    
    executeQuery("
        UPDATE tb_guru 
        SET nama_guru = :nama_guru, 
            nip = :nip, 
            id_kelas = :id_kelas, 
            is_walikelas = :is_walikelas,
            pin_validasi = :pin_validasi, 
            status = :status,
            mapel = :mapel
        WHERE id_guru = :id_guru
    ", [
        'nama_guru' => $nama_guru,
        'nip' => $nip ?: null,
        'id_kelas' => $id_kelas,
        'is_walikelas' => $is_walikelas,
        'pin_validasi' => $pin_validasi,
        'status' => $status,
        'mapel' => $mapel_string,
        'id_guru' => $id_guru
    ]);
    
    $_SESSION['success_message'] = '✅ Data guru berhasil diupdate!';
    
} catch (Exception $e) {
    $_SESSION['error_message'] = '❌ Gagal: ' . $e->getMessage();
}

header('Location: ../views/data_guru.php');
exit;
?>
