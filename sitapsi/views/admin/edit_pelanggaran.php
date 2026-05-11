<?php


session_start();
require_once '../../../config/database.php';
require_once '../../includes/session_check.php';

requireAdmin();

if (isKepsek()) {
    die("Akses Ditolak: Kepala Sekolah tidak diizinkan mengubah data pelanggaran.");
}

$id_transaksi = $_GET['id'] ?? null;
$source = $_GET['source'] ?? 'audit';
$back_url = ($source === 'report') ? 'kelola_report.php' : 'audit_harian.php';

if (!$id_transaksi) {
    $_SESSION['error_message'] = '❌ ID transaksi tidak valid';
    header("Location: $back_url");
    exit;
}

// Ambil data transaksi header (DISESUAIKAN NO INDUK)
$transaksi = fetchOne("
    SELECT 
        h.*,
        s.no_induk,
        s.nama_siswa,
        k.nama_kelas,
        a.id_anggota
    FROM tb_pelanggaran_header h
    JOIN tb_anggota_kelas a ON h.id_anggota = a.id_anggota
    JOIN tb_siswa s ON a.no_induk = s.no_induk
    JOIN tb_kelas k ON a.id_kelas = k.id_kelas
    WHERE h.id_transaksi = :id
", ['id' => $id_transaksi]);

if (!$transaksi) {
    $_SESSION['error_message'] = '❌ Transaksi tidak ditemukan';
    header("Location: $back_url");
    exit;
}

// Ambil detail pelanggaran yang sudah dipilih
$detail_pelanggaran = fetchAll("
    SELECT d.id_jenis, d.poin_saat_itu
    FROM tb_pelanggaran_detail d
    WHERE d.id_transaksi = :id
", ['id' => $id_transaksi]);

$selected_pelanggaran = array_column($detail_pelanggaran, 'id_jenis');

// Ambil sanksi yang sudah dipilih
$detail_sanksi = fetchAll("
    SELECT s.id_sanksi_ref
    FROM tb_pelanggaran_sanksi s
    WHERE s.id_transaksi = :id
", ['id' => $id_transaksi]);

$selected_sanksi = array_column($detail_sanksi, 'id_sanksi_ref');

// Ambil daftar pelanggaran per kategori
$pelanggaran_kelakuan = fetchAll("SELECT id_jenis, sub_kategori, nama_pelanggaran, poin_default, sanksi_default FROM tb_jenis_pelanggaran WHERE id_kategori = 1 ORDER BY sub_kategori, nama_pelanggaran");
$pelanggaran_kerajinan = fetchAll("SELECT id_jenis, sub_kategori, nama_pelanggaran, poin_default, sanksi_default FROM tb_jenis_pelanggaran WHERE id_kategori = 2 ORDER BY sub_kategori, nama_pelanggaran");
$pelanggaran_kerapian = fetchAll("SELECT id_jenis, sub_kategori, nama_pelanggaran, poin_default, sanksi_default FROM tb_jenis_pelanggaran WHERE id_kategori = 3 ORDER BY sub_kategori, nama_pelanggaran");

$sanksi_list = fetchAll("SELECT * FROM tb_sanksi_ref ORDER BY CAST(kode_sanksi AS UNSIGNED)");
$sanksi_json = json_encode($sanksi_list);

// --- UI CONFIG VARIABLES ---
$btn_primary = "px-6 py-3 bg-[#000080] text-white text-sm font-semibold rounded-lg shadow-md shadow-blue-900/10 hover:bg-blue-900 transition-all flex items-center justify-center";
$btn_outline = "px-6 py-3 bg-white border border-[#E2E8F0] text-slate-700 text-sm font-semibold rounded-lg shadow-sm hover:bg-slate-50 transition-all flex items-center justify-center";
$card_class = "bg-white border border-[#E2E8F0] rounded-xl shadow-sm";
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Pelanggaran - SITAPSI</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-[#F8FAFC]">

<div class="flex h-screen overflow-hidden">
    
    <?php include '../../includes/sidebar_admin.php'; ?>

    <div class="flex-1 overflow-auto lg:ml-64">
        
        <div class="bg-white border-b border-[#E2E8F0] px-6 py-4 sticky top-0 z-30 flex items-center gap-4">
            <a href="<?= $back_url ?>" class="p-2 rounded-lg text-slate-400 hover:text-slate-600 hover:bg-slate-50 transition-colors">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
            </a>
            <div>
                <h1 class="text-2xl font-extrabold text-slate-800 tracking-tight">Edit Transaksi Pelanggaran</h1>
                <p class="text-sm font-medium text-slate-500">ID Transaksi: <span class="text-[#000080] font-bold">#<?= htmlspecialchars($id_transaksi) ?></span></p>
            </div>
        </div>

        <div class="p-6 max-w-5xl mx-auto space-y-6">
            
            <div class="<?= $card_class ?> p-6 border-l-4 border-l-[#000080]">
                <div class="flex items-center space-x-4">
                    <div class="w-16 h-16 bg-[#000080] rounded-2xl flex items-center justify-center text-white font-extrabold text-2xl shadow-sm">
                        <?= strtoupper(substr($transaksi['nama_siswa'], 0, 1)) ?>
                    </div>
                    <div>
                        <h3 class="text-xl font-extrabold text-slate-800"><?= htmlspecialchars($transaksi['nama_siswa']) ?></h3>
                        <p class="text-sm font-medium text-slate-600"><?= $transaksi['nama_kelas'] ?> • No Induk: <?= $transaksi['no_induk'] ?></p>
                        <p class="text-xs font-bold text-slate-400 mt-1">
                            <?= date('d M Y', strtotime($transaksi['tanggal'])) ?> - <?= substr($transaksi['waktu'], 0, 5) ?> 
                            • <span class="text-[#000080]"><?= $transaksi['tipe_form'] ?></span>
                        </p>
                    </div>
                </div>
            </div>

            <form action="../../actions/update_pelanggaran.php" method="POST" class="space-y-6">
                <input type="hidden" name="id_transaksi" value="<?= htmlspecialchars($id_transaksi) ?>">
                <input type="hidden" name="id_anggota" value="<?= htmlspecialchars($transaksi['id_anggota']) ?>">
                <input type="hidden" name="source" value="<?= htmlspecialchars($source) ?>">
                
                <div class="<?= $card_class ?> overflow-hidden">
                    <div class="flex border-b border-[#E2E8F0] overflow-x-auto bg-slate-50/50">
                        <button type="button" onclick="switchCategory('kelakuan')" id="tab-kelakuan" 
                                class="category-tab flex-1 py-4 px-4 font-extrabold text-sm text-center transition-colors bg-red-600 text-white border-b-2 border-red-700">
                            🚨 KELAKUAN
                        </button>
                        <button type="button" onclick="switchCategory('kerajinan')" id="tab-kerajinan" 
                                class="category-tab flex-1 py-4 px-4 font-bold text-sm text-center transition-colors text-slate-500 hover:text-slate-800 border-b-2 border-transparent hover:bg-slate-100">
                            📘 KERAJINAN
                        </button>
                        <button type="button" onclick="switchCategory('kerapian')" id="tab-kerapian" 
                                class="category-tab flex-1 py-4 px-4 font-bold text-sm text-center transition-colors text-slate-500 hover:text-slate-800 border-b-2 border-transparent hover:bg-slate-100">
                            👔 KERAPIAN
                        </button>
                    </div>

                    <div id="content-kelakuan" class="category-content p-6">
                        <?php $current_sub = ''; foreach ($pelanggaran_kelakuan as $p): 
                            if ($current_sub !== $p['sub_kategori']): 
                                if ($current_sub !== '') echo '</div>'; 
                                $current_sub = $p['sub_kategori']; 
                        ?>
                        <div class="mb-6"><h5 class="text-[11px] font-extrabold text-slate-400 mb-3 uppercase tracking-wider border-b border-[#E2E8F0] pb-2"><?= htmlspecialchars($p['sub_kategori']) ?></h5>
                        <?php endif; ?>
                            <label class="flex items-start space-x-3 p-3.5 border border-[#E2E8F0] rounded-xl hover:bg-red-50 cursor-pointer mb-2.5 transition-all hover:border-red-300 group">
                                <input type="checkbox" name="pelanggaran[]" value="<?= $p['id_jenis'] ?>" 
                                       data-poin="<?= $p['poin_default'] ?>" 
                                       data-sanksi="<?= htmlspecialchars($p['sanksi_default']) ?>" 
                                       onchange="updateSanksi()"
                                       <?= in_array($p['id_jenis'], $selected_pelanggaran) ? 'checked' : '' ?>
                                       class="w-5 h-5 text-red-600 border-slate-300 rounded focus:ring-red-500 mt-0.5">
                                <div class="flex-1">
                                    <p class="font-bold text-slate-700 text-sm group-hover:text-red-700 leading-snug"><?= htmlspecialchars($p['nama_pelanggaran']) ?></p>
                                    <p class="text-xs text-red-600 font-extrabold mt-1"><?= $p['poin_default'] ?> Poin</p>
                                </div>
                            </label>
                        <?php endforeach; if ($current_sub !== '') echo '</div>'; ?>
                    </div>

                    <div id="content-kerajinan" class="category-content p-6 hidden">
                        <?php $current_sub = ''; foreach ($pelanggaran_kerajinan as $p): 
                            if ($current_sub !== $p['sub_kategori']): 
                                if ($current_sub !== '') echo '</div>'; 
                                $current_sub = $p['sub_kategori']; 
                        ?>
                        <div class="mb-6"><h5 class="text-[11px] font-extrabold text-slate-400 mb-3 uppercase tracking-wider border-b border-[#E2E8F0] pb-2"><?= htmlspecialchars($p['sub_kategori']) ?></h5>
                        <?php endif; ?>
                            <label class="flex items-start space-x-3 p-3.5 border border-[#E2E8F0] rounded-xl hover:bg-blue-50 cursor-pointer mb-2.5 transition-all hover:border-blue-300 group">
                                <input type="checkbox" name="pelanggaran[]" value="<?= $p['id_jenis'] ?>" 
                                       data-poin="<?= $p['poin_default'] ?>" 
                                       data-sanksi="<?= htmlspecialchars($p['sanksi_default']) ?>" 
                                       onchange="updateSanksi()"
                                       <?= in_array($p['id_jenis'], $selected_pelanggaran) ? 'checked' : '' ?>
                                       class="w-5 h-5 text-blue-600 border-slate-300 rounded focus:ring-blue-500 mt-0.5">
                                <div class="flex-1">
                                    <p class="font-bold text-slate-700 text-sm group-hover:text-blue-700 leading-snug"><?= htmlspecialchars($p['nama_pelanggaran']) ?></p>
                                    <p class="text-xs text-blue-600 font-extrabold mt-1"><?= $p['poin_default'] ?> Poin</p>
                                </div>
                            </label>
                        <?php endforeach; if ($current_sub !== '') echo '</div>'; ?>
                    </div>

                    <div id="content-kerapian" class="category-content p-6 hidden">
                        <?php $current_sub = ''; foreach ($pelanggaran_kerapian as $p): 
                            if ($current_sub !== $p['sub_kategori']): 
                                if ($current_sub !== '') echo '</div>'; 
                                $current_sub = $p['sub_kategori']; 
                        ?>
                        <div class="mb-6"><h5 class="text-[11px] font-extrabold text-slate-400 mb-3 uppercase tracking-wider border-b border-[#E2E8F0] pb-2"><?= htmlspecialchars($p['sub_kategori']) ?></h5>
                        <?php endif; ?>
                            <label class="flex items-start space-x-3 p-3.5 border border-[#E2E8F0] rounded-xl hover:bg-yellow-50 cursor-pointer mb-2.5 transition-all hover:border-yellow-400 group">
                                <input type="checkbox" name="pelanggaran[]" value="<?= $p['id_jenis'] ?>" 
                                       data-poin="<?= $p['poin_default'] ?>" 
                                       data-sanksi="<?= htmlspecialchars($p['sanksi_default']) ?>" 
                                       onchange="updateSanksi()"
                                       <?= in_array($p['id_jenis'], $selected_pelanggaran) ? 'checked' : '' ?>
                                       class="w-5 h-5 text-yellow-500 border-slate-300 rounded focus:ring-yellow-500 mt-0.5">
                                <div class="flex-1">
                                    <p class="font-bold text-slate-700 text-sm group-hover:text-yellow-700 leading-snug"><?= htmlspecialchars($p['nama_pelanggaran']) ?></p>
                                    <p class="text-xs text-yellow-600 font-extrabold mt-1"><?= $p['poin_default'] ?> Poin</p>
                                </div>
                            </label>
                        <?php endforeach; if ($current_sub !== '') echo '</div>'; ?>
                    </div>
                </div>

                <?php if ($source === 'report'): ?>
                    <!-- [BARU] CONTEXT FEEDBACK & BALASAN UNTUK REPORT -->
                    <div class="<?= $card_class ?> p-6 bg-amber-50/30 border-amber-200">
                        <h4 class="font-extrabold text-amber-800 mb-4 flex items-center text-sm uppercase tracking-wider">
                            <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2"><path d="M11 5.882V19.24a1.76 1.76 0 01-3.417.592l-2.147-6.15M18 13a3 3 0 100-6M5.436 13.683A4.001 4.001 0 017 6h1.832c4.1 0 7.625-1.234 9.168-3v14c-1.543-1.766-5.067-3-9.168-3H7a3.988 3.988 0 01-1.564-.317z"></path></svg>
                            Respon Admin & Keputusan Final
                        </h4>
                        
                        <div class="space-y-4">
                            <?php 
                                $fb_ortu = fetchOne("SELECT isi_feedback FROM tb_feedback_ortu WHERE id_transaksi = ? ORDER BY tanggal_kirim DESC LIMIT 1", [$id_transaksi]);
                            ?>
                            
                            <?php if ($fb_ortu || !empty($transaksi['alasan_revisi'])): ?>
                                <div class="p-4 bg-white border border-amber-100 rounded-xl space-y-3">
                                    <?php if ($fb_ortu): ?>
                                        <div class="pb-2 border-b border-slate-50">
                                            <p class="text-[10px] font-black text-rose-500 uppercase tracking-widest mb-1">Pesan Wali Murid:</p>
                                            <p class="text-xs text-slate-700 italic font-medium">"<?= htmlspecialchars($fb_ortu['isi_feedback']) ?>"</p>
                                        </div>
                                    <?php endif; ?>
                                    <?php if (!empty($transaksi['alasan_revisi'])): ?>
                                        <div>
                                            <p class="text-[10px] font-black text-blue-500 uppercase tracking-widest mb-1">Alasan Wali Kelas:</p>
                                            <p class="text-xs text-slate-700 italic font-medium">"<?= htmlspecialchars($transaksi['alasan_revisi']) ?>"</p>
                                        </div>
                                    <?php endif; ?>
                                </div>
                            <?php endif; ?>

                            <div>
                                <label class="block text-xs font-black text-slate-500 mb-2 uppercase tracking-widest">Berikan Balasan/Keputusan Final: *</label>
                                <textarea name="balasan_admin" rows="3" required class="w-full px-4 py-3 border border-amber-200 rounded-xl focus:outline-none focus:ring-4 focus:ring-amber-500/10 focus:border-amber-500 text-sm font-medium text-slate-700 transition-all resize-none bg-white" placeholder="Jelaskan perubahan atau keputusan Anda di sini (Akan tampil di Portal)..."><?= htmlspecialchars($transaksi['balasan_admin'] ?? '') ?></textarea>
                            </div>
                        </div>
                    </div>
                <?php endif; ?>

                <div class="flex flex-col sm:flex-row gap-4 pt-2">
                    <a href="<?= $back_url ?>" class="<?= $btn_outline ?> flex-1">
                        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
                        Kembali
                    </a>
                    
                    <button type="button" onclick="cancelTransactionAudit(<?= $id_transaksi ?>)" class="px-6 py-3 bg-red-50 text-red-600 border border-red-200 text-sm font-bold rounded-lg shadow-sm hover:bg-red-100 transition-all flex-1 flex items-center justify-center">
                        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M6 18L18 6M6 6l12 12"></path></svg>
                        Batalkan Transaksi (Audit Trail)
                    </button>

                    <button type="submit" class="<?= $btn_primary ?> flex-1">
                        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path><polyline points="17 21 17 13 7 13 7 21"></polyline><polyline points="7 3 7 8 15 8"></polyline></svg>
                        Simpan Perubahan
                    </button>
                </div>
                </div>

            </form>

        </div>

    </div>

</div>

<script>
const sanksiData = <?= $sanksi_json ?>;
const selectedSanksiDefault = <?= json_encode($selected_sanksi) ?>;

function switchCategory(category) {
    document.querySelectorAll('.category-content').forEach(content => content.classList.add('hidden'));
    
    document.querySelectorAll('.category-tab').forEach(tab => {
        tab.classList.remove('bg-red-600', 'bg-blue-600', 'bg-yellow-500', 'text-white', 'border-red-700', 'border-blue-700', 'border-yellow-600', 'font-extrabold');
        tab.classList.add('text-slate-500', 'border-transparent', 'font-bold');
    });
    
    document.getElementById('content-' + category).classList.remove('hidden');
    
    const activeTab = document.getElementById('tab-' + category);
    activeTab.classList.remove('text-slate-500', 'border-transparent', 'font-bold');
    activeTab.classList.add('text-white', 'font-extrabold');
    
    if (category === 'kelakuan') {
        activeTab.classList.add('bg-red-600', 'border-red-700');
    } else if (category === 'kerajinan') {
        activeTab.classList.add('bg-blue-600', 'border-blue-700');
    } else {
        activeTab.classList.add('bg-yellow-500', 'border-yellow-600');
    }
}

function updateSanksi() {
    const checked = document.querySelectorAll('input[name="pelanggaran[]"]:checked');
    const container = document.getElementById('sanksi-container');
    const empty = document.getElementById('sanksi-empty');
    let codes = new Set();
    
    checked.forEach(chk => { 
        if(chk.dataset.sanksi) {
            chk.dataset.sanksi.split(',').forEach(c => codes.add(c.trim())); 
        }
    });
    
    container.innerHTML = '';
    
    if (codes.size === 0) { 
        empty.style.display = 'block'; 
        return; 
    }
    
    empty.style.display = 'none';
    
    sanksiData.forEach(s => {
        if (codes.has(s.kode_sanksi)) {
            const isChecked = selectedSanksiDefault.includes(s.id_sanksi_ref);
            container.innerHTML += `
                <label class="flex items-start space-x-3 p-3.5 border-2 border-[#000080]/20 bg-[#000080]/5 rounded-xl cursor-pointer hover:border-[#000080]/40 transition-colors">
                    <input type="checkbox" name="sanksi[]" value="${s.id_sanksi_ref}" ${isChecked ? 'checked' : ''} 
                           class="w-5 h-5 text-[#000080] border-slate-300 rounded focus:ring-[#000080] mt-0.5">
                    <div class="flex-1">
                        <p class="font-bold text-slate-800 text-sm leading-snug"><span class="text-[#000080] mr-1">${s.kode_sanksi}.</span> ${s.deskripsi}</p>
                    </div>
                </label>
            `;
        }
    });
}

// Initialize on load
document.addEventListener('DOMContentLoaded', function() {
    updateSanksi();
});

function cancelTransactionAudit(id) {
    if (confirm('⚠️ PERINGATAN AUDIT TRAIL!\n\nAnda akan MEMBATALKAN transaksi ini.\n• Poin siswa akan dikembalikan secara otomatis\n• Data TIDAK DIHAPUS, tapi ditandai sebagai "Dibatalkan"\n• Sejarah kesalahan input akan tetap tersimpan di sistem\n\nYakin ingin membatalkan transaksi ini?')) {
        const alasan = prompt("Masukkan alasan pembatalan (Akan tampil di Audit Trail):", "Salah input oleh Admin - Dibatalkan via Edit");
        if (alasan) {
            window.location.href = `../../actions/hapus_transaksi.php?id=${id}&redirect=audit&alasan=${encodeURIComponent(alasan)}`;
        }
    }
}
</script>

</body>
</html>