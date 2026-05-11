-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 03 Bulan Mei 2026 pada 18.42
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Database: `db_portal1`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_admin`
--

CREATE TABLE `tb_admin` (
  `id_admin` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nama_lengkap` varchar(100) NOT NULL,
  `role` enum('AdminPusat','Admin','KepalaSekolah') DEFAULT 'Admin',
  `status` enum('Aktif','Suspend') DEFAULT 'Aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_admin` (`id_admin`, `username`, `password`, `nama_lengkap`, `role`, `status`, `created_at`) VALUES
(1, 'admin', 'admin123', 'Admin SITAPSI', 'AdminPusat', 'Aktif', '2026-04-20 11:39:16'),
(2, 'admintatib', 'admin123', 'Tim Kedisiplinan', 'Admin', 'Aktif', '2026-04-20 11:39:16'),
(3, 'kepsek', 'kepsek123', 'Kepala Sekolah', 'KepalaSekolah', 'Aktif', '2026-04-20 11:39:16');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_tahun_ajaran`
--

CREATE TABLE `tb_tahun_ajaran` (
  `id_tahun` int(11) NOT NULL,
  `nama_tahun` varchar(20) NOT NULL,
  `status` enum('Aktif','Arsip') DEFAULT 'Aktif',
  `semester_aktif` enum('Ganjil','Genap') DEFAULT 'Ganjil'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_tahun_ajaran` (`id_tahun`, `nama_tahun`, `status`, `semester_aktif`) VALUES
(1, '2023/2024', 'Arsip', 'Genap'),
(2, '2024/2025', 'Arsip', 'Genap'),
(3, '2025/2026', 'Aktif', 'Genap');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_kelas`
--

CREATE TABLE `tb_kelas` (
  `id_kelas` int(11) NOT NULL,
  `nama_kelas` varchar(10) NOT NULL,
  `tingkat` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_kelas` (`id_kelas`, `nama_kelas`, `tingkat`) VALUES
(1, 'VII A', 7), (2, 'VII B', 7), (3, 'VII C', 7), (4, 'VII D', 7), (5, 'VII E', 7),
(6, 'VIII A', 8), (7, 'VIII B', 8), (8, 'VIII C', 8), (9, 'VIII D', 8), (10, 'VIII E', 8),
(11, 'IX A', 9), (12, 'IX B', 9), (13, 'IX C', 9), (14, 'IX D', 9), (15, 'IX E', 9);

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_kategori_pelanggaran`
--

CREATE TABLE `tb_kategori_pelanggaran` (
  `id_kategori` int(11) NOT NULL,
  `nama_kategori` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_kategori_pelanggaran` (`id_kategori`, `nama_kategori`) VALUES
(1, 'KELAKUAN'), (2, 'KERAJINAN'), (3, 'KERAPIAN');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_jenis_pelanggaran`
--

CREATE TABLE `tb_jenis_pelanggaran` (
  `id_jenis` int(11) NOT NULL,
  `id_kategori` int(11) NOT NULL,
  `sub_kategori` varchar(100) DEFAULT NULL,
  `nama_pelanggaran` text NOT NULL,
  `poin_default` int(11) NOT NULL,
  `sanksi_default` varchar(50) DEFAULT NULL,
  `status` enum('Aktif','Non-Aktif') DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_jenis_pelanggaran` (`id_jenis`, `id_kategori`, `sub_kategori`, `nama_pelanggaran`, `poin_default`, `sanksi_default`, `status`) VALUES
