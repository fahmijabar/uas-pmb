<?php

header('Content-Type: application/json');

include 'koneksi.php';

$id = $_POST['id'];

$query = mysqli_query(
    $koneksi,
    "DELETE FROM kategori
     WHERE id='$id'"
);

if ($query) {
    echo json_encode([
        "success" => true,
        "message" => "Kategori berhasil dihapus"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => mysqli_error($koneksi)
    ]);
}

?>