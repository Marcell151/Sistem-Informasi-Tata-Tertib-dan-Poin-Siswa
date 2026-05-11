-- DUMMY DATA RICH SCENARIO SITAPSI 2 (SUPER RICH VERSION - 90+ STUDENTS)
-- Menggunakan database db_sitapsi
-- Tanggal Simulasi: 26 April 2026 (Semester Genap 2025/2026)

USE db_sitapsi;

-- 1. SETUP TAHUN AJARAN (3 TAHUN TERAKHIR)
TRUNCATE TABLE tb_tahun_ajaran;
INSERT INTO tb_tahun_ajaran (id_tahun, nama_tahun, status, semester_aktif) VALUES 
(1, '2023/2024', 'Arsip', 'Genap'),
(2, '2024/2025', 'Arsip', 'Genap'),
(3, '2025/2026', 'Aktif', 'Genap');

-- 2. DATA ORANG TUA (SKENARIO BERAGAM)
TRUNCATE TABLE tb_orang_tua;
INSERT INTO tb_orang_tua (id_ortu, nik_ortu, password, nama_ayah, pekerjaan_ayah, nama_ibu, pekerjaan_ibu, no_hp_ortu, alamat) VALUES
(1, '3573010000000001', MD5('ortu123'), 'Bpk. Wijaya', 'Pengusaha', 'Ibu Wijaya', 'Ibu Rumah Tangga', '08111111111', 'Jl. Ijen No. 10, Malang'),
(2, '3573010000000002', MD5('ortu123'), 'Bpk. Pratama', 'PNS', 'Ibu Pratama', 'Guru', '08222222222', 'Jl. Sukarno Hatta No. 5, Malang'),
(3, '3573010000000003', MD5('ortu123'), 'Bpk. Tan', 'Arsitek', 'Ibu Tan', 'Desainer', '08333333333', 'Komp. Permata Jingga Blok A, Malang'),
(4, '3573010000000004', MD5('ortu123'), 'Bpk. Kusuma', 'Dokter', 'Ibu Kusuma', 'Apoteker', '08444444444', 'Jl. Borobudur No. 1, Malang'),
(5, '3573010000000005', MD5('ortu123'), 'Bpk. Raharjo', 'Wiraswasta', 'Ibu Raharjo', 'Pedagang', '08555555555', 'Jl. Dinoyo No. 44, Malang'),
(6, '3573010000000006', MD5('ortu123'), 'Bpk. Santoso', 'Karyawan', 'Ibu Santoso', 'Guru', '08666666666', 'Jl. Arjosari, Malang'),
(7, '3573010000000007', MD5('ortu123'), 'Bpk. Budiman', 'Polisi', 'Ibu Budiman', 'Perawat', '08777777777', 'Jl. Sawojajar, Malang'),
(8, '3573010000000008', MD5('ortu123'), 'Bpk. Setiawan', 'Sopir', 'Ibu Setiawan', 'Pedagang', '08888888888', 'Jl. Blimbing, Malang');