(1, 1, '01. Kegiatan Sekolah', 'Tidak mengikuti kegiatan wajib sekolah / upacara tanpa keterangan.', 100, '5', 'Aktif'),
(2, 1, '01. Kegiatan Sekolah', 'Bergurau/tidak tertib saat kegiatan berlangsung', 100, '5', 'Aktif'),
(3, 1, '02. Sikap & Moral', 'Berkata tidak sopan/kasar/jorok', 100, '1', 'Aktif'),
(4, 1, '02. Sikap & Moral', 'Mencuri/memalak/meminta paksa', 500, '1,4,7', 'Aktif'),
(5, 1, '02. Sikap & Moral', 'Berbohong', 100, '1', 'Aktif'),
(6, 1, '02. Sikap & Moral', 'Menghina/mengejek Guru/Karyawan', 200, '1,5', 'Aktif'),
(7, 1, '02. Sikap & Moral', 'Menghina/mengejek Siswa/Teman', 100, '1', 'Aktif'),
(8, 1, '02. Sikap & Moral', 'Perundungan (Bullying)', 100, '1,5,7,8,9', 'Aktif'),
(9, 1, '02. Sikap & Moral', 'Membanting pintu/melempar benda', 100, '1', 'Aktif'),
(10, 1, '02. Sikap & Moral', 'Memanggil ortu dengan sebutan tidak sopan', 100, '1,2,5,8', 'Aktif'),
(11, 1, '02. Sikap & Moral', 'Bersikap tidak sopan (duduk di meja dll)', 100, '1,2', 'Aktif'),
(12, 1, '02. Sikap & Moral', 'Merayakan HUT teman secara negatif', 100, '1,5', 'Aktif'),
(13, 1, '02. Sikap & Moral', 'Memicu keributan di medsos/sekolah', 100, '1,2,7,8', 'Aktif'),
(14, 1, '02. Sikap & Moral', 'Membiarkan/mendorong kerusakan fasilitas', 100, '1,3', 'Aktif'),
(15, 1, '02. Sikap & Moral', 'Membiarkan teman celaka/sakit', 100, '1,2,7,8', 'Aktif'),
(16, 1, '03. Dokumen', 'Memalsukan surat/tanda tangan', 300, '7', 'Aktif'),
(17, 1, '04. Rokok & Miras', 'Membawa rokok', 300, '7,8', 'Aktif'),
(18, 1, '04. Rokok & Miras', 'Merokok (langsung/medsos)', 500, '7,8,9,10', 'Aktif'),
(19, 1, '04. Rokok & Miras', 'Membawa minuman keras', 300, '7,8', 'Aktif'),
(20, 1, '04. Rokok & Miras', 'Meminum minuman keras', 500, '7,8,9,10', 'Aktif'),
(21, 1, '05. NAPZA', 'Membawa/mengedarkan/menggunakan NAPZA', 9999, '10', 'Aktif'),
(22, 1, '06. Pelecehan Seksual', 'Membawa/akses/sebar konten porno', 300, '1,7', 'Aktif'),
(23, 1, '06. Pelecehan Seksual', 'Melakukan tindakan Pelecehan Seksual', 500, '1,7,8,9', 'Aktif'),
(24, 1, '07. Kekerasan', 'Terlibat perkelahian/main hakim sendiri', 300, '1,2,7,8,9', 'Aktif'),
(25, 1, '07. Kekerasan', 'Mengancam Kepala Sekolah/Guru/Karyawan', 300, '10', 'Aktif'),
(26, 1, '07. Kekerasan', 'Tindak kriminal terbukti hukum', 9999, '10', 'Aktif'),
(27, 1, '08. Gank', 'Terlibat Gank negatif', 300, '1,7,8', 'Aktif'),
(28, 1, '09. Sarana Prasarana', 'Mencorat-coret/merusak sarana sekolah', 75, '1,3', 'Aktif'),
(29, 1, '09. Sarana Prasarana', 'Bermain alat PBM/sapu di kelas', 75, '1,3', 'Aktif'),
(30, 1, '09. Sarana Prasarana', 'Makan dan minum di dalam kelas', 50, '1,2', 'Aktif'),
(31, 1, '10. Ketertiban PBM', 'Ramai/tidak memperhatikan saat PBM', 50, '1,2', 'Aktif'),
(32, 1, '10. Ketertiban PBM', 'Keluar kelas saat PBM tanpa izin', 50, '1,2', 'Aktif'),
(33, 1, '10. Ketertiban PBM', 'Menyontek saat ulangan', 300, '1,5', 'Aktif'),
(34, 1, '10. Ketertiban PBM', 'Mengambil alat PBM teman tanpa izin', 50, '1,2', 'Aktif'),
(35, 1, '10. Ketertiban PBM', 'Penyalahgunaan HP saat PBM', 50, '1,2', 'Aktif'),
(36, 1, '11. 10 K', 'Tidak mendukung 10 K', 50, '1,2,6', 'Aktif'),
(37, 1, '12. Kendaraan', 'Mengendarai kendaraan bermotor sendiri', 300, '1,7,8,9', 'Aktif'),
(38, 2, '01. Kehadiran', 'Terlambat sekolah/tambahan/ekstra', 25, '2,5,7,8', 'Aktif'),
(39, 2, '02. Efektif Sekolah', 'Tidak hadir tanpa keterangan (Alpa)', 75, '7,8', 'Aktif'),
(40, 2, '02. Efektif Sekolah', 'Meninggalkan sekolah saat PBM (Bolos)', 75, '7,8', 'Aktif'),
(41, 2, '03. PBM', 'Tidak masuk kelas jam pertama', 300, '1,7', 'Aktif'),
(42, 2, '03. PBM', 'Tidak ikut olahraga/praktikum tanpa izin', 500, '1,7,8,9', 'Aktif'),
(43, 2, '04. Perlengkapan', 'Tidak bawa buku pelajaran', 50, '1,2', 'Aktif'),
(44, 2, '04. Perlengkapan', 'Buku catatan campur/tidak rapi', 50, '1,2', 'Aktif'),
(45, 2, '04. Perlengkapan', 'Tidak bawa LKS/PR/Tugas', 50, '1,2', 'Aktif'),
(46, 2, '04. Perlengkapan', 'Membawa barang non-PBM', 75, '7,8', 'Aktif'),
(47, 2, '04. Perlengkapan', 'Tidak membawa buku tatib/literasi', 25, '1', 'Aktif'),
(48, 2, '05. Tugas', 'Mencontoh PR/Tugas', 50, '2', 'Aktif'),
(49, 2, '05. Tugas', 'Tidak mengumpulkan PR/Tugas', 50, '2', 'Aktif'),
(50, 2, '06. Ekstrakurikuler', 'Tidak ikut ekstra tanpa izin', 50, '7,8', 'Aktif'),
(51, 2, '06. Ekstrakurikuler', 'Ramai saat kegiatan ekstra', 50, '2', 'Aktif'),
(52, 2, '06. Ekstrakurikuler', 'Tidak ikut tambahan pelajaran', 50, '7', 'Aktif'),
(53, 3, '01. Seragam', 'Seragam tidak sesuai ketentuan', 75, '1,2,5,7', 'Aktif'),
(54, 3, '01. Seragam', 'Pakai rompi/jaket hanya aksesoris', 75, '1,2,5,7', 'Aktif'),
(55, 3, '01. Seragam', 'Seragam olahraga dari rumah/saat pulang', 50, '1', 'Aktif'),
(56, 3, '01. Seragam', 'Tidak pakai kaos dalam', 50, '1', 'Aktif'),
(57, 3, '01. Seragam', 'Atribut tidak lengkap (topi/dasi/sabuk/dll)', 50, '1', 'Aktif'),
(58, 3, '01. Seragam', 'Kaos kaki pendek/warna-warni/sepatu non-hitam', 50, '5', 'Aktif'),
(59, 3, '01. Seragam', 'Seragam dicoret-coret', 100, '1', 'Aktif'),
(60, 3, '01. Seragam', 'Mencoret anggota tubuh', 100, '1', 'Aktif'),
(61, 3, '01. Seragam', 'Baju tidak dimasukkan/rok-celana tidak standar', 50, '1,2,5,7', 'Aktif'),
(62, 3, '02. Aksesoris', 'Perhiasan/aksesoris berlebihan', 50, '1', 'Aktif'),
(63, 3, '02. Aksesoris', 'Putra memakai gelang/anting/kalung', 50, '1', 'Aktif'),
(64, 3, '02. Aksesoris', 'Putri memakai gelang/double anting', 50, '1', 'Aktif'),
(65, 3, '02. Aksesoris', 'Kuku panjang/dicat', 50, '1', 'Aktif'),
(66, 3, '03. Rambut', 'Rambut dicat', 100, '1,7', 'Aktif'),
(67, 3, '03. Rambut', 'Putra rambut panjang/gundul', 50, '1', 'Aktif'),
(68, 3, '03. Rambut', 'Rambut menutupi wajah/tidak rapi', 50, '1', 'Aktif'),
(69, 3, '04. Kegiatan', 'Tidak rapi/bersepatu saat ekstra/tambahan', 50, '1', 'Aktif'),
(70, 3, '05. Sepeda', 'Parkir sepeda tidak teratur/tidak dikunci', 25, '1', 'Aktif');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_sanksi_ref`
--

CREATE TABLE `tb_sanksi_ref` (
  `id_sanksi_ref` int(11) NOT NULL,
  `kode_sanksi` varchar(5) NOT NULL,
  `deskripsi` text NOT NULL,
  `status` enum('Aktif','Non-Aktif') DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_sanksi_ref` (`id_sanksi_ref`, `kode_sanksi`, `deskripsi`, `status`) VALUES
(1, '1', 'Meminta maaf dan berjanji tidak mengulang', 'Aktif'),
(2, '2', 'Dikeluarkan saat PBM (Proses Belajar Mengajar)', 'Aktif'),
(3, '3', 'Mengganti/memperbaiki fasilitas sekolah yang rusak', 'Aktif'),
(4, '4', 'Mengganti/mengembalikan uang atau barang yang dipinjam/diambil', 'Aktif'),
(5, '5', 'Menjalani pembinaan oleh Wali Kelas', 'Aktif'),
(6, '6', 'Membersihkan lingkungan sekolah', 'Aktif'),
(7, '7', 'Pemanggilan orang tua/wali siswa', 'Aktif'),
(8, '8', 'Menjalani pembinaan oleh BK', 'Aktif'),
(9, '9', 'Menjalani pembinaan khusus oleh Tim Tatib', 'Aktif'),
(10, '10', 'Diserahkan kembali pendidikannya kepada orang tua (Dikeluarkan)', 'Aktif');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_aturan_sp`
--

CREATE TABLE `tb_aturan_sp` (
  `id_aturan_sp` int(11) NOT NULL,
  `id_kategori` int(11) NOT NULL,
  `level_sp` enum('SP1','SP2','SP3','Sanksi oleh Sekolah') NOT NULL,
  `batas_bawah_poin` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_aturan_sp` (`id_aturan_sp`, `id_kategori`, `level_sp`, `batas_bawah_poin`) VALUES
