import random
import hashlib
import re
from collections import defaultdict
import datetime

# Configuration
NUM_PARENTS = 250
NUM_STUDENTS_PER_COHORT = 110

MALE_NAMES = ["Budi", "Agus", "Bambang", "Joko", "Dedi", "Hendra", "Slamet", "Wahyu", "Eko", "Andi", "Rian", "Dani", "Surya", "Bayu", "Aris", "Teguh", "Fajar", "Aditya", "Rizky", "Dimas", "Ahmad", "Indra", "Guntur", "Prasetyo", "Wawan", "Sutrisno", "Iwan", "Yanto", "Hadi", "Rudi", "Fauzan", "Ridwan", "Taufik", "Syarif", "Zulkifli", "Hamzah", "Lukman", "Yahya", "Zaki", "Umar", "Ali", "Hasan", "Husain"]
FEMALE_NAMES = ["Siti", "Ani", "Ratna", "Dewi", "Sri", "Maya", "Lestari", "Indah", "Rini", "Sari", "Putri", "Dian", "Linda", "Rina", "Wati", "Aisyah", "Nur", "Fatmawati", "Kartika", "Eka", "Tri", "Yuliana", "Mega", "Siska", "Fitri", "Amalia", "Widya", "Utami", "Hana", "Zahra", "Salma", "Nabila", "Keysha", "Aura", "Lutfia", "Khadijah", "Maryam", "Safira"]
LAST_NAMES = ["Santoso", "Sutrisno", "Wahyudi", "Pratama", "Kusuma", "Saputra", "Wijaya", "Hidayat", "Setiawan", "Gunawan", "Raharjo", "Budiman", "Nugroho", "Purnomo", "Wibowo", "Susanto", "Firmansyah", "Ramadhan", "Hidayatullah", "Permana", "Nasution", "Siregar", "Lubis", "Ginting", "Pohan", "Sitorus", "Pane"]
JOBS = ["PNS", "Wiraswasta", "Karyawan Swasta", "TNI", "Polri", "Guru", "Dosen", "Dokter", "Perawat", "Pedagang", "Buruh", "Petani", "Pilot", "Arsitek", "Nelayan", "Supir", "Satpam"]
MALANG_STREETS = ["Jl. Ijen", "Jl. Borobudur", "Jl. Sukarno Hatta", "Jl. Dinoyo", "Jl. Arjosari", "Jl. Blimbing", "Jl. Sawojajar", "Jl. Sulfat", "Jl. Veteran", "Jl. Kawi", "Jl. Galunggung", "Jl. Semeru", "Jl. Oro-oro Dowo", "Jl. Langsep"]

