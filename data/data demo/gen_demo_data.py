import random
import hashlib
from collections import defaultdict

# Configuration
NUM_PARENTS = 250
NUM_STUDENTS_PER_COHORT = 110
YEAR_2_ID = 2  # 2024/2025
YEAR_3_ID = 3  # 2025/2026

MALE_NAMES = ["Budi", "Agus", "Bambang", "Joko", "Dedi", "Hendra", "Slamet", "Wahyu", "Eko", "Andi", "Rian", "Dani", "Surya", "Bayu", "Aris", "Teguh", "Fajar", "Aditya", "Rizky", "Dimas", "Ahmad", "Indra", "Guntur", "Prasetyo", "Wawan", "Sutrisno", "Iwan", "Yanto", "Hadi", "Rudi", "Fauzan", "Ridwan", "Taufik", "Syarif", "Zulkifli", "Hamzah", "Lukman", "Yahya", "Zaki", "Umar", "Ali", "Hasan", "Husain"]
FEMALE_NAMES = ["Siti", "Ani", "Ratna", "Dewi", "Sri", "Maya", "Lestari", "Indah", "Rini", "Sari", "Putri", "Dian", "Linda", "Rina", "Wati", "Aisyah", "Nur", "Fatmawati", "Kartika", "Eka", "Tri", "Yuliana", "Mega", "Siska", "Fitri", "Amalia", "Widya", "Utami", "Hana", "Zahra", "Salma", "Nabila", "Keysha", "Aura", "Lutfia", "Khadijah", "Maryam", "Safira"]
LAST_NAMES = ["Santoso", "Sutrisno", "Wahyudi", "Pratama", "Kusuma", "Saputra", "Wijaya", "Hidayat", "Setiawan", "Gunawan", "Raharjo", "Budiman", "Nugroho", "Purnomo", "Wibowo", "Susanto", "Firmansyah", "Ramadhan", "Hidayatullah", "Permana", "Nasution", "Siregar", "Lubis", "Ginting", "Pohan", "Sitorus", "Pane"]
JOBS = ["PNS", "Wiraswasta", "Karyawan Swasta", "TNI", "Polri", "Guru", "Dosen", "Dokter", "Perawat", "Pedagang", "Buruh", "Petani", "Pilot", "Arsitek", "Nelayan", "Supir", "Satpam"]
MALANG_STREETS = ["Jl. Ijen", "Jl. Borobudur", "Jl. Sukarno Hatta", "Jl. Dinoyo", "Jl. Arjosari", "Jl. Blimbing", "Jl. Sawojajar", "Jl. Sulfat", "Jl. Veteran", "Jl. Kawi", "Jl. Galunggung", "Jl. Semeru", "Jl. Oro-oro Dowo", "Jl. Langsep"]

def get_name(gender):
    first = random.choice(MALE_NAMES if gender == 'L' else FEMALE_NAMES)
    last = random.choice(LAST_NAMES)
    return f"{first} {last}"

def sql_esc(text):
    return text.replace("'", "''")

# 1. Generate Parents
parents = []
for i in range(1, NUM_PARENTS + 1):
    nik = f"357301{random.randint(1000000000, 9999999999)}"
    ayah = get_name('L')
    ibu = get_name('P')
    job_a = random.choice(JOBS)
    job_i = random.choice(JOBS)
    hp = f"081{random.randint(100000000, 999999999)}"
    addr = f"{random.choice(MALANG_STREETS)} No. {random.randint(1, 100)}, Malang"
    parents.append({'id': i + 100, 'nik': nik, 'ayah': ayah, 'ibu': ibu, 'job_a': job_a, 'job_i': job_i, 'hp': hp, 'addr': addr})

parent_ids = [p['id'] for p in parents]
parent_assignments = []
for _ in range(40):
    pid = random.choice(parent_ids); parent_assignments.extend([pid, pid])
for _ in range(10):
    pid = random.choice(parent_ids); parent_assignments.extend([pid, pid, pid])
while len(parent_assignments) < 450:
    parent_assignments.append(random.choice(parent_ids))
random.shuffle(parent_assignments)

# 2. Generate Students
cohorts = {'A': [], 'B': [], 'C': [], 'D': []}
nisn_counter = 812345001
all_students = []

for code in ['A', 'B', 'C', 'D']:
    status = 'Lulus' if code == 'A' else 'Aktif'
    for _ in range(NUM_STUDENTS_PER_COHORT):
        gender = random.choice(['L', 'P'])
        s = {'nisn': f"00{nisn_counter}", 'name': get_name(gender), 'gender': gender, 'ortu_id': parent_assignments.pop(), 'status': status}
        nisn_counter += 1
        cohorts[code].append(s); all_students.append(s)