-- 3. DATA SISWA (5-8 SISWA PER KELAS, NAMA REAL)
TRUNCATE TABLE tb_siswa;
INSERT INTO tb_siswa (no_induk, nama_siswa, jenis_kelamin, kota, tanggal_lahir, alamat, id_ortu, status_aktif) VALUES
-- VII A (ID Kelas 1)
('SIS7A01', 'Aditya Pratama', 'L', 'Malang', '2013-01-01', 'Malang', 2, 'Aktif'),
('SIS7A02', 'Bening Wijaya', 'P', 'Malang', '2013-05-12', 'Malang', 1, 'Aktif'),
('SIS7A03', 'Citra Lestari', 'P', 'Malang', '2013-02-02', 'Malang', NULL, 'Aktif'),
('SIS7A04', 'Deni Setiawan', 'L', 'Malang', '2013-03-03', 'Malang', NULL, 'Aktif'),
('SIS7A05', 'Eka Putri', 'P', 'Malang', '2013-04-04', 'Malang', NULL, 'Aktif'),
('SIS7A06', 'Fajar Ramadhan', 'L', 'Malang', '2013-05-05', 'Malang', NULL, 'Aktif'),
-- VII B (ID Kelas 2)
('SIS7B01', 'Bintang Wijaya', 'L', 'Malang', '2013-05-12', 'Malang', 1, 'Aktif'),
('SIS7B02', 'Gita Permata', 'P', 'Malang', '2013-06-06', 'Malang', NULL, 'Aktif'),
('SIS7B03', 'Hendra Kusuma', 'L', 'Malang', '2013-07-07', 'Malang', 4, 'Aktif'),
('SIS7B04', 'Indah Sari', 'P', 'Malang', '2013-08-08', 'Malang', NULL, 'Aktif'),
('SIS7B05', 'Jaka Tarub', 'L', 'Malang', '2013-09-09', 'Malang', NULL, 'Aktif'),
('SIS7B06', 'Kartika Ajeng', 'P', 'Malang', '2013-10-10', 'Malang', NULL, 'Aktif'),
-- VII C (ID Kelas 3)
('SIS7C01', 'Luthfi Hakim', 'L', 'Malang', '2013-11-11', 'Malang', NULL, 'Aktif'),
('SIS7C02', 'Maya Sofia', 'P', 'Malang', '2013-12-12', 'Malang', NULL, 'Aktif'),
('SIS7C03', 'Naufal Rizky', 'L', 'Malang', '2013-01-15', 'Malang', NULL, 'Aktif'),
('SIS7C04', 'Olivia Zalianty', 'P', 'Malang', '2013-02-20', 'Malang', NULL, 'Aktif'),
('SIS7C05', 'Panji Gumilang', 'L', 'Malang', '2013-03-25', 'Malang', NULL, 'Aktif'),
-- VII D (ID Kelas 4)
('SIS7D01', 'Qori Antika', 'P', 'Malang', '2013-04-10', 'Malang', NULL, 'Aktif'),
('SIS7D02', 'Rendi Pangalila', 'L', 'Malang', '2013-05-15', 'Malang', NULL, 'Aktif'),
('SIS7D03', 'Siska Kohl', 'P', 'Malang', '2013-06-20', 'Malang', NULL, 'Aktif'),
('SIS7D04', 'Tegar Felix', 'L', 'Malang', '2013-07-25', 'Malang', NULL, 'Aktif'),
('SIS7D05', 'Uli Permata', 'P', 'Malang', '2013-08-30', 'Malang', NULL, 'Aktif'),
-- VII E (ID Kelas 5)
('SIS7E01', 'Vino G Bastian', 'L', 'Malang', '2013-09-05', 'Malang', NULL, 'Aktif'),
('SIS7E02', 'Wanda Hara', 'P', 'Malang', '2013-10-10', 'Malang', NULL, 'Aktif'),
('SIS7E03', 'Xavi Hernan', 'L', 'Malang', '2013-11-15', 'Malang', NULL, 'Aktif'),
('SIS7E04', 'Yuni Shara', 'P', 'Malang', '2013-12-20', 'Malang', NULL, 'Aktif'),
('SIS7E05', 'Zaskia Gotik', 'P', 'Malang', '2013-01-25', 'Malang', NULL, 'Aktif'),
-- VIII A (ID Kelas 6)
('SIS8A01', 'Agung Hapsah', 'L', 'Malang', '2012-02-02', 'Malang', NULL, 'Aktif'),
('SIS8A02', 'Baim Wong', 'L', 'Malang', '2012-03-03', 'Malang', NULL, 'Aktif'),
('SIS8A03', 'Cinta Laura', 'P', 'Malang', '2012-04-04', 'Malang', NULL, 'Aktif'),
('SIS8A04', 'Desta Mahendra', 'L', 'Malang', '2012-05-05', 'Malang', NULL, 'Aktif'),
('SIS8A05', 'Enzy Storia', 'P', 'Malang', '2012-06-06', 'Malang', NULL, 'Aktif'),
-- VIII B (ID Kelas 7)
('SIS8B01', 'Fedi Nuril', 'L', 'Malang', '2012-07-07', 'Malang', NULL, 'Aktif'),
('SIS8B02', 'Gading Marten', 'L', 'Malang', '2012-08-08', 'Malang', NULL, 'Aktif'),
('SIS8B03', 'Hesti Purwadinata', 'P', 'Malang', '2012-09-09', 'Malang', NULL, 'Aktif'),
('SIS8B04', 'Irfan Hakim', 'L', 'Malang', '2012-10-10', 'Malang', NULL, 'Aktif'),
('SIS8B05', 'Jessica Iskandar', 'P', 'Malang', '2012-11-11', 'Malang', NULL, 'Aktif'),
-- VIII C (ID Kelas 8)
('SIS8C01', 'Kezia Warouw', 'P', 'Malang', '2012-12-12', 'Malang', NULL, 'Aktif'),
('SIS8C02', 'Lesti Kejora', 'P', 'Malang', '2012-01-01', 'Malang', NULL, 'Aktif'),
('SIS8C03', 'Muhammad Rizky', 'L', 'Malang', '2012-02-05', 'Malang', NULL, 'Aktif'),
('SIS8C04', 'Najwa Shihab', 'P', 'Malang', '2012-03-10', 'Malang', NULL, 'Aktif'),
('SIS8C05', 'Onadio Leo', 'L', 'Malang', '2012-04-15', 'Malang', NULL, 'Aktif'),
-- VIII D (ID Kelas 9)
('SIS8D01', 'Pevita Pearce', 'P', 'Malang', '2012-05-20', 'Malang', NULL, 'Aktif'),
('SIS8D02', 'Quentin Stan', 'L', 'Malang', '2012-06-25', 'Malang', NULL, 'Aktif'),
('SIS8D03', 'Raffi Ahmad', 'L', 'Malang', '2012-07-30', 'Malang', NULL, 'Aktif'),
('SIS8D04', 'Sule Prikitiw', 'L', 'Malang', '2012-08-05', 'Malang', NULL, 'Aktif'),
('SIS8D05', 'Tulus Rusedi', 'L', 'Malang', '2012-09-10', 'Malang', NULL, 'Aktif'),
-- VIII E (ID Kelas 10)
('SIS8E01', 'Uus Rizky', 'L', 'Malang', '2012-10-15', 'Malang', NULL, 'Aktif'),
('SIS8E02', 'Vidi Aldiano', 'L', 'Malang', '2012-11-20', 'Malang', NULL, 'Aktif'),
('SIS8E03', 'Wilona Natasha', 'P', 'Malang', '2012-12-25', 'Malang', NULL, 'Aktif'),
('SIS8E04', 'Xylone Lee', 'L', 'Malang', '2012-01-30', 'Malang', NULL, 'Aktif'),
('SIS8E05', 'Yura Yunita', 'P', 'Malang', '2012-02-05', 'Malang', NULL, 'Aktif'),
-- IX A (ID Kelas 11)
('SIS9A01', 'Andhika Wijaya Sr', 'L', 'Malang', '2010-01-10', 'Malang', 1, 'Aktif'),
('SIS9A02', 'Edward Tan', 'L', 'Malang', '2011-11-11', 'Malang', 3, 'Aktif'),
('SIS9A03', 'Edwin Tan', 'L', 'Malang', '2011-11-11', 'Malang', 3, 'Aktif'),
('SIS9A04', 'Ziva Magnolya', 'P', 'Malang', '2011-03-15', 'Malang', NULL, 'Aktif'),
('SIS9A05', 'Ariel Noah', 'L', 'Malang', '2011-04-20', 'Malang', NULL, 'Aktif'),
-- IX B (ID Kelas 12)
('SIS9B01', 'Bunga Citra', 'P', 'Malang', '2011-05-25', 'Malang', NULL, 'Aktif'),
('SIS9B02', 'Chico Jericho', 'L', 'Malang', '2011-06-30', 'Malang', NULL, 'Aktif'),
('SIS9B03', 'Dian Sastro', 'P', 'Malang', '2011-07-05', 'Malang', NULL, 'Aktif'),
('SIS9B04', 'Ello Tahitoe', 'L', 'Malang', '2011-08-10', 'Malang', NULL, 'Aktif'),
('SIS9B05', 'Fatin Shidqia', 'P', 'Malang', '2011-09-15', 'Malang', NULL, 'Aktif'),
-- IX C (ID Kelas 13)
('SIS9C01', 'Giring Ganesha', 'L', 'Malang', '2011-10-20', 'Malang', NULL, 'Aktif'),
('SIS9C02', 'Isyana Sarasvati', 'P', 'Malang', '2011-11-25', 'Malang', NULL, 'Aktif'),
('SIS9C03', 'Judika Sihotang', 'L', 'Malang', '2011-12-30', 'Malang', NULL, 'Aktif'),
('SIS9C04', 'Krisdayanti', 'P', 'Malang', '2011-01-05', 'Malang', NULL, 'Aktif'),
('SIS9C05', 'Lyodra Ginting', 'P', 'Malang', '2011-02-10', 'Malang', NULL, 'Aktif'),
-- IX D (ID Kelas 14)
('SIS9D01', 'Maia Estianty', 'P', 'Malang', '2011-03-15', 'Malang', NULL, 'Aktif'),
('SIS9D02', 'Nicky Astria', 'P', 'Malang', '2011-04-20', 'Malang', NULL, 'Aktif'),
('SIS9D03', 'Once Mekel', 'L', 'Malang', '2011-05-25', 'Malang', NULL, 'Aktif'),
('SIS9D04', 'Pasha Ungu', 'L', 'Malang', '2011-06-30', 'Malang', NULL, 'Aktif'),
('SIS9D05', 'Raisa Andriana', 'P', 'Malang', '2011-07-05', 'Malang', NULL, 'Aktif'),
-- IX E (ID Kelas 15)
('SIS9E01', 'Sheila Dara', 'P', 'Malang', '2011-08-10', 'Malang', NULL, 'Aktif'),
('SIS9E02', 'Tora Sudiro', 'L', 'Malang', '2011-09-15', 'Malang', NULL, 'Aktif'),
('SIS9E03', 'Ungu Pasha', 'L', 'Malang', '2011-10-20', 'Malang', NULL, 'Aktif'),
('SIS9E04', 'Vina Panduwinata', 'P', 'Malang', '2011-11-25', 'Malang', NULL, 'Aktif'),
('SIS9E05', 'Wizzy Williana', 'P', 'Malang', '2011-12-30', 'Malang', NULL, 'Aktif'),
-- Data Lulus (Historical)
('SISLUL01', 'Candra Pratama', 'L', 'Malang', '2008-01-01', 'Malang', 2, 'Lulus'),
('SISLUL02', 'Dina Pratama Sr', 'P', 'Malang', '2008-01-01', 'Malang', 2, 'Lulus');

