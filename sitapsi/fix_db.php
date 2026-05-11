<?php
require_once 'config/database.php';

try {
    $pdo = getDBConnection();
    
    // 1. Tambahkan kolom status_pelanggaran jika belum ada
    echo "<h3>Memeriksa database...</h3>";
    $columns = $pdo->query("DESCRIBE tb_pelanggaran_header")->fetchAll(PDO::FETCH_COLUMN);
    
    if (!in_array('status_pelanggaran', $columns)) {
        echo "Menambahkan kolom status_pelanggaran ke tb_pelanggaran_header...<br>";
        $pdo->exec("ALTER TABLE tb_pelanggaran_header ADD COLUMN status_pelanggaran ENUM('Valid', 'Dibatalkan') DEFAULT 'Valid' AFTER lampiran_link");
        echo "✅ <b>Kolom berhasil ditambahkan.</b><br>";
    } else {
        echo "✅ <b>Kolom sudah ada.</b><br>";
    }

    echo "<br><b>Selesai!</b> Silakan kembali ke halaman Rekap Kelas dan refresh.";

} catch (Exception $e) {
    echo "❌ <b>Error:</b> " . $e->getMessage();
}
?>
