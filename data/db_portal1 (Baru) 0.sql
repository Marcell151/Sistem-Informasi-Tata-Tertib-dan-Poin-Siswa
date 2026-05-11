-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 26 Apr 2026 pada 14.28
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

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

--
-- Dumping data untuk tabel `tb_admin`
--

INSERT INTO `tb_admin` (`id_admin`, `username`, `password`, `nama_lengkap`, `role`, `status`, `created_at`) VALUES
(1, 'admin', 'admin123', 'Admin SITAPSI', 'AdminPusat', 'Aktif', '2026-04-20 11:39:16'),
(2, 'admintatib', 'admin123', 'Tim Kedisiplinan', 'Admin', 'Aktif', '2026-04-20 11:39:16'),
(3, 'kepsek', 'kepsek123', 'Kepala Sekolah', 'KepalaSekolah', 'Aktif', '2026-04-20 11:39:16');

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

--
-- Dumping data untuk tabel `tb_anggota_kelas`
--

INSERT INTO `tb_anggota_kelas` (`id_anggota`, `no_induk`, `id_kelas`, `id_tahun`, `poin_kelakuan`, `poin_kerajinan`, `poin_kerapian`, `total_poin_umum`, `status_sp_kelakuan`, `status_sp_kerajinan`, `status_sp_kerapian`, `status_sp_terakhir`, `status_reward`) VALUES
(1, 'SIS7A01', 1, 3, 20, 0, 0, 20, 'Aman', 'Aman', 'Aman', 'Aman', 'None'),
(2, 'SIS7A02', 1, 3, 0, 100, 50, 150, 'Aman', 'SP1', 'Aman', 'SP1', 'None'),
(3, 'SIS7A03', 1, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'None'),
(4, 'SIS7A04', 1, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'None'),
(5, 'SIS7A05', 1, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'None'),
(6, 'SIS7B01', 2, 3, 0, 25, 0, 25, 'Aman', 'Aman', 'Aman', 'Aman', 'None'),
(7, 'SIS7B02', 2, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'None'),
(8, 'SIS7B03', 2, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'None'),
(9, 'SIS7C01', 3, 3, 0, 0, 100, 100, 'Aman', 'Aman', 'Aman', 'SP1', 'None'),
(10, 'SIS7C02', 3, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'None'),
(11, 'SIS7D01', 4, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'None'),
(12, 'SIS7E01', 5, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'None'),
(13, 'SIS8A01', 6, 3, 300, 0, 0, 300, 'Aman', 'Aman', 'Aman', 'SP1', 'None'),
(14, 'SIS8A02', 6, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'None'),
(15, 'SIS8B01', 7, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'None'),
(16, 'SIS8C01', 8, 3, 0, 450, 0, 450, 'Aman', 'Aman', 'Aman', 'SP3', 'None'),
(17, 'SIS8D01', 9, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'None'),
(18, 'SIS8E01', 10, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'None'),
(19, 'SIS9A01', 11, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'None'),
(20, 'SIS9A02', 11, 3, 50, 0, 0, 50, 'Aman', 'Aman', 'Aman', 'Aman', 'None'),
(21, 'SIS9A03', 11, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'None'),
(22, 'SIS9B01', 12, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'None'),
(23, 'SIS9C01', 13, 3, 1000, 0, 0, 1000, 'Aman', 'Aman', 'Aman', 'SP2', 'None'),
(24, 'SIS9D01', 14, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'None'),
(25, 'SIS9E01', 15, 3, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'None'),
(101, 'SIS9A01', 6, 2, 100, 50, 50, 200, 'Aman', 'Aman', 'Aman', 'Aman', 'None'),
(102, 'SIS8A01', 1, 2, 0, 0, 0, 0, 'Aman', 'Aman', 'Aman', 'Aman', 'None');

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

--
-- Dumping data untuk tabel `tb_aturan_sp`
--

INSERT INTO `tb_aturan_sp` (`id_aturan_sp`, `id_kategori`, `level_sp`, `batas_bawah_poin`) VALUES
(1, 1, 'SP1', 250),
(2, 1, 'SP2', 750),
(3, 1, 'SP3', 1500),
(4, 1, 'Sanksi oleh Sekolah', 2000),
(5, 2, 'SP1', 75),
(6, 2, 'SP2', 300),
(7, 2, 'SP3', 450),
(8, 2, 'Sanksi oleh Sekolah', 600),
(9, 3, 'SP1', 100),
(10, 3, 'SP2', 300),
(11, 3, 'SP3', 450),
(12, 3, 'Sanksi oleh Sekolah', 600);

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