-- 4. ANGGOTA KELAS (MAPPING PERIODE)
TRUNCATE TABLE tb_anggota_kelas;
INSERT INTO tb_anggota_kelas (id_anggota, no_induk, id_kelas, id_tahun, poin_kelakuan, poin_kerajinan, poin_kerapian, total_poin_umum, status_sp_terakhir) VALUES
-- TAHUN AKTIF 2025/2026 (ID Tahun 3) - Semester Genap saat ini
(1, 'SIS7A01', 1, 3, 20, 0, 0, 20, 'Aman'),
(2, 'SIS7A02', 1, 3, 0, 0, 0, 0, 'Aman'),
(3, 'SIS7A03', 1, 3, 0, 0, 0, 0, 'Aman'),
(4, 'SIS7A04', 1, 3, 0, 0, 0, 0, 'Aman'),
(5, 'SIS7A05', 1, 3, 0, 0, 0, 0, 'Aman'),
(6, 'SIS7B01', 2, 3, 0, 25, 0, 25, 'Aman'),
(7, 'SIS7B02', 2, 3, 0, 0, 0, 0, 'Aman'),
(8, 'SIS7B03', 2, 3, 0, 0, 0, 0, 'Aman'),
(9, 'SIS7C01', 3, 3, 0, 0, 100, 100, 'SP1'),
(10, 'SIS7C02', 3, 3, 0, 0, 0, 0, 'Aman'),
(11, 'SIS7D01', 4, 3, 0, 0, 0, 0, 'Aman'),
(12, 'SIS7E01', 5, 3, 0, 0, 0, 0, 'Aman'),
(13, 'SIS8A01', 6, 3, 300, 0, 0, 300, 'SP1'),
(14, 'SIS8A02', 6, 3, 0, 0, 0, 0, 'Aman'),
(15, 'SIS8B01', 7, 3, 0, 0, 0, 0, 'Aman'),
(16, 'SIS8C01', 8, 3, 0, 450, 0, 450, 'SP3'),
(17, 'SIS8D01', 9, 3, 0, 0, 0, 0, 'Aman'),
(18, 'SIS8E01', 10, 3, 0, 0, 0, 0, 'Aman'),
(19, 'SIS9A01', 11, 3, 0, 0, 0, 0, 'Aman'),
(20, 'SIS9A02', 11, 3, 50, 0, 0, 50, 'Aman'),
(21, 'SIS9A03', 11, 3, 0, 0, 0, 0, 'Aman'),
(22, 'SIS9B01', 12, 3, 0, 0, 0, 0, 'Aman'),
(23, 'SIS9C01', 13, 3, 1000, 0, 0, 1000, 'SP2'),
(24, 'SIS9D01', 14, 3, 0, 0, 0, 0, 'Aman'),
(25, 'SIS9E01', 15, 3, 0, 0, 0, 0, 'Aman'),
-- Data Historis 2024/2025 (ID Tahun 2)
(101, 'SIS9A01', 6, 2, 100, 50, 50, 200, 'Aman'),
(102, 'SIS8A01', 1, 2, 0, 0, 0, 0, 'Aman');

