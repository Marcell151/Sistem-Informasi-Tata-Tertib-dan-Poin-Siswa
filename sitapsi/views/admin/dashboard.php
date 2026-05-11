<?php
/**
 */

session_start();
require_once '../../../config/database.php';
require_once '../../includes/session_check.php';

// Pastikan hanya Admin yang bisa mengakses halaman ini
requireAdmin();

// INITIALIZATION
$tahun_aktif = fetchOne("
    SELECT id_tahun, nama_tahun, semester_aktif 
    FROM tb_tahun_ajaran 
    WHERE status = 'Aktif' 
    LIMIT 1
");

// Jika Tahun Ajaran belum di-setup sama sekali (Database kosong)
if (!$tahun_aktif) {
    header("Location: setup_tahun_ajaran.php");
    exit;
}
// ===================================================================================

$id_tahun = $tahun_aktif['id_tahun'];
$hari_ini = date('Y-m-d');

// QUERY METRIK

// Statistik Umum (Total Siswa Aktif, Siswa SP, dan Kandidat Reward / Poin 0)
$stats = fetchOne("
    SELECT 
        COUNT(DISTINCT a.no_induk) as total_siswa,
        COUNT(DISTINCT CASE WHEN a.status_sp_terakhir != 'Aman' THEN a.no_induk END) as siswa_sp,
        COUNT(DISTINCT CASE WHEN a.total_poin_umum = 0 THEN a.no_induk END) as kandidat_reward
    FROM tb_anggota_kelas a
    JOIN tb_siswa s ON a.no_induk = s.no_induk
    WHERE a.id_tahun = :id_tahun AND s.status_aktif = 'Aktif'
", ['id_tahun' => $id_tahun]);

// Total Transaksi (Pelanggaran) Hari Ini
$q_trans_hari_ini = fetchOne("SELECT COUNT(*) as total FROM tb_pelanggaran_header WHERE id_tahun = ? AND tanggal = ? AND status_pelanggaran = 'Valid'", [$id_tahun, $hari_ini]);
$tot_hari_ini = $q_trans_hari_ini['total'] ?? 0;

// STATISTIK SP PER KATEGORI (Silo)
$stats_sp = fetchOne("
    SELECT 
        COUNT(CASE WHEN status_sp_kelakuan != 'Aman' THEN 1 END) as sp_kelakuan,
        COUNT(CASE WHEN status_sp_kerajinan != 'Aman' THEN 1 END) as sp_kerajinan,
        COUNT(CASE WHEN status_sp_kerapian != 'Aman' THEN 1 END) as sp_kerapian
    FROM tb_anggota_kelas
    WHERE id_tahun = :id_tahun
", ['id_tahun' => $id_tahun]);

// QUERY ANALITIK

// Analitik 1: Top 5 siswa poin tertinggi
$top_siswa = fetchAll("
    SELECT 
        s.nama_siswa,
        s.no_induk,
        k.nama_kelas,
        a.total_poin_umum,
        a.status_sp_terakhir
    FROM tb_anggota_kelas a
    JOIN tb_siswa s ON a.no_induk = s.no_induk
    JOIN tb_kelas k ON a.id_kelas = k.id_kelas
    WHERE a.id_tahun = :id_tahun
    AND a.total_poin_umum > 0
    ORDER BY a.total_poin_umum DESC
    LIMIT 5
", ['id_tahun' => $id_tahun]);

// Analitik 2: Top 5 Kelas dengan Akumulasi Poin Tertinggi (Hanya yang Aktif)
$top_kelas_poin = fetchAll("
    SELECT k.nama_kelas, SUM(ak.total_poin_umum) as total_poin_kelas, COUNT(ak.id_anggota) as jml_siswa_melanggar
    FROM tb_anggota_kelas ak
    JOIN tb_kelas k ON ak.id_kelas = k.id_kelas
    WHERE ak.id_tahun = ? AND ak.total_poin_umum > 0
    GROUP BY k.id_kelas
    ORDER BY total_poin_kelas DESC
    LIMIT 5
", [$id_tahun]);

// [BARU] Analitik Khusus Kepsek: Top 5 Kelas dengan Siswa Terkena SP Terbanyak (Unique Students)
$top_kelas_sp = fetchAll("
    SELECT k.nama_kelas, COUNT(DISTINCT sp.id_anggota) as total_siswa_sp
    FROM tb_riwayat_sp sp
    JOIN tb_anggota_kelas ak ON sp.id_anggota = ak.id_anggota
    JOIN tb_kelas k ON ak.id_kelas = k.id_kelas
    WHERE ak.id_tahun = ? AND sp.status != 'Dibatalkan'
    GROUP BY k.id_kelas
    ORDER BY total_siswa_sp DESC
    LIMIT 5
", [$id_tahun]);

// Analitik 3: Transaksi Terbaru (Valid Only)
$recent_trans = fetchAll("
    SELECT ph.id_transaksi, s.nama_siswa, k.nama_kelas, g.nama_guru, ph.tanggal, ph.waktu,
           (SELECT SUM(poin_saat_itu) FROM tb_pelanggaran_detail WHERE id_transaksi = ph.id_transaksi) as total_poin
    FROM tb_pelanggaran_header ph
    JOIN tb_anggota_kelas ak ON ph.id_anggota = ak.id_anggota
    JOIN tb_siswa s ON ak.no_induk = s.no_induk
    JOIN tb_kelas k ON ak.id_kelas = k.id_kelas
    JOIN tb_guru g ON ph.id_guru = g.id_guru
    WHERE ph.id_tahun = ? AND ph.status_pelanggaran = 'Valid'
    ORDER BY ph.tanggal DESC, ph.waktu DESC, ph.id_transaksi DESC
    LIMIT 5
", [$id_tahun]);

// [PERBAIKAN] Rincian Surat SP per Kategori dari TABEL RIWAYAT SP (Data Real Surat - Exclude Dibatalkan)
$sp_detail_cat = fetchAll("
    SELECT sp.kategori_pemicu as kategori, sp.tingkat_sp as tingkat, COUNT(*) as jml
    FROM tb_riwayat_sp sp
    JOIN tb_anggota_kelas ak ON sp.id_anggota = ak.id_anggota
    WHERE ak.id_tahun = ? AND sp.status != 'Dibatalkan'
    GROUP BY sp.kategori_pemicu, sp.tingkat_sp
", [$id_tahun]);

// [PERBAIKAN] Statistik Total Surat & Menunggu Validasi (Hanya yang Aktif/Selesai)
$sp_stats_exec = fetchOne("
    SELECT 
        COUNT(*) as total_surat,
        COUNT(DISTINCT sp.id_anggota) as total_siswa,
        COUNT(CASE WHEN sp.status = 'Pending' THEN 1 END) as total_pending
    FROM tb_riwayat_sp sp
    JOIN tb_anggota_kelas ak ON sp.id_anggota = ak.id_anggota
    WHERE ak.id_tahun = ? AND sp.status != 'Dibatalkan'
", [$id_tahun]);

// KHUSUS KEPSEK
if (isKepsek()) {
    // Analitik 4: Distribusi Pelanggaran per Kategori (Hanya yang Valid)
    $cat_dist = fetchAll("
        SELECT jp.id_kategori, SUM(d.poin_saat_itu) as total_poin
        FROM tb_pelanggaran_header h
        JOIN tb_pelanggaran_detail d ON h.id_transaksi = d.id_transaksi
        JOIN tb_jenis_pelanggaran jp ON d.id_jenis = jp.id_jenis
        WHERE h.id_tahun = ? AND h.status_pelanggaran = 'Valid'
        GROUP BY jp.id_kategori
    ", [$id_tahun]);
    
    $map_cat = [1 => 0, 2 => 0, 3 => 0];
    foreach($cat_dist as $c) $map_cat[$c['id_kategori']] = (int)$c['total_poin'];
    $total_all_poin = array_sum($map_cat) ?: 1;

    // Analitik 6: Sebaran Siswa yang Kena SP per Jenjang Kelas (Berdasarkan SP Aktif - Unique Students)
    $sp_by_grade = fetchAll("
        SELECT k.tingkat, COUNT(DISTINCT sp.id_anggota) as jml
        FROM tb_riwayat_sp sp
        JOIN tb_anggota_kelas ak ON sp.id_anggota = ak.id_anggota
        JOIN tb_kelas k ON ak.id_kelas = k.id_kelas
        WHERE ak.id_tahun = ? AND sp.status != 'Dibatalkan'
        GROUP BY k.tingkat
        ORDER BY k.tingkat ASC
    ", [$id_tahun]);

    // Analitik 8: Tren Bulanan (Valid Only)
    $monthly_trend = fetchOne("
        SELECT 
            COUNT(CASE WHEN MONTH(tanggal) = MONTH(CURRENT_DATE) THEN 1 END) as bulan_ini,
            COUNT(CASE WHEN MONTH(tanggal) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH) THEN 1 END) as bulan_lalu
        FROM tb_pelanggaran_header
        WHERE id_tahun = ? AND status_pelanggaran = 'Valid'
    ", [$id_tahun]);

} else {
    // ADMIN TATIB
    
    $audit_queue = fetchOne("
        SELECT COUNT(*) as total 
        FROM tb_pelanggaran_header 
        WHERE id_tahun = ? AND status_pelanggaran = 'Valid'
        AND (tanggal > CURRENT_DATE - INTERVAL 1 DAY OR (tanggal = CURRENT_DATE AND waktu <= CURRENT_TIME))
    ", [$id_tahun]);

    // [FITUR BARU] Radar Deteksi Dini: Siswa yang hampir kena SP (Jarak < 50 Poin)
    $sp_radar = fetchAll("
        SELECT s.nama_siswa, k.nama_kelas, ak.id_anggota,
               ak.poin_kelakuan, ak.poin_kerajinan, ak.poin_kerapian,
               ak.status_sp_kelakuan, ak.status_sp_kerajinan, ak.status_sp_kerapian
        FROM tb_anggota_kelas ak
        JOIN tb_siswa s ON ak.no_induk = s.no_induk
        JOIN tb_kelas k ON ak.id_kelas = k.id_kelas
        WHERE ak.id_tahun = ? AND s.status_aktif = 'Aktif'
        AND (
            (ak.poin_kelakuan BETWEEN 200 AND 249 AND ak.status_sp_kelakuan = 'Aman') OR
            (ak.poin_kelakuan BETWEEN 700 AND 749 AND ak.status_sp_kelakuan = 'SP1') OR
            (ak.poin_kerajinan BETWEEN 25 AND 74 AND ak.status_sp_kerajinan = 'Aman') OR
            (ak.poin_kerajinan BETWEEN 250 AND 299 AND ak.status_sp_kerajinan = 'SP1') OR
            (ak.poin_kerapian BETWEEN 50 AND 99 AND ak.status_sp_kerapian = 'Aman') OR
            (ak.poin_kerapian BETWEEN 250 AND 299 AND ak.status_sp_kerapian = 'SP1')
        )
        LIMIT 5
    ", [$id_tahun]);
}
// =========================================================================


$success = $_SESSION['success_message'] ?? '';
$error = $_SESSION['error_message'] ?? '';
unset($_SESSION['success_message'], $_SESSION['error_message']);

// --- UI CONFIG VARIABLES ---
$card_class = "bg-white border border-[#E2E8F0] rounded-xl shadow-sm p-6";
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - SITAPSI</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-[#F8FAFC]">

<div class="flex h-screen overflow-hidden">
    
    <?php include '../../includes/sidebar_admin.php'; ?>

    <div class="flex-1 overflow-auto lg:ml-64">
        
        <!-- HEADER -->
        <div class="bg-white border-b border-[#E2E8F0] px-6 py-4 sticky top-0 z-30 flex justify-between items-center">
            <div>
                <h1 class="text-2xl font-extrabold text-slate-800 tracking-tight">Dashboard Kedisiplinan</h1>
                <p class="text-sm font-medium text-slate-500">Tahun Ajaran: <?= htmlspecialchars($tahun_aktif['nama_tahun']) ?> (<?= htmlspecialchars($tahun_aktif['semester_aktif']) ?>)</p>
            </div>
            <div class="hidden sm:flex items-center gap-3 bg-slate-50 px-4 py-2 rounded-lg border border-slate-200">
                <div class="w-8 h-8 rounded-full bg-[#000080] text-white flex items-center justify-center font-bold text-sm">
                    <?= substr($_SESSION['nama_lengkap'] ?? 'A', 0, 1) ?>
                </div>
                <div class="text-right">
                    <p class="text-xs font-bold text-slate-800 leading-tight"><?= htmlspecialchars($_SESSION['nama_lengkap'] ?? 'Admin') ?></p>
                    <p class="text-[10px] font-bold text-slate-400 uppercase"><?= htmlspecialchars($_SESSION['role'] ?? '') ?></p>
                </div>
            </div>
        </div>

        <!-- CONTENT -->
        <div class="p-6 space-y-6 max-w-7xl mx-auto">

            <?php if ($success): ?>
            <div class="bg-emerald-50 border border-emerald-200 text-emerald-700 px-4 py-3 rounded-lg shadow-sm flex items-center">
                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
                <p class="font-medium text-sm"><?= htmlspecialchars($success) ?></p>
            </div>
            <?php endif; ?>

            <?php if ($error): ?>
            <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg shadow-sm flex items-center">
                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                <p class="font-medium text-sm"><?= htmlspecialchars($error) ?></p>
            </div>
            <?php endif; ?>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                
                <div class="<?= $card_class ?> flex flex-col justify-between hover:shadow-md transition-shadow group">
                    <div class="flex items-center justify-between mb-4">
                        <div class="w-12 h-12 rounded-xl bg-blue-50 border border-blue-100 flex items-center justify-center group-hover:scale-110 transition-transform">
                            <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                        </div>
                        <div class="text-right">
                            <p class="text-xs font-bold text-slate-500 uppercase tracking-wider mb-1">Total Siswa Aktif</p>
                            <p class="text-3xl font-extrabold text-slate-800"><?= number_format($stats['total_siswa'] ?? 0) ?></p>
                        </div>
                    </div>
                </div>

                <div class="<?= $card_class ?> flex flex-col justify-between hover:shadow-md transition-shadow group">
                    <div class="flex items-center justify-between mb-4">
                        <div class="w-12 h-12 rounded-xl bg-red-50 border border-red-100 flex items-center justify-center group-hover:scale-110 transition-transform">
                            <svg class="w-6 h-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path><line x1="12" y1="11" x2="12" y2="17"></line><line x1="9" y1="14" x2="15" y2="14"></line></svg>
                        </div>
                        <div class="text-right">
                            <p class="text-xs font-bold text-slate-500 uppercase tracking-wider mb-1" title="Total seluruh surat SP yang diterbitkan (bukan jumlah siswa)">Total Surat SP</p>
                            <p class="text-3xl font-extrabold text-red-600">
                                <?= number_format($sp_stats_exec['total_surat'] ?? 0) ?>
                            </p>
                        </div>
                    </div>
                    <div class="pt-4 border-t border-slate-100 flex justify-between items-center">
                        <p class="text-xs font-bold text-slate-500 uppercase tracking-wide">Status SP Aktif</p>
                        <div class="flex gap-2">
                            <?php if (($sp_stats_exec['total_pending'] ?? 0) > 0): ?>
                            <span class="px-2.5 py-1 bg-amber-50 text-amber-600 rounded-lg text-[11px] font-black border border-amber-200 animate-pulse">
                                <?= $sp_stats_exec['total_pending'] ?> PENDING
                            </span>
                            <?php endif; ?>
                            <span class="px-2.5 py-1 bg-red-50 text-red-600 rounded-lg text-[11px] font-black border border-red-200">
                                <?= number_format($sp_stats_exec['total_siswa'] ?? 0) ?> SISWA
                            </span>
                        </div>
                    </div>
                </div>

                <div class="<?= $card_class ?> flex flex-col justify-between hover:shadow-md transition-shadow group">
                    <div class="flex items-center justify-between mb-4">
                        <div class="w-12 h-12 rounded-xl bg-emerald-50 border border-emerald-100 flex items-center justify-center group-hover:scale-110 transition-transform">
                            <svg class="w-6 h-6 text-emerald-600" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                        </div>
                        <div class="text-right">
                            <p class="text-xs font-bold text-slate-500 uppercase tracking-wider mb-1" title="Siswa yang belum pernah melanggar sama sekali (Poin 0)">Siswa Tanpa Pelanggaran</p>
                            <p class="text-3xl font-extrabold text-emerald-600"><?= number_format($stats['kandidat_reward'] ?? 0) ?></p>
                        </div>
                    </div>
                </div>

                <div class="<?= $card_class ?> flex flex-col justify-between hover:shadow-md transition-shadow group">
                    <div class="flex items-center justify-between mb-4">
                        <div class="w-12 h-12 rounded-xl bg-indigo-50 border border-indigo-100 flex items-center justify-center group-hover:scale-110 transition-transform">
                            <svg class="w-6 h-6 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                        </div>
                        <div class="text-right">
                            <p class="text-xs font-bold text-slate-500 uppercase tracking-wider mb-1"><?= isKepsek() ? 'Tren Bulan Ini' : 'Transaksi Baru (24j)' ?></p>
                            <p class="text-3xl font-extrabold text-indigo-600"><?= isKepsek() ? ($monthly_trend['bulan_ini'] ?? 0) : ($audit_queue['total'] ?? 0) ?></p>
                        </div>
                    </div>
                    <?php if (isKepsek()): ?>
                        <div class="pt-2 border-t border-slate-100">
                            <p class="text-[10px] font-bold text-slate-400">Bulan Lalu: <span class="text-slate-600"><?= $monthly_trend['bulan_lalu'] ?? 0 ?> kasus</span></p>
                        </div>
                    <?php else: ?>
                        <div class="pt-2 border-t border-slate-100">
                            <p class="text-[10px] font-bold text-slate-400 uppercase tracking-tight">Audit Integritas Input</p>
                        </div>
                    <?php endif; ?>
                </div>

            </div>

            <!-- SECTION RINCIAN SP PER KATEGORI (FULL WIDTH AGAR RAPI) -->
            <div class="mb-6 bg-white border border-[#E2E8F0] rounded-xl shadow-sm p-6">
                <div class="flex items-center justify-between mb-6">
                    <h3 class="font-black text-slate-800 text-sm uppercase tracking-wider flex items-center">
                        <svg class="w-5 h-5 mr-3 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5.586a1 1 0 0 1 .707.293l5.414 5.414a1 1 0 0 1 .293.707V19a2 2 0 0 1-2 2z"></path></svg>
                        Rincian Surat Peringatan per Bidang
                    </h3>
                    <span class="text-xs font-bold text-slate-400 italic bg-slate-50 px-3 py-1 rounded-full border border-slate-100">Sumber Data: Riwayat SP Tahun <?= $tahun_aktif['nama_tahun'] ?></span>
                </div>
                
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <?php 
                    if(empty($sp_detail_cat)): ?>
                        <div class="col-span-3 py-12 text-center bg-slate-50/50 rounded-2xl border-2 border-dashed border-slate-200">
                            <p class="text-sm text-slate-400 italic">Belum ada rincian SP yang diterbitkan.</p>
                        </div>
                    <?php else: 
                        $grouped_sp = [];
                        foreach($sp_detail_cat as $s) {
                            $cat_key = ucfirst(strtolower($s['kategori']));
                            $grouped_sp[$cat_key][] = $s;
                        }
                        
                        $all_cats = ['Kelakuan', 'Kerajinan', 'Kerapian'];
                        foreach($all_cats as $cat):
                            $items = $grouped_sp[$cat] ?? [];
                            $c_color = $cat === 'Kelakuan' ? 'text-red-800' : ($cat === 'Kerajinan' ? 'text-indigo-800' : 'text-amber-800');
                            $c_bg = $cat === 'Kelakuan' ? 'bg-red-50' : ($cat === 'Kerajinan' ? 'bg-indigo-50' : 'bg-amber-50');
                            $c_border = $cat === 'Kelakuan' ? 'border-red-200' : ($cat === 'Kerajinan' ? 'border-indigo-200' : 'border-amber-200');
                    ?>
                    <div class="rounded-2xl border-2 <?= $c_border ?> overflow-hidden bg-white shadow-sm hover:shadow-md transition-all duration-300">
                        <div class="<?= $c_bg ?> px-5 py-3 border-b-2 <?= $c_border ?> flex justify-between items-center">
                            <p class="text-sm font-black uppercase tracking-widest <?= $c_color ?>"><?= $cat ?></p>
                        </div>
                        <div class="p-5 grid grid-cols-3 gap-4 bg-white">
                            <?php 
                            $levels = ['SP1', 'SP2', 'SP3'];
                            $map_levels = [];
                            foreach($items as $it) $map_levels[$it['tingkat']] = $it['jml'];
                            foreach($levels as $lvl): 
                                $count = $map_levels[$lvl] ?? 0;
                            ?>
                            <div class="text-center p-4 rounded-2xl transition-all <?= $count > 0 ? 'bg-slate-50 ring-2 ring-slate-100 shadow-inner' : 'opacity-30' ?>">
                                <p class="text-xs font-bold text-slate-400 uppercase mb-2"><?= $lvl ?></p>
                                <p class="text-xl font-black <?= $count > 0 ? 'text-slate-900' : 'text-slate-200' ?>"><?= $count ?></p>
                            </div>
                            <?php endforeach; ?>
                        </div>
                    </div>
                    <?php endforeach; ?>
                    <?php endif; ?>
                </div>
            </div>
            <?php if (isKepsek()): ?>
            <!-- VIEW KHUSUS KEPALA SEKOLAH (STRATEGIC ANALYTICS) -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
                <!-- Card Distribusi Masalah -->
                <div class="bg-white border border-[#E2E8F0] rounded-xl shadow-sm p-6">
                    <div class="flex items-center justify-between mb-6">
                        <h3 class="font-extrabold text-slate-800 flex items-center text-sm">
                            <svg class="w-5 h-5 mr-2 text-[#000080]" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2"><path d="M11 3.055A9.001 9.001 0 1020.945 13H11V3.055z"></path><path d="M20.488 9H15V3.512A9.025 9.025 0 0120.488 9z"></path></svg>
                            Fokus Masalah Kedisiplinan
                        </h3>
                    </div>
                    
                    <div class="space-y-7">
                        <?php 
                        $cats_info = [
                            ['label' => 'Kelakuan', 'poin' => $map_cat[1], 'color' => 'bg-red-500'],
                            ['label' => 'Kerajinan', 'poin' => $map_cat[2], 'color' => 'bg-blue-600'],
                            ['label' => 'Kerapian', 'poin' => $map_cat[3], 'color' => 'bg-amber-500']
                        ];
                        foreach($cats_info as $c): 
                            $percent = ($c['poin'] / $total_all_poin) * 100;
                        ?>
                        <div>
                            <div class="flex justify-between items-center mb-2">
                                <span class="text-sm font-black text-slate-700 uppercase tracking-wide"><?= $c['label'] ?></span>
                                <span class="text-sm font-black text-slate-900 bg-slate-100 px-3 py-1 rounded-lg border border-slate-200"><?= number_format($c['poin']) ?> <span class="text-[10px] text-slate-400 font-bold ml-1">POIN</span></span>
                            </div>
                            <div class="w-full h-3 bg-slate-100 rounded-full overflow-hidden shadow-inner">
                                <div class="h-full <?= $c['color'] ?> rounded-full shadow-lg" style="width: <?= $percent ?>%"></div>
                            </div>
                            <div class="flex justify-between mt-1.5">
                                <p class="text-xs text-slate-400 font-bold uppercase tracking-tighter">Beban Masalah</p>
                                <p class="text-xs font-black text-slate-600"><?= number_format($percent, 1) ?>%</p>
                            </div>
                        </div>
                        <?php endforeach; ?>
                    </div>
                </div>

                <!-- Card Analisis Angkatan -->
                <div class="bg-white border border-[#E2E8F0] rounded-xl shadow-sm p-6 flex flex-col">
                    <h3 class="font-extrabold text-slate-800 mb-6 flex items-center text-sm">
                        <svg class="w-5 h-5 mr-2 text-[#000080]" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2"><path d="M19 21V5a2 2 0 0 0-2-2H7a2 2 0 0 0-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v5m-4 0h4"></path></svg>
                        Analisis SP per Jenjang
                    </h3>
                    <div class="space-y-3 flex-1">
                        <?php if(empty($sp_by_grade)): ?>
                            <p class="text-sm text-slate-400 text-center py-12 font-medium italic">Jenjang terpantau aman.</p>
                        <?php else: ?>
                            <?php foreach($sp_by_grade as $grade): ?>
                            <div class="p-3 bg-slate-50 border border-slate-100 rounded-xl flex items-center justify-between group hover:border-[#000080] transition-colors">
                                <div class="flex items-center gap-2.5">
                                    <div class="w-8 h-8 rounded-lg bg-[#000080] text-white flex items-center justify-center text-xs font-black">
                                        <?= $grade['tingkat'] ?>
                                    </div>
                                    <p class="text-xs font-black text-slate-700">Kelas <?= $grade['tingkat'] ?></p>
                                </div>
                                <div class="text-right">
                                    <p class="text-lg font-black text-[#000080]"><?= $grade['jml'] ?></p>
                                    <p class="text-[10px] font-black text-slate-400 uppercase">Siswa SP</p>
                                </div>
                            </div>
                            <?php endforeach; ?>
                        <?php endif; ?>
                    </div>
                </div>

            </div>
            <?php endif; ?>

            <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
                
                <div class="bg-white border border-[#E2E8F0] rounded-xl shadow-sm overflow-hidden">
                    <div class="p-4 border-b border-[#E2E8F0] bg-slate-50/50 flex justify-between items-center">
                        <h3 class="font-bold text-slate-800 text-sm flex items-center">
                            <svg class="w-4 h-4 mr-2 text-rose-500" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"></path></svg>
                            Top 5 Poin Siswa Tertinggi
                        </h3>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left text-sm whitespace-nowrap">
                            <thead class="bg-white text-[10px] font-extrabold text-slate-500 uppercase tracking-wider border-b border-[#E2E8F0]">
                                <tr>
                                    <th class="p-4">Rank</th>
                                    <th class="p-4">Siswa & Kelas</th>
                                    <th class="p-4 text-center">Status SP</th>
                                    <th class="p-4 text-right">Poin</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-[#E2E8F0]">
                                <?php if (empty($top_siswa)): ?>
                                <tr>
                                    <td colspan="4" class="p-8 text-center text-slate-400 font-medium">Belum ada data poin siswa</td>
                                </tr>
                                <?php else: ?>
                                <?php foreach ($top_siswa as $idx => $siswa): ?>
                                <tr class="hover:bg-slate-50/50 transition-colors">
                                    <td class="p-4 text-center">
                                        <span class="inline-flex items-center justify-center w-7 h-7 rounded-lg font-bold text-xs shadow-sm border <?= $idx === 0 ? 'bg-amber-100 text-amber-700 border-amber-200' : ($idx === 1 ? 'bg-slate-100 text-slate-600 border-slate-200' : ($idx === 2 ? 'bg-orange-100 text-orange-700 border-orange-200' : 'bg-white text-slate-500 border-[#E2E8F0]')) ?>">
                                            #<?= $idx + 1 ?>
                                        </span>
                                    </td>
                                    <td class="p-4">
                                        <p class="font-bold text-slate-800 text-[13px]"><?= htmlspecialchars($siswa['nama_siswa']) ?></p>
                                        <p class="text-[10px] font-medium text-slate-400"><?= htmlspecialchars($siswa['nama_kelas']) ?></p>
                                    </td>
                                    <td class="p-4 text-center">
                                        <?php if($siswa['status_sp_terakhir'] === 'Aman'): ?>
                                            <span class="px-2 py-1 rounded-md text-[10px] font-bold bg-emerald-50 text-emerald-600 border border-emerald-200">Aman</span>
                                        <?php else: ?>
                                            <span class="px-2 py-1 rounded-md text-[10px] font-bold bg-red-50 text-red-600 border border-red-200"><?= $siswa['status_sp_terakhir'] ?></span>
                                        <?php endif; ?>
                                    </td>
                                    <td class="p-4 text-right font-extrabold text-rose-600">
                                        <?= $siswa['total_poin_umum'] ?>
                                    </td>
                                </tr>
                                <?php endforeach; ?>
                                <?php endif; ?>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="bg-white border border-[#E2E8F0] rounded-xl shadow-sm overflow-hidden">
                    <div class="p-4 border-b border-[#E2E8F0] bg-slate-50/50 flex justify-between items-center">
                        <h3 class="font-bold text-slate-800 text-sm flex items-center">
                            <svg class="w-4 h-4 mr-2 text-amber-500" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2"><rect x="3" y="3" width="7" height="9"></rect><rect x="14" y="3" width="7" height="5"></rect><rect x="14" y="12" width="7" height="9"></rect><rect x="3" y="16" width="7" height="5"></rect></svg>
                            <?= isKepsek() ? 'Top 5 Kelas Terbanyak SP' : 'Audit Alert: Siswa Kena SP Terbaru' ?>
                        </h3>
                    </div>
                    <?php if (isKepsek()): ?>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left text-sm whitespace-nowrap">
                            <thead class="bg-white text-[10px] font-extrabold text-slate-500 uppercase tracking-wider border-b border-[#E2E8F0]">
                                <tr>
                                    <th class="p-4">Nama Kelas</th>
                                    <th class="p-4 text-center">Analisis Pelanggaran</th>
                                    <th class="p-4 text-right">Total Surat SP</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-[#E2E8F0]">
                                <?php if (empty($top_kelas_sp)): ?>
                                <tr>
                                    <td colspan="3" class="p-8 text-center text-slate-400 font-medium">Belum ada riwayat SP aktif</td>
                                </tr>
                                <?php else: ?>
                                <?php foreach ($top_kelas_sp as $tk): ?>
                                <tr class="hover:bg-slate-50/50 transition-colors">
                                    <td class="p-4 font-bold text-slate-800 text-[13px]">
                                        <?= htmlspecialchars($tk['nama_kelas']) ?>
                                    </td>
                                    <td class="p-4 text-center">
                                        <div class="flex items-center justify-center gap-1.5">
                                            <span class="w-2 h-2 rounded-full bg-red-500"></span>
                                            <p class="text-[10px] font-bold text-slate-500 uppercase">Perlu Pembinaan</p>
                                        </div>
                                    </td>
                                    <td class="p-4 text-right font-extrabold text-red-600">
                                        <?= number_format($tk['total_siswa_sp']) ?> <span class="text-[9px] text-slate-400 ml-1">SISWA</span>
                                    </td>
                                </tr>
                                <?php endforeach; ?>
                                <?php endif; ?>
                            </tbody>
                        </table>
                    </div>
                    <?php else: ?>
                    <!-- PANEL RADAR DETEKSI DINI SP (KHUSUS ADMIN) -->
                    <div class="p-5 space-y-4">
                        <div class="mb-4">
                            <h4 class="text-xs font-black text-amber-700 uppercase tracking-widest flex items-center">
                                <span class="flex h-2 w-2 rounded-full bg-amber-500 mr-2 animate-ping"></span>
                                Radar Peringatan Dini: Ambang Batas SP
                            </h4>
                            <p class="text-[11px] text-slate-400 font-medium">Siswa yang poinnya mendekati batas SP berikutnya (Jarak < 50 Poin). Segera lakukan pembinaan preventif.</p>
                        </div>
                        <?php if (empty($sp_radar)): ?>
                            <div class="py-12 text-center bg-slate-50/50 rounded-2xl border-2 border-dashed border-slate-200">
                                <p class="text-sm text-slate-400 italic">Belum ada siswa di radar pantauan.</p>
                            </div>
                        <?php else: ?>
                            <?php foreach ($sp_radar as $r): 
                                // Logika penentuan target SP & sisa poin
                                $target_sp = "";
                                $kategori = "";
                                $sisa = 0;
                                
                                if($r['poin_kelakuan'] >= 200 && $r['poin_kelakuan'] < 250) { $target_sp = "SP1"; $kategori = "Kelakuan"; $sisa = 250 - $r['poin_kelakuan']; }
                                elseif($r['poin_kelakuan'] >= 700 && $r['poin_kelakuan'] < 750) { $target_sp = "SP2"; $kategori = "Kelakuan"; $sisa = 750 - $r['poin_kelakuan']; }
                                elseif($r['poin_kerajinan'] >= 25 && $r['poin_kerajinan'] < 75) { $target_sp = "SP1"; $kategori = "Kerajinan"; $sisa = 75 - $r['poin_kerajinan']; }
                                elseif($r['poin_kerajinan'] >= 250 && $r['poin_kerajinan'] < 300) { $target_sp = "SP2"; $kategori = "Kerajinan"; $sisa = 300 - $r['poin_kerajinan']; }
                                elseif($r['poin_kerapian'] >= 50 && $r['poin_kerapian'] < 100) { $target_sp = "SP1"; $kategori = "Kerapian"; $sisa = 100 - $r['poin_kerapian']; }
                                elseif($r['poin_kerapian'] >= 250 && $r['poin_kerapian'] < 300) { $target_sp = "SP2"; $kategori = "Kerapian"; $sisa = 300 - $r['poin_kerapian']; }
                            ?>
                            <div class="p-4 bg-amber-50/50 border-2 border-amber-100 rounded-2xl flex items-center justify-between shadow-sm group hover:border-amber-300 transition-all">
                                <div class="flex items-center gap-5">
                                    <div class="w-14 h-14 rounded-2xl bg-amber-500 text-white flex flex-col items-center justify-center shadow-md ring-4 ring-amber-100">
                                        <p class="text-[10px] font-bold leading-none mb-1 opacity-80">TARGET</p>
                                        <p class="text-sm font-black leading-none"><?= $target_sp ?></p>
                                    </div>
                                    <div>
                                        <p class="text-base font-black text-slate-800 tracking-tight"><?= htmlspecialchars($r['nama_siswa']) ?></p>
                                        <div class="flex items-center gap-2 mt-0.5">
                                            <span class="px-2 py-0.5 bg-white border border-amber-200 rounded text-[10px] font-black text-amber-700 uppercase"><?= $kategori ?></span>
                                            <p class="text-[11px] font-bold text-slate-400"><?= htmlspecialchars($r['nama_kelas']) ?></p>
                                        </div>
                                    </div>
                                </div>
                                <div class="text-right">
                                    <p class="text-lg font-black text-amber-600 leading-none">±<?= $sisa ?></p>
                                    <p class="text-[9px] font-bold text-slate-400 uppercase mt-1">Poin Lagi</p>
                                </div>
                            </div>
                            <?php endforeach; ?>
                        <?php endif; ?>
                    </div>
                    <?php endif; ?>
                </div>
            </div>

            <!-- JS / SCRIPTS -->
            <?php if (!isKepsek()): ?>
            <!-- VIEW KHUSUS ADMIN (RECENT LOGS WITH AUDIT ACTION) -->
            <div class="bg-white border border-[#E2E8F0] rounded-xl shadow-sm overflow-hidden">
                <div class="p-4 border-b border-[#E2E8F0] bg-slate-50/50 flex justify-between items-center">
                    <h3 class="font-bold text-slate-800 text-sm flex items-center">
                        <svg class="w-4 h-4 mr-2 text-indigo-500" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2"><polyline points="12 8 12 12 14 14"></polyline><circle cx="12" cy="12" r="10"></circle></svg>
                        Feed Monitoring Pelanggaran (Audit Integritas)
                    </h3>
                    <a href="audit_harian.php" class="text-[11px] font-bold text-[#000080] hover:underline uppercase tracking-wider">Buka Log Global</a>
                </div>
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-sm whitespace-nowrap">
                        <thead class="bg-white text-[10px] font-extrabold text-slate-500 uppercase tracking-wider border-b border-[#E2E8F0]">
                            <tr>
                                <th class="p-4">Waktu</th>
                                <th class="p-4">Siswa</th>
                                <th class="p-4">Pelapor</th>
                                <th class="p-4 text-center">Poin</th>
                                <th class="p-4 text-right">Audit</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-[#E2E8F0]">
                            <?php if (empty($recent_trans)): ?>
                            <tr>
                                <td colspan="5" class="p-8 text-center text-slate-400 font-medium">Belum ada riwayat pelanggaran.</td>
                            </tr>
                            <?php else: ?>
                            <?php foreach ($recent_trans as $rt): ?>
                            <tr class="hover:bg-slate-50/50 transition-colors">
                                <td class="p-4">
                                    <div class="font-bold text-slate-800 text-[12px]"><?= date('d M', strtotime($rt['tanggal'])) ?></div>
                                    <div class="text-[10px] font-medium text-slate-400"><?= date('H:i', strtotime($rt['waktu'])) ?></div>
                                </td>
                                <td class="p-4">
                                    <p class="font-bold text-slate-800 text-[13px]"><?= htmlspecialchars($rt['nama_siswa']) ?></p>
                                    <p class="text-[10px] font-medium text-slate-400"><?= htmlspecialchars($rt['nama_kelas']) ?></p>
                                </td>
                                <td class="p-4 text-slate-600 font-medium text-[13px]">
                                    <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-slate-100 text-slate-700">
                                        <?= htmlspecialchars($rt['nama_guru']) ?>
                                    </span>
                                </td>
                                <td class="p-4 text-center font-extrabold text-rose-600">
                                    +<?= $rt['total_poin'] ?? 0 ?>
                                </td>
                                <td class="p-4 text-right">
                                    <a href="edit_pelanggaran.php?id=<?= $rt['id_transaksi'] ?>" class="inline-flex items-center justify-center w-8 h-8 rounded-lg bg-slate-100 text-slate-500 hover:bg-[#000080] hover:text-white transition-colors" title="Audit / Edit Data">
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                    </a>
                                </td>
                            </tr>
                            <?php endforeach; ?>
                            <?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>
            <?php endif; ?>

        </div>
    </div>
</div>

</body>
</html>