JENIS_PELANGGARAN_INSERTS = """
INSERT INTO tb_jenis_pelanggaran (id_jenis, id_kategori, sub_kategori, nama_pelanggaran, poin_default, sanksi_default) VALUES 
(1, 1, '01. Kegiatan Sekolah', 'Tidak mengikuti kegiatan wajib sekolah / upacara tanpa keterangan.', 100, '5'),
(2, 1, '01. Kegiatan Sekolah', 'Bergurau/tidak tertib saat kegiatan berlangsung', 100, '5'),
(3, 1, '02. Sikap & Moral', 'Berkata tidak sopan/kasar/jorok', 100, '1'),
(4, 1, '02. Sikap & Moral', 'Mencuri/memalak/meminta paksa', 500, '1,4,7'),
(5, 1, '02. Sikap & Moral', 'Berbohong', 100, '1'),
(6, 1, '02. Sikap & Moral', 'Menghina/mengejek Guru/Karyawan', 200, '1,5'),
(7, 1, '02. Sikap & Moral', 'Menghina/mengejek Siswa/Teman', 100, '1'),
(8, 1, '02. Sikap & Moral', 'Perundungan (Bullying)', 100, '1,5,7,8,9'),
(9, 1, '02. Sikap & Moral', 'Membanting pintu/melempar benda', 100, '1'),
(10, 1, '02. Sikap & Moral', 'Memanggil ortu dengan sebutan tidak sopan', 100, '1,2,5,8'),
(11, 1, '02. Sikap & Moral', 'Bersikap tidak sopan (duduk di meja dll)', 100, '1,2'),
(12, 1, '02. Sikap & Moral', 'Merayakan HUT teman secara negatif', 100, '1,5'),
(13, 1, '02. Sikap & Moral', 'Memicu keributan di medsos/sekolah', 100, '1,2,7,8'),
(14, 1, '02. Sikap & Moral', 'Membiarkan/mendorong kerusakan fasilitas', 100, '1,3'),
(15, 1, '02. Sikap & Moral', 'Membiarkan teman celaka/sakit', 100, '1,2,7,8'),
(16, 1, '03. Dokumen', 'Memalsukan surat/tanda tangan', 300, '7'),
(17, 1, '04. Rokok & Miras', 'Membawa rokok', 300, '7,8'),
(18, 1, '04. Rokok & Miras', 'Merokok (langsung/medsos)', 500, '7,8,9,10'),
(19, 1, '04. Rokok & Miras', 'Membawa minuman keras', 300, '7,8'),
(20, 1, '04. Rokok & Miras', 'Meminum minuman keras', 500, '7,8,9,10'),
(21, 1, '05. NAPZA', 'Membawa/mengedarkan/menggunakan NAPZA', 9999, '10'),
(22, 1, '06. Pelecehan Seksual', 'Membawa/akses/sebar konten porno', 300, '1,7'),
(23, 1, '06. Pelecehan Seksual', 'Melakukan tindakan Pelecehan Seksual', 500, '1,7,8,9'),
(24, 1, '07. Kekerasan', 'Terlibat perkelahian/main hakim sendiri', 300, '1,2,7,8,9'),
(25, 1, '07. Kekerasan', 'Mengancam Kepala Sekolah/Guru/Karyawan', 300, '10'),
(26, 1, '07. Kekerasan', 'Tindak kriminal terbukti hukum', 9999, '10'),
(27, 1, '08. Gank', 'Terlibat Gank negatif', 300, '1,7,8'),
(28, 1, '09. Sarana Prasarana', 'Mencorat-coret/merusak sarana sekolah', 75, '1,3'),
(29, 1, '09. Sarana Prasarana', 'Bermain alat PBM/sapu di kelas', 75, '1,3'),
(30, 1, '09. Sarana Prasarana', 'Makan dan minum di dalam kelas', 50, '1,2'),
(31, 1, '10. Ketertiban PBM', 'Ramai/tidak memperhatikan saat PBM', 50, '1,2'),
(32, 1, '10. Ketertiban PBM', 'Keluar kelas saat PBM tanpa izin', 50, '1,2'),
(33, 1, '10. Ketertiban PBM', 'Menyontek saat ulangan', 300, '1,5'),
(34, 1, '10. Ketertiban PBM', 'Mengambil alat PBM teman tanpa izin', 50, '1,2'),
(35, 1, '10. Ketertiban PBM', 'Penyalahgunaan HP saat PBM', 50, '1,2'),
(36, 1, '11. 10 K', 'Tidak mendukung 10 K', 50, '1,2,6'),
(37, 1, '12. Kendaraan', 'Mengendarai kendaraan bermotor sendiri', 300, '1,7,8,9'),
(38, 2, '01. Kehadiran', 'Terlambat sekolah/tambahan/ekstra', 25, '2,5,7,8'),
(39, 2, '02. Efektif Sekolah', 'Tidak hadir tanpa keterangan (Alpa)', 75, '7,8'),
(40, 2, '02. Efektif Sekolah', 'Meninggalkan sekolah saat PBM (Bolos)', 75, '7,8'),
(41, 2, '03. PBM', 'Tidak masuk kelas jam pertama', 300, '1,7'),
(42, 2, '03. PBM', 'Tidak ikut olahraga/praktikum tanpa izin', 500, '1,7,8,9'),
(43, 2, '04. Perlengkapan', 'Tidak bawa buku pelajaran', 50, '1,2'),
(44, 2, '04. Perlengkapan', 'Buku catatan campur/tidak rapi', 50, '1,2'),
(45, 2, '04. Perlengkapan', 'Tidak bawa LKS/PR/Tugas', 50, '1,2'),
(46, 2, '04. Perlengkapan', 'Membawa barang non-PBM', 75, '7,8'),
(47, 2, '04. Perlengkapan', 'Tidak membawa buku tatib/literasi', 25, '1'),
(48, 2, '05. Tugas', 'Mencontoh PR/Tugas', 50, '2'),
(49, 2, '05. Tugas', 'Tidak mengumpulkan PR/Tugas', 50, '2'),
(50, 2, '06. Ekstrakurikuler', 'Tidak ikut ekstra tanpa izin', 50, '7,8'),
(51, 2, '06. Ekstrakurikuler', 'Ramai saat kegiatan ekstra', 50, '2'),
(52, 2, '06. Ekstrakurikuler', 'Tidak ikut tambahan pelajaran', 50, '7'),
(53, 3, '01. Seragam', 'Seragam tidak sesuai ketentuan', 75, '1,2,5,7'),
(54, 3, '01. Seragam', 'Pakai rompi/jaket hanya aksesoris', 75, '1,2,5,7'),
(55, 3, '01. Seragam', 'Seragam olahraga dari rumah/saat pulang', 50, '1'),
(56, 3, '01. Seragam', 'Tidak pakai kaos dalam', 50, '1'),
(57, 3, '01. Seragam', 'Atribut tidak lengkap (topi/dasi/sabuk/dll)', 50, '1'),
(58, 3, '01. Seragam', 'Kaos kaki pendek/warna-warni/sepatu non-hitam', 50, '5'),
(59, 3, '01. Seragam', 'Seragam dicoret-coret', 100, '1'),
(60, 3, '01. Seragam', 'Mencoret anggota tubuh', 100, '1'),
(61, 3, '01. Seragam', 'Baju tidak dimasukkan/rok-celana tidak standar', 50, '1,2,5,7'),
(62, 3, '02. Aksesoris', 'Perhiasan/aksesoris berlebihan', 50, '1'),
(63, 3, '02. Aksesoris', 'Putra memakai gelang/anting/kalung', 50, '1'),
(64, 3, '02. Aksesoris', 'Putri memakai gelang/double anting', 50, '1'),
(65, 3, '02. Aksesoris', 'Kuku panjang/dicat', 50, '1'),
(66, 3, '03. Rambut', 'Rambut dicat', 100, '1,7'),
(67, 3, '03. Rambut', 'Putra rambut panjang/gundul', 50, '1'),
(68, 3, '03. Rambut', 'Rambut menutupi wajah/tidak rapi', 50, '1'),
(69, 3, '04. Kegiatan', 'Tidak rapi/bersepatu saat ekstra/tambahan', 50, '1'),
(70, 3, '05. Sepeda', 'Parkir sepeda tidak teratur/tidak dikunci', 25, '1')
"""

# Parsing Jenis Pelanggaran constraints
jenis_map = {}
pattern = re.compile(r"\((\d+),\s*(\d+),\s*'.*?',\s*'.*?',\s*(\d+),\s*'([0-9,]+)'\)")
for match in pattern.finditer(JENIS_PELANGGARAN_INSERTS):
    jid = int(match.group(1))
    cat_id = int(match.group(2))
    poin = int(match.group(3))
    sanksi_str = match.group(4)
    sanksi_list = [int(x) for x in sanksi_str.split(',')]
    cat = 'kelakuan' if cat_id == 1 else 'kerajinan' if cat_id == 2 else 'kerapian'
    jenis_map[jid] = {'cat': cat, 'poin': poin, 'sanksi': sanksi_list}