-- 5. TRANSAKSI PELANGGARAN (AUDIT LENGKAP GANJIL & GENAP)
TRUNCATE TABLE tb_pelanggaran_header;
TRUNCATE TABLE tb_pelanggaran_detail;

-- TAHUN 2024/2025 (ARSIP GANJIL & GENAP)
INSERT INTO tb_pelanggaran_header (id_transaksi, id_anggota, id_guru, id_tahun, tanggal, waktu, semester, tipe_form) VALUES
(1, 101, 5, 2, '2024-09-10', '07:30:00', 'Ganjil', 'Kelas'),
(2, 101, 2, 2, '2025-02-12', '08:00:00', 'Genap', 'Piket');

-- TAHUN 2025/2026 (TAHUN AKTIF)
-- SEMESTER GANJIL 2025 (History)
INSERT INTO tb_pelanggaran_header (id_transaksi, id_anggota, id_guru, id_tahun, tanggal, waktu, semester, tipe_form) VALUES
(3, 13, 4, 3, '2025-10-05', '09:00:00', 'Ganjil', 'Kelas'), -- Agung 8A
(4, 23, 1, 3, '2025-11-20', '10:30:00', 'Ganjil', 'Kelas'); -- Giring 9C

-- SEMESTER GENAP 2026 (DIPERBANYAK - APRIL 2026)
INSERT INTO tb_pelanggaran_header (id_transaksi, id_anggota, id_guru, id_tahun, tanggal, waktu, semester, tipe_form) VALUES
(5, 1, 5, 3, '2026-01-10', '07:15:00', 'Genap', 'Piket'), -- Aditya 7A
(6, 6, 2, 3, '2026-02-15', '07:20:00', 'Genap', 'Piket'), -- Bintang 7B
(7, 9, 8, 3, '2026-03-05', '08:00:00', 'Genap', 'Kelas'), -- Luthfi 7C (SP1 Kerapian)
(8, 16, 12, 3, '2026-03-12', '07:45:00', 'Genap', 'Piket'), -- Kezia 8C (SP3 Kerajinan)
(9, 13, 1, 3, '2026-04-01', '09:00:00', 'Genap', 'Kelas'), -- Agung 8A (SP1 Kelakuan)
(10, 23, 1, 3, '2026-04-10', '11:00:00', 'Genap', 'Kelas'), -- Giring 9C (SP2 Kelakuan)
(11, 20, 4, 3, '2026-04-15', '10:00:00', 'Genap', 'Kelas'); -- Edward 9A