out_indices = random.sample(range(len(all_students)), 8)
for i, idx in enumerate(out_indices):
    all_students[idx]['status'] = 'Keluar' if i < 5 else 'Dikeluarkan'

# 3. Class Membership
anggota_kelas = []
counter = 2000
for s in cohorts['A']:
    anggota_kelas.append({'id': counter, 'no_induk': s['nisn'], 'kelas': random.randint(11, 15), 'tahun': 2})
    counter += 1
for s in cohorts['B']:
    anggota_kelas.append({'id': counter, 'no_induk': s['nisn'], 'kelas': random.randint(6, 10), 'tahun': 2})
    counter += 1
    if s['status'] in ['Aktif', 'Lulus']:
        anggota_kelas.append({'id': counter, 'no_induk': s['nisn'], 'kelas': random.randint(11, 15), 'tahun': 3})
        counter += 1
for s in cohorts['C']:
    anggota_kelas.append({'id': counter, 'no_induk': s['nisn'], 'kelas': random.randint(1, 5), 'tahun': 2})
    counter += 1
    if s['status'] in ['Aktif', 'Lulus']:
        anggota_kelas.append({'id': counter, 'no_induk': s['nisn'], 'kelas': random.randint(6, 10), 'tahun': 3})
        counter += 1
for s in cohorts['D']:
    if s['status'] in ['Aktif', 'Lulus']:
        anggota_kelas.append({'id': counter, 'no_induk': s['nisn'], 'kelas': random.randint(1, 5), 'tahun': 3})
        counter += 1

# 4. Violations
v_header = []
v_detail = []
h_id = 2000
d_id = 2000
stats = defaultdict(lambda: {'kelakuan': 0, 'kerajinan': 0, 'kerapian': 0})

bad_apples_per_year = {
    2: [a['id'] for a in random.sample([x for x in anggota_kelas if x['tahun'] == 2], 50)],
    3: [a['id'] for a in random.sample([x for x in anggota_kelas if x['tahun'] == 3], 60)]
}

def gen_violations(tahun, count, date_prefix):
    global h_id, d_id
    possible_a = [x for x in anggota_kelas if x['tahun'] == tahun]
    for _ in range(count):
        aid = random.choice(bad_apples_per_year[tahun]) if random.random() < 0.8 else random.choice(possible_a)['id']
        roll = random.random()
        if roll < 0.5: jid = random.randint(38, 52); poin = random.randint(25, 75); cat = 'kerajinan'
        elif roll < 0.8: jid = random.randint(53, 70); poin = random.randint(25, 100); cat = 'kerapian'
        else:
            jid = random.randint(1, 37); poin = random.randint(100, 1000); cat = 'kelakuan'
            if random.random() < 0.05: poin = 2100 
        v_header.append({'id': h_id, 'id_a': aid, 'id_g': random.randint(1, 27), 'id_t': tahun, 
                         'date': f"{date_prefix}-{random.randint(1,10):02d}-{random.randint(1,28):02d}", 
                         'time': f"{random.randint(7,14):02d}:{random.randint(0,59):02d}:00", 'rev': 'None'})
        v_detail.append({'id': d_id, 'id_h': h_id, 'id_j': jid, 'poin': poin})
        stats[aid][cat] += poin
        h_id += 1; d_id += 1

gen_violations(2, 100, "2024")
gen_violations(3, 150, "2025")

# 5. SP & Feedback
riwayat_sp = []
sp_id = 2000
feedback = []
fb_id = 2000

FEEDBACK_TEMPLATES = [
    "Mohon maaf bapak/ibu guru, anak saya {name} memang kurang disiplin. Saya akan lebih ketat mengawasinya di rumah.",
    "Terima kasih informasinya. Saya sudah memarahi {name} karena poinnya sudah {poin}. Saya akan menghadap wali kelas besok pagi.",
    "Maaf sekali, kemarin {name} bangun kesiangan karena membantu saya di pasar. Saya janji tidak akan terulang lagi.",
    "Aduh, saya kaget melihat poin {name} sudah segitu. Mohon bimbingannya bapak/ibu, saya akan segera ke sekolah.",
    "Anak saya {name} bilang dia hanya ikut-ikutan teman. Tapi saya tetap minta maaf dan akan membina dia lebih baik lagi."
]

