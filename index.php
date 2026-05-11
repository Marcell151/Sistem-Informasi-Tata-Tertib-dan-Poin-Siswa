<?php
/**
 * PORTAL TERPADU - Halaman Utama (Pre-Login)
 * SMPK Santa Maria 2 Malang
 */
header("Location: login.php");
exit;

session_start();
// ... rest of the code is preserved but will not be executed due to the redirect above
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portal Terpadu - SMPK Santa Maria 2</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Plus Jakarta Sans', sans-serif; }
        .glass-card {
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        .hero-gradient {
            background: radial-gradient(circle at top right, #e0e7ff 0%, #f8fafc 50%);
        }
    </style>
</head>
<body class="bg-slate-50 min-h-screen hero-gradient">

    <!-- Background Decoration -->
    <div class="fixed inset-0 pointer-events-none z-0 overflow-hidden">
        <div class="absolute -top-24 -right-24 w-96 h-96 bg-blue-100 rounded-full mix-blend-multiply filter blur-3xl opacity-50 animate-pulse"></div>
        <div class="absolute top-1/2 -left-24 w-72 h-72 bg-indigo-100 rounded-full mix-blend-multiply filter blur-3xl opacity-50 animate-pulse" style="animation-delay: 2s;"></div>
    </div>

    <!-- Navigation -->
    <nav class="relative z-10 px-6 py-6 max-w-7xl mx-auto flex justify-between items-center">
        <div class="flex items-center gap-3">
            <div class="w-12 h-12 bg-white rounded-2xl shadow-sm p-2 flex items-center justify-center border border-slate-100">
                <img src="sitapsi/assets/img/logo.png" alt="Logo" class="w-full h-full object-contain">
            </div>
            <div>
                <h1 class="text-xl font-extrabold text-slate-800 tracking-tight leading-none">Portal Terpadu</h1>
                <p class="text-[10px] font-bold text-slate-500 uppercase tracking-widest mt-1">SMPK Santa Maria 2</p>
            </div>
        </div>
        <div>
            <?php if ($is_logged_in): ?>
                <a href="launchpad.php" class="px-6 py-2.5 bg-[#000080] text-white rounded-full font-bold text-sm shadow-lg shadow-blue-900/20 hover:bg-blue-900 transition-all">
                    Kembali ke Launchpad
                </a>
            <?php else: ?>
                <a href="login.php" class="px-6 py-2.5 bg-white text-slate-700 border border-slate-200 rounded-full font-bold text-sm hover:border-[#000080] hover:text-[#000080] transition-all">
                    Login SSO
                </a>
            <?php endif; ?>
        </div>
    </nav>

    <!-- Hero Section -->
    <header class="relative z-10 max-w-7xl mx-auto px-6 pt-16 pb-20 text-center">
        <div class="inline-block px-4 py-1.5 bg-blue-50 border border-blue-100 rounded-full text-[#000080] text-[11px] font-extrabold uppercase tracking-widest mb-6">
            Pusat Layanan Digital Terintegrasi
        </div>
        <h2 class="text-4xl md:text-6xl font-extrabold text-slate-900 mb-6 tracking-tight leading-[1.1]">
            Satu Pintu untuk Semua <br/>
            <span class="text-transparent bg-clip-text bg-gradient-to-r from-[#000080] to-blue-500">Layanan Sekolah.</span>
        </h2>
        <p class="text-slate-500 text-lg max-w-2xl mx-auto font-medium">
            Selamat datang di Portal Terpadu SMPK Santa Maria 2 Malang. <br class="hidden md:block"> Silakan pilih layanan sistem informasi yang ingin Anda gunakan.
        </p>
    </header>

    <!-- App Grid -->
    <main class="relative z-10 max-w-6xl mx-auto px-6 pb-24">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            
            <!-- SITAPSI -->
            <a href="login.php?modul=sitapsi" class="group relative bg-white rounded-[2.5rem] p-8 border border-slate-200 shadow-sm hover:shadow-2xl hover:shadow-blue-900/10 hover:border-[#000080] transition-all duration-500 flex flex-col h-full overflow-hidden">
                <div class="absolute -top-12 -right-12 w-48 h-48 bg-blue-50 rounded-full group-hover:scale-150 transition-transform duration-700 -z-0"></div>
                
                <div class="relative z-10">
                    <div class="w-16 h-16 bg-[#000080] text-white rounded-3xl flex items-center justify-center mb-8 shadow-xl shadow-blue-900/30 group-hover:rotate-6 transition-transform">
                        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2.5"><path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                    </div>
                    <h3 class="text-2xl font-extrabold text-slate-800 mb-3">SITAPSI</h3>
                    <p class="text-slate-500 font-medium leading-relaxed mb-8">
                        Sistem Informasi Tata Tertib & Kedisiplinan Siswa. Pantau poin dan prestasi siswa secara real-time.
                    </p>
                    <div class="mt-auto flex items-center text-[#000080] font-extrabold text-sm uppercase tracking-wider">
                        Masuk Sistem <svg class="w-5 h-5 ml-2 group-hover:translate-x-2 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2.5"><path d="M13 7l5 5-5 5M6 12h12"></path></svg>
                    </div>
                </div>
            </a>

            <!-- SLIMS -->
            <a href="slims" class="group relative bg-white rounded-[2.5rem] p-8 border border-slate-200 shadow-sm hover:shadow-2xl hover:shadow-emerald-900/10 hover:border-emerald-500 transition-all duration-500 flex flex-col h-full overflow-hidden">
                <div class="absolute -top-12 -right-12 w-48 h-48 bg-emerald-50 rounded-full group-hover:scale-150 transition-transform duration-700 -z-0"></div>
                
                <div class="relative z-10">
                    <div class="w-16 h-16 bg-emerald-500 text-white rounded-3xl flex items-center justify-center mb-8 shadow-xl shadow-emerald-900/30 group-hover:rotate-6 transition-transform">
                        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2.5"><path d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path></svg>
                    </div>
                    <h3 class="text-2xl font-extrabold text-slate-800 mb-3">Senayan (SLiMS)</h3>
                    <p class="text-slate-500 font-medium leading-relaxed mb-8">
                        Perpustakaan Digital Terintegrasi. Telusuri koleksi buku, literasi digital, dan peminjaman secara daring.
                    </p>
                    <div class="mt-auto flex items-center text-emerald-600 font-extrabold text-sm uppercase tracking-wider">
                        Buka Katalog <svg class="w-5 h-5 ml-2 group-hover:translate-x-2 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2.5"><path d="M13 7l5 5-5 5M6 12h12"></path></svg>
                    </div>
                </div>
            </a>

            <!-- Website Sekolah -->
            <a href="https://smpksantamaria2malang.sch.id/" target="_blank" class="group relative bg-white rounded-[2.5rem] p-8 border border-slate-200 shadow-sm hover:shadow-2xl hover:shadow-amber-900/10 hover:border-amber-500 transition-all duration-500 flex flex-col h-full overflow-hidden">
                <div class="absolute -top-12 -right-12 w-48 h-48 bg-amber-50 rounded-full group-hover:scale-150 transition-transform duration-700 -z-0"></div>
                
                <div class="relative z-10">
                    <div class="w-16 h-16 bg-amber-500 text-white rounded-3xl flex items-center justify-center mb-8 shadow-xl shadow-amber-900/30 group-hover:rotate-6 transition-transform">
                        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2.5"><path d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9"></path></svg>
                    </div>
                    <h3 class="text-2xl font-extrabold text-slate-800 mb-3">Website Utama</h3>
                    <p class="text-slate-500 font-medium leading-relaxed mb-8">
                        Informasi profil sekolah, berita terbaru, pengumuman, dan galeri kegiatan SMPK Santa Maria 2.
                    </p>
                    <div class="mt-auto flex items-center text-amber-600 font-extrabold text-sm uppercase tracking-wider">
                        Kunjungi Web <svg class="w-5 h-5 ml-2 group-hover:translate-x-2 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2.5"><path d="M13 7l5 5-5 5M6 12h12"></path></svg>
                    </div>
                </div>
            </a>

        </div>

        <!-- Secondary Info -->
        <div class="mt-20 grid grid-cols-1 md:grid-cols-2 gap-8 items-center bg-[#000080]/5 rounded-[3rem] p-10 border border-blue-100">
            <div>
                <h4 class="text-2xl font-extrabold text-[#000080] mb-4">Butuh Bantuan Akses?</h4>
                <p class="text-slate-600 font-medium mb-6">
                    Jika Anda adalah Guru, Karyawan, atau Orang Tua Siswa yang mengalami kendala saat login ke dalam sistem, silakan hubungi bagian Tata Usaha atau Tim IT Sekolah.
                </p>
                <div class="flex flex-wrap gap-4">
                    <div class="flex items-center gap-3 bg-white px-5 py-3 rounded-2xl border border-slate-100 shadow-sm">
                        <div class="w-8 h-8 bg-blue-100 text-[#000080] rounded-full flex items-center justify-center">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"></path></svg>
                        </div>
                        <span class="text-sm font-bold text-slate-700">(0341) 325515</span>
                    </div>
                </div>
            </div>
            <div class="hidden md:block text-right">
                <img src="sitapsi/assets/img/logo.png" alt="Decoration" class="inline-block w-48 opacity-10 grayscale brightness-0">
            </div>
        </div>
    </main>

    <footer class="relative z-10 border-t border-slate-200 bg-white py-12 text-center">
        <p class="text-sm font-bold text-slate-400 uppercase tracking-[0.2em]">
            &copy; <?= date('Y') ?> SMPK Santa Maria 2 Malang. All Rights Reserved.
        </p>
    </footer>

</body>
</html>
