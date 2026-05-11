<?php
/**
 * PORTAL SEKOLAH - Arsip Global Super-App
 * Modul Tatib: Analitik Rekam Jejak Siswa (Read-Only)
 */

session_start();
require_once '../../config/database.php';
require_once '../includes/session_check.php';

requireAdmin();

$id_tahun = $_GET['tahun'] ?? null;
$tab_aktif = $_GET['tab'] ?? 'tatib'; 

// --- UI CONFIG VARIABLES ---
$btn_primary = "px-4 py-2 bg-[#000080] text-white text-xs font-bold rounded-lg shadow-sm hover:bg-blue-900 transition-all";
$input_class = "w-full px-3 py-2 border border-[#E2E8F0] rounded-lg focus:outline-none focus:ring-2 focus:ring-[#000080]/20 text-xs bg-white";
$card_class = "bg-white border border-[#E2E8F0] rounded-xl shadow-sm";

// ========================================
// STATE 1: PILIH TAHUN ARSIP
// ========================================
if (!$id_tahun) {
    $tahun_arsip = fetchAll("SELECT * FROM tb_tahun_ajaran WHERE status = 'Arsip' ORDER BY id_tahun DESC");
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Arsip Global - Portal Sekolah</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-[#F8FAFC]">
<div class="flex h-screen overflow-hidden">
    <?php include '../includes/sidebar_core.php'; ?>
    <div class="flex-1 overflow-auto lg:ml-64">
        <div class="bg-white border-b border-[#E2E8F0] px-6 py-4 sticky top-0 z-30">
            <h1 class="text-2xl font-extrabold text-slate-800 tracking-tight">Arsip Global Sekolah</h1>
            <p class="text-sm font-medium text-slate-500">Pusat data historis terintegrasi (Read-Only)</p>
        </div>

        <div class="p-6 max-w-7xl mx-auto space-y-6">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <?php if (empty($tahun_arsip)): ?>
                <div class="col-span-full bg-white rounded-xl border border-dashed border-[#E2E8F0] p-12 text-center">
                    <svg class="w-16 h-16 text-slate-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="1.5"><path d="M21 8v13H3V8"></path><path d="M1 3h22v5H1z"></path></svg>
                    <p class="text-slate-500 font-bold text-lg">Belum ada tahun ajaran yang diarsipkan.</p>
                </div>
                <?php else: ?>
                <?php foreach ($tahun_arsip as $t): ?>
                <a href="?tahun=<?= $t['id_tahun'] ?>" class="block group">
                    <div class="<?= $card_class ?> p-6 hover:shadow-lg hover:border-[#000080]/50 transition-all transform hover:-translate-y-1">
                        <div class="flex items-center justify-between mb-4">
                            <div>
                                <h3 class="text-xl font-extrabold text-slate-800 group-hover:text-[#000080]"><?= $t['nama_tahun'] ?></h3>
                                <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Semester <?= $t['semester_aktif'] ?></p>
                            </div>
                            <div class="w-12 h-12 rounded-full bg-blue-50 flex items-center justify-center text-[#000080] group-hover:scale-110 transition-transform">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg>
                            </div>
                        </div>
                        <div class="flex items-center text-slate-500 group-hover:text-[#000080] font-bold text-xs uppercase">
                            <span>Buka Data Arsip 6 Sistem</span>
                            <svg class="w-4 h-4 ml-1 transform group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2"><polyline points="9 18 15 12 9 6"></polyline></svg>
                        </div>
                    </div>
                </a>
                <?php endforeach; ?>
                <?php endif; ?>
            </div>
        </div>
    </div>
</div>
</body>
</html>
<?php
    exit;
}

// ========================================
// STATE 2: DETAIL ARSIP BERDASARKAN TAHUN
// ========================================
$tahun_info = fetchOne("SELECT * FROM tb_tahun_ajaran WHERE id_tahun = :id", ['id' => $id_tahun]);
if (!$tahun_info) { header('Location: arsip_tahun.php'); exit; }

// --- QUERY STATISTIK KARTU (Global Setahun) ---
$stats_global = fetchOne("
    SELECT 
        COUNT(DISTINCT h.id_anggota) as total_siswa_melanggar,
        COUNT(DISTINCT h.id_transaksi) as total_pelanggaran
    FROM tb_pelanggaran_header h
    WHERE h.id_tahun = :id
", ['id' => $id_tahun]);

$top_kelas = fetchOne("
    SELECT k.nama_kelas, SUM(a.total_poin_umum) as total_poin_kelas 
    FROM tb_anggota_kelas a
    JOIN tb_kelas k ON a.id_kelas = k.id_kelas
    WHERE a.id_tahun = :id
    GROUP BY k.id_kelas
    ORDER BY total_poin_kelas DESC LIMIT 1
", ['id' => $id_tahun]);

$total_sp = fetchOne("
    SELECT COUNT(id_sp) as jml_sp 
    FROM tb_riwayat_sp r
    JOIN tb_anggota_kelas a ON r.id_anggota = a.id_anggota
    WHERE a.id_tahun = :id
", ['id' => $id_tahun]);


// --- QUERY GRID KELAS ---
$kelas_list = fetchAll("SELECT id_kelas, nama_kelas, tingkat FROM tb_kelas ORDER BY tingkat, nama_kelas");

?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detail Arsip <?= $tahun_info['nama_tahun'] ?></title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-[#F8FAFC]">
<div class="flex h-screen overflow-hidden">
    <?php include '../includes/sidebar_core.php'; ?>
    <div class="flex-1 overflow-auto lg:ml-64 relative">
        
        <div class="bg-white border-b border-[#E2E8F0] px-6 py-4 sticky top-0 z-30 flex items-center justify-between">
            <div class="flex items-center space-x-4">
                <a href="arsip_tahun.php" class="p-2 bg-slate-100 rounded-lg text-slate-600 hover:bg-slate-200"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg></a>
                <div>
                    <h1 class="text-xl font-extrabold text-slate-800">Arsip: <?= htmlspecialchars($tahun_info['nama_tahun']) ?></h1>
                    <p class="text-xs font-bold text-slate-500 uppercase">Rekam Jejak Historis (Read-Only)</p>
                </div>
            </div>
        </div>

        <div class="p-6 max-w-7xl mx-auto space-y-6 pb-20">
            
            <div class="bg-white p-2 rounded-xl border border-[#E2E8F0] shadow-sm flex overflow-x-auto scrollbar-hide space-x-2">
                <a href="?tahun=<?= $id_tahun ?>&tab=absen" class="px-4 py-2 rounded-lg text-sm font-bold whitespace-nowrap transition-colors <?= $tab_aktif === 'absen' ? 'bg-emerald-600 text-white' : 'text-slate-500 hover:bg-slate-100' ?>">1. E-Absensi</a>
                <a href="?tahun=<?= $id_tahun ?>&tab=ekstra" class="px-4 py-2 rounded-lg text-sm font-bold whitespace-nowrap transition-colors <?= $tab_aktif === 'ekstra' ? 'bg-amber-500 text-white' : 'text-slate-500 hover:bg-slate-100' ?>">2. Ekstrakurikuler</a>
                <a href="?tahun=<?= $id_tahun ?>&tab=tatib" class="px-4 py-2 rounded-lg text-sm font-bold whitespace-nowrap transition-colors <?= $tab_aktif === 'tatib' ? 'bg-[#000080] text-white' : 'text-slate-500 hover:bg-slate-100' ?>">3. SITAPSI (Tatib)</a>
            </div>

            <?php if ($tab_aktif === 'tatib'): ?>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                <div class="bg-white p-4 rounded-xl border border-[#E2E8F0] shadow-sm border-l-4 border-l-red-500">
                    <p class="text-[10px] font-bold text-slate-500 uppercase">Siswa Melanggar</p>
                    <p class="text-2xl font-extrabold text-slate-800 mt-1"><?= number_format($stats_global['total_siswa_melanggar']) ?></p>
                    <p class="text-xs text-red-600 font-medium mt-1">Orang tercatat di arsip</p>
                </div>
                <div class="bg-white p-4 rounded-xl border border-[#E2E8F0] shadow-sm border-l-4 border-l-amber-500">
                    <p class="text-[10px] font-bold text-slate-500 uppercase">Kelas Paling Rawan</p>
                    <p class="text-lg font-extrabold text-slate-800 mt-1"><?= $top_kelas ? $top_kelas['nama_kelas'] : '-' ?></p>
                    <p class="text-xs text-amber-600 font-bold mt-1">Total: <?= $top_kelas ? $top_kelas['total_poin_kelas'] : '0' ?> Poin</p>
                </div>
                <div class="bg-white p-4 rounded-xl border border-[#E2E8F0] shadow-sm border-l-4 border-l-blue-500">
                    <p class="text-[10px] font-bold text-slate-500 uppercase">Total SP Dikeluarkan</p>
                    <p class="text-2xl font-extrabold text-slate-800 mt-1"><?= number_format($total_sp['jml_sp']) ?></p>
                    <p class="text-xs text-slate-500 font-medium mt-1">Surat Peringatan</p>
                </div>
                <div class="bg-white p-4 rounded-xl border border-[#E2E8F0] shadow-sm border-l-4 border-l-slate-500">
                    <p class="text-[10px] font-bold text-slate-500 uppercase">Total Kejadian</p>
                    <p class="text-2xl font-extrabold text-slate-800 mt-1"><?= number_format($stats_global['total_pelanggaran']) ?></p>
                    <p class="text-xs text-slate-500 font-medium mt-1">Kasus Tercatat</p>
                </div>
            </div>

            <div class="bg-[#000080] text-white rounded-xl shadow-md p-6 mb-6">
                <h2 class="text-xl font-extrabold mb-1">Pilih Kelas</h2>
                <p class="text-blue-200 text-sm">Klik kelas untuk melihat daftar siswa atau rekapitulasi poin.</p>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
                <?php foreach ($kelas_list as $kelas): 
                    $jumlah_siswa = fetchOne("
                        SELECT COUNT(*) as total 
                        FROM tb_anggota_kelas 
                        WHERE id_kelas = :id_kelas AND id_tahun = :id_tahun
                    ", ['id_kelas' => $kelas['id_kelas'], 'id_tahun' => $id_tahun])['total'] ?? 0;
                ?>
                <div class="bg-white border border-[#E2E8F0] hover:border-[#000080] rounded-xl shadow-sm hover:shadow-md transition-all transform hover:-translate-y-1 relative overflow-hidden flex flex-col justify-between group">
                    <div class="w-1.5 h-full bg-slate-200 group-hover:bg-[#000080] absolute left-0 top-0 transition-colors"></div>
                    
                    <div class="p-5 flex-1 cursor-pointer" onclick="window.location.href='../../sitapsi/views/admin/monitoring_siswa_list.php?kelas=<?= $kelas['id_kelas'] ?>&tahun=<?= $id_tahun ?>&arsip=1'">
                        <div class="flex items-center justify-between mb-4">
                            <div class="w-10 h-10 bg-slate-50 group-hover:bg-blue-50 text-[#000080] rounded-full flex items-center justify-center transition-colors">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle></svg>
                            </div>
                            <div class="text-right">
                                <p class="text-slate-400 text-[10px] font-bold uppercase tracking-wider">Tingkat</p>
                                <p class="text-xl font-extrabold text-slate-800"><?= $kelas['tingkat'] ?></p>
                            </div>
                        </div>
                        <h3 class="text-lg font-extrabold text-slate-800 mb-1"><?= $kelas['nama_kelas'] ?></h3>
                        <p class="text-xs font-bold text-slate-500"><?= $jumlah_siswa ?> Siswa</p>
                    </div>

                    <div class="grid grid-cols-2 border-t border-[#E2E8F0] divide-x divide-[#E2E8F0]">
                        <a href="../../sitapsi/views/admin/monitoring_siswa_list.php?kelas=<?= $kelas['id_kelas'] ?>&tahun=<?= $id_tahun ?>&arsip=1" class="block text-center py-2.5 text-[10px] font-bold text-[#000080] hover:bg-blue-50 transition-colors uppercase tracking-wider">
                            Daftar Siswa
                        </a>
                        <a href="../../sitapsi/views/admin/rekapitulasi_kelas.php?kelas=<?= $kelas['id_kelas'] ?>&tahun=<?= $id_tahun ?>&arsip=1" class="block text-center py-2.5 text-[10px] font-bold text-amber-600 hover:bg-amber-50 transition-colors uppercase tracking-wider">
                            Rekap Kelas
                        </a>
                    </div>
                </div>
                <?php endforeach; ?>
            </div>

            <?php else: ?>
            <div class="bg-white rounded-xl border border-[#E2E8F0] p-16 text-center shadow-sm">
                <div class="w-20 h-20 bg-slate-100 rounded-full flex items-center justify-center mx-auto mb-4">
                    <svg class="w-10 h-10 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="1.5"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                </div>
                <h3 class="text-xl font-extrabold text-slate-800 mb-2">Modul Sedang Dalam Pengembangan</h3>
                <p class="text-sm text-slate-500 max-w-md mx-auto">Database untuk sistem <strong class="uppercase"><?= htmlspecialchars($tab_aktif) ?></strong> belum terintegrasi ke Portal Induk. Teman tim Anda akan menyambungkan datanya ke halaman ini nantinya.</p>
            </div>
            <?php endif; ?>

        </div>
    </div>
</div>

<div id="modal-detail" class="hidden fixed inset-0 z-50 flex items-center justify-center p-4">
    <div class="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" onclick="closeDetailModal()"></div>
    <div class="bg-white rounded-2xl shadow-2xl max-w-2xl w-full relative z-10 overflow-hidden flex flex-col max-h-[85vh]">
        <div class="p-5 border-b border-slate-200 bg-slate-50/80 flex justify-between items-center">
            <div>
                <h3 class="font-extrabold text-slate-800 text-lg" id="modal-siswa-nama">Nama Siswa</h3>
                <p class="text-xs font-bold text-slate-500 uppercase">Rekam Jejak Historis</p>
            </div>
            <button onclick="closeDetailModal()" class="text-slate-400 hover:text-slate-600 transition-colors p-2 bg-white rounded-lg shadow-sm border border-slate-200">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
            </button>
        </div>
        
        <div class="p-0 overflow-y-auto flex-1 bg-slate-50">
            <div id="modal-content-area" class="divide-y divide-[#E2E8F0]">
                </div>
        </div>
    </div>
</div>

<script>
    // Mengonversi data detail PHP ke format JSON JavaScript agar bisa dipanggil saat modal dibuka
    const riwayatData = <?= json_encode($details_by_anggota) ?>;

    function openDetailModal(idAnggota, namaSiswa) {
        document.getElementById('modal-siswa-nama').innerText = namaSiswa;
        const contentArea = document.getElementById('modal-content-area');
        contentArea.innerHTML = ''; // Clear previous

        const riwayat = riwayatData[idAnggota];

        if (!riwayat || riwayat.length === 0) {
            contentArea.innerHTML = '<div class="p-8 text-center text-slate-400 font-bold text-sm">Tidak ada rincian kejadian.</div>';
        } else {
            let html = '';
            riwayat.forEach(item => {
                // Format Tanggal
                const dateObj = new Date(item.tanggal);
                const formattedDate = dateObj.toLocaleDateString('id-ID', { day: 'numeric', month: 'short', year: 'numeric' });
                
                html += `
                <div class="p-4 bg-white flex items-start gap-4 hover:bg-slate-50 transition-colors">
                    <div class="w-12 flex-shrink-0 text-center">
                        <div class="text-[10px] font-bold text-slate-400 uppercase leading-tight mb-1">Semester</div>
                        <div class="text-xs font-extrabold text-[#000080] bg-blue-50 py-1 rounded">${item.semester}</div>
                    </div>
                    <div class="flex-1 min-w-0">
                        <p class="text-xs font-bold text-slate-500 mb-0.5">${formattedDate}</p>
                        <p class="text-sm font-bold text-slate-800 leading-snug">${item.nama_pelanggaran}</p>
                    </div>
                    <div class="flex-shrink-0">
                        <span class="px-2.5 py-1 bg-red-50 text-red-600 font-extrabold text-xs rounded-lg shadow-sm border border-red-100">+${item.poin_saat_itu} Pts</span>
                    </div>
                </div>
                `;
            });
            contentArea.innerHTML = html;
        }

        document.getElementById('modal-detail').classList.remove('hidden');
    }

    function closeDetailModal() {
        document.getElementById('modal-detail').classList.add('hidden');
    }
</script>

</body>
</html>