<?php

header('Content-Type: application/json');

include 'koneksi.php';

$nama_kategori = $_POST['nama_kategori'];

$query = mysqli_query(
    $koneksi,
    "INSERT INTO kategori(nama_kategori)
     VALUES('$nama_kategori')"
);

if ($query) {
    echo json_encode([
        "success" => true,
        "message" => "Kategori berhasil ditambahkan"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => mysqli_error($koneksi)
    ]);
}

?>