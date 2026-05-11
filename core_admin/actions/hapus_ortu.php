<?php
session_start();
require_once '../../config/database.php';
require_once '../includes/session_check.php';

requireAdminStrict();

$id_ortu = $_GET['id'] ?? null;

if ($id_ortu) {
    try {
        $pdo = getDBConnection();
        $pdo->beginTransaction();

        // 1. Kosongkan relasi di anak (JANGAN DIKOSONGKAN agar riwayat ortu tetap ada)
        // executeQuery("UPDATE tb_siswa SET id_ortu = NULL WHERE id_ortu = ?", [$id_ortu]);

        // 2. Soft Hapus akun orang tua (Non-aktifkan login ortu)
        executeQuery("UPDATE tb_orang_tua SET is_active = 0 WHERE id_ortu = ?", [$id_ortu]);

        $pdo->commit();
        $_SESSION['success_message'] = "✅ Data Wali Murid berhasil dinonaktifkan. Akun tidak akan bisa login portal.";

    } catch (Exception $e) {
        if (isset($pdo) && $pdo->inTransaction()) {
            $pdo->rollBack();
        }
        $_SESSION['error_message'] = "❌ Gagal menghapus: " . $e->getMessage();
    }
}

header("Location: ../views/data_ortu.php");
exit;
