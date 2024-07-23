-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 23 Jul 2024 pada 08.30
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
-- Database: `uas`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `list_all_books` ()   BEGIN
    SELECT judul FROM buku;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_book_year` (IN `book_id` INT, IN `new_year` YEAR)   BEGIN
    DECLARE book_exists INT;
    
    SELECT COUNT(*) INTO book_exists FROM buku WHERE buku_id = book_id;
    
    IF book_exists > 0 THEN
        UPDATE buku SET tahun_terbit = new_year WHERE buku_id = book_id;
        SELECT 'Book year updated successfully.' AS Result;
    ELSE
        SELECT 'Book not found.' AS Result;
    END IF;
END$$

--
-- Fungsi
--
CREATE DEFINER=`root`@`localhost` FUNCTION `books_in_year_range` (`start_year` YEAR, `end_year` YEAR) RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM buku WHERE tahun_terbit BETWEEN start_year AND end_year;
    RETURN total;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_books` () RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM buku;
    RETURN total;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `anggota`
--

CREATE TABLE `anggota` (
  `anggota_id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telepon` varchar(15) DEFAULT NULL,
  `alamat` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `anggota`
--

INSERT INTO `anggota` (`anggota_id`, `nama`, `email`, `telepon`, `alamat`) VALUES
(1, 'Alice Johnson', 'alice@example.com', '1234567890', '123 Maple St.'),
(2, 'Bob Smith', 'bob@example.com', '2345678901', '456 Oak St.'),
(3, 'Charlie Brown', 'charlie@example.com', '3456789012', '789 Pine St.'),
(4, 'David Wilson', 'david@example.com', '4567890123', '101 Elm St.'),
(5, 'Eve Adams', 'eve@example.com', '5678901234', '202 Birch St.');

-- --------------------------------------------------------

--
-- Struktur dari tabel `buku`
--

CREATE TABLE `buku` (
  `buku_id` int(11) NOT NULL,
  `judul` varchar(255) NOT NULL,
  `pengarang_id` int(11) DEFAULT NULL,
  `penerbit_id` int(11) DEFAULT NULL,
  `tahun_terbit` year(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `buku`
--

INSERT INTO `buku` (`buku_id`, `judul`, `pengarang_id`, `penerbit_id`, `tahun_terbit`) VALUES
(1, 'Updated Book', 1, 1, '1998'),
(3, 'Pride and Prejudice', 3, 2, '0000'),
(4, 'Adventures of Huckleberry Finn', 4, 3, '0000'),
(5, 'The Old Man and the Sea', 5, 4, '1952'),
(6, 'New Book', 2, 3, '2020'),
(7, 'New Book', 2, 3, '2020'),
(8, 'New Book', 2, 3, '2020'),
(9, 'Another New Book', 3, 1, '2021');

--
-- Trigger `buku`
--
DELIMITER $$
CREATE TRIGGER `after_delete_buku` AFTER DELETE ON `buku` FOR EACH ROW BEGIN
    INSERT INTO log (event_type, buku_id, old_value) VALUES ('AFTER DELETE', OLD.buku_id, OLD.judul);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_insert_buku` AFTER INSERT ON `buku` FOR EACH ROW BEGIN
    INSERT INTO log (event_type, buku_id, new_value) VALUES ('AFTER INSERT', NEW.buku_id, NEW.judul);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_update_buku` AFTER UPDATE ON `buku` FOR EACH ROW BEGIN
    INSERT INTO log (event_type, buku_id, old_value, new_value) VALUES ('AFTER UPDATE', OLD.buku_id, OLD.judul, NEW.judul);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_delete_buku` BEFORE DELETE ON `buku` FOR EACH ROW BEGIN
    INSERT INTO log (event_type, buku_id, old_value) VALUES ('BEFORE DELETE', OLD.buku_id, OLD.judul);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_buku` BEFORE INSERT ON `buku` FOR EACH ROW BEGIN
    INSERT INTO log (event_type, buku_id, new_value) VALUES ('BEFORE INSERT', NEW.buku_id, NEW.judul);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_buku` BEFORE UPDATE ON `buku` FOR EACH ROW BEGIN
    INSERT INTO log (event_type, buku_id, old_value, new_value) VALUES ('BEFORE UPDATE', OLD.buku_id, OLD.judul, NEW.judul);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `buku_genre`
--

CREATE TABLE `buku_genre` (
  `buku_id` int(11) NOT NULL,
  `genre_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `buku_genre`
--

INSERT INTO `buku_genre` (`buku_id`, `genre_id`) VALUES
(1, 1),
(3, 3),
(4, 4),
(5, 5);

-- --------------------------------------------------------

--
-- Struktur dari tabel `genre`
--

CREATE TABLE `genre` (
  `genre_id` int(11) NOT NULL,
  `nama_genre` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `genre`
--

INSERT INTO `genre` (`genre_id`, `nama_genre`) VALUES
(1, 'Fantasi'),
(2, 'Fiksi Ilmiah'),
(3, 'Romansa'),
(4, 'Petualangan'),
(5, 'Fiksi Sastra');

-- --------------------------------------------------------

--
-- Struktur dari tabel `log`
--

CREATE TABLE `log` (
  `log_id` int(11) NOT NULL,
  `event_type` varchar(50) DEFAULT NULL,
  `event_time` datetime DEFAULT current_timestamp(),
  `buku_id` int(11) DEFAULT NULL,
  `old_value` varchar(255) DEFAULT NULL,
  `new_value` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `log`
--

INSERT INTO `log` (`log_id`, `event_type`, `event_time`, `buku_id`, `old_value`, `new_value`) VALUES
(1, 'BEFORE INSERT', '2024-07-23 12:44:06', 0, NULL, 'New Book'),
(2, 'AFTER INSERT', '2024-07-23 12:44:06', 6, NULL, 'New Book'),
(3, 'BEFORE UPDATE', '2024-07-23 12:44:06', 1, 'Harry Potter and the Philosopher\'s Stone', 'Updated Book'),
(4, 'AFTER UPDATE', '2024-07-23 12:44:06', 1, 'Harry Potter and the Philosopher\'s Stone', 'Updated Book'),
(6, 'BEFORE INSERT', '2024-07-23 12:47:50', 0, NULL, 'New Book'),
(7, 'AFTER INSERT', '2024-07-23 12:47:50', 7, NULL, 'New Book'),
(8, 'BEFORE UPDATE', '2024-07-23 12:47:50', 1, 'Updated Book', 'Updated Book'),
(9, 'AFTER UPDATE', '2024-07-23 12:47:50', 1, 'Updated Book', 'Updated Book'),
(11, 'BEFORE INSERT', '2024-07-23 12:48:08', 0, NULL, 'New Book'),
(12, 'AFTER INSERT', '2024-07-23 12:48:08', 8, NULL, 'New Book'),
(13, 'BEFORE UPDATE', '2024-07-23 12:48:08', 1, 'Updated Book', 'Updated Book'),
(14, 'AFTER UPDATE', '2024-07-23 12:48:08', 1, 'Updated Book', 'Updated Book'),
(19, 'BEFORE DELETE', '2024-07-23 12:53:30', 2, '1984', NULL),
(20, 'AFTER DELETE', '2024-07-23 12:53:30', 2, '1984', NULL),
(21, 'BEFORE UPDATE', '2024-07-23 13:09:26', 1, 'Updated Book', 'Updated Book'),
(22, 'AFTER UPDATE', '2024-07-23 13:09:26', 1, 'Updated Book', 'Updated Book'),
(23, 'BEFORE UPDATE', '2024-07-23 13:11:17', 1, 'Updated Book', 'Updated Book'),
(24, 'AFTER UPDATE', '2024-07-23 13:11:17', 1, 'Updated Book', 'Updated Book'),
(25, 'BEFORE INSERT', '2024-07-23 13:21:27', 0, NULL, 'Another New Book'),
(26, 'AFTER INSERT', '2024-07-23 13:21:27', 9, NULL, 'Another New Book');

-- --------------------------------------------------------

--
-- Struktur dari tabel `new_index_table`
--

CREATE TABLE `new_index_table` (
  `col1` int(11) NOT NULL,
  `col2` int(11) NOT NULL,
  `col3` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `peminjaman`
--

CREATE TABLE `peminjaman` (
  `peminjaman_id` int(11) NOT NULL,
  `buku_id` int(11) DEFAULT NULL,
  `anggota_id` int(11) DEFAULT NULL,
  `tanggal_pinjam` date NOT NULL,
  `tanggal_kembali` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `peminjaman`
--

INSERT INTO `peminjaman` (`peminjaman_id`, `buku_id`, `anggota_id`, `tanggal_pinjam`, `tanggal_kembali`) VALUES
(1, 1, 1, '2024-01-10', '2024-01-24'),
(3, 3, 3, '2024-01-12', '2024-01-26'),
(4, 4, 4, '2024-01-13', '2024-01-27'),
(5, 5, 5, '2024-01-14', '2024-01-28');

-- --------------------------------------------------------

--
-- Struktur dari tabel `penerbit`
--

CREATE TABLE `penerbit` (
  `penerbit_id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `alamat` varchar(255) DEFAULT NULL,
  `nomor_telepon` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `penerbit`
--

INSERT INTO `penerbit` (`penerbit_id`, `nama`, `alamat`, `nomor_telepon`) VALUES
(1, 'Bloomsbury', '50 Bedford Square, London', '1234567890'),
(2, 'Penguin Books', '80 Strand, London', '0987654321'),
(3, 'HarperCollins', '195 Broadway, New York', '2345678901'),
(4, 'Random House', '1745 Broadway, New York', '3456789012'),
(5, 'Simon & Schuster', '1230 Avenue of the Americas, New York', '4567890123');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengarang`
--

CREATE TABLE `pengarang` (
  `pengarang_id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `kewarganegaraan` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pengarang`
--

INSERT INTO `pengarang` (`pengarang_id`, `nama`, `tanggal_lahir`, `kewarganegaraan`) VALUES
(1, 'J.K. Rowling', '1965-07-31', 'Inggris'),
(2, 'George Orwell', '1903-06-25', 'Inggris'),
(3, 'Jane Austen', '1775-12-16', 'Inggris'),
(4, 'Mark Twain', '1835-11-30', 'Amerika'),
(5, 'Ernest Hemingway', '1899-07-21', 'Amerika');

-- --------------------------------------------------------

--
-- Struktur dari tabel `profil`
--

CREATE TABLE `profil` (
  `profil_id` int(11) NOT NULL,
  `anggota_id` int(11) DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `profil`
--

INSERT INTO `profil` (`profil_id`, `anggota_id`, `tanggal_lahir`, `foto`) VALUES
(1, 1, '1990-05-15', 'foto_alice.jpg'),
(2, 2, '1985-11-22', 'foto_bob.jpg'),
(3, 3, '1992-07-30', 'foto_charlie.jpg'),
(4, 4, '1980-03-12', 'foto_david.jpg'),
(5, 5, '1988-09-05', 'foto_eve.jpg');

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `view_detailed_buku`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `view_detailed_buku` (
`buku_id` int(11)
,`judul` varchar(255)
,`pengarang` varchar(100)
,`penerbit` varchar(100)
,`tahun_terbit` year(4)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `view_filtered_buku`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `view_filtered_buku` (
`buku_id` int(11)
,`judul` varchar(255)
,`pengarang` varchar(100)
,`penerbit` varchar(100)
,`tahun_terbit` year(4)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `view_horizontal`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `view_horizontal` (
`buku_id` int(11)
,`judul` varchar(255)
,`pengarang_id` int(11)
,`penerbit_id` int(11)
,`tahun_terbit` year(4)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `view_vertical`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `view_vertical` (
`anggota_id` int(11)
,`nama` varchar(100)
,`email` varchar(100)
,`telepon` varchar(15)
,`alamat` varchar(255)
);

-- --------------------------------------------------------

--
-- Struktur untuk view `view_detailed_buku`
--
DROP TABLE IF EXISTS `view_detailed_buku`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_detailed_buku`  AS SELECT `b`.`buku_id` AS `buku_id`, `b`.`judul` AS `judul`, `p`.`nama` AS `pengarang`, `pen`.`nama` AS `penerbit`, `b`.`tahun_terbit` AS `tahun_terbit` FROM ((`buku` `b` join `pengarang` `p` on(`b`.`pengarang_id` = `p`.`pengarang_id`)) join `penerbit` `pen` on(`b`.`penerbit_id` = `pen`.`penerbit_id`)) ;

-- --------------------------------------------------------

--
-- Struktur untuk view `view_filtered_buku`
--
DROP TABLE IF EXISTS `view_filtered_buku`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_filtered_buku`  AS SELECT `view_detailed_buku`.`buku_id` AS `buku_id`, `view_detailed_buku`.`judul` AS `judul`, `view_detailed_buku`.`pengarang` AS `pengarang`, `view_detailed_buku`.`penerbit` AS `penerbit`, `view_detailed_buku`.`tahun_terbit` AS `tahun_terbit` FROM `view_detailed_buku` WHERE `view_detailed_buku`.`tahun_terbit` > 1950 ;

-- --------------------------------------------------------

--
-- Struktur untuk view `view_horizontal`
--
DROP TABLE IF EXISTS `view_horizontal`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_horizontal`  AS SELECT `buku`.`buku_id` AS `buku_id`, `buku`.`judul` AS `judul`, `buku`.`pengarang_id` AS `pengarang_id`, `buku`.`penerbit_id` AS `penerbit_id`, `buku`.`tahun_terbit` AS `tahun_terbit` FROM `buku` ;

-- --------------------------------------------------------

--
-- Struktur untuk view `view_vertical`
--
DROP TABLE IF EXISTS `view_vertical`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_vertical`  AS SELECT `anggota`.`anggota_id` AS `anggota_id`, `anggota`.`nama` AS `nama`, `anggota`.`email` AS `email`, `anggota`.`telepon` AS `telepon`, `anggota`.`alamat` AS `alamat` FROM `anggota` WHERE `anggota`.`nama` like 'A%' ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `anggota`
--
ALTER TABLE `anggota`
  ADD PRIMARY KEY (`anggota_id`),
  ADD KEY `idx_nama_email` (`nama`,`email`);

--
-- Indeks untuk tabel `buku`
--
ALTER TABLE `buku`
  ADD PRIMARY KEY (`buku_id`),
  ADD KEY `penerbit_id` (`penerbit_id`),
  ADD KEY `idx_pengarang_penerbit` (`pengarang_id`,`penerbit_id`);

--
-- Indeks untuk tabel `buku_genre`
--
ALTER TABLE `buku_genre`
  ADD PRIMARY KEY (`buku_id`,`genre_id`),
  ADD KEY `genre_id` (`genre_id`);

--
-- Indeks untuk tabel `genre`
--
ALTER TABLE `genre`
  ADD PRIMARY KEY (`genre_id`);

--
-- Indeks untuk tabel `log`
--
ALTER TABLE `log`
  ADD PRIMARY KEY (`log_id`);

--
-- Indeks untuk tabel `new_index_table`
--
ALTER TABLE `new_index_table`
  ADD PRIMARY KEY (`col1`,`col2`);

--
-- Indeks untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD PRIMARY KEY (`peminjaman_id`),
  ADD KEY `anggota_id` (`anggota_id`),
  ADD KEY `peminjaman_ibfk_1` (`buku_id`);

--
-- Indeks untuk tabel `penerbit`
--
ALTER TABLE `penerbit`
  ADD PRIMARY KEY (`penerbit_id`);

--
-- Indeks untuk tabel `pengarang`
--
ALTER TABLE `pengarang`
  ADD PRIMARY KEY (`pengarang_id`);

--
-- Indeks untuk tabel `profil`
--
ALTER TABLE `profil`
  ADD PRIMARY KEY (`profil_id`),
  ADD UNIQUE KEY `anggota_id` (`anggota_id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `anggota`
--
ALTER TABLE `anggota`
  MODIFY `anggota_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `buku`
--
ALTER TABLE `buku`
  MODIFY `buku_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `genre`
--
ALTER TABLE `genre`
  MODIFY `genre_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `log`
--
ALTER TABLE `log`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  MODIFY `peminjaman_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `penerbit`
--
ALTER TABLE `penerbit`
  MODIFY `penerbit_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `pengarang`
--
ALTER TABLE `pengarang`
  MODIFY `pengarang_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `profil`
--
ALTER TABLE `profil`
  MODIFY `profil_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `buku`
--
ALTER TABLE `buku`
  ADD CONSTRAINT `buku_ibfk_1` FOREIGN KEY (`pengarang_id`) REFERENCES `pengarang` (`pengarang_id`),
  ADD CONSTRAINT `buku_ibfk_2` FOREIGN KEY (`penerbit_id`) REFERENCES `penerbit` (`penerbit_id`);

--
-- Ketidakleluasaan untuk tabel `buku_genre`
--
ALTER TABLE `buku_genre`
  ADD CONSTRAINT `buku_genre_ibfk_2` FOREIGN KEY (`genre_id`) REFERENCES `genre` (`genre_id`);

--
-- Ketidakleluasaan untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD CONSTRAINT `peminjaman_ibfk_1` FOREIGN KEY (`buku_id`) REFERENCES `buku` (`buku_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `peminjaman_ibfk_2` FOREIGN KEY (`anggota_id`) REFERENCES `anggota` (`anggota_id`);

--
-- Ketidakleluasaan untuk tabel `profil`
--
ALTER TABLE `profil`
  ADD CONSTRAINT `profil_ibfk_1` FOREIGN KEY (`anggota_id`) REFERENCES `anggota` (`anggota_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