(1, 1, 'SP1', 250), (2, 1, 'SP2', 750), (3, 1, 'SP3', 1500), (4, 1, 'Sanksi oleh Sekolah', 2000),
(5, 2, 'SP1', 75), (6, 2, 'SP2', 300), (7, 2, 'SP3', 450), (8, 2, 'Sanksi oleh Sekolah', 600),
(9, 3, 'SP1', 100), (10, 3, 'SP2', 300), (11, 3, 'SP3', 450), (12, 3, 'Sanksi oleh Sekolah', 600);

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_predikat_nilai`
--

CREATE TABLE `tb_predikat_nilai` (
  `id_predikat` int(11) NOT NULL,
  `id_kategori` int(11) NOT NULL,
  `huruf_mutu` char(1) NOT NULL,
  `batas_bawah` int(11) NOT NULL,
  `batas_atas` int(11) NOT NULL,
  `keterangan` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_predikat_nilai` (`id_predikat`, `id_kategori`, `huruf_mutu`, `batas_bawah`, `batas_atas`, `keterangan`) VALUES
(1, 1, 'A', 0, 49, 'Sangat Baik'), (2, 1, 'B', 50, 249, 'Baik'), (3, 1, 'C', 250, 1499, 'Cukup (SP1/SP2)'), (4, 1, 'D', 1500, 9999, 'Kurang (SP3/Berat)'),
(5, 2, 'A', 0, 24, 'Sangat Baik'), (6, 2, 'B', 25, 74, 'Baik'), (7, 2, 'C', 75, 449, 'Cukup (SP1/SP2)'), (8, 2, 'D', 450, 9999, 'Kurang (SP3/Berat)'),
(9, 3, 'A', 0, 49, 'Sangat Baik'), (10, 3, 'B', 50, 99, 'Baik'), (11, 3, 'C', 100, 449, 'Cukup (SP1/SP2)'), (12, 3, 'D', 450, 9999, 'Kurang (SP3/Berat)');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_orang_tua`
--

CREATE TABLE `tb_orang_tua` (
  `id_ortu` int(11) NOT NULL,
  `nik_ortu` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nama_ayah` varchar(150) DEFAULT NULL,
  `pekerjaan_ayah` varchar(100) DEFAULT NULL,
  `nama_ibu` varchar(150) DEFAULT NULL,
  `pekerjaan_ibu` varchar(100) DEFAULT NULL,
  `no_hp_ortu` varchar(15) DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_orang_tua` (`id_ortu`, `nik_ortu`, `password`, `nama_ayah`, `pekerjaan_ayah`, `nama_ibu`, `pekerjaan_ibu`, `no_hp_ortu`, `alamat`, `is_active`, `created_at`) VALUES
(1, '3573010000000001', 'e10adc3949ba59abbe56e057f20f883e', 'Bpk. Wijaya', 'Pengusaha', 'Ibu Wijaya', 'Ibu Rumah Tangga', '08111111111', 'Jl. Ijen No. 10, Malang', 1, '2026-04-26 08:19:06'),
(2, '3573010000000002', 'e10adc3949ba59abbe56e057f20f883e', 'Bpk. Pratama', 'PNS', 'Ibu Pratama', 'Guru', '08222222222', 'Jl. Sukarno Hatta No. 5, Malang', 1, '2026-04-26 08:19:06'),
(3, '3573010000000003', 'e10adc3949ba59abbe56e057f20f883e', 'Bpk. Tan', 'Arsitek', 'Ibu Tan', 'Desainer', '08333333333', 'Komp. Permata Jingga Blok A, Malang', 1, '2026-04-26 08:19:06'),
(4, '3573010000000004', 'e10adc3949ba59abbe56e057f20f883e', 'Bpk. Kusuma', 'Dokter', 'Ibu Kusuma', 'Apoteker', '08444444444', 'Jl. Borobudur No. 1, Malang', 1, '2026-04-26 08:19:06'),
(5, '3573010000000005', 'e10adc3949ba59abbe56e057f20f883e', 'Bpk. Raharjo', 'Wiraswasta', 'Ibu Raharjo', 'Pedagang', '08555555555', 'Jl. Dinoyo No. 44, Malang', 1, '2026-04-26 08:19:06'),
(6, '3573010000000006', 'e10adc3949ba59abbe56e057f20f883e', 'Bpk. Santoso', 'Karyawan', 'Ibu Santoso', 'Guru', '08666666666', 'Jl. Arjosari, Malang', 1, '2026-04-26 08:19:06'),
(7, '3573010000000007', 'e10adc3949ba59abbe56e057f20f883e', 'Bpk. Budiman', 'Polisi', 'Ibu Budiman', 'Perawat', '08777777777', 'Jl. Sawojajar, Malang', 1, '2026-04-26 08:19:06'),
(8, '3573010000000008', 'e10adc3949ba59abbe56e057f20f883e', 'Bpk. Setiawan', 'Sopir', 'Ibu Setiawan', 'Pedagang', '08888888888', 'Jl. Blimbing, Malang', 1, '2026-04-26 08:19:06'),
(9, '3573010000000009', 'e10adc3949ba59abbe56e057f20f883e', 'Bpk. Hidayat', 'Wiraswasta', 'Ibu Hidayat', 'Karyawan', '08999999999', 'Jl. Sulfat, Malang', 1, '2026-04-26 08:19:06'),
(10, '3573010000000010', 'e10adc3949ba59abbe56e057f20f883e', 'Bpk. Kurniawan', 'TNI', 'Ibu Kurniawan', 'Bidan', '08101010101', 'Jl. Veteran, Malang', 1, '2026-04-26 08:19:06');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_siswa`
--

