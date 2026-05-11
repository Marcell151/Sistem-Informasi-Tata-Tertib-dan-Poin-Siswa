<?php


session_start();
require_once '../../config/database.php';
require_once '../includes/session_check.php';
require_once '../includes/sp_helper.php';

requireAdminStrict();

$action = $_POST['action'] ?? ($_GET['action'] ?? null);
$id_transaksi = $_POST['id'] ?? ($_GET['id'] ?? null);
$balasan_admin = $_POST['balasan_admin'] ?? ($_GET['alasan_admin'] ?? null);

if (!$action || !$id_transaksi) {
    $_SESSION['error_message'] = '❌ Parameter tidak valid';
    header('Location: ../views/admin/kelola_report.php');
    exit;
}

try {
    $pdo = getDBConnection();
    
    // Ambil detail transaksi
    $transaksi = fetchOne("
        SELECT 
            h.id_transaksi,
            h.id_anggota,
            h.status_revisi,
            h.alasan_revisi,
            s.nama_siswa
        FROM tb_pelanggaran_header h
        JOIN tb_anggota_kelas a ON h.id_anggota = a.id_anggota
        JOIN tb_siswa s ON a.no_induk = s.no_induk
        WHERE h.id_transaksi = :id
    ", ['id' => $id_transaksi]);
    
    if (!$transaksi) {
        throw new Exception('Transaksi tidak ditemukan');
    }
    
    if ($action === 'setujui') {
        if ($transaksi['status_revisi'] !== 'Pending') {
            throw new Exception('Report ini sudah diproses sebelumnya');
        }

        // [BARU] Simpan balasan ke semua pihak yang mengajukan report
        $fb_ortu = fetchOne("SELECT id_feedback, isi_feedback FROM tb_feedback_ortu WHERE id_transaksi = ? ORDER BY tanggal_kirim DESC LIMIT 1", [$id_transaksi]);
        
        $alasan = "";
        if ($fb_ortu) {
            $alasan .= "[WALI MURID]: " . $fb_ortu['isi_feedback'] . " ";
            executeQuery("UPDATE tb_feedback_ortu SET status_baca = 'Sudah Dibaca', balasan_admin = :balasan, waktu_balas = NOW() WHERE id_feedback = :id_fb", [
                'balasan' => $balasan_admin ?? 'Sanggahan disetujui oleh Admin Tatib.',
                'id_fb' => $fb_ortu['id_feedback']
            ]);
        }
        
        if (!empty($transaksi['alasan_revisi'])) {
            $alasan .= "[WALI KELAS]: " . $transaksi['alasan_revisi'];
            executeQuery("UPDATE tb_pelanggaran_header SET balasan_admin = :balasan, waktu_balas = NOW() WHERE id_transaksi = :id", [
                'balasan' => $balasan_admin ?? 'Laporan disetujui.',
                'id' => $id_transaksi
            ]);
        }

        if (empty($alasan)) $alasan = "Penyesuaian Data oleh Admin";
        
        executeQuery("
            UPDATE tb_pelanggaran_header 
            SET status_revisi = 'Disetujui',
                status_pelanggaran = 'Dibatalkan',
                keterangan_pembatalan = :alasan
            WHERE id_transaksi = :id
        ", [
            'alasan' => $alasan,
            'id' => $id_transaksi
        ]);

        syncTotalPoinSiswa($transaksi['id_anggota']);
        
        $_SESSION['success_message'] = "✅ Berhasil! Transaksi telah disetujui untuk dibatalkan (Soft Delete). Poin siswa telah diperbarui.";
        
    } elseif ($action === 'tolak') {
        if ($transaksi['status_revisi'] !== 'Pending') {
            throw new Exception('Report ini sudah diproses sebelumnya');
        }

        // [BARU] Simpan balasan ke semua pihak jika ada
        $fb_ortu = fetchOne("SELECT id_feedback FROM tb_feedback_ortu WHERE id_transaksi = ? ORDER BY tanggal_kirim DESC LIMIT 1", [$id_transaksi]);
        if ($fb_ortu) {
            executeQuery("UPDATE tb_feedback_ortu SET status_baca = 'Sudah Dibaca', balasan_admin = :balasan, waktu_balas = NOW() WHERE id_feedback = :id_fb", [
                'balasan' => $balasan_admin ?? 'Maaf, sanggahan Anda ditolak oleh Admin Tatib.',
                'id_fb' => $fb_ortu['id_feedback']
            ]);
        }
        
        if (!empty($transaksi['alasan_revisi'])) {
            executeQuery("UPDATE tb_pelanggaran_header SET balasan_admin = :balasan, waktu_balas = NOW() WHERE id_transaksi = :id", [
                'balasan' => $balasan_admin ?? 'Maaf, laporan Anda ditolak.',
                'id' => $id_transaksi
            ]);
        }
        
        // UPDATE STATUS DITOLAK
        executeQuery("
            UPDATE tb_pelanggaran_header 
            SET status_revisi = 'Ditolak'
            WHERE id_transaksi = :id
        ", [
            'id' => $id_transaksi
        ]);
        
        $_SESSION['success_message'] = "✅ Report untuk transaksi {$transaksi['nama_siswa']} telah ditolak.";
        
    } elseif ($action === 'reset') {
        // RESET STATUS KEMBALI KE PENDING
        executeQuery("
            UPDATE tb_pelanggaran_header 
            SET status_revisi = 'Pending',
                status_pelanggaran = 'Valid',
                keterangan_pembatalan = NULL
            WHERE id_transaksi = :id
        ", ['id' => $id_transaksi]);

        syncTotalPoinSiswa($transaksi['id_anggota']);
        
        $_SESSION['success_message'] = "🔄 Status report berhasil direset ke Pending! Transaksi telah diaktifkan kembali.";
    }
    
} catch (Exception $e) {
    $_SESSION['error_message'] = '❌ Gagal: ' . $e->getMessage();
}

header('Location: ../views/admin/kelola_report.php');
exit;
