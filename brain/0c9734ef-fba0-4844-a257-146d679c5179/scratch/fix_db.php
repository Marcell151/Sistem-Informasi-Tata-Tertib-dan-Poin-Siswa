<?php
require_once 'config/database.php';

try {
    $pdo = getDBConnection();
    
    // 1. Tambahkan kolom status_pelanggaran jika belum ada
    echo "Memeriksa kolom status_pelanggaran di tb_pelanggaran_header...\n";
    $columns = $pdo->query("DESCRIBE tb_pelanggaran_header")->fetchAll(PDO::FETCH_COLUMN);
    
    if (!in_array('status_pelanggaran', $columns)) {
        echo "Menambahkan kolom status_pelanggaran...\n";
        $pdo->exec("ALTER TABLE tb_pelanggaran_header ADD COLUMN status_pelanggaran ENUM('Valid', 'Dibatalkan') DEFAULT 'Valid' AFTER lampiran_link");
        echo "✅ Kolom berhasil ditambahkan.\n";
    } else {
        echo "✅ Kolom sudah ada.\n";
    }

    echo "\nSelesai! Silakan refresh halaman Rekap Kelas.";

} catch (Exception $e) {
    echo "❌ Error: " . $e->getMessage();
}
?>
