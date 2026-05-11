<?php


session_start();
require_once '../../../config/database.php';
require_once '../../includes/session_check.php';

requireAdmin();

$filter_status = $_GET['status'] ?? 'Pending';

// Query report dengan detail lengkap (DISESUAIKAN NO INDUK)
$sql = "
    SELECT 
        h.id_transaksi,
        h.tanggal,
        h.waktu,
        h.semester,
        h.status_revisi,
        h.alasan_revisi, -- Alasan dari Wali Kelas
        s.no_induk,
        s.nama_siswa,
        k.nama_kelas,
        g.nama_guru as pelapor,
        g_wali.nama_guru as wali_kelas,
        ta.nama_tahun,
        GROUP_CONCAT(DISTINCT jp.nama_pelanggaran SEPARATOR ' | ') as pelanggaran,
        SUM(d.poin_saat_itu) as total_poin,
        -- AMBIL FEEDBACK ORTU JIKA ADA
        (SELECT isi_feedback FROM tb_feedback_ortu WHERE id_transaksi = h.id_transaksi ORDER BY tanggal_kirim DESC LIMIT 1) as feedback_ortu
    FROM tb_pelanggaran_header h
    JOIN tb_anggota_kelas a ON h.id_anggota = a.id_anggota
    JOIN tb_siswa s ON a.no_induk = s.no_induk
    JOIN tb_kelas k ON a.id_kelas = k.id_kelas
    JOIN tb_guru g ON h.id_guru = g.id_guru
    LEFT JOIN tb_guru g_wali ON k.id_kelas = g_wali.id_kelas
    JOIN tb_tahun_ajaran ta ON h.id_tahun = ta.id_tahun
    LEFT JOIN tb_pelanggaran_detail d ON h.id_transaksi = d.id_transaksi
    LEFT JOIN tb_jenis_pelanggaran jp ON d.id_jenis = jp.id_jenis
    WHERE h.status_revisi = :status
    GROUP BY h.id_transaksi
    ORDER BY h.tanggal DESC, h.waktu DESC
";

$reports = fetchAll($sql, ['status' => $filter_status]);

// Hitung jumlah pending (untuk badge tab)
$count_pending = fetchOne("SELECT COUNT(*) as total FROM tb_pelanggaran_header WHERE status_revisi = 'Pending'")['total'] ?? 0;

$success = $_SESSION['success_message'] ?? '';
$error = $_SESSION['error_message'] ?? '';
unset($_SESSION['success_message'], $_SESSION['error_message']);