def get_name(gender):
    first = random.choice(MALE_NAMES if gender == 'L' else FEMALE_NAMES)
    last = random.choice(LAST_NAMES)
    return f"{first} {last}"

def sql_esc(text):
    if text is None: return "NULL"
    return "'" + text.replace("'", "''") + "'"

# --- DATA GENERATION LOGIC ---

parents = []
parent_dict = {}
for i in range(1, NUM_PARENTS + 1):
    nik = f"357301{random.randint(1000000000, 9999999999)}"
    pid = i + 100
    p_data = {
        'id': pid, 
        'nik': nik, 
        'ayah': get_name('L'), 'ibu': get_name('P'), 
        'job_a': random.choice(JOBS), 'job_i': random.choice(JOBS), 
        'hp': f"081{random.randint(100000000, 999999999)}", 
        'addr': f"{random.choice(MALANG_STREETS)} No. {random.randint(1, 100)}, Malang"
    }
    parents.append(p_data)
    parent_dict[pid] = p_data

parent_ids = [p['id'] for p in parents]
parent_assignments = list(parent_ids) # Pastikan semua orang tua punya minimal 1 anak

# Isi sisanya secara acak untuk mensimulasikan saudara kandung (kakak/adik)
while len(parent_assignments) < 450:
    parent_assignments.append(random.choice(parent_ids))

random.shuffle(parent_assignments)

cohorts = {'A': [], 'B': [], 'C': [], 'D': []}
nisn_counter = 812345001
all_students = []
for code in ['A', 'B', 'C', 'D']:
    status = 'Lulus' if code == 'A' else 'Aktif'
    for _ in range(NUM_STUDENTS_PER_COHORT):
        gender = random.choice(['L', 'P'])
        ortu_id = parent_assignments.pop()
        p = parent_dict[ortu_id]
        
        s = {
            'nisn': f"00{nisn_counter}", 
            'name': get_name(gender), 
            'gender': gender, 
            'ortu_id': ortu_id, 
            'status': status,
            'kota': 'Malang',
            'tgl_lahir': f"{2010 + random.randint(0,4)}-{random.randint(1,12):02d}-{random.randint(1,28):02d}",
            'nama_ayah': p['ayah'],
            'job_ayah': p['job_a'],
            'nama_ibu': p['ibu'],
            'job_ibu': p['job_i'],
            'hp_ortu': p['hp'],
            'alamat': p['addr']
        }
        nisn_counter += 1
        cohorts[code].append(s); all_students.append(s)

out_indices = random.sample(range(len(all_students)), 8)
for i, idx in enumerate(out_indices):
    all_students[idx]['status'] = 'Keluar' if i < 5 else 'Dikeluarkan'

anggota_kelas = []
counter = 2000

for s in cohorts['A']: anggota_kelas.append({'id': counter, 'no_induk': s['nisn'], 'kelas': random.randint(6, 10), 'tahun': 1}); counter += 1
for s in cohorts['B']: anggota_kelas.append({'id': counter, 'no_induk': s['nisn'], 'kelas': random.randint(1, 5), 'tahun': 1}); counter += 1

for s in cohorts['A']: anggota_kelas.append({'id': counter, 'no_induk': s['nisn'], 'kelas': random.randint(11, 15), 'tahun': 2}); counter += 1
for s in cohorts['B']: anggota_kelas.append({'id': counter, 'no_induk': s['nisn'], 'kelas': random.randint(6, 10), 'tahun': 2}); counter += 1
for s in cohorts['C']: anggota_kelas.append({'id': counter, 'no_induk': s['nisn'], 'kelas': random.randint(1, 5), 'tahun': 2}); counter += 1

for s in cohorts['B']:
    anggota_kelas.append({'id': counter, 'no_induk': s['nisn'], 'kelas': random.randint(11, 15), 'tahun': 3}); counter += 1
for s in cohorts['C']:
    anggota_kelas.append({'id': counter, 'no_induk': s['nisn'], 'kelas': random.randint(6, 10), 'tahun': 3}); counter += 1
for s in cohorts['D']:
    anggota_kelas.append({'id': counter, 'no_induk': s['nisn'], 'kelas': random.randint(1, 5), 'tahun': 3}); counter += 1

v_header = []
v_detail = []
v_sanksi = []
h_id = 2000
d_id = 2000
s_id = 2000
stats = defaultdict(lambda: {'kelakuan': 0, 'kerajinan': 0, 'kerapian': 0})
bad_apples_per_year = {
    1: [a['id'] for a in random.sample([x for x in anggota_kelas if x['tahun'] == 1], 40)],
    2: [a['id'] for a in random.sample([x for x in anggota_kelas if x['tahun'] == 2], 50)],
    3: [a['id'] for a in random.sample([x for x in anggota_kelas if x['tahun'] == 3], 60)]
}

