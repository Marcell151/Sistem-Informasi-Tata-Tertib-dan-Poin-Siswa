<?php
require_once '../../config/database.php';
require_once '../includes/session_check.php';

header('Content-Type: application/json');

$id = $_GET['id'] ?? null;

if (!$id) {
    echo json_encode(['error' => 'ID missing']);
    exit;
}

$data = fetchOne("SELECT balasan_admin FROM tb_feedback_ortu WHERE id_feedback = :id", ['id' => $id]);

echo json_encode($data ?: ['balasan_admin' => null]);
?>