// --- UI CONFIG VARIABLES ---
$card_class = "bg-white border border-[#E2E8F0] rounded-xl shadow-sm";
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Report Wali Kelas - SITAPSI</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-[#F8FAFC]">

<div class="flex h-screen overflow-hidden">
    
    <?php include '../../includes/sidebar_admin.php'; ?>

    <div class="flex-1 overflow-auto lg:ml-64">
        
        <div class="bg-white border-b border-[#E2E8F0] px-6 py-4 sticky top-0 z-30 flex justify-between items-center">
            <div>
                <h1 class="text-2xl font-extrabold text-slate-800 tracking-tight">Kelola Report Data</h1>
                <p class="text-sm font-medium text-slate-500">Verifikasi pengajuan perbaikan/penghapusan data dari Wali Kelas</p>
            </div>
        </div>

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

            <div class="flex border-b border-[#E2E8F0] space-x-6">
                <a href="kelola_report.php?status=Pending" class="pb-3 text-sm font-bold transition-colors <?= $filter_status === 'Pending' ? 'text-[#000080] border-b-2 border-[#000080]' : 'text-slate-500 hover:text-slate-800' ?>">
                    Menunggu Verifikasi 
                    <?php if($count_pending > 0): ?>
                        <span class="ml-1.5 px-2 py-0.5 rounded-full text-[10px] font-bold bg-red-500 text-white"><?= $count_pending ?></span>
                    <?php endif; ?>
                </a>
                <a href="kelola_report.php?status=Disetujui" class="pb-3 text-sm font-bold transition-colors <?= $filter_status === 'Disetujui' ? 'text-[#000080] border-b-2 border-[#000080]' : 'text-slate-500 hover:text-slate-800' ?>">
                    Telah Disetujui
                </a>
                <a href="kelola_report.php?status=Ditolak" class="pb-3 text-sm font-bold transition-colors <?= $filter_status === 'Ditolak' ? 'text-[#000080] border-b-2 border-[#000080]' : 'text-slate-500 hover:text-slate-800' ?>">
                    Ditolak
                </a>
            </div>

            <div class="<?= $card_class ?> overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-sm whitespace-nowrap">
                        <thead class="bg-slate-50/50 text-xs text-slate-500 uppercase border-b border-[#E2E8F0]">
                            <tr>
                                <th class="p-4 font-bold">ID & Waktu</th>
                                <th class="p-4 font-bold">Siswa & Kelas</th>
                                <th class="p-4 font-bold">Wali Kelas (Pelapor)</th>
                                <th class="p-4 font-bold">Sumber Report</th>
                                <th class="p-4 font-bold">Detail Pelanggaran</th>
                                <th class="p-4 font-bold text-center">Status</th>
                                <th class="p-4 font-bold text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-[#E2E8F0]">
                            <?php if(empty($reports)): ?>
                            <tr>
                                <td colspan="6" class="p-12 text-center text-slate-400">
                                    <svg class="w-12 h-12 mx-auto mb-3 text-slate-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
                                    <p class="font-medium">Tidak ada data report dengan status <strong><?= $filter_status ?></strong></p>
                                </td>
                            </tr>
                            <?php else: ?>
                            <?php foreach($reports as $row): ?>
                            <tr class="hover:bg-slate-50/50 transition-colors">
                                <td class="p-4">
                                    <p class="font-bold text-slate-800">#<?= $row['id_transaksi'] ?></p>
                                    <p class="text-[10px] text-slate-500 font-medium"><?= date('d M Y', strtotime($row['tanggal'])) ?> • <?= substr($row['waktu'], 0, 5) ?></p>
                                </td>
                                <td class="p-4">
                                    <p class="font-bold text-slate-800 text-[13px]"><?= htmlspecialchars($row['nama_siswa']) ?></p>
                                    <p class="text-[10px] font-medium text-slate-500 bg-slate-100 inline-block px-1.5 py-0.5 rounded mt-0.5"><?= $row['nama_kelas'] ?> • <?= $row['no_induk'] ?></p>
                                </td>
                                <td class="p-4">
                                    <p class="font-bold text-slate-700 text-xs"><?= htmlspecialchars($row['wali_kelas'] ?? 'Tidak Diketahui') ?></p>
                                    <p class="text-[10px] text-slate-400">Guru Input: <?= htmlspecialchars($row['pelapor']) ?></p>
                                </td>
                                <td class="p-4">
                                    <div class="flex flex-col gap-1">
                                        <?php if (!empty($row['feedback_ortu'])): ?>
                                            <span class="px-2 py-0.5 rounded text-[9px] font-extrabold uppercase bg-rose-50 text-rose-600 border border-rose-100 text-center">Wali Murid</span>
                                        <?php endif; ?>
                                        <?php if (!empty($row['alasan_revisi'])): ?>
                                            <span class="px-2 py-0.5 rounded text-[9px] font-extrabold uppercase bg-blue-50 text-blue-600 border border-blue-100 text-center">Wali Kelas</span>
                                        <?php endif; ?>
                                    </div>
                                </td>
                                <td class="p-4 max-w-xs">
                                    <p class="text-xs text-slate-700 truncate" title="<?= htmlspecialchars($row['pelanggaran']) ?>"><?= htmlspecialchars($row['pelanggaran']) ?></p>
                                    <p class="text-[10px] font-bold text-red-600 mt-0.5">+<?= $row['total_poin'] ?> Poin</p>
                                </td>
                                <td class="p-4 text-center">
                                    <?php if ($row['status_revisi'] === 'Pending'): ?>
                                        <span class="px-2.5 py-1 text-[10px] font-bold uppercase rounded-md bg-amber-50 text-amber-600 border border-amber-200">Menunggu</span>
                                    <?php elseif ($row['status_revisi'] === 'Disetujui'): ?>
                                        <span class="px-2.5 py-1 text-[10px] font-bold uppercase rounded-md bg-emerald-50 text-emerald-600 border border-emerald-200">Disetujui</span>
                                    <?php elseif ($row['status_revisi'] === 'Ditolak'): ?>
                                        <span class="px-2.5 py-1 text-[10px] font-bold uppercase rounded-md bg-red-50 text-red-600 border border-red-200">Ditolak</span>
                                    <?php endif; ?>
                                </td>
                                <td class="p-4 text-center">
                                    <div class="flex items-center justify-center space-x-2">
                                        <?php 
                                            $full_message = "";
                                            if (!empty($row['feedback_ortu'])) {
                                                $full_message .= "--- [WALI MURID] ---\n" . $row['feedback_ortu'] . "\n\n";
                                            }
                                            if (!empty($row['alasan_revisi'])) {
                                                $full_message .= "--- [WALI KELAS] ---\n" . $row['alasan_revisi'];
                                            }
                                        ?>
                                        <button onclick='showAlasan(<?= json_encode($full_message) ?>, "Pesan Sanggahan / Report")' 
                                                class="px-3 py-1.5 text-[11px] font-bold bg-[#000080]/10 text-[#000080] rounded-md hover:bg-[#000080]/20 transition-colors shadow-sm">
                                            Alasan
                                        </button>
                                                                               <?php if (!isKepsek() && $filter_status === 'Pending'): ?>
                                            <a href="edit_pelanggaran.php?id=<?= $row['id_transaksi'] ?>&source=report" 
                                               class="p-1.5 bg-white border border-amber-200 text-amber-600 rounded-md hover:bg-amber-50 transition-colors shadow-sm" title="Edit Transaksi">
                                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                            </a>
                                            <button onclick="openProcessModal(<?= $row['id_transaksi'] ?>, 'setujui', '<?= addslashes(htmlspecialchars($row['nama_siswa'])) ?>')" 
                                                    class="p-1.5 bg-white border border-emerald-200 text-emerald-600 rounded-md hover:bg-emerald-50 transition-colors shadow-sm" title="Setujui">
                                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
                                            </button>
                                            <button onclick="openProcessModal(<?= $row['id_transaksi'] ?>, 'tolak', '<?= addslashes(htmlspecialchars($row['nama_siswa'])) ?>')" 
                                                    class="p-1.5 bg-white border border-red-200 text-red-600 rounded-md hover:bg-red-50 transition-colors shadow-sm" title="Tolak">
                                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                                            </button>
                                        <?php elseif (!isKepsek() && $filter_status !== 'Pending'): ?>
                                            <button onclick="openProcessModal(<?= $row['id_transaksi'] ?>, 'reset', '<?= addslashes(htmlspecialchars($row['nama_siswa'])) ?>')" 
                                                    class="p-1.5 bg-white border border-slate-200 text-slate-600 rounded-md hover:bg-slate-50 transition-colors shadow-sm" title="Reset Status (Audit Trail)">
                                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"></path></svg>
                                            </button>
                                        <?php endif; ?>
                                    </div>
                                </td>
                            </tr>
                            <?php endforeach; ?>
                            <?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>
</div>

<div id="modal-alasan" class="hidden fixed inset-0 z-50 flex items-center justify-center p-4">
    <div class="absolute inset-0 bg-slate-900/40 backdrop-blur-sm" onclick="closeAlasan()"></div>
    <div class="bg-white rounded-2xl shadow-xl max-w-lg w-full relative z-10 overflow-hidden transform transition-all">
        <div class="p-5 border-b border-[#E2E8F0] bg-slate-50/50 flex items-center justify-between">
            <h3 class="font-extrabold text-slate-800 flex items-center">
                <svg class="w-5 h-5 mr-2 text-[#000080]" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg>
                <span id="modal-judul">Pesan / Alasan</span>
            </h3>
            <button onclick="closeAlasan()" class="text-slate-400 hover:text-slate-600 transition-colors">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
            </button>
        </div>
        <div class="p-6">
            <div class="bg-slate-50 border border-[#E2E8F0] p-4 rounded-xl">
                <p id="teks-alasan" class="text-slate-700 whitespace-pre-wrap leading-relaxed text-sm font-medium"></p>
            </div>
        </div>
        <div class="p-5 border-t border-[#E2E8F0] flex justify-end">
            <button onclick="closeAlasan()" class="px-5 py-2.5 bg-slate-100 text-slate-700 rounded-lg font-bold text-sm hover:bg-slate-200 transition-colors">Tutup</button>
        </div>
    </div>
</div>

<!-- [BARU] MODAL PROSES REPORT DENGAN BALASAN -->
<div id="modal-proses" class="hidden fixed inset-0 z-50 flex items-center justify-center p-4">
    <div class="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" onclick="closeProcessModal()"></div>
    <div class="bg-white rounded-2xl shadow-2xl max-w-lg w-full relative z-10 overflow-hidden transform transition-all">
        <form action="../../actions/proses_report.php" method="POST">
            <input type="hidden" name="id" id="proses-id">
            <input type="hidden" name="action" id="proses-action">
            
            <div class="p-6 border-b border-[#E2E8F0] flex items-center justify-between" id="proses-header">
                <h3 class="font-extrabold text-slate-800 flex items-center">
                    <svg class="w-6 h-6 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2.5"><path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                    <span id="proses-judul">Proses Report</span>
                </h3>
                <button type="button" onclick="closeProcessModal()" class="text-slate-400 hover:text-slate-600 transition-colors">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                </button>
            </div>
            
            <div class="p-8 space-y-5">
                <div class="p-4 bg-slate-50 border border-slate-200 rounded-xl">
                    <p class="text-[10px] font-bold text-slate-400 uppercase tracking-widest mb-1">Nama Siswa</p>
                    <p id="proses-nama" class="font-black text-slate-800 text-lg"></p>
                </div>

                <div id="container-pesan">
                    <label class="block text-xs font-black text-slate-500 mb-3 uppercase tracking-widest">Berikan Balasan/Keputusan Final: *</label>
                    <textarea name="balasan_admin" id="proses-pesan" rows="4" required class="w-full px-5 py-4 border border-slate-200 rounded-2xl focus:outline-none focus:ring-4 focus:ring-blue-500/10 focus:border-blue-500 text-sm font-medium text-slate-700 transition-all resize-none bg-slate-50/50" placeholder="Tuliskan balasan Anda di sini..."></textarea>
                    <p class="text-[10px] text-slate-400 mt-2 italic font-medium">Pesan ini akan tampil di Portal Orang Tua jika sumbernya adalah Wali Murid.</p>
                </div>

                <div id="container-reset" class="hidden py-4 text-center">
                    <p class="text-sm font-medium text-slate-600">Anda yakin ingin membatalkan proses report ini dan mengembalikan status transaksi menjadi <strong class="text-emerald-600 uppercase tracking-tight">Valid</strong>?</p>
                </div>
            </div>

            <div class="p-6 border-t border-[#E2E8F0] bg-slate-50/50 flex gap-3">
                <button type="button" onclick="closeProcessModal()" class="flex-1 px-5 py-3.5 bg-white border border-slate-200 text-slate-600 rounded-2xl font-bold text-sm hover:bg-slate-100 transition-all">Batal</button>
                <button type="submit" id="proses-btn-submit" class="flex-1 px-5 py-3.5 text-white rounded-2xl font-black text-sm shadow-lg transition-all transform active:scale-95">Konfirmasi</button>
            </div>
        </form>
    </div>
</div>

<script>
function showAlasan(alasan, judul = 'Pesan / Alasan') {
    document.getElementById('modal-judul').textContent = judul;
    document.getElementById('teks-alasan').textContent = alasan;
    document.getElementById('modal-alasan').classList.remove('hidden');
}

function closeAlasan() {
    document.getElementById('modal-alasan').classList.add('hidden');
}

function openProcessModal(id, action, nama) {
    const modal = document.getElementById('modal-proses');
    const header = document.getElementById('proses-header');
    const judul = document.getElementById('proses-judul');
    const btn = document.getElementById('proses-btn-submit');
    const pesanContainer = document.getElementById('container-pesan');
    const resetContainer = document.getElementById('container-reset');
    
    document.getElementById('proses-id').value = id;
    document.getElementById('proses-action').value = action;
    document.getElementById('proses-nama').innerText = nama;
    
    // Reset classes
    header.className = 'p-6 border-b border-[#E2E8F0] flex items-center justify-between';
    btn.className = 'flex-1 px-5 py-3.5 text-white rounded-2xl font-black text-sm shadow-lg transition-all transform active:scale-95';
    
    pesanContainer.classList.remove('hidden');
    resetContainer.classList.add('hidden');
    document.getElementById('proses-pesan').required = true;

    if (action === 'setujui') {
        judul.innerText = 'Setujui & Batalkan';
        header.classList.add('bg-emerald-50/50');
        btn.classList.add('bg-emerald-600', 'hover:bg-emerald-700', 'shadow-emerald-200');
        document.getElementById('proses-pesan').placeholder = 'Contoh: Baik Bapak/Ibu, data sudah kami cek dan pelanggaran ini telah kami batalkan.';
    } else if (action === 'tolak') {
        judul.innerText = 'Tolak Report';
        header.classList.add('bg-red-50/50');
        btn.classList.add('bg-red-600', 'hover:bg-red-700', 'shadow-red-200');
        document.getElementById('proses-pesan').placeholder = 'Contoh: Mohon maaf, setelah kami kroscek dengan guru piket, data ini sudah valid.';
    } else if (action === 'reset') {
        judul.innerText = 'Reset Status Report';
        header.classList.add('bg-blue-50/50');
        btn.classList.add('bg-blue-600', 'hover:bg-blue-700', 'shadow-blue-200');
        pesanContainer.classList.add('hidden');
        resetContainer.classList.remove('hidden');
        document.getElementById('proses-pesan').required = false;
    }
    
    modal.classList.remove('hidden');
}

function closeProcessModal() {
    document.getElementById('modal-proses').classList.add('hidden');
}
</script>

</body>
</html>