def gen_violations(tahun, count, start_year, end_year):
    global h_id, d_id, s_id
    possible_a = [x for x in anggota_kelas if x['tahun'] == tahun]
    
    today_str = "2026-05-06"
    
    for i in range(count):
        aid = random.choice(bad_apples_per_year[tahun]) if random.random() < 0.8 else random.choice(possible_a)['id']
        roll = random.random()
        
        if roll < 0.5: jid = random.choice([j for j, v in jenis_map.items() if v['cat'] == 'kerajinan'])
        elif roll < 0.8: jid = random.choice([j for j, v in jenis_map.items() if v['cat'] == 'kerapian'])
        else: jid = random.choice([j for j, v in jenis_map.items() if v['cat'] == 'kelakuan'])
            
        poin = jenis_map[jid]['poin']
        cat = jenis_map[jid]['cat']
            
        month = random.choice([8,9,10,11,12,1,2,3,4,5])
        if month >= 8:
            y = start_year
            semester = 'Ganjil'
            day = random.randint(1, 28)
        else:
            y = end_year
            semester = 'Genap'
            day = random.randint(1, 28)
            
        trans_date = f"{y}-{month:02d}-{day:02d}"
        
        # Exact 16 transactions on "today"
        if tahun == 3 and count - i <= 16:
            trans_date = today_str
            semester = 'Genap'
            
        rev = 'None'
        rev_reason = None
        rev_roll = random.random()
        if rev_roll < 0.02: rev = 'Disetujui'; rev_reason = 'Salah pilih nama siswa di form'
        elif rev_roll < 0.03: rev = 'Ditolak'; rev_reason = 'Bukti valid, revisi ditolak'
        elif rev_roll < 0.04: rev = 'Pending'; rev_reason = 'Maaf Pak, anak ini sedang sakit'

        v_header.append({
            'id': h_id, 'id_a': aid, 'id_g': random.randint(1, 27), 'id_t': tahun, 
            'date': trans_date, 
            'time': f"{random.randint(7,14):02d}:{random.randint(0,59):02d}:00", 
            'rev': rev, 'rev_r': rev_reason,
            'semester': semester, 'tipe': random.choice(['Piket', 'Kelas'])
        })
        v_detail.append({'id': d_id, 'id_h': h_id, 'id_j': jid, 'poin': poin})
        
        for s_ref in jenis_map[jid]['sanksi']:
            v_sanksi.append({'id': s_id, 'id_h': h_id, 'id_s': s_ref})
            s_id += 1
            
        stats[aid][cat] += poin
        h_id += 1; d_id += 1

gen_violations(1, 50, 2023, 2024)
gen_violations(2, 80, 2024, 2025)
gen_violations(3, 130, 2025, 2026)

riwayat_sp = []
sp_id = 2000
feedback = []
fb_id = 2000
FEEDBACK_TEMPLATES = [
    "Mohon maaf bapak/ibu guru, anak saya {name} memang kurang disiplin. Saya akan lebih ketat mengawasinya di rumah.",
    "Terima kasih informasinya. Saya sudah memarahi {name} karena poinnya sudah {poin}. Saya akan menghadap wali kelas besok pagi.",
    "Maaf sekali, kemarin {name} bangun kesiangan karena membantu saya di pasar. Saya janji tidak akan terulang lagi.",
    "Aduh, saya kaget melihat poin {name} sudah segitu. Mohon bimbingannya bapak/ibu, saya akan segera ke sekolah.",
    "Anak saya {name} bilang dia hanya ikut-ikutan teman. Tapi saya tetap minta maaf dan akan membina dia lebih baik lagi.",
    "Saya sangat menyesal mendengar kabar ini dari pihak sekolah. Saya sebagai orang tua akan melakukan pembinaan lebih tegas lagi di rumah."
]

def get_all_sp(p, cat):
    sps = []
    if cat == 'kelakuan':
        if p >= 250: sps.append('SP1')
        if p >= 750: sps.append('SP2')
        if p >= 1500: sps.append('SP3')
        if p >= 2000: sps.append('Sanksi oleh Sekolah')
    elif cat == 'kerajinan':
        if p >= 75: sps.append('SP1')
        if p >= 300: sps.append('SP2')
        if p >= 450: sps.append('SP3')
        if p >= 600: sps.append('Sanksi oleh Sekolah')
    else: # kerapian
        if p >= 100: sps.append('SP1')
        if p >= 300: sps.append('SP2')
        if p >= 450: sps.append('SP3')
        if p >= 600: sps.append('Sanksi oleh Sekolah')
    return sps

for aid, s_map in stats.items():
    for cat_name, p in s_map.items():
        sps_reached = get_all_sp(p, cat_name)
        for level in sps_reached:
            # Randomize SP date: SP1 early, SP2 mid, SP3 late
            a_obj = next(x for x in anggota_kelas if x['id'] == aid)
            y_start = 2023 if a_obj['tahun'] == 1 else 2024 if a_obj['tahun'] == 2 else 2025
            
            if level == 'SP1':
                sp_date = f"{y_start}-{random.randint(8,10):02d}-{random.randint(1,28):02d}"
            elif level == 'SP2':
                sp_date = f"{y_start}-{random.randint(11,12):02d}-{random.randint(1,28):02d}"
            else:
                sp_date = f"{y_start+1}-{random.randint(1,4):02d}-{random.randint(1,28):02d}"

            riwayat_sp.append({'id': sp_id, 'id_a': aid, 'lvl': level, 'cat': cat_name.upper(), 'date': sp_date})
            if random.random() < 0.6:
                s_obj = next(x for x in all_students if x['nisn'] == a_obj['no_induk'])
                txt = random.choice(FEEDBACK_TEMPLATES).format(name=s_obj['name'], poin=p)
                feedback.append({'id': fb_id, 'id_o': s_obj['ortu_id'], 'id_sp': sp_id, 'txt': txt})
                fb_id += 1
            sp_id += 1

# --- SCHEMA DEFINITION ---