--
-- Dumping data untuk tabel `tb_feedback_ortu`
--

INSERT INTO `tb_feedback_ortu` (`id_feedback`, `id_ortu`, `id_sp`, `isi_feedback`, `tanggal_kirim`, `status_baca`, `id_admin_pembaca`) VALUES
(1, 1, 1, 'Terima kasih, Andhika sudah kami potong rambutnya.', '2026-04-26 15:19:06', 'Sudah Dibaca', NULL),
(2, 8, 2, 'Mohon maaf, Kezia sakit sehingga tidak ikut olahraga. Surat menyusul.', '2026-04-26 15:19:06', 'Belum Dibaca', NULL);

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

--
-- Dumping data untuk tabel `tb_guru`
--

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

--
-- Dumping data untuk tabel `tb_jenis_pelanggaran`
--

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
-- Struktur dari tabel `tb_kategori_pelanggaran`
--

CREATE TABLE `tb_kategori_pelanggaran` (
  `id_kategori` int(11) NOT NULL,
  `nama_kategori` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `tb_kategori_pelanggaran`
--

INSERT INTO `tb_kategori_pelanggaran` (`id_kategori`, `nama_kategori`) VALUES
(1, 'KELAKUAN'),
(2, 'KERAJINAN'),
(3, 'KERAPIAN');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_kelas`
--

CREATE TABLE `tb_kelas` (
  `id_kelas` int(11) NOT NULL,
  `nama_kelas` varchar(10) NOT NULL,
  `tingkat` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `tb_kelas`
--

INSERT INTO `tb_kelas` (`id_kelas`, `nama_kelas`, `tingkat`) VALUES
(1, 'VII A', 7),
(2, 'VII B', 7),
(3, 'VII C', 7),
(4, 'VII D', 7),
(5, 'VII E', 7),
(6, 'VIII A', 8),
(7, 'VIII B', 8),
(8, 'VIII C', 8),
(9, 'VIII D', 8),
(10, 'VIII E', 8),
(11, 'IX A', 9),
(12, 'IX B', 9),
(13, 'IX C', 9),
(14, 'IX D', 9),
(15, 'IX E', 9);

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

--
-- Dumping data untuk tabel `tb_orang_tua`
--

INSERT INTO `tb_orang_tua` (`id_ortu`, `nik_ortu`, `password`, `nama_ayah`, `pekerjaan_ayah`, `nama_ibu`, `pekerjaan_ibu`, `no_hp_ortu`, `alamat`, `is_active`, `created_at`) VALUES
(1, '3573010000000001', 'e10adc3949ba59abbe56e057f20f883e', 'Bpk. Wijaya', 'Pengusaha', 'Ibu Wijaya', 'Ibu Rumah Tangga', '08111111111', 'Jl. Ijen No. 10, Malang', 1, '2026-04-26 08:19:06'),
(2, '3573010000000002', 'e10adc3949ba59abbe56e057f20f883e', 'Bpk. Pratama', 'PNS', 'Ibu Pratama', 'Guru', '08222222222', 'Jl. Sukarno Hatta No. 5, Malang', 1, '2026-04-26 08:19:06'),
(3, '3573010000000003', 'e10adc3949ba59abbe56e057f20f883e', 'Bpk. Tan', 'Arsitek', 'Ibu Tan', 'Desainer', '08333333333', 'Komp. Permata Jingga Blok A, Malang', 1, '2026-04-26 08:19:06'),
(4, '3573010000000004', 'e10adc3949ba59abbe56e057f20f883e', 'Bpk. Kusuma', 'Dokter', 'Ibu Kusuma', 'Apoteker', '08444444444', 'Jl. Borobudur No. 1, Malang', 1, '2026-04-26 08:19:06'),
(5, '3573010000000005', 'e10adc3949ba59abbe56e057f20f883e', 'Bpk. Raharjo', 'Wiraswasta', 'Ibu Raharjo', 'Pedagang', '08555555555', 'Jl. Dinoyo No. 44, Malang', 1, '2026-04-26 08:19:06'),
(6, '3573010000000006', 'e10adc3949ba59abbe56e057f20f883e', 'Bpk. Santoso', 'Karyawan', 'Ibu Santoso', 'Guru', '08666666666', 'Jl. Arjosari, Malang', 1, '2026-04-26 08:19:06'),
(7, '3573010000000007', 'e10adc3949ba59abbe56e057f20f883e', 'Bpk. Budiman', 'Polisi', 'Ibu Budiman', 'Perawat', '08777777777', 'Jl. Sawojajar, Malang', 1, '2026-04-26 08:19:06'),
(8, '3573010000000008', 'e10adc3949ba59abbe56e057f20f883e', 'Bpk. Setiawan', 'Sopir', 'Ibu Setiawan', 'Pedagang', '08888888888', 'Jl. Blimbing, Malang', 1, '2026-04-26 08:19:06');

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

--
-- Dumping data untuk tabel `tb_pelanggaran_detail`
--

INSERT INTO `tb_pelanggaran_detail` (`id_detail`, `id_transaksi`, `id_jenis`, `poin_saat_itu`) VALUES
(1, 1, 62, 50),
(2, 2, 58, 50),
(3, 3, 4, 500),
(4, 4, 25, 300),
(5, 5, 70, 25),
(6, 6, 38, 25),
(7, 7, 66, 100),
(8, 8, 42, 500),
(9, 9, 3, 100),
(10, 10, 18, 500),
(11, 11, 31, 50),
(12, 12, 38, 25),
(13, 12, 40, 75),
(14, 12, 57, 50);

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

--
-- Dumping data untuk tabel `tb_pelanggaran_header`
--

INSERT INTO `tb_pelanggaran_header` (`id_transaksi`, `id_anggota`, `id_guru`, `id_tahun`, `tanggal`, `waktu`, `semester`, `tipe_form`, `bukti_foto`, `lampiran_link`, `status_revisi`, `alasan_revisi`) VALUES
(1, 101, 5, 2, '2024-09-10', '07:30:00', 'Ganjil', 'Kelas', NULL, NULL, 'None', NULL),
(2, 101, 2, 2, '2025-02-12', '08:00:00', 'Genap', 'Piket', NULL, NULL, 'None', NULL),
(3, 13, 4, 3, '2025-10-05', '09:00:00', 'Ganjil', 'Kelas', NULL, NULL, 'None', NULL),
(4, 23, 1, 3, '2025-11-20', '10:30:00', 'Ganjil', 'Kelas', NULL, NULL, 'None', NULL),
(5, 1, 5, 3, '2026-01-10', '07:15:00', 'Genap', 'Piket', NULL, NULL, 'None', NULL),
(6, 6, 2, 3, '2026-02-15', '07:20:00', 'Genap', 'Piket', NULL, NULL, 'None', NULL),
(7, 9, 8, 3, '2026-03-05', '08:00:00', 'Genap', 'Kelas', NULL, NULL, 'None', NULL),
(8, 16, 12, 3, '2026-03-12', '07:45:00', 'Genap', 'Piket', NULL, NULL, 'None', NULL),
(9, 13, 1, 3, '2026-04-01', '09:00:00', 'Genap', 'Kelas', NULL, NULL, 'None', NULL),
(10, 23, 1, 3, '2026-04-10', '11:00:00', 'Genap', 'Kelas', NULL, NULL, 'None', NULL),
(11, 20, 4, 3, '2026-04-15', '10:00:00', 'Genap', 'Kelas', NULL, NULL, 'None', NULL),
(12, 2, 17, 3, '2026-04-26', '16:03:00', 'Genap', 'Piket', NULL, NULL, 'Pending', 'Salah Input');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_pelanggaran_sanksi`
--

CREATE TABLE `tb_pelanggaran_sanksi` (
  `id_trans_sanksi` bigint(20) NOT NULL,
  `id_transaksi` bigint(20) NOT NULL,
  `id_sanksi_ref` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `tb_pelanggaran_sanksi`
--

INSERT INTO `tb_pelanggaran_sanksi` (`id_trans_sanksi`, `id_transaksi`, `id_sanksi_ref`) VALUES
(1, 1, 5),
(2, 2, 1),
(3, 2, 2),
(4, 2, 5),
(5, 2, 7),
(6, 2, 8),
(7, 2, 1),
(8, 2, 2),
(9, 2, 5),
(10, 2, 7),
(11, 2, 8),
(12, 3, 1),
(13, 3, 2),
(14, 3, 5),
(15, 3, 7),
(16, 3, 8),
(17, 4, 5),
(18, 5, 1),
(19, 5, 2),
(20, 5, 5),
(21, 5, 8),
(22, 12, 1),
(23, 12, 2),
(24, 12, 5),
(25, 12, 7),
(26, 12, 8);

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

--
-- Dumping data untuk tabel `tb_predikat_nilai`
--

INSERT INTO `tb_predikat_nilai` (`id_predikat`, `id_kategori`, `huruf_mutu`, `batas_bawah`, `batas_atas`, `keterangan`) VALUES
(1, 1, 'A', 0, 49, 'Sangat Baik'),
(2, 1, 'B', 50, 249, 'Baik'),
(3, 1, 'C', 250, 1499, 'Cukup (SP1/SP2)'),
(4, 1, 'D', 1500, 9999, 'Kurang (SP3/Berat)'),
(5, 2, 'A', 0, 24, 'Sangat Baik'),
(6, 2, 'B', 25, 74, 'Baik'),
(7, 2, 'C', 75, 449, 'Cukup (SP1/SP2)'),
(8, 2, 'D', 450, 9999, 'Kurang (SP3/Berat)'),
(9, 3, 'A', 0, 49, 'Sangat Baik'),
(10, 3, 'B', 50, 99, 'Baik'),
(11, 3, 'C', 100, 449, 'Cukup (SP1/SP2)'),
(12, 3, 'D', 450, 9999, 'Kurang (SP3/Berat)');

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
  `catatan_admin` text DEFAULT NULL COMMENT 'Pesan spesifik dari Admin untuk Orang Tua'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `tb_riwayat_sp`
--

INSERT INTO `tb_riwayat_sp` (`id_sp`, `id_anggota`, `tingkat_sp`, `kategori_pemicu`, `tanggal_terbit`, `tanggal_validasi`, `status`, `id_admin`, `catatan_admin`) VALUES
(1, 9, 'SP1', 'KERAPIAN', '2026-03-06', NULL, 'Selesai', 2, NULL),
(2, 16, 'SP3', 'KERAJINAN', '2026-03-13', NULL, 'Pending', NULL, NULL),
(3, 13, 'SP1', 'KELAKUAN', '2026-04-02', NULL, 'Selesai', 2, NULL),
(4, 23, 'SP2', 'KELAKUAN', '2026-04-11', NULL, 'Pending', NULL, NULL),
(5, 2, 'SP1', 'KERAJINAN', '2026-04-26', NULL, 'Pending', NULL, NULL);

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

--
-- Dumping data untuk tabel `tb_sanksi_ref`
--

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

--
-- Dumping data untuk tabel `tb_siswa`
--

INSERT INTO `tb_siswa` (`no_induk`, `nama_siswa`, `jenis_kelamin`, `kota`, `tanggal_lahir`, `alamat`, `nama_ayah`, `pekerjaan_ayah`, `nama_ibu`, `pekerjaan_ibu`, `no_hp_ortu`, `id_ortu`, `status_aktif`) VALUES
('SIS7A01', 'Aditya Pratama', 'L', 'Malang', '2013-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, 2, 'Aktif'),
('SIS7A02', 'Bening Wijaya', 'P', 'Malang', '2013-05-12', 'Malang', NULL, NULL, NULL, NULL, NULL, 1, 'Aktif'),
('SIS7A03', 'Citra Lestari', 'P', 'Malang', '2013-02-02', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7A04', 'Deni Setiawan', 'L', 'Malang', '2013-03-03', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7A05', 'Eka Putri', 'P', 'Malang', '2013-04-04', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7A06', 'Fajar Ramadhan', 'L', 'Malang', '2013-05-05', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7B01', 'Bintang Wijaya', 'L', 'Malang', '2013-05-12', 'Malang', NULL, NULL, NULL, NULL, NULL, 1, 'Aktif'),
('SIS7B02', 'Gita Permata', 'P', 'Malang', '2013-06-06', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7B03', 'Hendra Kusuma', 'L', 'Malang', '2013-07-07', 'Malang', NULL, NULL, NULL, NULL, NULL, 4, 'Aktif'),
('SIS7B04', 'Indah Sari', 'P', 'Malang', '2013-08-08', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7B05', 'Jaka Tarub', 'L', 'Malang', '2013-09-09', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7B06', 'Kartika Ajeng', 'P', 'Malang', '2013-10-10', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7C01', 'Luthfi Hakim', 'L', 'Malang', '2013-11-11', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7C02', 'Maya Sofia', 'P', 'Malang', '2013-12-12', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7C03', 'Naufal Rizky', 'L', 'Malang', '2013-01-15', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7C04', 'Olivia Zalianty', 'P', 'Malang', '2013-02-20', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7C05', 'Panji Gumilang', 'L', 'Malang', '2013-03-25', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7D01', 'Qori Antika', 'P', 'Malang', '2013-04-10', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7D02', 'Rendi Pangalila', 'L', 'Malang', '2013-05-15', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7D03', 'Siska Kohl', 'P', 'Malang', '2013-06-20', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7D04', 'Tegar Felix', 'L', 'Malang', '2013-07-25', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7D05', 'Uli Permata', 'P', 'Malang', '2013-08-30', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7E01', 'Vino G Bastian', 'L', 'Malang', '2013-09-05', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7E02', 'Wanda Hara', 'P', 'Malang', '2013-10-10', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7E03', 'Xavi Hernan', 'L', 'Malang', '2013-11-15', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7E04', 'Yuni Shara', 'P', 'Malang', '2013-12-20', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS7E05', 'Zaskia Gotik', 'P', 'Malang', '2013-01-25', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8A01', 'Agung Hapsah', 'L', 'Malang', '2012-02-02', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8A02', 'Baim Wong', 'L', 'Malang', '2012-03-03', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8A03', 'Cinta Laura', 'P', 'Malang', '2012-04-04', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8A04', 'Desta Mahendra', 'L', 'Malang', '2012-05-05', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8A05', 'Enzy Storia', 'P', 'Malang', '2012-06-06', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8B01', 'Fedi Nuril', 'L', 'Malang', '2012-07-07', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8B02', 'Gading Marten', 'L', 'Malang', '2012-08-08', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8B03', 'Hesti Purwadinata', 'P', 'Malang', '2012-09-09', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8B04', 'Irfan Hakim', 'L', 'Malang', '2012-10-10', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8B05', 'Jessica Iskandar', 'P', 'Malang', '2012-11-11', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8C01', 'Kezia Warouw', 'P', 'Malang', '2012-12-12', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8C02', 'Lesti Kejora', 'P', 'Malang', '2012-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8C03', 'Muhammad Rizky', 'L', 'Malang', '2012-02-05', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8C04', 'Najwa Shihab', 'P', 'Malang', '2012-03-10', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8C05', 'Onadio Leo', 'L', 'Malang', '2012-04-15', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8D01', 'Pevita Pearce', 'P', 'Malang', '2012-05-20', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8D02', 'Quentin Stan', 'L', 'Malang', '2012-06-25', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8D03', 'Raffi Ahmad', 'L', 'Malang', '2012-07-30', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8D04', 'Sule Prikitiw', 'L', 'Malang', '2012-08-05', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8D05', 'Tulus Rusedi', 'L', 'Malang', '2012-09-10', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8E01', 'Uus Rizky', 'L', 'Malang', '2012-10-15', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8E02', 'Vidi Aldiano', 'L', 'Malang', '2012-11-20', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8E03', 'Wilona Natasha', 'P', 'Malang', '2012-12-25', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8E04', 'Xylone Lee', 'L', 'Malang', '2012-01-30', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS8E05', 'Yura Yunita', 'P', 'Malang', '2012-02-05', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9A01', 'Andhika Wijaya Sr', 'L', 'Malang', '2010-01-10', 'Malang', NULL, NULL, NULL, NULL, NULL, 1, 'Aktif'),
('SIS9A02', 'Edward Tan', 'L', 'Malang', '2011-11-11', 'Malang', NULL, NULL, NULL, NULL, NULL, 3, 'Aktif'),
('SIS9A03', 'Edwin Tan', 'L', 'Malang', '2011-11-11', 'Malang', NULL, NULL, NULL, NULL, NULL, 3, 'Aktif'),
('SIS9A04', 'Ziva Magnolya', 'P', 'Malang', '2011-03-15', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9A05', 'Ariel Noah', 'L', 'Malang', '2011-04-20', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9B01', 'Bunga Citra', 'P', 'Malang', '2011-05-25', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9B02', 'Chico Jericho', 'L', 'Malang', '2011-06-30', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9B03', 'Dian Sastro', 'P', 'Malang', '2011-07-05', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9B04', 'Ello Tahitoe', 'L', 'Malang', '2011-08-10', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9B05', 'Fatin Shidqia', 'P', 'Malang', '2011-09-15', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9C01', 'Giring Ganesha', 'L', 'Malang', '2011-10-20', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9C02', 'Isyana Sarasvati', 'P', 'Malang', '2011-11-25', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9C03', 'Judika Sihotang', 'L', 'Malang', '2011-12-30', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9C04', 'Krisdayanti', 'P', 'Malang', '2011-01-05', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9C05', 'Lyodra Ginting', 'P', 'Malang', '2011-02-10', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9D01', 'Maia Estianty', 'P', 'Malang', '2011-03-15', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9D02', 'Nicky Astria', 'P', 'Malang', '2011-04-20', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9D03', 'Once Mekel', 'L', 'Malang', '2011-05-25', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9D04', 'Pasha Ungu', 'L', 'Malang', '2011-06-30', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9D05', 'Raisa Andriana', 'P', 'Malang', '2011-07-05', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9E01', 'Sheila Dara', 'P', 'Malang', '2011-08-10', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9E02', 'Tora Sudiro', 'L', 'Malang', '2011-09-15', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9E03', 'Ungu Pasha', 'L', 'Malang', '2011-10-20', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9E04', 'Vina Panduwinata', 'P', 'Malang', '2011-11-25', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SIS9E05', 'Wizzy Williana', 'P', 'Malang', '2011-12-30', 'Malang', NULL, NULL, NULL, NULL, NULL, NULL, 'Aktif'),
('SISLUL01', 'Candra Pratama', 'L', 'Malang', '2008-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, 2, 'Lulus'),
('SISLUL02', 'Dina Pratama Sr', 'P', 'Malang', '2008-01-01', 'Malang', NULL, NULL, NULL, NULL, NULL, 2, 'Lulus');

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

--
-- Dumping data untuk tabel `tb_tahun_ajaran`
--

INSERT INTO `tb_tahun_ajaran` (`id_tahun`, `nama_tahun`, `status`, `semester_aktif`) VALUES
(1, '2023/2024', 'Arsip', 'Genap'),
(2, '2024/2025', 'Arsip', 'Genap'),
(3, '2025/2026', 'Aktif', 'Genap');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `tb_admin`
--
ALTER TABLE `tb_admin`
  ADD PRIMARY KEY (`id_admin`);

--
-- Indeks untuk tabel `tb_anggota_kelas`
--
ALTER TABLE `tb_anggota_kelas`
  ADD PRIMARY KEY (`id_anggota`),
  ADD KEY `no_induk` (`no_induk`),
  ADD KEY `id_kelas` (`id_kelas`),
  ADD KEY `id_tahun` (`id_tahun`);

--
-- Indeks untuk tabel `tb_aturan_sp`
--
ALTER TABLE `tb_aturan_sp`
  ADD PRIMARY KEY (`id_aturan_sp`),
  ADD KEY `id_kategori` (`id_kategori`);

--
-- Indeks untuk tabel `tb_feedback_ortu`
--
ALTER TABLE `tb_feedback_ortu`
  ADD PRIMARY KEY (`id_feedback`);

--
-- Indeks untuk tabel `tb_guru`
--
ALTER TABLE `tb_guru`
  ADD PRIMARY KEY (`id_guru`),
  ADD KEY `id_kelas` (`id_kelas`);

--
-- Indeks untuk tabel `tb_jenis_pelanggaran`
--
ALTER TABLE `tb_jenis_pelanggaran`
  ADD PRIMARY KEY (`id_jenis`),
  ADD KEY `id_kategori` (`id_kategori`);

--
-- Indeks untuk tabel `tb_kategori_pelanggaran`
--
ALTER TABLE `tb_kategori_pelanggaran`
  ADD PRIMARY KEY (`id_kategori`);

--
-- Indeks untuk tabel `tb_kelas`
--
ALTER TABLE `tb_kelas`
  ADD PRIMARY KEY (`id_kelas`);

--
-- Indeks untuk tabel `tb_orang_tua`
--
ALTER TABLE `tb_orang_tua`
  ADD PRIMARY KEY (`id_ortu`),
  ADD UNIQUE KEY `nik_ortu` (`nik_ortu`);

--
-- Indeks untuk tabel `tb_pelanggaran_detail`
--
ALTER TABLE `tb_pelanggaran_detail`
  ADD PRIMARY KEY (`id_detail`),
  ADD KEY `id_transaksi` (`id_transaksi`),
  ADD KEY `id_jenis` (`id_jenis`);

--
-- Indeks untuk tabel `tb_pelanggaran_header`
--
ALTER TABLE `tb_pelanggaran_header`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `id_anggota` (`id_anggota`),
  ADD KEY `id_guru` (`id_guru`),
  ADD KEY `id_tahun` (`id_tahun`);

--
-- Indeks untuk tabel `tb_pelanggaran_sanksi`
--
ALTER TABLE `tb_pelanggaran_sanksi`
  ADD PRIMARY KEY (`id_trans_sanksi`),
  ADD KEY `id_transaksi` (`id_transaksi`),
  ADD KEY `id_sanksi_ref` (`id_sanksi_ref`);

--
-- Indeks untuk tabel `tb_predikat_nilai`
--
ALTER TABLE `tb_predikat_nilai`
  ADD PRIMARY KEY (`id_predikat`),
  ADD KEY `id_kategori` (`id_kategori`);

--
-- Indeks untuk tabel `tb_riwayat_sp`
--
ALTER TABLE `tb_riwayat_sp`
  ADD PRIMARY KEY (`id_sp`),
  ADD KEY `id_anggota` (`id_anggota`),
  ADD KEY `id_admin` (`id_admin`);

--
-- Indeks untuk tabel `tb_sanksi_ref`
--
ALTER TABLE `tb_sanksi_ref`
  ADD PRIMARY KEY (`id_sanksi_ref`);

--
-- Indeks untuk tabel `tb_siswa`
--
ALTER TABLE `tb_siswa`
  ADD PRIMARY KEY (`no_induk`),
  ADD KEY `fk_ortu_siswa` (`id_ortu`);

--
-- Indeks untuk tabel `tb_tahun_ajaran`
--
ALTER TABLE `tb_tahun_ajaran`
  ADD PRIMARY KEY (`id_tahun`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `tb_admin`
--
ALTER TABLE `tb_admin`
  MODIFY `id_admin` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `tb_anggota_kelas`
--
ALTER TABLE `tb_anggota_kelas`
  MODIFY `id_anggota` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=103;

--
-- AUTO_INCREMENT untuk tabel `tb_aturan_sp`
--
ALTER TABLE `tb_aturan_sp`
  MODIFY `id_aturan_sp` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT untuk tabel `tb_feedback_ortu`
--
ALTER TABLE `tb_feedback_ortu`
  MODIFY `id_feedback` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `tb_guru`
--
ALTER TABLE `tb_guru`
  MODIFY `id_guru` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT untuk tabel `tb_jenis_pelanggaran`
--
ALTER TABLE `tb_jenis_pelanggaran`
  MODIFY `id_jenis` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- AUTO_INCREMENT untuk tabel `tb_kategori_pelanggaran`
--
ALTER TABLE `tb_kategori_pelanggaran`
  MODIFY `id_kategori` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `tb_kelas`
--
ALTER TABLE `tb_kelas`
  MODIFY `id_kelas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT untuk tabel `tb_orang_tua`
--
ALTER TABLE `tb_orang_tua`
  MODIFY `id_ortu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `tb_pelanggaran_detail`
--
ALTER TABLE `tb_pelanggaran_detail`
  MODIFY `id_detail` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT untuk tabel `tb_pelanggaran_header`
--
ALTER TABLE `tb_pelanggaran_header`
  MODIFY `id_transaksi` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT untuk tabel `tb_pelanggaran_sanksi`
--
ALTER TABLE `tb_pelanggaran_sanksi`
  MODIFY `id_trans_sanksi` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT untuk tabel `tb_predikat_nilai`
--
ALTER TABLE `tb_predikat_nilai`
  MODIFY `id_predikat` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT untuk tabel `tb_riwayat_sp`
--
ALTER TABLE `tb_riwayat_sp`
  MODIFY `id_sp` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `tb_sanksi_ref`
--
ALTER TABLE `tb_sanksi_ref`
  MODIFY `id_sanksi_ref` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT untuk tabel `tb_tahun_ajaran`
--
ALTER TABLE `tb_tahun_ajaran`
  MODIFY `id_tahun` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `tb_anggota_kelas`
--
ALTER TABLE `tb_anggota_kelas`
  ADD CONSTRAINT `tb_anggota_kelas_ibfk_1` FOREIGN KEY (`no_induk`) REFERENCES `tb_siswa` (`no_induk`) ON DELETE CASCADE,
  ADD CONSTRAINT `tb_anggota_kelas_ibfk_2` FOREIGN KEY (`id_kelas`) REFERENCES `tb_kelas` (`id_kelas`),
  ADD CONSTRAINT `tb_anggota_kelas_ibfk_3` FOREIGN KEY (`id_tahun`) REFERENCES `tb_tahun_ajaran` (`id_tahun`);

--
-- Ketidakleluasaan untuk tabel `tb_aturan_sp`
--
ALTER TABLE `tb_aturan_sp`
  ADD CONSTRAINT `tb_aturan_sp_ibfk_1` FOREIGN KEY (`id_kategori`) REFERENCES `tb_kategori_pelanggaran` (`id_kategori`);

--
-- Ketidakleluasaan untuk tabel `tb_guru`
--
ALTER TABLE `tb_guru`
  ADD CONSTRAINT `tb_guru_ibfk_1` FOREIGN KEY (`id_kelas`) REFERENCES `tb_kelas` (`id_kelas`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `tb_jenis_pelanggaran`
--
ALTER TABLE `tb_jenis_pelanggaran`
  ADD CONSTRAINT `tb_jenis_pelanggaran_ibfk_1` FOREIGN KEY (`id_kategori`) REFERENCES `tb_kategori_pelanggaran` (`id_kategori`);

--
-- Ketidakleluasaan untuk tabel `tb_pelanggaran_detail`
--
ALTER TABLE `tb_pelanggaran_detail`
  ADD CONSTRAINT `tb_pelanggaran_detail_ibfk_1` FOREIGN KEY (`id_transaksi`) REFERENCES `tb_pelanggaran_header` (`id_transaksi`) ON DELETE CASCADE,
  ADD CONSTRAINT `tb_pelanggaran_detail_ibfk_2` FOREIGN KEY (`id_jenis`) REFERENCES `tb_jenis_pelanggaran` (`id_jenis`);

--
-- Ketidakleluasaan untuk tabel `tb_pelanggaran_header`
--
ALTER TABLE `tb_pelanggaran_header`
  ADD CONSTRAINT `tb_pelanggaran_header_ibfk_1` FOREIGN KEY (`id_anggota`) REFERENCES `tb_anggota_kelas` (`id_anggota`),
  ADD CONSTRAINT `tb_pelanggaran_header_ibfk_2` FOREIGN KEY (`id_guru`) REFERENCES `tb_guru` (`id_guru`),
  ADD CONSTRAINT `tb_pelanggaran_header_ibfk_3` FOREIGN KEY (`id_tahun`) REFERENCES `tb_tahun_ajaran` (`id_tahun`);

--
-- Ketidakleluasaan untuk tabel `tb_pelanggaran_sanksi`
--
ALTER TABLE `tb_pelanggaran_sanksi`
  ADD CONSTRAINT `tb_pelanggaran_sanksi_ibfk_1` FOREIGN KEY (`id_transaksi`) REFERENCES `tb_pelanggaran_header` (`id_transaksi`) ON DELETE CASCADE,
  ADD CONSTRAINT `tb_pelanggaran_sanksi_ibfk_2` FOREIGN KEY (`id_sanksi_ref`) REFERENCES `tb_sanksi_ref` (`id_sanksi_ref`);

--
-- Ketidakleluasaan untuk tabel `tb_predikat_nilai`
--
ALTER TABLE `tb_predikat_nilai`
  ADD CONSTRAINT `tb_predikat_nilai_ibfk_1` FOREIGN KEY (`id_kategori`) REFERENCES `tb_kategori_pelanggaran` (`id_kategori`);

--
-- Ketidakleluasaan untuk tabel `tb_riwayat_sp`
--
ALTER TABLE `tb_riwayat_sp`
  ADD CONSTRAINT `tb_riwayat_sp_ibfk_1` FOREIGN KEY (`id_anggota`) REFERENCES `tb_anggota_kelas` (`id_anggota`),
  ADD CONSTRAINT `tb_riwayat_sp_ibfk_2` FOREIGN KEY (`id_admin`) REFERENCES `tb_admin` (`id_admin`);

--
-- Ketidakleluasaan untuk tabel `tb_siswa`
--
ALTER TABLE `tb_siswa`
  ADD CONSTRAINT `fk_ortu_siswa` FOREIGN KEY (`id_ortu`) REFERENCES `tb_orang_tua` (`id_ortu`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