-- DETAIL PELANGGARAN
INSERT INTO tb_pelanggaran_detail (id_transaksi, id_jenis, poin_saat_itu) VALUES
(1, 62, 50), (2, 58, 50),
(3, 4, 500), (4, 25, 300),
(5, 70, 25), (6, 38, 25),
(7, 66, 100), (8, 42, 500),
(9, 3, 100), (10, 18, 500),
(11, 31, 50);

-- 6. RIWAYAT SP
TRUNCATE TABLE tb_riwayat_sp;
INSERT INTO tb_riwayat_sp (id_sp, id_anggota, tingkat_sp, kategori_pemicu, tanggal_terbit, status, id_admin) VALUES
(1, 9, 'SP1', 'KERAPIAN', '2026-03-06', 'Selesai', 2),
(2, 16, 'SP3', 'KERAJINAN', '2026-03-13', 'Pending', NULL),
(3, 13, 'SP1', 'KELAKUAN', '2026-04-02', 'Selesai', 2),
(4, 23, 'SP2', 'KELAKUAN', '2026-04-11', 'Pending', NULL);

-- 7. FEEDBACK ORANG TUA
TRUNCATE TABLE tb_feedback_ortu;
INSERT INTO tb_feedback_ortu (id_ortu, id_sp, isi_feedback, status_baca) VALUES
(1, 1, 'Terima kasih, Andhika sudah kami potong rambutnya.', 'Sudah Dibaca'),
(8, 2, 'Mohon maaf, Kezia sakit sehingga tidak ikut olahraga. Surat menyusul.', 'Belum Dibaca');