SCHEMA_HEAD = """-- SITAPSI STANDALONE FULL DEMO (DB PORTAL1)
-- Generated for SITAPSI 1 & 2 Synchronization

DROP DATABASE IF EXISTS db_portal1;
CREATE DATABASE db_portal1;
USE db_portal1;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET FOREIGN_KEY_CHECKS = 0;
START TRANSACTION;

CREATE TABLE tb_admin (
    id_admin INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL, 
    nama_lengkap VARCHAR(100) NOT NULL,
    role ENUM('AdminPusat', 'Admin', 'KepalaSekolah') DEFAULT 'Admin',
    status ENUM('Aktif', 'Suspend') DEFAULT 'Aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO tb_admin (id_admin, username, password, nama_lengkap, role) VALUES 
(1, 'admin', 'admin123', 'Admin SITAPSI', 'AdminPusat'),
(2, 'admintatib', 'admin123', 'Tim Kedisiplinan', 'Admin'),
(3, 'kepsek', 'kepsek123', 'Kepala Sekolah', 'KepalaSekolah');

CREATE TABLE tb_tahun_ajaran (
    id_tahun INT AUTO_INCREMENT PRIMARY KEY,
    nama_tahun VARCHAR(20) NOT NULL,
    status ENUM('Aktif', 'Arsip') DEFAULT 'Aktif', 
    semester_aktif ENUM('Ganjil', 'Genap') DEFAULT 'Ganjil'
);

INSERT INTO tb_tahun_ajaran (id_tahun, nama_tahun, status, semester_aktif) VALUES 
(1, '2023/2024', 'Arsip', 'Genap'),
(2, '2024/2025', 'Arsip', 'Genap'),
(3, '2025/2026', 'Aktif', 'Genap');

CREATE TABLE tb_kelas (
    id_kelas INT AUTO_INCREMENT PRIMARY KEY,
    nama_kelas VARCHAR(10) NOT NULL,
    tingkat INT NOT NULL
);

INSERT INTO tb_kelas (id_kelas, nama_kelas, tingkat) VALUES 
(1, 'VII A', 7), (2, 'VII B', 7), (3, 'VII C', 7), (4, 'VII D', 7), (5, 'VII E', 7),
(6, 'VIII A', 8), (7, 'VIII B', 8), (8, 'VIII C', 8), (9, 'VIII D', 8), (10, 'VIII E', 8),
(11, 'IX A', 9), (12, 'IX B', 9), (13, 'IX C', 9), (14, 'IX D', 9), (15, 'IX E', 9);

CREATE TABLE tb_guru (
    id_guru INT AUTO_INCREMENT PRIMARY KEY,
    nama_guru VARCHAR(100) NOT NULL,
    nip VARCHAR(30),
    kode_guru VARCHAR(10),
    id_kelas INT NULL,
    pin_validasi VARCHAR(6) NOT NULL,
    status ENUM('Aktif', 'Non-Aktif') DEFAULT 'Aktif'
);

CREATE TABLE tb_siswa (
    no_induk VARCHAR(50) PRIMARY KEY,
    nama_siswa VARCHAR(100) NOT NULL,
    jenis_kelamin ENUM('L', 'P') NOT NULL,
    kota VARCHAR(100),
    tanggal_lahir DATE,
    alamat TEXT,
    nama_ayah VARCHAR(150),
    pekerjaan_ayah VARCHAR(100),
    nama_ibu VARCHAR(150),
    pekerjaan_ibu VARCHAR(100),
    no_hp_ortu VARCHAR(15),
    id_ortu INT NULL,
    status_aktif ENUM('Aktif', 'Lulus', 'Keluar', 'Dikeluarkan') DEFAULT 'Aktif'
);

CREATE TABLE tb_anggota_kelas (
    id_anggota BIGINT AUTO_INCREMENT PRIMARY KEY,
    no_induk VARCHAR(50) NOT NULL, 
    id_kelas INT NOT NULL,
    id_tahun INT NOT NULL,
    poin_kelakuan INT DEFAULT 0,
    poin_kerajinan INT DEFAULT 0,
    poin_kerapian INT DEFAULT 0,
    total_poin_umum INT DEFAULT 0,
    status_sp_kelakuan ENUM('Aman', 'SP1', 'SP2', 'SP3', 'Sanksi oleh Sekolah') DEFAULT 'Aman',
    status_sp_kerajinan ENUM('Aman', 'SP1', 'SP2', 'SP3', 'Sanksi oleh Sekolah') DEFAULT 'Aman',
    status_sp_kerapian ENUM('Aman', 'SP1', 'SP2', 'SP3', 'Sanksi oleh Sekolah') DEFAULT 'Aman',
    status_sp_terakhir ENUM('Aman', 'SP1', 'SP2', 'SP3', 'Sanksi oleh Sekolah') DEFAULT 'Aman',
    status_reward ENUM('None', 'Kandidat Reward Semester','Kandidat Sertifikat') DEFAULT 'None'
);

CREATE TABLE tb_kategori_pelanggaran (
    id_kategori INT AUTO_INCREMENT PRIMARY KEY,
    nama_kategori VARCHAR(50) NOT NULL
);

INSERT INTO tb_kategori_pelanggaran (id_kategori, nama_kategori) VALUES (1, 'KELAKUAN'), (2, 'KERAJINAN'), (3, 'KERAPIAN');

CREATE TABLE tb_sanksi_ref (
    id_sanksi_ref INT AUTO_INCREMENT PRIMARY KEY,
    kode_sanksi VARCHAR(5) NOT NULL, 
    deskripsi TEXT NOT NULL,
    status ENUM('Aktif', 'Non-Aktif') DEFAULT 'Aktif'
);

INSERT INTO tb_sanksi_ref (id_sanksi_ref, kode_sanksi, deskripsi) VALUES 
(1, '1', 'Meminta maaf dan berjanji tidak mengulang'),
(2, '2', 'Dikeluarkan saat PBM (Proses Belajar Mengajar)'),
(3, '3', 'Mengganti/memperbaiki fasilitas sekolah yang rusak'),
(4, '4', 'Mengganti/mengembalikan uang atau barang yang dipinjam/diambil'),
(5, '5', 'Menjalani pembinaan oleh Wali Kelas'),
(6, '6', 'Membersihkan lingkungan sekolah'),
(7, '7', 'Pemanggilan orang tua/wali siswa'),
(8, '8', 'Menjalani pembinaan oleh BK'),
(9, '9', 'Menjalani pembinaan khusus oleh Tim Tatib'),
(10, '10', 'Diserahkan kembali pendidikannya kepada orang tua (Dikeluarkan)');

CREATE TABLE tb_jenis_pelanggaran (
    id_jenis INT AUTO_INCREMENT PRIMARY KEY,
    id_kategori INT NOT NULL,
    sub_kategori VARCHAR(100), 
    nama_pelanggaran TEXT NOT NULL,
    poin_default INT NOT NULL,
    sanksi_default VARCHAR(50), 
    status ENUM('Aktif', 'Non-Aktif') DEFAULT 'Aktif'
);

CREATE TABLE tb_aturan_sp (
    id_aturan_sp INT AUTO_INCREMENT PRIMARY KEY,
    id_kategori INT NOT NULL, 
    level_sp ENUM('SP1', 'SP2', 'SP3', 'Sanksi oleh Sekolah') NOT NULL,
    batas_bawah_poin INT NOT NULL
);

INSERT INTO tb_aturan_sp (id_kategori, level_sp, batas_bawah_poin) VALUES 
(1, 'SP1', 250), (1, 'SP2', 750), (1, 'SP3', 1500), (1, 'Sanksi oleh Sekolah', 2000),
(2, 'SP1', 75), (2, 'SP2', 300), (2, 'SP3', 450), (2, 'Sanksi oleh Sekolah', 600),
(3, 'SP1', 100), (3, 'SP2', 300), (3, 'SP3', 450), (3, 'Sanksi oleh Sekolah', 600);

CREATE TABLE tb_predikat_nilai (
    id_predikat INT AUTO_INCREMENT PRIMARY KEY,
    id_kategori INT NOT NULL,
    huruf_mutu CHAR(1) NOT NULL,
    batas_bawah INT NOT NULL,
    batas_atas INT NOT NULL,
    keterangan VARCHAR(100)
);

INSERT INTO tb_predikat_nilai (id_kategori, huruf_mutu, batas_bawah, batas_atas, keterangan) VALUES 
(1, 'A', 0, 49, 'Sangat Baik'), (1, 'B', 50, 249, 'Baik'), (1, 'C', 250, 1499, 'Cukup (SP1/SP2)'), (1, 'D', 1500, 9999, 'Kurang (SP3/Berat)'),
(2, 'A', 0, 24, 'Sangat Baik'), (2, 'B', 25, 74, 'Baik'), (2, 'C', 75, 449, 'Cukup (SP1/SP2)'), (2, 'D', 450, 9999, 'Kurang (SP3/Berat)'),
(3, 'A', 0, 49, 'Sangat Baik'), (3, 'B', 50, 99, 'Baik'), (3, 'C', 100, 449, 'Cukup (SP1/SP2)'), (3, 'D', 450, 9999, 'Kurang (SP3/Berat)');

CREATE TABLE tb_pelanggaran_header (
    id_transaksi BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_anggota BIGINT NOT NULL,
    id_guru INT NOT NULL,
    id_tahun INT NOT NULL, 
    tanggal DATE NOT NULL,
    waktu TIME NOT NULL,
    semester ENUM('Ganjil', 'Genap') NOT NULL, 
    tipe_form ENUM('Piket', 'Kelas') NOT NULL,
    bukti_foto VARCHAR(255) NULL,
    lampiran_link TEXT NULL, 
    lampiran VARCHAR(255) NULL, 
    catatan TEXT NULL,
    status_revisi ENUM('None', 'Pending', 'Disetujui', 'Ditolak') DEFAULT 'None',
    alasan_revisi TEXT NULL
);

CREATE TABLE tb_pelanggaran_detail (
    id_detail BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_transaksi BIGINT NOT NULL,
    id_jenis INT NOT NULL,
    poin_saat_itu INT NOT NULL
);

CREATE TABLE tb_pelanggaran_sanksi (
    id_trans_sanksi BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_transaksi BIGINT NOT NULL,
    id_sanksi_ref INT NOT NULL
);

CREATE TABLE tb_riwayat_sp (
    id_sp INT AUTO_INCREMENT PRIMARY KEY,
    id_anggota BIGINT NOT NULL,
    tingkat_sp ENUM('SP1', 'SP2', 'SP3', 'Sanksi oleh Sekolah') NOT NULL,
    kategori_pemicu VARCHAR(50), 
    tanggal_terbit DATE NOT NULL,
    tanggal_validasi DATE, 
    status ENUM('Pending', 'Selesai') DEFAULT 'Pending',
    id_admin INT, 
    catatan_admin TEXT NULL
);

CREATE TABLE tb_orang_tua (
    id_ortu INT AUTO_INCREMENT PRIMARY KEY,
    nik_ortu VARCHAR(20) UNIQUE NOT NULL, 
    password VARCHAR(255) NOT NULL, 
    nama_ayah VARCHAR(150),
    pekerjaan_ayah VARCHAR(100),
    nama_ibu VARCHAR(150),
    pekerjaan_ibu VARCHAR(100),
    no_hp_ortu VARCHAR(15),
    alamat TEXT,
    is_active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tb_feedback_ortu (
    id_feedback INT AUTO_INCREMENT PRIMARY KEY,
    id_ortu INT NOT NULL,
    id_sp INT NOT NULL,
    isi_feedback TEXT NOT NULL,
    tanggal_kirim DATETIME DEFAULT CURRENT_TIMESTAMP,
    status_baca ENUM('Belum Dibaca', 'Sudah Dibaca') DEFAULT 'Belum Dibaca',
    id_admin_pembaca INT NULL 
);
"""