CREATE TABLE `tb_siswa` (
  `no_induk` varchar(50) NOT NULL,
  `nama_siswa` varchar(100) NOT NULL,
  `jenis_kelamin` enum('L','P') NOT NULL,
  `kota` varchar(100) DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `nama_ayah` varchar(150) DEFAULT NULL,
  `pekerjaan_ayah` varchar(100) DEFAULT NULL,
  `nama_ibu` varchar(150) DEFAULT NULL,
  `pekerjaan_ibu` varchar(100) DEFAULT NULL,
  `no_hp_ortu` varchar(15) DEFAULT NULL,
  `id_ortu` int(11) DEFAULT NULL,
  `status_aktif` enum('Aktif','Lulus','Keluar','Dikeluarkan') DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_siswa` (`no_induk`, `nama_siswa`, `jenis_kelamin`, `kota`, `tanggal_lahir`, `alamat`, `nama_ayah`, `pekerjaan_ayah`, `nama_ibu`, `pekerjaan_ibu`, `no_hp_ortu`, `id_ortu`, `status_aktif`) VALUES
-- VII A (10)
('SIS7A01', 'Aditya Pratama', 'L', 'Malang', '2013-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, 1, 'Aktif'),
('SIS7A02', 'Bening Wijaya', 'P', 'Malang', '2013-05-12', 'Malang', NULL, NULL, NULL, NULL, NULL, 1, 'Aktif'),
('SIS7A03', 'Citra Lestari', 'P', 'Malang', '2013-02-02', 'Malang', NULL, NULL, NULL, NULL, NULL, 2, 'Aktif'),
('SIS7A04', 'Deni Setiawan', 'L', 'Malang', '2013-03-03', 'Malang', NULL, NULL, NULL, NULL, NULL, 2, 'Aktif'),
('SIS7A05', 'Eka Putri', 'P', 'Malang', '2013-04-04', 'Malang', NULL, NULL, NULL, NULL, NULL, 3, 'Aktif'),
('SIS7A06', 'Fajar Ramadhan', 'L', 'Malang', '2013-05-05', 'Malang', NULL, NULL, NULL, NULL, NULL, 3, 'Aktif'),
('SIS7A07', 'Genta Buana', 'L', 'Malang', '2013-06-06', 'Malang', NULL, NULL, NULL, NULL, NULL, 4, 'Aktif'),
('SIS7A08', 'Hana Pertiwi', 'P', 'Malang', '2013-07-07', 'Malang', NULL, NULL, NULL, NULL, NULL, 4, 'Aktif'),
('SIS7A09', 'Ivan Gunawan', 'L', 'Malang', '2013-08-08', 'Malang', NULL, NULL, NULL, NULL, NULL, 5, 'Aktif'),
('SIS7A10', 'Jihan Fahira', 'P', 'Malang', '2013-09-09', 'Malang', NULL, NULL, NULL, NULL, NULL, 5, 'Aktif'),
-- VII B (10)
('SIS7B01', 'Bintang Wijaya', 'L', 'Malang', '2013-05-12', 'Malang', NULL, NULL, NULL, NULL, NULL, 1, 'Aktif'),
('SIS7B02', 'Kaka Slank', 'L', 'Malang', '2013-10-10', 'Malang', NULL, NULL, NULL, NULL, NULL, 6, 'Aktif'),
('SIS7B03', 'Luna Maya', 'P', 'Malang', '2013-11-11', 'Malang', NULL, NULL, NULL, NULL, NULL, 6, 'Aktif'),
('SIS7B04', 'Momo Geisha', 'P', 'Malang', '2013-12-12', 'Malang', NULL, NULL, NULL, NULL, NULL, 7, 'Aktif'),
('SIS7B05', 'Nano-nano', 'L', 'Malang', '2013-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, 7, 'Aktif'),
('SIS7B06', 'Opick Religi', 'L', 'Malang', '2013-02-02', 'Malang', NULL, NULL, NULL, NULL, NULL, 8, 'Aktif'),
('SIS7B07', 'Pasha Ungu Jr', 'L', 'Malang', '2013-03-03', 'Malang', NULL, NULL, NULL, NULL, NULL, 8, 'Aktif'),
('SIS7B08', 'Queen Bee', 'P', 'Malang', '2013-04-04', 'Malang', NULL, NULL, NULL, NULL, NULL, 9, 'Aktif'),
('SIS7B09', 'Rossa Diva', 'P', 'Malang', '2013-05-05', 'Malang', NULL, NULL, NULL, NULL, NULL, 9, 'Aktif'),
('SIS7B10', 'Sule Prikitiw Jr', 'L', 'Malang', '2013-06-06', 'Malang', NULL, NULL, NULL, NULL, NULL, 10, 'Aktif'),
-- VII C (10)
('SIS7C01', 'Anang H', 'L', 'Malang', '2013-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7C02', 'Ashanty', 'P', 'Malang', '2013-02-02', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7C03', 'Aurel H', 'P', 'Malang', '2013-03-03', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7C04', 'Azriel H', 'L', 'Malang', '2013-04-04', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7C05', 'Arsy H', 'P', 'Malang', '2013-05-05', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7C06', 'Arsya H', 'L', 'Malang', '2013-06-06', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7C07', 'Atta H', 'L', 'Malang', '2013-07-07', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7C08', 'Sajidah H', 'P', 'Malang', '2013-08-08', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7C09', 'Thariq H', 'L', 'Malang', '2013-09-09', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7C10', 'Saaih H', 'L', 'Malang', '2013-10-10', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
-- VII D (10)
('SIS7D01', 'Siswa 7D 01', 'L', 'Malang', '2013-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7D02', 'Siswa 7D 02', 'P', 'Malang', '2013-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7D03', 'Siswa 7D 03', 'L', 'Malang', '2013-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7D04', 'Siswa 7D 04', 'P', 'Malang', '2013-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7D05', 'Siswa 7D 05', 'L', 'Malang', '2013-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7D06', 'Siswa 7D 06', 'P', 'Malang', '2013-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7D07', 'Siswa 7D 07', 'L', 'Malang', '2013-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7D08', 'Siswa 7D 08', 'P', 'Malang', '2013-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7D09', 'Siswa 7D 09', 'L', 'Malang', '2013-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7D10', 'Siswa 7D 10', 'P', 'Malang', '2013-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
-- VII E (10)
('SIS7E01', 'Siswa 7E 01', 'L', 'Malang', '2013-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7E02', 'Siswa 7E 02', 'P', 'Malang', '2013-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7E03', 'Siswa 7E 03', 'L', 'Malang', '2013-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7E04', 'Siswa 7E 04', 'P', 'Malang', '2013-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7E05', 'Siswa 7E 05', 'L', 'Malang', '2013-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7E06', 'Siswa 7E 06', 'P', 'Malang', '2013-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7E07', 'Siswa 7E 07', 'L', 'Malang', '2013-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7E08', 'Siswa 7E 08', 'P', 'Malang', '2013-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7E09', 'Siswa 7E 09', 'L', 'Malang', '2013-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7E10', 'Siswa 7E 10', 'P', 'Malang', '2013-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
-- VIII A (10)
('SIS8A01', 'Agung Hapsah', 'L', 'Malang', '2012-02-02', 'Malang', NULL, NULL, NULL, NULL, NULL, 6, 'Aktif'),
('SIS8A02', 'Baim Wong', 'L', 'Malang', '2012-03-03', 'Malang', NULL, NULL, NULL, NULL, NULL, 7, 'Aktif'),
('SIS8A03', 'Siswa 8A 03', 'P', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8A04', 'Siswa 8A 04', 'L', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8A05', 'Siswa 8A 05', 'P', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8A06', 'Siswa 8A 06', 'L', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8A07', 'Siswa 8A 07', 'P', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8A08', 'Siswa 8A 08', 'L', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8A09', 'Siswa 8A 09', 'P', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8A10', 'Siswa 8A 10', 'L', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
-- VIII B (10)
('SIS8B01', 'Siswa 8B 01', 'L', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8B02', 'Siswa 8B 02', 'P', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8B03', 'Siswa 8B 03', 'L', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8B04', 'Siswa 8B 04', 'P', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8B05', 'Siswa 8B 05', 'L', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8B06', 'Siswa 8B 06', 'P', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8B07', 'Siswa 8B 07', 'L', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8B08', 'Siswa 8B 08', 'P', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8B09', 'Siswa 8B 09', 'L', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8B10', 'Siswa 8B 10', 'P', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
-- VIII C (10)
('SIS8C01', 'Kezia Warouw', 'P', 'Malang', '2012-12-12', 'Malang', NULL, NULL, NULL, NULL, NULL, 8, 'Aktif'),
('SIS8C02', 'Siswa 8C 02', 'L', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8C03', 'Siswa 8C 03', 'P', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8C04', 'Siswa 8C 04', 'L', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8C05', 'Siswa 8C 05', 'P', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8C06', 'Siswa 8C 06', 'L', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8C07', 'Siswa 8C 07', 'P', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8C08', 'Siswa 8C 08', 'L', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8C09', 'Siswa 8C 09', 'P', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8C10', 'Siswa 8C 10', 'L', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
-- VIII D (10)
('SIS8D01', 'Siswa 8D 01', 'L', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8D02', 'Siswa 8D 02', 'P', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8D03', 'Siswa 8D 03', 'L', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8D04', 'Siswa 8D 04', 'P', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8D05', 'Siswa 8D 05', 'L', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8D06', 'Siswa 8D 06', 'P', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8D07', 'Siswa 8D 07', 'L', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8D08', 'Siswa 8D 08', 'P', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8D09', 'Siswa 8D 09', 'L', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8D10', 'Siswa 8D 10', 'P', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
-- VIII E (10)
('SIS8E01', 'Siswa 8E 01', 'L', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8E02', 'Siswa 8E 02', 'P', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8E03', 'Siswa 8E 03', 'L', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8E04', 'Siswa 8E 04', 'P', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8E05', 'Siswa 8E 05', 'L', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8E06', 'Siswa 8E 06', 'P', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8E07', 'Siswa 8E 07', 'L', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8E08', 'Siswa 8E 08', 'P', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8E09', 'Siswa 8E 09', 'L', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8E10', 'Siswa 8E 10', 'P', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
-- IX A (10)
('SIS9A01', 'Andhika Wijaya', 'L', 'Malang', '2010-01-10', 'Jl. Ijen', NULL, NULL, NULL, NULL, NULL, 1, 'Aktif'),
('SIS9A02', 'Edward Tan', 'L', 'Malang', '2011-11-11', 'Permata Jingga', NULL, NULL, NULL, NULL, NULL, 3, 'Aktif'),
('SIS9A03', 'Edwin Tan', 'L', 'Malang', '2011-11-11', 'Permata Jingga', NULL, NULL, NULL, NULL, NULL, 3, 'Aktif'),
('SIS9A04', 'Ziva Magnolya', 'P', 'Malang', '2011-03-15', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9A05', 'Ariel Noah', 'L', 'Malang', '2011-04-20', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Dikeluarkan'),
('SIS9A06', 'Bunga Citra', 'P', 'Malang', '2011-05-20', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9A07', 'Cakra Khan', 'L', 'Malang', '2011-06-20', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9A08', 'Deddy Corbuzier', 'L', 'Malang', '2011-07-20', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9A09', 'Ello Tahitoe', 'L', 'Malang', '2011-08-20', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9A10', 'Fatin Shidqia', 'P', 'Malang', '2011-09-20', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
-- IX B (10)
('SIS9B01', 'Siswa 9B 01', 'L', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9B02', 'Siswa 9B 02', 'P', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9B03', 'Siswa 9B 03', 'L', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9B04', 'Siswa 9B 04', 'P', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9B05', 'Siswa 9B 05', 'L', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9B06', 'Siswa 9B 06', 'P', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9B07', 'Siswa 9B 07', 'L', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9B08', 'Siswa 9B 08', 'P', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9B09', 'Siswa 9B 09', 'L', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9B10', 'Siswa 9B 10', 'P', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
-- IX C (10)
('SIS9C01', 'Giring Ganesha', 'L', 'Malang', '2011-10-20', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9C02', 'Siswa 9C 02', 'P', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9C03', 'Siswa 9C 03', 'L', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9C04', 'Siswa 9C 04', 'P', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9C05', 'Siswa 9C 05', 'L', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9C06', 'Siswa 9C 06', 'P', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9C07', 'Siswa 9C 07', 'L', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9C08', 'Siswa 9C 08', 'P', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9C09', 'Siswa 9C 09', 'L', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9C10', 'Siswa 9C 10', 'P', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
-- IX D (10)
('SIS9D01', 'Siswa 9D 01', 'L', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9D02', 'Siswa 9D 02', 'P', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9D03', 'Siswa 9D 03', 'L', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9D04', 'Siswa 9D 04', 'P', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9D05', 'Siswa 9D 05', 'L', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9D06', 'Siswa 9D 06', 'P', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9D07', 'Siswa 9D 07', 'L', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9D08', 'Siswa 9D 08', 'P', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9D09', 'Siswa 9D 09', 'L', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9D10', 'Siswa 9D 10', 'P', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
-- IX E (10)
('SIS9E01', 'Siswa 9E 01', 'L', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9E02', 'Siswa 9E 02', 'P', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9E03', 'Siswa 9E 03', 'L', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9E04', 'Siswa 9E 04', 'P', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9E05', 'Siswa 9E 05', 'L', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9E06', 'Siswa 9E 06', 'P', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9E07', 'Siswa 9E 07', 'L', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9E08', 'Siswa 9E 08', 'P', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9E09', 'Siswa 9E 09', 'L', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9E10', 'Siswa 9E 10', 'P', 'Malang', '2011-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),

-- KASUS KHUSUS (KELUAR/DIKELUARKAN)
('SISOUT01', 'Mario Dandy', 'L', 'Jakarta', '2010-01-01', 'Jakarta', NULL, NULL, NULL, NULL, NULL, NULL, 'Dikeluarkan'),
('SISOUT02', 'Rizky Billar', 'L', 'Medan', '2010-01-01', 'Medan', NULL, NULL, NULL, NULL, NULL, NULL, 'Dikeluarkan'),
('SISOUT03', 'Lesti Kejora', 'P', 'Cianjur', '2010-02-02', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Keluar'),
('SISOUT04', 'Nikita Mirzani', 'P', 'Jakarta', '2010-03-03', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Keluar'),
('SISOUT05', 'Ferry Irawan', 'L', 'Jakarta', '2010-04-04', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Dikeluarkan'),

-- ARSIP GLOBAL (LULUS)
('SISLUL01', 'Candra Wijaya', 'L', 'Malang', '2008-01-01', 'Jl. Ijen', NULL, NULL, NULL, NULL, NULL, 1, 'Lulus'),
('SISLUL02', 'Dina Pratama', 'P', 'Malang', '2008-01-01', 'Jl. Suhat', NULL, NULL, NULL, NULL, NULL, 2, 'Lulus'),
('SISLUL03', 'Eko Patrio', 'L', 'Malang', '2008-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, 4, 'Lulus'),
('SISLUL04', 'Fatin Shidqia Sr', 'P', 'Malang', '2008-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, 5, 'Lulus'),
('SISLUL05', 'Giring Ganesha Sr', 'L', 'Malang', '2008-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, 6, 'Lulus'),
('SISLUL06', 'Hesti Purwadinata', 'P', 'Malang', '2008-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, 7, 'Lulus'),
('SISLUL07', 'Irfan Hakim', 'L', 'Malang', '2008-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, 8, 'Lulus'),
('SISLUL08', 'Jessica Iskandar', 'P', 'Malang', '2008-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, 9, 'Lulus'),
('SISLUL09', 'Kaka Slank Sr', 'L', 'Malang', '2008-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, 10, 'Lulus'),
('SISLUL10', 'Luna Maya Sr', 'P', 'Malang', '2008-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Lulus'),
('SISLUL11', 'Momo Geisha Sr', 'P', 'Malang', '2008-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Lulus'),
('SISLUL12', 'Nano Sr', 'L', 'Malang', '2008-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Lulus'),
('SISLUL13', 'Opick Sr', 'L', 'Malang', '2008-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Lulus'),
('SISLUL14', 'Pasha Sr', 'L', 'Malang', '2008-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Lulus'),
('SISLUL15', 'Queen Sr', 'P', 'Malang', '2008-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Lulus');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_anggota_kelas`
--

CREATE TABLE `tb_anggota_kelas` (
  `id_anggota` bigint(20) NOT NULL,
  `no_induk` varchar(50) NOT NULL,
  `id_kelas` int(11) NOT NULL,
  `id_tahun` int(11) NOT NULL,
  `poin_kelakuan` int(11) DEFAULT 0,
  `poin_kerajinan` int(11) DEFAULT 0,
  `poin_kerapian` int(11) DEFAULT 0,
  `total_poin_umum` int(11) DEFAULT 0,
  `status_sp_kelakuan` enum('Aman','SP1','SP2','SP3','Sanksi oleh Sekolah') DEFAULT 'Aman',
  `status_sp_kerajinan` enum('Aman','SP1','SP2','SP3','Sanksi oleh Sekolah') DEFAULT 'Aman',
  `status_sp_kerapian` enum('Aman','SP1','SP2','SP3','Sanksi oleh Sekolah') DEFAULT 'Aman',
  `status_sp_terakhir` enum('Aman','SP1','SP2','SP3','Sanksi oleh Sekolah') DEFAULT 'Aman',
  `status_reward` enum('None','Kandidat Reward Semester','Kandidat Sertifikat') DEFAULT 'None'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_anggota_kelas` (`id_anggota`, `no_induk`, `id_kelas`, `id_tahun`, `poin_kelakuan`, `poin_kerajinan`, `poin_kerapian`, `total_poin_umum`, `status_sp_kelakuan`, `status_sp_kerajinan`, `status_sp_kerapian`, `status_sp_terakhir`, `status_reward`) VALUES
-- 2025/2026 (150 SISWA)
(1, 'SIS7A01', 1, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(2, 'SIS7A02', 1, 3, 0, 0, 100, 100, 'Aman', 'Aman', 'SP1', 'SP1', 'None'),
(3, 'SIS7A03', 1, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(4, 'SIS7A04', 1, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(5, 'SIS7A05', 1, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(6, 'SIS7A06', 1, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(7, 'SIS7A07', 1, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(8, 'SIS7A08', 1, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(9, 'SIS7A09', 1, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(10, 'SIS7A10', 1, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
-- VII B (11-20)
(11, 'SIS7B01', 2, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(12, 'SIS7B02', 2, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(13, 'SIS7B03', 2, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(14, 'SIS7B04', 2, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(15, 'SIS7B05', 2, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(16, 'SIS7B06', 2, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(17, 'SIS7B07', 2, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(18, 'SIS7B08', 2, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(19, 'SIS7B09', 2, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(20, 'SIS7B10', 2, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
-- VII C (21-30)
(21, 'SIS7C01', 3, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(22, 'SIS7C02', 3, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(23, 'SIS7C03', 3, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(24, 'SIS7C04', 3, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(25, 'SIS7C05', 3, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(26, 'SIS7C06', 3, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(27, 'SIS7C07', 3, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(28, 'SIS7C08', 3, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(29, 'SIS7C09', 3, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(30, 'SIS7C10', 3, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
-- VIII A (51-60)
(51, 'SIS8A01', 6, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(52, 'SIS8A02', 6, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(53, 'SIS8A03', 6, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(54, 'SIS8A04', 6, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(55, 'SIS8A05', 6, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(56, 'SIS8A06', 6, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(57, 'SIS8A07', 6, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(58, 'SIS8A08', 6, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(59, 'SIS8A09', 6, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(60, 'SIS8A10', 6, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
-- VIII C (71-80)
(71, 'SIS8C01', 8, 3, 0, 575, 0, 575, 'Aman', 'SP3', 'Aman', 'SP3', 'None'),
(72, 'SIS8C02', 8, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(73, 'SIS8C03', 8, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(74, 'SIS8C04', 8, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(75, 'SIS8C05', 8, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(76, 'SIS8C06', 8, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(77, 'SIS8C07', 8, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(78, 'SIS8C08', 8, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(79, 'SIS8C09', 8, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(80, 'SIS8C10', 8, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
-- IX A (101-110)
(101, 'SIS9A01', 11, 3, 100, 0, 0, 100, 'Aman', 'Aman', 'Aman', 'Aman', 'None'),
(102, 'SIS9A02', 11, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(103, 'SIS9A03', 11, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(104, 'SIS9A04', 11, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(105, 'SIS9A06', 11, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(106, 'SIS9A07', 11, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(107, 'SIS9A08', 11, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(108, 'SIS9A09', 11, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(109, 'SIS9A10', 11, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
-- IX C (121-130)
(121, 'SIS9C01', 13, 3, 2100, 0, 0, 2100, 'Sanksi oleh Sekolah', 'Aman', 'Aman', 'Sanksi oleh Sekolah', 'None'),
(122, 'SIS9C02', 13, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(123, 'SIS9C03', 13, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(124, 'SIS9C04', 13, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(125, 'SIS9C05', 13, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(126, 'SIS9C06', 13, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(127, 'SIS9C07', 13, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(128, 'SIS9C08', 13, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(129, 'SIS9C09', 13, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(130, 'SIS9C10', 13, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),

-- ARSIP 2024/2025 (GRADE 8/9 SEKARANG)
(201, 'SIS9C01', 13, 2, 1100, 0, 0, 1100, 'SP2', 'Aman', 'Aman', 'SP2', 'None'),
(202, 'SIS8A01', 6, 2, 400, 0, 0, 400, 'SP1', 'Aman', 'Aman', 'SP1', 'None'),
(203, 'SIS9A01', 11, 2, 0, 100, 50, 150, 'Aman', 'SP1', 'Aman', 'SP1', 'None'),
(204, 'SIS8C01', 8, 2, 0, 100, 0, 100, 'Aman', 'SP1', 'Aman', 'SP1', 'None'),

-- ARSIP 2024/2025 (SISWA LULUS)
(301, 'SISLUL01', 11, 2, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(302, 'SISLUL02', 11, 2, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(303, 'SISLUL03', 11, 2, 300, 0, 0, 300, 'SP1', 'Aman', 'Aman', 'SP1', 'None'),
(304, 'SISLUL04', 11, 2, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat'),
(305, 'SISLUL05', 11, 2, 1600, 0, 0, 1600, 'SP3', 'Aman', 'Aman', 'SP3', 'None'),

-- ARSIP 2023/2024
(401, 'SIS9C01', 13, 1, 300, 0, 0, 300, 'SP1', 'Aman', 'Aman', 'SP1', 'None'),
(402, 'SISLUL01', 11, 1, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'Kandidat Sertifikat');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_pelanggaran_header`
--

CREATE TABLE `tb_pelanggaran_header` (
  `id_transaksi` bigint(20) NOT NULL,
  `id_anggota` bigint(20) NOT NULL,
  `id_guru` int(11) NOT NULL,
  `id_tahun` int(11) NOT NULL,
  `tanggal` date NOT NULL,
  `waktu` time NOT NULL,
  `semester` enum('Ganjil','Genap') NOT NULL,
  `tipe_form` enum('Piket','Kelas') NOT NULL,
  `bukti_foto` varchar(255) DEFAULT NULL,
  `lampiran_link` text DEFAULT NULL,
  `status_revisi` enum('None','Pending','Disetujui','Ditolak') DEFAULT 'None',
  `alasan_revisi` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_pelanggaran_header` (`id_transaksi`, `id_anggota`, `id_guru`, `id_tahun`, `tanggal`, `waktu`, `semester`, `tipe_form`, `bukti_foto`, `lampiran_link`, `status_revisi`, `alasan_revisi`) VALUES
-- Histori 23/24
(1, 401, 2, 1, '2023-10-10', '08:00:00', 'Ganjil', 'Kelas', NULL, NULL, 'None', NULL),
-- Histori 24/25
(10, 201, 2, 2, '2024-09-10', '08:00:00', 'Ganjil', 'Kelas', NULL, NULL, 'None', NULL),
(11, 201, 4, 2, '2024-11-15', '10:00:00', 'Ganjil', 'Piket', NULL, NULL, 'None', NULL),
(12, 202, 5, 2, '2025-02-20', '07:30:00', 'Genap', 'Kelas', NULL, NULL, 'None', NULL),
(13, 303, 1, 2, '2024-08-20', '07:00:00', 'Ganjil', 'Kelas', NULL, NULL, 'None', NULL),
(14, 305, 12, 2, '2024-12-12', '11:00:00', 'Ganjil', 'Piket', NULL, NULL, 'None', NULL),
-- Aktif 25/26
(100, 121, 1, 3, '2025-08-05', '07:15:00', 'Ganjil', 'Kelas', NULL, NULL, 'None', NULL),
(101, 121, 2, 3, '2025-11-12', '10:00:00', 'Ganjil', 'Kelas', NULL, NULL, 'None', NULL),
(102, 71, 8, 3, '2026-01-20', '07:20:00', 'Genap', 'Piket', NULL, NULL, 'None', NULL),
(103, 71, 12, 3, '2026-03-15', '08:00:00', 'Genap', 'Kelas', NULL, NULL, 'None', NULL),
(104, 2, 5, 3, '2026-04-10', '07:10:00', 'Genap', 'Piket', NULL, NULL, 'None', NULL),
(105, 101, 2, 3, '2026-04-25', '09:30:00', 'Genap', 'Kelas', NULL, NULL, 'None', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_pelanggaran_detail`
--

CREATE TABLE `tb_pelanggaran_detail` (
  `id_detail` bigint(20) NOT NULL,
  `id_transaksi` bigint(20) NOT NULL,
  `id_jenis` int(11) NOT NULL,
  `poin_saat_itu` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_pelanggaran_detail` (`id_detail`, `id_transaksi`, `id_jenis`, `poin_saat_itu`) VALUES
(1, 1, 18, 300),
(10, 10, 18, 500),
(11, 11, 18, 600),
(12, 12, 4, 400),
(13, 13, 16, 300),
(14, 14, 23, 1600),
(100, 100, 18, 500),
(101, 101, 21, 1600), -- Escalated to Sanksi Sekolah
(102, 102, 42, 500),
(103, 103, 39, 75),
(104, 104, 66, 100),
(105, 105, 3, 100);

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_riwayat_sp`
--

CREATE TABLE `tb_riwayat_sp` (
  `id_sp` int(11) NOT NULL,
  `id_anggota` bigint(20) NOT NULL,
  `tingkat_sp` enum('SP1','SP2','SP3','Sanksi oleh Sekolah') NOT NULL,
  `kategori_pemicu` varchar(50) DEFAULT NULL,
  `tanggal_terbit` date NOT NULL,
  `tanggal_validasi` date DEFAULT NULL,
  `status` enum('Pending','Selesai') DEFAULT 'Pending',
  `id_admin` int(11) DEFAULT NULL,
  `catatan_admin` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_riwayat_sp` (`id_sp`, `id_anggota`, `tingkat_sp`, `kategori_pemicu`, `tanggal_terbit`, `tanggal_validasi`, `status`, `id_admin`, `catatan_admin`) VALUES
-- ARSIP
(1, 401, 'SP1', 'KELAKUAN', '2023-10-11', '2023-10-12', 'Selesai', 2, 'Merokok pertama kali.'),
(2, 201, 'SP2', 'KELAKUAN', '2024-11-16', '2024-11-17', 'Selesai', 2, 'Mengulangi merokok.'),
(3, 303, 'SP1', 'KELAKUAN', '2024-08-21', '2024-08-22', 'Selesai', 2, 'Palsu TTD.'),
(4, 305, 'SP3', 'KELAKUAN', '2024-12-13', NULL, 'Pending', NULL, 'Pelecehan Seksual.'),
-- AKTIF
(10, 121, 'Sanksi oleh Sekolah', 'KELAKUAN', '2025-11-13', NULL, 'Pending', NULL, 'Kasus NAPZA - Menunggu keputusan rapat.'),
(11, 71, 'SP3', 'KERAJINAN', '2026-03-16', NULL, 'Pending', NULL, 'Bolos berulang kali.'),
(12, 2, 'SP1', 'KERAPIAN', '2026-04-11', '2026-04-12', 'Selesai', 2, 'Baju sudah rapi.'),
(13, 204, 'SP1', 'KERAJINAN', '2025-01-16', '2025-01-17', 'Selesai', 2, 'Sering Alpa.');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_feedback_ortu`
--

CREATE TABLE `tb_feedback_ortu` (
  `id_feedback` int(11) NOT NULL,
  `id_ortu` int(11) NOT NULL,
  `id_sp` int(11) NOT NULL,
  `isi_feedback` text NOT NULL,
  `tanggal_kirim` datetime DEFAULT current_timestamp(),
  `status_baca` enum('Belum Dibaca','Sudah Dibaca') DEFAULT 'Belum Dibaca',
  `id_admin_pembaca` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_feedback_ortu` (`id_feedback`, `id_ortu`, `id_sp`, `isi_feedback`, `tanggal_kirim`, `status_baca`, `id_admin_pembaca`) VALUES
(1, 1, 12, 'Kami sudah menasihati Bening di rumah. Terima kasih.', '2026-04-13 08:00:00', 'Sudah Dibaca', 2),
(2, 8, 11, 'Mohon bantuannya bapak/ibu guru untuk membina anak kami.', '2026-03-17 09:00:00', 'Belum Dibaca', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_guru`
--

CREATE TABLE `tb_guru` (
  `id_guru` int(11) NOT NULL,
  `nama_guru` varchar(100) NOT NULL,
  `nip` varchar(30) DEFAULT NULL,
  `kode_guru` varchar(10) DEFAULT NULL,
  `id_kelas` int(11) DEFAULT NULL,
  `pin_validasi` varchar(6) NOT NULL,
  `status` enum('Aktif','Non-Aktif') DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tb_guru` (`id_guru`, `nama_guru`, `nip`, `kode_guru`, `id_kelas`, `pin_validasi`, `status`) VALUES
(1, 'Sr. M. Elfrida Suhartati, SPM, S.Psi.,MM', '10001', '1', NULL, '123456', 'Aktif'),
(2, 'Antonetta Maria Kuntodiati, S.Pd', '10002', '2', 9, '123456', 'Aktif'),
(3, 'Dra. Maria Marsiti', '10003', '3', NULL, '123456', 'Aktif'),
(4, 'Trianto Thomas, S.Pd', '10004', '4', 15, '123456', 'Aktif'),
(5, 'Agustina Peni Sarasati, S.Pd', '10005', '5', 1, '123456', 'Aktif'),
(6, 'Y. Pamungkas, S.Pd', '10006', '6', NULL, '123456', 'Aktif'),
(7, 'Joseph Andiek Kristian, S.Pd, S.Kom', '10007', '7', NULL, '123456', 'Aktif'),
(8, 'Albertha Yulanti Susetyo, M.Pd', '10008', '8', 4, '123456', 'Aktif'),
(9, 'Galang Bagus Afridianto, M.Pd', '10009', '9', NULL, '123456', 'Aktif'),
(10, 'Hendrik Kiswanto, S.Pd.', '10010', '10', NULL, '123456', 'Aktif'),
(11, 'Margareta Esti Wulan, S.Pd.', '10011', '11', 14, '123456', 'Aktif'),
(12, 'Theresia Sri Wahyuni, S.Pd, M.M.', '10012', '12', 12, '123456', 'Aktif'),
(13, 'Yosua Beni Setiawan, S.Pd.', '10014', '14', NULL, '123456', 'Aktif'),
(14, 'God Life Endob Mesak, S.Pd', '10015', '15', NULL, '123456', 'Aktif'),
(15, 'Agnes Herawaty Sinurat, S.E., M.M.', '10016', '16', 3, '123456', 'Aktif'),
(16, 'Deka Nanda Kurniawati, S.Pd.', '10017', '17', NULL, '123456', 'Aktif'),
(17, 'Agatha Novenia Bintang Prieska, S.Pd.', '10018', '18', 2, '123456', 'Aktif'),
(18, 'Bernadetha Devia Tindy Noveyra, S.Pd.', '10019', '19', 7, '123456', 'Aktif'),
(19, 'Drs. Albertus Magnus Meo Depa', '10020', '20', NULL, '123456', 'Aktif'),
(20, 'Giovani Bimby Dwiantonio, S.Pd', '10021', '21', 11, '123456', 'Aktif'),
(21, 'Arnoldus Kobe Tegar Felix Sai, S.Pd.', '10022', '22', NULL, '123456', 'Aktif'),
(22, 'Haniar Mey Sila Kinanti, S.Pd.', '10023', '23', 10, '123456', 'Aktif'),
(23, 'Anjelina Wulandari Sitina De Sareng, S.Pd', '10024', '24', 6, '123456', 'Aktif'),
(24, 'Lydia Uli Permatasari, S.Pd.', '10025', '25', 13, '123456', 'Aktif'),
(25, 'Albertus Bayu Seto, S.Pd', '10026', '26', NULL, '123456', 'Aktif'),
(26, 'Brigita Natalia Setyaningrum, S.Pd.', '10027', '27', 8, '123456', 'Aktif'),
(27, 'Amelia Rangel Da Silva, S.Pd', '10028', '28', 5, '123456', 'Aktif');

-- --------------------------------------------------------

--
-- Indexes for dumped tables
--

ALTER TABLE `tb_admin` ADD PRIMARY KEY (`id_admin`);
ALTER TABLE `tb_guru` ADD PRIMARY KEY (`id_guru`), ADD KEY `id_kelas` (`id_kelas`);
ALTER TABLE `tb_tahun_ajaran` ADD PRIMARY KEY (`id_tahun`);
ALTER TABLE `tb_kelas` ADD PRIMARY KEY (`id_kelas`);
ALTER TABLE `tb_kategori_pelanggaran` ADD PRIMARY KEY (`id_kategori`);
ALTER TABLE `tb_jenis_pelanggaran` ADD PRIMARY KEY (`id_jenis`), ADD KEY `id_kategori` (`id_kategori`);
ALTER TABLE `tb_sanksi_ref` ADD PRIMARY KEY (`id_sanksi_ref`);
ALTER TABLE `tb_aturan_sp` ADD PRIMARY KEY (`id_aturan_sp`), ADD KEY `id_kategori` (`id_kategori`);
ALTER TABLE `tb_predikat_nilai` ADD PRIMARY KEY (`id_predikat`), ADD KEY `id_kategori` (`id_kategori`);
ALTER TABLE `tb_orang_tua` ADD PRIMARY KEY (`id_ortu`), ADD UNIQUE KEY `nik_ortu` (`nik_ortu`);
ALTER TABLE `tb_siswa` ADD PRIMARY KEY (`no_induk`), ADD KEY `fk_ortu_siswa` (`id_ortu`);
ALTER TABLE `tb_anggota_kelas` ADD PRIMARY KEY (`id_anggota`), ADD KEY `no_induk` (`no_induk`), ADD KEY `id_kelas` (`id_kelas`), ADD KEY `id_tahun` (`id_tahun`);
ALTER TABLE `tb_pelanggaran_header` ADD PRIMARY KEY (`id_transaksi`), ADD KEY `id_anggota` (`id_anggota`), ADD KEY `id_guru` (`id_guru`), ADD KEY `id_tahun` (`id_tahun`);
ALTER TABLE `tb_pelanggaran_detail` ADD PRIMARY KEY (`id_detail`), ADD KEY `id_transaksi` (`id_transaksi`), ADD KEY `id_jenis` (`id_jenis`);
ALTER TABLE `tb_riwayat_sp` ADD PRIMARY KEY (`id_sp`), ADD KEY `id_anggota` (`id_anggota`), ADD KEY `id_admin` (`id_admin`);
ALTER TABLE `tb_feedback_ortu` ADD PRIMARY KEY (`id_feedback`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

ALTER TABLE `tb_admin` MODIFY `id_admin` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
ALTER TABLE `tb_tahun_ajaran` MODIFY `id_tahun` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
ALTER TABLE `tb_kelas` MODIFY `id_kelas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
ALTER TABLE `tb_kategori_pelanggaran` MODIFY `id_kategori` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
ALTER TABLE `tb_jenis_pelanggaran` MODIFY `id_jenis` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;
ALTER TABLE `tb_sanksi_ref` MODIFY `id_sanksi_ref` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
ALTER TABLE `tb_aturan_sp` MODIFY `id_aturan_sp` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
ALTER TABLE `tb_predikat_nilai` MODIFY `id_predikat` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
ALTER TABLE `tb_orang_tua` MODIFY `id_ortu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100;
ALTER TABLE `tb_anggota_kelas` MODIFY `id_anggota` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2000;
ALTER TABLE `tb_pelanggaran_header` MODIFY `id_transaksi` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2000;
ALTER TABLE `tb_pelanggaran_detail` MODIFY `id_detail` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2000;
ALTER TABLE `tb_riwayat_sp` MODIFY `id_sp` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2000;
ALTER TABLE `tb_feedback_ortu` MODIFY `id_feedback` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2000;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

ALTER TABLE `tb_anggota_kelas` ADD CONSTRAINT `tb_anggota_kelas_ibfk_1` FOREIGN KEY (`no_induk`) REFERENCES `tb_siswa` (`no_induk`) ON DELETE CASCADE, ADD CONSTRAINT `tb_anggota_kelas_ibfk_2` FOREIGN KEY (`id_kelas`) REFERENCES `tb_kelas` (`id_kelas`), ADD CONSTRAINT `tb_anggota_kelas_ibfk_3` FOREIGN KEY (`id_tahun`) REFERENCES `tb_tahun_ajaran` (`id_tahun`);
ALTER TABLE `tb_pelanggaran_header` ADD CONSTRAINT `tb_pelanggaran_header_ibfk_1` FOREIGN KEY (`id_anggota`) REFERENCES `tb_anggota_kelas` (`id_anggota`), ADD CONSTRAINT `tb_pelanggaran_header_ibfk_2` FOREIGN KEY (`id_guru`) REFERENCES `tb_guru` (`id_guru`), ADD CONSTRAINT `tb_pelanggaran_header_ibfk_3` FOREIGN KEY (`id_tahun`) REFERENCES `tb_tahun_ajaran` (`id_tahun`);
ALTER TABLE `tb_pelanggaran_detail` ADD CONSTRAINT `tb_pelanggaran_detail_ibfk_1` FOREIGN KEY (`id_transaksi`) REFERENCES `tb_pelanggaran_header` (`id_transaksi`) ON DELETE CASCADE, ADD CONSTRAINT `tb_pelanggaran_detail_ibfk_2` FOREIGN KEY (`id_jenis`) REFERENCES `tb_jenis_pelanggaran` (`id_jenis`);
ALTER TABLE `tb_riwayat_sp` ADD CONSTRAINT `tb_riwayat_sp_ibfk_1` FOREIGN KEY (`id_anggota`) REFERENCES `tb_anggota_kelas` (`id_anggota`), ADD CONSTRAINT `tb_riwayat_sp_ibfk_2` FOREIGN KEY (`id_admin`) REFERENCES `tb_admin` (`id_admin`);
ALTER TABLE `tb_siswa` ADD CONSTRAINT `fk_ortu_siswa` FOREIGN KEY (`id_ortu`) REFERENCES `tb_orang_tua` (`id_ortu`) ON DELETE SET NULL;

COMMIT;
