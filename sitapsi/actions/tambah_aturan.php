<?php
session_start();
require_once '../../config/database.php';
require_once '../includes/session_check.php';

requireAdminStrict();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: ../views/admin/manajemen_aturan.php');
    exit;
}

try {
    $id_kategori = $_POST['id_kategori'];
    $sub_kategori = $_POST['sub_kategori'];
    $nama_pelanggaran = trim($_POST['nama_pelanggaran']);
    $poin_default = (int)$_POST['poin_default'];
    $sanksi_default_array = $_POST['sanksi_default'] ?? [];
    
    // Logika 1: Checkbox ke String
    $sanksi_default = implode(',', $sanksi_default_array);

    // Logika 2: Sub Kategori Baru (Auto Numbering)
    if ($sub_kategori === 'NEW_SUB') {
        $nama_sub_baru = trim($_POST['sub_kategori_baru']);
        
        // Cari urutan tertinggi saat ini di kategori tersebut
        $latest = fetchOne("
            SELECT sub_kategori 
            FROM tb_jenis_pelanggaran 
            WHERE id_kategori = :id 
            AND sub_kategori REGEXP '^[0-9]+'
            ORDER BY CAST(SUBSTRING_INDEX(sub_kategori, '.', 1) AS UNSIGNED) DESC 
            LIMIT 1
        ", ['id' => $id_kategori]);
        
        $next_num = 1;
        if ($latest) {
            $current_num = (int)explode('.', $latest['sub_kategori'])[0];
            $next_num = $current_num + 1;
        }
        
        $prefix = str_pad($next_num, 2, '0', STR_PAD_LEFT);
        $sub_kategori = $prefix . '. ' . $nama_sub_baru;
    }
    
    if (empty($id_kategori) || empty($sub_kategori) || empty($nama_pelanggaran) || $poin_default <= 0) {
        throw new Exception('Data wajib belum lengkap');
    }
    
    executeQuery("
        INSERT INTO tb_jenis_pelanggaran (id_kategori, sub_kategori, nama_pelanggaran, poin_default, sanksi_default)
        VALUES (:id_kategori, :sub_kategori, :nama_pelanggaran, :poin_default, :sanksi_default)
    ", [
        'id_kategori' => $id_kategori,
        'sub_kategori' => $sub_kategori,
        'nama_pelanggaran' => $nama_pelanggaran,
        'poin_default' => $poin_default,
        'sanksi_default' => $sanksi_default
    ]);
    
    $_SESSION['success_message'] = '✅ Jenis pelanggaran berhasil ditambahkan!';
    
} catch (Exception $e) {
    $_SESSION['error_message'] = '❌ Gagal menambah: ' . $e->getMessage();
}

header('Location: ../views/admin/manajemen_aturan.php');
exit;
?>