GURU_INSERTS = """
INSERT INTO tb_guru (id_guru, nama_guru, nip, kode_guru, id_kelas, pin_validasi) VALUES 
(1, 'Sr. M. Elfrida Suhartati, SPM, S.Psi.,MM', '10001', '1', NULL, '123456'),
(2, 'Antonetta Maria Kuntodiati, S.Pd', '10002', '2', 9, '123456'),
(3, 'Dra. Maria Marsiti', '10003', '3', NULL, '123456'),
(4, 'Trianto Thomas, S.Pd', '10004', '4', 15, '123456'),
(5, 'Agustina Peni Sarasati, S.Pd', '10005', '5', 1, '123456'),
(6, 'Y. Pamungkas, S.Pd', '10006', '6', NULL, '123456'),
(7, 'Joseph Andiek Kristian, S.Pd, S.Kom', '10007', '7', NULL, '123456'),
(8, 'Albertha Yulanti Susetyo, M.Pd', '10008', '8', 4, '123456'),
(9, 'Galang Bagus Afridianto, M.Pd', '10009', '9', NULL, '123456'),
(10, 'Hendrik Kiswanto, S.Pd.', '10010', '10', NULL, '123456'),
(11, 'Margareta Esti Wulan, S.Pd.', '10011', '11', 14, '123456'),
(12, 'Theresia Sri Wahyuni, S.Pd, M.M.', '10012', '12', 12, '123456'),
(13, 'Yosua Beni Setiawan, S.Pd.', '10014', '14', NULL, '123456'),
(14, 'God Life Endob Mesak, S.Pd', '10015', '15', NULL, '123456'),
(15, 'Agnes Herawaty Sinurat, S.E., M.M.', '10016', '16', 3, '123456'),
(16, 'Deka Nanda Kurniawati, S.Pd.', '10017', '17', NULL, '123456'),
(17, 'Agatha Novenia Bintang Prieska, S.Pd.', '10018', '18', 2, '123456'),
(18, 'Bernadetha Devia Tindy Noveyra, S.Pd.', '10019', '19', 7, '123456'),
(19, 'Drs. Albertus Magnus Meo Depa', '10020', '20', NULL, '123456'),
(20, 'Giovani Bimby Dwiantonio, S.Pd', '10021', '21', 11, '123456'),
(21, 'Arnoldus Kobe Tegar Felix Sai, S.Pd.', '10022', '22', NULL, '123456'),
(22, 'Haniar Mey Sila Kinanti, S.Pd.', '10023', '23', 10, '123456'),
(23, 'Anjelina Wulandari Sitina De Sareng, S.Pd', '10024', '24', 6, '123456'),
(24, 'Lydia Uli Permatasari, S.Pd.', '10025', '25', 13, '123456'),
(25, 'Albertus Bayu Seto, S.Pd', '10026', '26', NULL, '123456'),
(26, 'Brigita Natalia Setyaningrum, S.Pd.', '10027', '27', 8, '123456'),
(27, 'Amelia Rangel Da Silva, S.Pd', '10028', '28', 5, '123456');
"""

