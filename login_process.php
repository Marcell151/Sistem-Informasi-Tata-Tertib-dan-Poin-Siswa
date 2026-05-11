<?php

session_start();
require_once 'config/database.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $login_type = $_POST['login_type'] ?? '';
    $remember_me = isset($_POST['remember_me']);

    try {
        if ($login_type === 'admin') {
            // PROSES LOGIN ADMIN
            $username = trim($_POST['username']);
            $password = $_POST['password']; 

            $admin = fetchOne("SELECT * FROM tb_admin WHERE username = :user AND password = :pass AND status = 'Aktif'", [
                'user' => $username,
                'pass' => $password
            ]);

            if ($admin) {
                // 1. Session untuk Portal Utama
                $_SESSION['user_id'] = $admin['id_admin'];
                $_SESSION['nama_lengkap'] = $admin['nama_lengkap'];
                
                // DISESUAIKAN: Mengambil role langsung dari DB (Admin / AdminTatib)
                $_SESSION['role'] = $admin['role']; 
                
                // 2. Session "Jembatan" agar SITAPSI lama tidak error
                $_SESSION['username'] = $admin['username'];
                $_SESSION['login_type'] = 'admin';
                $_SESSION['login_time'] = time();

                // Logika penentuan folder & file tujuan (sama seperti di launchpad)
                $role = $_SESSION['role'];
                $folder_tujuan = (in_array($role, ['AdminPusat', 'Admin', 'KepalaSekolah'])) ? 'admin' : strtolower($role);
                $file_tujuan   = (in_array($role, ['AdminPusat', 'Admin', 'KepalaSekolah'])) ? 'dashboard' : 'input_pelanggaran';

                if ($remember_me) {
                    setcookie('saved_admin_user', $username, time() + (86400 * 30), "/");
                    setcookie('saved_admin_pass', $password, time() + (86400 * 30), "/");
                } else {
                    setcookie('saved_admin_user', '', time() - 3600, "/");
                    setcookie('saved_admin_pass', '', time() - 3600, "/");
                }

                if (isset($_POST['redirect_to']) && $_POST['redirect_to'] === 'sitapsi') {
                    header("Location: sitapsi/views/" . $folder_tujuan . "/" . $file_tujuan . ".php");
                } else {
                    header("Location: launchpad.php");
                }
                exit;
            } else {
                throw new Exception("Username/Password salah, atau akun Admin sedang dinonaktifkan!");
            }

        } elseif ($login_type === 'guru') {
            // PROSES LOGIN GURU
            $id_guru = $_POST['id_guru'];
            $pin = $_POST['pin_validasi'];

            $guru = fetchOne("SELECT * FROM tb_guru WHERE id_guru = :id AND pin_validasi = :pin AND status = 'Aktif'", [
                'id' => $id_guru,
                'pin' => $pin
            ]);

            if ($guru) {
                $_SESSION['user_id'] = $guru['id_guru'];
                $_SESSION['nama_lengkap'] = $guru['nama_guru'];
                $_SESSION['role'] = 'Guru';
                
                $_SESSION['username'] = $guru['nama_guru'];
                $_SESSION['login_type'] = 'guru';
                $_SESSION['login_time'] = time();

                if ($remember_me) {
                    setcookie('saved_guru_id', $id_guru, time() + (86400 * 30), "/");
                    setcookie('saved_guru_pin', $pin, time() + (86400 * 30), "/");
                } else {
                    setcookie('saved_guru_id', '', time() - 3600, "/");
                    setcookie('saved_guru_pin', '', time() - 3600, "/");
                }

                if (isset($_POST['redirect_to']) && $_POST['redirect_to'] === 'sitapsi') {
                    // Penentuan folder & file untuk guru
                    $folder_guru = 'guru';
                    $file_guru   = 'input_pelanggaran';
                    header("Location: sitapsi/views/" . $folder_guru . "/" . $file_guru . ".php");
                } else {
                    header("Location: launchpad.php");
                }
                exit;
            } else {
                throw new Exception("PIN yang Anda masukkan salah!");
            }
        }
    } catch (Exception $e) {
        $_SESSION['error_message'] = $e->getMessage();
        header("Location: login.php");
        exit;
    }
}
header("Location: login.php");
exit;