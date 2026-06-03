<?php

header('Content-Type: application/json');

include 'koneksi.php';

$id = $_POST['id'];
$nama_kategori = $_POST['nama_kategori'];

$query = mysqli_query(
    $koneksi,
    "UPDATE kategori
     SET nama_kategori='$nama_kategori'
     WHERE id='$id'"
);

if ($query) {
    echo json_encode([
        "success" => true,
        "message" => "Kategori berhasil diupdate"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => mysqli_error($koneksi)
    ]);
}

?>