# --- OUTPUT GENERATION ---

# --- OUTPUT GENERATION ---

sql_content = SCHEMA_HEAD + "\n" + JENIS_PELANGGARAN_INSERTS + ";\n" + GURU_INSERTS + ";\n"

# 1. Parents
sql_content += "\n-- FASE: tb_orang_tua\n"
sql_content += "INSERT INTO tb_orang_tua (id_ortu, nik_ortu, password, nama_ayah, pekerjaan_ayah, nama_ibu, pekerjaan_ibu, no_hp_ortu, alamat) VALUES\n"
p_rows = [f"({p['id']}, '{p['nik']}', 'e10adc3949ba59abbe56e057f20f883e', {sql_esc(p['ayah'])}, {sql_esc(p['job_a'])}, {sql_esc(p['ibu'])}, {sql_esc(p['job_i'])}, '{p['hp']}', {sql_esc(p['addr'])})" for p in parents]
sql_content += ",\n".join(p_rows) + ";\n"

# 2. Students
sql_content += "\n-- FASE: tb_siswa\n"
sql_content += "INSERT INTO tb_siswa (no_induk, nama_siswa, jenis_kelamin, kota, tanggal_lahir, alamat, nama_ayah, pekerjaan_ayah, nama_ibu, pekerjaan_ibu, no_hp_ortu, id_ortu, status_aktif) VALUES\n"
s_rows = [f"('{s['nisn']}', {sql_esc(s['name'])}, '{s['gender']}', '{s['kota']}', '{s['tgl_lahir']}', {sql_esc(s['alamat'])}, {sql_esc(s['nama_ayah'])}, {sql_esc(s['job_ayah'])}, {sql_esc(s['nama_ibu'])}, {sql_esc(s['job_ibu'])}, '{s['hp_ortu']}', {s['ortu_id']}, '{s['status']}')" for s in all_students]
sql_content += ",\n".join(s_rows) + ";\n"