for aid, s_map in stats.items():
    if s_map['kelakuan'] >= 250:
        level = 'SP1'
        if s_map['kelakuan'] >= 2000: level = 'Sanksi oleh Sekolah'
        elif s_map['kelakuan'] >= 1500: level = 'SP3'
        elif s_map['kelakuan'] >= 750: level = 'SP2'
        riwayat_sp.append({'id': sp_id, 'id_a': aid, 'lvl': level, 'cat': 'KELAKUAN', 'date': '2026-01-10'})
        if random.random() < 0.6:
            a_obj = next(x for x in anggota_kelas if x['id'] == aid)
            s_obj = next(x for x in all_students if x['nisn'] == a_obj['no_induk'])
            txt = random.choice(FEEDBACK_TEMPLATES).format(name=s_obj['name'], poin=sum(s_map.values()))
            feedback.append({'id': fb_id, 'id_o': s_obj['ortu_id'], 'id_sp': sp_id, 'txt': txt})
            fb_id += 1
        sp_id += 1

print("SET FOREIGN_KEY_CHECKS = 0;")
print("\n-- FASE 1: tb_orang_tua")
print("INSERT IGNORE INTO `tb_orang_tua` (`id_ortu`, `nik_ortu`, `password`, `nama_ayah`, `pekerjaan_ayah`, `nama_ibu`, `pekerjaan_ibu`, `no_hp_ortu`, `alamat`) VALUES")
print(",\n".join([f"({p['id']}, '{p['nik']}', 'e10adc3949ba59abbe56e057f20f883e', '{sql_esc(p['ayah'])}', '{sql_esc(p['job_a'])}', '{sql_esc(p['ibu'])}', '{sql_esc(p['job_i'])}', '{p['hp']}', '{sql_esc(p['addr'])}')" for p in parents]) + ";")
print("\n-- FASE 2: tb_siswa")
print("INSERT IGNORE INTO `tb_siswa` (`no_induk`, `nama_siswa`, `jenis_kelamin`, `id_ortu`, `status_aktif`) VALUES")
print(",\n".join([f"('{s['nisn']}', '{sql_esc(s['name'])}', '{s['gender']}', {s['ortu_id']}, '{s['status']}')" for s in all_students]) + ";")
print("\n-- FASE 3: tb_anggota_kelas")
print("INSERT IGNORE INTO `tb_anggota_kelas` (`id_anggota`, `no_induk`, `id_kelas`, `id_tahun`, `poin_kelakuan`, `poin_kerajinan`, `poin_kerapian`, `total_poin_umum`, `status_sp_terakhir`) VALUES")
ak_rows = []
for a in anggota_kelas:
    s = stats[a['id']]
    sp = 'Sanksi oleh Sekolah' if s['kelakuan'] >= 2000 else 'SP3' if s['kelakuan'] >= 1500 else 'SP2' if s['kelakuan'] >= 750 else 'SP1' if s['kelakuan'] >= 250 else 'Aman'
    ak_rows.append(f"({a['id']}, '{a['no_induk']}', {a['kelas']}, {a['tahun']}, {s['kelakuan']}, {s['kerajinan']}, {s['kerapian']}, {sum(s.values())}, '{sp}')")
print(",\n".join(ak_rows) + ";")
print("\n-- FASE 4: Violations")
print("INSERT IGNORE INTO `tb_pelanggaran_header` (`id_transaksi`, `id_anggota`, `id_guru`, `id_tahun`, `tanggal`, `waktu`, `status_revisi`) VALUES")
print(",\n".join([f"({h['id']}, {h['id_a']}, {h['id_g']}, {h['id_t']}, '{h['date']}', '{h['time']}', '{h['rev']}')" for h in v_header]) + ";")
print("\nINSERT IGNORE INTO `tb_pelanggaran_detail` (`id_detail`, `id_transaksi`, `id_jenis`, `poin_saat_itu`) VALUES")
print(",\n".join([f"({d['id']}, {d['id_h']}, {d['id_j']}, {d['poin']})" for d in v_detail]) + ";")
print("\n-- FASE 5: SP & Feedback")
print("INSERT IGNORE INTO `tb_riwayat_sp` (`id_sp`, `id_anggota`, `tingkat_sp`, `kategori_pemicu`, `tanggal_terbit`, `status`) VALUES")
print(",\n".join([f"({r['id']}, {r['id_a']}, '{r['lvl']}', '{r['cat']}', '{r['date']}', 'Selesai')" for r in riwayat_sp]) + ";")
print("\nINSERT IGNORE INTO `tb_feedback_ortu` (`id_feedback`, `id_ortu`, `id_sp`, `isi_feedback`, `status_baca`) VALUES")
print(",\n".join([f"({f['id']}, {f['id_o']}, {f['id_sp']}, '{sql_esc(f['txt'])}', 'Sudah Dibaca')" for f in feedback]) + ";")
print("\nSET FOREIGN_KEY_CHECKS = 1;")