# 3. Anggota Kelas
sql_content += "\n-- FASE: tb_anggota_kelas\n"
sql_content += "INSERT INTO tb_anggota_kelas (id_anggota, no_induk, id_kelas, id_tahun, poin_kelakuan, poin_kerajinan, poin_kerapian, total_poin_umum, status_sp_kelakuan, status_sp_kerajinan, status_sp_kerapian, status_sp_terakhir) VALUES\n"
ak_rows = []
for a in anggota_kelas:
    s_m = stats[a['id']]
    def get_lvl(p, cat):
        if cat == 'kelakuan':
            return 'Sanksi oleh Sekolah' if p >= 2000 else 'SP3' if p >= 1500 else 'SP2' if p >= 750 else 'SP1' if p >= 250 else 'Aman'
        elif cat == 'kerajinan':
            return 'Sanksi oleh Sekolah' if p >= 600 else 'SP3' if p >= 450 else 'SP2' if p >= 300 else 'SP1' if p >= 75 else 'Aman'
        else: # kerapian
            return 'Sanksi oleh Sekolah' if p >= 600 else 'SP3' if p >= 450 else 'SP2' if p >= 300 else 'SP1' if p >= 100 else 'Aman'
    
    sp_kel = get_lvl(s_m['kelakuan'], 'kelakuan')
    sp_raj = get_lvl(s_m['kerajinan'], 'kerajinan')
    sp_rap = get_lvl(s_m['kerapian'], 'kerapian')
    
    lvls = [sp_kel, sp_raj, sp_rap]
    severity = {'Sanksi oleh Sekolah': 4, 'SP3': 3, 'SP2': 2, 'SP1': 1, 'Aman': 0}
    sp_last = max(lvls, key=lambda x: severity[x])
    
    ak_rows.append(f"({a['id']}, '{a['no_induk']}', {a['kelas']}, {a['tahun']}, {s_m['kelakuan']}, {s_m['kerajinan']}, {s_m['kerapian']}, {s_m['kelakuan']+s_m['kerajinan']+s_m['kerapian']}, '{sp_kel}', '{sp_raj}', '{sp_rap}', '{sp_last}')")

sql_content += ",\n".join(ak_rows) + ";\n"

# 4. Violations
sql_content += "\n-- FASE: tb_pelanggaran_header\n"
sql_content += "INSERT INTO tb_pelanggaran_header (id_transaksi, id_anggota, id_guru, id_tahun, tanggal, waktu, semester, tipe_form, bukti_foto, lampiran_link, status_revisi, alasan_revisi) VALUES\n"
h_rows = []

# Logic for realistic evidence distribution
# 1. We want about 8 empty ones (sudden cases)
# 2. Others should vary between photos, docs, and links
empty_indices = random.sample(range(len(v_header)), min(8, len(v_header)))
photo_files = ['bukti_seragam.png', 'bukti_terlambat.png']
doc_files = ['surat_pernyataan.png', 'laporan_kejadian.pdf.png']

for idx, h in enumerate(v_header):
    bukti_foto = "NULL"
    lampiran_link = "NULL"
    
    if idx not in empty_indices:
        # Determine type based on modulo
        evidence_type = idx % 3
        
        if evidence_type == 0: # Photo
            file = random.choice(photo_files)
            bukti_foto = f'\'["{file}"]\''
        elif evidence_type == 1: # Document
            file = random.choice(doc_files)
            bukti_foto = f'\'["{file}"]\''
        else: # Link
            lampiran_link = f"'https://drive.google.com/file/d/demo_evid_{h['id']}/view'"
            
    h_rows.append(f"({h['id']}, {h['id_a']}, {h['id_g']}, {h['id_t']}, '{h['date']}', '{h['time']}', '{h['semester']}', '{h['tipe']}', {bukti_foto}, {lampiran_link}, '{h['rev']}', {sql_esc(h['rev_r'])})")

sql_content += ",\n".join(h_rows) + ";\n"

sql_content += "\n-- FASE: tb_pelanggaran_detail\n"
sql_content += "INSERT INTO tb_pelanggaran_detail (id_detail, id_transaksi, id_jenis, poin_saat_itu) VALUES\n"
d_rows = [f"({d['id']}, {d['id_h']}, {d['id_j']}, {d['poin']})" for d in v_detail]
sql_content += ",\n".join(d_rows) + ";\n"

sql_content += "\n-- FASE: tb_pelanggaran_sanksi\n"
sql_content += "INSERT INTO tb_pelanggaran_sanksi (id_trans_sanksi, id_transaksi, id_sanksi_ref) VALUES\n"
s_rows = [f"({s['id']}, {s['id_h']}, {s['id_s']})" for s in v_sanksi]
sql_content += ",\n".join(s_rows) + ";\n"

# 5. SP History
sql_content += "\n-- FASE: tb_riwayat_sp\n"
sql_content += "INSERT INTO tb_riwayat_sp (id_sp, id_anggota, tingkat_sp, kategori_pemicu, tanggal_terbit, status) VALUES\n"
sp_rows = [f"({sp['id']}, {sp['id_a']}, '{sp['lvl']}', '{sp['cat']}', '{sp['date']}', 'Selesai')" for sp in riwayat_sp]
sql_content += ",\n".join(sp_rows) + ";\n"

# 6. Feedback
sql_content += "\n-- FASE: tb_feedback_ortu\n"
sql_content += "INSERT INTO tb_feedback_ortu (id_feedback, id_ortu, id_sp, isi_feedback, status_baca) VALUES\n"
f_rows = [f"({f['id']}, {f['id_o']}, {f['id_sp']}, {sql_esc(f['txt'])}, 'Sudah Dibaca')" for f in feedback]
sql_content += ",\n".join(f_rows) + ";\n"

sql_content += "\nCOMMIT;\nSET FOREIGN_KEY_CHECKS = 1;"

# Write to both files
for filename in ["db_portal1.sql", "db_sitapsi_full_demo.sql"]:
    with open(f"c:\\xampp\\htdocs\\portal1\\sitapsi2\\data\\data demo\\{filename}", "w", encoding="utf-8") as f:
        f.write(sql_content)

print("Generated full database with balanced semester data in db_portal1.sql and db_sitapsi_full_demo.sql")
