-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 12, 2026 at 03:01 PM
-- Server version: 8.4.3
-- PHP Version: 8.3.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `receitadevovo`
--

-- --------------------------------------------------------

--
-- Table structure for table `addresses`
--

CREATE TABLE `addresses` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `label` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Casa',
  `cep` varchar(9) COLLATE utf8mb4_unicode_ci NOT NULL,
  `street` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `complement` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `neighborhood` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `recipient_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cpf` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zipcode` varchar(9) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `addresses`
--

INSERT INTO `addresses` (`id`, `user_id`, `label`, `cep`, `street`, `number`, `complement`, `neighborhood`, `city`, `state`, `reference`, `is_default`, `recipient_name`, `cpf`, `phone`, `zipcode`, `created_at`, `updated_at`) VALUES
(1, 2, 'Casa', '06445070', 'Rua Guarujá', '66', 'Casa', 'Jardim Maria Helena', 'Barueri', 'SP', NULL, 1, 'Wagner Gusmão', '26432620856', '11943896903', '06445070', '2026-05-20 13:59:42', '2026-05-20 13:59:42');

-- --------------------------------------------------------

--
-- Table structure for table `batches`
--

CREATE TABLE `batches` (
  `id` bigint UNSIGNED NOT NULL,
  `raw_material_id` bigint UNSIGNED NOT NULL,
  `supplier_id` bigint UNSIGNED DEFAULT NULL,
  `batch_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `internal_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity_received` decimal(12,3) NOT NULL,
  `quantity_remaining` decimal(12,3) NOT NULL,
  `unit_cost` decimal(10,4) NOT NULL,
  `total_cost` decimal(12,2) GENERATED ALWAYS AS ((`quantity_received` * `unit_cost`)) STORED,
  `manufactured_at` date DEFAULT NULL,
  `expires_at` date DEFAULT NULL,
  `status` enum('active','depleted','expired','quarantine') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `batches`
--

INSERT INTO `batches` (`id`, `raw_material_id`, `supplier_id`, `batch_number`, `internal_code`, `quantity_received`, `quantity_remaining`, `unit_cost`, `manufactured_at`, `expires_at`, `status`, `notes`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 'SI-15-N5KJ', 'LOT-MWAE7YRB', 1.000, 2.000, 1.2000, NULL, NULL, 'active', 'SmartInput #15: BISNAGA BRANCA PE 60G', '2026-05-21 02:48:19', '2026-05-21 14:12:15'),
(2, 2, 2, 'SI-16-ETJK', 'LOT-7G2A4LZQ', 10.000, 20.000, 1.5997, NULL, NULL, 'active', 'SmartInput #16: OLEO- ESSENCIAL DE LARANJA DOCE - BALLON', '2026-05-21 13:36:30', '2026-05-21 14:16:16'),
(3, 3, 2, 'SI-16-0IBN', 'LOT-CLXIWO1G', 10.000, 20.000, 2.5000, NULL, NULL, 'active', 'SmartInput #16: OLEO- ESSENCIAL DE LAVANDA - BALLON', '2026-05-21 13:36:30', '2026-05-21 14:15:55'),
(4, 4, 2, 'SI-16-DVZ4', 'LOT-YMF89WQU', 100.000, 200.000, 0.2600, NULL, NULL, 'active', 'SmartInput #16: ESS LAVANDA INGLESA - OAK', '2026-05-21 13:36:30', '2026-05-21 14:15:21'),
(5, 5, 2, 'SI-16-GD7S', 'LOT-I2DLHYEY', 100.000, 200.000, 0.2400, NULL, NULL, 'active', 'SmartInput #16: ESS LAVANDA FRANCESA - OAK', '2026-05-21 13:36:30', '2026-05-21 14:15:04'),
(6, 6, 2, 'SI-16-G68C', 'LOT-TBR4REN0', 100.000, 200.000, 0.2800, NULL, NULL, 'active', 'SmartInput #16: ESS LAVANDA & ALGODAO MAHOGANY- ISAN', '2026-05-21 13:36:30', '2026-05-21 14:14:50'),
(7, 7, 2, 'SI-16-O6JV', 'LOT-CMBDKE1W', 100.000, 200.000, 0.2496, NULL, NULL, 'active', 'SmartInput #16: ESS LAVANDA PROVENCE - LESS', '2026-05-21 13:36:30', '2026-05-21 14:14:34'),
(8, 8, 2, 'SI-16-RCJ2', 'LOT-H7T1ZY7X', 100.000, 200.000, 0.2796, NULL, NULL, 'active', 'SmartInput #16: ESS ALMISCAR - DOMO', '2026-05-21 13:36:30', '2026-05-21 14:13:57'),
(9, 9, 2, 'SI-16-UYII', 'LOT-YAZJSSLY', 100.000, 200.000, 0.2200, NULL, NULL, 'active', 'SmartInput #16: ESS ROSAS BRANCAS- LESSENCE', '2026-05-21 13:36:30', '2026-05-21 14:13:34'),
(10, 10, 3, 'SI-18-SQZQ', 'LOT-4K6Q9DVE', 10.000, 20.000, 0.8100, NULL, NULL, 'active', 'SmartInput #18: Frasco PET 220ML Malta R. 24/415 Laranja', '2026-05-21 14:49:38', '2026-05-21 14:49:38'),
(11, 11, 3, 'SI-18-4TRC', 'LOT-X2EHABT7', 10.000, 20.000, 0.8100, NULL, NULL, 'active', 'SmartInput #18: Frasco PET 220ml Malta R.24/415 Azul', '2026-05-21 14:49:38', '2026-05-21 14:49:38'),
(12, 12, 3, 'SI-18-OVH3', 'LOT-SUPJXRGL', 12.000, 24.000, 0.8300, NULL, NULL, 'active', 'SmartInput #18: Frasco PET 220ml Malta R.24/415 Cristal', '2026-05-21 14:49:38', '2026-05-21 14:49:38'),
(13, 14, 3, 'SI-18-Z5I5', 'LOT-7X4JV413', 37.000, 74.000, 1.1300, NULL, NULL, 'active', 'SmartInput #18: Tampa Disk TOP 24/410 Luxo Prata Fosco', '2026-05-21 14:49:38', '2026-05-21 14:49:38'),
(14, 13, 3, 'SI-18-NYAZ', 'LOT-YTVSTGFF', 37.000, 74.000, 1.2000, NULL, NULL, 'active', 'SmartInput #18: Frasco PET 300ml Cilreto saturno 24/410', '2026-05-21 14:49:38', '2026-05-21 14:49:38'),
(15, 15, 3, 'SI-18-C1O3', 'LOT-LCURMTD4', 12.000, 24.000, 0.8300, NULL, NULL, 'active', 'SmartInput #18: Tampa Disk TOP 24/415 Natural R.27822', '2026-05-21 14:49:38', '2026-05-21 14:49:38'),
(16, 16, 3, 'SI-18-ULRI', 'LOT-CTKZU2KQ', 10.000, 20.000, 0.6400, NULL, NULL, 'active', 'SmartInput #18: Tampa Disk TOP 24/415 Branca 27827', '2026-05-21 14:49:38', '2026-05-21 14:49:38'),
(17, 17, 3, 'SI-18-MKYM', 'LOT-9RHLVRX4', 10.000, 20.000, 0.6400, NULL, NULL, 'active', 'SmartInput #18: Tampa Disk TOP 24/415 Laranja', '2026-05-21 14:49:38', '2026-05-21 14:49:38'),
(18, 18, 3, 'SI-18-4FJV', 'LOT-QEOOQWRH', 4.000, 8.000, 25.7500, NULL, NULL, 'active', 'SmartInput #18: Creme Hidratante Concent 1x4 1kg yant/gi', '2026-05-21 14:49:38', '2026-05-21 14:49:38'),
(19, 19, 1, 'SI-20-WRUJ', 'LOT-EI01AYJU', 1.000, 0.000, 63.0000, NULL, NULL, 'depleted', 'SmartInput #20: Laauril 2000 Decilglucosideo 50', '2026-05-21 15:17:25', '2026-06-10 03:21:18'),
(20, 20, 1, 'SI-20-HWPM', 'LOT-IXB25UET', 1.000, 2.000, 32.5000, NULL, NULL, 'active', 'SmartInput #20: Lauril Vegetal VG', '2026-05-21 15:17:25', '2026-05-21 15:17:25'),
(21, 21, 1, 'SI-20-KMT4', 'LOT-T4PDEGJO', 30.000, 60.000, 1.3400, NULL, NULL, 'active', 'SmartInput #20: ESS G. Armani My Way FEM Linha 1', '2026-05-21 15:17:25', '2026-05-21 15:17:25'),
(22, 22, 1, 'SI-20-YF4E', 'LOT-GIKPZLWK', 30.000, 60.000, 1.3400, NULL, NULL, 'active', 'SmartInput #20: ESS Interditada FEM Linha 1', '2026-05-21 15:17:25', '2026-05-21 15:17:25'),
(23, 23, 1, 'SI-20-Q689', 'LOT-3EDYR9OD', 30.000, 60.000, 1.3400, NULL, NULL, 'active', 'SmartInput #20: ESS La Vita Linha 1', '2026-05-21 15:17:25', '2026-05-21 15:17:25'),
(24, 24, 1, 'SI-20-KYWO', 'LOT-M08PKH6R', 30.000, 60.000, 1.3400, NULL, NULL, 'active', 'SmartInput #20: ESSÊNCIA LANCOM LA NUITE LINHA 1', '2026-05-21 15:17:25', '2026-05-21 15:17:25'),
(25, 25, 1, 'SI-20-ELFE', 'LOT-RQLLHQMB', 30.000, 60.000, 1.7400, NULL, NULL, 'active', 'SmartInput #20: ESSÊNCIA ARMAFI – CLUB DE NOITE INTENSO MASC (LINHA ARABE)', '2026-05-21 15:17:25', '2026-05-21 15:17:25'),
(26, 26, 1, 'SI-20-9CUV', 'LOT-F4APM5OS', 100.000, 200.000, 0.2000, NULL, NULL, 'active', 'SmartInput #20: ESSÊNCIA BERGAMOTA ROSA', '2026-05-21 15:17:25', '2026-05-21 15:17:25'),
(27, 27, 1, 'SI-20-JZKJ', 'LOT-GWGXM31C', 100.000, 200.000, 0.2300, NULL, NULL, 'active', 'SmartInput #20: ESSÊNCIA BAMBOO', '2026-05-21 15:17:25', '2026-05-21 15:17:25'),
(28, 28, 1, 'SI-20-GYGG', 'LOT-PRHH0LEI', 100.000, 200.000, 0.2800, NULL, NULL, 'active', 'SmartInput #20: ESSÊNCIA LIS BRANCO ALECRIM', '2026-05-21 15:17:25', '2026-05-21 15:17:25'),
(29, 29, 3, 'SI-21-LVFB', 'LOT-TUEYXJ9X', 50.000, 100.000, 0.1500, NULL, NULL, 'active', 'SmartInput #21: ESS CEDRO SABONETE', '2026-05-21 16:55:01', '2026-05-21 16:55:01'),
(30, 30, 3, 'SI-21-XY5M', 'LOT-KML0JKUP', 50.000, 100.000, 0.1500, NULL, NULL, 'active', 'SmartInput #21: ESS P KIT PATCHOLY', '2026-05-21 16:55:01', '2026-05-21 16:55:01'),
(31, 31, 3, 'SI-21-JEYY', 'LOT-7Z6BI7HV', 1.000, 2.000, 7.3000, NULL, NULL, 'active', 'SmartInput #21: SABONETE LIQUIDO AROMAS YANTRA', '2026-05-21 16:55:01', '2026-05-21 16:55:01'),
(32, 32, 3, 'SI-21-PVZ6', 'LOT-QEIOFBFO', 5.000, 10.000, 1.1500, NULL, NULL, 'active', 'SmartInput #21: VARETA OLHO GREGO MINI', '2026-05-21 16:55:01', '2026-05-21 16:55:01'),
(33, 33, 3, 'SI-21-XEPR', 'LOT-WF245RWX', 3.000, 6.000, 1.4900, NULL, NULL, 'active', 'SmartInput #21: VARETA ESTRELA MADEIRA PEQUENA', '2026-05-21 16:55:01', '2026-05-21 16:55:01'),
(34, 34, 3, 'SI-21-YUYU', 'LOT-JKGKJM5E', 5.000, 10.000, 0.9500, NULL, NULL, 'active', 'SmartInput #21: VARETA FRAMBOESA MINI C/ARGOLA', '2026-05-21 16:55:01', '2026-05-21 16:55:01'),
(35, 35, 3, 'SI-21-KKX5', 'LOT-ARE77TFP', 3.000, 6.000, 0.6000, NULL, NULL, 'active', 'SmartInput #21: VARETA MINI C/ ARGOLA 12CM', '2026-05-21 16:55:01', '2026-05-21 16:55:01'),
(36, 36, 3, 'SI-21-O5PE', 'LOT-OWPKALPA', 7.000, 14.000, 1.6500, NULL, NULL, 'active', 'SmartInput #21: PINGENTE DIFUSOR C/PONTEIRA BOLA MADEIRA', '2026-05-21 16:55:01', '2026-05-21 16:55:01'),
(37, 37, 3, 'SI-22-JWYG', 'LOT-NBAGBNCE', 20.000, 40.000, 1.1000, NULL, NULL, 'active', 'SmartInput #22: VIDRO AMBAR GPP 200ML 28/400 LAVADO', '2026-05-23 03:55:48', '2026-05-23 03:55:48'),
(38, 38, 3, 'SI-22-ALH7', 'LOT-290IK6ZI', 10.000, 20.000, 1.7300, NULL, NULL, 'active', 'SmartInput #22: VALVULA SPRAY LUXO 28/410 SAIA PRETA/NAT', '2026-05-23 03:55:48', '2026-05-23 03:55:48'),
(39, 39, 3, 'SI-22-84FU', 'LOT-09ROKUCB', 10.000, 20.000, 1.4000, NULL, NULL, 'active', 'SmartInput #22: VALVULA GATILHO MINI 28/410 PRETA C/TRV', '2026-05-23 03:55:48', '2026-05-23 03:55:48'),
(40, 40, 3, 'SI-23-MOB9', 'LOT-PWHMKNFA', 10.000, 20.000, 0.5400, NULL, NULL, 'active', 'SmartInput #23: FRASCO PET   35ML BASE VITA 20/410 36/10', '2026-05-23 04:11:19', '2026-05-23 04:11:19'),
(41, 41, 3, 'SI-23-NNQ5', 'LOT-AJI5SRA0', 20.000, 40.000, 0.5500, NULL, NULL, 'active', 'SmartInput #23: FRASCO PET   30ML OVAL 20/410 R.35/10', '2026-05-23 04:11:19', '2026-05-23 04:11:19'),
(42, 42, 3, 'SI-23-W8CU', 'LOT-0TUAVJXW', 10.000, 20.000, 0.5900, NULL, NULL, 'active', 'SmartInput #23: FRASCO PVC  30ML OVAL CRISTAL 18/410 F22', '2026-05-23 04:11:19', '2026-05-23 04:11:19'),
(43, 43, 3, 'SI-23-ZIQG', 'LOT-1UI7AS1U', 20.000, 40.000, 0.5600, NULL, NULL, 'active', 'SmartInput #23: FRASCO PET   60ML OVAL 18/410 8G REF:120', '2026-05-23 04:11:19', '2026-05-23 04:11:19'),
(44, 44, 3, 'SI-23-PPQF', 'LOT-ADEUZT8P', 100.000, 200.000, 0.1900, NULL, NULL, 'active', 'SmartInput #23: FRASCO PET   10ML CILINDRICO 18/410 BCO', '2026-05-23 04:11:20', '2026-05-23 04:11:20'),
(45, 45, 3, 'SI-23-BIQQ', 'LOT-XU2VSJRS', 50.000, 100.000, 0.2800, NULL, NULL, 'active', 'SmartInput #23: TAMPA FLIP TOP 18/410 PINK ISOS', '2026-05-23 04:11:20', '2026-05-23 04:11:20'),
(46, 46, 3, 'SI-23-QHPV', 'LOT-AHTFSZS6', 60.000, 120.000, 0.1300, NULL, NULL, 'active', 'SmartInput #23: TAMPA FLIP TOP OMEGA 18/410 MARROM', '2026-05-23 04:11:20', '2026-05-23 04:11:20'),
(47, 47, 3, 'SI-23-SZQD', 'LOT-0BDV6FFX', 20.000, 40.000, 0.2800, NULL, NULL, 'active', 'SmartInput #23: TAMPA FLIP TOP 18/410 PRETA ABAULADA IS', '2026-05-23 04:11:20', '2026-05-23 04:11:20'),
(48, 48, 3, 'SI-23-VPEO', 'LOT-XHV4PJCC', 20.000, 40.000, 0.1600, NULL, NULL, 'active', 'SmartInput #23: TAMPA FLIP TOP OMEGA 20/410 VERDE R.45', '2026-05-23 04:11:20', '2026-05-23 04:11:20'),
(49, 49, 3, 'SI-23-I4RZ', 'LOT-M8LWOESO', 5.000, 10.000, 0.1500, NULL, NULL, 'active', 'SmartInput #23: TAMPA FLIP TOP OMEGA 20/410 LILAS 08', '2026-05-23 04:11:20', '2026-05-23 04:11:20'),
(50, 50, 3, 'SI-23-GNY7', 'LOT-BPMWFNMH', 10.000, 20.000, 0.6000, NULL, NULL, 'active', 'SmartInput #23: FRASCO AMBAR PET  35ML BASE VIT 20/41 36', '2026-05-23 04:11:20', '2026-05-23 04:11:20'),
(51, 51, 3, 'SI-23-88JK', 'LOT-ODH0XMNJ', 50.000, 100.000, 1.2400, NULL, NULL, 'active', 'SmartInput #23: FRASCO PET  140ML OVAL CRIST.24/415 5969', '2026-05-23 04:11:20', '2026-05-23 04:11:20'),
(52, 52, 3, 'SI-23-WJD8', 'LOT-3QALVHEI', 2.000, 4.000, 25.9900, NULL, NULL, 'active', 'SmartInput #23: POTE  04GRS.CRISTAL/BRANCO C/TP CORES', '2026-05-23 04:11:20', '2026-05-23 04:11:20'),
(53, 53, 3, 'SI-23-9KCS', 'LOT-314EJOLA', 2.000, 4.000, 2.7000, NULL, NULL, 'active', 'SmartInput #23: POTE 500GRS.OVAL PRATA TP FIO OURO/PRATA', '2026-05-23 04:11:20', '2026-05-23 04:11:20'),
(54, 6, 2, 'SI-24-Q3IV', 'LOT-SLHY5AJB', 400.000, 800.000, 0.2800, NULL, NULL, 'active', 'SmartInput #24: ESS LAVANDA & ALGODAO MAHOGANY-ISAN', '2026-05-23 04:25:44', '2026-05-23 04:25:44'),
(55, 54, 2, 'SI-24-JNV8', 'LOT-7TTGPNMX', 100.000, 200.000, 0.4000, NULL, NULL, 'active', 'SmartInput #24: ESS SCANDALO JEAN PAUL FEM - DOMO', '2026-05-23 04:25:44', '2026-05-23 04:25:44'),
(56, 55, 2, 'SI-24-67RM', 'LOT-IVUYHLWS', 50.000, 100.000, 0.9000, NULL, NULL, 'active', 'SmartInput #24: ESS ARABE FAKAR BLACK UNISEX 50ML', '2026-05-23 04:25:44', '2026-05-23 04:25:44'),
(57, 56, 2, 'SI-24-YE6U', 'LOT-W4XBLH08', 50.000, 100.000, 0.9000, NULL, NULL, 'active', 'SmartInput #24: ESS ARABE ROYAL AMBER UNISEX', '2026-05-23 04:25:44', '2026-05-23 04:25:44'),
(58, 57, 2, 'SI-24-5SJQ', 'LOT-NMDGEGGF', 50.000, 96.000, 0.9000, NULL, NULL, 'active', 'SmartInput #24: ESS ARABE DELINIA LA ROSÉ FEM.', '2026-05-23 04:25:44', '2026-06-09 15:42:10'),
(59, 58, 2, 'SI-24-XOIG', 'LOT-2D6BWJDO', 2.000, 4.000, 18.0000, NULL, NULL, 'active', 'SmartInput #24: BASE PARA BODY SPLASH', '2026-05-23 04:25:44', '2026-05-23 04:25:44'),
(60, 59, 2, 'SI-24-PURK', 'LOT-UC1MWDOL', 10.000, 20.000, 2.6500, NULL, NULL, 'active', 'SmartInput #24: FRASCO PET 200ML R 24/410 CRISTAL AURA C/TP', '2026-05-23 04:25:44', '2026-05-23 04:25:44'),
(61, 60, 2, 'SI-24-WEVK', 'LOT-6XP7BDTW', 10.000, 20.000, 1.6500, NULL, NULL, 'active', 'SmartInput #24: VALVULA SPRAY R.24/410 OURO HOT STAMP', '2026-05-23 04:25:44', '2026-05-23 04:25:44'),
(62, 61, 2, 'SI-24-6HLT', 'LOT-ZFU97X2R', 1.000, 2.000, 18.0000, NULL, NULL, 'active', 'SmartInput #24: BASE P PERFUME VEICULO 1LT', '2026-05-23 04:25:44', '2026-05-23 04:25:44'),
(63, 62, 2, 'SI-24-YZOV', 'LOT-AC4NTJWE', 10.000, 20.000, 3.8500, NULL, NULL, 'active', 'SmartInput #24: POTE DE VIDRO REDONDO 30ML C/TP', '2026-05-23 04:25:44', '2026-05-23 04:25:44'),
(64, 63, 4, 'SI-25-YHOS', 'LOT-0Y8FQU40', 1.000, 2.000, 2.0000, NULL, NULL, 'active', 'SmartInput #25: TAMPA PLAST. POTE MET. DOURADA TRADITION', '2026-05-23 04:46:37', '2026-05-23 04:46:37'),
(65, 64, 4, 'SI-25-VE3N', 'LOT-QZXMUPRC', 1.000, 2.000, 3.0000, NULL, NULL, 'active', 'SmartInput #25: POTE PET 1LT WHEY ROSA', '2026-05-23 04:46:37', '2026-05-23 04:46:37'),
(66, 65, 4, 'SI-25-AX2T', 'LOT-FASU1BQY', 100.000, 200.000, 0.1800, NULL, NULL, 'active', 'SmartInput #25: ESS.CLASSIC 7 ERVAS R.CC113 DOMO', '2026-05-23 04:46:37', '2026-05-23 04:46:37'),
(67, 66, 4, 'SI-25-YUNX', 'LOT-TUFWL8MA', 100.000, 200.000, 0.2000, NULL, NULL, 'active', 'SmartInput #25: ESS.CLASSIC CAFE  R GC0059 DOMO', '2026-05-23 04:46:37', '2026-05-23 04:46:37'),
(68, 67, 4, 'SI-25-YPNP', 'LOT-HRRN9GEG', 100.000, 200.000, 0.1800, NULL, NULL, 'active', 'SmartInput #25: ESS.CLASSIC DOVE  17.013 DOMO ZZZ', '2026-05-23 04:46:37', '2026-05-23 04:46:37'),
(69, 68, 4, 'SI-25-L7YO', 'LOT-IQKR54UW', 200.000, 400.000, 0.1000, NULL, NULL, 'active', 'SmartInput #25: ESSENCIA P/AROMATIZADOR MARVEL', '2026-05-23 04:46:37', '2026-05-23 04:46:37'),
(70, 18, 5, 'SI-28-TUMC', 'LOT-MCDL4HHJ', 2.000, 4.000, 27.4900, NULL, NULL, 'active', 'SmartInput #28: Creme Hidratante Concent 1x4 1kg yant/gi', '2026-05-23 05:40:42', '2026-05-23 05:40:42'),
(71, 69, 5, 'SI-28-BPX9', 'LOT-DPEJKBME', 100.000, 200.000, 0.2000, NULL, NULL, 'active', 'SmartInput #28: ESSÊNCIA AMACIANTE DOWNY AZUL', '2026-05-23 05:40:42', '2026-05-23 05:40:42'),
(72, 70, 5, 'SI-28-EYDL', 'LOT-FC0T4WOV', 100.000, 200.000, 0.1900, NULL, NULL, 'active', 'SmartInput #28: ESSÊNCIA ARTEMISA OAK', '2026-05-23 05:40:42', '2026-05-23 05:40:42'),
(73, 71, 5, 'SI-28-H00C', 'LOT-M9Y9BH5A', 100.000, 200.000, 0.1900, NULL, NULL, 'active', 'SmartInput #28: ESSÊNCIA ALECRIM OAK', '2026-05-23 05:40:42', '2026-05-23 05:40:42'),
(74, 72, 5, 'SI-28-PPGH', 'LOT-29EWWGLV', 100.000, 200.000, 0.1900, NULL, NULL, 'active', 'SmartInput #28: ESSÊNCIA DASLU OAK', '2026-05-23 05:40:42', '2026-05-23 05:40:42'),
(75, 75, 5, 'SI-28-MAHP', 'LOT-TJM4O8CN', 50.000, 100.000, 0.6000, NULL, NULL, 'active', 'SmartInput #28: ESSÊNCIA VIP BLACK VOLLMENS', '2026-05-23 05:40:42', '2026-05-23 05:40:42'),
(76, 78, 5, 'SI-28-P0OH', 'LOT-UIWUWPJU', 50.000, 100.000, 0.6500, NULL, NULL, 'active', 'SmartInput #28: ESSÊNCIA GOOD GIRL FEM', '2026-05-23 05:40:42', '2026-05-23 05:40:42'),
(77, 73, 5, 'SI-28-TCNI', 'LOT-WWSS0OFW', 100.000, 200.000, 0.1900, NULL, NULL, 'active', 'SmartInput #28: ESSÊNCIA ARRUDA OAK', '2026-05-23 05:40:42', '2026-05-23 05:40:43'),
(78, 74, 5, 'SI-28-1LZ2', 'LOT-FOLQFU70', 1.000, 2.000, 14.9900, NULL, NULL, 'active', 'SmartInput #28: BODY SPLASH NEUTRO YANTRA', '2026-05-23 05:40:43', '2026-05-23 05:40:43'),
(79, 31, 5, 'SI-28-DAFQ', 'LOT-U54B7JW4', 2.000, 4.000, 8.9900, NULL, NULL, 'active', 'SmartInput #28: SABONETE LIQUIDO AROMAS YANTRA', '2026-05-23 05:40:43', '2026-05-23 05:40:43'),
(80, 27, 5, 'SI-28-SRSG', 'LOT-9GNVLV31', 100.000, 200.000, 0.1900, NULL, NULL, 'active', 'SmartInput #28: ESSÊNCIA BAMBOO', '2026-05-23 05:40:43', '2026-05-23 05:40:43'),
(81, 76, 5, 'SI-28-PPQO', 'LOT-PPVSFPMM', 100.000, 200.000, 0.1900, NULL, NULL, 'active', 'SmartInput #28: ESSÊNCIA CASCA E FOLHA OAK', '2026-05-23 05:40:43', '2026-05-23 05:40:43'),
(82, 77, 5, 'SI-28-0553', 'LOT-CSCFDMC6', 50.000, 100.000, 0.4500, NULL, NULL, 'active', 'SmartInput #28: TAMPA FLIP TOP OMEGA 24/415 BRANCA', '2026-05-23 05:40:43', '2026-05-23 05:40:43'),
(83, 59, 2, 'SI-29-9PHR', 'LOT-QZQNM6CG', 30.000, 60.000, 2.6500, NULL, NULL, 'active', 'SmartInput #29: FRASCO PET 200ML R.24/410 CRISTAL AURA C/TP', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(84, 79, 2, 'SI-29-MSQS', 'LOT-4VOZP41I', 30.000, 60.000, 1.6500, NULL, NULL, 'active', 'SmartInput #29: FRASCO PET 100ML R.24/410 CRISTAL ACQUA - Body Splash', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(85, 60, 2, 'SI-29-BJXV', 'LOT-CCXPUFZ0', 60.000, 120.000, 1.6500, NULL, NULL, 'active', 'SmartInput #29: VALVULA SPRAY R.24/410 OURO HOT STAMP', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(86, 56, 2, 'SI-29-JGF9', 'LOT-T1FIB1JK', 100.000, 200.000, 0.9000, NULL, NULL, 'active', 'SmartInput #29: ESS ARABE ROYAL AMBER UNISEX LESS', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(87, 4, 2, 'SI-29-QR6F', 'LOT-8ZCU6G0T', 100.000, 200.000, 0.2600, NULL, NULL, 'active', 'SmartInput #29: ESS LAVANDA INGLESA - OAK OAK - 5169', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(88, 5, 2, 'SI-29-YXS4', 'LOT-JDGKHGQE', 100.000, 200.000, 0.2400, NULL, NULL, 'active', 'SmartInput #29: ESS LAVANDA FRANCESA - OAK OAK 51690', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(89, 7, 2, 'SI-29-QE46', 'LOT-X2S9Z6NZ', 100.000, 200.000, 0.2500, NULL, NULL, 'active', 'SmartInput #29: ESS LAVANDA PROVENCE - LESS LAP 28675', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(90, 54, 2, 'SI-29-O40K', 'LOT-QRBKPYMT', 100.000, 200.000, 0.4000, NULL, NULL, 'active', 'SmartInput #29: ESS SCANDALO JEAN PAUL FEM - DOMO', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(91, 80, 2, 'SI-29-G4LI', 'LOT-QCBRILO7', 50.000, 100.000, 0.9000, NULL, NULL, 'active', 'SmartInput #29: ESS ARABE ASSAD BOURBON MASC.', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(92, 81, 2, 'SI-29-HKCF', 'LOT-YXVLAGXR', 50.000, 100.000, 0.9000, NULL, NULL, 'active', 'SmartInput #29: ESS ARABE ASSAD MASC. LESS', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(93, 58, 2, 'SI-29-4APK', 'LOT-B87M6AG1', 8.000, 16.000, 18.0000, NULL, NULL, 'active', 'SmartInput #29: BASE PARA BODY SPLASH', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(94, 82, 2, 'SI-29-LDCP', 'LOT-DSAZ3IA7', 2.000, 4.000, 16.0000, NULL, NULL, 'active', 'SmartInput #29: BASE PARA BODY SPLASH S/MICA', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(95, 61, 2, 'SI-29-PX3U', 'LOT-BLJOUUKN', 2.000, 4.000, 18.0000, NULL, NULL, 'active', 'SmartInput #29: BASE P PERFUME VEICULO 1LT', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(96, 37, 3, 'SI-30-UGNL', 'LOT-IXQOXK0T', 126.000, 252.000, 1.1000, NULL, NULL, 'active', 'SmartInput #30: VIDRO AMBAR GPP 200ML 28/400 LAVADO', '2026-06-03 18:05:23', '2026-06-03 18:05:23'),
(97, 38, 3, 'SI-30-KCNN', 'LOT-IF0WLISZ', 63.000, 126.000, 1.7300, NULL, NULL, 'active', 'SmartInput #30: VALVULA SPRAY LUXO 28/410 SAIA PRETA/NAT', '2026-06-03 18:05:23', '2026-06-03 18:05:23'),
(98, 39, 3, 'SI-30-PRQA', 'LOT-HCT2N2SQ', 63.000, 126.000, 1.4000, NULL, NULL, 'active', 'SmartInput #30: VALVULA GATILHO MINI 28/410 PRETA C/TRV', '2026-06-03 18:05:23', '2026-06-03 18:05:23'),
(99, 83, 3, 'SI-30-E3KU', 'LOT-JWIDIDTG', 100.000, 200.000, 0.4200, NULL, NULL, 'active', 'SmartInput #30: VIDRO AMOSTRA 1.8ML TP PRESSAO F2', '2026-06-03 18:05:23', '2026-06-03 18:05:23'),
(100, 78, 5, 'SI-32-QDT1', 'LOT-APFLTY4A', 50.000, 100.000, 0.6500, NULL, NULL, 'active', 'SmartInput #32: ESSÊNCIA GOOD GIRL FEM', '2026-06-03 18:09:35', '2026-06-03 18:09:35'),
(101, 75, 5, 'SI-32-DNIF', 'LOT-DGLRZ90N', 50.000, 100.000, 0.6000, NULL, NULL, 'active', 'SmartInput #32: ESSÊNCIA VIP BLACK VOLLMENS', '2026-06-03 18:09:35', '2026-06-03 18:09:35'),
(102, 84, 7, 'SI-35-OHYM', 'LOT-F3FX45LK', 4.000, 8.000, 3.9900, NULL, NULL, 'active', 'SmartInput #35: LACO DE STRASS CORES - Simples', '2026-06-03 19:41:05', '2026-06-03 19:41:05'),
(103, 85, 7, 'SI-35-L0ZU', 'LOT-APE8BOEG', 13.000, 26.000, 6.4500, NULL, NULL, 'active', 'SmartInput #35: LACO 2 FLORES CAMELIAS - Flores', '2026-06-03 19:41:05', '2026-06-03 19:41:05'),
(104, 86, 7, 'SI-35-QOJM', 'LOT-DPRL2XIW', 2.000, 4.000, 14.9800, NULL, NULL, 'active', 'SmartInput #35: BASE CREME HIDRATANTE NEUTRO C/UREIA YANTAR', '2026-06-03 19:41:05', '2026-06-03 19:41:05'),
(105, 18, 7, 'SI-35-FCTX', 'LOT-YTWJU6WW', 2.000, 4.000, 24.3500, NULL, NULL, 'active', 'SmartInput #35: BASE CREME HIDRATANTE 1.4 1KG-YANTRA', '2026-06-03 19:41:05', '2026-06-03 19:41:05'),
(106, 61, 7, 'SI-35-BQYJ', 'LOT-YKHZOLKN', 4.000, 8.000, 14.7000, NULL, NULL, 'active', 'SmartInput #35: BASE PARA PERFUME 1LITRO YANTRA', '2026-06-03 19:41:05', '2026-06-03 19:41:05'),
(107, 87, 1, 'SI-42-O8TU', 'LOT-AHRKZVPQ', 1.000, 2.000, 24.0000, NULL, NULL, 'active', 'SmartInput #42: BASE SAB. LIQ. VEGETAL VG 1X4 TRANSPARENTE LT', '2026-06-03 20:06:22', '2026-06-03 20:06:22'),
(108, 88, 1, 'SI-42-XQSW', 'LOT-FPCWVL9X', 8.000, 16.000, 5.5000, NULL, NULL, 'active', 'SmartInput #42: ETIQUETA METALIZADA 3UN', '2026-06-03 20:06:22', '2026-06-03 20:06:22'),
(109, 89, 1, 'SI-42-S5B3', 'LOT-K32GBMS1', 2.000, 4.000, 0.5500, NULL, NULL, 'active', 'SmartInput #42: DOSADOR 01ML', '2026-06-03 20:06:22', '2026-06-03 20:06:22'),
(110, 90, 1, 'SI-42-6TXF', 'LOT-2UIEQ9KG', 1.000, 2.000, 24.0000, NULL, NULL, 'active', 'SmartInput #42: BASE SAB. LIQ. VEGETAL VG 1X4 PEROLADA LT', '2026-06-03 20:06:22', '2026-06-03 20:06:22'),
(111, 91, 1, 'SI-42-IMDB', 'LOT-DFBTP6I1', 100.000, 200.000, 0.0600, NULL, NULL, 'active', 'SmartInput #42: RENEX NONILFENOL ETOXILADO 95', '2026-06-03 20:06:22', '2026-06-03 20:06:22'),
(112, 92, 1, 'SI-42-NDBA', 'LOT-EYWUUQVT', 4.000, 8.000, 18.8000, NULL, NULL, 'active', 'SmartInput #42: VIDRO IMP 050ML ARABE COLOR COM VALV. E CAPA UN', '2026-06-03 20:06:22', '2026-06-03 20:06:22'),
(113, 93, 1, 'SI-42-ZPHA', 'LOT-2WDVPCAI', 30.000, 60.000, 0.3000, NULL, NULL, 'active', 'SmartInput #42: ESS VICTORI SECRET PEAR SUGAR LINHA A', '2026-06-03 20:06:22', '2026-06-03 20:06:22'),
(114, 94, 1, 'SI-42-JAWO', 'LOT-LPZJXR4R', 100.000, 200.000, 0.2200, NULL, NULL, 'active', 'SmartInput #42: PAPEL PH NACIONAL', '2026-06-03 20:06:22', '2026-06-03 20:06:22'),
(115, 95, 1, 'SI-42-XBNW', 'LOT-TBYQOCRB', 2.000, 4.000, 3.5000, NULL, NULL, 'active', 'SmartInput #42: ETIQUETAS DIVERSAS TRANSPARENTE C/ 20 UN', '2026-06-03 20:06:22', '2026-06-03 20:06:22'),
(116, 19, 1, 'SI-43-I3PK', 'LOT-5KVKBDDS', 1.000, 2.000, 63.0000, NULL, NULL, 'active', 'SmartInput #43: LAURIL 2000 DECILGLUCOSIDEO 50 1 LT', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(117, 112, 1, 'SI-43-T8JQ', 'LOT-SY0VPZII', 1.000, 1.000, 19.0000, NULL, NULL, 'active', 'SmartInput #43: ANFOTERO BETAINICO COCCAMIDOPROPILBETAINA LITRO', '2026-06-08 21:03:43', '2026-06-10 03:22:07'),
(118, 113, 1, 'SI-43-RS6N', 'LOT-8JYNHQZO', 1.000, 1.000, 33.0000, NULL, NULL, 'active', 'SmartInput #43: BASE CREME LIMNE C/ ROSA MOSQUETA KG 1993 ONU-1993', '2026-06-08 21:03:43', '2026-06-09 15:42:10'),
(119, 114, 1, 'SI-43-HSG7', 'LOT-3BMV0XGH', 100.000, 200.000, 0.0500, NULL, NULL, 'active', 'SmartInput #43: COR 100ML AGUA LILAS', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(120, 115, 1, 'SI-43-M7SD', 'LOT-8ZPZMDLC', 100.000, 200.000, 0.0500, NULL, NULL, 'active', 'SmartInput #43: COR 100ML AGUA LARANJA', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(121, 116, 1, 'SI-43-MJTN', 'LOT-F9LOSFJ1', 1.000, 2.000, 0.0300, NULL, NULL, 'active', 'SmartInput #43: COR ALIM 10ML BRANCO', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(122, 117, 1, 'SI-43-XIGX', 'LOT-QGSV0TL0', 60.000, 120.000, 0.9700, NULL, NULL, 'active', 'SmartInput #43: ESSÊNCIA DIOR SAUVAGE MASC LINHA I', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(123, 24, 1, 'SI-43-AVJD', 'LOT-WCFNX0U0', 60.000, 120.000, 0.9700, NULL, NULL, 'active', 'SmartInput #43: ESS LANCOM LA NUITE LINHA I 060ML', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(124, 118, 1, 'SI-43-TKT5', 'LOT-GRRVAGH0', 100.000, 200.000, 0.0700, NULL, NULL, 'active', 'SmartInput #43: EXTRATO GLICOLICO ABACATE', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(125, 119, 1, 'SI-43-0POX', 'LOT-NYW8J9AZ', 400.000, 800.000, 0.1500, NULL, NULL, 'active', 'SmartInput #43: PROMOCAO ESSENCIA', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(126, 120, 1, 'SI-43-WUEH', 'LOT-J1A5T8EA', 2.000, 4.000, 1.5000, NULL, NULL, 'active', 'SmartInput #43: F143 FORMA DE ACETATO CORACAO DECORADO 15 CAV', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(127, 121, 1, 'SI-43-H5BD', 'LOT-A9V3FFA9', 2.000, 4.000, 1.5000, NULL, NULL, 'active', 'SmartInput #43: F140 FORMA DE ACETATO CORACAO TORTO PEQ 12 CAV', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(128, 122, 1, 'SI-43-BQJK', 'LOT-9WWUQUNO', 2.000, 4.000, 4.6000, NULL, NULL, 'active', 'SmartInput #43: POTE VIDRO TRANSP 030G TAMPA PRATA', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(129, 123, 1, 'SI-43-38KD', 'LOT-QXAXNRBV', 2.000, 4.000, 4.9000, NULL, NULL, 'active', 'SmartInput #43: POTE VIDRO AMBAR 030G TAMPA DOURADA', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(130, 96, 8, 'SI-44-LFYK', 'LOT-BFTUAI8V', 1000.000, 2000.000, 0.0300, NULL, NULL, 'active', 'SmartInput #44: EXTRATO DE ARNICA', '2026-06-08 21:04:07', '2026-06-08 21:04:07'),
(131, 58, 2, 'SI-46-0C2O', 'LOT-5SXOEXWJ', 3.000, 6.000, 20.0000, NULL, NULL, 'active', 'SmartInput #46: BASE PARA BODY SPLASH', '2026-06-09 20:30:13', '2026-06-09 20:30:13'),
(132, 82, 2, 'SI-46-4X1J', 'LOT-8CHHYOIS', 1.000, 2.000, 18.0000, NULL, NULL, 'active', 'SmartInput #46: BASE PARA BODY SPLASH S/MICA', '2026-06-09 20:30:13', '2026-06-09 20:30:13'),
(133, 59, 2, 'SI-46-IGOG', 'LOT-YBAUJ16Y', 30.000, 60.000, 2.6500, NULL, NULL, 'active', 'SmartInput #46: FRASCO PET 200ML R.24/410 CRISTAL AURA C/TP', '2026-06-09 20:30:13', '2026-06-09 20:30:13'),
(134, 60, 2, 'SI-46-HL0B', 'LOT-VREVQDXY', 30.000, 60.000, 1.6500, NULL, NULL, 'active', 'SmartInput #46: VALVULA SPRAY R 24/410 OURO HOT STAMP', '2026-06-09 20:30:13', '2026-06-09 20:30:13'),
(135, 133, 2, 'SI-46-EZOX', 'LOT-X3L0HJX4', 12.000, 24.000, 2.8000, NULL, NULL, 'active', 'SmartInput #46: VALVULA SABONETE R.24/410 LUXO DOURADA/NATURAL - CREME CORPORAL', '2026-06-09 20:30:13', '2026-06-09 20:30:13'),
(136, 54, 2, 'SI-46-OYQC', 'LOT-UJYTECJF', 100.000, 200.000, 0.4000, NULL, NULL, 'active', 'SmartInput #46: ESS SCANDALO JEAN PAUL FEM - DOMO', '2026-06-09 20:30:13', '2026-06-09 20:30:13'),
(137, 57, 2, 'SI-46-EFGB', 'LOT-QD0YTTEH', 100.000, 200.000, 0.4500, NULL, NULL, 'active', 'SmartInput #46: ESS ARABE DELINIA LA ROSÉ FEM. 50ML', '2026-06-09 20:30:13', '2026-06-09 20:30:13');

-- --------------------------------------------------------

--
-- Table structure for table `benefits`
--

CREATE TABLE `benefits` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `icon` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `benefits`
--

INSERT INTO `benefits` (`id`, `name`, `slug`, `description`, `icon`, `created_at`, `updated_at`) VALUES
(1, 'Relaxamento', 'relaxamento', 'Promove relaxamento muscular e mental, aliviando tensões do dia a dia', '😌', '2026-05-14 15:28:19', '2026-05-15 17:54:10'),
(2, 'Energia', 'energia', 'Aumenta a energia e disposição sem causar agitação', '⚡', '2026-05-14 15:28:19', '2026-05-15 17:54:10'),
(3, 'Foco', 'foco', 'Melhora concentração e clareza mental', '🎯', '2026-05-14 15:28:19', '2026-05-15 17:54:10'),
(4, 'Digestão', 'digestao', 'Auxilia no processo digestivo, reduzindo desconfortos estomacais', '🌿', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(5, 'Sono', 'sono', 'Melhora a qualidade do sono e facilita o adormecer naturalmente', '😴', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(6, 'Ansiedade', 'ansiedade', 'Reduz sintomas de ansiedade e promove bem-estar emocional', '🧘', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(7, 'Imunidade', 'imunidade', 'Fortalece o sistema imunológico e aumenta as defesas do corpo', '🛡️', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(8, 'Anti-inflamatório', 'anti-inflamatorio', 'Reduz processos inflamatórios no organismo', '💊', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(9, 'Detox', 'detox', 'Auxilia na eliminação de toxinas e purificação do organismo', '🌱', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(10, 'Antioxidante', 'antioxidante', 'Combate radicais livres e previne envelhecimento precoce', '✨', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(11, 'Circulação', 'circulacao', 'Melhora a circulação sanguínea e saúde cardiovascular', '❤️', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(12, 'Respiratório', 'respiratorio', 'Auxilia no sistema respiratório e desobstrução das vias aéreas', '🌬️', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(13, 'Memória', 'memoria', 'Melhora memória e funções cognitivas', '🧠', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(14, 'TPM', 'tpm', 'Alivia sintomas da tensão pré-menstrual', '🌸', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(15, 'Menopausa', 'menopausa', 'Auxilia no equilíbrio hormonal durante a menopausa', '🦋', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(16, 'Pele', 'pele', 'Promove saúde da pele e aparência jovem', '💆', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(17, 'Cabelo', 'cabelo', 'Fortalece cabelos e estimula crescimento', '💇', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(18, 'Dor', 'dor', 'Alivia dores musculares e articulares', '💪', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(19, 'Colesterol', 'colesterol', 'Auxilia no controle dos níveis de colesterol', '📉', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(20, 'Diabetes', 'diabetes', 'Ajuda no controle glicêmico', '🩺', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(21, 'Peso', 'peso', 'Auxilia no controle de peso e metabolismo', '⚖️', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(22, 'Hormonal', 'hormonal', 'Promove equilíbrio hormonal', '⚖️', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(23, 'Aphrodisíaco', 'aphrodisiaco', 'Estimula libido e vitalidade sexual', '❤️‍🔥', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(24, 'Antiespasmódico', 'antiespamodico', 'Alivia espasmos e cólicas', '🌀', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(25, 'Diurético', 'diuretico', 'Auxilia na eliminação de líquidos', '💧', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(26, 'Cicatrizante', 'cicatrizante', 'Acelera cicatrização de feridas', '🩹', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(27, 'Expectorante', 'expectorante', 'Facilita eliminação de secreções pulmonares', '🫁', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(28, 'Calmante', 'calmante', 'Acalma o sistema nervoso', '🕊️', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(29, 'Antibacteriano', 'antibacteriano', 'Combate bactérias e infecções', '🦠', '2026-05-15 17:54:10', '2026-05-15 17:54:10'),
(30, 'Adaptógeno', 'adaptogeno', 'Aumenta resistência ao estresse físico e mental', '🌟', '2026-05-15 17:54:10', '2026-05-15 17:54:10');

-- --------------------------------------------------------

--
-- Table structure for table `benefit_herb`
--

CREATE TABLE `benefit_herb` (
  `id` bigint UNSIGNED NOT NULL,
  `benefit_id` bigint UNSIGNED NOT NULL,
  `herb_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `benefit_herb`
--

INSERT INTO `benefit_herb` (`id`, `benefit_id`, `herb_id`) VALUES
(1, 1, 1),
(2, 5, 1),
(3, 6, 1),
(4, 28, 1),
(5, 16, 1),
(6, 2, 2),
(7, 3, 2),
(8, 11, 2),
(9, 13, 2),
(10, 4, 2),
(11, 1, 3),
(12, 5, 3),
(13, 6, 3),
(14, 28, 3),
(15, 8, 3),
(16, 4, 3),
(17, 4, 4),
(18, 12, 4),
(19, 18, 4),
(20, 2, 4),
(21, 1, 5),
(22, 5, 5),
(23, 6, 5),
(24, 28, 5),
(25, 1, 6),
(26, 6, 6),
(27, 25, 6),
(28, 28, 6),
(29, 18, 6),
(30, 16, 7),
(31, 26, 7),
(32, 8, 7),
(33, 29, 7),
(34, 12, 8),
(35, 27, 8),
(36, 18, 8),
(37, 29, 8),
(38, 2, 9),
(39, 4, 9),
(40, 7, 9),
(41, 8, 9),
(42, 18, 9),
(43, 22, 10),
(44, 15, 10),
(45, 14, 10),
(46, 29, 10),
(47, 4, 10),
(48, 4, 11),
(49, 25, 11),
(50, 8, 11),
(51, 4, 12),
(52, 8, 12),
(53, 12, 13),
(54, 27, 13),
(55, 8, 13),
(56, 25, 14),
(57, 8, 14),
(58, 18, 14),
(59, 8, 15),
(60, 18, 15),
(61, 26, 15),
(62, 4, 16),
(63, 8, 16),
(64, 26, 16),
(65, 1, 17),
(66, 5, 17),
(67, 6, 17),
(68, 28, 17),
(69, 1, 18),
(70, 5, 18),
(71, 6, 18),
(72, 28, 18),
(73, 1, 19),
(74, 4, 19),
(75, 8, 19),
(76, 28, 19),
(77, 25, 20),
(78, 4, 20),
(79, 7, 20),
(80, 16, 21),
(81, 8, 21),
(82, 25, 21),
(83, 26, 21),
(84, 7, 22),
(85, 8, 22),
(86, 18, 22),
(87, 8, 23),
(88, 22, 23),
(89, 7, 23),
(90, 25, 24),
(91, 11, 24),
(92, 7, 24),
(93, 16, 24),
(94, 25, 25),
(95, 16, 25),
(96, 8, 25),
(97, 18, 25),
(98, 25, 26),
(99, 8, 26),
(100, 18, 26),
(101, 11, 26),
(102, 1, 27),
(103, 5, 27),
(104, 6, 27),
(105, 28, 27),
(106, 4, 28),
(107, 1, 28),
(108, 27, 28),
(109, 28, 28),
(110, 4, 29),
(111, 25, 29),
(112, 28, 29),
(113, 8, 29),
(114, 4, 30),
(115, 29, 30),
(116, 8, 30),
(117, 12, 31),
(118, 27, 31),
(119, 4, 31),
(120, 28, 31),
(121, 25, 32),
(122, 8, 32),
(123, 11, 32),
(124, 4, 33),
(125, 8, 33),
(126, 25, 33),
(127, 1, 34),
(128, 5, 34),
(129, 6, 34),
(130, 28, 34),
(131, 18, 34),
(132, 4, 35),
(133, 7, 35),
(134, 12, 35),
(135, 27, 35),
(136, 18, 36),
(137, 29, 36),
(138, 2, 36),
(139, 11, 36),
(140, 4, 36),
(141, 2, 37),
(142, 11, 37),
(143, 8, 37),
(144, 29, 37),
(145, 1, 38),
(146, 5, 38),
(147, 6, 38),
(148, 28, 38),
(149, 22, 38),
(150, 7, 39),
(151, 12, 39),
(152, 27, 39),
(153, 29, 39),
(154, 16, 39),
(155, 22, 40),
(156, 14, 40),
(157, 15, 40),
(158, 4, 40),
(159, 18, 40),
(160, 11, 41),
(161, 8, 41),
(162, 18, 41),
(163, 18, 42),
(164, 8, 42),
(165, 7, 42),
(166, 4, 43),
(167, 1, 43),
(168, 6, 43),
(169, 28, 43),
(170, 18, 43),
(171, 12, 44),
(172, 27, 44),
(173, 8, 44),
(174, 29, 44),
(175, 12, 45),
(176, 27, 45),
(177, 8, 45),
(178, 25, 45),
(179, 26, 46),
(180, 8, 46),
(181, 29, 46),
(182, 16, 46),
(183, 26, 47),
(184, 8, 47),
(185, 18, 47),
(186, 18, 48),
(187, 8, 48),
(188, 14, 48),
(189, 4, 49),
(190, 25, 49),
(191, 11, 50),
(192, 16, 50),
(193, 26, 50),
(194, 3, 50),
(195, 13, 50),
(196, 8, 51),
(197, 18, 51),
(198, 2, 52),
(199, 7, 52),
(200, 13, 52),
(201, 3, 52),
(202, 22, 53),
(203, 14, 53),
(204, 18, 53),
(205, 8, 53),
(206, 8, 54),
(207, 26, 54),
(208, 29, 54),
(209, 27, 54),
(210, 12, 54),
(211, 8, 55),
(212, 16, 55),
(213, 12, 55),
(214, 26, 55),
(215, 4, 56),
(216, 25, 56),
(217, 1, 57),
(218, 6, 57),
(219, 28, 57),
(220, 12, 57),
(221, 27, 57),
(222, 1, 58),
(223, 5, 58),
(224, 6, 58),
(225, 28, 58),
(226, 12, 59),
(227, 4, 59),
(228, 27, 59),
(229, 11, 60),
(230, 13, 60),
(231, 3, 60),
(232, 8, 60),
(233, 2, 61),
(234, 3, 61),
(235, 7, 61),
(236, 13, 61),
(237, 8, 62),
(238, 7, 62),
(239, 18, 62),
(240, 4, 62),
(241, 2, 63),
(242, 22, 63),
(243, 15, 63),
(244, 14, 63),
(245, 2, 64),
(246, 22, 64),
(247, 11, 64),
(248, 25, 65),
(249, 8, 65),
(250, 12, 65),
(251, 25, 66),
(252, 8, 66),
(253, 16, 66),
(254, 11, 66),
(255, 8, 67),
(256, 18, 67),
(257, 26, 67),
(258, 16, 67),
(259, 8, 68),
(260, 4, 68),
(261, 16, 68),
(262, 29, 68),
(263, 4, 69),
(264, 8, 69),
(265, 25, 69),
(266, 7, 70),
(267, 12, 70),
(268, 26, 70),
(269, 29, 70),
(270, 7, 71),
(271, 27, 71),
(272, 12, 71),
(273, 25, 71),
(274, 1, 72),
(275, 5, 72),
(276, 6, 72),
(277, 28, 72),
(278, 11, 72),
(279, 7, 73),
(280, 8, 73),
(281, 26, 73),
(282, 29, 73),
(283, 16, 73),
(284, 25, 74),
(285, 8, 74),
(286, 18, 74),
(287, 7, 75),
(288, 12, 75),
(289, 4, 75),
(290, 29, 75),
(291, 1, 76),
(292, 7, 76),
(293, 8, 76),
(294, 4, 76),
(295, 12, 76),
(296, 12, 77),
(297, 27, 77),
(298, 8, 77),
(299, 4, 77),
(300, 4, 78),
(301, 7, 78),
(302, 8, 78),
(303, 18, 79),
(304, 8, 79),
(305, 4, 80),
(306, 8, 80),
(307, 27, 81),
(308, 12, 81),
(309, 25, 81),
(310, 7, 81),
(311, 4, 82),
(312, 1, 82),
(313, 6, 82),
(314, 28, 82),
(315, 16, 83),
(316, 14, 83),
(317, 15, 83),
(318, 25, 83),
(319, 8, 83),
(320, 22, 83),
(321, 25, 84),
(322, 8, 84),
(323, 16, 84),
(324, 26, 84),
(325, 18, 84),
(326, 4, 85),
(327, 12, 85),
(328, 8, 85),
(329, 2, 85),
(330, 25, 86),
(331, 8, 86),
(332, 18, 86),
(333, 2, 87),
(334, 4, 87),
(335, 18, 87),
(336, 25, 88),
(337, 8, 88),
(338, 18, 88),
(339, 11, 89),
(340, 26, 89),
(341, 8, 89),
(342, 18, 89),
(343, 16, 89),
(344, 8, 90),
(345, 26, 90),
(346, 16, 90),
(347, 28, 90),
(348, 26, 91),
(349, 4, 91),
(350, 16, 91),
(351, 8, 91),
(352, 18, 91),
(353, 7, 92),
(354, 8, 92),
(355, 26, 92),
(356, 25, 93),
(357, 18, 93),
(358, 12, 93),
(359, 8, 94),
(360, 16, 94),
(361, 29, 94),
(362, 1, 95),
(363, 5, 95),
(364, 6, 95),
(365, 4, 95),
(366, 28, 95),
(367, 25, 95),
(368, 1, 96),
(369, 28, 96),
(370, 6, 96),
(371, 18, 96),
(372, 12, 96),
(373, 2, 97),
(374, 3, 97),
(375, 13, 97),
(376, 22, 97),
(377, 14, 98),
(378, 26, 98),
(379, 11, 98),
(380, 8, 98),
(381, 4, 98),
(382, 18, 98),
(383, 22, 98),
(384, 25, 99),
(385, 8, 99),
(386, 26, 99),
(387, 16, 99),
(388, 27, 100),
(389, 12, 100),
(390, 4, 100),
(391, 1, 101),
(392, 28, 101),
(393, 6, 101),
(394, 4, 101),
(395, 18, 101),
(396, 25, 102),
(397, 18, 102),
(398, 8, 102),
(399, 16, 102),
(400, 8, 103),
(401, 18, 103),
(402, 26, 103),
(403, 4, 103),
(404, 16, 103),
(405, 27, 104),
(406, 12, 104),
(407, 25, 104),
(408, 4, 104),
(409, 8, 104),
(410, 2, 105),
(411, 3, 105),
(412, 13, 105),
(413, 7, 105),
(414, 8, 105),
(415, 25, 105),
(416, 4, 106),
(417, 25, 106),
(418, 25, 107),
(419, 8, 107),
(420, 18, 107),
(421, 14, 108),
(422, 22, 108),
(423, 28, 108),
(424, 1, 108),
(425, 7, 109),
(426, 26, 109),
(427, 8, 109),
(428, 22, 109),
(429, 15, 110),
(430, 22, 110),
(431, 12, 111),
(432, 27, 111),
(433, 26, 111),
(434, 8, 111),
(435, 29, 112),
(436, 26, 112),
(437, 4, 112),
(438, 8, 112),
(439, 12, 113),
(440, 29, 113),
(441, 25, 113),
(442, 18, 113),
(443, 12, 114),
(444, 27, 114),
(445, 25, 114),
(446, 25, 115),
(447, 7, 115),
(448, 2, 115),
(449, 1, 116),
(450, 7, 116),
(451, 1, 117),
(452, 7, 117),
(453, 1, 118),
(454, 7, 118),
(455, 1, 119),
(456, 7, 119),
(457, 1, 120),
(458, 7, 120),
(459, 1, 121),
(460, 7, 121),
(461, 1, 122),
(462, 7, 122),
(463, 1, 123),
(464, 7, 123),
(465, 1, 124),
(466, 7, 124),
(467, 1, 125),
(468, 7, 125),
(469, 1, 126),
(470, 7, 126),
(471, 1, 127),
(472, 7, 127),
(473, 1, 128),
(474, 7, 128),
(475, 1, 129),
(476, 7, 129),
(477, 1, 130),
(478, 7, 130),
(479, 1, 131),
(480, 7, 131),
(481, 1, 132),
(482, 7, 132),
(483, 1, 133),
(484, 7, 133),
(485, 1, 134),
(486, 7, 134),
(487, 1, 135),
(488, 7, 135),
(489, 1, 136),
(490, 7, 136),
(491, 1, 137),
(492, 7, 137),
(493, 1, 138),
(494, 7, 138),
(495, 1, 139),
(496, 7, 139),
(497, 1, 140),
(498, 7, 140),
(499, 1, 141),
(500, 7, 141),
(501, 1, 142),
(502, 7, 142),
(503, 1, 143),
(504, 7, 143),
(505, 1, 144),
(506, 7, 144),
(507, 1, 145),
(508, 7, 145),
(509, 1, 146),
(510, 7, 146),
(511, 1, 147),
(512, 7, 147),
(513, 1, 148),
(514, 7, 148),
(515, 1, 149),
(516, 7, 149),
(517, 1, 150),
(518, 7, 150),
(519, 1, 151),
(520, 7, 151),
(521, 1, 152),
(522, 7, 152),
(523, 1, 153),
(524, 7, 153),
(525, 1, 154),
(526, 7, 154),
(527, 1, 155),
(528, 7, 155),
(529, 1, 156),
(530, 7, 156),
(531, 1, 157),
(532, 7, 157),
(533, 1, 158),
(534, 7, 158),
(535, 1, 159),
(536, 7, 159),
(537, 1, 160),
(538, 7, 160),
(539, 1, 161),
(540, 7, 161),
(541, 1, 162),
(542, 7, 162),
(543, 1, 163),
(544, 7, 163),
(545, 1, 164),
(546, 7, 164),
(547, 1, 165),
(548, 7, 165),
(549, 1, 166),
(550, 7, 166),
(551, 1, 167),
(552, 7, 167),
(553, 1, 168),
(554, 7, 168),
(555, 1, 169),
(556, 7, 169),
(557, 1, 170),
(558, 7, 170),
(559, 1, 171),
(560, 7, 171),
(561, 1, 172),
(562, 7, 172),
(563, 1, 173),
(564, 7, 173),
(565, 1, 174),
(566, 7, 174),
(567, 1, 175),
(568, 7, 175),
(569, 1, 176),
(570, 7, 176),
(571, 1, 177),
(572, 7, 177),
(573, 1, 178),
(574, 7, 178),
(575, 1, 179),
(576, 7, 179),
(577, 1, 180),
(578, 7, 180),
(579, 1, 181),
(580, 7, 181),
(581, 1, 182),
(582, 7, 182),
(583, 1, 183),
(584, 7, 183),
(585, 1, 184),
(586, 7, 184),
(587, 1, 185),
(588, 7, 185),
(589, 1, 186),
(590, 7, 186),
(591, 1, 187),
(592, 7, 187),
(593, 1, 188),
(594, 7, 188),
(595, 1, 189),
(596, 7, 189),
(597, 1, 190),
(598, 7, 190),
(599, 1, 191),
(600, 7, 191),
(601, 1, 192),
(602, 7, 192),
(603, 1, 193),
(604, 7, 193),
(605, 1, 194),
(606, 7, 194),
(607, 1, 195),
(608, 7, 195),
(609, 1, 196),
(610, 7, 196),
(611, 1, 197),
(612, 7, 197),
(613, 1, 198),
(614, 7, 198),
(615, 1, 199),
(616, 7, 199),
(617, 1, 200),
(618, 7, 200),
(619, 1, 201),
(620, 7, 201),
(621, 1, 202),
(622, 7, 202),
(623, 1, 203),
(624, 7, 203),
(625, 1, 204),
(626, 7, 204),
(627, 1, 205),
(628, 7, 205),
(629, 1, 206),
(630, 7, 206),
(631, 1, 207),
(632, 7, 207),
(633, 1, 208),
(634, 7, 208),
(635, 1, 209),
(636, 7, 209),
(637, 1, 210),
(638, 7, 210),
(639, 1, 211),
(640, 7, 211),
(641, 1, 212),
(642, 7, 212),
(643, 1, 213),
(644, 7, 213),
(645, 1, 214),
(646, 7, 214),
(647, 1, 215),
(648, 7, 215),
(649, 1, 216),
(650, 7, 216),
(651, 1, 217),
(652, 7, 217),
(653, 1, 218),
(654, 7, 218),
(655, 1, 219),
(656, 7, 219),
(657, 1, 220),
(658, 7, 220),
(659, 1, 221),
(660, 7, 221),
(661, 1, 222),
(662, 7, 222),
(663, 1, 223),
(664, 7, 223),
(665, 1, 224),
(666, 7, 224),
(667, 1, 225),
(668, 7, 225),
(669, 1, 226),
(670, 7, 226),
(671, 1, 227),
(672, 7, 227),
(673, 1, 228),
(674, 7, 228),
(675, 1, 229),
(676, 7, 229),
(677, 1, 230),
(678, 7, 230),
(679, 1, 231),
(680, 7, 231),
(681, 1, 232),
(682, 7, 232),
(683, 1, 233),
(684, 7, 233),
(685, 1, 234),
(686, 7, 234),
(687, 1, 235),
(688, 7, 235),
(689, 1, 236),
(690, 7, 236),
(691, 1, 237),
(692, 7, 237),
(693, 1, 238),
(694, 7, 238),
(695, 1, 239),
(696, 7, 239),
(697, 1, 240),
(698, 7, 240),
(699, 1, 241),
(700, 7, 241),
(701, 1, 242),
(702, 7, 242),
(703, 1, 243),
(704, 7, 243),
(705, 1, 244),
(706, 7, 244),
(707, 1, 245),
(708, 7, 245),
(709, 1, 246),
(710, 7, 246),
(711, 1, 247),
(712, 7, 247),
(713, 1, 248),
(714, 7, 248),
(715, 1, 249),
(716, 7, 249),
(717, 1, 250),
(718, 7, 250);

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('receita-de-vovo-cache-5cecfd4a33982c19d1cd55351d277c82', 'i:1;', 1781202538),
('receita-de-vovo-cache-5cecfd4a33982c19d1cd55351d277c82:timer', 'i:1781202538;', 1781202538),
('receita-de-vovo-cache-af7d21d71c5c859d62cdd8bbe4c7500c', 'i:2;', 1781270927),
('receita-de-vovo-cache-af7d21d71c5c859d62cdd8bbe4c7500c:timer', 'i:1781270927;', 1781270927),
('receita-de-vovo-cache-e45444ecc678a271a6330f468a373360', 'i:1;', 1781273836),
('receita-de-vovo-cache-e45444ecc678a271a6330f468a373360:timer', 'i:1781273836;', 1781273836);

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Chás & Infusões', 'chas-e-infusoes', 'Chás e infusões de ervas selecionadas para saúde, relaxamento e bem-estar.', '2026-05-20 18:12:05', '2026-05-20 18:12:05'),
(2, 'Cosméticos Naturais', 'cosmeticos-naturais', 'Sabonetes artesanais, pomadas e óleos essenciais com base em ervas medicinais.', '2026-05-20 18:12:05', '2026-05-20 18:12:05'),
(3, 'Acessórios & Utensílios', 'acessorios-e-utensilios', 'Infusores, xícaras, bules e utensílios para preparar o seu ritual de chá.', '2026-05-20 18:12:05', '2026-05-20 18:12:05'),
(4, 'Kits & Presentes', 'kits-e-presentes', 'Kits e presentes preparados com carinho e aroma especial de vovó.', '2026-05-20 18:12:05', '2026-05-20 18:12:05'),
(5, 'Capilar', 'shampoo-cremes-e-tonico', 'Itens para tratamento e saúde do cabelo e couro cabeludo.', '2026-05-20 18:23:59', '2026-05-20 18:23:59'),
(6, 'Cremes', 'Cremes-Hidratante', 'Cremes e hidratantes para o corpo, rosto, pés.', '2026-05-20 19:38:51', '2026-05-20 19:38:51'),
(7, 'Loção', 'Loção-cremes', 'Loção, indicado para masagem e hidratação para seu corpo.', '2026-05-20 20:52:04', '2026-05-20 20:52:04'),
(8, 'Body Splash', 'Body-Splash', 'Essa categoria reuni inspirações emfragâncias conhecidas e famosas.', '2026-05-26 15:31:45', '2026-05-26 15:31:45'),
(9, 'Home Spray', 'Home-Sppray', NULL, '2026-05-26 20:34:14', '2026-05-26 20:34:14'),
(10, 'Sabonete Artesanal', 'Sabonete-Artesanal', 'Sabonete Artesanal de ervas e de fragâncias unicas e esclusivas, para proporcionar um banho mais que especial.', '2026-06-10 14:48:46', '2026-06-10 14:48:46');

-- --------------------------------------------------------

--
-- Table structure for table `comodato_audits`
--

CREATE TABLE `comodato_audits` (
  `id` bigint UNSIGNED NOT NULL,
  `partner_id` bigint UNSIGNED NOT NULL,
  `audited_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'completed',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `comodato_audit_items`
--

CREATE TABLE `comodato_audit_items` (
  `id` bigint UNSIGNED NOT NULL,
  `comodato_audit_id` bigint UNSIGNED NOT NULL,
  `itemable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `itemable_id` bigint UNSIGNED NOT NULL,
  `expected_quantity` int NOT NULL,
  `actual_quantity` int NOT NULL,
  `difference` int NOT NULL,
  `action_taken` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `comodato_movements`
--

CREATE TABLE `comodato_movements` (
  `id` bigint UNSIGNED NOT NULL,
  `partner_id` bigint UNSIGNED NOT NULL,
  `itemable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `itemable_id` bigint UNSIGNED NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int NOT NULL,
  `order_id` bigint UNSIGNED DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `comodato_movements`
--

INSERT INTO `comodato_movements` (`id`, `partner_id`, `itemable_type`, `itemable_id`, `type`, `quantity`, `order_id`, `notes`, `created_at`, `updated_at`) VALUES
(1, 1, 'App\\Modules\\Ecommerce\\Models\\Product', 40, 'dispatch', 5, NULL, 'Quantidade enviada para formar espositor', '2026-06-12 17:23:10', '2026-06-12 17:23:10'),
(2, 1, 'App\\Modules\\Ecommerce\\Models\\Product', 36, 'dispatch', 5, NULL, 'Quantidade enviar para formar espositor', '2026-06-12 17:23:43', '2026-06-12 17:23:43'),
(3, 1, 'App\\Modules\\Ecommerce\\Models\\Product', 35, 'dispatch', 10, NULL, 'Quantidade enviar para formar espositor', '2026-06-12 17:24:01', '2026-06-12 17:24:01'),
(4, 1, 'App\\Modules\\Ecommerce\\Models\\Product', 37, 'dispatch', 6, NULL, 'Quantidade enviar para formar espositor', '2026-06-12 17:24:58', '2026-06-12 17:24:58'),
(5, 1, 'App\\Modules\\Ecommerce\\Models\\Product', 43, 'dispatch', 10, NULL, 'Quantidade enviar para formar espositor', '2026-06-12 17:25:22', '2026-06-12 17:25:22');

-- --------------------------------------------------------

--
-- Table structure for table `comodato_partners`
--

CREATE TABLE `comodato_partners` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `commission_percentage` decimal(5,2) NOT NULL DEFAULT '0.00',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `comodato_partners`
--

INSERT INTO `comodato_partners` (`id`, `name`, `contact_name`, `phone`, `address`, `commission_percentage`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Podologia', 'Elisangela Santos', '11969645996', 'Praça da flores, 45, Centro Comercial Alphaville, Barueri - SP', 0.00, 1, '2026-06-12 17:18:13', '2026-06-12 17:18:13');

-- --------------------------------------------------------

--
-- Table structure for table `comodato_stocks`
--

CREATE TABLE `comodato_stocks` (
  `id` bigint UNSIGNED NOT NULL,
  `partner_id` bigint UNSIGNED NOT NULL,
  `itemable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `itemable_id` bigint UNSIGNED NOT NULL,
  `quantity` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `comodato_stocks`
--

INSERT INTO `comodato_stocks` (`id`, `partner_id`, `itemable_type`, `itemable_id`, `quantity`, `created_at`, `updated_at`) VALUES
(1, 1, 'App\\Modules\\Ecommerce\\Models\\Product', 40, 5, '2026-06-12 17:23:10', '2026-06-12 17:23:10'),
(2, 1, 'App\\Modules\\Ecommerce\\Models\\Product', 36, 5, '2026-06-12 17:23:43', '2026-06-12 17:23:43'),
(3, 1, 'App\\Modules\\Ecommerce\\Models\\Product', 35, 10, '2026-06-12 17:24:01', '2026-06-12 17:24:01'),
(4, 1, 'App\\Modules\\Ecommerce\\Models\\Product', 37, 6, '2026-06-12 17:24:58', '2026-06-12 17:24:58'),
(5, 1, 'App\\Modules\\Ecommerce\\Models\\Product', 43, 10, '2026-06-12 17:25:22', '2026-06-12 17:25:22');

-- --------------------------------------------------------

--
-- Table structure for table `emotions`
--

CREATE TABLE `emotions` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `emotions`
--

INSERT INTO `emotions` (`id`, `name`, `slug`, `description`, `color`, `created_at`, `updated_at`) VALUES
(1, 'Ansiedade', 'ansiedade', 'Preocupação excessiva, inquietação e nervosismo', '#FFD93D', '2026-05-14 15:28:19', '2026-05-15 17:56:22'),
(2, 'Cansaço', 'cansaco', 'Fadiga física ou mental, exaustão', '#A29BFE', '2026-05-14 15:28:19', '2026-05-15 17:56:22'),
(3, 'Alegria', 'alegria', 'Para celebrar e elevar o espírito.', NULL, '2026-05-14 15:28:20', '2026-05-14 15:28:20'),
(4, 'Estresse', 'estresse', 'Sensação de tensão, pressão ou sobrecarga emocional', '#FF6B6B', '2026-05-15 17:56:22', '2026-05-15 17:56:22'),
(5, 'Tristeza', 'tristeza', 'Sentimento de melancolia, desânimo ou pesar', '#6C5CE7', '2026-05-15 17:56:22', '2026-05-15 17:56:22'),
(6, 'Raiva', 'raiva', 'Irritação, frustração ou sentimento de injustiça', '#E74C3C', '2026-05-15 17:56:22', '2026-05-15 17:56:22'),
(7, 'Medo', 'medo', 'Sensação de perigo, insegurança ou apreensão', '#95A5A6', '2026-05-15 17:56:22', '2026-05-15 17:56:22'),
(8, 'Insônia', 'insonia', 'Dificuldade para dormir ou manter o sono', '#2C3E50', '2026-05-15 17:56:22', '2026-05-15 17:56:22'),
(9, 'Agitação', 'agitacao', 'Inquietude, hiperatividade mental ou física', '#FD79A8', '2026-05-15 17:56:22', '2026-05-15 17:56:22'),
(10, 'Desânimo', 'desanimo', 'Falta de motivação, energia ou interesse', '#636E72', '2026-05-15 17:56:22', '2026-05-15 17:56:22'),
(11, 'Solidão', 'solidao', 'Sentimento de isolamento ou falta de conexão', '#74B9FF', '2026-05-15 17:56:22', '2026-05-15 17:56:22'),
(12, 'Confusão Mental', 'confusao-mental', 'Dificuldade de concentração ou clareza de pensamento', '#DFE6E9', '2026-05-15 17:56:22', '2026-05-15 17:56:22'),
(13, 'Luto', 'luto', 'Processo de perda e elaboração de despedida', '#2D3436', '2026-05-15 17:56:22', '2026-05-15 17:56:22'),
(14, 'Culpa', 'culpa', 'Sentimento de responsabilidade por algo negativo', '#A29BFE', '2026-05-15 17:56:22', '2026-05-15 17:56:22'),
(15, 'Vergonha', 'vergonha', 'Sensação de inadequação ou exposição negativa', '#FFEAA7', '2026-05-15 17:56:22', '2026-05-15 17:56:22'),
(16, 'Impaciência', 'impaciencia', 'Dificuldade em esperar ou tolerar demoras', '#FF7675', '2026-05-15 17:56:22', '2026-05-15 17:56:22');

-- --------------------------------------------------------

--
-- Table structure for table `emotion_herb`
--

CREATE TABLE `emotion_herb` (
  `id` bigint UNSIGNED NOT NULL,
  `emotion_id` bigint UNSIGNED NOT NULL,
  `herb_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `emotion_herb`
--

INSERT INTO `emotion_herb` (`id`, `emotion_id`, `herb_id`) VALUES
(1, 1, 1),
(2, 4, 1),
(3, 2, 1),
(4, 2, 2),
(5, 3, 2),
(6, 1, 3),
(7, 4, 3),
(8, 2, 4),
(9, 4, 4),
(10, 1, 5),
(11, 4, 5),
(12, 1, 6),
(13, 4, 6),
(14, 5, 7),
(15, 4, 7),
(16, 2, 8),
(17, 4, 8),
(18, 2, 9),
(19, 5, 9),
(20, 4, 10),
(21, 5, 10),
(22, 2, 11),
(23, 4, 11),
(24, 4, 12),
(25, 5, 12),
(26, 2, 13),
(27, 1, 13),
(28, 4, 14),
(29, 1, 14),
(30, 2, 15),
(31, 4, 15),
(32, 4, 16),
(33, 1, 16),
(34, 1, 17),
(35, 4, 17),
(36, 1, 18),
(37, 4, 18),
(38, 2, 18),
(39, 1, 19),
(40, 5, 19),
(41, 4, 19),
(42, 2, 20),
(43, 4, 20),
(44, 4, 21),
(45, 5, 21),
(46, 2, 22),
(47, 4, 22),
(48, 5, 23),
(49, 4, 23),
(50, 3, 24),
(51, 2, 24),
(52, 2, 25),
(53, 4, 25),
(54, 4, 26),
(55, 5, 26),
(56, 1, 27),
(57, 4, 27),
(58, 1, 28),
(59, 5, 28),
(60, 4, 28),
(61, 4, 29),
(62, 1, 29),
(63, 5, 30),
(64, 4, 30),
(65, 2, 31),
(66, 1, 31),
(67, 2, 32),
(68, 4, 32),
(69, 2, 33),
(70, 4, 33),
(71, 1, 34),
(72, 4, 34),
(73, 3, 35),
(74, 2, 35),
(75, 2, 36),
(76, 4, 36),
(77, 3, 37),
(78, 2, 37),
(79, 5, 38),
(80, 1, 38),
(81, 4, 38),
(82, 2, 39),
(83, 3, 39),
(84, 5, 40),
(85, 4, 40),
(86, 1, 40),
(87, 4, 41),
(88, 5, 41),
(89, 2, 42),
(90, 4, 42),
(91, 4, 43),
(92, 1, 43),
(93, 3, 43),
(94, 2, 44),
(95, 4, 44),
(96, 2, 45),
(97, 4, 45),
(98, 4, 46),
(99, 5, 46),
(100, 2, 47),
(101, 4, 47),
(102, 2, 48),
(103, 4, 48),
(104, 4, 49),
(105, 5, 49),
(106, 2, 50),
(107, 4, 50),
(108, 2, 51),
(109, 4, 51),
(110, 2, 52),
(111, 5, 52),
(112, 4, 53),
(113, 5, 53),
(114, 5, 54),
(115, 4, 54),
(116, 1, 55),
(117, 5, 55),
(118, 4, 55),
(119, 4, 56),
(120, 1, 56),
(121, 1, 57),
(122, 4, 57),
(123, 1, 58),
(124, 4, 58),
(125, 2, 59),
(126, 4, 59),
(127, 2, 60),
(128, 4, 60),
(129, 2, 61),
(130, 5, 61),
(131, 4, 61),
(132, 5, 62),
(133, 2, 62),
(134, 2, 63),
(135, 5, 63),
(136, 2, 64),
(137, 4, 64),
(138, 4, 65),
(139, 1, 65),
(140, 2, 66),
(141, 4, 66),
(142, 4, 67),
(143, 1, 67),
(144, 4, 68),
(145, 2, 68),
(146, 2, 69),
(147, 4, 69),
(148, 4, 70),
(149, 1, 70),
(150, 5, 71),
(151, 2, 71),
(152, 1, 72),
(153, 4, 72),
(154, 2, 73),
(155, 5, 73),
(156, 4, 74),
(157, 1, 74),
(158, 2, 75),
(159, 1, 75),
(160, 5, 76),
(161, 4, 76),
(162, 1, 76),
(163, 4, 77),
(164, 1, 77),
(165, 2, 78),
(166, 4, 78),
(167, 4, 79),
(168, 1, 79),
(169, 4, 80),
(170, 2, 80),
(171, 2, 81),
(172, 4, 81),
(173, 1, 82),
(174, 4, 82),
(175, 5, 82),
(176, 5, 83),
(177, 4, 83),
(178, 1, 83),
(179, 2, 84),
(180, 4, 84),
(181, 2, 85),
(182, 5, 85),
(183, 4, 86),
(184, 1, 86),
(185, 2, 87),
(186, 3, 87),
(187, 4, 87),
(188, 4, 88),
(189, 1, 88),
(190, 4, 89),
(191, 1, 89),
(192, 5, 90),
(193, 1, 90),
(194, 4, 91),
(195, 1, 91),
(196, 5, 92),
(197, 2, 92),
(198, 3, 92),
(199, 4, 93),
(200, 1, 93),
(201, 2, 94),
(202, 4, 94),
(203, 1, 95),
(204, 4, 95),
(205, 3, 95),
(206, 1, 96),
(207, 5, 96),
(208, 4, 96),
(209, 2, 97),
(210, 5, 97),
(211, 4, 97),
(212, 4, 98),
(213, 1, 98),
(214, 5, 98),
(215, 4, 99),
(216, 1, 99),
(217, 2, 100),
(218, 4, 100),
(219, 1, 101),
(220, 4, 101),
(221, 2, 101),
(222, 2, 102),
(223, 5, 102),
(224, 4, 103),
(225, 2, 103),
(226, 4, 104),
(227, 1, 104),
(228, 2, 105),
(229, 4, 105),
(230, 4, 106),
(231, 2, 106),
(232, 5, 107),
(233, 4, 107),
(234, 1, 108),
(235, 4, 108),
(236, 4, 109),
(237, 5, 109),
(238, 4, 110),
(239, 2, 111),
(240, 4, 112),
(241, 1, 113),
(242, 4, 113),
(243, 4, 114),
(244, 1, 114),
(245, 2, 115),
(246, 4, 116),
(247, 4, 117),
(248, 4, 118),
(249, 4, 119),
(250, 4, 120),
(251, 4, 121),
(252, 4, 122),
(253, 4, 123),
(254, 4, 124),
(255, 4, 125),
(256, 4, 126),
(257, 4, 127),
(258, 4, 128),
(259, 4, 129),
(260, 4, 130),
(261, 4, 131),
(262, 4, 132),
(263, 4, 133),
(264, 4, 134),
(265, 4, 135),
(266, 4, 136),
(267, 4, 137),
(268, 4, 138),
(269, 4, 139),
(270, 4, 140),
(271, 4, 141),
(272, 4, 142),
(273, 4, 143),
(274, 4, 144),
(275, 4, 145),
(276, 4, 146),
(277, 4, 147),
(278, 4, 148),
(279, 4, 149),
(280, 4, 150),
(281, 4, 151),
(282, 4, 152),
(283, 4, 153),
(284, 4, 154),
(285, 4, 155),
(286, 4, 156),
(287, 4, 157),
(288, 4, 158),
(289, 4, 159),
(290, 4, 160),
(291, 4, 161),
(292, 4, 162),
(293, 4, 163),
(294, 4, 164),
(295, 4, 165),
(296, 4, 166),
(297, 4, 167),
(298, 4, 168),
(299, 4, 169),
(300, 4, 170),
(301, 4, 171),
(302, 4, 172),
(303, 4, 173),
(304, 4, 174),
(305, 4, 175),
(306, 4, 176),
(307, 4, 177),
(308, 4, 178),
(309, 4, 179),
(310, 4, 180),
(311, 4, 181),
(312, 4, 182),
(313, 4, 183),
(314, 4, 184),
(315, 4, 185),
(316, 4, 186),
(317, 4, 187),
(318, 4, 188),
(319, 4, 189),
(320, 4, 190),
(321, 4, 191),
(322, 4, 192),
(323, 4, 193),
(324, 4, 194),
(325, 4, 195),
(326, 4, 196),
(327, 4, 197),
(328, 4, 198),
(329, 4, 199),
(330, 4, 200),
(331, 4, 201),
(332, 4, 202),
(333, 4, 203),
(334, 4, 204),
(335, 4, 205),
(336, 4, 206),
(337, 4, 207),
(338, 4, 208),
(339, 4, 209),
(340, 4, 210),
(341, 4, 211),
(342, 4, 212),
(343, 4, 213),
(344, 4, 214),
(345, 4, 215),
(346, 4, 216),
(347, 4, 217),
(348, 4, 218),
(349, 4, 219),
(350, 4, 220),
(351, 4, 221),
(352, 4, 222),
(353, 4, 223),
(354, 4, 224),
(355, 4, 225),
(356, 4, 226),
(357, 4, 227),
(358, 4, 228),
(359, 4, 229),
(360, 4, 230),
(361, 4, 231),
(362, 4, 232),
(363, 4, 233),
(364, 4, 234),
(365, 4, 235),
(366, 4, 236),
(367, 4, 237),
(368, 4, 238),
(369, 4, 239),
(370, 4, 240),
(371, 4, 241),
(372, 4, 242),
(373, 4, 243),
(374, 4, 244),
(375, 4, 245),
(376, 4, 246),
(377, 4, 247),
(378, 4, 248),
(379, 4, 249),
(380, 4, 250);

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `herbs`
--

CREATE TABLE `herbs` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `scientific_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `aliases` text COLLATE utf8mb4_unicode_ci,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `contraindications` text COLLATE utf8mb4_unicode_ci,
  `how_to_use` text COLLATE utf8mb4_unicode_ci,
  `bath_instructions` text COLLATE utf8mb4_unicode_ci,
  `incense_usage` text COLLATE utf8mb4_unicode_ci,
  `image_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `source_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'popular',
  `sources` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `herbs`
--

INSERT INTO `herbs` (`id`, `name`, `slug`, `scientific_name`, `aliases`, `description`, `contraindications`, `how_to_use`, `bath_instructions`, `incense_usage`, `image_path`, `source_type`, `sources`, `created_at`, `updated_at`) VALUES
(1, 'Lavanda', 'lavanda', 'Lavandula angustifolia', 'Alfazema, Lavândula', 'Uma das plantas medicinais mais versáteis e veneradas do mundo. Suas flores roxas contêm um óleo essencial riquíssimo em linalol e acetato de linalila, substâncias cientificamente comprovadas por sua ação calmante no sistema nervoso central. Atua como um ansiolítico natural poderoso, reduzindo a frequência cardíaca, acalmando a agitação mental, aliviando o estresse crônico e combatendo a insônia. Também possui propriedades antissépticas, regeneradoras da pele e analgésicas suaves.', 'Evitar em pacientes com hipersensibilidade ao óleo essencial. Não recomendado o uso oral do óleo por gestantes, lactantes e crianças pequenas sem orientação médica.', '• Infusão Relaxante: Adicione 1 colher de sobremesa de flores de lavanda seca em 1 xícara (200ml) de água fervente. Abafe por 5 a 10 minutos, coe e beba antes de dormir.\n\n• Inalação Direta: Pingue 2 a 3 gotas de óleo essencial de lavanda no travesseiro ou use em um difusor pessoal de aromas para reduzir crises de ansiedade.', '• Banho de Harmonização Emocional: Prepare uma infusão fervendo 1 litro de água. Desligue o fogo e adicione 3 colheres de sopa de flores de lavanda seca (ou 2 ramos frescos). Cubra e abafe por 10 minutos. Coe a mistura e adicione 5 gotas de óleo essencial de lavanda se desejar potencializar. Deixe amornar. Após o seu banho de higiene normal, despeje o banho de lavanda lentamente do pescoço para baixo, mentalizando paz, relaxamento e limpeza de energias densas. Seque-se suavemente.', '• Defumação de Paz e Purificação de Ambientes: A lavanda seca é excelente para queima direta. Coloque um punhado de flores secas sobre um disco de carvão vegetal in brasa (em um incensário seguro) ou queime um bastão de lavanda amarrado (smudge stick). Espalhe a fumaça calmante e adstringente pelos cantos da casa para afastar energias de ansiedade, brigas e pesadelos, criando uma atmosfera altamente pacífica ideal para meditação e sono restaurador.', '/images/herbs/lavanda.png', 'integrative', 'Farmacopeia Brasileira (Ed. 6), Compêndio de Fitoterapia da OMS & Tradição Oral de Aromaterapia', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(2, 'Alecrim', 'alecrim', 'Salvia rosmarinus', 'Alecrim-de-Jardim, Rosmarino, Alecrim-Comum', 'Conhecido historicamente como a erva da alegria, da clareza mental e da memória. O alecrim é um estimulante natural fantástico do sistema circulatório e cognitivo. Seus compostos ativos, como o ácido rosmarínico e o cineol, melhoram a oxigenação cerebral, aumentando a concentração, o foco e a retenção de memória, além de combater o cansaço físico e a fadiga mental. Também possui forte ação antioxidante, anti-inflamatória e auxilia na digestão lenta, aumentando a secreção de suco gástrico e reduzindo gases.', 'Evitar o uso terapêutico por via oral em gestantes (pode induzir contrações), lactantes, crianças menores de 6 anos e pessoas com hipertensão ou epilepsia.', '• Infusão de Clareza Mental: Adicione 1 colher de sopa de folhas de alecrim fresco ou seco em 1 xícara de água fervente. Abafe por 10 minutos, coe e consuma pela manhã ou tarde (evite à noite por ser estimulante).\n\n• Inalação de Cineol: Adicione ramos de alecrim fresco em uma bacia com água fervente e respire o vapor cobrindo a cabeça com uma toalha por 5 minutos.', '• Banho de Despertar e Proteção: Ferva 1,5 litros de água com 3 ramos frescos de alecrim por 3 minutos. Desligue o fogo e adicione 1 colher de sopa de sal grosso (opcional, para limpeza energética). Deixe abafado até amornar e coe. Despeje o líquido do pescoço para baixo após o banho higiênico, de preferência pela manhã ou antes do trabalho, mentalizando foco, vitalidade, alegria e proteção espiritual. Não tome este banho à noite para não interferir no sono.', '• Defumação de Clareza Mental e Alegria: Acenda as pontas de um bastão seco de ramos de alecrim amarrados ou coloque as folhas secas em carvão em brasa. A fumaça resinosa e herbal do alecrim é excelente para limpar a mente de pensamentos obsessivos, fadiga intelectual e purificar salas de estudos ou escritórios antes de atividades que exijam foco. Afasta a apatia e atrai vibrações de alegria e prosperidade.', '/images/herbs/alecrim.png', 'integrative', 'Estudo Clínico sobre Cineol (Coombs et al., 2012) & Tradição Popular Ibérica de Proteção e Foco', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(3, 'Camomila', 'camomila', 'Matricaria chamomilla', 'Camomila-Comum, Camomila-Alemã, Matricária', 'A rainha das plantas calmantes. Rica em apigenina (um flavonoide que se liga a receptores cerebrais reduzindo a atividade do sistema nervoso), a camomila é um bálsamo contra a ansiedade, a insônia e a agitação infantil. Além de sua excelente ação calmante, ela é um poderoso antiespasmódico intestinal, aliviando cólicas menstruais, gastrites nervosas, azia e má digestão. Na pele, atua como um excelente agente anti-inflamatório, calmante de dermatites, queimaduras de sol e olheiras.', 'Evitar o uso em pessoas com alergia conhecida a plantas da família Asteraceae (como margaridas). Evitar doses extremamente elevadas durante a gestação.', '• Infusão de Sono Profundo: Use 1 a 2 colheres de sopa de flores de camomila seca para 1 xícara de água fervente. Abafe por 10 minutos para extrair os óleos essenciais, coe e tome 30 minutos antes de dormir.\n\n• Compressa para Olheiras e Dermatites: Prepare um chá forte de camomila, deixe esfriar na geladeira, embeba algodões ou gazes e aplique sobre a área irritada ou olhos por 15 minutos.\n\n• Infusão Digestiva: Tome 1 xícara de chá morno de camomila sem açúcar logo após as refeições principais para evitar gases e azia.', '• Banho de Acalento e Proteção Materna: Ferva 1 litro de água. Desligue o fogo e acrescente 4 colheres de sopa de flores de camomila seca. Deixe abafado por 15 minutos até extrair a cor amarela dourada da planta. Coe. Despeje morno do pescoço para baixo após o banho regular, mentalizando calma, perdão, dissolução de mágoas e acolhimento. Excelente banho para crianças agitadas antes de dormir (pode ser usado na banheira).', '• Defumação de Suavidade e Cura Emocional: Queime flores secas de camomila em brasa. Sua fumaça leve e levemente adocicada é perfeita para suavizar o clima de ambientes onde ocorreram discussões ou choro. Excelente para defumar quartos antes de dormir para acalmar a mente de pensamentos hiperativos e atrair vibrações de paz, doçura e cura do coração.', '/images/herbs/camomila.png', 'integrative', 'Monografias de Plantas Medicinais da ESCOP, Formulário Fitoterápico Nacional do SUS & Sabedoria Oral Ancestral', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(4, 'Hortelã-Pimenta', 'hortela-pimenta', 'Mentha x piperita', 'Hortelã, Menta-Pimenta, Hortelã-Pimentosa', 'Extremamente aromática, refrescante e cheia de propriedades terapêuticas. O mentol presente em abundância em suas folhas confere ação analgésica, expectorante e relaxante muscular. É amplamente utilizada para aliviar dores de cabeça tensionais e enxaquecas, desobstruir as vias respiratórias em resfriados, sinusites e bronquites, e atuar como um dos melhores remédios naturais para a síndrome do intestino irritável, má digestão e espasmos digestivos.', 'Evitar o uso por pessoas com obstrução das vias biliares, cálculos biliares, refluxo gastroesofágico grave ou úlceras estomacais ativas.', '• Chá Expectorante e Digestivo: Adicione 1 colher de sopa de folhas frescas de hortelã amassadas em 1 xícara de água fervente. Abafe por 7 minutos, coe e beba após as refeições ou em momentos de congestão nasal.\n\n• Inalação contra Sinusite: Pingue 3 gotas de óleo essencial de hortelã ou adicione um punhado de folhas frescas em uma vasilha com água fervendo e respire o vapor profundamente.', '• Banho de Descarrego e Renovação Física: Ferva 1,5 litros de água. Ao ferver, apague o fogo e adicione 1 xícara de folhas frescas de hortelã-pimenta. Abafe por 10 minutos. Coe e deixe amornar até uma temperatura agradável. Despeje do pescoço para baixo após o banho normal, sentindo o frescor do mentol agindo no corpo. Sinta a renovação das energias físicas, o alívio das dores musculares e o cansaço do dia a dia escorrendo pelo ralo.', '• Defumação de Renovação e Limpeza de Caminhos: Queime folhas de hortelã secas no carvão. A fumaça mentolada e forte quebra o acúmulo de energias estagnadas ou \'pesadas\' em ambientes comerciais ou residenciais. Abre caminhos mentais, estimula a criatividade e traz uma sensação imediata de ar limpo, renovação e frescor espiritual.', '/images/herbs/hortela.png', 'integrative', 'Agência Europeia de Medicamentos (EMA) - Herbal Monograph on Mentha piperita & Tradição de Purificação de Terreiro', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(5, 'Erva-Cidreira (Melissa)', 'erva-cidreira-melissa', 'Melissa officinalis', 'Melissa, Cidreira-Verdadeira, Chá-de-França', 'Um calmante suave com um delicioso aroma cítrico. A Melissa é cientificamente reconhecida por combater a ansiedade leve a moderada, o nervosismo, as palpitações cardíacas de origem nervosa e o estresse do dia a dia. Seus compostos promovem o aumento do neurotransmissor GABA no cérebro, induzindo o relaxamento profundo e melhorando a qualidade do sono. Também possui forte ação antiviral (especialmente contra o vírus da herpes labial) e alivia cólicas e espasmos intestinais decorrentes da tensão nervosa.', 'Contraindicado em pessoas com hipotireoidismo (pode interferir na absorção de hormônios tireoidianos) e glaucoma. Evitar antes de operar máquinas pesadas.', '• Chá de Relaxamento e Sono: Adicione 1 colher de sopa de folhas de melissa frescas ou secas em 1 xícara de água fervente. Deixe abafado por 10 minutos, coe e beba 2 vezes ao dia, inclusive antes de deitar.\n\n• Compressa Antiviral para Herpes: Prepare um chá forte de melissa e aplique morno com um algodão sobre as lesões labiais de herpes até 4 vezes ao dia.', '• Banho de Serenidade contra Estresse: Ferva 1 litro de água. Desligue o fogo e junte 3 colheres de sopa cheias de folhas secas de Melissa. Mantenha abafado por 10 minutos até liberar o aroma cítrico relaxante. Coe. Tome o seu banho comum e, em seguida, jogue o banho de melissa morno do pescoço para baixo, respirando fundo o aroma. Sinta o estresse ir embora, acalmando palpitações no peito e relaxando os ombros tensionados.', '• Defumação de Doçura e Alívio da Ansiedade: Queime melissa seca. A fumaça cítrica e reconfortante reduz tensões psíquicas, acalma corações aflitos e dissolve o medo. É maravilhosa para purificar ambientes de terapias, massagens ou quartos de pessoas que passam por momentos difíceis, preenchendo o espaço com amorosidade, doçura e serenidade.', '/images/herbs/melissa.png', 'integrative', 'Monografias Selecionadas de Plantas Medicinais da OMS & Práticas Rituais de Cura Física e Espiritual', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(6, 'Capim-Limão (Capim-Santo)', 'capim-limao-capim-santo', 'Cymbopogon citratus', 'Capim-Santo, Capim-Cidreira, Cidró, Erva-Cidreira, Capim-Cheiroso', 'Rico em citral, substância que confere seu marcante e relaxante perfume de limão. O Capim-Limão é um diurético natural suave e um calmante maravilhoso. É muito utilizado para diminuir a pressão arterial levemente, aliviar dores musculares e de cabeça, combater a retenção de líquidos e acalmar estados de histeria e estresse. Possui também ação antimicrobiana e ajuda a aliviar cólicas estomacais e intestinais.', 'Evitar em pessoas com glaucoma de ângulo estreito e hipotensão arterial severa. Mulheres grávidas devem consumir apenas sob supervisão médica.', '• Chá Diurético e Calmante: Coloque 1 colher de sopa de capim-limão picado (fresco de preferência) em 1 xícara de água fervendo. Abafe por 10 minutos, coe e consuma quente ou gelado ao longo do dia.\n\n• Vaporização Facial Purificante: Use o vapor do chá de capim-limão sobre o rosto para abrir os poros e combater a oleosidade excessiva da pele.', '• Banho de Chá para Dores Musculares: Ferva 2 litros de água com 1 xícara de capim-limão por 5 minutos. Despeje do pescoço para baixo após o banho para relaxar a musculatura após exercícios físicos. Outra opção é preparar a infusão padrão morna em uma bacia e imergir os pés cansados (escalda-pés).', '• Defumação de Purificação e Desbloqueio Criativo: Queime capim-limão seco em brasa de carvão. O perfume cítrico pronunciado limpa as nuvens mentais, desfaz bloqueios energéticos e promove a inspiração artística e criativa. Muito utilizado para reenergizar salas de reuniões e espaços de criação.', '/images/herbs/capim_limao.png', 'integrative', 'Manual de Fitoterapia Prática do SUS (Mapeamento Fitoterapêutico) & Sabedoria Popular Brasileira', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(7, 'Calêndula', 'calendula', 'Calendula officinalis', 'Mal-me-quer, Maravilha, Calêndula-Oficial', 'A calêndula é um dos maiores agentes cicatrizantes e anti-inflamatórios da natureza. Suas flores de cor laranja brilhante contêm uma grande quantidade de carotenoides e flavonoides, responsáveis por acelerar a regeneração celular da pele e estimular a produção de colágeno. É ideal para tratar feridas, queimaduras, picadas de insetos, dermatite de fraldas em bebês, psoríase e eczemas. Também possui propriedades antifúngicas, antibacterianas e ameniza cólicas menstruais quando ingerida.', 'Contraindicado para uso oral em gestantes (potencial abortivo). Não aplicar na pele em caso de dermatites alérgicas a plantas da família Asteraceae.', '• Compressa Regeneradora para Pele: Faça uma infusão com 2 colheres de sopa de flores de calêndula em 1 xícara de água fervendo. Espere esfriar, coe e use um pano limpo para aplicar compressas frias sobre feridas ou queimaduras por 20 minutos.\n\n• Infusão Reguladora Menstrual: Coloque 1 colher de chá de flores de calêndula in 1 xícara de água fervente. Abafe por 10 minutos, coe e beba uma semana antes do início do ciclo menstrual.', '• Banho de Assento Anti-inflamatório: Prepare 1 litro de chá forte de calêndula, misture na água morna em uma bacia e faça um banho de assento de 15 minutos para aliviar irritações na região íntima. Pode ser usado também do pescoço para baixo para trazer brilho pessoal e elevar a autoestima.', '• Defumação de Autoestima e Sucesso: A queima das flores de calêndula atrai a energia solar do sucesso, da alegria e da autoconfiança. Sua fumaça acolhedora limpa a negatividade relacionada à insegurança, rejeição e tristeza, elevando instantaneamente a vibração áurica do espaço e dos moradores.', '/images/herbs/calendula.png', 'integrative', 'Monografia da Comissão E da Alemanha, Compêndios Farmacológicos & Tradição Mística Solar Ancestral', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(8, 'Eucalipto', 'eucalipto', 'Eucalyptus globulus', 'Eucalipto-Glóbulo, Árvore-da-Febre', 'Um dos descongestionantes e antissépticos respiratórios mais famosos do planeta. Suas folhas contêm o eucaliptol, composto volátil que atua de forma espetacular na diluição e eliminação de secreções pulmonares, facilitando a respiração. Possui forte ação antisséptica das vias aéreas, expectorante, antiviral e antibacteriana, sendo um remédio natural fantástico para tratar gripes, resfriados, asma, sinusites, rinites e bronquites. Além disso, alivia dores nas articulações.', 'O óleo essencial não deve ser ingerido puro. Contraindicado em caso de inflamações gastrointestinais, vias biliares ou doenças hepáticas severas.', '• Inalação Descongestionante Pulmonar: Ferva 1 litro de água com 5 a 6 folhas frescas de eucalipto. Transfira para uma bacia, posicione o rosto acima do vapor cobrindo a cabeça com uma toalha e respire o vapor profundamente por 10 minutos.\n\n• Vaporizador Natural de Chuveiro: Pendure alguns ramos de eucalipto fresco perto da saída de água do seu chuveiro. O vapor quente do banho liberará os óleos essenciais, limpando as vias aéreas todas as manhãs.', '• Banho para Alívio de Dores Articulares: Ferva 2 litros de água com 10 folhas de eucalipto por 5 minutos. Misture na água da banheira ou jogue sobre o corpo morno após o banho normal. Ajuda a acalmar dores reumáticas, cansaço muscular extremo e traz foco mental.', '• Defumação de Desinfecção Energética e Saúde: Queime folhas de eucalipto secas. É uma das defumações de limpeza mais potentes que existem. A fumaça canforada purifica profundamente o ar de vírus e bactérias físicas, além de banir larvas mentais e energias estagnadas deixadas por doenças ou tristeza acumulada.', '/images/herbs/eucalipto.png', 'integrative', 'British Pharmacopoeia (2020), Estudos Clínicos Respiratórios & Práticas Rituais de Defumação Xamânica', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(9, 'Gengibre', 'gengibre', 'Zingiber officinale', 'Mangarataia, Gengibre-Oficial', 'Uma raiz milenar altamente termogênica, anti-inflamatória e revigorante. O gingerol, principal composto active do gengibre, atua como um poderoso analgésico e antioxidante. O gengibre acelera o metabolismo, combate a fadiga crônica, estimula a digestão promovendo a secreção de enzymes gástricas, e elimina náuseas, enjoos e tonturas de forma extremamente eficaz. Também é um excelente aliado do sistema imunológico no combate a infecções respiratórias e garganta inflamada.', 'Evitar o uso em altas doses por pessoas com cálculos biliares, distúrbios de coagulação (como hemofilia) ou que usam anticoagulantes.', '• Decocção Termogênica e Imunológica: Ferva 1 pedaço de gengibre (cerca de 3 cm cortado em rodelas) em 250ml de água por 5 a 10 minutos. Desligue o fogo, abafe por mais 5 minutos, adicione limão se desejar, coe e beba quente pela manhã para energia ou imunidade.\n\n• Gargarismo contra Dor de Garganta: Prepare o chá de gengibre morno concentrado com uma pitada de sal e faça gargarismos de 3 a 4 vezes ao dia.\n\n• Mastigação contra Enjoos: Mastigue um pedacinho fino de gengibre fresco cru para cortar instantaneamente tonturas ou náuseas de viagem.', '• Banho Termogênico de Força e Vitalidade: Ferva 1,5 litros de água com 1 pedaço de gengibre ralado de 4cm por 8 minutos. Desligue e abafe por 5 minutos. Coe. Espere amornar. Despeje do pescoço para baixo após o banho normal, mentalizando força, poder pessoal, coragem e aquecimento corporal. Ideal para dias frios ou momentos em que se sente sem rumo ou enfraquecido.', '• Defumação de Ativação Energética e Coragem: O gengibre seco em pó ou pequenos pedaços desidratados queimados em brasa liberam uma fumaça picante e quente. Esta fumaça estimula a ação, a iniciativa, o fogo interior e afasta o medo, a preguiça e o desânimo crônico de ambientes parados.', '/images/herbs/gengibre.png', 'integrative', 'Farmacopeia de Medicinas Tradicionais do Extremo Oriente, Farmacologia Integrada & Sabedoria de Cura de Raiz Popular', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(10, 'Sálvia', 'salvia', 'Salvia officinalis', 'Salva, Sálvia-Comum, Sálvia-Real', 'Historicamente conhecida como a planta da longevidade e da saúde feminina. A sálvia possui forte ação fitoterapêutica para regular hormônios femininos, sendo um dos melhores remédios naturais para combater as ondas de calor (fogachos) da menopausa e aliviar sintomas de TPM. Suas propriedades antissépticas e adstringentes fazem dela a planta ideal para tratar infecções da mucosa bucal, aftas, dores de garganta e gengivites, além de melhorar a digestão de gorduras e reduzir o suor excessivo.', 'Contraindicado na gestação e lactação (pode secar o leite materno devido ao teor de tujona) e por pessoas com insuficiência renal severa ou epilepsia.', '• Chá Regulador Feminino: Coloque 1 colher de sopa de folhas de sálvia seca em 1 xícara de água fervente. Abafe por 10 minutos, coe e beba 2 vezes ao dia (especialmente indicado durante a menopausa).\n\n• Infusão para Gargarejo contra Aftas e Dor de Garganta: Prepare um chá forte de sálvia com 2 colheres de sopa para 1 xícara de água fervendo. Deixe amornar, coe e faça bochechos ou gargarejos morno 3 vezes ao dia.', '• Banho de Sabedoria e Equilíbrio Feminino: Ferva 1 litro de água. Desligue e acrescente 3 colheres de sopa de sálvia seca. Abafe por 10 minutos e coe. Deixe amornar. Jogue do pescoço para baixo após o banho de rotina, mentalizando sabedoria ancestral, equilíbrio das emoções e regulação dos ciclos biológicos femininos.', '• Defumação de Sabedoria Sagrada e Banimento de Negatividade: A sálvia comum seca é a erva sagrada por excelência das práticas de defumação. Ao queimar o bastão seco, a fumaça densa e purificadora afasta imediatamente qualquer energia intrusa, inveja ou pensamentos negativos. Restabelece o equilíbrio sagrado do ambiente.', '/images/herbs/salvia.png', 'integrative', 'Monografia da Comissão E de Fitoterapia, Tratados de Saúde Ginecológica Natural & Sabedoria de Anciãs (Tradição Oral)', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(11, 'Carqueja', 'carqueja', 'Baccharis trimera', 'Carqueja-Amarga, Carqueja-do-Mato, Cacália', 'Arbusto perene nativo da América do Sul, caracterizado por hastes aladas sem folhas verdadeiras que realizam a fotossíntese. Contém lactonas sesquiterpênicas e flavonoides que conferem forte ação hepatoprotetora, digestiva e hipoglicemiante. É amplamente recomendada para desintoxicação hepática e controle da digestão lenta.', 'Contraindicado para gestantes (risco de aborto), lactantes, diabéticos (pode causar hipoglicemia severa) e pessoas hipertensas sob medicação.', '• Infusão Digestiva: Adicione 1 colher de sopa de hastes de carqueja picadas em 1 xícara de água fervente. Abafe por 10 minutos, coe e beba antes das principais refeições.', '• Banho de Limpeza e Fluidez: Ferva 1 litro de água. Desligue o fogo e adicione 3 colheres de sopa de carqueja seca. Abafe por 10 minutos e coe. Deixe amornar. Despeje do pescoço para baixo após o banho normal, mentalizando a dissolução de barreiras emocionais, desintoxicação mental e o restabelecimento do fluxo energético positivo.', '• Defumação de Purificação e Quebra de Obstáculos: Queime hastes secas de carqueja em brasa de carvão vegetal. A fumaça de aroma amargo e terroso é ideal para limpar ambientes com energias estagnadas ou densas, quebrando bloqueios que impedem o progresso e promovendo clareza espiritual.', '/images/herbs/carqueja.png', 'integrative', 'Formulário Fitoterápico da Farmacopeia Brasileira (2ª Edição) & Manual de Fitoterapia do SUS', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(12, 'Boldo', 'boldo', 'Peumus boldus', 'Boldo-do-Chile, Boldo-Verdadeiro', 'Árvore nativa das regiões montanhosas do Chile, amplamente cultivada e utilizada em toda a América do Sul. Suas folhas contêm o alcaloide boldina e flavonoides específicos que estimulam a secreção de bile pelo fígado e a liberação pela vesícula biliar. Possui propriedades hepatoprotetoras e digestivas cientificamente consagradas para o tratamento de dispepsias e desconfortos abdominais.', 'Altamente contraindicado em caso de obstrução das vias biliares, doenças hepáticas graves, gestação (risco de má-formação e aborto) e lactação.', '• Infusão Protetora: Adicione 1 colher de chá de folhas secas de boldo-do-chile em 1 xícara de água fervente. Deixe abafado por 10 minutos, coe e consuma morno logo após refeições pesadas.', '• Banho de Descarrego e Purificação Fisiológica: Ferva 1,5 litros de água, desligue e adicione 5 folhas secas de boldo. Deixe abafar até atingir temperatura morna agradável e coe. Despeje lentamente sobre o corpo a partir do pescoço, mentalizando a liberação de rancores, mágoas acumuladas e impurezas físicas ou espirituais.', '• Defumação de Banimento de Energias Densas: Queime folhas desidratadas de boldo em carvão em brasa. A fumaça aromática forte atua desfazendo miasmas energéticos e formas-pensamento negativas acumuladas no ambiente doméstico, trazendo leveza e restauração do equilíbrio íntimo.', '/images/herbs/boldo.png', 'integrative', 'Monografia do Boldo da Agência Europeia de Medicamentos (EMA) & Farmacopeia Homeopática Brasileira', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(13, 'Guaco', 'guaco', 'Mikania glomerata', 'Erva-de-Serpente, Cipó-Catinga, Guaco-de-Cheiro', 'Trepadeira lenhosa nativa da Mata Atlântica brasileira, muito conhecida por suas folhas ovaladas de textura coriácea. Rica em cumarina, a planta possui ação broncodilatadora, expectorante e antiespasmódica de eficácia comprovada nas vias respiratórias. É amplamente empregada na fitoterapia para aliviar tosses persistentes, bronquites e estados gripais congestivos.', 'Evitar o uso prolongado e por pessoas com distúrbios hemorrágicos ou que utilizam medicamentos anticoagulantes, devido à presença de cumarina.', '• Infusão Expectorante: Coloque 1 colher de sobremesa de folhas de guaco picadas em 1 xícara de água fervente. Abafe por 10 minutos, coe e beba até 3 vezes ao dia.\n\n• Xarope Caseiro: Ferva as folhas de guaco com açúcar mascavo e água até obter ponto de xarope líquido para alívio rápido da tosse.', '• Banho de Abertura e Expansão Pulmonar: Ferva 2 litros de água com 5 folhas frescas de guaco por 5 minutos. Permita amornar até uma temperatura agradável e coe. Despeje do pescoço para baixo, respirando profundamente os vapores aromáticos exalados, mentalizando a abertura de caminhos e a desobstrução de emoções reprimidas.', '• Defumação de Proteção e Purificação do Ar: Queime folhas secas de guaco no carvão vegetal. A fumaça adocicada rica em cumarina purifica o ar de agentes patógenos e harmoniza o campo áurico do ambiente, criando um escudo protetor contra influências externas negativas.', '/images/herbs/guaco.png', 'integrative', 'Memento Fitoterápico da ANVISA & Relação Nacional de Medicamentos Essenciais (RENAME) do SUS', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(14, 'Quebra-Pedra', 'quebra-pedra', 'Phyllanthus niruri', 'Erva-Pombinha, Saxífraga, Filanto', 'Pequena planta herbácea anual que cresce espontaneamente em solos úmidos e fendas de calçadas. Contém lignanas, alcaloides e flavonoides que inibem a formação e facilitam a eliminação de cálculos renais ao relaxar os ureteres. Apresenta também marcante ação diurética, anti-inflamatória e protetora do sistema urinário e hepático.', 'Evitar o uso contínuo por mais de 21 dias sem pausa. Contraindicado para gestantes (relaxa a musculatura uterina), lactantes e crianças menores de 6 anos.', '• Decocção Renal: Ferva 1 colher de sopa da planta inteira seca em 1 xícara de água por 5 minutos. Desligue o fogo, abafe por mais 5 minutos, coe e consuma ao longo do dia para estimular a eliminação de toxinas.', '• Banho de Dissolução e Fluidez Emocional: Ferva 1,5 litros de água. Desligue o fogo e adicione 3 colheres de sopa de quebra-pedra seca. Abafe por 10 minutos, coe e deixe amornar. Despeje do pescoço para baixo após o banho, mentalizando a quebra de bloqueios internos rígidos, ressentimentos e mágoas endurecidas.', '• Defumação de Desbloqueio e Harmonização: Queime a erva seca em brasa. A fumaça suave e herbal ajuda a dissolver barreiras energéticas no ambiente que geram discórdia ou estagnação mental, restabelecendo o fluxo natural de entendimento mútuo.', '/images/herbs/quebra-pedra.png', 'integrative', 'Farmacopeia Brasileira (Ed. 6) & Monografias de Plantas Medicis da Organização Mundial da Saúde (OMS)', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(15, 'Arnica', 'arnica', 'Arnica montana', 'Arnica-Montana, Tabaco-de-Montanha', 'Planta de flores amarelas originária das regiões montanhosas da Europa, amplamente consagrada na medicina integrativa. Suas flores contêm lactonas sesquiterpênicas com extraordinária atividade anti-inflamatória, analgésica e anti-equimótica. É excelente para o tratamento de contusões, dores musculares, reumatismo e processos inflamatórios localizados (uso estritamente externo).', 'Uso exclusivamente externo (tópico). Altamente tóxica se ingerida por via oral. Não aplicar em feridas abertas, cortes ou mucosas.', '• Compressa Analgésica: Prepare uma infusão com 1 colher de chá de flores de arnica em 250ml de água fervendo. Deixe esfriar, coe, embeba uma gaze limpa e aplique topicamente sobre a área machucada por 15 minutos (evite feridas abertas).', '• Banho de Recuperação Muscular e Revitalização: Ferva 2 litros de água. Desligue o fogo e adicione 3 colheres de sopa de flores de arnica. Cubra e abafe por 15 minutos. Coe e misture à água morna para um escalda-pés reconfortante ou despeje dos ombros para baixo após atividades exaustivas, mentalizando o alívio das tensões físicas e a renovação celular.', '• Defumação de Proteção Espiritual e Vitalidade: Queime flores secas de arnica em brasa de carvão. A fumaça balsâmica atua restabelecendo a integridade do campo energético do ambiente após discussões tensas ou acidentes, banindo energias de trauma e dor física.', '/images/herbs/arnica.png', 'integrative', 'Monografias da Comissão E da Alemanha & Farmacopeia Homeopática Francesa', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(16, 'Espinheira-Santa', 'espinheira-santa', 'Monteverdia ilicifolia', 'Maytenus, Salva-Almas, Cancerosa, Erva-da-Juventude', 'Arbusto nativo da região sul do Brasil, conhecido por suas folhas com espinhos nas margens. Seus taninos e flavonoides possuem potente ação antiácida, cicatrizante de mucosas gástricas e analgésica digestiva comprovada cientificamente. É o principal tratamento fitoterapêutico para gastrites, úlceras estomacais, azia e dispepsias nervosas.', 'Contraindicado para gestantes (pode provocar contrações uterinas e reduzir a fixação do embrião), lactantes (reduz a secreção de leite) e crianças menores de 6 anos.', '• Infusão Gástrica Protetora: Use 1 colher de sopa de folhas secas de espinheira-santa para 1 xícara de água fervente. Abafe por 10 minutos, coe e consuma 30 minutos antes das principais refeições.', '• Banho de Proteção Digestiva e Emocional: Prepare uma infusão fervendo 1,5 litros de água e adicionando 3 colheres de sopa de folhas de espinheira-santa. Deixe abafado por 15 minutos, coe e espere amornar. Despeje lentamente sobre o corpo mentalizando a criação de um escudo de proteção energética que filtra sentimentos negativos alheios e digere as próprias tensões.', '• Defumação de Filtragem Energética: Queime folhas secas em um incensário. A fumaça atua limpando o ambiente de resíduos de inveja e cobiça, auxiliando os moradores a estabelecerem limites saudáveis em suas interações diárias.', '/images/herbs/espinheira-santa.png', 'integrative', 'Formulário Fitoterápico Nacional do SUS & Estudos Clínicos da Central de Medicamentos (CEME)', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(17, 'Passiflora', 'passiflora', 'Passiflora incarnata', 'Flor-do-Maracujá, Maracujá-Silvestre', 'Trepadeira exuberante cujas flores e folhas contêm alcaloides indólicos e flavonoides com marcante ação depressora do sistema nervoso central. Atua como um dos mais potentes sedativos e ansiolíticos naturais da fitoterapia clássica. Promove a melhora significativa do sono, alívio de palpitações cardíacas de origem nervosa e redução da irritabilidade cotidiana.', 'Evitar o consumo associado a álcool, sedativos ou calmantes sintéticos (potencializa a sonolência). Não recomendado o uso antes de dirigir.', '• Infusão Tranquilizante Noturna: Adicione 1 colher de chá de folhas e flores secas de passiflora em 1 xícara de água fervendo. Abafe por 10 minutos, coe e beba preferencialmente 1 hora antes de dormir.', '• Banho de Acalento contra Insônia: Ferva 1 litro de água. Apague o fogo e acrescente 3 colheres de sopa de passiflora seca. Deixe abafado por 10 minutos, coe e tempere com água morna. Tome o banho do pescoço para baixo à noite, mentalizando o desligamento dos ruídos externos e o mergulho em um sono reparador e protegido.', '• Defumação de Paz Profunda e Sono Tranquilo: Queime folhas secas de passiflora em carvão vegetal. A fumaça suave purifica a atmosfera doméstica de vibrações de histeria, preocupação e angústia, induzindo a um estado de relaxamento ideal para práticas meditativas e repouso.', '/images/herbs/passiflora.png', 'integrative', 'British Herbal Pharmacopoeia & Monografia de Plantas Medicinais da Agência Europeia de Medicamentos', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(18, 'Valeriana', 'valeriana', 'Valeriana officinalis', 'Erva-dos-Gatos, Valeriana-Oficial', 'Planta herbácea perene nativa da Europa e Ásia, cujas raízes e rizomas exalam um odor característico marcante. Contém ácidos valerênicos e valepotriatos que agem nos receptores GABA do cérebro, reduzindo significativamente o tempo de latência do sono e acalmando a hiperexcitabilidade mental. É amplamente prescrita como alternativa natural e segura aos ansiolíticos sintéticos em casos de distúrbios do sono e estresse severo.', 'Não deve ser ingerida junto com álcool, sedativos sintéticos ou antes de operar veículos. Evitar o uso contínuo por mais de 4 semanas consecutivas.', '• Infusão Sedativa das Raízes: Adicione 1 colher de chá de raízes picadas de valeriana em 1 xícara de água fervente. Deixe abafado por 15 minutos (ou ferva por 3 minutos em decocção), coe e consuma 30 a 60 minutos antes de se deitar.', '• Banho de Desaceleração e Desligamento Mental: Ferva 1,5 litros de água e adicione 2 colheres de sopa de raízes de valeriana. Deixe ferver por 3 minutos, desligue o fogo e abafe por 10 minutos. Coe e misture à água do banho. Despeje do pescoço para baixo, mentalizando a liberação de todas as tensões musculares e mentais do dia, permitindo-se descansar inteiramente.', '• Defumação de Ancoramento e Alívio de Estresse Crônico: Queime as raízes secas e picadas sobre o carvão. Embora o odor seja pungente e característico, sua fumaça possui forte efeito sedativo no ambiente, desfazendo bloqueios de estresse extremo e trazendo sensação de segurança e aterramento.', '/images/herbs/valeriana.png', 'integrative', 'United States Pharmacopeia (USP) & Monografia da OMS sobre Radix Valerianae', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(19, 'Macela', 'macela', 'Achyrocline satureioides', 'Marcela, Marcela-do-Campo, Macela-do-Sertão', 'Planta aromática de flores amarelas e delicadas que cresce em campos abertos da América do Sul. Rica em flavonoides e óleos essenciais, destaca-se por suas potentes ações antiespasmódica, digestiva, anti-inflamatória e calmante suave. É tradicionalmente utilizada no tratamento de distúrbios digestivos de origem nervosa, cólicas intestinais e para promover relaxamento físico.', 'Evitar o uso em pessoas com conhecida sensibilidade a plantas da família Asteraceae. Evitar o uso concomitante com sedativos e ansiolíticos.', '• Chá Digestivo e Suave: Coloque 1 colher de sopa de flores secas de macela em 1 xícara de água fervente. Deixe abafado por 5 a 10 minutos, coe e consuma morno após as refeições ou antes de dormir.', '• Banho de Acalento e Purificação Dourada: Ferva 1,5 litros de água. Desligue o fogo e adicione 4 colheres de sopa de flores de macela secas. Abafe por 15 minutos até a água adquirir um tom amarelo dourado radiante. Coe. Despeje do pescoço para baixo após o banho normal, mentalizando harmonia, proteção angelical, brilho pessoal e aconchego emocional.', '• Defumação de Harmonia e Limpeza Sutil: Queime flores de macela secas em brasa. A fumaça exala um perfume doce e herbal que dissipa imediatamente tensões no ar, promovendo sentimentos de tranquilidade, união familiar e clareza nos relacionamentos domésticos.', '/images/herbs/macela.png', 'integrative', 'Farmacopeia Brasileira (Ed. 5) & Formulário de Fitoterapia Popular do Rio Grande do Sul', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(20, 'Dente-de-Leão', 'dente-de-leao', 'Taraxacum officinale', 'Taraxaco, Coroa-de-Monge, Amor-dos-Homens', 'Planta herbácea perene extremamente resistente, caracterizada por suas flores amarelas que se transformam em globos de sementes plumosas. Rica em potássio, inulina e princípios amargos (taraxacina), possui excelente atividade diurética (sem perda de potássio), depurativa do sangue e estimulante das funções hepáticas e biliares. Auxilia na digestão, eliminação de toxinas e redução de inchaços corporais.', 'Contraindicado em pessoas com obstrução dos dutos biliares, úlcera gastroduodenal, gastrite aguda e obstrução intestinal.', '• Decocção de Raízes Depurativas: Ferva 1 colher de chá de raízes secas picadas em 250ml de água por 5 minutos, coe e consuma pela manhã.\n\n• Infusão Diurética de Folhas: Adicione 1 colher de sopa de folhas secas em 1 xícara de água fervente, abafe por 10 minutos, coe e consuma ao longo do dia.', '• Banho de Renovação e Limpeza de Estagnações: Ferva 2 litros de água com 3 colheres de sopa de folhas e raízes secas de dente-de-leão por 3 minutos. Abafe por 10 minutos e coe. Deixe amornar. Despeje do pescoço para baixo após o banho regular, mentalizando a desintoxicação de pensamentos negativos e a renovação de suas metas e energia de vida.', '• Defumação de Libertação e Novos Começos: Queime folhas e flores desidratadas sobre carvão em brasa. A fumaça atua dissipando barreiras mentais, medos limitantes e apegos ao passado, abrindo espaço para novas oportunidades e novos ciclos prósperos na residência.', '/images/herbs/dente-de-leao.png', 'integrative', 'British Herbal Pharmacopoeia & Monografia da OMS sobre Folium et Radix Taraxaci', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(21, 'Bardana', 'bardana', 'Arctium lappa', 'Pegamassa, Orelha-de-Gigante, Erva-dos-Tinhorões', 'Planta de grandes folhas e flores espinhosas cujas raízes profundas são ricas em inulina, compostos poliacetilênicos e ácidos fenólicos. Destaca-se na medicina integrativa por sua impressionante ação depurativa do sangue, desintoxicante linfática e sebostática. É muito recomendada para o tratamento de afecções crônicas da pele, como acne severa, psoríase, eczemas e furunculose.', 'Evitar o uso por gestantes, lactantes e crianças. Pacientes diabéticos devem monitorar a glicemia devido ao risco de hipoglicemia.', '• Decocção Depurativa das Raízes: Adicione 1 colher de sobremesa de raízes fatiadas de bardana em 1 xícara de água. Ferva por 5 a 8 minutos, coe e beba em jejum ou entre as refeições.\n\n• Compressa Tópica para Acne: Umedeça uma gaze no chá morno e aplique suavemente sobre a pele limpa do rosto por 15 minutos.', '• Banho de Desintoxicação Cutânea e Áurica: Ferva 2 litros de água com 3 colheres de sopa de raízes de bardana picadas por 7 minutos. Abafe por 10 minutos e coe. Despeje morno do pescoço para baixo, mentalizando a expulsão de toxinas físicas, a desinflamação do corpo e a limpeza profunda do seu campo energético pessoal.', '• Defumação de Purificação Profunda e Banimento: Queime pedacinhos de raiz seca de bardana sobre carvão vegetal. A fumaça de aroma denso e terroso purifica o ambiente contra acúmulo de sentimentos ruins, ciúme e vibrações que causam discórdia familiar.', '/images/herbs/bardana.png', 'integrative', 'Farmacopeia Homeopática dos Estados Unidos & Manual de Fitoterapia Dermatológica', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(22, 'Unha-de-Gato', 'unha-de-gato', 'Uncaria tomentosa', 'Herba-do-Peru, Cipó-de-Gato', 'Trepadeira lenhosa gigante nativa da floresta amazônica, que possui espinhos curvos semelhantes a unhas de gato em suas folhas. Seus alcaloides oxindólicos pentacíclicos conferem-lhe uma das mais potentes ações imunomoduladoras, anti-inflamatórias e antioxidantes do reino vegetal. É amplamente empregada no tratamento adjuvante de artrite reumatoide, osteoartrite, inflamações crônicas e para o fortalecimento do sistema imunológico.', 'Contraindicado para pacientes transplantados ou que usam imunossupressores (devido ao seu efeito imunoestimulante) e mulheres grávidas.', '• Decocção Imunomoduladora da Casca: Ferva 1 colher de sopa de casca interna desidratada de unha-de-gato em 1 xícara de água por 10 a 15 minutos. Cubra, deixe amornar, coe e consuma até 2 vezes ao dia.', '• Banho de Proteção Física e Fortalecimento Energético: Ferva 2 litros de água com 2 colheres de sopa de casca de unha-de-gato por 15 minutos. Coe e deixe amornar até uma temperatura agradável. Despeje do pescoço para baixo, mentalizando o fortalecimento de seu escudo áurico, a vitalidade do corpo físico e a cura de dores articulares.', '• Defumação de Proteção e Elevação de Frequência: Queime pedaços secos de casca de unha-de-gato em brasa. A fumaça espessa e amadeirada é excelente para selar o ambiente doméstico contra invasões espirituais indesejadas e elevar a vibração de cura.', '/images/herbs/unha-de-gato.png', 'integrative', 'Formulário Fitoterápico da Farmacopeia Brasileira & Monografias da Organização Mundial da Saúde (OMS)', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(23, 'Uxi-Amarelo', 'uxi-amarelo', 'Endopleura uchi', 'Uxi, Axuá, Pururu', 'Árvore alta e majestosa endêmica da Bacia Amazônica, cuja casca cinzenta e fibrosa é largamente utilizada na medicina tradicional e integrativa. Rica em bergenina, substância com extraordinária atividade anti-inflamatória, imunomoduladora e antioxidante. É amplamente recomendada na saúde da mulher para auxiliar no tratamento de miomas uterinos, cistos ovarianos, endometriose e infecções urinárias.', 'Embora muito seguro para o útero, é contraindicado durante a gestação e lactação. Interromper o uso durante o fluxo menstrual mais intenso se notar aumento.', '• Decocção para Saúde Feminina: Adicione 1 colher de sopa de casca de uxi-amarelo picada em 1 litro de água. Ferva por 10 a 15 minutos em fogo baixo. Coe e consuma ao longo do dia (frequentemente associado ao chá de unha-de-gato).', '• Banho de Útero e Conexão Sagrada Feminina: Prepare a decocção concentrada fervendo 2 colheres de sopa de casca de uxi-amarelo em 1,5 litros de água por 15 minutos. Coe e misture em uma bacia grande para banho de assento morno de 15 minutos, mentalizando a cura física e energética do aparelho reprodutor, liberando bloqueios de fertilidade e traumas femininos.', '• Defumação de Resgate da Energia Ancestral: Queime a casca desidratada de uxi-amarelo em carvão. A fumaça terrosa e profunda reconecta o ambiente com as forças da natureza e do sagrado feminino, restabelecendo a harmonia e o respeito no lar.', '/images/herbs/uxi-amarelo.png', 'integrative', 'Estudos de Etnofarmacologia da Amazônia & Manual Prático de Ginecologia Natural', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(24, 'Hibisco', 'hibisco', 'Hibiscus sabdariffa', 'Mimo-de-Vênus, Vinagreira, Caruru-Azedo', 'Arbusto cultivado em regiões tropicais, cujos cálices florais vermelhos e carnosos dão origem a uma das bebidas mais populares do mundo. Apresenta alta concentração de antocianinas, flavonoides e ácidos orgânicos que atuam como poderosos antioxidantes, diuréticos e redutores da pressão arterial. É muito utilizado no auxílio do emagrecimento saudável, controle do colesterol e combate à retenção de líquidos.', 'Evitar por gestantes (pode alterar níveis hormonais e causar relaxamento uterino), pessoas com hipotensão arterial ou que buscam engravidar.', '• Infusão Termogênica e Diurética: Adicione 1 colher de sopa de cálices secos de hibisco em 1 xícara de água fervente. Abafe por 5 a 8 minutos, coe e beba quente ou gelado ao longo do dia.', '• Banho de Atração, Paixão e Autoestima: Ferva 1,5 litros de água. Ao desligar o fogo, adicione 3 colheres de sopa de flores secas de hibisco. Abafe até a água ficar de cor vermelho rubi vibrante e coe. Despeje do pescoço para baixo após o banho normal, mentalizando amor-próprio, poder de atração, vitalidade criativa e ativação da energia sexual saudável.', '• Defumação de Magnetismo e Harmonia Amorosa: Queime as flores secas de hibisco em carvão em brasa. A fumaça exala um aroma suave que atrai vibrações de amor, desejo, sociabilidade e desfaz a frieza emocional acumulada nos cômodos da casa.', '/images/herbs/hibisco.png', 'integrative', 'Estudos Clínicos sobre Hipertensão e Hibisco (Journal of Nutrition) & Tradição Herbal de Afrodisíacos', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(25, 'Cavalinha', 'cavalinha', 'Equisetum arvense', 'Cauda-de-Cavalo, Cola-de-Cavalo, Milho-de-Cobra', 'Planta pré-histórica singular que se assemelha a uma pequena cauda de cavalo e cresce em áreas úmidas. É um dos maiores tesouros minerais da natureza, possuindo alto teor de silício orgânico, potássio e flavonoides. Destaca-se por sua espetacular ação diurética (que não altera a eliminação de eletrólitos), remineralizante de ossos e articulações, além de fortalecer cabelos, unhas e estimular a síntese de colágeno na pele.', 'Evitar o uso por pessoas com insuficiência renal ou cardíaca severa. Não utilizar de forma contínua por períodos superiores a 15 dias sem pausa.', '• Decocção Remineralizante: Devido ao alto teor de silício, ferva 1 colher de sopa de hastes secas de cavalinha em 1 xícara de água por 5 minutos. Abafe por 10 minutos, coe e beba duas vezes ao dia.', '• Banho de Fortalecimento Físico e Fluidez Energética: Ferva 2 litros de água com 4 colheres de sopa de cavalinha seca por 5 minutos. Coe e deixe amornar. Despeje lentamente a partir do pescoço, mentalizando a estruturação de seu corpo físico, o fortalecimento de sua força interior e a eliminação do inchaço e cansaço das pernas.', '• Defumação de Proteção e Foco Mental: Queime as hastes secas de cavalinha em carvão. A fumaça sutil ajuda a estruturar pensamentos dispersos, promovendo a disciplina mental, o foco em metas difíceis e a filtragem de energias caóticas externas.', '/images/herbs/cavalinha.png', 'integrative', 'Farmacopeia Alemã (Commission E) & Formulário Fitoterápico Nacional do SUS', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(26, 'Chapéu-de-Couro', 'chapeu-de-couro', 'Echinodorus grandiflorus', 'Erva-do-Brejo, Chapeuzinho, Alface-do-Brejo', 'Planta aquática de grandes folhas coriáceas e rígidas que lembram a forma de um chapéu típico nordestino. Rica em flavonoides, diterpenos e sais minerais, destaca-se por sua excelente ação depurativa, anti-inflamatória, antirreumática e diurética. É tradicionalmente utilizada para auxiliar no tratamento de gota, reumatismo crônico, excesso de ácido úrico no sangue e infecções do trato urinário.', 'Evitar o uso por pessoas com hipotensão arterial crônica e insuficiência cardíaca ou renal severa, devido à forte ação diurética.', '• Infusão Depurativa e Antigota: Coloque 1 colher de sopa de folhas picadas de chapéu-de-couro em 1 xícara de água fervente. Deixe abafado por 10 minutos, coe e beba 2 a 3 vezes ao dia.', '• Banho de Desinflamação e Limpeza Emocional Profunda: Ferva 2 litros de água e adicione 3 colheres de sopa de folhas secas de chapéu-de-couro. Abafe por 10 minutos e coe. Despeje morno do pescoço para baixo após o banho normal, mentalizando o alívio das dores articulares e a eliminação de sentimentos pesados e ressentimentos antigos que enrijecem a mente.', '• Defumação de Purificação de Ambientes Estagnados: Queime folhas secas picadas sobre o carvão. A fumaça terrosa purifica o ar e ajuda a desobstruir energias de estagnação mental e rancor acumulados por desentendimentos de longa data no lar.', '/images/herbs/chapeu-de-couro.png', 'integrative', 'Farmacopeia Brasileira (Ed. 6) & Manual de Fitoterapia de Plantas Medicinais da Mata Atlântica', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(27, 'Mulungu', 'mulungu', 'Erythrina mulungu', 'Corticeira, Mulungu-Cerejeira, Bico-de-Papagaio', 'Árvore nativa do cerrado brasileiro, com belas flores alaranjadas e casca cientificamente reverenciada por suas propriedades farmacológicas no sistema nervoso. Contém alcaloides como a eritravina que atuam diretamente nos receptores de GABA, apresentando forte efeito ansiolítico, sedativo suave e antiespasmódico. É um dos melhores recursos naturais para o tratamento de insônia severa, síndrome do pânico, histeria e ansiedade crônica.', 'Contraindicado para pessoas que utilizam medicamentos anti-hipertensivos ou sedativos químicos, pois pode potencializar seus efeitos.', '• Decocção Sedativa da Casca: Ferva 1 colher de sobremesa de casca de mulungu triturada in 1 xícara de água por 10 minutos. Desligue o fogo, abafe por mais 5 minutos, coe e consuma 1 hora antes de dormir para garantir um sono reparador.', '• Banho de Acalento contra Ataques de Pânico e Nervosismo: Prepare uma decocção fervendo 3 colheres de sopa de casca de mulungu em 2 litros de água por 15 minutos. Coe e deixe amornar até uma temperatura muito agradável. Despeje lentamente do pescoço para baixo, mentalizando a descida de uma onda de paz divina, acalmando o coração acelerado e relaxando os nervos.', '• Defumação de Harmonia Familiar e Serenidade Cósmica: Queime lascas secas de mulungu sobre carvão em brasa. A fumaça densa e com notas de madeira acalma imediatamente mentes agitadas e agressividade acumulada nos cômodos, restabelecendo a paz absoluta no lar.', '/images/herbs/mulungu.png', 'integrative', 'Estudos de Psicofarmacologia de Plantas Nacionais (USP) & Manual de Fitoterapia Integrativa do SUS', '2026-05-28 03:56:12', '2026-05-28 03:56:12');
INSERT INTO `herbs` (`id`, `name`, `slug`, `scientific_name`, `aliases`, `description`, `contraindications`, `how_to_use`, `bath_instructions`, `incense_usage`, `image_path`, `source_type`, `sources`, `created_at`, `updated_at`) VALUES
(28, 'Erva-Doce', 'erva-doce', 'Pimpinella anisum', 'Erva-Doce-Verdadeira, Anis, Pimpinela', 'Planta herbácea anual de flores brancas e sementes pequenas e muito aromáticas, cultivada desde a antiguidade. Seus frutos contêm óleo essencial rico em anetol, substância que confere forte atividade carminativa, antiespasmódica, galactagoga e expectorante. É ideal para aliviar gases intestinais, cólicas infantis, má digestão, tosses com catarro e estimular a lactação em mães.', 'Evitar o uso do óleo essencial por gestantes, lactantes e crianças. O chá deve ser consumido em quantidades moderadas por mulheres grávidas.', '• Infusão Antigases e Cólicas: Esmague levemente 1 colher de chá de sementes de erva-doce para liberar os óleos essenciais. Adicione a 1 xícara de água fervendo, abafe por 7 a 10 minutos, coe e beba morno após as refeições principais.', '• Banho de Doçura, Conforto e Proteção Infantil: Ferva 1 litro de água, apague o fogo e junte 2 colheres de sopa de sementes de erva-doce. Deixe abafado por 10 minutos e coe. Despeje morno sobre o corpo após o banho higiênico, mentalizando o recolhimento, a doçura da alma, a redução de medos ocultos e a atração de energias ternas.', '• Defumação de Acolhimento e Paz de Espírito: Queime as sementes secas de erva-doce em carvão vegetal. A fumaça adocicada e reconfortante desfaz o estresse mental, suaviza sentimentos de solidão e cria uma atmosfera propícia para a amabilidade e a união familiar.', '/images/herbs/erva-doce.png', 'integrative', 'Farmacopeia Europeia & Monografia de Fitoterapia do Ministério da Saúde do Brasil', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(29, 'Funcho', 'funcho', 'Foeniculum vulgare', 'Erva-Doce-de-Cabeça, Funcho-Doce', 'Planta herbácea perene de folhas plumosas amarelas e aroma pronunciado que lembra o anis. Rico em anetol e fenchona, possui excelentes propriedades digestivas, diuréticas, antiespasmódicas e anti-inflamatórias. Auxilia no alívio de cólicas estomacais e abdominais, estimula a produção de leite materno e combate a retenção de líquidos com eficácia.', 'Evitar o uso excessivo em gestantes devido à presença de estragol. Contraindicado para pessoas com hipersensibilidade ao anetol.', '• Infusão Digestiva e Diurética: Amasse 1 colher de chá de sementes secas de funcho e adicione a 1 xícara de água fervente. Abafe por 10 minutos, coe e consuma após o almoço ou jantar.', '• Banho de Alinhamento Energético e Equilíbrio Físico: Ferva 1,5 litros de água, desligue e adicione 3 colheres de sopa de sementes ou folhas frescas de funcho. Deixe abafado por 10 minutos, coe e espere amornar. Despeje do pescoço para baixo, mentalizando a digestão das experiências diárias difíceis e o restabelecimento do equilíbrio interno.', '• Defumação de Purificação e Clareza Mental: Queime sementes de funcho desidratadas sobre brasas. A fumaça exala um aroma fresco e herbal que limpa o ambiente de confusões mentais, ciúmes e promove a clareza de ideias em ambientes profissionais.', '/images/herbs/funcho.png', 'integrative', 'Farmacopeia Britânica & Mapeamento de Fitoterápicos do SUS (Atenção Básica)', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(30, 'Losna', 'losna', 'Artemisia absinthium', 'Absinto, Erva-dos-Vermes, Alenço', 'Planta medicinal de folhagem prateada e sabor extremamente amargo, historicamente associada à alquimia e à medicina popular. Contém princípios amargos (absintina) e óleos essenciais que atuam como potentes estimulantes do apetite, digestivos, coleréticos e vermífugos. É um recurso clássico para tratar a anorexia nervosa, atonia da vesícula biliar, verminoses intestinais e cólicas menstruais.', 'Altamente contraindicado na gestação (abortivo), lactação e em casos de úlceras estomacais. Evitar uso contínuo por mais de 7 dias devido à toxicidade da tujona.', '• Infusão Estimulante Digestiva: Adicione 1 colher de chá de folhas secas de losna em 1 xícara de água fervente (sabor altamente amargo). Deixe abafado por 5 a 7 minutos, coe e beba no máximo 1 xícara ao dia dividida em pequenas colheres antes das refeições.', '• Banho de Descarrego Pesado e Quebra de Feitiços Mentais: Ferva 2 litros de água e acrescente 2 colheres de sopa de losna seca. Deixe abafado por 15 minutos e coe. Deixe amornar. Despeje estritamente do pescoço para baixo após o banho normal, mentalizando a destruição de invejas profundas, pensamentos obsessivos e o corte de cordões energéticos negativos.', '• Defumação de Proteção Psíquica e Limpeza Energética Pesada: Queime folhas desidratadas de losna em carvão vegetal. A fumaça canforada e amarga é uma ferramenta poderosa para banir formas-pensamento hostis, miasmas astrais e purificar ambientes com histórico de conflitos graves.', '/images/herbs/losna.png', 'integrative', 'Monografia da ESCOP (European Scientific Cooperative on Phytotherapy) & Formulário Fitoterápico do SUS', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(31, 'Poejo', 'poejo', 'Mentha pulegium', 'Poejo-Real, Hortelã-dos-Campos', 'Pequena erva rasteira extremamente aromática pertencente à família das mentas, muito comum em áreas de pastagem úmidas. Rica em pulegona, exibe excelente ação expectorante, mucolítica, antiespasmódica e digestiva. É tradicionalmente empregada na fitoterapia para aliviar tosses produtivas, gripes, asma, má digestão associada a flatulências.', 'Altamente contraindicado na gestação (forte ação abortiva do óleo essencial) e para crianças menores de 2 anos devido a riscos respiratórios e hepáticos.', '• Infusão Expectorante: Adicione 1 colher de chá de folhas e flores secas de poejo em 1 xícara de água fervente. Abafe por 10 minutos, coe e consuma quente ou morno. Ideal para crianças (em dosagens reduzidas) e adultos gripados.', '• Banho de Abertura de Caminhos e Alívio Respiratório: Ferva 1,5 litros de água. Ao ferver, apague o fogo e adicione 3 colheres de sopa de poejo fresco ou seco. Abafe por 10 minutos e coe. Despeje morno do pescoço para baixo, respirando fundo o perfume mentolado, mentalizando a purificação das vias aéreas e a desobstrução das emoções reprimidas.', '• Defumação de Purificação do Ar e Foco: Queime folhas secas de poejo em carvão. A fumaça rica em pulegona limpa o ar de germes físicos e energéticos, renova a atmosfera mental do ambiente de trabalho e desperta a intuição e a clareza de pensamento.', '/images/herbs/poejo.png', 'integrative', 'Farmacopeia Portuguesa & Tradição Ervanária do Interior do Brasil (Phytotherapy Manual)', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(32, 'Pata-de-Vaca', 'pata-de-vaca', 'Bauhinia forficata', 'Pé-de-Boi, Unha-de-Vaca, Bauínia', 'Árvore nativa do Brasil cujas folhas possuem formato característico semelhante a pegadas de bovinos. Seus flavonoides (caempferitrina) conferem-lhe potente atividade hipoglicemiante cientificamente documentada, sendo apelidada de insulina vegetal. Além de auxiliar no controle do diabetes, apresenta excelente ação diurética, antioxidante e depurativa do organismo.', 'Pessoas diabéticas em tratamento medicamentoso devem monitorar a glicemia frequentemente, pois a planta possui forte efeito hipoglicemiante.', '• Decocção Hipoglicemiante: Ferva 2 folhas secas picadas de pata-de-vaca em 250ml de água por 5 minutos. Desligue, abafe por mais 10 minutos, coe e consuma após as refeições principais conforme orientação profissional.', '• Banho de Equilíbrio Vital e Redução de Tensões: Ferva 2 litros de água com 4 folhas secas de pata-de-vaca por 5 minutos. Coe e deixe amornar. Despeje do pescoço para baixo após o banho normal, mentalizando a harmonização de suas energias vitais, o equilíbrio do açúcar e da doçura na vida e a eliminação do cansaço.', '• Defumação de Estabilidade e Ancoramento Espiritual: Queime folhas secas em carvão em brasa. A fumaça suave atua promovendo a estabilidade emocional dos moradores, ancorando energias de paz, equilíbrio financeiro e clareza nas decisões de negócios.', '/images/herbs/pata-de-vaca.png', 'integrative', 'Estudo de Eficácia Hipoglicemiante da Bauhinia (Unicamp) & Formulário de Fitoterapia do SUS', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(33, 'Jurubeba', 'jurubeba', 'Solanum paniculatum', 'Jurubeba-Verdadeira, Jupeba, Jurubeba-do-Pará', 'Arbusto espinhoso nativo do Brasil, de flores roxas e pequenos frutos amarelos de sabor intensamente amargo. Contém alcaloides esteroidais e saponinas que agem como potentes estimulantes das secreções gástricas e biliares, além de possuir ação hepatoprotetora. É amplamente empregado na medicina popular e integrativa para tratar dispepsia, ressaca alcoólica, fígado preguiçoso e atonia gástrica.', 'Evitar o uso diário e prolongado (superior a 15 dias) pois pode causar irritação gástrica, diarreia e sobrecarga renal.', '• Decocção Aperiente e Hepatoprotetora: Ferva 1 colher de chá de raiz ou folhas secas picadas de jurubeba em 1 xícara de água por 5 minutos. Coe e beba em pequenas colheres 15 minutos antes de comer para abrir o apetite e facilitar a digestão.', '• Banho de Desintoxicação Física e Proteção Espiritual: Ferva 1,5 litros de água com 3 colheres de sopa de folhas secas de jurubeba por 5 minutos. Deixe abafado até amornar e coe. Despeje do pescoço para baixo após o banho normal, mentalizando a limpeza de excessos físicos e a proteção áurica contra vibrações negativas e inveja alheia.', '• Defumação de Banimento de Más Vibrações: Queime as folhas e raízes desidratadas sobre brasas. A fumaça amarga possui alta eficiência para desintegrar miasmas astrais de inércia, preguiça coletiva e raivas acumuladas em ambientes comerciais ou residenciais.', '/images/herbs/jurubeba.png', 'integrative', 'Farmacopeia Brasileira (Ed. 1 - 1929) & Farmacologia de Plantas Medicinais Brasileiras', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(34, 'Lippia Alba', 'lippia-alba', 'Lippia alba', 'Erva-Cidreira-de-Arbusto, Cidreira-de-Árvore, Sálvia-da-Gripe', 'Arbusto aromático nativo das Américas, muito confundido com a erva-cidreira comum devido ao seu forte e relaxante cheiro cítrico. Rica em limoneno, citral e mirceno, possui extraordinária ação ansiolítica, sedativa suave, antiespasmódica gástrica e analgésica. É amplamente empregada no controle da ansiedade, hipertensão de origem nervosa, insônia e cólicas.', 'Muito segura, mas deve ser consumida com moderação. Evitar antes de realizar atividades de alta concentração por seu leve efeito relaxante.', '• Infusão Calmante e Hipotensora: Adicione 1 colher de sopa de folhas frescas picadas em 1 xícara de água fervente. Abafe por 10 minutos, coe e consuma 2 a 3 vezes ao dia, especialmente sob condições de estresse elevado.', '• Banho de Serenidade e Relaxamento do Coração: Ferva 1,5 litros de água, desligue e adicione 4 colheres de sopa de folhas de Lippia Alba frescas. Deixe abafado até atingir temperatura morna agradável e coe. Despeje lentamente sobre o corpo, mentalizando o acalento do coração acelerado, a dissolução do estresse e a harmonia mental.', '• Defumação de Acolhimento e Purificação Emocional: Queime as folhas secas em um incensário. O aroma cítrico penetrante limpa a atmosfera áurica de desespero e medos ocultos, preenchendo o ambiente com vibrações de serenidade, amorosidade e aconchego.', '/images/herbs/lippia-alba.png', 'integrative', 'Formulário Fitoterápico Nacional do SUS & Monografia de Lippia alba da Sociedade Brasileira de Farmacognosia', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(35, 'Anis-Estrelado', 'anis-estrelado', 'Illicium verum', 'Anis-da-China, Funcho-da-China', 'Árvore perene originária da China e Vietnã, famosa por seus frutos em forma de estrela de 8 pontas que exalam um marcante perfume adocicado. Rica em anetol e ácido chiquímico (precursor de antivirais), possui propriedades expectorantes, antiespasmódicas, carminativas e digestivas. Auxilia no combate a gripes e tosses, gases intestinais e estimula o sistema imunológico com eficácia.', 'Evitar o uso em bebês e crianças pequenas devido ao risco de reações neurológicas e alérgicas. Gestantes devem usar com moderação.', '• Infusão Antigripal e Digestiva: Coloque 2 a 3 estrelas de anis-estrelado em 1 xícara de água fervente. Abafe por 10 minutos, coe e consuma morno após refeições principais ou em quadros de tosses produtivas.', '• Banho de Magnetismo, Brilho Pessoal e Prosperidade: Ferva 1,5 litros de água com 7 estrelas de anis-estrelado por 5 minutos. Desligue o fogo, abafe e coe após amornar. Despeje do pescoço para baixo após o banho normal, mentalizando a atração de prosperidade, o aumento de sua intuição espiritual, autoestima e brilho pessoal.', '• Defumação de Intuição e Abertura de Caminhos Financeiros: Queime estrelas de anis secas em brasas de carvão vegetal. A fumaça intensamente perfumada e adocicada aguça a intuição, melhora as faculdades mentais para meditação e atrai a energia do dinheiro e do sucesso comercial.', '/images/herbs/anis-estrelado.png', 'integrative', 'Pharmacopoeia of the People\'s Republic of China & Tratado de Fitoterapia Energética e Fitoenergética', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(36, 'Cravo-da-Índia', 'cravo-da-india', 'Syzygium aromaticum', 'Cravo-Cabecinha, Girofle', 'Botões florais secos de uma árvore perene nativa das Ilhas Molucas, na Indonésia, conhecidos mundialmente na culinária e medicina antiga. Apresenta o maior teor de eugenol da natureza, substância com extraordinária atividade antisséptica, analgésica local, anti-inflamatória e estimulante da circulação periférica. É amplamente utilizado contra dores de dente, infecções orais, má digestão e parasitoses intestinais.', 'Contraindicado o consumo excessivo em gestantes, lactantes e pessoas que utilizam medicamentos anticoagulantes. O óleo essencial pode irritar a pele.', '• Infusão Estimulante e Analgésica: Adicione 1 colher de chá de cravos-da-índia inteiros em 1 xícara de água fervendo. Abafe por 10 minutos, coe e consuma morno.\n\n• Gargarejo Antisséptico: Use a infusão morna para fazer bochechos em casos de inflamação de gengiva ou aftas.', '• Banho de Proteção Espiritual, Limpeza de Larvas Astrais e Vitalidade: Ferva 1,5 litros de água com 1 colher de sopa de cravos-da-índia por 5 minutos. Deixe amornar e coe. Despeje do pescoço para baixo, mentalizando a queima de energias negativas grudadas no corpo (como inveja profunda), o revigoramento das forças físicas e a ativação da coragem.', '• Defumação de Purificação de Ambientes contra Más Influências: Queime cravos secos em carvão. A fumaça aromática, picante e forte limpa instantaneamente o ambiente de miasmas negativos, larvas astrais e atrai vibrações de prosperidade e proteção psíquica ativa.', '/images/herbs/cravo-da-india.png', 'integrative', 'Farmacopeia Francesa & Estudos Clínicos de Fitoterapia Odontológica (Eugenol USP)', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(37, 'Canela', 'canela', 'Cinnamomum verum', 'Canela-de-Cheiro, Canela-da-Índia', 'Casca interna seca dos ramos de uma árvore perene nativa do Sri Lanka, consagrada na medicina milenar Ayurveda e na fitoterapia moderna. Contém cinamaldeído e óleos essenciais que lhe conferem potente ação termogênica, antioxidante, hipoglicemiante e antisséptica. Estimula o metabolismo celular, melhora a circulação sanguínea, combate o cansaço crônico e auxilia no controle dos níveis de açúcar no sangue.', 'Altamente contraindicada em altas doses na gestação (risco de estimulação uterina) e para pessoas com úlcera péptica ou hipertensão descontrolada.', '• Decocção Termogênica: Ferva 1 a 2 paus de canela em 250ml de água por 5 a 8 minutos. Desligue, abafe por mais 5 minutos, coe e beba pela manhã ou antes de atividades físicas para obter vigor e foco.', '• Banho de Atração, Prosperidade e Vitalidade Sexual: Ferva 2 litros de água com 3 paus de canela por 5 minutos. Permita amornar e coe. Despeje do pescoço para baixo, mentalizando a atração de prosperidade financeira, o aquecimento do magnetismo pessoal e a ativação de forças criativas e sexuais saudáveis.', '• Defumação de Fogo Interior, Prosperidade e Sucesso: Queime pedaços de casca de canela seca em brasa de carvão. A fumaça intensamente adocicada e quente ativa a energia da abundância material, estimula a mente para ação comercial e atrai boas vendas e clientes.', '/images/herbs/canela.png', 'integrative', 'Tratados de Medicina Ayurveda (Charaka Samhita) & Farmacopeia Europeia', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(38, 'Hipérico', 'hiperico', 'Hypericum perforatum', 'Erva-de-São-João, Hipérico-Verdadeiro', 'Planta de flores amarelas originária da Europa, também conhecida popularmente como Erva-de-São-João. Contém hipericina e hiperforina, compostos que aumentam os níveis de neurotransmissores como serotonina e dopamina nas fendas sinápticas. É amplamente documentada na medicina integrativa como um dos mais potentes tratamentos fitoterapêuticos para a depressão leve a moderada, ansiedade crônica e distúrbios de humor.', 'Interage negativamente com dezenas de medicamentos (anticoncepcionais, antidepressivos, anticoagulantes). Causa fotossensibilidade (evitar exposição ao sol).', '• Infusão Antidepressiva: Adicione 1 colher de chá de flores e folhas secas de hipérico em 1 xícara de água fervente. Deixe abafado por 10 minutos, coe e beba 2 vezes ao dia (consulte sempre interações medicamentosas).', '• Banho de Elevação Espiritual e Cura da Alma: Ferva 1,5 litros de água, desligue o fogo e adicione 3 colheres de sopa de hipérico seco. Abafe por 15 minutos até a infusão adquirir um tom levemente avermelhado. Coe e deixe amornar. Despeje do pescoço para baixo, mentalizando a entrada de luz solar em sua mente, afastando pensamentos tristes e restaurando a alegria vital.', '• Defumação de Proteção Espiritual e Banimento da Tristeza: Queime a erva seca em carvão. Conhecida na antiguidade por espantar demônios da melancolia, sua fumaça dissipa vibrações de profunda tristeza, luto e desespero que assombram lares.', '/images/herbs/hiperico.png', 'integrative', 'Monografias Clínicas da Comissão E da Alemanha (Hyperici herba) & Farmacopeia Britânica', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(39, 'Capuchinha', 'capuchinha', 'Tropaeolum majus', 'Flor-de-Sangue, Chagas, Agrião-do-México', 'Planta alimentícia não convencional (PANC) rasteira, com belas flores ornamentais e folhas circulares de sabor picante. Apresenta alta concentração de vitamina C, flavonoides e glucosinolatos que conferem marcante atividade antibacteriana das vias aéreas e urinárias, expectorante e estimulante da imunidade. É ideal para tratar gripes acompanhadas de secreções pulmonares, infecções urinárias e queda capilar.', 'Contraindicado em pessoas com hipotireoidismo e úlceras estomacais ativas devido ao teor de glicosinolatos que podem irritar a mucosa gástrica.', '• Infusão Fortalecedora: Adicione 1 colher de sopa de folhas e flores frescas de capuchinha em 1 xícara de água fervente. Abafe por 10 minutos, coe e consuma duas vezes ao dia.\n\n• Uso Culinário: Consuma as folhas e flores frescas diretamente em saladas para obter altos teores de antioxidantes ativos.', '• Banho de Fortalecimento Físico e Revitalização Áurica: Ferva 1,5 litros de água. Ao desligar, adicione 1 xícara de folhas e flores frescas de capuchinha amassadas. Abafe por 10 minutos e coe. Despeje morno do pescoço para baixo após o banho higiênico, mentalizando o fortalecimento de sua saúde física e a elevação de suas defesas energéticas.', '• Defumação de Purificação de Ambientes para Convalescença: Queime flores e folhas desidratadas picadas sobre brasas. A fumaça suave purifica o ar físico de bactérias e renova a energia mental de cômodos onde pessoas estiveram doentes de cama.', '/images/herbs/capuchinha.png', 'integrative', 'Formulário de Fitoterapia Geral e PANC de Universidades Federais & Tradição Ervanária Europeia', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(40, 'Artemísia', 'artemisia', 'Artemisia vulgaris', 'Losna-Brava, Erva-de-São-João-Feminina', 'Planta perene robusta de aroma forte e folhas recortadas com a parte inferior acinzentada, historicamente associada à deusa grega Ártemis. Contém flavonoides, cumarinas e óleos essenciais que atuam como excelentes reguladores hormonais femininos, emenagogos e tônicos digestivos. É amplamente indicada na medicina integrativa para tratar ciclos menstruais irregulares, cólicas severas e estomacais.', 'Contraindicado durante a gestação (abortivo e emenagogo) e lactação. Pode provocar reações alérgicas em pessoas sensíveis a compostos terpênicos.', '• Chá Regulador Feminino: Coloque 1 colher de chá de folhas secas de artemísia em 1 xícara de água fervendo. Abafe por 10 minutos, coe e consuma até 2 vezes ao dia (evitar durante a gravidez por sua ação estimulante uterina).', '• Banho de Resgate do Sagrado Feminino e Intuição: Ferva 1,5 litros de água, desligue e adicione 3 colheres de sopa de artemísia seca. Deixe abafado por 10 minutos, coe e tempere com água morna. Despeje lentamente do pescoço para baixo, mentalizando a conexão com a sabedoria dos ciclos naturais, o equilíbrio ginecológico e o despertar da intuição profunda.', '• Defumação de Limpeza Psíquica e Conexão Espiritual: Queime as folhas secas em carvão em brasa. A fumaça densa e mística abre as faculdades psíquicas de percepção, purifica o ambiente de bloqueios energéticos antigos e facilita meditações profundas.', '/images/herbs/artemisia.png', 'integrative', 'Farmacopeia Alemã (Commission E) & Tratados de Ginecologia Natural e Saberes Ancestrais', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(41, 'Arruda', 'arruda', 'Ruta graveolens', 'Arruda-Fêmea, Arruda-dos-Jardins, Ruta-Forte', 'Arbusto de folhas verde-acinzentadas e odor extremamente pungente e característico, amplamente utilizado nas culturas tradicionais do Brasil e do Mediterrâneo. Contém rutina (flavonoide que fortalece os vasos sanguíneos), alcaloides e óleos essenciais com forte ação antiespasmódica, anti-inflamatória e estimulante da circulação. Na medicina integrativa, seu uso terapêutico externo exige cautela.', 'Altamente contraindicada para gestantes (fortemente abortiva e tóxica). O contato da planta fresca com a pele sob o sol pode causar fitofotodermatite grave.', '• Uso Externo Tópico: Prepare uma infusão suave com 1 colher de café de folhas secas de arruda em 1 xícara de água fervente. Espere esfriar, coe e utilize em compressas sobre varizes ou pernas cansadas por 15 minutos (não ingerir sem supervisão médica).', '• Banho de Descarrego Forte e Proteção Espiritual: Ferva 2 litros de água. Ao desligar o fogo, adicione 1 ramo fresco de arruda (macerado com as mãos). Abafe por 15 minutos e coe. Despeje estritamente do pescoço para baixo após o banho normal, mentalizando a limpeza completa de cargas negativas adquiridas, banimento de invejas e blindagem de seu campo áurico.', '• Defumação de Banimento Absoluto de Energias Negativas: Queime folhas secas de arruda em carvão vegetal. A fumaça penetrante e resinosa da arruda é considerada uma das mais fortes ferramentas para desintegrar feitiços mentais, invejas acumuladas, larvas astrais e afastar presenças espirituais perturbadoras do lar.', '/images/herbs/arruda.png', 'integrative', 'Farmacopeia Homeopática Brasileira & Tradição Popular Afro-Brasileira e Ibérica de Limpeza Energética', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(42, 'Guiné', 'guine', 'Petiveria alliacea', 'Erva-de-Guiné, Tipi, Amansa-Senhor', 'Planta herbácea nativa da floresta amazônica e das regiões tropicais das Américas, com um odor forte característico que lembra o alho. Contém compostos sulfurados, flavonoides e alcaloides que exibem marcante atividade imunomoduladora, anti-inflamatória e analgésica expressiva. É tradicionalmente consagrada como uma das ervas de proteção espiritual mais poderosas.', 'Tóxica se consumida em grandes volumes ou por tempo prolongado. Totalmente proibida na gestação. O uso espiritual deve evitar o consumo do chá.', '• Uso Tópico Analgésico: Faça uma infusão com 1 colher de chá de folhas secas de guiné em 250ml de água fervendo. Deixe amornar, coe, molhe uma gaze limpa e aplique topicamente sobre articulações doloridas para alívio da dor do reumatismo (uso estritamente externo).', '• Banho de Descarrego Pesado e Quebra de Demandas: Ferva 1,5 litros de água, desligue e adicione 3 folhas frescas de guiné amassadas. Deixe abafado até amornar e coe. Despeje obrigatoriamente do pescoço para baixo, mentalizando a quebra de amarras energéticas, corte de inveja, ciúme crônico e remoção de vibrações adversas.', '• Defumação de Defesa Psíquica e Limpeza de Cantos Estagnados: Queime folhas secas de guiné sobre carvão em brasa. A fumaça forte e picante atua esterilizando o ambiente de energias maléficas, pensamentos hostis dirigidos e desfazendo nós de inércia acumulados.', '/images/herbs/guine.png', 'integrative', 'Estudos Etnofarmacológicos de Plantas de Proteção & Sabedoria Oral dos Ervanários do Mercado Ver-o-Peso', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(43, 'Manjericão', 'manjericao', 'Ocimum basilicum', 'Alfavaca-Doce, Basílico, Manjericão-de-Folha-Larga', 'Planta aromática cultivada mundialmente, de flores delicadas e folhas perfumadas ricas em linalol, eugenol e geraniol. Possui ação antiespasmódica, digestiva, anti-inflamatória e relaxante muscular suave do sistema digestório. Além de ser um tempero culinário fantástico, atua de forma excelente para reduzir o estresse mental e a fadiga intelectual.', 'Evitar o uso terapêutico (óleo essencial concentrado) em gestantes, lactantes e crianças. O uso culinário do chá leve é seguro.', '• Chá Estimulante e Digestivo: Coloque 1 colher de sopa de folhas frescas de manjericão em 1 xícara de água fervente. Deixe abafado por 10 minutos, coe e beba quente após as refeições ou em momentos de exaustão mental.', '• Banho de Equilíbrio, Harmonia e Prosperidade: Ferva 1,5 litros de água. Ao apagar o fogo, junte 1 xícara de folhas frescas de manjericão maceradas. Deixe abafado por 10 minutos, coe e tempere com água morna. Despeje do pescoço para baixo após o seu banho de higiene normal, mentalizando harmonia mental, amor universal, prosperidade e paz interior.', '• Defumação de Harmonia Familiar e Purificação Afetiva: Queime folhas secas de manjericão. A fumaça exala um perfume doce e herbal que dissipa imediatamente energias de irritação coletiva, impaciência e agressividade verbal, preenchendo o lar com vibrações de paz.', '/images/herbs/manjericao.png', 'integrative', 'Farmacopeia Brasileira (Ed. 6) & Tratados de Fitoenergética e Fitoaromaterapia', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(44, 'Hortelã-Gorda', 'hortela-gorda', 'Plectranthus amboinicus', 'Malva-do-Reino, Hortelã-Pimenta-Grande, Hortelã-da-Bahia, Orelha-de-Monge', 'Planta suculenta de folhas aveludadas, grossas e intensamente aromáticas, também conhecida como Malvariço ou Hortelã-da-Bahia. Contém timol e carvacrol em abundância, conferindo-lhe uma espetacular atividade expectorante, broncodilatadora, antisséptica pulmonar e anti-inflamatória das mucosas bucais. É amplamente empregada no tratamento de tosses agudas, gargantas inflamadas e bronquites.', 'Evitar o uso em pessoas com gastrite crônica severa ou refluxo gastroesofágico sem orientação profissional.', '• Chá Expectorante e Anti-inflamatório: Adicione 1 folha fresca média de hortelã-gorda (previamente higienizada e picada) em 1 xícara de água fervente. Abafe por 10 minutos, coe e beba quente com mel.\n\n• Gargarejo de Garganta: Use o chá sem açúcar morno para gargarejos em casos de amigdalite.', '• Banho de Renovação Física e Desobstrução Pulmonar: Ferva 2 litros de água. Apague o fogo e adicione 5 folhas frescas amassadas de hortelã-gorda. Abafe por 10 minutos, coe e deixe amornar. Despeje lentamente sobre o corpo enquanto inala os vapores aromáticos mentolados, mentalizando a recuperação de sua energia vital física.', '• Defumação de Limpeza de Vias Aéreas e Purificação de Miasmas: Queime folhas secas picadas sobre carvão. A fumaça resinosa e balsâmica quebra o acúmulo de energias estagnadas deixadas por doenças respiratórias físicas, purificando e desinfetando o ar.', '/images/herbs/hortela-gorda.png', 'integrative', 'Formulário de Fitoterapia do SUS (Atenção Primária à Saúde) & Estudos de Eficácia do Timol na Saúde de Vias Aéreas', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(45, 'Assa-Peixe', 'assa-peixe', 'Vernonia polysphaera', 'Assa-Peixe-Branco, Vernônia', 'Arbusto rústico nativo dos campos e pastagens do Brasil, de folhas ásperas e inflorescências esbranquiçadas. Contém flavonoides, sesquiterpenos e taninos com potente ação diurética, anti-inflamatória e béquica (antitussígena e expectorante). É amplamente utilizado na fitoterapia integrativa para acalmar tosses agudas, gripes severas, asma e dor de garganta.', 'Não utilizar em crianças menores de 2 anos e mulheres grávidas sem supervisão médica. Evitar o uso prolongado.', '• Infusão Respiratória e Diurética: Coloque 1 colher de sopa de folhas picadas de assa-peixe em 1 xícara de água fervente. Deixe abafado por 10 minutos, coe e consuma até 3 vezes ao dia morno.', '• Banho de Abertura Energética e Desinflamação Muscular: Ferva 2 litros de água com 3 colheres de sopa de folhas de assa-peixe secas por 5 minutos. Permita amornar até atingir temperatura de conforto e coe. Despeje lentamente do pescoço para baixo, mentalizando a liberação de catarro emocional e cansaço físico.', '• Defumação de Limpeza de Campo Áurico e Purificação do Ar: Queime folhas secas no carvão vegetal. A fumaça suave e terrosa dissolve bloqueios energéticos que geram sensação de aperto no peito e desânimo físico nos moradores, clareando a atmosfera áurica.', '/images/herbs/assa-peixe.png', 'integrative', 'Farmacopeia Brasileira (Ed. 5) & Formulário Fitoterápico de Fitoterapia de Minas Gerais', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(46, 'Barbatimão', 'barbatimao', 'Stryphnodendron adstringens', 'Casca-da-Mocidade, Barbatimão-Verdadeiro', 'Árvore retorcida do cerrado brasileiro cujas cascas contêm altíssima concentração de taninos condensados. É reconhecido cientificamente como um dos cicatrizantes, anti-inflamatórios, adstringentes e antissépticos naturais mais potentes do planeta. É amplamente utilizado no tratamento de feridas, úlceras de pele e inflamações ginecológicas (uso externo).', 'Uso oral deve ser extremamente cauteloso (pode causar constipação severa e irritação). Contraindicado em gestantes (abortivo).', '• Compressa Cicatrizante Externa: Ferva 1 colher de sobremesa de casca de barbatimão em 250ml de água por 10 minutos. Deixe esfriar completamente, coe e use um pano limpo para aplicar compressas sobre a pele limpa.\n\n• Banho de Assento: Dilua a decocção morna em bacia limpa para tratar inflamações íntimas.', '• Banho de Proteção da Pele e Limpeza de Cargas Sexuais Negativas: Ferva 2 colheres de sopa de casca de barbatimão em 1,5 litros de água por 15 minutos. Coe e deixe amornar. Faça um banho de assento morno ou despeje estritamente do pescoço para baixo, mentalizando a limpeza profunda de memórias sexuais negativas e blindagem da pele.', '• Defumação de Selamento Áurico e Proteção Física: Queime lascas secas de casca sobre brasa. A fumaça densa e amadeirada sela o ambiente doméstico contra drenagem de energia física e vitalidade dos moradores, desativando miasmas negativos.', '/images/herbs/barbatimao.png', 'integrative', 'Memento Fitoterápico da ANVISA & Estudos Farmacológicos de Cicatrização da Casca de Barbatimão (USP)', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(47, 'Confrei', 'confrei', 'Symphytum officinale', 'Consolda, Orelha-de-Asno, Confrei-Gigante', 'Planta de folhas grandes, ásperas e aveludadas, cujas raízes e folhas são ricas em alantoína, taninos e mucilagens. Apresenta espetacular capacidade de regeneração tecidual, aceleração da consolidação de fraturas ósseas, cicatrização de feridas e alívio de tendinites (uso exclusivamente externo devido a alcaloides pirrolizidínicos tóxicos).', 'Totalmente proibido para uso interno (oral) devido a alcaloides pirrolizidínicos hepatotóxicos e cancerígenos. Usar apenas externamente na pele íntegra.', '• Cataplasma Regenerador de Contusões: Amasse folhas frescas de confrei até obter uma pasta úmida. Aplique sobre a área com entorses, fraturas ou dores musculares (não use em feridas abertas) cobrindo com gaze por 20 minutos (estritamente externo).', '• Banho de Recuperação Óssea e Articular: Ferva 2 litros de água com 3 colheres de sopa de folhas secas de confrei por 5 minutos. Coe e deixe amornar. Despeje lentamente sobre as pernas e articulações doloridas após o banho normal, mentalizando a reestruturação e regeneração de seus tecidos.', '• Defumação de Reestruturação e Proteção contra Traumas: Queime folhas secas no carvão. A fumaça terrosa atua no campo vibratório do ambiente dissipando memórias de traumas físicos causados por quedas ou acidentes, restabelecendo a harmonia sutil.', '/images/herbs/confrei.png', 'integrative', 'British Herbal Pharmacopoeia & Monografia da Comissão E de Fitoterapia Externa da Alemanha', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(48, 'Mentrasto', 'mentrasto', 'Ageratum conyzoides', 'Erva-de-São-João-Popular, Catinga-de-Bode', 'Erva anual de aroma forte e pequenas flores azul-arroxeadas, nativa das Américas e muito comum em pastos. Rica em flavonoides e alcaloides pirrolizidínicos, destaca-se por sua notável atividade anti-inflamatória e analgésica nas articulações. É amplamente recomendada no tratamento complementar de artrose, reumatismo e cólicas menstruais.', 'Evitar o uso oral por mais de 5 dias seguidos ou em doses altas devido à presença de alcaloides que podem sobrecarregar o fígado.', '• Infusão Antirreumática e Analgésica: Coloque 1 colher de chá de folhas e flores secas de mentrasto em 1 xícara de água fervente. Abafe por 10 minutos, coe e consuma até 2 vezes ao dia (uso por tempo limitado de até 2 semanas).', '• Banho para Alívio de Dores Crônicas e Rigidez Articular: Ferva 1,5 litros de água. Ao desligar, junte 3 colheres de sopa de mentrasto seco. Abafe por 10 minutos, coe e deixe amornar. Despeje lentamente sobre as regiões do corpo com dores articulares e musculares, mentalizando a dissolução da rigidez física.', '• Defumação de Flexibilidade Mental e Dissolução de Inércia: Queime a erva seca em carvão vegetal. A fumaça herbal limpa o ambiente doméstico de energias rígidas de teimosia, intransigência e orgulho excessivo, promovendo o entendimento mútuo.', '/images/herbs/mentrasto.png', 'integrative', 'Farmacopeia Brasileira (Ed. 5) & Pesquisas Clínicas em Antirreumáticos Naturais', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(49, 'Sene', 'sene', 'Senna alexandrina', 'Sena, Cássia', 'Pequeno arbusto originário do Nordeste da África e do Oriente Médio, mundialmente conhecido por seus folíolos finos e secos. Contém senosídeos A e B, glicosídeos antraquinônicos que estimulam a motilidade do intestino grosso e reduzem a absorção de água. Apresenta potente ação laxante de curto prazo recomendada para constipações intestinais agudas.', 'Contraindicado em caso de dor abdominal de causa desconhecida, obstrução intestinal, colite ulcerosa, Doença de Crohn, gestação e lactação.', '• Infusão Laxante Rápida: Adicione 1 colher de chá de folíolos secos de sene em 1 xícara de água fervente. Deixe abafado por 10 minutos, coe e beba à noite antes de deitar (não utilizar por mais de 7 dias consecutivos).', '• Banho de Desapego e Eliminação de Estagnações Emocionais: Ferva 1,5 litros de água, desligue e adicione 2 colheres de sopa de folhas de sene. Abafe por 10 minutos e coe. Despeje do pescoço para baixo, mentalizando a eliminação total de bloqueios mentais e o desapego de mágoas passadas.', '• Defumação de Libertação e Renovação de Ciclos: Queime folhas secas de sene em brasas. A fumaça atua desfazendo a estagnação mental e apegos doentios a situações passadas na residência, renovando o fluxo da vida.', '/images/herbs/sene.png', 'integrative', 'Farmacopeia dos Estados Unidos (USP) & Monografia da OMS sobre Folium Sennae', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(50, 'Centelha Asiática', 'centelha-asiatica', 'Centella asiatica', 'Gotu-Kola, Centela', 'Planta herbácea rasteira nativa das regiões tropicais úmidas da Ásia, de folhas em forma de rim amplamente consagrada na medicina ayurvédica. Seus triterpenos (como o asiaticosídeo) estimulam a síntese de colágeno nos tecidos vasculares e na pele, melhorando a circulação de retorno. É amplamente indicada para o tratamento de varizes, cicatrização de feridas e melhoria da capacidade cognitiva.', 'Evitar o uso concomitante com sedativos e hipnóticos. Contraindicado para gestantes e pessoas com doenças hepáticas ativas.', '• Infusão Circulatória e Pele: Adicione 1 colher de sobremesa de folhas secas de centelha asiática em 1 xícara de água fervente. Abafe por 10 minutos, coe e consuma até 2 vezes ao dia entre as refeições.', '• Banho de Drenagem, Regeneração e Conexão de Mente-Corpo: Ferva 1,5 litros de água, desligue e adicione 3 colheres de sopa de centelha asiática seca. Abafe por 10 minutos e coe. Despeje do pescoço para baixo morno, mentalizando a ativação da circulação e a regeneração celular.', '• Defumação de Longevidade, Foco e Estímulo Mental: Queime folhas desidratadas de centelha asiática em brasa. A fumaça sutil melhora a atmosfera mental do ambiente, facilitando estudos complexos e trabalhos de pesquisa intelectual.', '/images/herbs/centelha-asiatica.png', 'integrative', 'United States Pharmacopeia & Estudos Clínicos Vasculares da Centella asiatica (Commission E)', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(51, 'Garra-do-Diabo', 'garra-do-diabo', 'Harpagophytum procumbens', 'Harpago, Garra', 'Planta herbácea rasteira originária do deserto do Kalahari na África Austral, cujo fruto possui espinhos em forma de ganchos afiados. Suas raízes tuberosas contêm harpagosídeo, um iridoide com potente e cientificamente comprovada ação anti-inflamatória e analgésica. É o principal tratamento fitoterapêutico alternativo e seguro para artroses dolorosas e artrites.', 'Contraindicado em pessoas com úlcera gástrica ou duodenal e cálculos biliares ativos. Gestantes devem evitar o uso.', '• Decocção Analgésica de Raízes: Ferva 1 colher de chá de raízes secas trituradas de garra-do-diabo em 1 xícara de água por 5 a 8 minutos. Abafe por mais 10 minutos, coe e consuma de 2 a 3 vezes ao dia.', '• Banho de Alívio das Dores Crônicas e Vitalidade Física: Prepare uma decocção fervendo 3 colheres de sopa de raiz de garra-do-diabo em 2 litros de água por 10 minutos. Coe e tempere com água morna. Despeje sobre as costas e articulações doloridas, mentalizando a dissolução total da dor.', '• Defumação de Quebra de Feitiços Mentais e Barreiras Rígidas: Queime pedaços secos de raiz no carvão em brasa. A fumaça exala um odor amadeirado forte que desintegra pensamentos de autossabotagem e crenças limitantes direcionadas ao lar.', '/images/herbs/garra-do-diabo.png', 'integrative', 'Monografia da OMS sobre Radix Harpagophyti & Memento Fitoterápico da ANVISA', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(52, 'Ginseng Brasileiro', 'ginseng-brasileiro', 'Pfaffia paniculata', 'Pfaffia, Corandi, Caroba', 'Planta medicinal nativa das florestas brasileiras, cujas raízes tuberosas são ricas em fitoesteroides adaptógenos e saponinas. Aumenta a resistência inespecífica do organismo ao estresse físico e mental crônico, combatendo a fadiga profunda e fortalecendo a imunidade. Estimula a vitalidade geral, melhora a memória, o foco e exibe leve ação revigorante.', 'Evitar o uso por pessoas hipertensas sem monitoramento regular e pacientes com câncer estrogênio-dependente.', '• Decocção Adaptógena das Raízes: Ferva 1 colher de sobremesa de raízes trituradas de pfaffia em 250ml de água por 5 a 10 minutos. Deixe abafado por mais 5 minutos, coe e consuma preferencialmente pela manhã.', '• Banho de Superenergia e Vigor Vital: Ferva 1,5 litros de água com 2 colheres de sopa de raiz de pfaffia por 7 minutos. Coe e deixe amornar. Despeje a partir do pescoço, de manhã, mentalizando o despertar de toda a sua resiliência física e mental.', '• Defumação de Revigoramento Energético e Coragem: Queime pequenos pedaços de raiz seca de pfaffia em brasas. A fumaça terrosa e tonificante eleva a vibração do ambiente, afastando a inércia, apatia coletiva e preguiça mental.', '/images/herbs/ginseng-brasileiro.png', 'integrative', 'Farmacopeia Brasileira & Pesquisas Clínicas em Adaptógenos (Instituto de Biociências da USP)', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(53, 'Catinga-de-Mulata', 'catinga-de-mulata', 'Tanacetum vulgare', 'Tanaceto, Erva-de-São-Marcos, Botão-de-Sol', 'Planta herbácea aromática de folhas recortadas e inflorescências amarelas em forma de pequenos botões agrupados, da família das Asteráceas. Rica em tujona, flavonoides e lactonas, destaca-se por sua potente ação analgésica local, antiespasmódica urinária e anti-inflamatória. É tradicionalmente empregada no alívio de cólicas menstruais severas e reumatismos.', 'Altamente contraindicado na gestação (abortivo) e por pessoas alérgicas a plantas da família Asteraceae. O óleo essencial é tóxico.', '• Uso Externo Tópico (Compressas): Coloque 1 colher de sopa de folhas secas de catinga-de-mulata em 1 xícara de água fervente. Deixe esfriar, coe, molhe um pano e aplique sobre articulações doloridas por 15 minutos (evitar ingestão).', '• Banho de Purificação Uterina e Equilíbrio Menstrual: Prepare uma infusão fervendo 1,5 litros de água e adicionando 2 colheres de sopa de folhas e flores secas. Abafe por 10 minutos e coe. Deixe amornar. Faça um banho de assento morno ou despeje do pescoço para baixo, mentalizando a limpeza dos ciclos.', '• Defumação de Afastamento de Invejas e Proteção Ativa: Queime as folhas e flores desidratadas sobre brasa. A fumaça de aroma picante e forte limpa miasmas negativos, desfaz olho-gordo crônico e afasta correntes de inveja.', '/images/herbs/catinga-de-mulata.png', 'integrative', 'Farmacopeia Francesa & Manual de Fitoterapia de Plantas Tradicionais da Região Sul do Brasil', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(54, 'Tanchagem', 'tanchagem', 'Plantago major', 'Transagem, Tanchagem-Maior, Sete-Nervos', 'Planta herbácea perene de folhas verdes dispostas em roseta que cresce espontaneamente em terrenos úmidos. Contém taninos, mucilagens, flavonoides e iridoides com extraordinária atividade anti-inflamatória, cicatrizante, antibacteriana e expectorante. É ideal para tratar gargantas inflamadas, aftas, gripes com catarro e feridas na pele.', 'Geralmente segura, mas pode causar constipação intestinal em doses extremamente elevadas. Evitar o uso por pessoas com obstrução intestinal.', '• Gargarejo de Garganta e Aftas: Coloque 1 colher de sopa de folhas de tanchagem secas ou frescas em 1 xícara de água fervente. Deixe abafado por 10 minutos, coe e faça gargarejos morno 3 vezes ao dia.\n\n• Infusão Digestiva: Beba 1 xícara do chá morno 2 a 3 vezes ao dia.', '• Banho de Cicatrização e Limpeza Emocional de Feridas do Passado: Ferva 1,5 litros de água, desligue o fogo e acrescente 3 colheres de sopa de folhas secas de tanchagem. Abafe por 10 minutos e coe. Despeje lentamente a partir do pescoço, mentalizando a cicatrização de suas dores emocionais.', '• Defumação de Limpeza de Conflitos e Harmonização: Queime folhas de tanchagem secas. A fumaça sutil purifica a atmosfera doméstica de vibrações de ressentimento deixadas após discussões ou atritos, restabelecendo a vibração de paz.', '/images/herbs/tanchagem.png', 'integrative', 'Farmacopeia Europeia & Formulário Fitoterápico do SUS (Atenção Básica à Saúde)', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(55, 'Malva', 'malva', 'Malva sylvestris', 'Malva-Silvestre, Malva-Comum', 'Planta herbácea de belas flores lilases cujas folhas e flores contêm altíssima concentração de mucilagens protetoras das mucosas. Apresenta notável ação anti-inflamatória local, emoliente, suavizante, expectorante e calmante da pele e garganta. É muito empregada contra tosses secas irritativas, bronquites e irritações de pele.', 'Sem contraindicações significativas relatadas em doses recomendadas. Pode reduzir a absorção de outros medicamentos se tomada exatamente no mesmo horário.', '• Infusão de Tosse Seca e Mucosas: Use 1 colher de sobremesa de folhas e flores secas de malva para 1 xícara de água fervente. Deixe abafado por 10 minutos para liberar as mucilagens protetoras, coe e beba morno com mel.\n\n• Compressa Tópica Dermatológica: Aplique panos umedecidos no chá frio sobre peles secas e irritadas.', '• Banho de Acolhimento, Suavidade e Proteção da Pele: Ferva 1,5 litros de água, desligue o fogo e junte 4 colheres de sopa de flores e folhas de malva. Cubra por 10 minutos e coe. Despeje do pescoço para baixo, mentalizando a suavização das tensões cotidianas e blindagem da pele.', '• Defumação de Doçura e Cura de Relações: Queime as flores de malva secas. A fumaça leve exala uma vibração que dissipa tensões afetivas, promovendo a suavização de tratamento, a paciência e a concórdia amorosa entre os moradores.', '/images/herbs/malva.png', 'integrative', 'British Herbal Pharmacopoeia & Mapeamento de Fitoterapia do SUS', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(56, 'Cáscara-Sagrada', 'cascara-sagrada', 'Rhamnus purshiana', 'Cáscara, Rhamnus', 'Nativa da América do Norte, a Cáscara-Sagrada é amplamente reconhecida por suas propriedades laxativas potentes, atribuídas aos cascarosídeos presentes em sua casca envelhecida. Esta planta atua estimulando o peristaltismo do cólon e aumentando a secreção de água no intestino, facilitando a evacuação de forma eficaz. Além do uso digestivo, é tradicionalmente valorizada por auxiliar na desintoxicação do organismo.', 'Contraindicado em gestantes (pode induzir o parto), lactantes (passa no leite), crianças menores de 12 anos e pessoas com desidratação ou cólicas.', '• Decocção Intestinal: Adicione 1 colher de chá de cascas secas de cáscara-sagrada em 1 xícara (200ml) de água e ferva por 5 a 10 minutos. Coe e beba morno antes de deitar, para que o efeito ocorra pela manhã.', '• Banho de Desbloqueio e Fluidez: Ferva 1 litro de água com 2 colheres de sopa de cascas de cáscara-sagrada por 5 minutos. Abafe por 10 minutos, coe e deixe atingir a temperatura corporal. Após o banho habitual, despeje lentamente dos ombros para baixo, concentrando-se na liberação de traumas antigos, mágoas e sentimentos estagnados. Mentalize a energia da vida fluindo livremente através de você.', '• Defumação de Libertação e Banimento: Queime cascas secas de cáscara-sagrada trituradas em brasa de carvão vegetal. A fumaça densa e amadeirada é ideal para quebrar padrões mentais limitantes, afastar pensamentos obsessivos de escassez e purificar o ambiente de energias que bloqueiam novos começos.', '/images/herbs/cascara-sagrada.png', 'integrative', 'Farmacopeia Brasileira (Ed. 6) & Monografia Fitoterápica da Organização Mundial da Saúde (OMS)', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(57, 'Alfazema', 'alfazema', 'Lavandula latifolia', 'Lavanda-Latifólia, Alfazema-Inglesa', 'A Alfazema, parente próxima da lavanda tradicional, destaca-se por seu aroma canforado mais pronunciado e propriedades terapêuticas revigorantes. É extremamente eficaz para aliviar tensões musculares, dores de cabeça tensionais e problemas respiratórios leves devido às suas propriedades antissépticas e expectorantes. Também atua no reequilíbrio energético, promovendo relaxamento sem induzir ao sono profundo imediato.', 'Evitar o uso oral do óleo essencial por gestantes, lactantes e pessoas sensíveis aos compostos aromáticos da planta.', '• Infusão Calmante e Expectorante: Coloque 1 colher de sobremesa de flores secas de alfazema em 1 xícara de água fervente. Abafe por 8 minutos, coe e consuma para aliviar tosses ou agitação mental.\n\n• Inalação Aromática: Pingue 3 gotas de óleo essencial de alfazema em um lenço e aspire profundamente para clarear as vias aéreas e aliviar enxaquecas.', '• Banho de Equilíbrio Áurico: Ferva 1,5 litros de água. Ao desligar o fogo, adicione 3 colheres de sopa de flores de alfazema e abafe por 10 minutos. Coe e misture com água fria até atingir uma temperatura morna agradável. Derrame do pescoço para baixo após o banho higiênico, mentalizando a purificação de sua aura e o restabelecimento da harmonia e da paz interior.', '• Defumação de Paz e Elevação Vibracional: Acenda flores e ramos secos de alfazema sobre brasa. A fumaça perfumada desintegra energias densas, afasta a desarmonia familiar e eleva o padrão energético do ambiente, propiciando um clima de serenidade ideal para a prece ou meditação.', '/images/herbs/alfazema.png', 'integrative', 'Formulário de Fitoterapêuticos da Farmacopeia Brasileira & Práticas Integrativas de Aromaterapia Clínica', '2026-05-28 03:56:12', '2026-05-28 03:56:12');
INSERT INTO `herbs` (`id`, `name`, `slug`, `scientific_name`, `aliases`, `description`, `contraindications`, `how_to_use`, `bath_instructions`, `incense_usage`, `image_path`, `source_type`, `sources`, `created_at`, `updated_at`) VALUES
(58, 'Maracujá-azedo', 'maracuja-zedo', 'Passiflora edulis', 'Maracujá, Passiflora-Comum', 'As folhas do Maracujá-azedo contêm flavonoides e alcaloides que atuam diretamente no sistema nervoso central, promovendo um relaxamento profundo e restaurador. É um dos fitoterápicos mais consolidados para o controle da ansiedade crônica, insônia e palpitações de origem nervosa. Suas propriedades antiespasmódicas também ajudam a aliviar tensões musculares e cólicas de fundo emocional.', 'Pode potencializar o efeito de tranquilizantes químicos. Evitar o uso por pessoas com pressão arterial muito baixa.', '• Infusão Calmante Intensa: Use 1 colher de sopa de folhas secas de maracujá para 1 xícara de água fervente. Abafe por 10 minutos, coe e consuma preferencialmente à noite, antes de deitar.', '• Banho de Acalento e Sono Profundo: Prepare uma infusão concentrada fervendo 2 litros de água com 4 colheres de sopa de folhas de maracujá seco por 3 minutos. Abafe por 10 minutos, coe e deixe amornar. Tome o seu banho comum e, em seguida, jogue o banho de maracujá lentamente do pescoço para baixo, visualizando uma luz azul-celeste envolvendo seu corpo, desfazendo preocupações e induzindo a mente ao repouso.', '• Defumação de Acalento e Sossego: Queime as folhas secas trituradas de maracujá em brasa. A fumaça suave ajuda a dissipar o estresse acumulado no ambiente, acalmar mentes hiperativas e preparar a atmosfera para um sono tranquilo e livre de pesadelos.', '/images/herbs/maracuja-zedo.png', 'integrative', 'Formulário Fitoterápico Nacional do SUS & Monografias de Plantas Medicinais da ESCOP', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(59, 'Poejo-do-campo', 'poejo-do-campo', 'Cunila spicata', 'Poejo-Silvestre, Cunila', 'O Poejo-do-campo é uma planta medicinal nativa do cerrado e campos brasileiros, muito reconhecida por suas propriedades antissépticas, digestivas e sudoríficas. É amplamente empregado no combate a febres, gripes e resfriados, auxiliando na eliminação de toxinas através do suor. No sistema digestivo, é um excelente aliado contra espasmos intestinais e flatulência.', 'Evitar o uso na gestação devido à estimulação uterina leve e em crianças menores de 3 anos.', '• Chá Sudorífico e Digestivo: Ferva 1 colher de chá de folhas e flores de poejo-do-campo em 1 xícara de água por 3 minutos. Abafe por 5 minutos, coe e tome quente quando sentir os primeiros sintomas de resfriado.', '• Banho de Limpeza Térmica e Revigoramento: Ferva 1,5 litros de água. Desligue o fogo e adicione 3 colheres de sopa de poejo-do-campo seco. Deixe abafado até amornar. Coe e despeje do pescoço para baixo após o banho habitual, mentalizando a eliminação de toxinas e energias estagnadas.', '• Defumação de Purificação Campestre: Queime ramos secos de poejo-do-campo. A fumaça silvestre e purificadora limpa o ar de energias pesadas deixadas por discussões, restaurando a energia vital e a clareza do ambiente.', '/images/herbs/poejo-do-campo.png', 'integrative', 'Phytoterapia nos Manuais Tradicionais Brasileiros & Estudos Fitoterápicos da Flora Nativa do Sul', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(60, 'Ginkgo-Biloba', 'ginkgo-biloba', 'Ginkgo biloba', 'Ginkgo, Árvore-dos-Quarenta-Escudos', 'Considerado um fóssil vivo, o Ginkgo-Biloba é um dos melhores vasodilatadores periféricos e cerebrais conhecidos. Seus flavonoides e terpenoides melhoram a microcirculação sanguínea, otimizando o fluxo de oxigênio no cérebro, o que potencializa a memória, a concentração e combate a labirintite e zumbidos no ouvido. Também atua como um poderoso antioxidante, retardando o envelhecimento celular precoce.', 'Altamente contraindicado para quem usa anticoagulantes (aumenta o risco de hemorragias). Suspender o uso 10 dias antes de qualquer cirurgia.', '• Infusão Concentrada de Foco: Coloque 1 colher de chá de folhas secas picadas de ginkgo-biloba em 1 xícara de água fervendo. Abafe por 10 minutos, coe e tome morno pela manhã, durante o café da manhã.', '• Banho de Clareza e Ativação Mental: Ferva 1,5 litros de água. Desligue e junte 2 colheres de sopa de ginkgo-biloba seco. Deixe abafado por 10 minutos, coe e espere amornar. Derrame lentamente do pescoço para baixo, mentalizando a ativação dos seus centros cognitivos, clareza nas decisões e superação de névoas mentais.', '• Defumação de Foco e Conectividade Ancestral: Queime folhas secas de ginkgo-biloba em brasa. A fumaça sutil e levemente herbácea limpa o campo mental coletivo do ambiente, estimulando a troca de ideias claras e resgatando a sabedoria acumulada dos tempos.', '/images/herbs/ginkgo-biloba.png', 'integrative', 'Monografia de Plantas Medicinais da OMS & Estudos de Fitofarmacologia da Comissão E Alemã', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(61, 'Ginseng', 'ginseng', 'Panax ginseng', 'Ginseng-Coreano, Ginseng-Asiático', 'O Ginseng é uma raiz adaptógena lendária, amplamente reverenciada por sua capacidade de aumentar a resistência do corpo ao estresse físico, químico e biológico. Seus princípios ativos, chamados ginsenosídeos, atuam equilibrando o sistema nervoso e endócrino, fornecendo energia sustentável contra a fadiga crônica, estimulando a cognição e fortalecendo o sistema imunológico de forma espetacular. Também melhora o vigor físico e mental geral.', 'Contraindicado em pessoas com hipertensão arterial descontrolada, arritmias cardíacas graves ou distúrbios de ansiedade severos.', '• Decocção Revigorante: Ferva 1 colher de chá de fatias secas de raiz de ginseng em 1 xícara (200ml) de água por 10 a 15 minutos. Coe e beba pela manhã para ter energia duradoura ao longo do dia.', '• Banho de Força e Vitalidade Adaptógena: Ferva 2 litros de água com 2 colheres de sopa de raiz de ginseng triturada por 10 minutos. Espere amornar, coe e jogue sobre o corpo morno após o banho normal. Mentalize a recuperação de suas defesas naturais, vigor inabalável, resiliência e poder pessoal absoluto.', '• Defumação de Proteção Física e Fogo Interno: Queime pequenos pedaços de raiz seca de ginseng em brasa de carvão. A fumaça terrosa e forte ativa o fluxo vital do ambiente, banindo a apatia, a fadiga psíquica coletiva e estimulando o espírito de perseverança.', '/images/herbs/ginseng.png', 'integrative', 'Farmacopeia da República Popular da China & Estudos Clínicos sobre Plantas Adaptógenas', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(62, 'Cúrcuma', 'curcuma', 'Curcuma longa', 'Açafrão-da-Terra, Açafrão-da-Índia, Cúrcuma-Comum', 'A Cúrcuma, ou açafrão-da-terra, é um dos anti-inflamatórios e antioxidantes naturais mais potentes do planeta. A curcumina, seu principal composto ativo, combate a inflamação celular crônica, aliviando dores articulares em casos de artrite e artrose, fortalecendo a saúde cardiovascular e auxiliando na proteção do fígado e na digestão. Também atua no fortalecimento do sistema imunológico e na prevenção do envelhecimento precoce.', 'Contraindicado em pessoas com cálculos biliares ativos, obstrução das vias biliares ou úlceras gástricas severas.', '• Decocção Anti-inflamatória: Ferva 1 colher de chá de cúrcuma ralada em 1 xícara de água por 5 minutos. Adicione uma pitada de pimenta-preta (para aumentar a absorção da curcumina em até 2000%) e consuma quente.\n\n• Golden Milk (Leite Dourado): Misture cúrcuma, canela, gengibe e mel em leite morno.', '• Banho de Luz Solar e Regeneração: Ferva 1,5 litros de água e junte 1 colher de sopa de cúrcuma em pó ou ralada fresca. Abafe por 5 minutos e coe em um filtro de pano fino para evitar resíduos na pele. Despeje do pescoço para baixo após o banho, mentalizando a irradiação da luz solar no seu corpo, a dissolução das inflamações e a atração de prosperidade e vitalidade.', '• Defumação de Purificação Áurea e Prosperidade: Queime a raiz de cúrcuma seca em pó ou fatias secas sobre brasa. A fumaça purifica o ambiente de vibrações de escassez, tristeza e depressão, atraindo a frequência da abundância, da saúde plena e do sucesso espiritual.', '/images/herbs/curcuma.png', 'integrative', 'Monografia de Cúrcuma da Comissão E Alemã & Compêndio Científico da Associação Brasileira de Fitoterapia', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(63, 'Maca-Peruana', 'maca-peruana', 'Lepidium meyenii', 'Maca, Ginseng-dos-Andes', 'Nativa dos altos Andes peruanos, a Maca é uma raiz adaptógena reconhecida por seus incríveis benefícios de melhora da energia, do vigor físico e do equilíbrio hormonal. Ela ajuda a modular o sistema endócrino, aliviando os sintomas incômodos da menopausa e TPM, estimulando a libido e combatendo a fadiga crônica. Rica em minerais e fitoesteróis, atua também no aumento do foco e clareza mental.', 'Evitar o uso em pessoas com distúrbios hormonais estrogênio-dependentes (como câncer de mama ou ovário) e disfunções da tireoide.', '• Uso Nutricional Diário: Consuma de 1 a 2 colheres de chá de pó de maca-peruana diluído em sucos, vitaminas, iogurtes ou polvilhado na salada de frutas, de preferência pela manhã para obter energia constante.', '• Banho de Vigor e Fogo Pessoal: Ferva 2 litros de água com 2 colheres de sopa de maca-peruana em pó. Deixe em infusão por 10 minutos, filtre com um pano limpo e aguarde a temperatura ficar agradável. Banhe-se do pescoço para baixo mentalizando o despertar de seu magnetismo pessoal, libido e força motriz vital.', '• Defumação de Vitalidade e Estímulo Físico: Queime pequenas porções de maca seca triturada sobre brasa. A fumaça densa e levemente terrosa afasta o cansaço do ambiente doméstico, revitaliza a energia dos moradores e atrai dinamismo e entusiasmo para o trabalho.', '/images/herbs/maca-peruana.png', 'integrative', 'Estudos Clínicos Andinos sobre Plantas Adaptógenas & Farmacopeia de Alimentos Funcionais Peruanos', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(64, 'Tribulus', 'tribulus', 'Tribulus terrestris', 'Abrolhos, Tribulus-Terrestre', 'O Tribulus é amplamente valorizado por suas propriedades de modulação e equilíbrio hormonal no organismo. Seus compostos ativos, como as saponinas esteroidais, estimulam a vitalidade física, auxiliam no ganho de massa muscular de forma natural, aumentam a libido e combatem a fadiga física crônica. Além disso, apoia a saúde cardiovascular e o bom funcionamento do trato urinário.', 'Evitar o uso em homens com hiperplasia prostática benigna e pessoas com histórico de câncer de próstata.', '• Infusão de Vigor Físico: Adicione 1 colher de chá de frutos secos ou folhas de tribulus em 1 xícara de água fervente. Abafe por 10 minutos, coe e consuma pela manhã ou 30 minutos antes do treino físico.', '• Banho de Empoderamento e Vigor Muscular: Ferva 1,5 litros de água com 2 colheres de sopa de tribulus seco por 5 minutos. Abafe, coe e espere amornar. Derrame sobre o corpo após o banho higiênico, mentalizando o fortalecimento muscular, a determinação e a recarga das energias vitais e hormonais.', '• Defumação de Força de Vontade e Iniciativa: Queime frutos e folhas secas de tribulus em brasa. A fumaça afasta o desânimo crônico, a procrastinação e estimula a força de vontade, a disciplina e a coragem para enfrentar desafios pesados.', '/images/herbs/tribulus.png', 'integrative', 'Compêndio Americano de Suplementos Botânicos & Farmacologia de Plantas Ergogênicas Tradicionais', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(65, 'Douradinha', 'douradinha', 'Waltheria douradinha', 'Douradinha-do-Campo, Valtéria', 'A Douradinha é uma joia da fitoterapia tradicional brasileira, célebre por sua notável ação diurética, depurativa e anti-inflamatória. Ela é frequentemente empregada para tratar afecções urinárias como cistites e infecções nos rins, ajudando a eliminar toxinas e prevenir a retenção de líquidos. Também possui propriedades que auxiliam no alívio de tosses e irritações respiratórias.', 'Evitar o uso por pessoas com hipotensão grave e gestantes, devido ao seu efeito vasodilatador e diurético.', '• Infusão Diurética e Purificadora: Coloque 1 colher de sopa de folhas de douradinha em 1 xícara de água fervendo. Abafe por 10 minutos, coe e consuma ao longo do dia para estimular o bom funcionamento renal.', '• Banho de Purificação Fluida e Descarrego Suave: Ferva 2 litros de água com 3 colheres de sopa de douradinha por 3 minutos. Abafe por 10 minutos, coe e misture com água fria até ficar morno. Jogue do pescoço para baixo mentalizando a eliminação do excesso de peso emocional e a purificação de seus fluidos vitais.', '• Defumação de Fluidez e Limpeza Psíquica: Queime folhas secas de douradinha. A fumaça suave e sutil ajuda a desatar nós energéticos, permitindo que a harmonia espiritual volte a fluir em ambientes carregados de mágoa ou discórdia.', '/images/herbs/douradinha.png', 'integrative', 'Formulário de Fitoterapêuticos da Farmacopeia Brasileira & Manual de Plantas Medicinais do Cerrado', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(66, 'Salsaparrilha', 'salsaparrilha', 'Smilax officinalis', 'Salsa, Japecanga', 'A Salsaparrilha é um potente depurativo do sangue e estimulante metabólico, amplamente utilizada na fitoterapia integrativa por sua ação detoxificante. Seus fitoesteróis e saponinas auxiliam o fígado e os rins na excreção de toxinas acumuladas, sendo excelente para tratar inflamações da pele como psoríase, eczemas e acne. Também auxilia na melhora da circulação e alívio de dores reumáticas e gota.', 'Pode causar irritação na mucosa gástrica em doses elevadas. Evitar o uso concomitante com medicamentos de excreção renal.', '• Decocção Depurativa Sanguínea: Ferva 1 colher de chá de raízes trituradas de salsaparrilha em 1 xícara de água por 10 minutos. Abafe por 5 minutos, coe e tome de preferência em jejum pela manhã para potencializar a ação desintoxicante.', '• Banho de Desintoxicação Física e Áurica: Ferva 2 litros de água com 2 colheres de sopa de raiz de salsaparrilha por 8 minutos. Abafe por 10 minutos, coe e espere amornar. Jogue do pescoço para baixo visualizando todas as impurezas do seu corpo físico e energético escorrendo pela água e sendo neutralizadas.', '• Defumação de Regeneração e Filtro Energético: Queime raízes secas de salsaparrilha em brasa. A fumaça terrosa e resinosa atua como um filtro, prendendo e neutralizando partículas energéticas negativas flutuantes no espaço, purificando profundamente o ambiente.', '/images/herbs/salsaparrilha.png', 'integrative', 'Farmacopeia Brasileira (Ed. 5) & Tratados Tradicionais de Fitoterapia Latino-Americana', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(67, 'Erva-Baleeira', 'erva-baleeira', 'Cordia verbenacea', 'Baleeira, Maria-Milagrosa, Erva-Preta', 'Nativa da Mata Atlântica brasileira, a Erva-Baleeira é um dos anti-inflamatórios e cicatrizantes mais potentes e cicatrizantes do país. Ela contém o composto ativo alfa-humuleno, que inibe de forma espetacular mediadores inflamatórios no corpo, tornando-a ideal para o tratamento de dores musculares, contusões, tendinites, artrite e dores na coluna. Possui também ação cicatrizante na pele.', 'Muito segura para uso tópico. Para uso oral em forma de chá, evitar por gestantes e pessoas com histórico de sensibilidade a plantas da família Boraginaceae.', '• Infusão Contra Dores Articulares: Coloque 1 colher de sopa de folhas secas de erva-baleeira em 1 xícara de água fervendo. Abafe por 10 minutos, coe e consuma até 2 vezes ao dia.\n\n• Compressa Anti-inflamatória: Prepare um chá forte de baleeira, umedeça uma compressa limpa e aplique morna sobre a área dolorida por 20 minutos.', '• Banho de Alívio e Regeneração Muscular: Ferva 2 litros de água. Ao desligar o fogo, acrescente 3 colheres de sopa de erva-baleeira seca e abafe por 10 minutos. Coe, certifique-se de que está morno e despeje lentamente na região dolorida do corpo, mentalizando o alívio das tensões físicas e a restauração da elasticidade e integridade dos seus músculos e tendões.', '• Defumação de Regeneração e Alívio de Conflitos: Queime folhas secas de erva-baleeira em brasa. A fumaça herbal densa ajuda a dissipar \'dores\' emocionais coletivas no ambiente de convivência, amenizando o clima tenso provocado por ressentimentos e atritos frequentes.', '/images/herbs/erva-baleeira.png', 'integrative', 'Monografia de Erva-Baleeira da ANVISA & Formulário Fitoterápico Nacional do SUS', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(68, 'Picão-Preto', 'picao-preto', 'Bidens pilosa', 'Picão, Carrapicho-de-Agulha', 'O Picão-Preto é uma planta medicinal com poderosas ações hepatoprotetora, anti-inflamatória e antibacteriana. É tradicionalmente empregado para aliviar sintomas de icterícia, hepatite e congestão biliar, auxiliando o fígado na desintoxicação. Devido às suas propriedades antissépticas e regenerativas, também é muito útil no tratamento de alergias cutâneas, inflamações bucais e infecções urinárias.', 'Geralmente seguro, mas deve ser evitado por pessoas com alergia conhecida ao picão e plantas da família Asteraceae. Gestantes devem evitar o uso oral.', '• Infusão Depurativa do Fígado: Coloque 1 colher de sopa de folhas secas de picão-preto em 1 xícara de água fervente. Abafe por 10 minutos, coe e tome de preferência antes das principais refeições.', '• Banho de Assento ou Banho de Descarrego de Alergias: Prepare 2 litros de chá forte de picão-preto, coe e aguarde amornar. Jogue do pescoço para baixo para aliviar coceiras, alergias cutâneas ou irritações da mucosa íntima, visualizando a cura de toda e qualquer irritação física e energética.', '• Defumação de Banimento de Miasmas: Queime folhas e sementes secas de picão-preto sobre brasa de carvão. A fumaça rústica afasta miasmas astrais e limpa o ambiente doméstico de influências e correntes energéticas negativas acumuladas.', '/images/herbs/picao-preto.png', 'integrative', 'Formulário Fitoterápico Nacional do SUS & Monografia Científica da ANVISA', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(69, 'Carqueja-doce', 'carqueja-doce', 'Baccharis articulata', 'Carquejinha, Carqueja-Fêmea', 'A Carqueja-doce destaca-se por sua ação terapêutica hepática e digestiva notável, com sabor significativamente menos amargo que a carqueja comum. É ideal para combater a má digestão, refluxo, dores estomacais e azia, além de proteger as funções hepáticas e biliares. Suas propriedades depurativas também auxiliam no controle de colesterol e açúcar no sangue.', 'Evitar por diabéticos que usam insulina (risco de hipoglicemia rápida) e mulheres grávidas.', '• Infusão Digestiva Suave: Adicione 1 colher de sopa de ramos secos de carqueja-doce em 1 xícara de água fervente. Abafe por 10 minutos, coe e beba de preferência morno após o almoço ou jantar.', '• Banho de Desintoxicação e Limpeza Espiritual: Ferva 1,5 litros de água com 3 colheres de sopa de carqueja-doce por 3 minutos. Coe e deixe esfriar até a temperatura morna. Jogue do pescoço para baixo mentalizando a eliminação das energias que causam congestão em sua vida e a limpeza do plexo solar.', '• Defumação de Purificação do Plexo Solar: Queime carqueja-doce seca em brasa. A fumaça atua limpando ambientes onde há estagnação de pensamentos e sentimentos de raiva ou frustração, reequilibrando a energia vital dos moradores.', '/images/herbs/carqueja-doce.png', 'integrative', 'Farmacopeia Brasileira (Ed. 6) & Monografias de Plantas Medicinais da Comissão E da Alemanha', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(70, 'Erva-de-Santa-Maria', 'erva-de-santa-maria', 'Dysphania ambrosioides', 'Mastruz, Mentruz, Erva-Formigueira, Ambrósia', 'Tradicionalmente conhecida como Mastruz ou Mentruz, a Erva-de-Santa-Maria é uma planta medicinal com poderosas ações vermífuga, cicatrizante e antimicrobiana. Seus óleos essenciais contêm ascaridol, composto que confere excelente ação contra parasitas intestinais. É também amplamente utilizada para aliviar problemas respiratórios como bronquites, gripes e inflamações e contusões externas.', 'Altamente tóxica em doses terapêuticas altas. O óleo essencial é vermífugo mas perigoso. Proibido na gestação (abortivo e neurotóxico).', '• Uso Externo e Compressas: Macere folhas frescas com um pouco de sal e aplique sobre contusões para reduzir o inchaço.\n\n• Infusão Vermífuga (Uso Adulto Controlado): Coloque 1 colher de chá de folhas secas de erva-de-santa-maria em 1 xícara de água fervendo. Abafe por 10 minutos, coe e beba no máximo 1 xícara por dia (não usar em gestantes ou crianças).', '• Banho de Fechamento de Corpo e Proteção: Ferva 2 litros de água. Apague o fogo e junte 2 colheres de sopa de folhas frescas ou secas de erva-de-santa-maria. Abafe por 10 minutos e coe. Derrame do pescoço para baixo após o banho higiênico, mentalizando o fortalecimento do seu campo físico e a criação de uma barreira protetora contra males.', '• Defumação de Proteção Espiritual e Banimento Forte: Queime folhas secas de erva-de-santa-maria em brasa. O aroma forte e penetrante purifica profundamente o ambiente doméstico de influências astrais negativas e desintegra formas-pensamento de inveja.', '/images/herbs/erva-de-santa-maria.png', 'integrative', 'Formulário Fitoterápico Nacional do SUS & Compêndio Brasileiro de Plantas Medicinais', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(71, 'Sabugueiro', 'sabugueiro', 'Sambucus nigra', 'Sabugueirinho, Flor-de-Sabugueiro', 'As flores de Sabugueiro são mundialmente conhecidas como um dos melhores remédios naturais para combater gripes, resfriados e febres. Elas contêm flavonoides com potente ação antiviral e diurética que ajudam a fortalecer o sistema imunológico e estimulam a sudorese para abaixar a febre. Além disso, possui propriedades expectorantes que ajudam a aliviar a congestão nasal e do peito.', 'As cascas, folhas e frutos crus contêm glicosídeos cianogênicos e são tóxicos. Use apenas as flores secas ou frutos devidamente cozidos.', '• Infusão Antigripal e Antifebril: Adicione 1 colher de sopa de flores secas de sabugueiro em 1 xícara de água fervendo. Abafe por 10 minutos, coe e beba bem quente para estimular o suor e abaixar a febre.\n\n• Compressa Ocular Calmante: Umedeça algodões no chá de sabugueiro frio e coloque sobre olhos cansados por 15 minutos.', '• Banho de Renovação Imunológica e Suavidade: Ferva 1,5 litros de água. Ao ferver, desligue e adicione 3 colheres de sopa de flores de sabugueiro. Mantenha abafado por 10 minutos, coe e espere amornar. Banhe-se do pescoço para baixo mentalizando o fortalecimento das suas defesas biológicas, paz de espírito e vitalidade física.', '• Defumação de Transmutação e Proteção da Saúde: Queime flores secas de sabugueiro em brasa. A fumaça sutil e levemente adocicada é perfeita para criar um escudo protetor da saúde no lar, transmutando sentimentos de tristeza e cansaço em esperança e cura.', '/images/herbs/sabugueiro.png', 'integrative', 'Monografia de Sabugueiro da Comissão E Alemã & Farmacopeia Europeia', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(72, 'Tília', 'tilia', 'Tilia cordata', 'Tília-Europeia, Teja', 'A Tília é uma árvore majestosa cujas flores e folhas possuem propriedades sedativas, ansiolíticas e antiespasmódicas excelentes. Ela é indicada para combater a insônia, ansiedade crônica, estresse grave e palpitações de origem nervosa, promovendo um relaxamento suave no sistema circulatório e muscular. Suas propriedades sudoríficas também a tornam útil no combate a resfriados.', 'Contraindicado em pessoas com cardiopatias severas devido a relatos de efeitos cardíacos em uso crônico. Evitar durante a gestação.', '• Infusão Calmante e Indutora de Sono: Coloque 1 colher de sobremesa de flores e folhas de tília em 1 xícara de água fervendo. Abafe por 10 minutos, coe e beba cerca de 30 minutos a 1 hora antes de dormir.', '• Banho de Serenidade e Acalento da Alma: Ferva 2 litros de água e desligue o fogo. Adicione 3 colheres de sopa de tília seca e abafe por 12 minutos. Coe, aguarde a temperatura ficar morna e derrame lentamente do pescoço para baixo. Mentalize o relaxamento dos seus batimentos cardíacos, o repouso absoluto da sua mente e o acolhimento espiritual suave.', '• Defumação de Harmonia Familiar e Sono Doce: Queime flores secas de tília em brasa. A fumaça leve e perfumada promove o desarmamento de tensões familiares no lar, acalma o nervosismo das crianças e induz o ambiente doméstico a um sono tranquilo e reparador.', '/images/herbs/tilia.png', 'integrative', 'Monografia de Plantas Medicinais da Agência Europeia de Medicamentos (EMA) & Farmacopeia Francesa', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(73, 'Ipê-Roxo', 'ipe-roxo', 'Handroanthus impetiginosus', 'Pau-d\'Arco, Ipê-Preto, Taheebo', 'A casca do Ipê-Roxo é um poderoso estimulante imunológico, anti-inflamatório, cicatrizante e antifúngico natural, altamente valorizado na medicina integrativa. Ela contém o composto ativo lapachol, que combate infecções fúngicas como a candidíase crônica, fortalece as defesas celulares e auxilia no tratamento de gastrites e feridas de difícil cicatrização. Possui também ação analgésica suave.', 'Contraindicado em doses concentradas para quem usa anticoagulantes (risco de hemorragia) e mulheres gestantes (efeito teratogênico).', '• Decocção Fortalecedora e Antifúngica: Ferva 1 colher de sopa de casca picada de ipê-roxo em 1 xícara de água por 10 minutos. Abafe por 5 minutos, coe e tome 2 vezes ao dia.\n\n• Banho de Assento para Candidíase: Prepare 1 litro da decocção concentrada, coe, deixe amornar e utilize em banho de assento.', '• Banho de Imunidade e Autoestima Regenerada: Ferva 2 litros de água com 3 colheres de sopa de cascas de ipê-roxo por 10 minutos. Abafe, coe e deixe amornar. Derrame lentamente do pescoço para baixo visualizando a energia da árvore do ipê revestindo seu corpo com um escudo roxo de cura física, vitalidade celular e força imune.', '• Defumação de Purificação Profunda e Banimento de Enfermidades: Queime cascas secas de ipê-roxo sobre brasa. A fumaça forte e amadeirada é excelente para banir larvas astrais e purificar energeticamente o lar de vibrações de doença física crônica ou desvitalização extrema.', '/images/herbs/ipe-roxo.png', 'integrative', 'Formulário Fitoterápico Nacional do SUS & Monografia de Plantas Medicinais Sul-Americanas', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(74, 'Cana-do-Brejo', 'cana-do-brejo', 'Costus spicatus', 'Cana-de-Macaco, Jacuacanga, Cana-Roxa', 'A Cana-do-Brejo é uma planta brasileira tradicional por sua notável ação diurética, depurativa e analgésica urinária. É amplamente empregada no tratamento de cistite crônica, inflamações renais e na prevenção da formação de cálculos renais, pois estimula a micção de forma suave e reduz a inflamação nas vias urinárias. Também é útil para combater a retenção de líquidos generalizada.', 'Evitar o uso por pessoas com cálculos renais formados por oxalato de cálcio, devido à sua ação intensamente diurética e depurativa.', '• Chá Diurético e Renal: Coloque 1 colher de sopa de folhas picadas de cana-do-brejo seco em 1 xícara de água fervente. Abafe por 10 minutos, coe e beba morno de 2 a 3 vezes ao dia.', '• Banho de Limpeza Emocional e Fluidez dos Fluidos: Ferva 1,5 litros de água. Ao desligar o fogo, acrescente 3 colheres de sopa de cana-do-brejo seca e abafe por 10 minutos. Coe, deixe amornar e despeje lentamente do pescoço para baixo. Mentalize a liberação de ressentimentos guardados e a limpeza dos seus corpos sutis.', '• Defumação de Renovação e Equilíbrio Emocional: Queime folhas secas de cana-do-brejo. A fumaça sutil ajuda a acalmar desentendimentos, limpando a atmosfera de mágoas acumuladas e abrindo caminhos para uma comunicação clara e pacífica entre as pessoas.', '/images/herbs/cana-do-brejo.png', 'integrative', 'Farmacopeia Brasileira & Manual de Fitoterapia da Flora Nativa', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(75, 'Alfavaca', 'alfavaca', 'Ocimum gratissimum', 'Alfavaca-Cravo, Manjericão-de-Folha-Larga-Popular', 'A Alfavaca, ou manjericão-de-folha-larga, é uma planta aromática medicinal com poderosas ações antisséptica, carminativa e sudorífica. O seu óleo essencial é rico em eugenol, que confere notável ação antibacteriana e analgésica suave. É muito empregada para combater tosses, gripes e resfriados, além de ser excelente para aliviar gases intestinais e flatulência incômoda.', 'Evitar uso oral do chá concentrado em gestantes e crianças muito pequenas sem avaliação profissional.', '• Infusão Digestiva e Respiratória: Use 1 colher de sopa de folhas frescas ou secas de alfavaca para 1 xícara de água fervente. Abafe por 8 minutos, coe e consuma quente ou morno após as refeições ou em momentos de congestão nasal.', '• Banho de Prosperidade e Purificação Energética: Ferva 2 litros de água com 1 xícara de folhas frescas de alfavaca por 2 minutos. Abafe por 10 minutos, coe e deixe amornar. Jogue do pescoço para baixo visualizando a atração de energias prósperas, clareza mental e purificação completa do seu campo de força.', '• Defumação de Harmonia e Prosperidade no Lar: Queime folhas secas de alfavaca. O seu aroma pronunciado e herbal preenche o ambiente doméstico de vibrações de fartura, paz, amorosidade e harmonia, abrindo portas para energias prósperas de sucesso.', '/images/herbs/alfavaca.png', 'integrative', 'Farmacopeia Brasileira & Manual de Fitoterapia Prática da Saúde Integrativa', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(76, 'Manjericão-roxo', 'manjericao-roxo', 'Ocimum basilicum var. purpurascens', 'Basílico-Roxo, Manjericão-Cremita', 'O Manjericão-roxo destaca-se por sua coloração vibrante e altíssimo teor de antocianinas e antioxidantes potentes. Além de possuir excelentes ações antisséptica, digestiva e expectorante, ele atua no relaxamento físico e alívio do estresse crônico no sistema nervoso. É muito apreciado na medicina integrativa por harmonizar a mente e ajudar a elevar o ânimo em estados de tristeza profunda.', 'Evitar doses terapêuticas na gravidez e lactação. Uso culinário geral não apresenta contraindicações.', '• Infusão de Reequilíbrio Mental: Coloque 1 colher de sobremesa de folhas secas de manjericão-roxo em 1 xícara de água fervente. Abafe por 8 minutos, coe e beba à tarde ou à noite para aliviar a tensão do dia.\n\n• Inalação Vaporizante: Inale o vapor da infusão de folhas frescas para desobstruir as vias aéreas.', '• Banho de Limpeza Espiritual e Elevação Vibracional: Ferva 1,5 litros de água. Apague o fogo e acrescente 1 xícara de folhas frescas de manjericão-roxo. Abafe por 10 minutos, coe e derrame do pescoço para baixo após o seu banho de higiene. Mentalize a sua energia se renovando, a tristeza se dissipando e a proteção espiritual se restabelecendo.', '• Defumação de Proteção Espiritual e Purificação de Espaços: Queime folhas secas de manjericão-roxo em brasa. A fumaça perfumada desfaz energias pesadas, afasta a desarmonia e atrai vibrações purificadas de paz espiritual, harmonia no amor e amorosidade.', '/images/herbs/manjericao-roxo.png', 'integrative', 'Formulário de Fitoterapêuticos do SUS & Tradições Rituais de Cura Física e Espiritual', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(77, 'Alcaçuz', 'alcacuz', 'Glycyrrhiza glabra', 'Regaliz, Raiz-Doce', 'A raiz de Alcaçuz é amplamente consagrada por sua potente ação anti-inflamatória, expectorante e protetora das vias respiratórias e da mucosa gástrica. Seus principais compostos ativos, como a glicirrizina, atuam acalmando tosses secas graves e suavizando inflamações na garganta. Também ajuda na cicatrização de úlceras estomacais devido à sua notável capacidade de estimular a produção de muco protetor no estômago.', 'Altamente contraindicado para hipertensos (pode causar retenção de sódio, perda de potássio e elevar gravemente a pressão arterial).', '• Decocção Expectorante e Gástrica: Ferva 1 colher de chá de raízes secas de alcaçuz em 1 xícara de água por 5 a 10 minutos. Abafe por 5 minutos, coe e beba morno (evitar em hipertensos, pois pode elevar levemente a pressão se usado em excesso).', '• Banho de Doçura e Alívio de Tensões Corporais: Ferva 2 litros de água com 2 colheres de sopa de raiz de alcaçuz triturada por 8 minutos. Abafe por 10 minutos, coe e aguarde a temperatura ficar agradável. Jogue lentamente do pescoço para baixo mentalizando a doçura da vida e a libertação de toda a rigidez física.', '• Defumação de Atração de Vibrações Doces e Paz: Queime pedaços de raiz seca de alcaçuz em brasa. A fumaça libera um perfume sutilmente adocicado que preenche o ambiente de suavidade, acalmando o estresse severo coletivo e estimulando sentimentos de afeto.', '/images/herbs/alcacuz.png', 'integrative', 'Monografia de Alcaçuz da Organização Mundial da Saúde (OMS) & British Pharmacopoeia', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(78, 'Cardo-Mariano', 'cardo-mariano', 'Silybum marianum', 'Silimarina, Cardo-Leitoso', 'O Cardo-Mariano é o protetor hepático natural por excelência da medicina integrativa. Suas sementes contêm a silimarina, um complexo flavonoide que atua de forma espetacular regenerando as células do fígado danificadas por toxinas e gordura, estimulando a síntese de proteínas e agindo como um poderoso antioxidante celular. Auxilia intensamente na melhora da digestão pesada de gorduras e no detox geral.', 'Evitar em pessoas com hipertensão arterial grave e cânceres estrogênio-dependentes. Pode causar leve efeito laxativo.', '• Infusão de Sementes Moídas: Triture 1 colher de chá de sementes de cardo-mariano e junte em 1 xícara de água fervendo. Abafe por 15 minutos para extrair os compostos ativos, coe e consuma morno 30 minutos antes das refeições.', '• Banho de Proteção e Purificação do Plexo Solar: Ferva 1,5 litros de água com 2 colheres de sopa de sementes trituradas de cardo-mariano por 5 minutos. Abafe, coe e espere amornar. Jogue na altura do estômago (plexo solar) para baixo, mentalizando a proteção do seu fígado e o escudo contra energias de raiva externa.', '• Defumação de Blindagem e Afastamento de Inveja: Queime sementes secas de cardo-mariano em brasa. A fumaça tem propriedades místicas de blindagem, criando uma barreira de força ao redor do lar que dissolve formas-pensamento agressivas ou invejosas.', '/images/herbs/cardo-mariano.png', 'integrative', 'Monografia de Silybum marianum da OMS & Estudos de Fitofarmacologia da Comissão E Alemã', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(79, 'Salgueiro-Branco', 'salgueiro-branco', 'Salix alba', 'Salgueiro, Chorão-Branco, Aspirina-Natural', 'A casca de Salgueiro-Branco é considerada a \'aspirina natural\' do reino vegetal. Ela contém a salicina, substância precursora do ácido acetilsalicílico, que possui fantásticas ações analgésica, anti-inflamatória e antipirética. É ideal para aliviar dores de cabeça tensionais, dores musculares, febre de gripes e resfriados, e dores articulares sem provocar irritações extremas na mucosa estomacal.', 'Contraindicado em pessoas com alergia a salicilatos (aspirina), asma, úlceras gástricas ativas e menores de 16 anos (risco de Síndrome de Reye).', '• Decocção Analgésica e Antitérmica: Ferva 1 colher de sopa de cascas secas de salgueiro-branco em 1 xícara de água por 10 minutos. Abafe por 5 minutos, coe e tome morno quando sentir dores no corpo ou febre alta.', '• Banho de Alívio Térmico e Relaxamento: Ferva 2 litros de água com 3 colheres de sopa de casca de salgueiro-branco por 8 minutos. Abafe, coe e deixe amornar. Jogue do pescoço para baixo mentalizando o alívio das tensões físicas, a dissipação de febres emocionais e o relaxamento profundo da mente.', '• Defumação de Resfriamento Mental e Paz: Queime cascas secas de salgueiro-branco em brasa. A fumaça atua \'resfriando\' ambientes onde ocorreram discussões acaloradas, acalmando os ânimos exaltados e estimulando a paz.', '/images/herbs/salgueiro-branco.png', 'integrative', 'Monografia de Salix da Comissão E Alemã & Farmacopeia de Medicinas Tradicionais', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(80, 'Boldo-do-Chile', 'boldo-do-chile', 'Peumus boldus', 'Boldo-Verdadeiro, Boldo-Chile', 'O Boldo-do-Chile é um dos maiores e mais consagrados protetores do fígado e estimulantes digestivos conhecidos. Suas folhas contêm a boldina, um alcaloide que atua de forma espetacular estimulando a produção e a secreção de bile pela vesícula biliar, o que melhora significativamente a digestão de gorduras e alivia imediatamente a azia, ressaca e o peso estomacal decorrente de excessos alimentares.', 'Contraindicado em caso de obstrução biliar, hepatite aguda, gestação (provoca aborto e anomalias fetais) e lactação.', '• Infusão Digestiva Imediata: Coloque 1 colher de chá de folhas secas de boldo-do-chile em 1 xícara de água fervendo. Abafe por 5 a 10 minutos, coe e consuma morno, sem açúcar, logo após refeições pesadas ou em quadros de azia extrema.', '• Banho de Desintoxicação Física e Plexo Solar: Ferva 1,5 litros de água com 2 colheres de sopa de boldo-do-chile por 3 minutos. Coe, deixe atingir uma temperatura morna agradável. Jogue lentamente do pescoço para baixo mentalizando a desintoxicação do seu corpo físico e a liberação de ressentimentos.', '• Defumação de Purificação e Clareza de Decisões: Queime folhas secas de boldo em brasa. A fumaça amarga e forte atua limpando o ambiente doméstico de influências mentais negativas que geram confusão, restabelecendo a clareza para tomadas de decisão.', '/images/herbs/boldo-do-chile.png', 'integrative', 'Farmacopeia Brasileira (Ed. 6) & Monografias de Plantas Medicinais da OMS', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(81, 'Agrião', 'agriao', 'Nasturtium officinale', 'Agrião-d\'Água, Agrião-da-Fonte', 'O Agrião é uma planta herbácea semiaquática amplamente reconhecida pelo seu alto valor nutricional e pelas suas propriedades terapêuticas no trato respiratório. Rico em glicosinolatos, ferro, cálcio e vitaminas A e C, atua como um excelente expectorante e fluidificante, auxiliando na eliminação do muco bronquial e no combate à tosse e bronquites. Possui também ação diurética e depurativa, contribuindo para a eliminação de toxinas e a melhora da digestão.', 'Contraindicado em pessoas com úlceras gástricas ativas, inflamações renais agudas e hipotireoidismo severo.', '• Xarope Expectorante: Amasse um punhado de agrião fresco com mel ou calda de açúcar, filtre e tome colheradas ao longo do dia para acalmar a tosse.\n\n• Infusão Fortificante: Adicione 1 colher de sopa de folhas frescas em 1 xícara de água fervente. Abafe por 5 minutos, coe e consuma morno para auxiliar no trato respiratório.', '• Banho de Purificação e Nutrição Energética: Ferva 1,5 litros de água. Ao desligar o fogo, acrescente um punhado generoso de agrião fresco. Abafe por 10 minutos, coe e deixe atingir uma temperatura morna confortável. Despeje do pescoço para baixo após o banho habitual, mentalizando a renovação celular, a desintoxicação de energias estagnadas e o preenchimento de sua aura com vitalidade e frescor.', '• Defumação de Purificação e Renovação do Ar: Queime folhas de agrião desidratadas sobre brasa de carvão. A fumaça picante purifica o ar de agentes patógenos e ajuda a dispersar energias de letargia física, renovando o ânimo do ambiente doméstico.', '/images/herbs/agriao.png', 'integrative', 'Formulário Fitoterápico Nacional do SUS & Monografias de Plantas Medicinais da OMS', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(82, 'Angélica', 'angelica', 'Angelica archangelica', 'Angélica-Oficial, Erva-do-Espírito-Santo', 'A Angélica é uma planta imponente de aroma penetrante e agradável, célebre por suas virtudes digestivas, carminativas e espasmolíticas. Seus compostos amargos e óleos essenciais estimulam as secreções gástricas, auxiliando no tratamento de dispepsias, flatulência e cólicas gastrointestinais. Além disso, é tradicionalmente valorizada por sua capacidade de reduzir o estresse mental, atuando como um relaxante do sistema nervoso.', 'Causa fotossensibilidade (evitar exposição solar intensa após tomar). Contraindicado na gravidez e por pessoas com diabetes.', '• Infusão Digestiva e Nervosa: Coloque 1 colher de chá de raízes secas picadas ou sementes de angélica em 1 xícara de água fervendo. Abafe por 10 minutos, coe e consuma após as refeições para regular o estômago.', '• Banho de Proteção Espiritual e Centramento: Ferva 2 litros de água com 2 colheres de sopa de raízes secas de angélica por 5 minutos. Abafe por 10 minutos, coe e deixe amornar. Jogue do pescoço para baixo, visualizando uma luz dourada angelical selando seu campo energético, promovendo segurança psíquica, força interna e serenidade absoluta.', '• Defumação de Limpeza Áurica e Conexão Superior: Queime raízes de angélica secas trituradas em brasa. A fumaça aromática e balsâmica atua dissipando pesadelos, purificando ambientes de cargas psíquicas negativas e facilitando estados meditativos profundos.', '/images/herbs/angelica.png', 'integrative', 'Farmacopeia Europeia & Tratado de Fitoterapia Clínica da Comissão E Alemã', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(83, 'Borragem', 'borragem', 'Borago officinalis', 'Folha-de-Estrela, Borragem-Oficial', 'A Borragem destaca-se na fitoterapia pelas suas excelentes propriedades emolientes, diaforéticas e reguladoras hormonais. O óleo extraído de suas sementes é extremamente rico em ácido gama-linolênico (GLA), um ácido graxo essencial crucial para combater processos inflamatórios cutâneos e aliviar sintomas de TPM e menopausa. Suas folhas e flores secas também auxiliam na redução da retenção de líquidos e na eliminação de toxinas pela transpiração em episódios febris.', 'As sementes são seguras, mas o chá das folhas não deve ser consumido de forma contínua por conter traços de alcaloides prejudiciais ao fígado.', '• Infusão Depurativa e Reguladora: Coloque 1 colher de sopa de folhas e flores secas de borragem em 1 xícara de água fervente. Abafe por 8 minutos, coe e consuma duas vezes ao dia para reduzir o inchaço e modular o sistema endócrino.', '• Banho de Suavização Cutânea e Autoacolhimento: Ferva 1,5 litros de água, desligue e adicione 3 colheres de sopa de borragem. Mantenha abafado por 15 minutos, coe e aguarde amornar. Despeje lentamente sobre o corpo, visualizando a maciez física e a dissolução de rigidezes emocionais, permitindo que o amor-próprio floresça.', '• Defumação de Alegria e Leveza da Alma: Queime flores e folhas secas de borragem. A fumaça suave acalma corações aflitos, afasta a melancolia e restabelece a harmonia no lar, promovendo coragem e otimismo para novos começos.', '/images/herbs/borragem.png', 'integrative', 'Monografias de Plantas Medicinais da Agência Europeia de Medicamentos (EMA) & Farmacopeia Brasileira', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(84, 'Carobinha', 'carobinha', 'Jacaranda caroba', 'Jacarandá, Caroba-do-Campo', 'A Carobinha é uma planta nativa do cerrado e florestas brasileiras, grandemente valorizada por sua extraordinária ação depurativa do sangue, cicatrizante e antirreumática. Seus princípios ativos atuam de forma notável auxiliando o fígado e rins a eliminar toxinas metabólicas, sendo muito eficaz no tratamento de dermatoses como psoríase, eczemas e sífilis secundária. Também atua no alívio de dores nas articulações provocadas por gota e reumatismo.', 'Evitar o uso oral por gestantes, lactantes e pessoas com distúrbios gastroduodenais graves sem orientação médica.', '• Decocção Purificadora e Cicatrizante: Ferva 1 colher de sopa de folhas de carobinha em 1 xícara de água por 5 minutos. Abafe por 10 minutos, coe e tome de preferência em jejum pela manhã para potencializar a ação depurativa.', '• Banho de Limpeza Celular e Descarrego de Impurezas: Ferva 2 litros de água com 3 colheres de sopa de folhas de carobinha por 3 minutos. Abafe por 10 minutos, coe e misture com água fria até ficar morno. Despeje lentamente do pescoço para baixo, mentalizando a cura das inflamações do corpo físico e a purificação de sua aura.', '• Defumação de Filtro e Banimento de Cargas Densas: Queime folhas secas de carobinha. A fumaça terrosa atua como um desintegrador de pensamentos obsessivos e fluidos astrais estagnados no ambiente de convivência diária.', '/images/herbs/carobinha.png', 'integrative', 'Formulário de Fitoterapêuticos da Farmacopeia Brasileira & Manual de Plantas Medicinais do Cerrado', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(85, 'Casca-de-Anta', 'casca-de-anta', 'Drimys winteri', 'Cataia, Winteriana', 'A Casca-de-Anta, também conhecida como Cataia, é uma árvore nativa da Mata Atlântica cujas cascas são ricas em óleos essenciais, flavonoides e vitamina C. Possui potentes propriedades tônicas, estimulantes, antissépticas e digestivas, sendo historicamente utilizada no combate ao escorbuto, diarreias, dispepsias e dores de estômago. No trato respiratório, atua auxiliando o alívio de espasmos da asma e tosses catarrais.', 'Evitar o uso por pessoas com estômago excessivamente sensível, pois pode provocar náuseas e vômitos se consumido em jejum.', '• Decocção Tônica e Estomacal: Ferva 1 colher de chá de cascas secas de casca-de-anta em 1 xícara de água por 10 minutos. Coe e tome morno 15 minutos antes das refeições principais para estimular as funções gástricas.', '• Banho de Restauração Física e Vigor Energético: Ferva 1,5 litros de água com 2 colheres de sopa de cascas trituradas de casca-de-anta por 8 minutos. Deixe em infusão abafada até atingir uma temperatura agradável. Coe e despeje sobre o corpo físico, concentrando-se na revitalização dos seus músculos, ossos e no despertar da sua resiliência ancestral.', '• Defumação de Fortalecimento e Proteção da Saúde: Queime cascas secas picadas sobre carvão. A fumaça aromática, picante e amadeirada purifica o ambiente contra miasmas de convalescença, preenchendo a casa com uma atmosfera vigorosa e protetora.', '/images/herbs/casca-de-anta.png', 'integrative', 'Farmacopeia Brasileira (Ed. 1) & Manual de Fitoterapia Prática do SUS', '2026-05-28 03:56:12', '2026-05-28 03:56:12'),
(86, 'Cipó-Cabeludo', 'cipo-cabeludo', 'Mikania hirsutissima', 'Guaco-Cabeludo, Micania-Lanosa', 'O Cipó-Cabeludo é uma trepadeira brasileira altamente consagrada na medicina popular por sua notável ação diurética, anti-inflamatória e analgésica no sistema urinário. É amplamente empregado no tratamento de cálculos renais, cistites, uretrites e prostatites, ajudando a dissolver e eliminar sedimentos urinários de forma eficaz. Suas propriedades antirreumáticas também trazem alívio significativo a dores articulares e gota.', 'Evitar o uso contínuo sem pausas e por pessoas com distúrbios da coagulação sanguínea.', '• Infusão Diurética e Antisséptica: Coloque 1 colher de sopa de folhas e ramos picados de cipó-cabeludo em 1 xícara de água fervente. Abafe por 10 minutos, coe e beba morno 2 a 3 vezes ao dia.', '• Banho de Desobstrução de Canais e Alívio de Dores: Ferva 2 litros de água com 3 colheres de sopa de cipó-cabeludo seco por 3 minutos. Abafe por 12 minutos, coe e deixe amornar. Despeje lentamente nas costas e quadris, mentalizando o alívio das tensões físicas acumuladas e a fluidez das águas no seu corpo.', '• Defumação de Dissolução de Bloqueios e Padrões Rígidos: Queime ramos secos e desidratados de cipó-cabeludo. A fumaça suave atua quebrando energias de estagnação mental e ressentimentos que impedem o livre curso das decisões cotidianas dos moradores.', '/images/herbs/cipo-cabeludo.png', 'integrative', 'Formulário de Fitoterapêuticos da Farmacopeia Brasileira & Estudos Clínicos sobre Plantas do Cerrado', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(87, 'Cipó-Cravo', 'cipo-cravo', 'Tynanthus fasciculatus', 'Cipó-Trindade, Cravo-de-Cipó', 'O Cipó-Cravo é uma trepadeira amazônica famosa por seu delicioso aroma canforado-adocicado que lembra o cravo-da-índia. Possui excelentes propriedades tônicas, estimulantes, carminativas e afrodisíacas, sendo muito utilizado no combate à fadiga física e mental extrema, dores de estômago, gases e fraqueza geral. Suas propriedades analgésicas também ajudam no alívio de dores de dente, musculares e reumáticas.', 'Evitar o uso por gestantes devido ao seu efeito levemente estimulante sobre a musculatura lisa do útero.', '• Decocção Estimulante e Digestiva: Ferva 1 colher de sopa de pedaços de cipó-cravo em 1 xícara de água por 5 a 10 minutos. Coe e tome morno para combater a má digestão ou reidratar os sentidos cansados.', '• Banho de Ativação do Vigor e Magnetismo Pessoal: Ferva 2 litros de água com 3 colheres de sopa de cipó-cravo picado por 5 minutos. Abafe por 10 minutos, coe e deixe amornar. Jogue do pescoço para baixo após o banho higiênico, visualizando a ativação do seu magnetismo, vitalidade e energia de realização.', '• Defumação de Acolhimento Aromático e Vitalidade: Queime pedaços secos triturados de cipó-cravo sobre brasa. A fumaça exala um aroma aquecedor que dissipa a apatia coletiva no ambiente, estimulando a criatividade e a autoconfiança de todos.', '/images/herbs/cipo-cravo.png', 'integrative', 'Farmacopeia Popular Brasileira & Estudos Etnobotânicos da Flora Amazônica', '2026-05-28 03:56:13', '2026-05-28 03:56:13');
INSERT INTO `herbs` (`id`, `name`, `slug`, `scientific_name`, `aliases`, `description`, `contraindications`, `how_to_use`, `bath_instructions`, `incense_usage`, `image_path`, `source_type`, `sources`, `created_at`, `updated_at`) VALUES
(88, 'Cipó-Prata', 'cipo-prata', 'Banisteriopsis argyrophylla', 'Cipó-Branco, Prateada', 'O Cipó-Prata é uma planta da flora brasileira amplamente consagrada por sua excelente ação diurética, anti-inflamatória e protetora das vias urinárias. É extremamente eficaz para auxiliar na eliminação de cristais e cálculos renais, aliviar dores decorrentes de cólicas renais e tratar inflamações na bexiga. Auxilia também no controle do ácido úrico elevado e na redução do inchaço nas pernas.', 'Evitar o uso por indivíduos hipertensos sem acompanhamento médico, por sua forte ação diurética.', '• Infusão Renal e Diurética: Coloque 1 colher de sopa de cipó-prata seco em 1 xícara de água fervendo. Abafe por 10 minutos, coe e beba morno ao longo do dia para estimular o bom funcionamento dos rins.', '• Banho de Clareza e Purificação Cristalina: Ferva 1,5 litros de água. Apague o fogo e junte 3 colheres de sopa de cipó-prata seco. Abafe, coe e deixe amornar. Despeje lentamente sobre o corpo, visualizando suas energias físicas e sutis se tornando limpas, cristalinas e livres de detritos energéticos.', '• Defumação de Purificação Áurica e Clareza Mental: Queime folhas e ramos secos de cipó-prata. A fumaça leve limpa o campo mental do lar, propiciando um clima de serenidade ideal para focar nos estudos ou no trabalho com clareza.', '/images/herbs/cipo-prata.png', 'integrative', 'Formulário Fitoterápico do Farmacêutico Brasileiro & Estudos das Plantas Medicinais do Planalto Central', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(89, 'Erva-de-Bicho', 'erva-de-bicho', 'Polygonum hydropiper', 'Persicária, Pimenta-d\'Água, Pimenta-do-Brejo', 'A Erva-de-Bicho é uma planta de notável ação hemostática, cicatrizante e anti-inflamatória, amplamente consagrada na medicina popular para o tratamento de hemorroidas e varizes. Seus compostos ativos atuam de forma extraordinária fortalecendo a parede dos vasos sanguíneos, aumentando a resistência capilar e promovendo o alívio rápido de sangramentos e dores. Também apresenta eficácia na cicatrização de feridas na pele.', 'Totalmente contraindicada para gestantes (estimula o fluxo menstrual e contrações uterinas). Pode causar irritação urinária.', '• Infusão Circulatória e Hemostática: Adicione 1 colher de sobremesa de folhas secas de erva-de-bicho em 1 xícara de água fervente. Abafe por 10 minutos, coe e beba de preferência morno.\n\n• Banho de Assento para Hemorroidas: Prepare uma infusão concentrada com 3 colheres de sopa de erva-de-bicho em 1 litro de água fervente, coe, deixe amornar e realize banhos de assento diários.', '• Banho de Fortalecimento Vascular e Fechamento Áurico: Ferva 2 litros de água. Desligue e junte 3 colheres de sopa de erva-de-bicho. Abafe, coe e aguarde a temperatura corporal. Derrame do pescoço para baixo mentalizando o fortalecimento dos seus canais de energia e a cicatrização de suas dores internas.', '• Defumação de Banimento de Energias Parasitas: Queime folhas secas de erva-de-bicho em brasa. O aroma herbáceo pungente desintegra formas-pensamento parasitárias e purifica profundamente o ambiente de larvas astrais.', '/images/herbs/erva-de-bicho.png', 'integrative', 'Formulário Fitoterápico Nacional do SUS & Farmacopeia Brasileira (Ed. 5)', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(90, 'Erva-de-Santa-Luzia', 'erva-de-santa-luzia', 'Commelina erecta', 'Trapoeraba, Commelina', 'A Erva-de-Santa-Luzia é uma pequena planta de delicadas flores azuis, altamente prestigiada na medicina tradicional por suas propriedades antissépticas, anti-inflamatórias e cicatrizantes. Seu suco ou chá concentrado é historicamente utilizado para lavar olhos cansados, irritados ou inflamados em casos de conjuntivite. Na pele, atua auxiliando na cicatrização de eczemas, feridas superficiais e pequenas queimaduras de forma muito suave.', 'Geralmente muito segura. Evitar o uso por pessoas com hipersensibilidade conhecida à planta.', '• Infusão Calmante e Cicatrizante: Coloque 1 colher de sobremesa de folhas e flores de erva-de-santa-luzia em 1 xícara de água fervendo. Abafe por 10 minutos, coe com filtro de papel e utilize morno para compressas externas na pele ou lavagem suave das pálpebras.', '• Banho de Visão Clara e Purificação da Alma: Ferva 1,5 litros de água, desligue e adicione 3 colheres de sopa da erva com flores. Abafe por 10 minutos, coe e espere amornar. Derrame sobre o corpo mentalizando a abertura da sua visão interior, clarividência emocional e a dissolução de ilusões dolorosas.', '• Defumação de Iluminação e Paz Espiritual: Queime ramos secos e flores de erva-de-santa-luzia. A fumaça sutil ajuda a restaurar a harmonia e a clareza mental do ambiente doméstico, dissipando névoas mentais causadas por brigas.', '/images/herbs/erva-de-santa-luzia.png', 'integrative', 'Fitoterapia Popular no Brasil & Manual de Identificação de Plantas Medicinais Brasileiras', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(91, 'Guaçatonga', 'guacatonga', 'Casearia sylvestris', 'Guaçatunga, Erva-de-Bugre, Chá-de-Bugre', 'A Guaçatonga é um arbusto nativo do Brasil, célebre por suas extraordinárias propriedades cicatrizantes, antiulcerogênicas, antissépticas e analgésicas. Seus compostos químicos atuam inibindo a secreção de ácido clorídrico no estômago, cicatrizando úlceras gástricas com eficácia comparável a medicamentos tradicionais. Na pele, é uma das melhores aliadas contra o herpes labial, aftas e feridas difíceis.', 'Muito segura. Evitar o uso terapêutico oral por mulheres grávidas sem acompanhamento profissional.', '• Chá Protetor Gástrico: Ferva 1 colher de sopa de folhas secas de guaçatonga em 1 xícara de água por 3 minutos. Abafe por 5 minutos, coe e beba morno de preferência 20 minutos antes das refeições principais.\n\n• Aplicação Tópica para Aftas ou Herpes: Prepare um chá concentrado de guaçatonga e aplique na lesão com um cotonete várias vezes ao dia.', '• Banho de Proteção e Regeneração da Pele: Ferva 2 litros de água e desligue o fogo. Adicione 3 colheres de sopa de guaçatonga seca. Deixe abafado por 15 minutos, coe e aguarde amornar. Derrame sobre o corpo visualizando uma película protetora regeneradora de luz verde-esmeralda envolvendo todo o seu corpo.', '• Defumação de Escudo Protetor e Banimento: Queime folhas secas de guaçatonga em brasa. A fumaça aromática cria uma barreira protetora contra intrusões energéticas no lar, repelindo vibrações de inveja e cobiça.', '/images/herbs/guacatonga.png', 'integrative', 'Formulário Fitoterápico Nacional do SUS & Monografia de Plantas Medicinais da ANVISA', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(92, 'Ipê-Amarelo', 'ipe-amarelo', 'Handroanthus albus', 'Pau-d\'Arco-Amarelo, Ipê', 'O Ipê-Amarelo é uma das árvores mais icônicas da flora brasileira, cujas cascas e flores possuem reconhecidas ações imunoestimulantes, depurativas e anti-inflamatórias. Suas cascas contêm substâncias que ativam a resposta imunológica celular, auxiliando na defesa do organismo contra vírus e bactérias. É tradicionalmente utilizado no combate a febres, resfriados e no reequilíbrio geral do organismo.', 'Evitar o uso concomitante com medicamentos anticoagulantes. Contraindicado durante a gestação.', '• Decocção Fortalecedora: Ferva 1 colher de chá de cascas secas picadas de ipê-amarelo em 1 xícara de água por 10 minutos. Coe e tome morno pela manhã, durante períodos de mudanças de temperatura para proteger a imunidade.', '• Banho de Luz, Prosperidade e Renovação Vital: Ferva 2 litros de água com 3 colheres de sopa de cascas de ipê-amarelo por 8 minutos. Adicione algumas flores amarelas se tiver disponíveis. Coe e espere ficar morno. Derrame lentamente do pescoço para baixo mentalizando a atração de luz solar, vitalidade dourada, abertura de caminhos e abundância plena.', '• Defumação de Atração de Luz e Otimismo: Queime cascas e flores secas trituradas de ipê-amarelo. A fumaça amadeirada e suave dissipa pensamentos de depressão e melancolia do lar, preenchendo o ambiente com a vibração da alegria e do sucesso.', '/images/herbs/ipe-amarelo.png', 'integrative', 'Estudos Clínicos da Flora Nativa Brasileira & Manual de Fitoterapia e Plantas Medicinais do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(93, 'Jarrinha', 'jarrinha', 'Aristolochia galeata', 'Cipó-Milhomens, Aristolóquia', 'A Jarrinha é uma trepadeira de flores de formato singular, conhecida popularmente por suas fortes ações diuréticas, antiespasmódicas e depurativas na medicina popular. É tradicionalmente empregada para acalmar cólicas intestinais, estimular a transpiração em casos de febres e resfriados e auxiliar no alívio de sintomas de asma e tosses. Deve ser usada com extremo critério e moderação, preferencialmente sob orientação terapêutica.', 'Contém ácido aristolóquico, que é nefrotóxico e cancerígeno se consumido em doses concentradas e uso contínuo. Usar com extrema cautela e sob supervisão.', '• Infusão Controlada (Uso Moderado): Adicione no máximo 1 colher de café rasa de folhas secas de jarrinha em 1 xícara de água fervente. Abafe por 10 minutos, coe e consuma morno, limitando o consumo a apenas 1 xícara ao dia.', '• Banho de Proteção Espiritual e Quebra de Demandas: Ferva 1,5 litros de água com 1 colher de sopa de jarrinha seca por 3 minutos. Abafe, coe e espere ficar morno. Jogue do pescoço para baixo concentrando-se no desfazimento de nós energéticos que amarram seus caminhos profissionais e amorosos.', '• Defumação de Descarrego e Banimento de Cargas Pesadas: Queime folhas secas de jarrinha em brasa. A fumaça densa é excelente para purificar o ambiente doméstico de influências astrais negativas duradouras ou após períodos de discussões pesadas.', '/images/herbs/jarrinha.png', 'integrative', 'Farmacopeia Brasileira (Ed. 1) & Estudos Científicos sobre Aristolochiaceae na Flora Brasileira', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(94, 'Juá', 'jua', 'Solanum viarum', 'Juazeiro, Laranjinha-de-Vaqueiro', 'O Juá é um arbusto espinhoso da caatinga brasileira, cujas cascas e frutos são extremamente ricos em saponinas naturais, conferindo-lhe uma notável ação detergente, antisséptica e anti-inflamatória. É consagrado na higiene natural para limpeza bucal, prevenção de cáries e gengivite, além de ser empregado na limpeza profunda do couro cabeludo contra caspa e queda.', 'As cascas são ricas em saponinas. Evitar o uso oral por crianças e gestantes. O uso externo como higienizante capilar e bucal é extremamente seguro.', '• Pó Dental de Juá: Triture as cascas secas de juá até virar um pó muito fino. Utilize este pó para escovar os dentes 1 a 2 vezes por semana para limpeza profunda e saúde das gengivas.\n\n• Decocção Capilar Anticaspa: Ferva 2 colheres de sopa de cascas em 500ml de água por 10 minutos. Deixe esfriar, coe e aplique no couro cabeludo após a lavagem habitual.', '• Banho de Limpeza Profunda e Banimento de Miopias Mentais: Ferva 2 litros de água com 3 colheres de sopa de cascas de juá por 8 minutos. Espere amornar, coe e despeje sobre o corpo físico. Mentalize a remoção de todas as crostas energéticas de autossabotagem e a regeneração de sua autoestima e pureza interior.', '• Defumação de Purificação Severa e Banimento: Queime pedaços de casca de juá desidratados. A fumaça áspera e purificadora corta cordões energéticos negativos no ambiente de trabalho ou no lar, restabelecendo a neutralidade espiritual.', '/images/herbs/jua.png', 'integrative', 'Manual de Fitoterapia do Semiárido & Formulário de Fitoterapêuticos da Farmacopeia Brasileira', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(95, 'Laranja-Azeda', 'laranja-azeda', 'Citrus aurantium', 'Laranja-da-Terra, Laranja-Amarga', 'As flores e cascas de Laranja-Azeda são excepcionalmente ricas em óleos essenciais (como o neroli) e compostos termogênicos como a sinefrina. Atua no sistema nervoso promovendo um relaxamento suave que combate a insônia, estresse severo e palpitações de origem nervosa. Simultaneamente, suas cascas auxiliam no processo de queima de gorduras, controle do apetite excessivo e melhora das funções digestivas e diuréticas.', 'Evitar o uso por hipertensos e cardíacos, pois contém sinefrina, que pode elevar a frequência cardíaca e a pressão arterial.', '• Infusão Relaxante e Digestiva: Adicione 1 colher de chá de flores de laranja-azeda desidratadas em 1 xícara de água fervente. Abafe por 8 minutos, coe e consuma à noite para induzir o repouso.\n\n• Chá Termogênico de Cascas: Ferva 1 colher de sopa de cascas secas em 200ml de água por 5 minutos antes das refeições principais para auxiliar na queima de gordura.', '• Banho de Acalento, Doçura e Equilíbrio Emocional: Ferva 2 litros de água, desligue e adicione 3 colheres de sopa de flores ou cascas secas de laranja-azeda. Mantenha abafado por 10 minutos, coe e jogue morno do pescoço para baixo. Mentalize o derretimento do estresse do dia, preenchendo a mente com tranquilidade, doçura e equilíbrio restaurado.', '• Defumação de Paz, Prosperidade e Boa Convivência: Queime cascas secas de laranja-azeda e flores. A fumaça cítrica e aromática atrai a vibração da alegria, suaviza atritos familiares e perfuma deliciosamente o ambiente, preparando-o para o repouso seguro.', '/images/herbs/laranja-azeda.png', 'integrative', 'Monografias de Plantas Medicinais da OMS & Formulário Fitoterápico Nacional do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(96, 'Lírio-do-Brejo', 'lirio-do-brejo', 'Hedychium coronarium', 'Jasmim-Borboleta, Borboleta', 'O Lírio-do-Brejo é uma planta semiaquática de flores brancas intensamente perfumadas, valorizada pelas suas marcantes propriedades calmantes, analgésicas, antirreumáticas e purificadoras. Seus óleos essenciais atuam suavemente no sistema nervoso, ajudando a diminuir a ansiedade excessiva, aliviar dores de cabeça tensionais e dores nas articulações. Também possui excelente ação protetora respiratória e cicatrizante na pele.', 'Muito seguro, porém o chá das raízes deve ser evitado por gestantes devido à carência de estudos toxicológicos na gravidez.', '• Infusão Calmante e Perfumada: Adicione 1 colher de chá de pétalas secas de lírio-do-brejo em 1 xícara de água fervente. Abafe por 8 minutos, coe e tome à tarde para desacelerar o ritmo de trabalho.\n\n• Inalação de Vapor Vias Aéreas: Despeje pétalas frescas em água fervente e inale o vapor para aliviar a tensão nasal.', '• Banho de Purificação Áurica, Delicadeza e Paz: Ferva 1,5 litros de água, desligue e acrescente pétalas secas ou frescas de lírio-do-brejo. Abafe por 10 minutos, coe e espere atingir a temperatura corporal. Derrame lentamente do pescoço para baixo após o banho higiênico, mentalizando o recolhimento suave de sua mente e o equilíbrio espiritual restaurado.', '• Defumação de Harmonia Familiar e Elevação Vibracional: Queime pétalas e raízes desidratadas de lírio-do-brejo sobre carvão. A fumaça floral e adocicada harmoniza as energias domésticas, afasta a desavença conjugal e promove um ambiente propício para a paz interior.', '/images/herbs/lirio-do-brejo.png', 'integrative', 'Manual de Fitoterapia Tradicional Brasileira & Estudos Fitoquímicos sobre Plantas Semiaquáticas', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(97, 'Marapuama', 'marapuama', 'Ptychopetalum olacoides', 'Muira-Puama, Madeira-da-Potência', 'A Marapuama é uma planta nativa da floresta amazônica, celebrada mundialmente como um dos mais potentes tônicos neuromusculares, estimulantes do sistema nervoso e afrodisíacos naturais. Seus alcaloides e fitoesteróis auxiliam no combate ao esgotamento físico e mental crônico, melhoram consideravelmente a memória e a concentração, equilibram o sistema hormonal e combatem problemas de impotência.', 'Contraindicado em pessoas com hipertensão arterial descontrolada, ansiedade severa e insônia persistente.', '• Decocção Revigorante e Cognitiva: Ferva 1 colher de sopa de cascas picadas de marapuama em 1 xícara de água por 15 minutos. Coe e consuma morno de manhã para obter vitalidade duradoura e foco ao longo do dia de trabalho.', '• Banho de Ativação Energética e Fogo Vital: Ferva 2 litros de água com 2 colheres de sopa de cascas de marapuama por 10 minutos. Espere amornar, coe e derrame do pescoço para baixo após o banho habitual. Mentalize a recuperação de todo o seu vigor físico, poder de foco e a ativação de sua chama interna realizadora.', '• Defumação de Iniciativa, Coragem e Dinamismo: Queime cascas secas trituradas de marapuama sobre carvão em brasa. A fumaça densa e terrosa elimina o desânimo, a procrastinação e a apatia coletiva no ambiente doméstico ou profissional.', '/images/herbs/marapuama.png', 'integrative', 'Farmacopeia Brasileira (Ed. 2) & Monografia Científica de Plantas Amazônicas da ANVISA', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(98, 'Mil-Folhas', 'mil-folhas', 'Achillea millefolium', 'Mil-em-Rama, Aquileia, Novalgina-Natural', 'A Mil-Folhas é uma planta medicinal versátil com renomadas ações adstringentes, cicatrizantes, hemostáticas, antiespasmódicas e digestivas. É extremamente benéfica para regular o ciclo menstrual, diminuindo as cólicas dolorosas e controlando sangramentos excessivos devido às suas propriedades moduladoras do sistema circulatório. Também protege o fígado e estômago, aliviando dispepsias e febres devido à sua ação sudorífica.', 'Contraindicado para gestantes (estimulante uterina e abortiva) e pessoas alérgicas a plantas da família Asteraceae.', '• Infusão Digestiva e Reguladora Menstrual: Coloque 1 colher de sobremesa de folhas secas de mil-folhas em 1 xícara de água fervendo. Abafe por 10 minutos, coe e beba morno, preferencialmente antes das refeições principais ou durante o ciclo menstrual.', '• Banho de Proteção Áurica e Fechamento de Ciclos: Ferva 2 litros de água com 3 colheres de sopa de mil-folhas por 3 minutos. Coe, aguarde a temperatura corporal e jogue lentamente do pescoço para baixo. Mentalize o fechamento de brechas no seu campo áurico e a cura de feridas do passado.', '• Defumação de Corte de Energias Negativas e Proteção: Queime folhas e flores secas de mil-folhas. A fumaça herbal cria uma forte barreira protetora que corta invejas, ciúmes e afasta discórdias do ambiente familiar.', '/images/herbs/mil-folhas.png', 'integrative', 'Formulário Fitoterápico Nacional do SUS & Monografias da Agência Europeia de Medicamentos (EMA)', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(99, 'Parietária', 'parietaria', 'Parietaria officinalis', 'Erva-de-Nossa-Senhora, Alfaca-de-Cobra', 'A Parietária, historicamente apelidada de \'erva-das-muralhas\', é amplamente reverenciada por sua poderosa ação diurética, depurativa e anti-inflamatória no sistema urinário. Ela estimula suavemente o funcionamento renal, facilitando a dissolução de cálculos nos rins, combatendo infecções urinárias e aliviando edemas causados por retenção hídrica. Na pele, possui excelente ação cicatrizante e calmante sobre feridas e eczemas.', 'Contraindicado para pessoas com alergias severas ao pólen. Evitar o uso na gravidez.', '• Infusão Diurética e Renal: Coloque 1 colher de sopa de folhas secas de parietária em 1 xícara de água fervente. Abafe por 10 minutos, coe e tome de 2 a 3 vezes ao dia para incentivar a eliminação de toxinas urinárias.', '• Banho de Fluidez, Renovação e Desintoxicação Renal: Ferva 1,5 litros de água. Ao apagar o fogo, junte 3 colheres de sopa de parietária seca. Abafe, coe e deixe amornar. Banhe-se do pescoço para baixo mentalizando o livre fluxo dos sentimentos e a purificação total dos seus líquidos biológicos.', '• Defumação de Fluidez e Liberação de Obstáculos: Queime folhas secas desidratadas de parietária. A fumaça suave desfaz bloqueios energéticos nas estruturas de convivência, trazendo um clima de maior adaptabilidade e renovação.', '/images/herbs/parietaria.png', 'integrative', 'Farmacopeia Europeia & Tratados Tradicionais de Fitoterapia Europeia', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(100, 'Pêssego-do-mato', 'pessego-do-mato', 'Prunus myrtifolia', 'Prunus, Pêssego-Silvestre', 'O Pêssego-do-mato é uma espécie arbórea nativa do Brasil cujas cascas e folhas são tradicionalmente valorizadas por suas potentes propriedades adstringentes, antiespasmódicas e respiratórias. Seus princípios ativos atuam de forma extraordinária acalmando espasmos da tosse e auxiliando na expectoração de secreções bronquiais em gripes e bronquites crônicas. Também possui ação tônica digestiva e antisséptica suave.', 'Evitar o consumo das folhas e sementes sem processamento térmico adequado, pois podem conter glicosídeos cianogênicos.', '• Decocção Expectorante e Calmante da Tosse: Ferva 1 colher de chá de cascas secas picadas de pêssego-do-mato em 1 xícara de água por 8 minutos. Abafe por 5 minutos, coe e consuma morno adoçado com mel para potencializar a ação bronquial.', '• Banho de Desobstrução Respiratória e Acalento Físico: Ferva 2 litros de água com 2 colheres de sopa de folhas secas de pêssego-do-mato por 3 minutos. Abafe por 10 minutos, coe e deixe morno. Derrame lentamente nos ombros e peito, mentalizando a cura das vias respiratórias e o conforto físico total.', '• Defumação de Clareza e Purificação do Ar: Queime ramos secos e folhas de pêssego-do-mato. A fumaça sutil limpa o ar de vírus e bactérias físicas e ajuda a dissipar energias pesadas de desânimo coletivo no lar, trazendo leveza e facilidade de convívio.', '/images/herbs/pessego-do-mato.png', 'integrative', 'Manual de Fitoterapia e Flora Nativa Brasileira & Farmacopeia Popular Brasileira', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(101, 'Piri-Piri', 'piri-piri', 'Cyperus articulatus', 'Junco-Cheiroso, Capim-Piri-Piri', 'O Piri-Piri, conhecido também como Pripioca, é uma planta amazônica cujos rizomas exalam um perfume terroso e picante altamente terapêutico. Possui excelentes propriedades tônicas, calmantes, digestivas e carminativas, atuando com sucesso na regulação gástrica, no alívio de náuseas, gases intestinais e dores de cabeça tensionais. Na aromaterapia tradicional, é reverenciado por acalmar mentes hiperativas e promover equilíbrio.', 'Evitar o uso do óleo por gestantes e crianças sem supervisão profissional.', '• Decocção Aromática e Digestiva: Ferva 1 colher de chá de rizomas triturados de piri-piri em 1 xícara de água por 10 minutos. Coe e consuma morno após refeições pesadas ou para aliviar enjoos de viagens.', '• Banho de Aterramento, Proteção e Magnetismo Amazônico: Ferva 2 litros de água com 2 colheres de sopa de rizomas picados por 10 minutos. Deixe amornar, coe e derrame por todo o corpo. Mentalize sua conexão firme com a Terra, dissolução do estresse e aumento do seu magnetismo pessoal e autoconfiança.', '• Defumação de Limpeza Profunda e Aterramento Mental: Queime rizomas desidratados de pripioca ou piri-piri sobre brasa. A fumaça intensamente aromática e terrosa elimina ruídos e estresses mentais do ambiente, trazendo clareza, centramento e paz espiritual estável.', '/images/herbs/piri-piri.png', 'integrative', 'Estudos Etnobotânicos da Flora Amazônica & Farmacopeia Homeopática Brasileira', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(102, 'Sassafrás', 'sassafras', 'Sassafras albidum', 'Canela-Sassafrás, Sassafrás-do-Brasil', 'O Sassafrás é uma árvore nativa da América do Norte célebre por seu marcante aroma adocicado e por suas excelentes ações depurativas, diaforéticas e analgésicas. Tradicionalmente, suas raízes e cascas estimulam a eliminação de toxinas do sangue através do suor e da urina, auxiliando no tratamento de reumatismos crônicos, gota e problemas de pele como acne e psoríase. Deve ser utilizado de forma cautelosa e em baixas concentrações.', 'O óleo essencial contém safrol, substância hepatotóxica. Proibida a ingestão contínua ou em altas doses. Totalmente proibida na gravidez.', '• Decocção Depurativa Controlada: Ferva 1 colher de café rasa de casca de raiz de sassafrás em 1 xícara de água por 5 minutos. Abafe por 10 minutos, coe e consuma no máximo 1 vez ao dia por curtos períodos.', '• Banho de Transmutação, Renovação e Descarrego: Ferva 2 litros de água com 1 colher de sopa de sassafrás por 5 minutos. Abafe por 10 minutos, coe e aguarde ficar morno. Despeje do pescoço para baixo, visualizando uma luz azul transmutando dores físicas e amarguras emocionais em esperança e fluidez vital.', '• Defumação de Purificação Profunda e Renovação de Ambientes: Queime lascas de madeira ou cascas de sassafrás secas. A fumaça deliciosamente aromática e adocicada desintegra resíduos de energias densas, atraindo a frequência da saúde plena e do recomeço.', '/images/herbs/sassafras.png', 'integrative', 'Farmacopeia dos Estados Unidos (USP) & Tratados de Etnobotânica Nativa Americana', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(103, 'Sucuuba', 'sucuuba', 'Himatanthus sucuuba', 'Janaguba, Sucuba, Raivosa', 'A Sucuuba é uma árvore emblemática da Amazônia, famosa pelo seu látex e cascas com extraordinárias propriedades anti-inflamatórias, cicatrizantes, analgésicas e antissépticas. Na medicina tradicional, é altamente reverenciada para o tratamento de úlceras gástricas, inflamações uterinas, artrite, reumatismo e dores na coluna. Possui excelente ação na cicatrização de eczemas, feridas externas e picadas de insetos.', 'O látex deve ser diluído adequadamente antes do uso oral para evitar vômitos, náuseas e irritação gástrica severa. Contraindicado para gestantes.', '• Decocção Cicatrizante e Anti-inflamatória: Ferva 1 colher de chá de cascas de sucuuba picadas em 1 xícara de água por 10 minutos. Coe e consuma 2 vezes ao dia.\n\n• Compressas Externas Anti-inflamatórias: Umedeça uma compressa limpa no chá de sucuuba concentrado e aplique morno sobre tecidos inflamados ou dores musculares profundas por 20 minutos.', '• Banho de Restauração Física e Fortalecimento Estrutural: Ferva 2 litros de água com 3 colheres de sopa de casca de sucuuba por 8 minutos. Abafe por 10 minutos, coe e espere amornar. Derrame lentamente nos ombros e coluna, visualizando o alívio das inflamações e a regeneração de suas forças físicas estruturais.', '• Defumação de Fechamento de Corpo e Proteção: Queime cascas secas de sucuuba sobre carvão. A fumaça resinosa e firme atua blindando as portas e janelas do lar contra vibrações de baixa frequência ou ataques psíquicos direcionados.', '/images/herbs/sucuuba.png', 'integrative', 'Farmacopeia Popular da Amazônia & Manual de Fitoterapia de Plantas da Flora Brasileira', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(104, 'Vassourinha', 'vassourinha', 'Scoparia dulcis', 'Vassourinha-de-Botão, Tupixaba', 'A Vassourinha é uma planta herbácea amplamente distribuída no Brasil, com reconhecidas propriedades expectorantes, antiespasmódicas, diuréticas e febrífugas. É muito empregada na medicina tradicional para tratar problemas respiratórios como asma, bronquite e tosses catarrais, pois ajuda a dilatar os brônquios e fluidificar as secreções. Também auxilia no reequilíbrio gástrico e na eliminação renal de toxinas.', 'Evitar o uso por gestantes nas primeiras semanas de gravidez e por pessoas hipertensas sem acompanhamento.', '• Infusão Expectorante e Bronquial: Coloque 1 colher de sobremesa de folhas secas de vassourinha em 1 xícara de água fervente. Abafe por 10 minutos, coe e consuma morno, preferencialmente adoçado com mel para aliviar tosses.', '• Banho de Limpeza Astral e Desobstrução Caminhos: Ferva 2 litros de água. Ao desligar, adicione 3 colheres de sopa de vassourinha. Abafe por 10 minutos, coe e espere amornar. Jogue do pescoço para baixo após o banho higiênico, mentalizando a \'varredura\' de todas as energias intrusas e a abertura fluida dos seus caminhos.', '• Defumação de Varredura Espiritual e Banimento: Queime ramos secos de vassourinha sobre carvão. A fumaça densa e rústica atua como uma verdadeira vassoura espiritual, limpando a atmosfera do lar de ciúmes, fofocas e vibrações estagnadas.', '/images/herbs/vassourinha.png', 'integrative', 'Formulário Fitoterápico Nacional do SUS & Monografia de Plantas Medicinais do Caribe e América Latina', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(105, 'Chá-Verde', 'cha-verde', 'Camellia sinensis', 'Chá-da-Índia, Camélia', 'O Chá-Verde, derivado das folhas da Camellia sinensis, é mundialmente aclamado por seu poderoso teor de antioxidantes (especialmente as catequinas) e cafeína estimulante. Atua promovendo uma melhora espetacular no foco mental, na memória e na clareza de pensamentos, além de acelerar o metabolismo celular e auxiliar na perda de peso. Seus compostos também fortalecem o sistema imunológico, a saúde cardiovascular e atuam como protetores do envelhecimento celular precoce.', 'Evitar o consumo excessivo à noite por conter cafeína (pode causar insônia). Contraindicado em caso de gastrite severa e arritmias cardíacas.', '• Infusão Antioxidante e Estimulante de Foco: Aqueça a água até começar a formar pequenas bolhas (cerca de 80°C), apague o fogo e adicione 1 colher de chá de folhas secas de chá-verde. Abafe por no máximo 3 minutos (para evitar o amargor excessivo), coe e consuma quente pela manhã ou no início da tarde.', '• Banho de Rejuvenescimento, Foco e Renovação Celular: Ferva 2 litros de água. Ao desligar o fogo, acrescente 3 colheres de sopa de folhas secas de chá-verde e abafe por 10 minutos. Coe, deixe amornar e jogue sobre o corpo mentalizando a eliminação dos radicais livres físicos, ativação da sua mente e o despertar de uma nova energia vital e jovialidade plena.', '• Defumação de Purificação Intelectual e Clareza Psíquica: Queime folhas secas de chá-verde em brasa. A fumaça sutil e levemente herbácea clareia a mente de ruídos, favorece debates e estudos intelectuais, além de restaurar o padrão de energia positiva no ambiente de trabalho.', '/images/herbs/cha-verde.png', 'integrative', 'Monografias de Plantas Medicinais da OMS & Farmacopeia Europeia', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(106, 'Alcachofra', 'alcachofra', 'Cynara scolymus', 'Alcachofra-de-Comer, Alcachofra-Hortense', 'Planta herbácea famosa por suas propriedades protetoras do fígado e estimulantes da vesícula biliar. Suas folhas contêm cinarina, ácido rosmarínico e flavonoides, que auxiliam na digestão de gorduras, regulam o colesterol e reduzem a sensação de inchaço abdominal após as refeições.', 'Totalmente contraindicada em caso de obstrução das vias biliares ou cálculos na vesícula. Evitar na gravidez e lactação.', '• Infusão Digestiva: Adicione 1 colher de sopa de folhas de alcachofra secas em 1 xícara (200ml) de água fervente. Abafe por 10 minutos, coe e consuma cerca de 15 a 20 minutos antes das refeições principais.', '• Banho de Desintoxicação e Limpeza de Excessos: Ferva 1,5 litros de água. Ao ferver, desligue o fogo e adicione 3 colheres de sopa de folhas de alcachofra secas. Deixe abafado por 10 minutos, coe e jogue do pescoço para baixo após o banho normal para ajudar a liberar bloqueios energéticos causados por excessos materiais ou alimentares.', '• Defumação de Purificação e Desapego: Coloque folhas secas de alcachofra trituradas sobre carvão em brasa. A fumaça ajuda a limpar a atmosfera de energias densas ligadas à ganância, possessividade e apego excessivo a bens materiais.', '/images/herbs/alcachofra.png', 'scientific', 'Formulário Fitoterápico Nacional do SUS & Monografias da Organização Mundial da Saúde (OMS)', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(107, 'Abacateiro', 'abacateiro', 'Persea americana', 'Folha-de-Abacate, Abacate', 'As folhas do abacateiro são amplamente reconhecidas na medicina popular brasileira por sua forte ação diurética, anti-inflamatória e protetora dos rins. Auxiliam na eliminação de toxinas urinárias e são usadas para aliviar dores reumáticas e combater a retenção de líquidos.', 'Evitar o uso em gestantes e por pessoas com insuficiência renal severa sem acompanhamento médico.', '• Chá Diurético de Folhas de Abacate: Ferva 1 litro de água com 2 colheres de sopa de folhas secas de abacateiro picadas por 5 minutos. Desligue, abafe por 10 minutos, coe e beba ao longo do dia.', '• Banho de Fluidez e Renovação de Águas: Ferva 2 litros de água e adicione 5 folhas frescas de abacateiro amassadas. Abafe por 15 minutos. Após o banho de higiene, jogue o líquido do pescoço para baixo mentalizando a eliminação de mágoas acumuladas e renovando o fluxo emocional.', '• Defumação de Transmutação de Mágoas: Queime folhas de abacateiro secas. A fumaça suave e herbal auxilia na transmutação de sentimentos de ressentimento e tristeza estagnados na energia do ambiente.', '/images/herbs/abacateiro.png', 'popular', 'Farmacopeia Brasileira (Ed. 5) & Sabedoria de Benzedeiras do Sul do Brasil', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(108, 'Agoniada', 'agoniada', 'Himatanthus lancifolius', 'Quina-Mole, Sucuba, Arapuê', 'Árvore nativa do Brasil cujas cascas e folhas são usadas tradicionalmente para regular o ciclo menstrual e aliviar as cólicas uterinas e sintomas da TPM. Atua como um excelente relaxante da musculatura lisa e acalma os nervos.', 'Altamente contraindicada na gravidez (estimulante uterina) e lactação.', '• Chá Regulador Feminino: Coloque 1 colher de sopa de cascas ou folhas de agoniada em 500ml de água e ferva por 10 minutos. Coe e tome morno em pequenas xícaras ao longo do dia, especialmente na semana que antecede a menstruação.', '• Banho de Acalento e Equilíbrio Feminino: Prepare uma decocção fervendo 1 colher de sopa de cascas de agoniada in 1 litro de água por 10 minutos. Coe e despeje do pescoço para baixo para reequilibrar a energia cíclica e trazer sensação de paz interior.', '• Defumação de Liberação de Tensões Psíquicas: Queime cascas ou folhas secas trituradas em brasa. A fumaça atua dispersando sentimentos de aflição, ansiedade crônica e desespero emocional.', '/images/herbs/agoniada.png', 'popular', 'Compêndio de Fitoterapia Popular do Nordeste & Formulário de Fitoterápicos da Anvisa', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(109, 'Algodoeiro', 'algodoeiro', 'Gossypium hirsutum', 'Folha-de-Algodão, Algodão', 'As folhas e a casca da raiz do algodoeiro são utilizadas na medicina tradicional para estimular a produção de leite materno (galactagogo) e auxiliar na regulação de hemorragias uterinas pós-parto, além de possuir propriedades cicatrizantes e anti-inflamatórias.', 'Totalmente contraindicado durante a gestação (pode provocar aborto devido ao efeito estimulante uterino).', '• Infusão Cicatrizante e Reguladora: Use 1 colher de chá de folhas secas de algodoeiro para 1 xícara de água fervente. Deixe abafado por 10 minutos e coe. Beber moderadamente.', '• Banho de Proteção e Aconchego Materno: Ferva 1,5 litros de água com 3 colheres de sopa de folhas de algodoeiro secas. Despeje morno do pescoço para baixo após o banho, mentalizando segurança, suavidade e fortalecimento áurico.', '• Defumação de Suavização e Harmonia Familiar: A queima das folhas secas de algodoeiro espalha uma fumaça de aroma leve e adocicado, ideal para trazer sensação de aconchego, paz e suavizar conflitos e discussões no lar.', '/images/herbs/algodoeiro.png', 'integrative', 'Estudos Etnobotânicos Brasileiros & Tradição de Parteiras do Interior do Brasil', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(110, 'Amora-Miúra', 'amora-miura', 'Morus nigra', 'Folha-de-Amora, Amoreira-Preta', 'Rica em flavonoides e fitoestrogênios, as folhas da amoreira-preta (Amora-Miúra) são as maiores aliadas naturais das mulheres para aliviar as ondas de calor e alterações de humor da menopausa, além de auxiliar no controle dos níveis de açúcar no sangue.', 'Consumir com moderação. Indivíduos diabéticos sob medicação devem monitorar a glicose devido ao risco de hipoglicemia.', '• Chá de Amora para Menopausa: Adicione 1 colher de sopa de folhas secas de amora em 1 litro de água fervente. Abafe por 10 minutos, coe e consuma ao longo do dia em substituição à água.', '• Banho de Brilho Pessoal e Equilíbrio Hormonal: Ferva 2 litros de água e adicione 1 xícara de folhas secas de amora. Deixe abafado até amornar, coe e tome do pescoço para baixo, mentalizando jovialidade, autoconfiança e harmonia hormonal.', '• Defumação de Autoestima e Vibração Feminina: Queime folhas secas de amora em brasa. A fumaça suave purifica a energia de baixa autoestima, auxiliando a restaurar o amor-próprio e o acolhimento emocional.', '/images/herbs/amora-miura.png', 'scientific', 'Estudos sobre Fitoestrogênios da Amoreira (Morus nigra) & Práticas Clínicas de Ginecologia Natural', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(111, 'Angico', 'angico', 'Anadenanthera colubrina', 'Angico-Preto, Cambuí, Arapiraca', 'Árvore medicinal brasileira cuja casca é riquíssima em taninos e mucilagens. É historicamente utilizada como um poderoso tônico respiratório, expectorante e cicatrizante de feridas e tosses crônicas ou bronquites.', 'Evitar o uso oral por gestantes, lactantes e por crianças menores de 6 anos.', '• Xarope Caseiro ou Decocção de Expectorante: Ferva 1 colher de sopa de cascas secas de angico em 500ml de água por 15 minutos. Coe, misture mel se desejar e tome 1 colher de sopa de 3 em 3 horas para tosses intensas.', '• Banho de Fortalecimento Físico e Espiritual: Ferva 2 colheres de sopa de casca de angico triturada em 2 litros de água por 15 minutos. Coe, deixe amornar e despeje dos ombros para baixo após o banho higiênico, mentalizando vigor, força interior e proteção áurica.', '• Defumação de Afastamento de Energias Densas: As cascas de angico queimadas em brasa produzem uma fumaça amadeirada forte, excelente para banir influências espirituais negativas e limpar ambientes sobrecarregados.', '/images/herbs/angico.png', 'popular', 'Tradição Oral de Ervanários do Cerrado & Farmacopeia Popular do Brasil', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(112, 'Araçá', 'araca', 'Psidium cattleianum', 'Araçazeiro, Araçá-Vermelho', 'Parente silvestre da goiabeira, o araçazeiro possui folhas riquíssimas em óleos essenciais e taninos. Suas folhas têm potente ação antibacteriana, antidiarreica e cicatrizante, sendo muito usadas para bochechos em caso de inflamações na boca e garganta.', 'Evitar a ingestão em altas doses em caso de constipação severa devido ao seu alto teor de taninos adstringentes.', '• Infusão Antisséptica Bucal (Bochecho/Gargarejo): Coloque 1 colher de sopa de folhas de araçá picadas em 1 xícara de água fervente. Abafe por 10 minutos, coe e faça gargarejos 3 vezes ao dia.', '• Banho de Limpeza e Fechamento de Corpo: Ferva 1,5 litros de água com 5 ramos frescos de araçá por 5 minutos. Coe e use do pescoço para baixo após o banho higiênico para afastar energias intrusas e selar os canais energéticos protetores.', '• Defumação de Consolidação e Firmeza Espiritual: Queime folhas secas de araçá. A fumaça herbal densa ajuda a centralizar a mente, trazendo estabilidade e foco espiritual após períodos de dispersão e confusão.', '/images/herbs/araca.png', 'integrative', 'Estudos Farmacológicos de Plantas Nativas do Sul do Brasil & Tradição Indígena Guarani', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(113, 'Aroeira-Salsa', 'aroeira-salsa', 'Schinus molle', 'Anacahuita, Aroeira-Mole, Pimenteira-Bastarda', 'Árvore de folhas delicadas e pendentes com aroma balsâmico e resinoso marcante. Suas folhas possuem propriedades antissépticas, antifúngicas, digestivas e combatem infecções urinárias e respiratórias.', 'Contraindicado para gestantes e pessoas com pele altamente sensível ou predisposição a dermatite de contato.', '• Infusão Respiratória e Antisséptica: Use 1 colher de chá de folhas secas de aroeira-salsa para 1 xícara de água fervente. Deixe abafado por 10 minutos e coe. Tomar 2 vezes ao dia em resfriados.', '• Banho de Limpeza Astral e Descarrego Suave: Ferva 2 litros de água e acrescente 3 ramos frescos de aroeira-salsa. Abafe por 15 minutos. Banhe-se do pescoço para baixo sentindo a dissolução de larvas astrais e energias estagnadas de inveja e mau-olhado.', '• Defumação de Blindagem e Proteção Psíquica: Queime folhas e resinas de aroeira-salsa em carvão em brasa. A fumaça aromática resinosa cria um escudo protetor no ambiente contra ataques psíquicos e pensamentos hostis.', '/images/herbs/aroeira-salsa.png', 'integrative', 'Tradição de Proteção Energética do Sul do Brasil & Estudos de Óleo Essencial (Schinus molle)', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(114, 'Avenca', 'avenca', 'Adiantum capillus-veneris', 'Cabelo-de-Vênus, Avenca-Comum', 'Delicada samambaia conhecida tradicionalmente por sua ação expectorante, calmante da tosse, diurética e benéfica para a saúde capilar. Contém flavonoides e triterpenos que auxiliam nas vias respiratórias congestionadas.', 'Evitar o uso por grávidas, lactantes e pessoas com gastrite severa.', '• Chá Expectorante de Avenca: Coloque 1 colher de sopa de folhas de avenca secas em 1 xícara de água fervente. Abafe por 10 minutos, coe e beba quente para aliviar tosses secas e resfriados.', '• Banho de Leveza e Liberação de Tensões Mentais: Ferva 1,5 litros de água e junte um punhado de avenca seca (ou ramos frescos). Cubra e deixe amornar. Jogue do pescoço para baixo sentindo a mente se esvaziar de preocupações repetitivas e obsessivas.', '• Defumação de Leveza e Clareza de Pensamentos: A avenca seca queimada espalha uma fumaça sutil e limpa que quebra padrões de pensamentos circulares, favorecendo o desbloqueio mental e a criatividade.', '/images/herbs/avenca.png', 'popular', 'Formulário Fitoterápico da Farmacopeia Brasileira & Sabedoria Popular de Jardinagem e Cura', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(115, 'Azedinha', 'azedinha', 'Rumex acetosa', 'Azeda, Erva-Vinagreira, Sorrel', 'Planta alimentícia não convencional (PANC) e medicinal, rica em vitamina C e ferro. Possui sabor ácido característico e propriedades depurativas, diuréticas e refrescantes, auxiliando a combater a anemia e a fadiga física.', 'Contraindicado em pessoas com histórico de cálculos renais de oxalato de cálcio, devido ao seu elevado teor de ácido oxálico.', '• Uso Culinário e Chá Depurativo: Consumir folhas frescas picadas em saladas ou preparar infusão rápida com 4 folhas picadas para 1 xícara de água fervente por 5 minutos.', '• Banho de Revitalização Física e Ânimo: Ferva 1 litro de água. Apague o fogo e adicione 1 xícara de folhas frescas de azedinha. Abafe até amornar e coe. Despeje do pescoço para baixo pela manhã para atrair disposição física e renovar a vitalidade.', '• Defumação de Revitalização Mental: Queime folhas secas. A fumaça suave limpa a apatia mental do ambiente e estimula a clareza e o ânimo dos moradores.', '/images/herbs/azedinha.png', 'scientific', 'Guia de PANCs do Brasil (Kinupp et al.) & Monografias Botânicas Europeias', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(116, 'Bálsamo', 'balsamo', 'Sedum dendroideum', 'Bálsamo-do-Gileade', 'Planta suculenta amplamente cultivada em jardins brasileiros por sua extraordinária ação cicatrizante, anti-inflamatória e protetora gástrica. Seu suco é usado para úlceras e gastrite.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Suco fresco das folhas ou infusão leve.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/balsamo.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(117, 'Baunilha', 'baunilha', 'Vanilla planifolia', 'Vanilla', 'Orquídea trepadeira cujas favas secas e curadas fornecem um aroma doce e reconfortante amplamente usado como relaxante do sistema nervoso.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Uso da fava em infusão ou culinária.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/baunilha.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(118, 'Bétula', 'betula', 'Betula pendula', 'Vassoura-de-Bruxa', 'Árvore de casca branca cujas folhas são ricas em flavonoides, excelentes para eliminação de toxinas e combate ao reumatismo e gota.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/betula.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(119, 'Bicuíba', 'bicuiba', 'Virola sebifera', 'Ucuúba, Virola', 'Árvore da Amazônia cujas sementes e cascas fornecem gordura e resina cicatrizantes e fortemente anti-inflamatórias.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção das cascas ou aplicação tópica de óleos.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/bicuiba.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(120, 'Buchinha-do-Norte', 'buchinha-do-norte', 'Luffa operculata', 'Cabacinha, Purga-de-Gentio', 'Fruto seco fibroso usado tradicionalmente no tratamento de sinusite aguda severa por sua forte ação descongestionante de vias aéreas.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Uso estritamente externo e diluído em inalações sob cuidado extremo.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/buchinha-do-norte.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(121, 'Cabelo-de-Milho', 'cabelo-de-milho', 'Zea mays', 'Estigma-de-Milho, Barba-de-Milho', 'Os estiletes e estigmas do milho são um dos diuréticos mais tradicionais e suaves da fitoterapia brasileira, aliviando infecções urinárias e cistite.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão morna ao longo do dia.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/cabelo-de-milho.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(122, 'Cacau', 'cacau', 'Theobroma cacao', 'Cacauzeiro', 'Fruto sagrado asteca e maia. Rico em teobromina e polifenóis, estimula a produção de serotonina, combatendo o desânimo e a fadiga física.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Chá das cascas da semente ou pó de cacau puro.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/cacau.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13');
INSERT INTO `herbs` (`id`, `name`, `slug`, `scientific_name`, `aliases`, `description`, `contraindications`, `how_to_use`, `bath_instructions`, `incense_usage`, `image_path`, `source_type`, `sources`, `created_at`, `updated_at`) VALUES
(123, 'Café', 'cafe', 'Coffea arabica', 'Cafeeiro', 'O grão de café é um potente estimulante do sistema nervoso central e cognitivo, além de conter antioxidantes excelentes contra a fadiga.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão ou decocção dos grãos torrados.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/cafe.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(124, 'Calumba', 'calumba', 'Jateorhiza palmata', 'Raiz-de-Calumba', 'Raiz medicinal de sabor intensamente amargo, usada tradicionalmente para combater diarreias, vômitos e fraqueza gástrica.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção leve da raiz seca.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/calumba.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(125, 'Camapu', 'camapu', 'Physalis angulata', 'Físalis, Balãozinho', 'Erva silvestre cujas raízes e ramos contêm fisalinas com propriedades anti-inflamatórias que auxiliam na regeneração neurológica.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Chá das raízes ou consumo do fruto.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/camapu.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(126, 'Cardamomo', 'cardamomo', 'Elettaria cardamomum', 'Cardamomo-Verdadeiro', 'Especiaria oriental de aroma refinado e picante, conhecida por suas excelentes propriedades digestivas e carminativas.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Sementes mastigadas ou em infusão aromática.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/cardamomo.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(127, 'Catuaba', 'catuaba', 'Trichilia catigua', 'Catuaba-Verdadeira, Alecrim-do-Campo', 'Famoso estimulante e tônico físico do folclore brasileiro. Usada contra cansaço cerebral, memória fraca e esgotamento nervoso.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção das cascas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/catuaba.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(128, 'Caxeta', 'caxeta', 'Tabebuia cassinoides', 'Pau-de-Tamanco, Tabebuia', 'Cascas da árvore usadas tradicionalmente no litoral do Brasil para tratar febres, fraquezas musculares e inflamações.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Chá de casca triturada.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/caxeta.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(129, 'Centaurea', 'centaurea', 'Centaurium erythraea', 'Fel-da-Terra, Centáurea-Menor', 'Planta medicinal de amargor tradicional, estimulante gástrico excepcional que combate a falta de apetite e má digestão.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão das flores secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/centaurea.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(130, 'Cerejeira-da-Terra', 'cerejeira-da-terra', 'Prunus avium', 'Pedúnculos-de-Cereja, Cereja', 'Os cabinhos da cereja são altamente diuréticos, promovendo o combate à retenção urinária e depurando o sangue.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção dos pedúnculos secos.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/cerejeira-da-terra.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(131, 'Cipó-Caboclo', 'cipo-caboclo', 'Davilla rugosa', 'Cipó-de-Carijó, Folha-de-Esfolar', 'Cipó brasileiro com potente ação anti-inflamatória e analgésica nas articulações, reumatismo e inchaços.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Chá de folhas ou compressas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/cipo-caboclo.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(132, 'Cipó-Cruz', 'cipo-cruz', 'Chiococca alba', 'Cainca, Raiz-de-Cobra', 'Cipó de raiz aromática usada tradicionalmente contra picadas de cobras, reumatismo e diurese severa.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção da raiz.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/cipo-cruz.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(133, 'Cipó-Gato', 'cipo-gato', 'Mimosa filipes', 'Unha-de-Gato-Nativa', 'Cipó de espinhos curvos usado na medicina popular para combater inflamações crônicas e infecções urinárias.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Chá de folhas ou cascas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/cipo-gato.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(134, 'Cipó-Suma', 'cipo-suma', 'Anchietea salutaris', 'Cipó-Catarina, Suma', 'Excelente depurador sanguíneo, muito utilizado contra dermatites crônicas, psoríase, eczemas e coceiras na pele.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção dos ramos secos.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/cipo-suma.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(135, 'Coentro', 'coentro', 'Coriandrum sativum', 'Coriandro', 'Folhas e sementes ricas em linalol, excelentes agentes digestivos, carminativos e quelantes naturais de metais pesados.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Folhas frescas ou sementes em infusão.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/coentro.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(136, 'Cominho', 'cominho', 'Cuminum cyminum', 'Cominho-Verdadeiro', 'Sementes aromáticas digestivas tradicionais, que evitam gases intestinais, cólicas estomacais e estimulam as enzimas digestivas.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de sementes esmagadas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/cominho.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(137, 'Congonha-de-Bugre', 'congonha-de-bugre', 'Rudgea viburnoides', 'Chá-de-Bugre, Porangaba', 'Erva diurética e cardioprotetora tradicional, muito usada em regimes de controle de peso e eliminação de líquidos.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Chá de folhas secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/congonha-de-bugre.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(138, 'Cordão-de-Frade', 'cordao-de-frade', 'Leonotis nepetifolia', 'Rubim, Cordão-de-São-Francisco', 'Planta medicinal excelente para problemas respiratórios, asma, bronquite e dores reumáticas articulares.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de flores e folhas secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/cordao-de-frade.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(139, 'Corticeira-do-Banhado', 'corticeira-do-banhado', 'Erythrina crista-galli', 'Sananduva', 'Árvore de flores vermelhas cuja casca possui alcaloides com propriedades sedativas intensas e relaxantes musculares.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção de casca seca.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/corticeira-do-banhado.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(140, 'Erva-Botão', 'erva-botao', 'Eclipta prostrata', 'Agrião-do-Brejo, Eclipta', 'Famosa erva depurativa do fígado e rins, muito utilizada na medicina tradicional indiana (Bhringraj) e folclore brasileiro.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/erva-botao.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(141, 'Erva-de-Passarinho', 'erva-de-passarinho', 'Struthanthus vulgaris', 'Erva-Laranja', 'Planta hemiparasita com propriedades expectorantes e anti-inflamatórias, usada tradicionalmente em afecções pulmonares.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas picadas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/erva-de-passarinho.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(142, 'Erva-de-Santana', 'erva-de-santana', 'Adenostemma lavenia', 'Adenostema', 'Erva tradicionalmente usada no Norte e Nordeste para combater febres, resfriados e dores reumáticas articulares.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Chá de folhas frescas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/erva-de-santana.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(143, 'Escovinha', 'escovinha', 'Centaurea cyanus', 'Ciano, Fidalguinhos', 'Lindas flores azuis com propriedades calmantes oculares (usadas em compressas) e tônicas renais leves.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de flores secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/escovinha.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(144, 'Espinho-de-Cigano', 'espinho-de-cigano', 'Acanthospermum hispidum', 'Retirante, Cabeça-de-Boi', 'Erva rasteira medicinal do cerrado brasileiro com ação expectorante e febrífuga em gripes fortes.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Chá das folhas e frutos secos.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/espinho-de-cigano.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(145, 'Esporeira', 'esporeira', 'Delphinium consolida', 'Delfínio', 'Planta de uso externo tradicional para eliminar piolhos e sarna devido a propriedades inseticidas naturais.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção para lavagem capilar externa apenas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/esporeira.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(146, 'Eupatório', 'eupatorio', 'Eupatorium cannabinum', 'Trevo-Cervino', 'Planta tradicional europeia e brasileira usada como febrífuga, imunoestimulante suave e protetora hepática.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de flores e folhas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/eupatorio.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(147, 'Fedegoso', 'fedegoso', 'Senna occidentalis', 'Ibixuma, Café-de-Negro', 'Sementes torradas e raízes usadas tradicionalmente contra febres, distúrbios de fígado e infecções urinárias.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de raízes secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/fedegoso.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(148, 'Flor-de-Merenda', 'flor-de-merenda', 'Senna macranthera', 'Pau-Fava, Merenda', 'Planta ornamental e medicinal usada tradicionalmente como depurativa e laxante leve em chás do sertão.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão suave de folhas secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/flor-de-merenda.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(149, 'Gamiova', 'gamiova', 'Geonoma gamiova', 'Palmeira-Gamiova', 'Palmeira cujas folhas são usadas tradicionalmente no sul como adstringente e tônico estomacal.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão leve.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/gamiova.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(150, 'Genciana', 'genciana', 'Gentiana lutea', 'Raiz-de-Genciana', 'O amargo mais potente da fitoterapia botânica mundial. Estimula apetite e secreções ácidas do estômago.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção muito leve de raiz seca.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/genciana.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(151, 'Gervão-Roxo', 'gervao-roxo', 'Stachytarpheta cayennensis', 'Gervão, Orgão', 'Excelente tônico digestivo, antiasmático, diurético e cicatrizante do estômago (contra gastrite nervosa).', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/gervao-roxo.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(152, 'Grama-Tepinho', 'grama-tepinho', 'Cynodon dactylon', 'Capim-D Bermuda, Grama', 'As raízes dessa gramínea são altamente diuréticas e calmantes urinárias, aliviando infecções de dutos renais.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção de raízes picadas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/grama-tepinho.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(153, 'Grindélia', 'grindelia', 'Grindelia robusta', 'Planta-de-Alcatrão', 'Planta rica em resinas medicinais expectorantes, calmantes da asma espasmódica e bronquite.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão leve.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/grindelia.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(154, 'Guabiroba', 'guabiroba', 'Campomanesia xanthocarpa', 'Gabiroba', 'Folhas do fruto silvestre ricas em óleos essenciais, úteis contra diarreia severa, reumatismo e colesterol.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/guabiroba.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(155, 'Guaimbé', 'guaimbe', 'Philodendron bipinnatifidum', 'Imbé', 'Uso externo tradicional de suas folhas em compressas para aliviar dores reumáticas musculares.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Uso estritamente externo e cutâneo.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/guaimbe.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(156, 'Guajuveira', 'guajuveira', 'Patagonula americana', 'Guajuvira', 'Cascas usadas tradicionalmente na medicina do Sul do Brasil como anti-inflamatório e adstringente de pele.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção para compressas tópicas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/guajuveira.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(157, 'Imbaúba', 'imbauba', 'Cecropia peltata', 'Embaúba, Árvore-da-Preguiça', 'Planta medicinal com forte ação cardiotônica, diurética e expectorante, usada para acalmar palpitações cardíacas.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/imbauba.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(158, 'Inhame-Selvagem', 'inhame-selvagem', 'Dioscorea villosa', 'Wild Yam', 'Raiz rica em diosgenina (precursor hormonal natural) usada tradicionalmente para equilibrar hormônios femininos.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão leve ou creme transdérmico.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/inhame-selvagem.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(159, 'Ipecacuanha', 'ipecacuanha', 'Carapichea ipecacuanha', 'Ipeca, Poaia', 'Famosa raiz amazônica com fortíssimo efeito expectorante em doses mínimas e emético (provoca vômito) em doses altas.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Uso sob extrema cautela farmacológica.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/ipecacuanha.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(160, 'Jaborandi', 'jaborandi', 'Pilocarpus jaborandi', 'Jaborandi-Legítimo', 'Folhas ricas em pilocarpina, alcaloide que estimula intensamente as glândulas salivares, suor e fortifica a raiz do cabelo.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Tônico capilar externo ou chá sob dosagem estrita.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/jaborandi.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(161, 'Jacarandá', 'jacaranda', 'Jacaranda mimosifolia', 'Jacarandá-Mimoso', 'Folhas e cascas com propriedades antissépticas fortes, úteis para lavar feridas crônicas e eczemas na pele.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção para banhos tópicos.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/jacaranda.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(162, 'Jambolão', 'jambolao', 'Syzygium cumini', 'Jambo, Jambeiro', 'Cascas e sementes usadas tradicionalmente com sucesso no controle complementar do diabetes devido à ação hipoglicemiante.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas ou pó das sementes secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/jambolao.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(163, 'Jasmin-Ganga', 'jasmin-ganga', 'Jasminum officinale', 'Jasmim-Branco', 'Flores aromáticas de efeito altamente relaxante emocional, ansiolítico suave e calmante do sistema nervoso.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão aromática das flores secas antes de dormir.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/jasmin-ganga.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(164, 'Jatobá', 'jatoba', 'Hymenaea courbaril', 'Jatobazeiro, Copal', 'Casca e seiva ricas em resinas balsâmicas que fortalecem o sistema respiratório, combatem a asma e trazem vigor físico.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção das cascas duras.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/jatoba.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(165, 'Juá-de-Capote', 'jua-de-capote', 'Physalis pubescens', 'Camapu-Miúdo', 'Planta medicinal de frutos envoltos em casca de papel, diurética e depurativa do fígado.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Chá de folhas ou consumo do fruto fresco.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/jua-de-capote.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(166, 'Lúpulo', 'lupulo', 'Humulus lupulus', 'Hortelã-do-Lobo', 'Flores femininas ricas em lupulina e flavonoides com ação sedativa intensa, ansiolítica extraordinária e promotora do sono.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão suave dos cones secos.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/lupulo.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(167, 'Língua-de-Vaca', 'lingua-de-vaca', 'Chaptalia nutans', 'Erva-de-Sangue, Arnica-de-Terreiro', 'Folhas cicatrizantes de feridas, adstringentes intestinais em diarreias e calmantes pulmonares.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/lingua-de-vaca.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(168, 'Macela-Galega', 'macela-galega', 'Chamaemelum nobile', 'Camomila-Romana', 'Flores calmantes estomacais de sabor levemente mais amargo que a camomila-comum, excelentes contra indigestão e estresse.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de flores secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/macela-galega.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(169, 'Mandacaru', 'mandacaru', 'Cereus jamacaru', 'Cardeiro', 'Cacto do semiárido brasileiro cujo broto interno é altamente diurético, refrescante e cardiotônico leve.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção da polpa interna.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/mandacaru.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(170, 'Maricá', 'marica', 'Mimosa bimucronata', 'Espinheiro', 'Cascas usadas tradicionalmente na medicina popular como anti-inflamatório, cicatrizante e adstringente de garganta.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Gargarejo da decocção.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/marica.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(171, 'Marmelada-de-Cachorro', 'marmelada-de-cachorro', 'Alibertia edulis', 'Marmelada', 'Folhas usadas tradicionalmente para controle de febres altas, além de ser antioxidante e tônica.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão das folhas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/marmelada-de-cachorro.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(172, 'Mulungu-do-Litoral', 'mulungu-do-litoral', 'Erythrina speciosa', 'Mulungu-Vermelho', 'Espécie de mulungu costeira com potente efeito calmante, hipnótico suave de regulação do sono e relaxante de ansiedade.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção da casca dos ramos.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/mulungu-do-litoral.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(173, 'Mutamba', 'mutamba', 'Guazuma ulmifolia', 'Mutambo, Guaxuma', 'Cascas e folhas usadas tradicionalmente no combate à queda de cabelo, e oralmente como adstringente e antiviral natural.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Tônico capilar externo ou decocção para ingestão.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/mutamba.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(174, 'Noni', 'noni', 'Morinda citrifolia', 'Noni-da-Polinésia', 'Fruto de forte aroma exótico, cujas folhas e polpa são estudadas por sua forte ação imunomoduladora e antioxidante.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Uso oral moderado da infusão de folhas secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/noni.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(175, 'Noz-Moscada', 'noz-moscada', 'Myristica fragrans', 'Moscadeira', 'Semente medicinal aromática estimulante da digestão e calmante mental em doses mínimas. Espasmolítica natural.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Pó ralado finamente em infusões culinárias.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/noz-moscada.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(176, 'Óleo-Copaíba', 'oleo-copaiba', 'Copaifera officinalis', 'Bálsamo-de-Copaíba, Copaíba', 'Óleo-resina extraído do tronco da copaibeira na Amazônia, considerado o maior anti-inflamatório e antibiótico natural da floresta.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Uso interno de gotas ou aplicação externa em feridas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/oleo-copaiba.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13');
INSERT INTO `herbs` (`id`, `name`, `slug`, `scientific_name`, `aliases`, `description`, `contraindications`, `how_to_use`, `bath_instructions`, `incense_usage`, `image_path`, `source_type`, `sources`, `created_at`, `updated_at`) VALUES
(177, 'Orelha-de-Onça', 'oleo-onca', 'Tibouchina holosericea', 'Quaresmeira-Aveludada', 'Folhas aveludadas usadas em banhos de assento para tratar hemorroidas e infecções na pele de forma tradicional.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Banhos tópicos da decocção.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/oleo-onca.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(178, 'Orégano', 'oregano', 'Origanum vulgare', 'Manjerona-Silvestre', 'Riquíssimo em carvacrol e timol, o orégano é um potente antifúngico, digestivo, carminativo e expectorante.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/oregano.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(179, 'Pau-Ferro', 'pau-ferro', 'Libidibia ferrea', 'Jucá, Jacá', 'Árvore medicinal de madeira dura cujas cascas e vagens são usadas como potente anti-inflamatório, cicatrizante e antigripal.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção de cascas ou vagens.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/pau-ferro.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(180, 'Pau-Pereira', 'pau-pereira', 'Geissospermum laeve', 'Pereira', 'Casca extremamente amarga usada no folclore brasileiro para curar febres persistentes, malária e indigestão crônica.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção de casca seca.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/pau-pereira.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(181, 'Pau-Tenente', 'pau-tenente', 'Quassia amara', 'Quássia, Pau-Amargo', 'Excepcional amargo medicinal contra parasitas intestinais, estimulante digestivo e regulador da digestão lenta.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão rápida das lascas de madeira.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/pau-tenente.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(182, 'Pé-de-Galinha', 'pe-de-galinha', 'Eleusine indica', 'Capim-Pé-de-Galinha', 'Grama medicinal refrescante usada em chás rústicos para acalmar febres intestinais, diarreias e inflamações renais.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção de toda a planta.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/pe-de-galinha.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(183, 'Peltóforo', 'peltoforo', 'Peltophorum dubium', 'Canafístula, Angico-Amarelo', 'Cascas usadas tradicionalmente como depurativo, antisséptico e no alívio de inflamações na garganta.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Gargarejos do chá.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/peltoforo.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(184, 'Picão-Branco', 'picao-branco', 'Galinsoga parviflora', 'Fazendeiro, Botão-de-Ouro', 'Planta medicinal de hortas usada em chás cicatrizantes estomacais, além de ser depurativa leve de toxinas.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/picao-branco.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(185, 'Pimenta-de-Macaco', 'pimenta-de-macaco', 'Xylopia aromatica', 'Pimenta-do-Sertão', 'Sementes aromáticas usadas no cerrado como tônico estomacal, digestivo e estimulante geral.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção leve.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/pimenta-de-macaco.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(186, 'Pindaíba', 'pindaiba', 'Xylopia brasiliensis', 'Pindaíba-Preta', 'Cascas e frutos aromáticos usados tradicionalmente como estimulantes circulatórios e antigripais.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão leve.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/pindaiba.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(187, 'Pinheiro-do-Paraná', 'pinheiro-do-parana', 'Araucaria angustifolia', 'Araucária, Pinhão', 'A casca e as acículas do pinheiro são usadas em xaropes e inalações rústicas para combater a sinusite e bronquites.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Inalação do vapor da decocção.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/pinheiro-do-parana.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(188, 'Pitanga', 'pitanga', 'Eugenia uniflora', 'Pitangueira', 'As folhas da pitangueira são riquíssimas em óleos essenciais digestivos e anti-inflamatórios, excelentes para cólicas e diarreia.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas frescas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/pitanga.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(189, 'Poejo-Nativo', 'poejo-nativo', 'Cunila menthoides', 'Poejo-do-Campo-Sul', 'Espécie de poejo nativo do Sul com delicioso aroma mentolado, excelente expectorante, antigripal e calmante da tosse.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/poejo-nativo.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(190, 'Quaresmeira', 'quaresmeira', 'Pleroma granulosum', 'Flor-de-Quaresma', 'Folhas usadas tradicionalmente em banhos de assento cicatrizantes e decocções leves de ação adstringente e antisséptica.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/quaresmeira.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(191, 'Quina', 'quina', 'Cinchona officinalis', 'Quina-Amarela, Casca-Sagrada', 'Famosa casca rica em quinina, o maior febrífugo e antimalárico natural da história da medicina botânica mundial.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção leve sob dosagem estrita.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/quina.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(192, 'Quebra-Arado', 'quebra-arado', 'Psychotria carthagenensis', 'Erva-de-Rato', 'Usada na medicina popular do interior como depurativo, antisséptico e no tratamento de tosses de fundo nervoso.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão suave.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/quebra-arado.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(193, 'Rabanete-Silvestre', 'rabanete-silvestre', 'Raphanus raphanistrum', 'Saramago', 'Planta medicinal rica em enxofre e óleos mostarda, excelente depurativa do fígado e estimulante biliar.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Chá de folhas frescas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/rabanete-silvestre.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(194, 'Rosa-Branca', 'rosa-branca', 'Rosa alba', 'Rosa-de-Cheiro', 'As pétalas de rosa branca têm ação cicatrizante e calmante, muito usadas em colírios populares e banhos espirituais de purificação.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão das pétalas secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/rosa-branca.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(195, 'Rosa-Mosqueta', 'rosa-mosqueta', 'Rosa rubiginosa', 'Rosa-Silvestre', 'Famosa por seu óleo altamente regenerador cutâneo de cicatrizes e estrias devido ao alto teor de ácidos graxos essenciais.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Aplicação do óleo prensado a frio.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/rosa-mosqueta.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(196, 'Salsinha', 'salsinha', 'Petroselinum crispum', 'Salsa-de-Jardim', 'Riquíssima em ferro e vitaminas. As sementes e folhas são diuréticas excepcionais e reguladoras menstruais.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão rápida de folhas frescas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/salsinha.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(197, 'Samambaia', 'samambaia', 'Pteridium aquilinum', 'Feto-Macho', 'Cascas da raiz e folhas usadas no folclore como vermífugo potente e em banhos rústicos de descarrego.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Banhos externos e uso oral estritamente moderado.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/samambaia.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(198, 'Sangue-de-Dragão', 'sangue-de-dragao', 'Croton lechleri', 'Seiva-de-Dragão', 'Seiva vermelha viscosa com extraordinário poder cicatrizante, regenerador celular da pele e anti-inflamatório gastrointestinal.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Uso interno diluído ou aplicação externa direta de gotas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/sangue-de-dragao.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(199, 'Sapucainha', 'sapucainha', 'Carpotroche brasiliensis', 'Pau-de-Lepra', 'Sementes tradicionais com óleo curativo dermatológico, historicamente usado contra sarna e eczemas severos.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Aplicação tópica do óleo.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/sapucainha.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(200, 'Serpão', 'serpao', 'Thymus serpyllum', 'Tomilho-Silvestre', 'Erva aromática excelente contra tosse seca, bronquites e cólicas intestinais devido ao seu alto teor de timol.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/serpao.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(201, 'Sete-Sangrias', 'sete-sangrias', 'Cuphea carthagenensis', 'Erva-de-Sangue-Popular', 'Famoso depurador do sangue na medicina popular do Sul. Usado contra hipertensão leve, colesterol e problemas de pele.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/sete-sangrias.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(202, 'Sucupira-Branca', 'sucupira-branca', 'Pterodon emarginatus', 'Fava-de-Sucupira', 'Favas ricas em óleos anti-inflamatórios e analgésicos extraordinários, famosas contra artrite, artrose e dores na garganta.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção da fava quebrada ou óleo.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/sucupira-branca.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(203, 'Taiuiá', 'taiuia', 'Cayaponia tayuya', 'Cabeça-de-Negro, Abóbora-do-Mato', 'Raiz medicinal de amargor severo com potente ação analgésica nas articulações, depurativa e antirreumática.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção de raiz triturada.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/taiuia.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(204, 'Taioba', 'taioba', 'Xanthosoma sagittifolium', 'Taioba-Mansa', 'Folhas grandes depurativas do sangue e ricas em ferro. Devem ser cozidas para eliminar cristais de oxalato de cálcio.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Consumo das folhas bem cozidas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/taioba.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(205, 'Tamarindo', 'tamarindo', 'Tamarindus indica', 'Tamarindeiro', 'A polpa do fruto é um laxante osmótico natural suave, excelente para constipação crônica, de sabor azedo delicioso.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Polpa fresca ou infusão fria.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/tamarindo.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(206, 'Tarumã', 'taruma', 'Vitex montevidensis', 'Maria-Preta', 'Folhas usadas no Sul como potente depurador do sangue, diurético e regulador hormonal suave na menopausa.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/taruma.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(207, 'Tomilho', 'tomilho', 'Thymus vulgaris', 'Poejo-Inglês', 'Poderoso antisséptico pulmonar e digestivo. Alivia espasmos intestinais, tosse, rouquidão e dores de garganta.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de ramos secos.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/tomilho.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(208, 'Tuia', 'tuia', 'Thuja occidentalis', 'Árvore-da-Vida', 'Folhas usadas tradicionalmente para tratar verrugas de forma tópica, e oralmente contra sinusite ao nascer.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Aplicação tópica do óleo ou chá leve.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/tuia.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(209, 'Umbaúba-Vermelha', 'umbauba-vermelha', 'Cecropia hololeuca', 'Embaúba-Branca', 'Espécie de embaúba rica em flavonoides com ação cardiotônica e calmante respiratória excepcional.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão das folhas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/umbauba-vermelha.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(210, 'Urtiga-Maior', 'urtiga-maior', 'Urtica dioica', 'Ortiga', 'Folhas ricas em minerais que combatem o reumatismo, inflamações prostáticas de forma cientificamente validada.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/urtiga-maior.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(211, 'Urucum', 'urucum', 'Bixa orellana', 'Colorau, Bixa', 'Sementes ricas em bixina (antioxidante solar potente), protetoras da pele e úteis na imunidade e digestão.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Pó das sementes na culinária ou chá de folhas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/urucum.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(212, 'Velas-do-Brejo', 'velas-do-brejo', 'Senna alata', 'Mangerioba, Fedegoso-Gigante', 'Folhas usadas tradicionalmente no Norte e Nordeste em banhos terapêuticos contra micoses, sarna e infecções.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Banhos tópicos de decocção das folhas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/velas-do-brejo.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:13', '2026-05-28 03:56:13'),
(213, 'Velame-do-Campo', 'velame-do-campo', 'Croton campestris', 'Velame', 'Excelente depurativo do sangue tradicional, usado contra afecções dermatológicas, eczemas e reumatismo.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/velame-do-campo.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(214, 'Vinca-Menor', 'vinca-menor', 'Vinca minor', 'Pervinca', 'Folhas usadas tradicionalmente para melhorar o fluxo sanguíneo cerebral, concentração e regular a pressão.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão suave de folhas secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/vinca-menor.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(215, 'Violeta', 'violeta', 'Viola odorata', 'Violeta-de-Cheiro', 'Flores e folhas aromáticas com ação expectorante suave, calmante e emoliente pulmonar.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de flores secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/violeta.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(216, 'Xaxim', 'xaxim', 'Cyathea delgadii', 'Samambaiaçu', 'Os brotos jovens da raiz eram usados no passado em xaropes rústicos contra coqueluche e tosse crônica.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção muito leve de broto.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/xaxim.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(217, 'Zimbro', 'zimbro', 'Juniperus communis', 'Junípero', 'Bagas aromáticas ricas em óleos essenciais fortemente diuréticos, antissépticos das vias urinárias e digestivos.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de bagas secas esmagadas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/zimbro.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(218, 'Cardo-Santo', 'cardo-santo', 'Argemone mexicana', 'Cardo-Amarelo', 'Folhas e sementes usadas tradicionalmente contra febres, tosses persistentes e como cicatrizante de feridas.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção leve das folhas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/cardo-santo.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(219, 'Acoro', 'acoro', 'Acorus calamus', 'Cálamo-Aromático', 'Raiz aromática de forte amargor usada tradicionalmente na Ásia e Europa para estimular digestão lenta.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção leve da raiz seca.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/acoro.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(220, 'Alcaparra', 'alcaparra', 'Capparis spinosa', 'Alcaparreira', 'Botões florais com propriedades antioxidantes e anti-inflamatórias fortes que estimulam o apetite.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Botão em conserva ou infusão de folhas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/alcaparra.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(221, 'Agrião-do-Brejo', 'agriao-do-brejo', 'Eclipta alba', 'Erva-Botão-Branco', 'Planta muito similar à erva-botão clássica, com ação tônica do fígado, rins e depuradora de toxinas.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/agriao-do-brejo.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(222, 'Anileira-Verdadeira', 'anileira-verdadeira', 'Indigofera tinctoria', 'Anil, Índigo', 'Planta do anil usada tradicionalmente em purificações espirituais e decocções antissépticas locais.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Banhos espirituais com folhas secas maceradas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/anileira-verdadeira.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(223, 'Aperta-Ruão-Nativo', 'aperta-ruao-nativo', 'Piper aduncum', 'Pimenta-de-Macaco-Fina', 'Folhas e frutos aromáticos adstringentes fortes, úteis para estancar sangramentos, lavar feridas e combater gases.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas secas para banhos ou chá.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/aperta-ruao-nativo.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(224, 'Barba-de-Velho', 'barba-de-velho', 'Tillandsia usneoides', 'Samambaia-de-Árvore', 'Planta epífita fibrosa com propriedades anti-inflamatórias, diuréticas e calmantes das dores articulares.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Chá de toda a planta limpa.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/barba-de-velho.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(225, 'Beldroega', 'beldroega', 'Portulaca oleracea', 'Beldroega-Comum', 'Uma das poucas plantas terrestres riquíssimas em ômega-3, magnésio e cálcio. Depuradora e cicatrizante.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Folhas e talos frescos em saladas ou chá.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/beldroega.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(226, 'Betônica', 'betonica', 'Stachys officinalis', 'Betônia', 'Planta de uso milenar europeu contra cefaleia tensional, ansiedade crônica e congestão respiratória.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de flores secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/betonica.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(227, 'Boca-de-Leão', 'boca-de-leao', 'Antirrhinum majus', 'Antirrino', 'Flores usadas tradicionalmente em infusões suaves de propriedades emolientes, calmantes e cicatrizantes.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão suave.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/boca-de-leao.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(228, 'Caité', 'caite', 'Heliconia', 'Caeté', 'Folhas usadas tradicionalmente na mata para envolver remédios naturais ou em decocções locais.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Banhos tópicos de decocção das folhas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/caite.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(229, 'Cará-Moela', 'cara-moela', 'Dioscorea bulbifera', 'Cará-de-Árvore', 'Tubérculo aéreo rico em amidos depurativos do sangue e compostos cicatrizantes uterinos leves.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Consumo cozido ou chá suave de rodelas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/cara-moela.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(230, 'Cipó-Azul', 'cipo-azul', 'Petrea volubilis', 'Viuvinha', 'Cipó lenhoso ornamental cujas cascas e folhas são usadas na cura popular como anti-inflamatório articular.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão leve.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/cipo-azul.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(231, 'Cipó-Insulina', 'cipo-insulina', 'Cissus sicyoides', 'Uva-Brava, Insulina-Vegetal', 'Cipó tradicional amplamente conhecido por sua forte ação auxiliar no controle dos níveis glicêmicos.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas frescas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/cipo-insulina.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14');
INSERT INTO `herbs` (`id`, `name`, `slug`, `scientific_name`, `aliases`, `description`, `contraindications`, `how_to_use`, `bath_instructions`, `incense_usage`, `image_path`, `source_type`, `sources`, `created_at`, `updated_at`) VALUES
(232, 'Coentro-Selvagem', 'coentro-selvagem', 'Eryngium foetidum', 'Coentro-de-Carijó, Chicória-de-Caboclo', 'Folhas aromáticas fortes com potente ação digestiva, sudorífica (combate febres) e calmante de cólicas.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão rápida de folhas frescas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/coentro-selvagem.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(233, 'Erva-Marta', 'erva-marta', 'Senecio jacobaea', 'Senécio', 'Planta de uso externo antigo para limpar feridas crônicas e úlceras na pele devido a taninos adstringentes.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Compressas tópicas externas do chá forte.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/erva-marta.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(234, 'Espada-de-São-Jorge', 'espada-de-sao-jorge', 'Sansevieria trifasciata', 'Sanseviéria', 'Folha fibrosa sagrada e ornamental. Uso exclusivamente ritualístico e externo para banhos espirituais.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Banhos ritualísticos do pescoço para baixo.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/espada-de-sao-jorge.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(235, 'Estévia', 'estevia', 'Stevia rebaudiana', 'Stevia', 'Folhas de sabor doce que regulam os níveis de insulina no sangue de maneira suave e saudável.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Folha triturada para adoçar infusões medicinais.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/estevia.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(236, 'Girassol', 'girassol', 'Helianthus annuus', 'Flor-do-Sol', 'As sementes são ricas em vitamina E, e as pétalas ajudam no combate a gripes intensas e febres.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de pétalas secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/girassol.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(237, 'Lágrima-de-Nossa-Senhora', 'lagrima-de-nossa-senhora', 'Coix lacryma-jobi', 'Capim-Contas', 'As sementes esféricas brancas são diuréticas e calmantes urinárias rústicas de forma tradicional.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção de sementes quebradas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/lagrima-de-nossa-senhora.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(238, 'Manjericão-Limão', 'manjericao-limao', 'Ocimum citriodorum', 'Manjericão-Citral', 'Variedade de manjericão de forte perfume cítrico relaxante. Excelente digestivo e indutor de sono.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas frescas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/manjericao-limao.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(239, 'Sálvia-Branca', 'salvia-branca', 'Salvia apiana', 'White Sage, Sálvia-Sagrada', 'Erva sagrada das tradições nativas americanas, famosa por sua fumaça que purifica ambientes densos.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Queima em defumação direta (smudging) para limpeza áurica.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/salvia-branca.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(240, 'Erva-dos-Gatos', 'erva-dos-gatos', 'Nepeta cataria', 'Catnip, Nêpeta', 'Famosa erva com óleos aromáticos relaxantes para humanos e intensamente estimulantes para felinos.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão leve antes de dormir.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/erva-dos-gatos.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(241, 'Ginseng-Siberiano', 'ginseng-siberiano', 'Eleutherococcus senticosus', 'Eleutero', 'Planta adaptógena potente que aumenta a energia física, foco e imunidade sob estresse extremo.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção da raiz seca.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/ginseng-siberiano.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(242, 'Erva-Mansa', 'erva-mansa', 'Anemopsis californica', 'Yerba Mansa', 'Planta medicinal tradicional americana com potente ação antibacteriana, antifúngica e cicatrizante.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas ou aplicação tópica.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/erva-mansa.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(243, 'Pé-de-Pinto', 'pe-de-pinto', 'Boerhavia diffusa', 'Pega-Pinto, Erva-Tostão', 'Excelente diurético e protetor hepático do folclore brasileiro, depurando os canais urinários.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/pe-de-pinto.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(244, 'Sândalo', 'sandalo', 'Santalum album', 'Madeira-de-Sândalo', 'Madeira aromática sagrada de aroma profundamente relaxante, meditativo e purificador de ambientes.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Queima de lascas ou uso de óleo essencial.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/sandalo.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(245, 'Espirulina', 'espirulina', 'Arthrospira platensis', 'Spirulina, Alga-Azul', 'Superalimento rico em proteínas, ferro e antioxidantes, que atua como excelente revigorante físico.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Consumo do pó diluído em sucos.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/espirulina.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(246, 'Damiána', 'damiana', 'Turnera diffusa', 'Damiana-da-Califórnia', 'Erva aromática estimulante, tônica do sistema nervoso e tradicionalmente conhecida como afrodisíaco natural.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão de folhas secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/damiana.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(247, 'Erva-de-São-Cristóvão', 'erva-de-sao-cristovao', 'Actaea racemosa', 'Cimicífuga, Black Cohosh', 'Planta de uso secular no alívio de cólicas menstruais fortes e no controle do calor da menopausa.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão suave ou extrato sob supervisão.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/erva-de-sao-cristovao.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(248, 'Alcarávia', 'alcaravia', 'Carum carvi', 'Cominho-Armênio, Cariz', 'Sementes digestivas clássicas, excelentes para combater gases intestinais e estimular o apetite infantil.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão leve de sementes esmagadas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/alcaravia.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(249, 'Astrágalo', 'astragalo', 'Astragalus membranaceus', 'Huang Qi', 'Poderosa raiz adaptógena da Medicina Chinesa que fortalece profundamente as defesas imunológicas.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Decocção leve da raiz em fatias.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/astragalo.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14'),
(250, 'Lótus', 'lotus', 'Nelumbo nucifera', 'Lótus-Sagrado', 'Planta aquática venerada no Oriente por suas propriedades calmantes psíquicas, indutoras da paz e meditação.', 'Evitar o uso em gestantes e lactantes. Não consumir de forma contínua por mais de 15 dias sem pausas.', 'Infusão das pétalas ou sementes secas.', '• Banho de Purificação Energética: Prepare 1,5 litros de água fervente. Apague o fogo, adicione 2 colheres de sopa da erva seca, abafe por 10 minutos e coe. Despeje do pescoço para baixo após o banho regulador.', '• Defumação de Equilíbrio de Ambientes: Queime punhados secos da erva sobre carvão vegetal em brasa. Espalhe a fumaça de dentro para fora de casa para harmonizar a atmosfera espiritual.', '/images/herbs/lotus.png', 'popular', 'Mapeamento Fitoenergético Popular & Formulários de Práticas Integrativas do SUS', '2026-05-28 03:56:14', '2026-05-28 03:56:14');

-- --------------------------------------------------------

--
-- Table structure for table `herb_product`
--

CREATE TABLE `herb_product` (
  `id` bigint UNSIGNED NOT NULL,
  `herb_id` bigint UNSIGNED NOT NULL,
  `product_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inventory_movements`
--

CREATE TABLE `inventory_movements` (
  `id` bigint UNSIGNED NOT NULL,
  `itemable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `itemable_id` bigint UNSIGNED NOT NULL,
  `type` enum('in','out') COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int NOT NULL,
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order_id` bigint UNSIGNED DEFAULT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `inventory_movements`
--

INSERT INTO `inventory_movements` (`id`, `itemable_type`, `itemable_id`, `type`, `quantity`, `reason`, `order_id`, `user_id`, `notes`, `created_at`, `updated_at`) VALUES
(1, 'App\\Modules\\Ecommerce\\Models\\Product', 42, 'out', 1, 'sale', 1, NULL, NULL, '2026-05-21 03:10:52', '2026-05-21 03:10:52'),
(2, 'App\\Modules\\Ecommerce\\Models\\Product', 41, 'out', 1, 'sale', 2, NULL, NULL, '2026-05-21 03:48:56', '2026-05-21 03:48:56'),
(3, 'App\\Modules\\Ecommerce\\Models\\Product', 42, 'out', 1, 'sale', 2, NULL, NULL, '2026-05-21 03:48:56', '2026-05-21 03:48:56'),
(4, 'App\\Modules\\Ecommerce\\Models\\Product', 36, 'out', 1, 'sale', 3, NULL, NULL, '2026-05-21 03:51:02', '2026-05-21 03:51:02'),
(5, 'App\\Modules\\Ecommerce\\Models\\Product', 40, 'out', 1, 'sale', 3, NULL, NULL, '2026-05-21 03:51:02', '2026-05-21 03:51:02'),
(6, 'App\\Modules\\Ecommerce\\Models\\Product', 36, 'out', 1, 'sale', 4, NULL, NULL, '2026-05-21 04:06:14', '2026-05-21 04:06:14'),
(7, 'App\\Modules\\Ecommerce\\Models\\Product', 43, 'out', 1, 'sale', 5, NULL, NULL, '2026-05-21 04:08:23', '2026-05-21 04:08:23'),
(8, 'App\\Modules\\Ecommerce\\Models\\Product', 40, 'out', 2, 'sale', 5, NULL, NULL, '2026-05-21 04:08:23', '2026-05-21 04:08:23'),
(9, 'App\\Modules\\Ecommerce\\Models\\Product', 37, 'out', 1, 'sale', 5, NULL, NULL, '2026-05-21 04:08:23', '2026-05-21 04:08:23'),
(10, 'App\\Modules\\Ecommerce\\Models\\Product', 35, 'out', 1, 'sale', 5, NULL, NULL, '2026-05-21 04:08:23', '2026-05-21 04:08:23'),
(11, 'App\\Modules\\Ecommerce\\Models\\Product', 40, 'out', 1, 'sale', 6, NULL, NULL, '2026-05-21 04:10:19', '2026-05-21 04:10:19'),
(12, 'App\\Modules\\Ecommerce\\Models\\Product', 37, 'out', 1, 'sale', 7, NULL, NULL, '2026-05-21 13:13:55', '2026-05-21 13:13:55'),
(13, 'App\\Modules\\Ecommerce\\Models\\Product', 40, 'out', 1, 'sale', 8, NULL, NULL, '2026-05-22 01:44:47', '2026-05-22 01:44:47'),
(14, 'App\\Modules\\Ecommerce\\Models\\Product', 41, 'out', 1, 'sale', 8, NULL, NULL, '2026-05-22 01:44:47', '2026-05-22 01:44:47'),
(15, 'App\\Modules\\Ecommerce\\Models\\Product', 35, 'out', 1, 'sale', 8, NULL, NULL, '2026-05-22 01:44:47', '2026-05-22 01:44:47'),
(16, 'App\\Modules\\Ecommerce\\Models\\Product', 44, 'in', 2, 'production', NULL, 1, 'Produção OP: OP-2026-0001', '2026-05-26 17:43:21', '2026-05-26 17:43:21'),
(17, 'App\\Modules\\Ecommerce\\Models\\Product', 45, 'in', 2, 'production', NULL, 1, 'Produção OP: OP-2026-0002', '2026-05-26 18:05:17', '2026-05-26 18:05:17'),
(18, 'App\\Modules\\Ecommerce\\Models\\Product', 47, 'in', 2, 'production', NULL, 1, 'Produção OP: OP-2026-0003', '2026-05-26 19:46:50', '2026-05-26 19:46:50'),
(19, 'App\\Modules\\Ecommerce\\Models\\Product', 46, 'in', 2, 'production', NULL, 1, 'Produção OP: OP-2026-0004', '2026-05-26 19:47:12', '2026-05-26 19:47:12'),
(20, 'App\\Modules\\Ecommerce\\Models\\Product', 43, 'out', 1, 'sale', 9, NULL, NULL, '2026-05-26 19:49:20', '2026-05-26 19:49:20'),
(21, 'App\\Modules\\Ecommerce\\Models\\Product', 46, 'out', 1, 'sale', 10, NULL, NULL, '2026-05-26 19:52:57', '2026-05-26 19:52:57'),
(22, 'App\\Modules\\Ecommerce\\Models\\Product', 47, 'out', 1, 'sale', 11, NULL, NULL, '2026-05-26 19:54:18', '2026-05-26 19:54:18'),
(23, 'App\\Modules\\Ecommerce\\Models\\Product', 36, 'out', 1, 'sale', 12, NULL, NULL, '2026-05-26 19:55:29', '2026-05-26 19:55:29'),
(24, 'App\\Modules\\Ecommerce\\Models\\Product', 40, 'out', 1, 'sale', 12, NULL, NULL, '2026-05-26 19:55:29', '2026-05-26 19:55:29'),
(25, 'App\\Modules\\Ecommerce\\Models\\Product', 46, 'out', 1, 'sale', 12, NULL, NULL, '2026-05-26 19:55:29', '2026-05-26 19:55:29'),
(26, 'App\\Modules\\Ecommerce\\Models\\Product', 45, 'out', 1, 'sale', 13, NULL, NULL, '2026-05-26 19:56:26', '2026-05-26 19:56:26'),
(27, 'App\\Modules\\Ecommerce\\Models\\Product', 47, 'out', 1, 'sale', 14, NULL, NULL, '2026-05-26 19:57:51', '2026-05-26 19:57:51'),
(28, 'App\\Modules\\Ecommerce\\Models\\Product', 46, 'out', 1, 'sale', 14, NULL, NULL, '2026-05-26 19:57:51', '2026-05-26 19:57:51'),
(29, 'App\\Modules\\Ecommerce\\Models\\Product', 45, 'out', 1, 'sale', 15, NULL, NULL, '2026-05-26 19:58:58', '2026-05-26 19:58:58'),
(30, 'App\\Modules\\Ecommerce\\Models\\Product', 47, 'out', 1, 'sale', 16, NULL, NULL, '2026-05-26 20:02:11', '2026-05-26 20:02:11'),
(31, 'App\\Modules\\Ecommerce\\Models\\Product', 46, 'out', 1, 'sale', 17, NULL, NULL, '2026-05-26 20:03:37', '2026-05-26 20:03:37'),
(32, 'App\\Modules\\Ecommerce\\Models\\Product', 35, 'out', 1, 'sale', 18, NULL, NULL, '2026-05-26 20:09:25', '2026-05-26 20:09:25'),
(33, 'App\\Modules\\Ecommerce\\Models\\Product', 36, 'out', 1, 'sale', 19, NULL, NULL, '2026-05-26 20:11:11', '2026-05-26 20:11:11'),
(34, 'App\\Modules\\Ecommerce\\Models\\Product', 36, 'out', 1, 'sale', 20, NULL, NULL, '2026-05-26 20:12:13', '2026-05-26 20:12:13'),
(35, 'App\\Modules\\Ecommerce\\Models\\Product', 47, 'out', 1, 'manual_adjustment', NULL, 1, 'Ajustando estoque.', '2026-05-26 20:30:23', '2026-05-26 20:30:23'),
(36, 'App\\Modules\\Ecommerce\\Models\\Product', 45, 'out', 2, 'manual_adjustment', NULL, 1, NULL, '2026-05-26 20:31:14', '2026-05-26 20:31:14'),
(37, 'App\\Modules\\Ecommerce\\Models\\Product', 44, 'out', 2, 'manual_adjustment', NULL, 1, NULL, '2026-05-26 20:32:14', '2026-05-26 20:32:14'),
(38, 'App\\Modules\\Ecommerce\\Models\\Product', 48, 'out', 1, 'sale', 21, NULL, NULL, '2026-05-27 04:08:08', '2026-05-27 04:08:08'),
(39, 'App\\Modules\\Ecommerce\\Models\\Product', 43, 'out', 1, 'sale', 22, NULL, NULL, '2026-05-27 14:03:56', '2026-05-27 14:03:56'),
(40, 'App\\Modules\\Ecommerce\\Models\\Product', 36, 'out', 1, 'sale', 23, NULL, NULL, '2026-05-27 16:35:55', '2026-05-27 16:35:55'),
(42, 'App\\Modules\\Ecommerce\\Models\\Product', 19, 'out', 1, 'sale', 24, NULL, NULL, '2026-05-29 14:34:40', '2026-05-29 14:34:40'),
(43, 'App\\Modules\\Ecommerce\\Models\\Product', 38, 'out', 1, 'sale', 24, NULL, NULL, '2026-05-29 14:34:40', '2026-05-29 14:34:40'),
(44, 'App\\Modules\\Ecommerce\\Models\\Product', 48, 'out', 1, 'sale', 24, NULL, NULL, '2026-05-29 14:34:40', '2026-05-29 14:34:40'),
(45, 'App\\Modules\\Ecommerce\\Models\\Product', 39, 'out', 1, 'sale', 25, NULL, NULL, '2026-05-30 14:50:01', '2026-05-30 14:50:01'),
(46, 'App\\Modules\\Ecommerce\\Models\\Product', 40, 'out', 1, 'sale', 25, NULL, NULL, '2026-05-30 14:50:01', '2026-05-30 14:50:01'),
(47, 'App\\Modules\\Ecommerce\\Models\\Product', 48, 'out', 1, 'sale', 25, NULL, NULL, '2026-05-30 14:50:01', '2026-05-30 14:50:01'),
(48, 'App\\Modules\\Ecommerce\\Models\\Product', 44, 'out', 1, 'sale', 26, NULL, NULL, '2026-05-30 14:52:19', '2026-05-30 14:52:19'),
(49, 'App\\Modules\\Ecommerce\\Models\\Product', 48, 'out', 1, 'sale', 26, NULL, NULL, '2026-05-30 14:52:19', '2026-05-30 14:52:19'),
(50, 'App\\Modules\\Ecommerce\\Models\\Product', 40, 'out', 1, 'sale', 27, NULL, NULL, '2026-06-03 15:29:54', '2026-06-03 15:29:54'),
(51, 'App\\Modules\\Ecommerce\\Models\\Product', 43, 'out', 1, 'sale', 27, NULL, NULL, '2026-06-03 15:29:54', '2026-06-03 15:29:54'),
(52, 'App\\Modules\\Ecommerce\\Models\\Product', 40, 'out', 1, 'sale', 29, NULL, NULL, '2026-06-03 16:12:43', '2026-06-03 16:12:43'),
(53, 'App\\Modules\\Ecommerce\\Models\\Product', 49, 'out', 1, 'sale', 29, NULL, NULL, '2026-06-03 16:12:43', '2026-06-03 16:12:43'),
(54, 'App\\Modules\\Ecommerce\\Models\\Product', 43, 'out', 1, 'sale', 30, NULL, NULL, '2026-06-03 16:13:56', '2026-06-03 16:13:56'),
(55, 'App\\Modules\\Ecommerce\\Models\\Product', 49, 'in', 5, 'production', NULL, 30, 'Produção OP: OP-2026-0008', '2026-06-03 20:40:17', '2026-06-03 20:40:17'),
(56, 'App\\Modules\\Ecommerce\\Models\\Product', 46, 'in', 10, 'production', NULL, 30, 'Produção OP: OP-2026-0007', '2026-06-03 20:40:54', '2026-06-03 20:40:54'),
(57, 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 3, 'in', 8, 'production', NULL, 30, 'Produção OP: OP-2026-0006', '2026-06-03 20:41:45', '2026-06-03 20:41:45'),
(58, 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 4, 'in', 2, 'production', NULL, 30, 'Produção OP: OP-2026-0006', '2026-06-03 20:41:45', '2026-06-03 20:41:45'),
(59, 'App\\Modules\\Ecommerce\\Models\\Product', 47, 'in', 5, 'production', NULL, 30, 'Produção OP: OP-2026-0005', '2026-06-03 20:42:06', '2026-06-03 20:42:06'),
(60, 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 7, 'out', 1, 'sale', 31, NULL, NULL, '2026-06-04 04:35:53', '2026-06-04 04:35:53'),
(64, 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 3, 'out', 1, 'sale', 32, NULL, NULL, '2026-06-04 18:22:55', '2026-06-04 18:22:55'),
(65, 'App\\Modules\\Ecommerce\\Models\\Product', 43, 'out', 1, 'sale', 32, NULL, NULL, '2026-06-04 18:22:55', '2026-06-04 18:22:55'),
(66, 'App\\Modules\\Ecommerce\\Models\\Product', 40, 'out', 1, 'sale', 32, NULL, NULL, '2026-06-04 18:22:55', '2026-06-04 18:22:55'),
(67, 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 9, 'out', 1, 'sale', 32, NULL, NULL, '2026-06-04 18:22:55', '2026-06-04 18:22:55'),
(68, 'App\\Modules\\Ecommerce\\Models\\Product', 51, 'out', 1, 'sale', 33, NULL, NULL, '2026-06-08 18:18:58', '2026-06-08 18:18:58'),
(69, 'App\\Modules\\Ecommerce\\Models\\Product', 50, 'out', 1, 'sale', 34, NULL, NULL, '2026-06-08 18:19:57', '2026-06-08 18:19:57'),
(70, 'App\\Modules\\Ecommerce\\Models\\Product', 51, 'out', 1, 'sale', 34, NULL, NULL, '2026-06-08 18:19:57', '2026-06-08 18:19:57'),
(71, 'App\\Modules\\Ecommerce\\Models\\Product', 48, 'out', 1, 'sale', 34, NULL, NULL, '2026-06-08 18:19:57', '2026-06-08 18:19:57'),
(72, 'App\\Modules\\Ecommerce\\Models\\Product', 52, 'out', 2, 'sale', 35, NULL, NULL, '2026-06-08 18:29:13', '2026-06-08 18:29:13'),
(73, 'App\\Modules\\Ecommerce\\Models\\Product', 53, 'in', 30, 'production', NULL, 30, 'Produção OP: OP-2026-0009', '2026-06-09 15:42:14', '2026-06-09 15:42:14'),
(81, 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 7, 'out', 1, 'sale', 37, NULL, NULL, '2026-06-10 14:58:42', '2026-06-10 14:58:42'),
(82, 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 13, 'out', 1, 'sale', 37, NULL, NULL, '2026-06-10 14:58:42', '2026-06-10 14:58:42'),
(83, 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 11, 'out', 1, 'sale', 37, NULL, NULL, '2026-06-10 14:58:42', '2026-06-10 14:58:42'),
(84, 'App\\Modules\\Ecommerce\\Models\\Product', 50, 'out', 1, 'sale', 37, NULL, NULL, '2026-06-10 14:58:42', '2026-06-10 14:58:42'),
(85, 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 16, 'out', 1, 'sale', 37, NULL, NULL, '2026-06-10 14:58:42', '2026-06-10 14:58:42'),
(86, 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 5, 'out', 1, 'sale', 36, NULL, NULL, '2026-06-11 02:36:46', '2026-06-11 02:36:46'),
(87, 'App\\Modules\\Ecommerce\\Models\\Product', 42, 'out', 1, 'sale', 36, NULL, NULL, '2026-06-11 02:36:46', '2026-06-11 02:36:46'),
(88, 'App\\Modules\\Ecommerce\\Models\\Product', 39, 'out', 3, 'sale', 36, NULL, NULL, '2026-06-11 02:36:46', '2026-06-11 02:36:46'),
(89, 'App\\Modules\\Ecommerce\\Models\\Product', 53, 'out', 1, 'sale', 36, NULL, NULL, '2026-06-11 02:36:46', '2026-06-11 02:36:46'),
(90, 'App\\Modules\\Ecommerce\\Models\\Product', 35, 'out', 1, 'sale', 36, NULL, NULL, '2026-06-11 02:36:46', '2026-06-11 02:36:46'),
(91, 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 21, 'out', 1, 'sale', 36, NULL, NULL, '2026-06-11 02:36:46', '2026-06-11 02:36:46'),
(98, 'App\\Modules\\Ecommerce\\Models\\Product', 37, 'out', 1, 'sale', 41, NULL, NULL, '2026-06-11 15:12:10', '2026-06-11 15:12:10'),
(99, 'App\\Modules\\Ecommerce\\Models\\Product', 54, 'out', 1, 'sale', 41, NULL, NULL, '2026-06-11 15:12:10', '2026-06-11 15:12:10'),
(100, 'App\\Modules\\Ecommerce\\Models\\Product', 37, 'in', 1, 'cancelled_order', 41, NULL, NULL, '2026-06-11 15:47:23', '2026-06-11 15:47:23'),
(101, 'App\\Modules\\Ecommerce\\Models\\Product', 54, 'in', 1, 'cancelled_order', 41, NULL, NULL, '2026-06-11 15:47:23', '2026-06-11 15:47:23'),
(102, 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 4, 'out', 1, 'sale', 42, NULL, NULL, '2026-06-11 21:22:49', '2026-06-11 21:22:49'),
(103, 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 11, 'out', 1, 'sale', 42, NULL, NULL, '2026-06-11 21:22:49', '2026-06-11 21:22:49'),
(104, 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 14, 'out', 1, 'sale', 42, NULL, NULL, '2026-06-11 21:22:49', '2026-06-11 21:22:49'),
(105, 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 5, 'out', 1, 'sale', 43, NULL, NULL, '2026-06-11 21:27:58', '2026-06-11 21:27:58'),
(106, 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 17, 'out', 1, 'sale', 43, NULL, NULL, '2026-06-11 21:27:58', '2026-06-11 21:27:58'),
(107, 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 14, 'out', 1, 'sale', 43, NULL, NULL, '2026-06-11 21:27:58', '2026-06-11 21:27:58'),
(108, 'App\\Modules\\Ecommerce\\Models\\Product', 48, 'out', 1, 'sale', 43, NULL, NULL, '2026-06-11 21:27:58', '2026-06-11 21:27:58'),
(111, 'App\\Modules\\Ecommerce\\Models\\Product', 40, 'out', 5, 'comodato_dispatch', NULL, NULL, 'Enviado para comodato em: Podologia. Quantidade enviada para formar espositor', '2026-06-12 17:23:10', '2026-06-12 17:23:10'),
(112, 'App\\Modules\\Ecommerce\\Models\\Product', 36, 'out', 5, 'comodato_dispatch', NULL, NULL, 'Enviado para comodato em: Podologia. Quantidade enviar para formar espositor', '2026-06-12 17:23:43', '2026-06-12 17:23:43'),
(113, 'App\\Modules\\Ecommerce\\Models\\Product', 35, 'out', 10, 'comodato_dispatch', NULL, NULL, 'Enviado para comodato em: Podologia. Quantidade enviar para formar espositor', '2026-06-12 17:24:01', '2026-06-12 17:24:01'),
(114, 'App\\Modules\\Ecommerce\\Models\\Product', 37, 'out', 6, 'comodato_dispatch', NULL, NULL, 'Enviado para comodato em: Podologia. Quantidade enviar para formar espositor', '2026-06-12 17:24:58', '2026-06-12 17:24:58'),
(115, 'App\\Modules\\Ecommerce\\Models\\Product', 43, 'out', 10, 'comodato_dispatch', NULL, NULL, 'Enviado para comodato em: Podologia. Quantidade enviar para formar espositor', '2026-06-12 17:25:22', '2026-06-12 17:25:22');

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` smallint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jobs`
--

INSERT INTO `jobs` (`id`, `queue`, `payload`, `attempts`, `reserved_at`, `available_at`, `created_at`) VALUES
(3, 'default', '{\"uuid\":\"c0915a7d-8a67-4afc-ba78-b4a781e11f7b\",\"displayName\":\"App\\\\Modules\\\\SmartInventory\\\\Jobs\\\\ProcessSmartInputJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":2,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":90,\"retryUntil\":null,\"deleteWhenMissingModels\":false,\"data\":{\"commandName\":\"App\\\\Modules\\\\SmartInventory\\\\Jobs\\\\ProcessSmartInputJob\",\"command\":\"O:52:\\\"App\\\\Modules\\\\SmartInventory\\\\Jobs\\\\ProcessSmartInputJob\\\":2:{s:9:\\\"sessionId\\\";i:3;s:8:\\\"mimeType\\\";s:15:\\\"application\\/pdf\\\";}\",\"batchId\":null},\"createdAt\":1779192220,\"delay\":null}', 0, NULL, 1779192220, 1779192220);

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `kits`
--

CREATE TABLE `kits` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `short_description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `unit_cost` decimal(10,4) DEFAULT NULL COMMENT 'Custo de montagem por unidade',
  `old_price` decimal(10,2) DEFAULT NULL,
  `discount_percent` decimal(5,2) DEFAULT NULL,
  `promo_start` timestamp NULL DEFAULT NULL,
  `promo_end` timestamp NULL DEFAULT NULL,
  `original_price` decimal(10,2) DEFAULT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `featured_image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `images` json DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `kit_product`
--

CREATE TABLE `kit_product` (
  `id` bigint UNSIGNED NOT NULL,
  `kit_id` bigint UNSIGNED NOT NULL,
  `product_id` bigint UNSIGNED NOT NULL,
  `quantity` int NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `loyalty_levels`
--

CREATE TABLE `loyalty_levels` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `min_points` int NOT NULL,
  `discount_percentage` decimal(5,2) NOT NULL DEFAULT '0.00',
  `badge_icon` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `loyalty_levels`
--

INSERT INTO `loyalty_levels` (`id`, `name`, `min_points`, `discount_percentage`, `badge_icon`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Semente de Alecrim', 0, 0.00, 'seed', 'Começo da sua jornada de bem-estar natural.', '2026-05-20 17:35:20', '2026-05-20 17:35:20'),
(2, 'Brotinho de Hortelã', 200, 5.00, 'leaf', 'Você está florescendo! Ganhe 5% de desconto em rituais de compra.', '2026-05-20 17:35:20', '2026-05-20 17:35:20'),
(3, 'Arbusto de Lavanda', 500, 10.00, 'flower', 'Um aroma suave e marcante. Ganhe 10% de desconto em rituais de compra.', '2026-05-20 17:35:20', '2026-05-20 17:35:20'),
(4, 'Árvore de Sálvia', 1500, 15.00, 'tree', 'A sabedoria máxima da natureza. Ganhe 15% de desconto em todas as suas compras.', '2026-05-20 17:35:20', '2026-05-20 17:35:20');

-- --------------------------------------------------------

--
-- Table structure for table `loyalty_offers`
--

CREATE TABLE `loyalty_offers` (
  `id` bigint UNSIGNED NOT NULL,
  `product_id` bigint UNSIGNED NOT NULL,
  `loyalty_level_id` bigint UNSIGNED NOT NULL,
  `special_price` decimal(10,2) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `loyalty_redemptions`
--

CREATE TABLE `loyalty_redemptions` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `loyalty_reward_id` bigint UNSIGNED NOT NULL,
  `reward_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `loyalty_rewards`
--

CREATE TABLE `loyalty_rewards` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `points_cost` int NOT NULL,
  `reward_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `loyalty_transactions`
--

CREATE TABLE `loyalty_transactions` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `order_id` bigint UNSIGNED DEFAULT NULL,
  `points` int NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `loyalty_transactions`
--

INSERT INTO `loyalty_transactions` (`id`, `user_id`, `order_id`, `points`, `description`, `created_at`, `updated_at`) VALUES
(1, 4, 2, 57, 'Sementes acumuladas no ritual de compra #BAL-CUO4CLQV', '2026-05-21 03:48:56', '2026-05-21 03:48:56'),
(2, 5, 3, 70, 'Sementes acumuladas no ritual de compra #BAL-3PL7XFA0', '2026-05-21 03:51:02', '2026-05-21 03:51:02'),
(3, 6, 4, 33, 'Sementes acumuladas no ritual de compra #BAL-LTKMSKX0', '2026-05-21 04:06:14', '2026-05-21 04:06:14'),
(4, 7, 5, 179, 'Sementes acumuladas no ritual de compra #BAL-2OC4FJOU', '2026-05-21 04:08:23', '2026-05-21 04:08:23'),
(5, 8, 6, 37, 'Sementes acumuladas no ritual de compra #BAL-E4NE4AMR', '2026-05-21 04:10:19', '2026-05-21 04:10:19'),
(6, 9, 7, 37, 'Sementes acumuladas no ritual de compra #BAL-MFJHVDNC', '2026-05-21 21:16:07', '2026-05-21 21:16:07'),
(7, 11, 9, 33, 'Sementes acumuladas no ritual de compra #BAL-8OMIB5YK', '2026-05-26 20:05:55', '2026-05-26 20:05:55'),
(8, 15, 12, 131, 'Sementes acumuladas no ritual de compra #BAL-26QPZCSN', '2026-05-28 14:49:15', '2026-05-28 14:49:15'),
(9, 14, 11, 60, 'Sementes acumuladas no ritual de compra #BAL-KHYGINFG', '2026-05-28 14:49:25', '2026-05-28 14:49:25'),
(10, 13, 10, 60, 'Sementes acumuladas no ritual de compra #BAL-LMRVMR3K', '2026-05-28 14:49:32', '2026-05-28 14:49:32'),
(11, 16, 13, 60, 'Sementes acumuladas no ritual de compra #BAL-0S9WBLFI', '2026-05-28 14:49:38', '2026-05-28 14:49:38'),
(12, 18, 15, 60, 'Sementes acumuladas no ritual de compra #BAL-MWPWCTC9', '2026-05-28 14:49:45', '2026-05-28 14:49:45'),
(13, 20, 18, 33, 'Sementes acumuladas no ritual de compra #BAL-IFZ36BJQ', '2026-05-28 14:49:54', '2026-05-28 14:49:54'),
(14, 10, 8, 108, 'Sementes acumuladas no ritual de compra #BAL-6BUULUHD', '2026-05-28 14:50:54', '2026-05-28 14:50:54'),
(15, 23, 22, 33, 'Sementes acumuladas no ritual de compra #BAL-AWRQMXYB', '2026-05-29 14:35:16', '2026-05-29 14:35:16'),
(16, 24, 23, 33, 'Sementes acumuladas no ritual de compra #BAL-NECYIEHQ', '2026-06-02 21:11:30', '2026-06-02 21:11:30'),
(17, 21, 19, 33, 'Sementes acumuladas no ritual de compra #BAL-CRSXANFO', '2026-06-02 21:11:36', '2026-06-02 21:11:36'),
(18, 22, 21, 45, 'Sementes acumuladas no ritual de compra #BAL-GVBPXKV4', '2026-06-02 21:11:42', '2026-06-02 21:11:42'),
(19, 26, 25, 98, 'Sementes acumuladas no ritual de compra #BAL-VLQOY5KW', '2026-06-02 21:11:45', '2026-06-02 21:11:45'),
(20, 28, 28, 33, 'Sementes acumuladas no ritual de compra #BAL-EG3OJ3OE', '2026-06-03 16:16:06', '2026-06-03 16:16:06'),
(21, 27, 27, 70, 'Sementes acumuladas no ritual de compra #BAL-RNBOVLVR', '2026-06-03 16:16:11', '2026-06-03 16:16:11'),
(22, 29, 30, 33, 'Sementes acumuladas no ritual de compra #BAL-IKSNJVO6', '2026-06-04 04:17:03', '2026-06-04 04:17:03'),
(23, 28, 29, 97, 'Sementes acumuladas no ritual de compra #BAL-WW3FAPSK', '2026-06-04 04:17:15', '2026-06-04 04:17:15'),
(24, 25, 24, 108, 'Sementes acumuladas no ritual de compra #BAL-IRIFBU4S', '2026-06-08 18:08:51', '2026-06-08 18:08:51'),
(25, 33, 33, 45, 'Sementes acumuladas no ritual de compra #BAL-NBPTJGTI', '2026-06-08 18:20:21', '2026-06-08 18:20:21'),
(26, 34, 34, 137, 'Sementes acumuladas no ritual de compra #BAL-E8ISA2OQ', '2026-06-08 18:20:22', '2026-06-08 18:20:22'),
(27, 10, 26, 106, 'Sementes acumuladas no ritual de compra #BAL-TJP8SGWL', '2026-06-10 14:29:30', '2026-06-10 14:29:30'),
(28, 12, 16, 60, 'Sementes acumuladas no ritual de compra #BAL-JXHQGREJ', '2026-06-10 14:29:56', '2026-06-10 14:29:56'),
(29, 19, 17, 60, 'Sementes acumuladas no ritual de compra #BAL-996OAZIG', '2026-06-10 14:29:59', '2026-06-10 14:29:59');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_05_14_000001_create_wellness_tables', 1),
(5, '2026_05_14_000002_create_ecommerce_tables', 1),
(6, '2026_05_14_000003_create_content_tables', 1),
(7, '2026_05_14_113258_create_personal_access_tokens_table', 1),
(8, '2026_05_14_130520_add_is_admin_to_users_table', 2),
(9, '2026_05_14_150749_update_order_items_for_kits', 3),
(10, '2026_05_15_add_personal_data_to_users', 4),
(11, '2026_05_15_add_color_to_emotions', 5),
(12, '2026_05_15_add_short_description_to_products_kits', 6),
(13, '2026_05_15_add_is_active_to_products_kits', 7),
(14, '2026_05_15_add_stock_to_kits', 8),
(15, '2026_05_15_150000_create_addresses_table', 9),
(16, '2026_05_16_000001_add_old_price_to_products', 10),
(17, '2026_05_16_update_products_for_promo_images', 11),
(18, '2026_05_16_add_cpf_phone_to_addresses', 12),
(19, '2026_05_18_000000_create_inventory_movements_table', 13),
(20, '2026_05_18_100000_create_inventory_tables', 14),
(21, '2026_05_18_200000_create_recipe_tables', 15),
(22, '2026_05_18_300000_create_production_tables', 16),
(23, '2026_05_18_400000_create_purchase_tables', 17),
(24, '2026_05_18_500000_add_unit_cost_to_products', 18),
(25, '2026_05_18_600000_create_quality_tables', 19),
(26, '2026_05_19_100000_create_smart_inventory_tables', 20),
(27, '2026_05_20_110133_add_is_active_to_users_table', 21),
(28, '2026_05_20_200000_add_image_path_to_raw_materials_table', 22),
(29, '2026_05_20_135158_add_avatar_path_to_users_table', 23),
(30, '2026_05_20_142148_create_loyalty_tables', 24),
(31, '2026_05_20_151000_create_categories_table', 25),
(32, '2026_05_20_153343_add_counter_fields_to_orders_table', 26),
(33, '2026_05_20_235041_add_shipping_fields_to_orders_table', 27),
(34, '2026_05_21_000909_make_user_id_nullable_on_orders_table', 28),
(35, '2026_05_21_074000_add_address_and_instagram_to_suppliers_table', 29),
(36, '2026_05_21_123000_create_product_reviews_table', 30),
(37, '2026_05_26_000002_add_bath_and_incense_columns_to_herbs_table', 31),
(38, '2026_05_27_113607_add_source_fields_to_herbs_table', 32),
(39, '2026_05_27_000003_add_aliases_and_contraindications_to_herbs_table', 33),
(40, '2026_06_03_120000_create_newsletter_subscribers_table', 34),
(41, '2026_06_03_133000_add_google_id_to_users_table', 35),
(42, '2026_06_03_140000_create_product_variants_table', 36),
(43, '2026_06_03_141000_create_production_order_outputs_table', 36),
(44, '2026_06_04_020000_change_result_in_quality_check_criteria', 37),
(45, '2026_06_10_000001_create_order_installments_table', 38),
(46, '2026_06_10_000002_create_comodato_tables', 38),
(47, '2026_06_10_200000_add_lgpd_consent_fields_to_users_table', 39),
(48, '2026_06_10_201000_resize_personal_data_columns_for_encryption', 40),
(49, '2026_06_11_114517_add_payment_fields_to_orders_table', 41),
(50, '2026_06_11_130000_add_shipping_method_to_orders_table', 42);

-- --------------------------------------------------------

--
-- Table structure for table `newsletter_subscribers`
--

CREATE TABLE `newsletter_subscribers` (
  `id` bigint UNSIGNED NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `customer_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_phone` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `discount_amount` decimal(10,2) DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `source` enum('online','counter') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'online',
  `payment_method` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_link` text COLLATE utf8mb4_unicode_ci,
  `payment_pix_qr` text COLLATE utf8mb4_unicode_ci,
  `payment_pix_code` text COLLATE utf8mb4_unicode_ci,
  `payment_pix_expiration` timestamp NULL DEFAULT NULL,
  `shipping_address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipping_method` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `tracking_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipped_at` timestamp NULL DEFAULT NULL,
  `weight_kg` decimal(5,2) DEFAULT NULL,
  `box_dimensions` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `freight_value` decimal(8,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `customer_name`, `customer_phone`, `order_number`, `total`, `discount_amount`, `status`, `source`, `payment_method`, `payment_id`, `payment_status`, `payment_link`, `payment_pix_qr`, `payment_pix_code`, `payment_pix_expiration`, `shipping_address`, `shipping_method`, `notes`, `tracking_code`, `shipped_at`, `weight_kg`, `box_dimensions`, `freight_value`, `created_at`, `updated_at`) VALUES
(1, NULL, 'Maria das Dores da Silva Camilo', '11964401205', 'BAL-6TLQQXZ4', 19.70, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Telefonista da ITB Belval.', NULL, NULL, NULL, NULL, NULL, '2026-05-21 03:10:52', '2026-05-21 03:10:52'),
(2, 4, NULL, NULL, 'BAL-CUO4CLQV', 57.40, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Filha da Marli namorada do Geomar', NULL, NULL, NULL, NULL, NULL, '2026-05-21 03:48:56', '2026-05-21 03:48:56'),
(3, 5, NULL, NULL, 'BAL-3PL7XFA0', 70.90, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Secretaria do ITB Belval', NULL, NULL, NULL, NULL, NULL, '2026-05-21 03:51:02', '2026-05-21 03:51:02'),
(4, 6, NULL, NULL, 'BAL-LTKMSKX0', 33.20, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Inspetora de alunos ITB Belval.', NULL, NULL, NULL, NULL, NULL, '2026-05-21 04:06:14', '2026-05-21 04:06:14'),
(5, 7, NULL, NULL, 'BAL-2OC4FJOU', 179.50, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prof. ITB Belval, irá pagar de duas vezes, sendo 90,00 agora e 90 para o dia 31/05.', NULL, NULL, NULL, NULL, NULL, '2026-05-21 04:08:23', '2026-05-21 04:08:23'),
(6, 8, NULL, NULL, 'BAL-E4NE4AMR', 37.70, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prof. ITB Belval.', NULL, NULL, NULL, NULL, NULL, '2026-05-21 04:10:19', '2026-05-21 04:10:19'),
(7, 9, NULL, NULL, 'BAL-MFJHVDNC', 37.70, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entregar na ETEC no dia 21/05 a tarde', NULL, 'Prof. da ETEC', NULL, NULL, NULL, NULL, NULL, '2026-05-21 13:13:55', '2026-05-21 21:16:07'),
(8, 10, NULL, NULL, 'BAL-6BUULUHD', 108.60, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entregar em casa', NULL, 'Entregar na residencia', NULL, '2026-05-22 01:48:55', 0.75, '16x12x6', 12.00, '2026-05-22 01:44:47', '2026-05-28 14:50:54'),
(9, 11, NULL, NULL, 'BAL-8OMIB5YK', 33.20, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entregar na ETEC', NULL, NULL, NULL, '2026-05-26 20:04:53', 0.50, '10x10x10', 0.00, '2026-05-26 19:49:20', '2026-05-26 20:05:55'),
(10, 13, NULL, NULL, 'BAL-LMRVMR3K', 60.20, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entregar no ITB', NULL, NULL, NULL, '2026-05-27 02:43:18', 0.30, '10x10x10', 0.00, '2026-05-26 19:52:57', '2026-05-28 14:49:32'),
(11, 14, NULL, NULL, 'BAL-KHYGINFG', 60.20, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entregar no ITB', NULL, NULL, NULL, '2026-05-27 02:43:48', 0.30, '10x10x10', 0.00, '2026-05-26 19:54:18', '2026-05-28 14:49:25'),
(12, 15, NULL, NULL, 'BAL-26QPZCSN', 131.10, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entregar no ITB', NULL, NULL, NULL, '2026-05-27 02:45:50', 0.33, '10x10x10', 0.00, '2026-05-26 19:55:29', '2026-05-28 14:49:15'),
(13, 16, NULL, NULL, 'BAL-0S9WBLFI', 60.20, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entregar no ITB', NULL, NULL, NULL, '2026-05-27 02:47:01', 0.30, '10x10x10', 0.00, '2026-05-26 19:56:26', '2026-05-28 14:49:38'),
(14, 17, NULL, NULL, 'BAL-RY7D7VIL', 120.40, NULL, 'pending', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entregar no ITB / ETEC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-26 19:57:51', '2026-05-26 19:57:51'),
(15, 18, NULL, NULL, 'BAL-MWPWCTC9', 60.20, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entrega na ETEC', NULL, NULL, NULL, '2026-05-27 02:44:23', 0.30, '10x10x10', 0.00, '2026-05-26 19:58:58', '2026-05-28 14:49:45'),
(16, 12, NULL, NULL, 'BAL-JXHQGREJ', 60.20, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entregar na ETEC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-26 20:02:11', '2026-06-10 14:29:56'),
(17, 19, NULL, NULL, 'BAL-996OAZIG', 60.20, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entregar na ETE - ENCOMENDA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-26 20:03:37', '2026-06-10 14:29:59'),
(18, 20, NULL, NULL, 'BAL-IFZ36BJQ', 33.20, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entregar na ETEC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-26 20:09:25', '2026-05-28 14:49:54'),
(19, 21, NULL, NULL, 'BAL-CRSXANFO', 33.20, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entregar na ETEC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-26 20:11:11', '2026-06-02 21:11:36'),
(20, 4, NULL, NULL, 'BAL-XDSDXZXA', 33.20, NULL, 'pending', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entregar para o Geomar - Enviar depois do dia 05/06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-26 20:12:13', '2026-05-26 20:12:13'),
(21, 22, NULL, NULL, 'BAL-GVBPXKV4', 45.80, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entregar no ITB', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-27 04:08:08', '2026-06-02 21:11:42'),
(22, 23, NULL, NULL, 'BAL-AWRQMXYB', 33.20, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entregar na ETEC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-27 14:03:56', '2026-05-29 14:35:16'),
(23, 24, NULL, NULL, 'BAL-NECYIEHQ', 33.20, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entregar na ETEC na segunda-feira', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-27 16:35:55', '2026-06-02 21:11:30'),
(24, 25, NULL, NULL, 'BAL-IRIFBU4S', 108.60, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Enviar por correio', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-28 14:59:30', '2026-06-08 18:08:51'),
(25, 26, NULL, NULL, 'BAL-VLQOY5KW', 98.70, NULL, 'delivered', 'counter', 'cash', NULL, NULL, NULL, NULL, NULL, NULL, 'Entregar no loja na segunda-feira para o Nelson', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-30 14:50:01', '2026-06-02 21:11:45'),
(26, 10, NULL, NULL, 'BAL-TJP8SGWL', 106.00, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Enviar por moto boy', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-30 14:52:19', '2026-06-10 14:29:30'),
(27, 27, NULL, NULL, 'BAL-RNBOVLVR', 70.90, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entrega na Moisotis', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-03 15:29:54', '2026-06-03 16:16:11'),
(28, 28, NULL, NULL, 'BAL-EG3OJ3OE', 33.20, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entregue no ITB', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-20 03:00:00', '2026-06-03 16:16:06'),
(29, 28, NULL, NULL, 'BAL-WW3FAPSK', 97.90, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entregar no ITB Belval', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-03 16:12:43', '2026-06-04 04:17:15'),
(30, 29, NULL, NULL, 'BAL-IKSNJVO6', 33.20, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entrega no ITB Belval', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-03 16:13:56', '2026-06-04 04:17:03'),
(31, 31, NULL, NULL, 'BAL-IEPXAL8E', 60.20, NULL, 'pending', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entregar na Bolo da Gioma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-04 04:35:53', '2026-06-04 04:35:53'),
(32, 32, NULL, NULL, 'BAL-2KIC0UEN', 191.30, NULL, 'pending', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entregar na boloda Gioma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-04 04:37:51', '2026-06-04 18:22:55'),
(33, 33, NULL, NULL, 'BAL-NBPTJGTI', 45.80, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entrega na casa dela.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-08 18:18:58', '2026-06-08 18:20:21'),
(34, 34, NULL, NULL, 'BAL-E8ISA2OQ', 137.40, NULL, 'delivered', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entrega em casa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-08 18:19:57', '2026-06-08 18:20:22'),
(35, 35, NULL, NULL, 'BAL-0RPZ1RJ6', 120.40, NULL, 'pending', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entregar no ITB na sexta-feira', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-08 18:29:13', '2026-06-08 18:29:13'),
(36, 36, NULL, NULL, 'BAL-BFFHDA4N', 236.80, NULL, 'shipped', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, '03627030 Vila Buenos Aires - São Paulo/SP Rua Sebastião José Francisco 95', NULL, 'fará o pgto em 2 vezes', NULL, NULL, NULL, NULL, NULL, '2026-06-10 04:14:01', '2026-06-11 03:25:09'),
(37, 37, NULL, NULL, 'BAL-K7TQU6YH', 197.40, NULL, 'shipped', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entregar via moto boy', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-10 14:55:52', '2026-06-11 21:15:41'),
(41, 2, NULL, NULL, 'ORD-2PSQUGFE', 78.10, NULL, 'cancelled', 'online', 'credit_card', NULL, 'pending', 'http://localhost:3000/checkout?step=3&status=success', NULL, NULL, NULL, 'Rua Guarujá, 66 - Casa, Jardim Maria Helena, Barueri - SP | CEP: 06445070', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-11 15:12:10', '2026-06-11 15:47:23'),
(42, 38, NULL, NULL, 'BAL-BM0NXH8R', 121.20, NULL, 'pending', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entrega será feita no centro comeercial do Alphaville', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-11 21:22:49', '2026-06-11 21:22:49'),
(43, 39, NULL, NULL, 'BAL-DSMIPL7X', 186.80, NULL, 'pending', 'counter', 'pix', NULL, NULL, NULL, NULL, NULL, NULL, 'Entrega será feita para o seu Geomar visinho.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-11 21:27:58', '2026-06-11 21:27:58');

-- --------------------------------------------------------

--
-- Table structure for table `order_installments`
--

CREATE TABLE `order_installments` (
  `id` bigint UNSIGNED NOT NULL,
  `order_id` bigint UNSIGNED NOT NULL,
  `installment_number` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `due_date` date NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `payment_method` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `paid_at` timestamp NULL DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` bigint UNSIGNED NOT NULL,
  `order_id` bigint UNSIGNED NOT NULL,
  `quantity` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `itemable_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `itemable_id` bigint UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `quantity`, `price`, `created_at`, `updated_at`, `itemable_type`, `itemable_id`) VALUES
(1, 1, 1, 19.70, '2026-05-21 03:10:52', '2026-05-21 03:10:52', 'App\\Modules\\Ecommerce\\Models\\Product', 42),
(2, 2, 1, 37.70, '2026-05-21 03:48:56', '2026-05-21 03:48:56', 'App\\Modules\\Ecommerce\\Models\\Product', 41),
(3, 2, 1, 19.70, '2026-05-21 03:48:56', '2026-05-21 03:48:56', 'App\\Modules\\Ecommerce\\Models\\Product', 42),
(4, 3, 1, 33.20, '2026-05-21 03:51:02', '2026-05-21 03:51:02', 'App\\Modules\\Ecommerce\\Models\\Product', 36),
(5, 3, 1, 37.70, '2026-05-21 03:51:02', '2026-05-21 03:51:02', 'App\\Modules\\Ecommerce\\Models\\Product', 40),
(6, 4, 1, 33.20, '2026-05-21 04:06:14', '2026-05-21 04:06:14', 'App\\Modules\\Ecommerce\\Models\\Product', 36),
(7, 5, 1, 33.20, '2026-05-21 04:08:23', '2026-05-21 04:08:23', 'App\\Modules\\Ecommerce\\Models\\Product', 43),
(8, 5, 2, 37.70, '2026-05-21 04:08:23', '2026-05-21 04:08:23', 'App\\Modules\\Ecommerce\\Models\\Product', 40),
(9, 5, 1, 37.70, '2026-05-21 04:08:23', '2026-05-21 04:08:23', 'App\\Modules\\Ecommerce\\Models\\Product', 37),
(10, 5, 1, 33.20, '2026-05-21 04:08:23', '2026-05-21 04:08:23', 'App\\Modules\\Ecommerce\\Models\\Product', 35),
(11, 6, 1, 37.70, '2026-05-21 04:10:19', '2026-05-21 04:10:19', 'App\\Modules\\Ecommerce\\Models\\Product', 40),
(12, 7, 1, 37.70, '2026-05-21 13:13:55', '2026-05-21 13:13:55', 'App\\Modules\\Ecommerce\\Models\\Product', 37),
(13, 8, 1, 37.70, '2026-05-22 01:44:47', '2026-05-22 01:44:47', 'App\\Modules\\Ecommerce\\Models\\Product', 40),
(14, 8, 1, 37.70, '2026-05-22 01:44:47', '2026-05-22 01:44:47', 'App\\Modules\\Ecommerce\\Models\\Product', 41),
(15, 8, 1, 33.20, '2026-05-22 01:44:47', '2026-05-22 01:44:47', 'App\\Modules\\Ecommerce\\Models\\Product', 35),
(16, 9, 1, 33.20, '2026-05-26 19:49:20', '2026-05-26 19:49:20', 'App\\Modules\\Ecommerce\\Models\\Product', 43),
(17, 10, 1, 60.20, '2026-05-26 19:52:57', '2026-05-26 19:52:57', 'App\\Modules\\Ecommerce\\Models\\Product', 46),
(18, 11, 1, 60.20, '2026-05-26 19:54:18', '2026-05-26 19:54:18', 'App\\Modules\\Ecommerce\\Models\\Product', 47),
(19, 12, 1, 33.20, '2026-05-26 19:55:29', '2026-05-26 19:55:29', 'App\\Modules\\Ecommerce\\Models\\Product', 36),
(20, 12, 1, 37.70, '2026-05-26 19:55:29', '2026-05-26 19:55:29', 'App\\Modules\\Ecommerce\\Models\\Product', 40),
(21, 12, 1, 60.20, '2026-05-26 19:55:29', '2026-05-26 19:55:29', 'App\\Modules\\Ecommerce\\Models\\Product', 46),
(22, 13, 1, 60.20, '2026-05-26 19:56:26', '2026-05-26 19:56:26', 'App\\Modules\\Ecommerce\\Models\\Product', 45),
(23, 14, 1, 60.20, '2026-05-26 19:57:51', '2026-05-26 19:57:51', 'App\\Modules\\Ecommerce\\Models\\Product', 47),
(24, 14, 1, 60.20, '2026-05-26 19:57:51', '2026-05-26 19:57:51', 'App\\Modules\\Ecommerce\\Models\\Product', 46),
(25, 15, 1, 60.20, '2026-05-26 19:58:58', '2026-05-26 19:58:58', 'App\\Modules\\Ecommerce\\Models\\Product', 45),
(26, 16, 1, 60.20, '2026-05-26 20:02:11', '2026-05-26 20:02:11', 'App\\Modules\\Ecommerce\\Models\\Product', 47),
(27, 17, 1, 60.20, '2026-05-26 20:03:37', '2026-05-26 20:03:37', 'App\\Modules\\Ecommerce\\Models\\Product', 46),
(28, 18, 1, 33.20, '2026-05-26 20:09:25', '2026-05-26 20:09:25', 'App\\Modules\\Ecommerce\\Models\\Product', 35),
(29, 19, 1, 33.20, '2026-05-26 20:11:11', '2026-05-26 20:11:11', 'App\\Modules\\Ecommerce\\Models\\Product', 36),
(30, 20, 1, 33.20, '2026-05-26 20:12:13', '2026-05-26 20:12:13', 'App\\Modules\\Ecommerce\\Models\\Product', 36),
(31, 21, 1, 45.80, '2026-05-27 04:08:08', '2026-05-27 04:08:08', 'App\\Modules\\Ecommerce\\Models\\Product', 48),
(32, 22, 1, 33.20, '2026-05-27 14:03:56', '2026-05-27 14:03:56', 'App\\Modules\\Ecommerce\\Models\\Product', 43),
(33, 23, 1, 33.20, '2026-05-27 16:35:55', '2026-05-27 16:35:55', 'App\\Modules\\Ecommerce\\Models\\Product', 36),
(35, 24, 1, 27.80, '2026-05-29 14:34:40', '2026-05-29 14:34:40', 'App\\Modules\\Ecommerce\\Models\\Product', 19),
(36, 24, 1, 35.00, '2026-05-29 14:34:40', '2026-05-29 14:34:40', 'App\\Modules\\Ecommerce\\Models\\Product', 38),
(37, 24, 1, 45.80, '2026-05-29 14:34:40', '2026-05-29 14:34:40', 'App\\Modules\\Ecommerce\\Models\\Product', 48),
(38, 25, 1, 15.20, '2026-05-30 14:50:01', '2026-05-30 14:50:01', 'App\\Modules\\Ecommerce\\Models\\Product', 39),
(39, 25, 1, 37.70, '2026-05-30 14:50:01', '2026-05-30 14:50:01', 'App\\Modules\\Ecommerce\\Models\\Product', 40),
(40, 25, 1, 45.80, '2026-05-30 14:50:01', '2026-05-30 14:50:01', 'App\\Modules\\Ecommerce\\Models\\Product', 48),
(41, 26, 1, 60.20, '2026-05-30 14:52:19', '2026-05-30 14:52:19', 'App\\Modules\\Ecommerce\\Models\\Product', 44),
(42, 26, 1, 45.80, '2026-05-30 14:52:19', '2026-05-30 14:52:19', 'App\\Modules\\Ecommerce\\Models\\Product', 48),
(43, 27, 1, 37.70, '2026-06-03 15:29:54', '2026-06-03 15:29:54', 'App\\Modules\\Ecommerce\\Models\\Product', 40),
(44, 27, 1, 33.20, '2026-06-03 15:29:54', '2026-06-03 15:29:54', 'App\\Modules\\Ecommerce\\Models\\Product', 43),
(45, 28, 1, 33.20, '2026-05-20 03:00:00', '2026-05-20 03:00:00', 'App\\Modules\\Ecommerce\\Models\\Product', 35),
(46, 29, 1, 37.70, '2026-06-03 16:12:43', '2026-06-03 16:12:43', 'App\\Modules\\Ecommerce\\Models\\Product', 40),
(47, 29, 1, 60.20, '2026-06-03 16:12:43', '2026-06-03 16:12:43', 'App\\Modules\\Ecommerce\\Models\\Product', 49),
(48, 30, 1, 33.20, '2026-06-03 16:13:56', '2026-06-03 16:13:56', 'App\\Modules\\Ecommerce\\Models\\Product', 43),
(49, 31, 1, 60.20, '2026-06-04 04:35:53', '2026-06-04 04:35:53', 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 7),
(53, 32, 1, 60.20, '2026-06-04 18:22:55', '2026-06-04 18:22:55', 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 3),
(54, 32, 1, 33.20, '2026-06-04 18:22:55', '2026-06-04 18:22:55', 'App\\Modules\\Ecommerce\\Models\\Product', 43),
(55, 32, 1, 37.70, '2026-06-04 18:22:55', '2026-06-04 18:22:55', 'App\\Modules\\Ecommerce\\Models\\Product', 40),
(56, 32, 1, 60.20, '2026-06-04 18:22:55', '2026-06-04 18:22:55', 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 9),
(57, 33, 1, 45.80, '2026-06-08 18:18:58', '2026-06-08 18:18:58', 'App\\Modules\\Ecommerce\\Models\\Product', 51),
(58, 34, 1, 45.80, '2026-06-08 18:19:57', '2026-06-08 18:19:57', 'App\\Modules\\Ecommerce\\Models\\Product', 50),
(59, 34, 1, 45.80, '2026-06-08 18:19:57', '2026-06-08 18:19:57', 'App\\Modules\\Ecommerce\\Models\\Product', 51),
(60, 34, 1, 45.80, '2026-06-08 18:19:57', '2026-06-08 18:19:57', 'App\\Modules\\Ecommerce\\Models\\Product', 48),
(61, 35, 2, 60.20, '2026-06-08 18:29:13', '2026-06-08 18:29:13', 'App\\Modules\\Ecommerce\\Models\\Product', 52),
(69, 37, 1, 60.20, '2026-06-10 14:58:42', '2026-06-10 14:58:42', 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 7),
(70, 37, 1, 40.40, '2026-06-10 14:58:42', '2026-06-10 14:58:42', 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 13),
(71, 37, 1, 40.40, '2026-06-10 14:58:42', '2026-06-10 14:58:42', 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 11),
(72, 37, 1, 45.80, '2026-06-10 14:58:42', '2026-06-10 14:58:42', 'App\\Modules\\Ecommerce\\Models\\Product', 50),
(73, 37, 1, 10.60, '2026-06-10 14:58:42', '2026-06-10 14:58:42', 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 16),
(74, 36, 1, 60.20, '2026-06-11 02:36:46', '2026-06-11 02:36:46', 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 5),
(75, 36, 1, 19.70, '2026-06-11 02:36:46', '2026-06-11 02:36:46', 'App\\Modules\\Ecommerce\\Models\\Product', 42),
(76, 36, 3, 15.20, '2026-06-11 02:36:46', '2026-06-11 02:36:46', 'App\\Modules\\Ecommerce\\Models\\Product', 39),
(77, 36, 1, 37.70, '2026-06-11 02:36:46', '2026-06-11 02:36:46', 'App\\Modules\\Ecommerce\\Models\\Product', 53),
(78, 36, 1, 33.20, '2026-06-11 02:36:46', '2026-06-11 02:36:46', 'App\\Modules\\Ecommerce\\Models\\Product', 35),
(79, 36, 1, 40.40, '2026-06-11 02:36:46', '2026-06-11 02:36:46', 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 21),
(86, 41, 1, 37.70, '2026-06-11 15:12:10', '2026-06-11 15:12:10', 'App\\Modules\\Ecommerce\\Models\\Product', 37),
(87, 41, 1, 40.40, '2026-06-11 15:12:10', '2026-06-11 15:12:10', 'App\\Modules\\Ecommerce\\Models\\Product', 54),
(88, 42, 1, 40.40, '2026-06-11 21:22:49', '2026-06-11 21:22:49', 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 4),
(89, 42, 1, 40.40, '2026-06-11 21:22:49', '2026-06-11 21:22:49', 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 11),
(90, 42, 1, 40.40, '2026-06-11 21:22:49', '2026-06-11 21:22:49', 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 14),
(91, 43, 1, 60.20, '2026-06-11 21:27:58', '2026-06-11 21:27:58', 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 5),
(92, 43, 1, 40.40, '2026-06-11 21:27:58', '2026-06-11 21:27:58', 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 17),
(93, 43, 1, 40.40, '2026-06-11 21:27:58', '2026-06-11 21:27:58', 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 14),
(94, 43, 1, 45.80, '2026-06-11 21:27:58', '2026-06-11 21:27:58', 'App\\Modules\\Ecommerce\\Models\\Product', 48);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '6ace5efeb29082a38a81e284689a546270385d69ccf1bdb513ee99165f54dac1', '[\"*\"]', NULL, NULL, '2026-05-14 16:49:34', '2026-05-14 16:49:34'),
(2, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', 'f2d5975308d9aec89e3f7347a6eca911f375b278f84b49201cf72450e0a9bbab', '[\"*\"]', '2026-05-14 19:49:58', NULL, '2026-05-14 16:53:00', '2026-05-14 19:49:58'),
(3, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '38b0d0279d628dae605d883bcf50e15d276bdb6d8fdde21d5e062febb4af14a7', '[\"*\"]', '2026-05-15 15:12:50', NULL, '2026-05-15 13:34:19', '2026-05-15 15:12:50'),
(4, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '55a22331e2798e57036154806964771665ac898dfd49343ad72b6f35d485fad8', '[\"*\"]', '2026-05-15 16:14:34', NULL, '2026-05-15 15:13:26', '2026-05-15 16:14:34'),
(5, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '0a7795592be4a7de043c2df8fcba10b92dd4a84fe22952d179ce2d0ce128ed0a', '[\"*\"]', '2026-05-15 17:33:04', NULL, '2026-05-15 17:25:23', '2026-05-15 17:33:04'),
(6, 'App\\Modules\\Auth\\Models\\User', 2, 'auth_token', '8d6c145f425b75adc49558e78b721b3026e4185a5536b20a2a10f830f034235c', '[\"*\"]', '2026-05-16 15:44:18', NULL, '2026-05-15 17:33:48', '2026-05-16 15:44:18'),
(7, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '7f2622a5b5b90078498fc3553455b4b879928135cd8856ee31ceef1dbfa7f214', '[\"*\"]', '2026-05-16 17:22:11', NULL, '2026-05-16 15:44:27', '2026-05-16 17:22:11'),
(8, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '72feebe0337c2054efbdf0e79f2e8ce247d06363d4e22d9eaf87378584a23f8c', '[\"*\"]', '2026-05-19 13:44:32', NULL, '2026-05-18 19:59:20', '2026-05-19 13:44:32'),
(9, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', 'eaee78ad6576af579c4d13d689c0071b57fe1b3d7f08f2e2bce3df702d687567', '[\"*\"]', '2026-05-20 04:30:41', NULL, '2026-05-19 13:44:44', '2026-05-20 04:30:41'),
(10, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '8c3df2955f88a0abff6c437602876224b1bcb79d76ab55d2284464377bf85f42', '[\"*\"]', '2026-05-20 13:55:46', NULL, '2026-05-20 04:31:00', '2026-05-20 13:55:46'),
(11, 'App\\Modules\\Auth\\Models\\User', 2, 'auth_token', '76539adf5bfd419eafe830c23ecfcee425a1d2053813fad1f58d2a38ff008b89', '[\"*\"]', '2026-05-20 16:27:20', NULL, '2026-05-20 13:55:54', '2026-05-20 16:27:20'),
(12, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '618e99305b8c629ebd4d54b87585e1a90259b407c296fcac341373c938642e2a', '[\"*\"]', '2026-05-20 16:30:53', NULL, '2026-05-20 16:28:05', '2026-05-20 16:30:53'),
(13, 'App\\Modules\\Auth\\Models\\User', 2, 'auth_token', '3450adf4495e3605fd2c22e48514d3dbe3ece47830d0b4605e5f956579daa310', '[\"*\"]', '2026-05-20 16:32:18', NULL, '2026-05-20 16:32:16', '2026-05-20 16:32:18'),
(14, 'App\\Modules\\Auth\\Models\\User', 2, 'auth_token', 'f79e25227c08952e4be8b9910010e40158da9f1c7ac962d0db1dbaf8b35f00b8', '[\"*\"]', '2026-05-20 16:45:05', NULL, '2026-05-20 16:32:34', '2026-05-20 16:45:05'),
(15, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '3481ec111b4a02cfcdb78db20b4b13f0eea4e3d0049a70b7c97b120321e17244', '[\"*\"]', '2026-05-20 17:57:14', NULL, '2026-05-20 16:45:08', '2026-05-20 17:57:14'),
(16, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', 'fb5456c4b6ee73041e53783c240bdde3e85194540a217244edb5911bebbb33a5', '[\"*\"]', '2026-05-21 21:06:58', NULL, '2026-05-20 17:57:20', '2026-05-21 21:06:58'),
(17, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '6774f300f9d3b883b06bfc6310a668fa25e884a070501b66d5a3c580dd998ce2', '[\"*\"]', '2026-05-21 21:07:18', NULL, '2026-05-21 21:07:02', '2026-05-21 21:07:18'),
(18, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', 'b9a0f2bc22d4dd7b7727caef99d86d10b0ddb5f225ae0d26c002daedd90174ac', '[\"*\"]', '2026-05-22 01:38:17', NULL, '2026-05-21 21:07:30', '2026-05-22 01:38:17'),
(19, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '2059687e24b92ad05abc804fff6a7b726a79ce268574fda3cfda2e98230ccd8a', '[\"*\"]', '2026-05-23 03:49:41', NULL, '2026-05-22 01:38:56', '2026-05-23 03:49:41'),
(20, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', 'f9fdfabb07dd3b3670cd3698074beb123cdc775bd70c37f82c14035033e5d777', '[\"*\"]', '2026-05-24 17:56:13', NULL, '2026-05-23 03:49:43', '2026-05-24 17:56:13'),
(21, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', 'aaeb700eb61447ac9296202711c7fcb7c5c5b48d5682fab45632e459011ea338', '[\"*\"]', '2026-05-26 14:59:28', NULL, '2026-05-24 17:56:15', '2026-05-26 14:59:28'),
(22, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', 'f98ae67740e8c43014740b00bd9b9cfb43a24726dca04ae724c2575b449e9704', '[\"*\"]', '2026-05-27 14:04:55', NULL, '2026-05-26 14:59:25', '2026-05-27 14:04:55'),
(23, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', 'aa91fd75f509f317306900ae052376e21f50d0d00b30664636d959eac963752c', '[\"*\"]', '2026-05-27 14:53:19', NULL, '2026-05-27 14:45:08', '2026-05-27 14:53:19'),
(24, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '37e40bf549127bf4554d1adb007cd981d19ef17a501bc96190ff7442a7dd3149', '[\"*\"]', '2026-05-27 16:34:24', NULL, '2026-05-27 14:53:19', '2026-05-27 16:34:24'),
(25, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '9d8db48bf55690240b95afa33d6ebb424160c333096c68262994773b5ac2ca61', '[\"*\"]', '2026-05-27 20:57:14', NULL, '2026-05-27 16:34:26', '2026-05-27 20:57:14'),
(26, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '85aa8f97129be4806ad4164cde83032d8c629cec99c42f6b47f674bcde2b6014', '[\"*\"]', '2026-05-28 14:33:46', NULL, '2026-05-27 20:57:15', '2026-05-28 14:33:46'),
(27, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '07315581409665d98e0bbad0dfe836e53a4a6a95c52eec8b166ac1ead46bdede', '[\"*\"]', '2026-05-28 16:36:33', NULL, '2026-05-28 14:48:25', '2026-05-28 16:36:33'),
(28, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '481020e64031ca840852dc8d027647dc17be6172d4d932dadbaa0afc1ce9f17c', '[\"*\"]', '2026-05-28 16:45:55', NULL, '2026-05-28 16:36:35', '2026-05-28 16:45:55'),
(29, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '0a5c30de77d72e6b24125a828048400b1531dc69b87b0ea366591dd7a8093176', '[\"*\"]', '2026-05-28 16:54:01', NULL, '2026-05-28 16:45:54', '2026-05-28 16:54:01'),
(30, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '913945a1760884080b27bee36c8a5f4598d4126a1b95f566348b764be7e95d3b', '[\"*\"]', '2026-05-28 18:00:13', NULL, '2026-05-28 16:54:02', '2026-05-28 18:00:13'),
(31, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '0f3141bcb4849195940a88694116a2b7f0ab12081bc8c3d81141424d467a0089', '[\"*\"]', '2026-05-29 13:42:00', NULL, '2026-05-29 13:37:59', '2026-05-29 13:42:00'),
(32, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '3e1d0d711ec23c27d703244e756516564d5e22d750ed854f3e233d7aab29112f', '[\"*\"]', '2026-05-29 13:49:27', NULL, '2026-05-29 13:44:53', '2026-05-29 13:49:27'),
(33, 'App\\Modules\\Auth\\Models\\User', 2, 'auth_token', 'd65376722689a9b71a1cf1423be6a131de805abd93cbaa049c24989ca8139a5a', '[\"*\"]', '2026-05-29 13:59:56', NULL, '2026-05-29 13:49:30', '2026-05-29 13:59:56'),
(34, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '72f0300003fe4e28776e778728fa678023da20ee3120035fb0b81d874f6050af', '[\"*\"]', '2026-05-29 14:33:39', NULL, '2026-05-29 14:00:05', '2026-05-29 14:33:39'),
(35, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', 'af95dcdc4aa5ccf6c57c0b14a75d01d8732eb03d88ff94f291041084b803a9d0', '[\"*\"]', '2026-05-29 14:35:53', NULL, '2026-05-29 14:33:42', '2026-05-29 14:35:53'),
(36, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '261ba129b1da959759e75258d9d3663dc5f122a8b2072d73006b38e5ef50ec57', '[\"*\"]', '2026-05-29 14:42:46', NULL, '2026-05-29 14:35:54', '2026-05-29 14:42:46'),
(37, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', 'c376ff743873751f02625a56817cbe70b1371cf3cda3b05d635f9552b06455bc', '[\"*\"]', '2026-05-29 14:58:53', NULL, '2026-05-29 14:42:48', '2026-05-29 14:58:53'),
(38, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '1bdd0a253559975a786c1678d8901746d32211bad5ae24c4e5ffe1edb15cf0c5', '[\"*\"]', '2026-05-29 15:05:34', NULL, '2026-05-29 14:58:55', '2026-05-29 15:05:34'),
(39, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', 'a8c2d323d179d5645131717c4f4e14ee71bd31d52deda5c80f79d426e182006f', '[\"*\"]', '2026-06-03 15:25:27', NULL, '2026-05-29 15:05:35', '2026-06-03 15:25:27'),
(40, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', 'b0cb4f2324515bb2c3107ba8a6843a525ad0a716e0f145b05c6319bbbd0a54a5', '[\"*\"]', '2026-06-02 20:51:12', NULL, '2026-06-02 20:29:04', '2026-06-02 20:51:12'),
(41, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', 'cba02a4d1e2e73dd4e0da3dfefe5959f28e0cfc2d9cce02d25913e980360f6d6', '[\"*\"]', '2026-06-03 01:11:34', NULL, '2026-06-02 21:10:16', '2026-06-03 01:11:34'),
(42, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '054638575cf389e575c27eb51c61defd4344b204a454ef259d8d815b46fc6325', '[\"*\"]', '2026-06-03 16:26:18', NULL, '2026-06-03 15:25:37', '2026-06-03 16:26:18'),
(43, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', 'bd59d7335269b068698e274fe43d652be7f1e121bb4a9ace9a58a688ce0b2684', '[\"*\"]', '2026-06-03 16:27:55', NULL, '2026-06-03 16:26:20', '2026-06-03 16:27:55'),
(44, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', '4cb13a55521f5d7272d7ce16400fd7110ab890bcb03ba558e9df55e2e6c59d56', '[\"*\"]', '2026-06-03 16:42:06', NULL, '2026-06-03 16:41:55', '2026-06-03 16:42:06'),
(45, 'App\\Modules\\Auth\\Models\\User', 1, 'auth_token', '08d28f3c67bf7b88caa4e9ab635022748e2da7a2318b52ad2040197b95a9fccc', '[\"*\"]', '2026-06-03 16:54:33', NULL, '2026-06-03 16:42:10', '2026-06-03 16:54:33'),
(46, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', 'cfe83a9ff0ced5389983e3fe612e8d1fd8e1a4244a2884bab909765f6b8dc50f', '[\"*\"]', '2026-06-03 17:04:03', NULL, '2026-06-03 16:55:03', '2026-06-03 17:04:03'),
(47, 'App\\Modules\\Auth\\Models\\User', 2, 'auth_token', '6594ab9b126ef113a77d6fb07711e59b6126d3346145471ce94a9214bf4c6ac7', '[\"*\"]', NULL, NULL, '2026-06-03 17:04:21', '2026-06-03 17:04:21'),
(48, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', '48a38e221077286ce2487d004b9a45b459bf0b7e47dbe640ad41fcd07536cf23', '[\"*\"]', '2026-06-03 17:24:01', NULL, '2026-06-03 17:11:09', '2026-06-03 17:24:01'),
(49, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', '1ca4622a2e7a19802758d45940767fc1c59b7102a4ee2d71257f50dc71bc2102', '[\"*\"]', '2026-06-03 17:51:46', NULL, '2026-06-03 17:24:05', '2026-06-03 17:51:46'),
(50, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', '7fa8c08ae4f9688c9ba7d5ac0454d83c3748b84834f8923fd91fe46f50c7c84c', '[\"*\"]', '2026-06-03 20:52:58', NULL, '2026-06-03 17:51:50', '2026-06-03 20:52:58'),
(51, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', 'd1dfe84cab8db2e8644eb5d85398c27903c5b9705b340a9e6ea3ee88f70c930a', '[\"*\"]', '2026-06-03 20:56:18', NULL, '2026-06-03 20:53:01', '2026-06-03 20:56:18'),
(52, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', 'a89f3d985f83c4eea5f27afa4c79c497204feddfa4a9af935e66c7bebe9fb0bf', '[\"*\"]', '2026-06-03 22:09:49', NULL, '2026-06-03 20:56:20', '2026-06-03 22:09:49'),
(53, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', '028bb6920c12b4eefa6dd186ac108ff78ac15cd1207f9a826c9cc6209e924fda', '[\"*\"]', '2026-06-03 22:11:53', NULL, '2026-06-03 22:09:52', '2026-06-03 22:11:53'),
(54, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', '847c9aadf4504ca559fe92a02692eafe1644dce8d5588a9ec56b5f8f17267c20', '[\"*\"]', '2026-06-04 01:21:32', NULL, '2026-06-03 22:11:56', '2026-06-04 01:21:32'),
(55, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', '6a4e60a6304e23e8149b0239d628fcf2a089cacead724c1acc4fe3bcfa1e8fdf', '[\"*\"]', '2026-06-04 04:24:42', NULL, '2026-06-04 01:21:33', '2026-06-04 04:24:42'),
(56, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', 'cdbb4c2ff98fa1e3d4125e5e28148e31a3cb5a21995207d1ce57c436dd4f010e', '[\"*\"]', '2026-06-04 04:25:12', NULL, '2026-06-04 04:24:43', '2026-06-04 04:25:12'),
(57, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', '4e0ab2e198dd3b5026befb45e12686a3d1088cc8d1f7f8ccab9aef5b0087b83d', '[\"*\"]', '2026-06-04 04:28:13', NULL, '2026-06-04 04:25:13', '2026-06-04 04:28:13'),
(58, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', 'd988022ee2c66a6c25e21f282142e2adbc8da289585255f141dcd66c830196d6', '[\"*\"]', '2026-06-04 04:40:27', NULL, '2026-06-04 04:28:14', '2026-06-04 04:40:27'),
(59, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', 'eabb5a4c66e39c4bc86914c74572ab37e94cac7282ffee112ecf20cb959e6242', '[\"*\"]', '2026-06-04 18:21:41', NULL, '2026-06-04 04:40:28', '2026-06-04 18:21:41'),
(60, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', '5c03d5146f2c2ded0236e000af263a9d85fd99565dd802ef634e7115e81731b4', '[\"*\"]', '2026-06-08 15:16:31', NULL, '2026-06-04 18:21:44', '2026-06-08 15:16:31'),
(61, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', 'e82f7679d2fdd6bcdcede3414b840e2b8e5367b5acde9b65dd260d5abd75d362', '[\"*\"]', '2026-06-08 18:08:02', NULL, '2026-06-08 18:07:53', '2026-06-08 18:08:02'),
(62, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', '73d22895052dc3f5cdfadc73784fd74ca3ffa1f1ee78ea806b6a698c73bc8d3e', '[\"*\"]', '2026-06-08 19:45:19', NULL, '2026-06-08 18:08:03', '2026-06-08 19:45:19'),
(63, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', '458540fa5129b2271601302094939994287d5898afe6680f084a5b48c4c18c58', '[\"*\"]', '2026-06-08 21:04:14', NULL, '2026-06-08 19:46:06', '2026-06-08 21:04:14'),
(64, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', 'b8c9956a5b75cafa4bb98742740ded3f2125b5c4696ceeaee69d32aa746ff9c4', '[\"*\"]', '2026-06-08 22:25:57', NULL, '2026-06-08 21:04:15', '2026-06-08 22:25:57'),
(65, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', '23a7d5e076cab4473ff51220ff5b7b583c8021bf8acdce853fe8745f63a29258', '[\"*\"]', '2026-06-09 14:10:13', NULL, '2026-06-08 22:26:03', '2026-06-09 14:10:13'),
(66, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', '7c9a39ee2d1264a0ab1a0f4e0af5d357ceff40f96c4e920aa3dd258dbe0291c6', '[\"*\"]', '2026-06-09 14:27:46', NULL, '2026-06-09 14:18:14', '2026-06-09 14:27:46'),
(67, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', '10510bcb7988b510224d0e8c5b070790c58235e930508c6e4f9a7ec529987773', '[\"*\"]', '2026-06-09 15:09:35', NULL, '2026-06-09 14:29:10', '2026-06-09 15:09:35'),
(68, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', '4f7b762ebc592a47265a443eec477f4a2f45d42e670044427fdec72f953a192d', '[\"*\"]', '2026-06-09 15:44:38', NULL, '2026-06-09 15:09:40', '2026-06-09 15:44:38'),
(69, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', '3f4ee68c6231f2f72d8e439546cccc9bf07787f70e866f5fc3cbffa8798e2351', '[\"*\"]', '2026-06-09 20:12:43', NULL, '2026-06-09 15:44:44', '2026-06-09 20:12:43'),
(70, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', '77ea9587b8e2fbb1564e5e8489c5787fb8fcdfa51961f060a7347ecb5071e4f2', '[\"*\"]', '2026-06-10 01:13:48', NULL, '2026-06-09 20:12:47', '2026-06-10 01:13:48'),
(71, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', 'dbc79f53dde5139f99b4fb99d45f9c64994e0ed6cf94dc4e65b1b2cdab650e25', '[\"*\"]', '2026-06-10 01:44:44', NULL, '2026-06-10 01:16:12', '2026-06-10 01:44:44'),
(72, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', '5ddd244fd9e58eb9ac68aba59087f02d8695870b9752e55c8475185a02592785', '[\"*\"]', '2026-06-10 02:27:43', NULL, '2026-06-10 01:58:02', '2026-06-10 02:27:43'),
(73, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', '5763bcdcbcbe25199ebd8d3ca000b86f1d45437781a2fa8f20f912c12a65e3ba', '[\"*\"]', '2026-06-10 14:20:38', NULL, '2026-06-10 02:27:44', '2026-06-10 14:20:38'),
(74, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', 'd80b918c3621a496d11c1483892b1857f2dfc078d50a8260f4dfa72a7f1d281c', '[\"*\"]', '2026-06-10 15:33:40', NULL, '2026-06-10 14:20:40', '2026-06-10 15:33:40'),
(75, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', '62e99ed2f7c32a47b4e752271615caa78aa534c72b98133863c4351eb3ac9020', '[\"*\"]', '2026-06-11 02:23:58', NULL, '2026-06-10 16:10:31', '2026-06-11 02:23:58'),
(76, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', '41d854180cc6bc313976b33f91a8224ffec9b8e97ff3d3ce5fa99d80ad1762e8', '[\"*\"]', NULL, NULL, '2026-06-11 02:23:59', '2026-06-11 02:23:59'),
(77, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', 'cfe55cb84769c18436c64d4df50846ea27cf82b50f342575689874ea2afc8868', '[\"*\"]', NULL, NULL, '2026-06-11 02:24:10', '2026-06-11 02:24:10'),
(78, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', '0328d3db0b88d6ec03d9f761a8bb1dc4e31baf9f98713aad8d4aca5d08bd5be2', '[\"*\"]', NULL, NULL, '2026-06-11 02:24:27', '2026-06-11 02:24:27'),
(79, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', '4992c2c458f0d15545fe64275119a41a8903a1446d58d2f860628bbb61ff09a6', '[\"*\"]', '2026-06-11 02:39:12', NULL, '2026-06-11 02:31:29', '2026-06-11 02:39:12'),
(80, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', 'b777963928854ab663227320f6338ba63dc9bdd30ac1aa08791d9916f5077a1e', '[\"*\"]', '2026-06-11 14:24:10', NULL, '2026-06-11 03:20:04', '2026-06-11 14:24:10'),
(81, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', 'ed43837c2262c5a278981c886e458745d91f030d9455be89bdba9a8c7efc28ee', '[\"*\"]', '2026-06-11 14:55:55', NULL, '2026-06-11 14:54:27', '2026-06-11 14:55:55'),
(82, 'App\\Modules\\Auth\\Models\\User', 2, 'auth_token', 'c339c8a0467d5a90bca07e88a33437a2ce6dabe66a39e4e90147a21b3d1242f1', '[\"*\"]', '2026-06-11 15:45:44', NULL, '2026-06-11 14:56:08', '2026-06-11 15:45:44'),
(83, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', 'e6b67641168a3ae3a0e31a3eb289ecbc072b5a79bf07736ce452591ca3c0c4c6', '[\"*\"]', '2026-06-11 15:47:43', NULL, '2026-06-11 15:45:50', '2026-06-11 15:47:43'),
(84, 'App\\Modules\\Auth\\Models\\User', 2, 'auth_token', 'cb91903ad08790abe14e5e8a8073337329a2b66cfb538c071a3cbcd245a42c7f', '[\"*\"]', '2026-06-11 16:09:54', NULL, '2026-06-11 15:47:50', '2026-06-11 16:09:54'),
(85, 'App\\Modules\\Auth\\Models\\User', 2, 'auth_token', 'ad531e6f83d2032fa0bcc5547bce4932cb8ebbccbf5b89e5c84328fcbaff1e59', '[\"*\"]', '2026-06-11 21:15:13', NULL, '2026-06-11 16:10:16', '2026-06-11 21:15:13'),
(86, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', 'a6483d7f6b66dfbffa6bebb9369f04152778aa83abebaa98f28ae4197b399900', '[\"*\"]', '2026-06-12 16:26:29', NULL, '2026-06-11 21:15:21', '2026-06-12 16:26:29'),
(87, 'App\\Modules\\Auth\\Models\\User', 2, 'auth_token', '65687e076346d3e427b75391e276ab6a4d23ee48d389bc9ac8e880ed67faa927', '[\"*\"]', '2026-06-12 17:16:13', NULL, '2026-06-12 16:26:34', '2026-06-12 17:16:13'),
(88, 'App\\Modules\\Auth\\Models\\User', 30, 'auth_token', 'ff89aa543d19c046ffc688483d42477071a71e25cdae0b328f91976b96e59c8c', '[\"*\"]', '2026-06-12 18:01:00', NULL, '2026-06-12 17:16:16', '2026-06-12 18:01:00');

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `category_id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `excerpt` text COLLATE utf8mb4_unicode_ci,
  `content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `featured_image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('draft','published') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `seo_metadata` json DEFAULT NULL,
  `published_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`id`, `user_id`, `category_id`, `title`, `slug`, `excerpt`, `content`, `featured_image`, `status`, `seo_metadata`, `published_at`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 'O Poder Secreto da Lavanda', 'o-poder-secreto-da-lavanda', NULL, 'A lavanda não é apenas uma flor bonita; ela carrega séculos de história...', NULL, 'published', NULL, '2026-05-14 15:28:20', '2026-05-14 15:28:20', '2026-05-14 15:28:20'),
(2, 1, 2, 'Como Criar seu Próprio Ritual de Banho', 'como-criar-seu-proprio-ritual-de-banho', NULL, 'Um banho pode ser muito mais que higiene; pode ser uma renovação energética...', NULL, 'published', NULL, '2026-05-14 15:28:20', '2026-05-14 15:28:20', '2026-05-14 15:28:20');

-- --------------------------------------------------------

--
-- Table structure for table `post_categories`
--

CREATE TABLE `post_categories` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `post_categories`
--

INSERT INTO `post_categories` (`id`, `name`, `slug`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Sabedoria Ancestral', 'sabedoria-ancestral', 'Conhecimentos passados por gerações.', '2026-05-14 15:28:20', '2026-05-14 15:28:20'),
(2, 'Autocuidado', 'autocuidado', 'Rituais para o dia a dia.', '2026-05-14 15:28:20', '2026-05-14 15:28:20');

-- --------------------------------------------------------

--
-- Table structure for table `production_orders`
--

CREATE TABLE `production_orders` (
  `id` bigint UNSIGNED NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `recipe_id` bigint UNSIGNED NOT NULL,
  `product_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `status` enum('draft','in_progress','completed','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `planned_batches` int NOT NULL DEFAULT '1',
  `planned_yield` decimal(12,3) NOT NULL,
  `planned_cost` decimal(12,2) NOT NULL,
  `actual_batches` int DEFAULT NULL,
  `actual_yield` decimal(12,3) DEFAULT NULL,
  `actual_cost` decimal(12,2) DEFAULT NULL,
  `waste_quantity` decimal(12,3) DEFAULT NULL,
  `waste_notes` text COLLATE utf8mb4_unicode_ci,
  `started_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `production_orders`
--

INSERT INTO `production_orders` (`id`, `code`, `recipe_id`, `product_id`, `user_id`, `status`, `planned_batches`, `planned_yield`, `planned_cost`, `actual_batches`, `actual_yield`, `actual_cost`, `waste_quantity`, `waste_notes`, `started_at`, `completed_at`, `notes`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'OP-2026-0001', 1, 44, 1, 'completed', 1, 2.000, 40.10, 1, 2.000, 40.10, NULL, NULL, '2026-05-26 15:35:52', '2026-05-26 17:43:21', NULL, '2026-05-26 15:35:08', '2026-05-26 17:43:21', NULL),
(2, 'OP-2026-0002', 2, 45, 1, 'completed', 1, 2.000, 27.60, 1, 2.000, 27.60, NULL, NULL, '2026-05-26 18:04:52', '2026-05-26 18:05:17', NULL, '2026-05-26 18:04:44', '2026-05-26 18:05:17', NULL),
(3, 'OP-2026-0003', 8, 47, 1, 'completed', 1, 2.000, 33.85, 1, 2.000, 33.85, NULL, NULL, '2026-05-26 19:46:38', '2026-05-26 19:46:50', NULL, '2026-05-26 19:46:31', '2026-05-26 19:46:50', NULL),
(4, 'OP-2026-0004', 11, 46, 1, 'completed', 1, 2.000, 40.10, 1, 2.000, 40.10, NULL, NULL, '2026-05-26 19:47:05', '2026-05-26 19:47:12', NULL, '2026-05-26 19:46:58', '2026-05-26 19:47:12', NULL),
(5, 'OP-2026-0005', 8, 47, 30, 'completed', 1, 5.000, 71.00, 1, 5.000, 71.00, NULL, NULL, '2026-06-03 20:40:42', '2026-06-03 20:42:06', NULL, '2026-06-03 20:34:39', '2026-06-03 20:42:06', NULL),
(6, 'OP-2026-0006', 2, 45, 30, 'completed', 2, 10.000, 117.00, 2, 10.000, 117.00, NULL, NULL, '2026-06-03 20:40:36', '2026-06-03 20:41:45', NULL, '2026-06-03 20:34:52', '2026-06-03 20:41:45', NULL),
(7, 'OP-2026-0007', 11, 46, 30, 'completed', 2, 10.000, 163.70, 2, 10.000, 163.70, NULL, NULL, '2026-06-03 20:40:27', '2026-06-03 20:40:54', NULL, '2026-06-03 20:35:05', '2026-06-03 20:40:54', NULL),
(8, 'OP-2026-0008', 12, 49, 30, 'completed', 1, 5.000, 81.50, 1, 5.000, 81.50, NULL, NULL, '2026-06-03 20:39:39', '2026-06-03 20:40:17', NULL, '2026-06-03 20:39:30', '2026-06-03 20:40:17', NULL),
(9, 'OP-2026-0009', 15, 53, 30, 'completed', 1, 30.000, 116.92, 1, 30.000, 116.92, NULL, NULL, '2026-06-09 15:42:09', '2026-06-09 15:42:14', NULL, '2026-06-09 14:50:23', '2026-06-09 15:42:14', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `production_order_items`
--

CREATE TABLE `production_order_items` (
  `id` bigint UNSIGNED NOT NULL,
  `production_order_id` bigint UNSIGNED NOT NULL,
  `raw_material_id` bigint UNSIGNED NOT NULL,
  `batch_id` bigint UNSIGNED DEFAULT NULL,
  `planned_quantity` decimal(12,4) NOT NULL,
  `actual_quantity` decimal(12,4) DEFAULT NULL,
  `unit_cost` decimal(10,4) NOT NULL,
  `total_cost` decimal(12,4) NOT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `production_order_items`
--

INSERT INTO `production_order_items` (`id`, `production_order_id`, `raw_material_id`, `batch_id`, `planned_quantity`, `actual_quantity`, `unit_cost`, `total_cost`, `notes`, `created_at`, `updated_at`) VALUES
(1, 1, 56, NULL, 25.0000, 25.0000, 0.9000, 22.5000, NULL, '2026-05-26 15:35:08', '2026-05-26 17:43:21'),
(2, 1, 58, NULL, 0.5000, 0.5000, 18.0000, 9.0000, NULL, '2026-05-26 15:35:08', '2026-05-26 17:43:21'),
(3, 1, 59, NULL, 2.0000, 2.0000, 2.6500, 5.3000, NULL, '2026-05-26 15:35:08', '2026-05-26 17:43:21'),
(4, 1, 60, NULL, 2.0000, 2.0000, 1.6500, 3.3000, NULL, '2026-05-26 15:35:08', '2026-05-26 17:43:21'),
(5, 2, 54, NULL, 25.0000, 25.0000, 0.4000, 10.0000, NULL, '2026-05-26 18:04:44', '2026-05-26 18:05:17'),
(6, 2, 58, NULL, 0.5000, 0.5000, 18.0000, 9.0000, NULL, '2026-05-26 18:04:44', '2026-05-26 18:05:17'),
(7, 2, 59, NULL, 2.0000, 2.0000, 2.6500, 5.3000, NULL, '2026-05-26 18:04:44', '2026-05-26 18:05:17'),
(8, 2, 60, NULL, 2.0000, 2.0000, 1.6500, 3.3000, NULL, '2026-05-26 18:04:44', '2026-05-26 18:05:17'),
(9, 3, 58, NULL, 0.5000, 0.5000, 18.0000, 9.0000, NULL, '2026-05-26 19:46:31', '2026-05-26 19:46:50'),
(10, 3, 59, NULL, 2.0000, 2.0000, 2.6500, 5.3000, NULL, '2026-05-26 19:46:31', '2026-05-26 19:46:50'),
(11, 3, 60, NULL, 2.0000, 2.0000, 1.6500, 3.3000, NULL, '2026-05-26 19:46:31', '2026-05-26 19:46:50'),
(12, 3, 78, NULL, 25.0000, 25.0000, 0.6500, 16.2500, NULL, '2026-05-26 19:46:31', '2026-05-26 19:46:50'),
(13, 4, 56, NULL, 25.0000, 25.0000, 0.9000, 22.5000, NULL, '2026-05-26 19:46:58', '2026-05-26 19:47:12'),
(14, 4, 58, NULL, 0.5000, 0.5000, 18.0000, 9.0000, NULL, '2026-05-26 19:46:58', '2026-05-26 19:47:12'),
(15, 4, 59, NULL, 2.0000, 2.0000, 2.6500, 5.3000, NULL, '2026-05-26 19:46:58', '2026-05-26 19:47:12'),
(16, 4, 60, NULL, 2.0000, 2.0000, 1.6500, 3.3000, NULL, '2026-05-26 19:46:58', '2026-05-26 19:47:12'),
(17, 5, 58, NULL, 1.0000, 1.0000, 18.0000, 18.0000, NULL, '2026-06-03 20:34:39', '2026-06-03 20:42:06'),
(18, 5, 59, NULL, 4.0000, 4.0000, 2.6500, 10.6000, NULL, '2026-06-03 20:34:39', '2026-06-03 20:42:06'),
(19, 5, 60, NULL, 5.0000, 5.0000, 1.6500, 8.2500, NULL, '2026-06-03 20:34:39', '2026-06-03 20:42:06'),
(20, 5, 78, NULL, 50.0000, 50.0000, 0.6500, 32.5000, NULL, '2026-06-03 20:34:39', '2026-06-03 20:42:06'),
(21, 5, 79, NULL, 1.0000, 1.0000, 1.6500, 1.6500, NULL, '2026-06-03 20:34:39', '2026-06-03 20:42:06'),
(22, 6, 54, NULL, 100.0000, 100.0000, 0.4000, 40.0000, NULL, '2026-06-03 20:34:52', '2026-06-03 20:41:45'),
(23, 6, 58, NULL, 2.0000, 2.0000, 18.0000, 36.0000, NULL, '2026-06-03 20:34:52', '2026-06-03 20:41:45'),
(24, 6, 59, NULL, 8.0000, 8.0000, 2.6500, 21.2000, NULL, '2026-06-03 20:34:52', '2026-06-03 20:41:45'),
(25, 6, 60, NULL, 10.0000, 10.0000, 1.6500, 16.5000, NULL, '2026-06-03 20:34:52', '2026-06-03 20:41:45'),
(26, 6, 79, NULL, 2.0000, 2.0000, 1.6500, 3.3000, NULL, '2026-06-03 20:34:52', '2026-06-03 20:41:45'),
(27, 7, 56, NULL, 100.0000, 100.0000, 0.9000, 90.0000, NULL, '2026-06-03 20:35:05', '2026-06-03 20:40:53'),
(28, 7, 58, NULL, 2.0000, 2.0000, 18.0000, 36.0000, NULL, '2026-06-03 20:35:05', '2026-06-03 20:40:53'),
(29, 7, 59, NULL, 8.0000, 8.0000, 2.6500, 21.2000, NULL, '2026-06-03 20:35:05', '2026-06-03 20:40:53'),
(30, 7, 60, NULL, 10.0000, 10.0000, 1.6500, 16.5000, NULL, '2026-06-03 20:35:05', '2026-06-03 20:40:53'),
(31, 8, 59, NULL, 4.0000, 4.0000, 2.6500, 10.6000, NULL, '2026-06-03 20:39:30', '2026-06-03 20:40:17'),
(32, 8, 60, NULL, 5.0000, 5.0000, 1.6500, 8.2500, NULL, '2026-06-03 20:39:30', '2026-06-03 20:40:17'),
(33, 8, 79, NULL, 1.0000, 1.0000, 1.6500, 1.6500, NULL, '2026-06-03 20:39:30', '2026-06-03 20:40:17'),
(34, 8, 80, NULL, 25.0000, 25.0000, 0.9000, 22.5000, NULL, '2026-06-03 20:39:30', '2026-06-03 20:40:17'),
(35, 8, 81, NULL, 25.0000, 25.0000, 0.9000, 22.5000, NULL, '2026-06-03 20:39:30', '2026-06-03 20:40:17'),
(36, 8, 82, NULL, 1.0000, 1.0000, 16.0000, 16.0000, NULL, '2026-06-03 20:39:30', '2026-06-03 20:40:17'),
(37, 9, 57, NULL, 4.0000, 4.0000, 0.9000, 3.6000, NULL, '2026-06-09 14:50:23', '2026-06-09 15:42:10'),
(38, 9, 97, NULL, 40.0000, 40.0000, 0.0300, 1.2000, NULL, '2026-06-09 14:50:23', '2026-06-09 15:42:10'),
(39, 9, 102, NULL, 20.0000, 20.0000, 0.1600, 3.2000, NULL, '2026-06-09 14:50:23', '2026-06-09 15:42:10'),
(40, 9, 105, NULL, 8.0000, 8.0000, 0.5400, 4.3200, NULL, '2026-06-09 14:50:23', '2026-06-09 15:42:10'),
(41, 9, 113, NULL, 1.0000, 1.0000, 33.0000, 33.0000, NULL, '2026-06-09 14:50:23', '2026-06-09 15:42:10'),
(42, 9, 124, NULL, 20.0000, 20.0000, 0.1000, 2.0000, NULL, '2026-06-09 14:50:23', '2026-06-09 15:42:10'),
(43, 9, 125, NULL, 48.0000, 48.0000, 0.3800, 18.2400, NULL, '2026-06-09 14:50:23', '2026-06-09 15:42:10'),
(44, 9, 126, NULL, 28.0000, 28.0000, 0.1200, 3.3600, NULL, '2026-06-09 14:50:23', '2026-06-09 15:42:10'),
(45, 9, 127, NULL, 20.0000, 20.0000, 0.6000, 12.0000, NULL, '2026-06-09 14:50:23', '2026-06-09 15:42:10'),
(46, 9, 128, NULL, 30.0000, 30.0000, 1.2000, 36.0000, NULL, '2026-06-09 14:50:23', '2026-06-09 15:42:10');

-- --------------------------------------------------------

--
-- Table structure for table `production_order_outputs`
--

CREATE TABLE `production_order_outputs` (
  `id` bigint UNSIGNED NOT NULL,
  `production_order_id` bigint UNSIGNED NOT NULL,
  `itemable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `itemable_id` bigint UNSIGNED NOT NULL,
  `quantity` decimal(12,3) NOT NULL,
  `unit_cost` decimal(12,4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `production_order_outputs`
--

INSERT INTO `production_order_outputs` (`id`, `production_order_id`, `itemable_type`, `itemable_id`, `quantity`, `unit_cost`, `created_at`, `updated_at`) VALUES
(1, 8, 'App\\Modules\\Ecommerce\\Models\\Product', 49, 5.000, 16.3000, '2026-06-03 20:40:17', '2026-06-03 20:40:17'),
(2, 7, 'App\\Modules\\Ecommerce\\Models\\Product', 46, 10.000, 16.3700, '2026-06-03 20:40:54', '2026-06-03 20:40:54'),
(3, 6, 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 3, 8.000, 14.6067, '2026-06-03 20:41:45', '2026-06-03 20:41:45'),
(4, 6, 'App\\Modules\\Ecommerce\\Models\\ProductVariant', 4, 2.000, 0.0730, '2026-06-03 20:41:45', '2026-06-03 20:41:45'),
(5, 5, 'App\\Modules\\Ecommerce\\Models\\Product', 47, 5.000, 14.2000, '2026-06-03 20:42:06', '2026-06-03 20:42:06'),
(6, 9, 'App\\Modules\\Ecommerce\\Models\\Product', 53, 30.000, 3.8973, '2026-06-09 15:42:11', '2026-06-09 15:42:11');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `short_description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `unit_cost` decimal(10,4) DEFAULT NULL COMMENT 'Custo de produção por unidade',
  `old_price` decimal(10,2) DEFAULT NULL,
  `discount_percent` decimal(5,2) DEFAULT NULL,
  `promo_start` timestamp NULL DEFAULT NULL,
  `promo_end` timestamp NULL DEFAULT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `featured_image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `images` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `category_id` bigint UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `slug`, `description`, `short_description`, `price`, `unit_cost`, `old_price`, `discount_percent`, `promo_start`, `promo_end`, `stock`, `featured_image`, `is_active`, `images`, `created_at`, `updated_at`, `category_id`) VALUES
(19, 'Shampoo Fortalecedor e Crescimento Capilar', 'Shampoo-Fortalecedor', '🌿 Shampoo Fortalecedor “Alquimia da Terra”\n\nO ritual natural que desperta a força, o brilho e o crescimento dos seus cabelos.\n\nSeu cabelo não precisa apenas de limpeza.\nEle precisa de cuidado verdadeiro.\n\nCriado com ervas medicinais cuidadosamente maceradas por 29 dias, o Shampoo Fortalecedor Receita de Vovó transforma o banho em um ritual botânico de fortalecimento capilar.\n\n✨ Sinta seus fios mais fortes, encorpados, hidratados e cheios de vida desde as primeiras aplicações.\n\nNossa fórmula combina o poder ancestral das ervas com ativos naturais conhecidos por estimular o couro cabeludo, fortalecer a fibra capilar e devolver o brilho saudável dos fios.\n\n🌱 O poder das ervas da vovó:\n\n• Jaborandi & Alecrim\nDespertam o couro cabeludo e auxiliam no fortalecimento da raiz.\n\n• Bardana & Avenca\nPurificam e ajudam a manter os fios mais resistentes e equilibrados.\n\n• Babosa & Pantenol\nHidratação profunda, maciez e brilho espelhado.\n\n• Óleo de Rícino & Vitamina A\nNutrição intensa que ajuda a encorpar os fios e fortalecer a estrutura capilar.\n\n• Cravo & Canela\nUm toque estimulante e aromático que transforma seu banho em um verdadeiro ritual de autocuidado.\n\n💚 Por que escolher a Receita de Vovó?\n\n✔ Vegano\n✔ Livre de crueldade animal\n✔ Feito artesanalmente em Barueri\n✔ Ervas maceradas lentamente por 29 dias\n✔ Inspirado na sabedoria das ervas medicinais brasileiras\n\n👵 Dica da Vovó:\n\n“Passe o shampoo devagarinho, massageando o couro cabeludo com carinho. Deixe a espuma agir por alguns minutinhos enquanto o cheirinho das ervas abraça você. A natureza precisa de tempo para cuidar da raiz.”\n\n🌿 Seu cabelo merece mais do que química agressiva.\nMerece o cuidado das ervas, da tradição e da natureza.', NULL, 27.80, NULL, 35.00, NULL, NULL, NULL, 4, 'http://localhost:8000/storage/uploads/6a0dcd4a804c1.webp', 1, '[\"http://localhost:8000/storage/uploads/6a0dce1154426.webp\", \"http://localhost:8000/storage/uploads/6a0dce17254c6.webp\"]', '2026-05-16 17:16:54', '2026-05-29 14:34:40', 5),
(35, 'Creme Hidratante para as Mãos', 'creme-hidratante-mãos', '🌿\"A cura pelas ervas em suas mãos. Proteção e paz em cada toque.\"\n🌸\n\nImagine envolver suas mãos em uma luva invisível de seda e natureza. O Creme Hidratante para as Mãos da Receita de Vovó foi desenvolvido para quem busca mais que hidratação: busca um momento de pausa.\n\nCom uma base neutra, ele combina o poder cicatrizante de ervas ancestrais com óleos nobres que penetram profundamente, sem deixar a pele oleosa. O aroma exclusivo de Lavanda Francesa e Provença traz o equilíbrio que você precisa para enfrentar o dia com tranquilidade.\n\nIdeal para: Mãos ressecadas, peles sensíveis ou para quem deseja um ritual de aromaterapia no dia a dia.\n\n📖 Guia de Ingredientes: O que cada item faz por você?\n\nExtrato de Calêndula: Acalma irritações e tem alto poder anti-inflamatório.\n\nExtrato de Confrei: Poderoso regenerador celular, auxilia na cura de pequenas fissuras.\n\nExtrato de Babosa (Aloe Vera): Hidratação profunda e refrescância imediata.\n\nExtrato de Panaceia: Conhecida na sabedoria popular por \"curar todos os males\", ajuda na purificação da pele.\n\nÓleo de Semente de Uva: Rico em Vitamina E, previne o envelhecimento precoce das mãos.\n\nÓleo de Andiroba: Antisséptico e protetor, cria uma barreira contra agentes externos.\n\nÓleo de Girassol: Mantém a elasticidade e a maciez por muito mais tempo.\n\nÓleo de Silicone: Forma a \"luva invisível\", conferindo um toque aveludado e protegendo contra a umidade.\n\nEssências Lavanda Francesa e Provença: Proporcionam relaxamento profundo e combatem a ansiedade através do aroma.\n\nEssências de Almíscar e Patchouli: Garantem um perfume sofisticado, acolhedor e com longa fixação na pele.\n\n👵 Por que escolher a Receita de Vovó?\nProduto Vegano: Respeito total aos animais e à natureza.\nArtesanal: Feito em pequenos lotes para garantir a energia e a pureza das ervas.\nLivre de Parabenos: Sem químicas pesadas, apenas o que a terra oferece de melhor.\n\n👵 Dica da Vovó:\n\n\"Não passe o creme apenas por passar. Depois de espalhar nas mãos, leve-as ao rosto, feche os olhos e respire fundo três vezes. A Lavanda vai acalmar seus pensamentos enquanto o creme cuida da sua pele. É o seu minuto de paz no meio da correria.\"', NULL, 33.20, 2.4812, 37.70, NULL, NULL, NULL, 31, 'http://localhost:8000/storage/uploads/6a0dd5e012e10.webp', 1, '[\"http://localhost:8000/storage/uploads/6a0dd5d937c1e.webp\", \"http://localhost:8000/storage/uploads/6a0dd5e6e9cd4.webp\", \"http://localhost:8000/storage/uploads/6a0dd5ee35a4a.webp\", \"http://localhost:8000/storage/uploads/6a0dd64b6710a.webp\"]', '2026-05-20 18:42:07', '2026-06-12 17:24:01', 6),
(36, 'Creme Hidratante Facial de Rosas Noturno', 'creme-hidratante-facial', 'Creme Facial Regenerador: Rosa Mosqueta & Vitamina E\n\nA sinergia perfeita entre a tradição botânica e a proteção antioxidante.\n\nNosso creme facial foi redesenhado para oferecer o máximo de nutrição e defesa para a sua pele. Combinamos o poder cicatrizante da Rosa Mosqueta com a barreira protetora da Vitamina E, criando uma fórmula que não apenas hidrata, mas preserva a juventude do seu rosto.\n\nNova Composição de Alta Performance:\n\nVitamina E (Antioxidante): O escudo da pele. Protege contra a poluição e os radicais livres, prevenindo o envelhecimento precoce e ajudando na conservação natural do creme.\n\nÓleo de Rosa Mosqueta: Ouro líquido. Rico em ácidos essenciais, atua diretamente na regeneração de tecidos, suavizando manchas, linhas de expressão e cicatrizes.\n\nExtrato de Rosas Vermelhas: Equilíbrio e frescor. Tonifica a pele e ajuda a acalmar irritações, deixando um toque sedoso e renovado.\n\nCreme Hidratante Neutro; Base Pura. Veículo leve e hipoalergênico que garante que os ativos penetrem profundamente sem obstruir os poros.\n\nEssência de Rosa: Aromaterapia. Um perfume delicado que transforma o momento da aplicação em um ritual de spa em casa.\n\nPor que esta nova fórmula é superior?\n\nCom a adição da Vitamina E, seu creme agora oferece uma Dupla Camada de Regeneração:\n\nAção Profunda: A Rosa Mosqueta trabalha na renovação celular e nas camadas internas.\nAção Superficial: A Vitamina E protege a camada externa contra agressões do dia a dia (sol, vento, poluição).\nDiferenciais que você vai amar:\n\nPele mais firme: A Vitamina E auxilia na firmeza da pele a longo prazo.\nBrilho Natural: Devolve o viço de \"pele descansada\" logo nas primeiras semanas de uso.\n\nConservação Natural: A Vitamina E ajuda a manter os óleos vegetais frescos por mais tempo, garantindo a qualidade artesanal.', NULL, 33.20, 2.4140, 37.70, NULL, NULL, NULL, 30, 'http://localhost:8000/storage/uploads/6a0df075be390.webp', 1, '[\"http://localhost:8000/storage/uploads/6a0df0806db4a.webp\", \"http://localhost:8000/storage/uploads/6a0df08594bfc.webp\", \"http://localhost:8000/storage/uploads/6a0df08b9a6a7.webp\"]', '2026-05-20 20:34:07', '2026-06-12 17:23:43', 6),
(37, 'Creme Hidratante Corporal Toque de Rosas', 'creme-hidratante-corporal', 'Hidratação Real: O Toque das Rosas na sua Pele\n\nSinta a delicadeza e o frescor de um jardim em cada aplicação.\n\nNosso Creme Corporal é um convite ao autocuidado diário. Elaborado artesanalmente, ele combina a nobreza das rosas com óleos nutritivos para criar uma textura leve que envolve o corpo em hidratação e um perfume inesquecível.\n\nA Alquimia por trás da Maciez:\n\nBase Neutra Premium: Um creme leve e livre de excessos químicos, permitindo que os ativos naturais sejam absorvidos profundamente.\n\nExtrato de Rosa Vermelha: Atua como um tonificante natural e antioxidante, ajudando a manter a pele com aspecto jovem, firme e revigorado.\n\nExtrato de Camomila: Reduz irritações, vermelhidão e acalma peles sensíveis.\n\nÓleo de Rosa Mosqueta: Famoso por atenuar cicatrizes, estrias e rugas devido ao alto teor de ácidos graxos e vitamina A.\n\nÓleo de Amêndoas\n\nO clássico da hidratação. Cria uma barreira de proteção que impede a perda de água, garantindo uma pele macia por 24h.\n\nÓleo de Semente de Uva: Rico em vitamina E e ômega 6, tem toque leve e combate os radicais livres.\n\nEssência de Babosa (Aloe Vera): Calmante e refrescante, trazendo um equilíbrio natural e terapêutico para a mistura.\n\nEssência de Rosa Vermelha: Remete à sofisticação, paixão e elegância. É um aroma \"quente\" que traz presença ao produto.\n\nEssência de Rosa Branca: Traz paz, pureza e suavidade, equilibrando a fragrância, tornando-a mais delicada e menos enjoativa.\n\nEssência de La Nuit: Misteriosa, noturna e sedutora. Ela dá o toque de \"perfume de grife\" à sua loção, elevando seu creme.\n\nEssência de Andiroba: Conexão com a floresta e com a força da Amazônia. É um aroma mais rústico.\n\nVitamina E (Antioxidante): O escudo da pele. Protege contra a poluição e os radicais livres, prevenindo o envelhecimento precoce e ajudando na conservação natural do creme.\n\nPor que você vai se apaixonar?\n\nDiferente dos cremes industriais que muitas vezes apenas \"mascaram\" o ressecamento, nossa fórmula artesanal alimenta a pele.\n\nToque Seco e Aveludado: Hidrata sem deixar a pele oleosa.\nPerfume Irresistível: A essência de rosas vermelhas é marcante e feminina na medida certa.\n\nPureza Garantida: Sem aditivos pesados, respeitando o equilíbrio natural do seu corpo.\n\n\nDica de Uso da Vovó:\n\n\"Aplique o creme logo após o banho, com a pele ainda levemente úmida. Isso potencializa a absorção dos óleos e faz com que o perfume das rosas acompanhe você durante todo o dia.\"', NULL, 37.70, 12.4429, 44.00, NULL, NULL, NULL, 11, 'http://localhost:8000/storage/uploads/6a0df15c2a50c.webp', 1, '[\"http://localhost:8000/storage/uploads/6a0df16601102.webp\", \"http://localhost:8000/storage/uploads/6a0df17893357.webp\"]', '2026-05-20 20:38:04', '2026-06-12 17:24:58', 6),
(38, 'Elixir do Crescimento Extrato Fortalecedor e Cresimento Capilar', 'capilar-elixir-extrato-fortalecimento', 'Linha Crescimento e Força: O Segredo das Ervas no Seu Cabelo\nNa Receita de Vovó, acreditamos que a natureza guarda todas as respostas para o nosso cuidado pessoal. Por isso, desenvolvemos com muita dedicação e amor a nossa nova linha de tratamento capilar, focada em devolver a vitalidade, o brilho e, acima de tudo, a força para o crescimento dos seus fios.\n\nA Alquimia por Trás do Frasco\nNossa fórmula não é apenas um produto; é um ritual de cuidado feito à mão. Utilizamos extratos puros que passam pelo processo tradicional de maceração, garantindo que cada gota entregue o máximo poder das plantas.\n\nAlecrim: O motor da circulação que desperta o couro cabeludo para o crescimento.\nBabosa: A hidratação enzimática que nutre e regenera a fibra capilar desde a raiz.\nAvenca & Bardana: Uma dupla poderosa que fortalece o fio e mantém o equilíbrio natural da oleosidade.\nVitamina A: O toque final para acelerar a renovação celular e garantir fios mais vigorosos.\n\nCompromisso com a Vida\nAssim como todos os nossos itens, esta linha é 100% Vegana e livre de crueldade animal. Nossos produtos são artesanais e desenvolvidos para quem busca um autocuidado consciente e seguro.\n\n\"Para o cabelo crescer forte, ele precisa de terra boa e chuva mansa. Nossa linha é o carinho que alimenta a sua raiz.\" — Receita de Vovó\n\n👵 Dica da Vovó para o Crescimento:\n\"Meu filho, o segredo para o cabelo crescer não está na força, mas na paciência e no toque. Quando aplicar o seu Elixir, use a pontinha dos dedos para fazer uma massagem suave e circular em todo o couro cabeludo, como se estivesse fazendo um carinho na terra antes de plantar uma semente. Esse movimento faz o sangue circular e \'acorda\' o Alecrim e a Avenca para trabalharem melhor. E não esqueça: o melhor horário é antes de dormir, para que as ervas descansem com você e a natureza faça o trabalho dela em silêncio.\"', NULL, 35.00, NULL, 44.00, NULL, NULL, NULL, 1, 'http://localhost:8000/storage/uploads/6a0df23ac60e0.webp', 1, '[\"http://localhost:8000/storage/uploads/6a0df25237951.webp\", \"http://localhost:8000/storage/uploads/6a0df295103b6.webp\"]', '2026-05-20 20:42:46', '2026-05-29 14:34:40', 5),
(39, 'Sabonete Íntimo Artesanal', 'sabonete-íntimo', 'Sabonete Íntimo Receita de Vovó – O Cuidado Mais Puro da Natureza\nDescrição:\n\nResgatamos o poder das ervas e o conhecimento ancestral para criar um cuidado diário que respeita o seu corpo. O Sabonete Íntimo Receita de Vovó combina extratos botânicos selecionados em uma base neutra e suave, garantindo limpeza sem agredir o pH da região íntima.\n\nO que tem dentro (e por que faz bem)\n\nExtrato de Barbatimão: O \"queridinho\" da saúde feminina, conhecido por suas propriedades adstringentes e protetoras.\n\nExtrato de Calêndula: Acalma a pele, evita irritações e traz uma sensação de suavidade imediata.\n\nEtrato de Panaceia e Unha de Gato: Uma dupla imbatível que auxilia nas defesas naturais da pele com propriedades regeneradoras.\n\nExtrato de Uxi Amarelo: Tradicionalmente utilizado para o bem-estar do sistema reprodutor, reforça o cuidado preventivo.\n\nBase Neutra e Cocoamido: Limpeza delicada com espuma suave, derivada do coco, que limpa sem ressecar ou agredir a mucosa.\n\nPor que escolher nosso sabonete íntimo?\n🌿 1. O Poder do Barbatimão e da Panaceia\nDiferente de muitos sabonetes do mercado, usamos o extrato puro de Barbatimão, conhecido há gerações como um poderoso protetor natural. Junto com a Panaceia, ele forma uma barreira que auxilia na defesa da região íntima, mantendo a saúde em dia de forma preventiva e suave.\n\n🌼 2. Acalma e Protege com Calêndula\nA região íntima é sensível e pode sofrer com o atrito da roupa ou depilação. A Calêndula entra na nossa receita para acalmar a pele, prevenindo aquelas irritações chatas e trazendo uma sensação de conforto imediato após o banho.\n\n✨ 3. Fórmula \"Limpa\" e Respeitosa\nNossa base é suave e livre de componentes pesados. O uso do Cocoamido (um agente de limpeza muito delicado) faz com que a espuma seja cremosa, mas fácil de enxaguar, não deixando resíduos que possam causar desconforto ao longo do dia.\n\n❤️ 4. Confiança de Quem Faz com Carinho\nCada frasco carrega o conceito da Receita de Vovó: produtos botânicos, feitos com atenção aos detalhes e com o objetivo de resgatar o que a natureza tem de melhor para o nosso bem-estar.\n\nDicas da Vovó\n🌿 O Segredo de Família: \"O Uxi Amarelo e a Unha de Gato são como duas mãos que se dão: um protege e o outro fortalece. A dica da vovó é usar esse sabonete como um momento de carinho com você mesma. Se sentir qualquer desconforto ou irritação por causa do calor, ele é o seu melhor calmante natural.\"', NULL, 15.20, 7.0056, 18.80, NULL, NULL, NULL, 8, 'http://localhost:8000/storage/uploads/6a0df3533bf45.webp', 1, '[\"http://localhost:8000/storage/uploads/6a0df35e88ed6.webp\", \"http://localhost:8000/storage/uploads/6a0df36849b78.webp\"]', '2026-05-20 20:46:26', '2026-06-11 02:36:46', 2),
(40, 'Bio Alívio 21 Loção para Dores Alívio e bem-estar', 'Loção-para-dores-alívio-bem-estar', 'BioAlívio 21: O Poder da Natureza no Combate às Dores\n\nOnde a sabedoria das ervas encontra o conforto do cuidado diário.\n\nDescubra o segredo da sabedoria popular brasileira aliado à ciência do bem-estar. Nossa loção exclusiva combina 21 extratos naturais e ativos botânicos selecionados para proporcionar um alívio profundo, restaurando sua mobilidade e qualidade de vida.\n\nSeja para o cansaço do dia a dia, dores musculares após o treino ou desconfortos articulares crônicos, o BioAlívio 21 é o cuidado que seu corpo merece.\n\nPor que cada ingrediente faz a diferença?\n\nNossa fórmula foi desenhada em três pilares de ação:\n\n1. Regeneração e Alívio Articular\n\nCanela de Velho & Sucupira: A dupla imbatível para o bem-estar das articulações e cartilagens.\nMaçã de Elefante & Chapéu de Couro: Auxiliam na redução de inchaços e processos inflamatórios naturais.\nCaninha do Brejo & Cavalinha: Atuam na drenagem e purificação local, favorecendo a leveza dos movimentos.\n\n2. Ação Anti-inflamatória e Muscular\n\nErva Baleeira & Arnica: Consideradas as \"joias\" da flora brasileira para contusões e tensões musculares.\nDente de Leão & Rubim: Propriedades purificantes que acalmam a pele e os tecidos.\n7 Sangria & Erva de Bicho: Auxiliam na circulação, combatendo a sensação de pernas pesadas.\n\n3. Frescor e Proteção Térmica\n\nCânfora, Mentol e Salicilato de Mentila: Promovem o efeito hot-cold (quente e frio), que interrompe a percepção da dor imediatamente após a aplicação.\nHortelã, Calêndula e Romã: Refrescam e cuidam da saúde da pele, mantendo-a hidratada e protegida.\nGuaçatonga & Santa Maria: Potencializam a absorção dos ativos, garantindo que a loção penetre onde você mais precisa.\nBenefícios no seu Dia a Dia:\n\nAbsorção Rápida: Base em creme hidratante neutro que não deixa a pele pegajosa.\n\nAlívio Imediato: Sensação de frescor que relaxa os músculos instantaneamente.\n\nMultifuncional: Ideal para massagens relaxantes, dores nas costas, joelhos e ombros.\n\nPós-Treino ou Caminhada: Ideal para massagear os músculos cansados.\n\nFim de Dia: Relaxa as pernas e pés após longos períodos em pé ou sentado.\nMassagem Terapêutica: Sua base em creme desliza suavemente, facilitando a massagem.\n\nDica da \"Vovó\" (O Ritual do Alívio):\n\n\"Para um efeito ainda melhor, peça para alguém fazer uma massagem suave ou você mesma aplique com movimentos circulares e firmes. Depois, coloque uma roupa confortável e mantenha a região aquecida. É como se as ervas \'puxassem\' o cansaço para fora do corpo.\"', NULL, 37.70, 8.8733, 44.00, NULL, NULL, NULL, 5, 'http://localhost:8000/storage/uploads/6a0df43559a3e.webp', 1, '[\"http://localhost:8000/storage/uploads/6a0df43f19d82.webp\", \"http://localhost:8000/storage/uploads/6a0df4455c031.webp\", \"http://localhost:8000/storage/uploads/6a0df44b321ba.webp\"]', '2026-05-20 20:51:05', '2026-06-12 17:23:10', 7),
(41, 'Loção de  Panacéia', 'Loção-panaceia', '🌿\"A força das ervas que restauram, protegem e acalmam.\"\n\n✨\nA Loção de Panacéia é mais que um hidratante; é um tratamento botânico intensivo. Com uma textura fluida e de rápida absorção, ela combina o poder anti-inflamatório da Arnica com a regeneração celular do Confrei e da Bétula.\n\nSua base neutra e vegana permite que os extratos vegetais atuem com pureza total, sendo a escolha ideal para áreas que precisam de cuidado especial, alívio de tensões ou uma hidratação que realmente recupere a vitalidade da pele.\n\nSentir a Panacéia na pele é como receber um abraço curativo da natureza.\n\n📖 Guia de Ingredientes: O Poder da Natureza no Frasco\n\nExtrato de Panacéia: A base do nosso segredo: purifica e auxilia na saúde geral da derme.\n\nExtrato de Calêndula: Acalma peles sensíveis, reduz a vermelhidão e suaviza o toque.\n\nExtrato de Confrei: Age na renovação das células, sendo excelente para peles desvitalizadas.\n\nExtrato de Babosa: Garante hidratação profunda e uma camada de proteção refrescante.\n\nÓleo de Arnica: O melhor aliado contra o cansaço muscular e inflamações locais.\n\nBétula: Com propriedades purificantes, ajuda a tonificar e limpar profundamente.\n\nÓleo de Andiroba: Um poderoso repelente natural e antisséptico da Amazônia.\n\nÓleo de Camomila: Traz a paz e o relaxamento, acalmando até as peles mais reativas.\n\nCreme Neutro: Nossa base vegana que carrega todos os ativos com suavidade e pureza.\n\n💎 Diferenciais do Produto:\nFórmula Multiativa: Age em diversas frentes (hidratação, cicatrização e alívio).\nVegano e Artesanal: Feito com intenção e respeito à vida.\nToque Seco: Hidratação poderosa sem deixar a pele \"melada\".\n\n👵 Dica da Vovó para a Panacéia:\n\"Sabe aquele lugarzinho que está incomodando, uma pele mais áspera ou um cansaço que não passa? Aplique a Loção de Panacéia fazendo movimentos circulares e lentos. Enquanto massageia, imagine a força das ervas entrando e limpando tudo. Use logo após o banho, com o corpo ainda morno, para que a terra cure você por inteiro.\"', NULL, 37.70, 7.0386, 44.00, NULL, NULL, NULL, 1, 'http://localhost:8000/storage/uploads/6a0df5c680d28.webp', 1, '[\"http://localhost:8000/storage/uploads/6a0df5cabdf36.webp\", \"http://localhost:8000/storage/uploads/6a0df5d32b0db.webp\", \"http://localhost:8000/storage/uploads/6a0df5d7a902f.webp\"]', '2026-05-20 20:56:52', '2026-06-09 16:00:46', 7),
(42, 'Xampunete de Panacéia Equilíbrio do Corpo e Capilar', 'Shampoo-sabonete-panacéia-regeeração', 'Xampunete de Panacéia – O Bálsamo 2 em 1\n\"Limpeza profunda e alívio imediato para corpo e cabelo.\"\n\n✨ Descrição\nO Xampunete de Panacéia é a solução definitiva da Receita de Vovó para quem busca praticidade sem abrir mão do tratamento fitoterápico intenso. Formulado como um produto multifuncional, ele atua tanto como um xampu restaurador quanto como um sabonete líquido calmante.\n\nSua fórmula é especialmente indicada para peles que sofrem com alergias, irritações persistentes e sintomas de psoríase. Através da nossa extração artesanal, conseguimos concentrar as propriedades anti-inflamatórias e cicatrizantes das ervas em uma base neutra e vegana que respeita o equilíbrio natural da sua pele e fios.\n\n📖 O Poder da Trindade Botânica (Extração de 29 Dias)\nComo em toda a nossa linha, os ativos são extraídos em um processo de maceração de 29 dias, garantindo pureza e eficácia:\n\nO Poder da Restauração:\n\nExtrato de Panacéia: A \"cura total\" que combate inflamações e auxilia na regeneração de peles com descamação e psoríase.\n\nExtrato de Calêndula: O braço direito contra alergias e vermelhidão, acalmando a pele no momento do contato.\n\nExtrato de Babosa (Aloe Vera): Hidrata profundamente, criando uma barreira protetora que impede o ressecamento excessivo.\n\nBase Neutra Vegana: Livre de sulfatos agressivos, ideal para peles extremamente sensíveis.\n\n👵 Dica da Vovó: Como usar para tratamento\n\"Para quem sofre com coceiras ou pele irritada, a dica é simples: no banho, passe o Xampunete e deixe a espuma descansar sobre a pele ou o couro cabeludo por uns 3 minutinhos. É o tempo que as ervas precisam para \'beber\' a irritação e começar a cura. Enxágue com água morna, nunca pelando de quente, para não assustar a pele que já está sofrida.\"\n\nSempre busque uma orientação médica.', NULL, 19.70, NULL, 25.10, NULL, NULL, NULL, 2, 'http://localhost:8000/storage/uploads/6a0df6e3c893d.webp', 1, '[\"http://localhost:8000/storage/uploads/6a0df6e7caa17.webp\", \"http://localhost:8000/storage/uploads/6a0df6ecb197c.webp\", \"http://localhost:8000/storage/uploads/6a0df6f5e25b0.webp\"]', '2026-05-20 21:01:27', '2026-06-11 02:36:46', NULL),
(43, 'Creme Hidratante para os Pés', 'Creme-hidratante-pés', 'O Poder da Natureza nos Seus Pés\n\nA ciência da terra unida ao cuidado artesanal.\n\nCada ingrediente do nosso hidratante foi selecionado para criar uma barreira de proteção e restauração profunda. Conheça o que compõe este frasco de bem-estar:\n\nUreia: O segredo da hidratação intensa. Ela retém a umidade na pele, combatendo o ressecamento extremo e as rachaduras.\n\nExtrato de Calêndula: Com propriedades calmantes e cicatrizantes, acalma a pele cansada e auxilia na regeneração celular.\n\nÓleo de Semente de Uva: Rico em Vitamina E, penetra rapidamente sem deixar a pele pegajosa, agindo como um poderoso antioxidante.\n\nÓleo de Amêndoas: Proporciona uma maciez incomparável e melhora a elasticidade da pele dos pés.\n\nÓleo de Girassol: Cria uma camada protetora que mantém a hidratação por muito mais tempo.\n\nÓleo de Andiroba: Um tesouro da Amazônia com ação anti-inflamatória e regeneradora, ideal para pés sobrecarregados.\n\nÓleo de Babosa (Aloe Vera): Nutre profundamente e refresca, trazendo alívio imediato e vitalidade.\n\nEssência de Rosa: Finaliza o ritual com um toque delicado, proporcionando uma sensação de relaxamento e sofisticação.\n\nEssência de Andiroba: Proteção natural e toque aveludado.\n\nVitamina E (Antioxidante): O escudo da pele. Protege contra a poluição e os radicais livres, prevenindo o envelhecimento precoce e ajudando na conservação natural do creme.\n\nPor que escolher nossa fórmula?\n\nDiferente dos produtos industrializados, nossa base de Creme Hidratante Neutro serve como um veículo puro para que esses óleos e extratos ajam com 100% de sua eficácia. Sem excesso de químicos, apenas o essencial para a sua saúde.\n\nDica de uso:\n\nToque de Vovó: Para um resultado de \"pés de seda\", aplique o creme generosamente antes de dormir e use uma meia de algodão. Aqueça o coração e cuide do seu corpo.', NULL, 33.20, 2.6519, 37.70, NULL, NULL, NULL, 65, 'http://localhost:8000/storage/uploads/6a0df7cf30bdc.webp', 1, '[\"http://localhost:8000/storage/uploads/6a0df7d45bc3e.webp\", \"http://localhost:8000/storage/uploads/6a0df7dd73afa.webp\", \"http://localhost:8000/storage/uploads/6a0df7e3b6d9c.webp\", \"http://localhost:8000/storage/uploads/6a0df7ecbfbfb.webp\"]', '2026-05-20 21:05:35', '2026-06-12 17:25:22', 6),
(44, 'Body Splash - Marly Delina', 'body-splash-marly-delina', '✨ Mimos de Vó — Body Splash Delina ✨\n\nDelicado, sofisticado e absolutamente encantador.\nO Body Splash Delina — Mimos de Vó foi criado para mulheres que amam fragrâncias femininas, elegantes e inesquecíveis.\n\nInspirado em perfumes florais luxuosos, ele combina suavidade e sofisticação em uma fragrância envolvente que transforma cada borrifada em um momento especial de autocuidado e beleza.\n\nA linha Mimos de Vó da Receita de Vovó nasceu para representar aqueles pequenos gestos de carinho que aquecem o coração — os mimos que fazem a gente se sentir cuidada, especial e perfumada todos os dias.\n\nO Delina revela um perfume floral sofisticado com toque delicadamente adocicado, trazendo sensação de leveza, romantismo e feminilidade elegante.\n\nSua fragrância transmite:\n🌸 delicadeza marcante\n🌸 elegância feminina\n🌸 perfume sofisticado\n🌸 suavidade envolvente\n🌸 luxo floral moderno\n\nIdeal para:\n✨ uso diário\n✨ momentos especiais\n✨ mulheres delicadas e sofisticadas\n✨ quem ama perfumes florais elegantes e memoráveis\n\nMais do que um body splash, ele é:\n\num gesto de autocuidado;\numa experiência sensorial;\num perfume que desperta autoestima;\num mimo pensado para deixar seus dias ainda mais especiais.\n\nCom brilho sofisticado, embalagem delicada e fragrância apaixonante, o Delina — Mimos de Vó transforma pequenos momentos em experiências cheias de beleza, elegância e carinho.\n\n🌸 Mimos de Vó\nPorque toda mulher merece sentir-se perfumada, confiante e inesquecível.', NULL, 60.20, 16.7000, 85.40, NULL, NULL, NULL, 1, 'http://localhost:8000/storage/uploads/6a15911ca9482.webp', 1, '[\"http://localhost:8000/storage/uploads/6a1591225a7a6.webp\", \"http://localhost:8000/storage/uploads/6a1591a603048.webp\", \"http://localhost:8000/storage/uploads/6a1591abac34e.webp\"]', '2026-05-26 15:30:30', '2026-06-09 19:17:46', NULL),
(45, 'Body Splash - Scandal', 'Body-Splash-Scandal', '✨ Mimos de Vó — Body Splash Scandal ✨\n\nIntenso, envolvente e irresistivelmente feminino.\nO Body Splash Scandal — Mimos de Vó foi criado para mulheres que gostam de marcar presença com elegância, atitude e um perfume inesquecível.\n\nInspirado em fragrâncias modernas e marcantes, ele combina sensualidade e sofisticação em uma experiência perfumada que desperta confiança, autoestima e poder feminino.\n\nA linha Mimos de Vó da Receita de Vovó nasceu para transformar carinho em momentos especiais, trazendo fragrâncias inspiradas na beleza, no autocuidado e na sensação acolhedora dos pequenos mimos que fazem toda diferença.\n\nO Scandal revela uma fragrância doce, sofisticada e envolvente, perfeita para mulheres modernas que amam perfumes impactantes e cheios de personalidade.\n\nSua fragrância transmite:\n✨ sensualidade elegante\n✨ feminilidade marcante\n✨ perfume intenso e envolvente\n✨ sofisticação moderna\n✨ presença inesquecível\n\nIdeal para:\n🌸 ocasiões especiais\n🌸 momentos de autoestima\n🌸 uso noturno\n🌸 mulheres confiantes e sofisticadas\n🌸 quem ama fragrâncias doces e marcantes\n\nMais do que um body splash, ele é:\n\num gesto de autocuidado;\numa experiência sensorial envolvente;\num perfume que desperta olhares e elogios;\num mimo pensado para fazer você se sentir ainda mais poderosa.\n\nCom brilho sofisticado, embalagem delicada e fragrância apaixonante, o Scandal — Mimos de Vó transforma cada borrifada em um momento de beleza, confiança e elegância.\n\n🌸 Mimos de Vó\nPorque toda mulher merece sentir-se linda, perfumada e inesquecível todos os dias.', NULL, 60.20, 11.7000, 85.40, NULL, NULL, NULL, 10, 'http://localhost:8000/storage/uploads/6a15b5c4a2d66.webp', 1, '[\"http://localhost:8000/storage/uploads/6a15b5cc985df.webp\", \"http://localhost:8000/storage/uploads/6a15b5d3a074b.webp\", \"http://localhost:8000/storage/uploads/6a15b5d947cff.webp\"]', '2026-05-26 18:02:28', '2026-06-09 19:17:09', 8),
(46, 'Body Splash - Royal Ambar', 'Body-Splash-Royal-Ambar', '✨ Mimos de Vó — Body Splash Royal Amber ✨\n\nQuente, sofisticado e envolvente.\nO Body Splash Royal Amber — Mimos de Vó foi criado para mulheres que amam fragrâncias marcantes, elegantes e cheias de personalidade.\n\nInspirado em perfumes ambarados luxuosos, ele combina sensualidade, aconchego e sofisticação em uma fragrância intensa e irresistível, perfeita para transformar qualquer momento em uma experiência especial.\n\nA linha Mimos de Vó da Receita de Vovó nasceu para representar aqueles pequenos gestos de carinho que aquecem o coração — os mimos especiais que fazem a gente se sentir cuidada, confiante e ainda mais bonita.\n\nO Royal Amber revela uma fragrância envolvente com notas quentes e sofisticadas, trazendo sensação de conforto elegante, feminilidade intensa e luxo moderno.\n\nSua fragrância transmite:\n✨ sofisticação marcante\n✨ calor envolvente\n✨ feminilidade elegante\n✨ perfume intenso e aconchegante\n✨ presença inesquecível\n\nIdeal para:\n🌸 noites especiais\n🌸 momentos de autoestima\n🌸 mulheres sofisticadas e confiantes\n🌸 quem ama fragrâncias quentes e elegantes\n🌸 ocasiões em que você deseja se sentir ainda mais poderosa\n\nMais do que um body splash, ele é:\n\num ritual de autocuidado;\numa experiência sensorial envolvente;\num perfume que desperta elegância e confiança;\num mimo pensado para transformar sua rotina em momentos especiais.\n\nCom brilho sofisticado, embalagem delicada e fragrância apaixonante, o Royal Amber — Mimos de Vó transforma cada borrifada em uma experiência intensa, elegante e memorável.\n\n🌸 Mimos de Vó\nPorque todo carinho também pode ser sofisticado, marcante e inesquecível.', NULL, 60.20, 16.3700, 85.40, NULL, NULL, NULL, 10, 'http://localhost:8000/storage/uploads/6a15b7515d1b6.webp', 1, '[\"http://localhost:8000/storage/uploads/6a15b757c8efa.webp\", \"http://localhost:8000/storage/uploads/6a15b75de5d8f.webp\", \"http://localhost:8000/storage/uploads/6a15b7655a25b.webp\", \"http://localhost:8000/storage/uploads/6a15b76eae3aa.webp\"]', '2026-05-26 18:08:34', '2026-06-09 16:02:30', 8),
(47, 'Body Splash - Good Girl', 'Body-Splash-Good-Girl', '✨ Mimos de Vó — Body Splash Good Girl ✨\n\nMarcante, sofisticado e irresistivelmente feminino.\nO Body Splash Good Girl — Mimos de Vó foi criado para mulheres que amam fragrâncias elegantes, envolventes e cheias de personalidade.\n\nInspirado em perfumes modernos e sofisticados, ele combina delicadeza e intensidade em uma fragrância apaixonante que desperta confiança, charme e autoestima em cada borrifada.\n\nA linha Mimos de Vó da Receita de Vovó nasceu para transformar carinho em experiências especiais, trazendo fragrâncias inspiradas nos pequenos mimos que fazem toda mulher se sentir única, cuidada e inesquecível.\n\nO Good Girl revela uma fragrância floral oriental envolvente, com toque doce sofisticado e presença marcante, perfeita para mulheres modernas que gostam de deixar sua essência por onde passam.\n\nSua fragrância transmite:\n✨ feminilidade sofisticada\n✨ sensualidade elegante\n✨ perfume envolvente e marcante\n✨ modernidade e confiança\n✨ charme irresistível\n\nIdeal para:\n🌸 uso diário\n🌸 ocasiões especiais\n🌸 momentos de autoestima\n🌸 mulheres elegantes e confiantes\n🌸 quem ama fragrâncias doces e sofisticadas\n\nMais do que um body splash, ele é:\n\num gesto de autocuidado;\numa experiência sensorial envolvente;\num perfume que desperta elogios;\num mimo pensado para elevar sua beleza e confiança todos os dias.\n\nCom brilho sofisticado, embalagem delicada e fragrância inesquecível, o Good Girl — Mimos de Vó transforma cada momento em uma experiência perfumada cheia de elegância, charme e feminilidade.\n\n🌸 Mimos de Vó\nPorque toda mulher merece sentir-se linda, perfumada e especial em todos os momentos.', NULL, 60.20, 14.2000, 85.40, NULL, NULL, NULL, 5, 'http://localhost:8000/storage/uploads/6a15b9d746972.webp', 1, '[\"http://localhost:8000/storage/uploads/6a15b9dd188bc.webp\", \"http://localhost:8000/storage/uploads/6a15b9e302011.webp\", \"http://localhost:8000/storage/uploads/6a15b9ec5db71.webp\", \"http://localhost:8000/storage/uploads/6a15b9f207b24.webp\"]', '2026-05-26 18:19:17', '2026-06-09 19:18:23', 8),
(48, 'Home Spray - Doce Lar', 'Home-Spray-Doce-Lar', '✨ Mimos para Casa — Home Spray Doce Lar ✨\n\nA verdadeira sensação de lar vai muito além da decoração.\nEla está no perfume que acolhe, nas memórias que aquecem e no conforto que sentimos ao entrar em casa.\n\nO Home Spray Doce Lar — Mimos para Casa foi criado para transformar ambientes em experiências de aconchego, sofisticação e bem-estar.\n\nInspirado em fragrâncias elegantes e refinadas, ele combina delicadeza, limpeza sofisticada e um toque envolvente que deixa cada espaço ainda mais especial e acolhedor.\n\nA nova linha Mimos para Casa da Receita de Vovó nasceu para levar o carinho da Receita de Vovó para dentro do lar, criando produtos que despertam conforto, elegância e memórias afetivas em cada detalhe.\n\nO Doce Lar possui uma fragrância suave, sofisticada e marcante na medida certa, perfeita para perfumar ambientes com sensação de:\n✨ casa limpa e aconchegante\n✨ elegância delicada\n✨ conforto sofisticado\n✨ bem-estar diário\n✨ ambiente acolhedor e perfumado\n\nIdeal para:\n🏡 salas\n🏡 quartos\n🏡 roupas de cama\n🏡 cortinas\n🏡 lavabos\n🏡 ambientes especiais\n\nMais do que um home spray, ele é:\n\num gesto de carinho para sua casa;\num toque de sofisticação no dia a dia;\numa experiência sensorial acolhedora;\num mimo pensado para transformar ambientes em momentos especiais.\n\nCom embalagem elegante, frasco âmbar sofisticado e detalhes delicados que encantam, o Doce Lar — Mimos para Casa une perfume, beleza e aconchego em um único produto.\n\n🌿 Mimos para Casa\nPorque uma casa perfumada também abraça quem chega.', NULL, 45.80, NULL, 65.60, NULL, NULL, NULL, 1, 'http://localhost:8000/storage/uploads/6a16436287e50.webp', 1, '[\"http://localhost:8000/storage/uploads/6a1643679648e.webp\", \"http://localhost:8000/storage/uploads/6a16437116ec6.webp\", \"http://localhost:8000/storage/uploads/6a16437dbf965.webp\", \"http://localhost:8000/storage/uploads/6a16438d4cb13.webp\", \"http://localhost:8000/storage/uploads/6a164399d0723.webp\"]', '2026-05-27 04:06:45', '2026-06-11 21:27:58', 9),
(49, 'Body Splash Bourbon Intense', 'Body-Splash-bourbon-intense', '✨ Mimos de Vó — Body Splash Bourbon Intenso ✨\n\nPresença marcante. Elegância natural. Confiança em cada borrifada.\nO Body Splash Bourbon Intenso — Mimos de Vó foi criado para homens que valorizam personalidade, sofisticação e autenticidade.\n\nInspirado na combinação de grandes fragrâncias orientais masculinas, ele une a intensidade das especiarias, a profundidade das madeiras e o calor envolvente das notas ambaradas, criando uma experiência marcante, elegante e memorável.\n\nA linha Mimos de Vó nasceu para transformar o cuidado diário em um momento especial. E agora, apresenta uma fragrância masculina desenvolvida para homens que gostam de estar bem cuidados, perfumados e confiantes em qualquer ocasião.\n\nMais do que um body splash, o Bourbon Intenso é uma assinatura de estilo.\n________________________________________\n🖤 Uma fragrância que transmite\n✨ presença elegante\n✨ masculinidade moderna\n✨ confiança natural\n✨ sofisticação sem exageros\n✨ personalidade marcante\n✨ conforto e bem-estar ao longo do dia\n________________________________________\n\n🌿 A Experiência Bourbon Intenso\nA abertura revela acordes envolventes e especiados que despertam os sentidos.\n\nEm seguida surgem notas quentes e amadeiradas que transmitem força, equilíbrio e maturidade.\n\nPor fim, nuances ambaradas e levemente adocicadas criam uma sensação acolhedora e sofisticada, deixando uma presença agradável e inesquecível na pele.\n\nO resultado é uma fragrância versátil, capaz de acompanhar tanto a rotina diária quanto momentos especiais.\n________________________________________\n\nIdeal para\n🖤 trabalho e reuniões\n🖤 encontros especiais\n🖤 eventos sociais\n🖤 uso diário\n🖤 homens que gostam de fragrâncias sofisticadas\n🖤 quem busca elegância sem excessos\n________________________________________\n\nMais do que um body splash\n• um momento de autocuidado\n• uma fragrância que transmite confiança\n• um ritual diário de bem-estar\n• um toque de sofisticação para qualquer ocasião\n• um mimo pensado especialmente para homens que valorizam sua presença', NULL, 60.20, 16.3000, 85.40, NULL, NULL, NULL, 5, NULL, 1, '[]', '2026-06-03 16:11:52', '2026-06-09 19:19:40', 8),
(50, 'Home Spray - Casa Iluminada', 'Home-Spray-Casa-Iluminada', '✨ **Mimos para Casa — Home Spray Casa Iluminada** ✨\n\nTransforme sua casa em um ambiente leve, elegante e cheio de boas energias.\n\nO **Home Spray Casa Iluminada — Mimos para Casa** foi criado para quem ama a sensação de ambientes frescos, harmoniosos e naturalmente sofisticados.\n\nInspirado na delicadeza e no frescor das fragrâncias de bambu presentes nos ambientes mais refinados, ele desperta uma atmosfera de serenidade, equilíbrio e bem-estar, tornando cada espaço mais acolhedor e agradável.\n\nA linha **Mimos para Casa**, da Receita de Vovó, nasceu para levar o cuidado e o carinho que você já conhece para além do autocuidado, criando experiências sensoriais que transformam a casa em um verdadeiro refúgio.\n\nO **Casa Iluminada** revela uma fragrância fresca, elegante e revigorante, perfeita para transmitir sensação de:\n\n✨ ambiente leve e harmonioso\n✨ frescor natural e sofisticado\n✨ tranquilidade e equilíbrio\n✨ casa organizada e acolhedora\n✨ bem-estar renovador\n\nSeu aroma suave e refinado envolve os ambientes de forma delicada, proporcionando uma sensação de conforto que permanece ao longo do dia.\n\nIdeal para:\n\n🏡 salas de estar\n🏡 quartos\n🏡 escritórios\n🏡 roupas de cama\n🏡 cortinas\n🏡 lavabos\n🏡 ambientes de relaxamento\n\nMais do que um home spray, ele é:\n\num convite ao bem-estar;\numa sensação de renovação diária;\num toque de elegância natural para sua casa;\num mimo pensado para iluminar os ambientes e os momentos especiais.\n\nCom embalagem elegante, frasco âmbar sofisticado e detalhes delicados feitos para encantar, o **Casa Iluminada — Mimos para Casa** une frescor, beleza e aconchego em uma experiência única para o seu lar.\n\n🌿 **Mimos para Casa**\nPorque uma casa iluminada pelo carinho também pode ser iluminada pelo perfume. ✨🏡💚\n\n---\n\n### Posicionamento da coleção\n\nEnquanto o **Doce Lar** transmite **aconchego e conforto afetivo**, o **Casa Iluminada** representa **leveza, frescor e renovação**, permitindo que o cliente escolha a atmosfera que deseja criar em casa:\n\n🏡 **Doce Lar** → acolhedor, confortável e envolvente.\n🎋 **Casa Iluminada** → fresco, elegante, leve e harmonioso.', NULL, 45.80, NULL, 65.80, NULL, NULL, NULL, 2, NULL, 1, '[]', '2026-06-08 18:16:04', '2026-06-10 14:58:42', 9),
(51, 'Home Spray - Casa Serena', 'Home-Spray-Casa-Serena', '✨ **Mimos para Casa — Home Spray Casa Serena** ✨\n\nTransforme sua casa em um refúgio de tranquilidade, equilíbrio e bem-estar.\n\nO **Home Spray Casa Serena — Mimos para Casa** foi criado para quem valoriza momentos de calma, leveza e conexão com o que realmente importa.\n\nInspirado na sofisticação aromática do alecrim, uma fragrância tradicionalmente associada à renovação, harmonia e sensação de frescor, ele envolve os ambientes com uma presença elegante e acolhedora, tornando cada espaço mais agradável e convidativo.\n\nA linha **Mimos para Casa**, da Receita de Vovó, nasceu para levar o cuidado e o carinho além dos produtos de autocuidado, criando experiências que transformam os ambientes em lugares cheios de conforto, afeto e bem-estar.\n\nO **Casa Serena** revela uma fragrância fresca, herbal e sofisticada, perfeita para transmitir sensação de:\n\n✨ serenidade e equilíbrio\n✨ frescor natural e revitalizante\n✨ paz e tranquilidade no dia a dia\n✨ ambiente acolhedor e harmonioso\n✨ bem-estar para corpo e mente\n\nSeu aroma delicado desperta uma sensação de leveza que ajuda a tornar os momentos em casa ainda mais especiais, criando uma atmosfera agradável para relaxar, receber visitas ou simplesmente aproveitar o seu espaço.\n\nIdeal para:\n\n🏡 salas de estar\n🏡 quartos\n🏡 escritórios e home office\n🏡 lavabos\n🏡 corredores\n🏡 roupas de cama\n🏡 ambientes de meditação e relaxamento\n\nMais do que um home spray, ele é:\n\num convite para desacelerar;\numa pausa perfumada na rotina;\num toque de frescor e equilíbrio para o lar;\num mimo pensado para transformar ambientes em espaços de paz e acolhimento.\n\nCom embalagem elegante, frasco âmbar sofisticado e detalhes delicados feitos para encantar, o **Casa Serena — Mimos para Casa** une frescor, elegância e bem-estar em uma experiência que acolhe todos os sentidos.\n\n🌿 **Mimos para Casa**\nPorque os melhores momentos acontecem em ambientes que transmitem paz.', NULL, 45.80, NULL, 65.60, NULL, NULL, NULL, 2, NULL, 1, '[]', '2026-06-08 18:18:16', '2026-06-08 18:19:57', 9),
(52, 'Body Splash - Ateliê de Vovó', 'Body-Splash-Atelie-Vovó', 'Acho que para o **Ateliê de Vovó** vale trabalhar um posicionamento diferente do restante da marca. Enquanto a linha **Receita de Vovó** transmite carinho, cuidado e tradição, e a linha **Mimos para Casa** fala de experiências para o lar, o **Ateliê de Vovó** pode ser apresentado como um espaço de criação exclusiva, onde cada produto é feito sob medida para o cliente.\n\nPara o Body Splash, eu seguiria algo como:\n\n✨ Ateliê de Vovó — Body Splash Exclusivo ✨\n\nAlgumas fragrâncias encantam.\nOutras contam histórias.\n\nO Ateliê de Vovó nasceu para transformar preferências, memórias e inspirações em criações exclusivas, desenvolvidas especialmente para quem deseja algo único.\n\nAqui, cada Body Splash é produzido sob encomenda, permitindo que você escolha fragrâncias que fazem parte da sua história, dos seus momentos especiais ou simplesmente do seu gosto pessoal.\n\nMais do que um produto, o Ateliê de Vovó oferece uma experiência personalizada, onde cada criação recebe atenção aos detalhes, cuidado artesanal e todo o carinho que faz parte da essência da Receita de Vovó.\n\nSe você sonha em usar uma fragrância inspirada em um perfume que ama, em uma lembrança especial ou em uma combinação única, o Ateliê de Vovó transforma essa inspiração em realidade.\n\nNosso Body Splash proporciona uma perfumação leve e agradável, ideal para o dia a dia, trazendo frescor, personalidade e exclusividade para cada momento.\n\nPerfeito para quem busca:\n\n✨ fragrâncias exclusivas\n✨ produções sob encomenda\n✨ experiências personalizadas\n✨ presentes especiais\n✨ produtos feitos com carinho e atenção aos detalhes\n\nCada criação é desenvolvida especialmente para você, tornando cada frasco tão único quanto a sua história.\n\n🌿 Ateliê de Vovó\n\nPorque algumas fragrâncias não devem ser escolhidas em uma prateleira.\nElas devem ser criadas especialmente para você.', NULL, 60.20, NULL, 85.40, NULL, NULL, NULL, 0, NULL, 1, '[]', '2026-06-08 18:28:11', '2026-06-08 18:29:13', 8),
(53, 'Creme Hidratante Facial Diurno', 'creme-hidratante-facial-Diurno', '✨ Receita de Vovó — Creme Facial Diurno ✨\n\nSua pele merece cuidado, proteção e hidratação desde o primeiro momento do dia.\n\nO Creme Facial Diurno da Receita de Vovó foi desenvolvido para proporcionar hidratação equilibrada, toque suave e sensação de conforto ao longo do dia, ajudando a manter a pele bonita, macia e bem cuidada.\n\nSua fórmula combina ingredientes cuidadosamente selecionados para nutrir a pele sem deixá-la pesada, proporcionando uma aparência saudável, iluminada e naturalmente viçosa.\n\nIdeal para quem busca uma rotina de autocuidado simples e eficiente, o Creme Facial Diurno auxilia na manutenção da hidratação natural da pele, contribuindo para uma sensação prolongada de maciez e bem-estar.\n\nBenefícios percebidos:\n\n✨ hidratação leve e duradoura\n✨ toque macio e confortável\n✨ rápida absorção\n✨ sensação de pele nutrida e revitalizada\n✨ aparência mais saudável e luminosa\n✨ cuidado diário para todos os tipos de pele\n\nSua textura suave espalha facilmente e deixa a pele agradável ao toque, tornando-se uma excelente opção para fazer parte da sua rotina diária de cuidados faciais.\n\nPerfeito para:\n\n🌿 uso diário\n🌿 rotina matinal de cuidados\n🌿 peles que precisam de hidratação sem pesar\n🌿 quem busca conforto e maciez ao longo do dia\n🌿 complementar sua rotina de autocuidado\n\nCom o carinho e a qualidade que fazem parte da essência da Receita de Vovó, cada aplicação é um convite para começar o dia cuidando de quem mais importa: você.\n\n🌸 Receita de Vovó\n\nPorque uma pele bem cuidada começa com pequenos gestos de carinho todos os dias.', NULL, 37.70, 3.8973, 44.00, NULL, NULL, NULL, 32, NULL, 1, '[]', '2026-06-08 23:04:32', '2026-06-11 02:36:46', NULL),
(54, 'Creme Hidratante Corporal Scandal', 'Creme-Corporal-Scandal', '🌸 Mimos de Vó — Creme Corporal Scandal🌸\n\nSua fragrância favorita agora também em forma de cuidado.\n\nO Creme Corporal Scandal foi desenvolvido para complementar perfeitamente o seu Body Splash, criando uma experiência completa de hidratação, perfumação e autocuidado.\n\nCom uma fragrância doce, envolvente e marcante, perfeita para mulheres confiantes e cheias de personalidade.\n\nCom textura leve, toque aveludado e rápida absorção, ele hidrata a pele enquanto deixa uma fragrância delicada e envolvente que permanece por muito mais tempo.\n\nA linha Mimos de Vó nasceu para transformar pequenos momentos em experiências especiais, unindo carinho, autoestima e sofisticação em produtos que despertam sensações inesquecíveis.\n\nSua fórmula ajuda a manter a pele macia, nutrida e confortável, proporcionando uma sensação agradável de cuidado durante todo o dia.\n\n✨ Benefícios:\n\n• Hidratação diária da pele;\n• Toque macio e sedoso;\n• Rápida absorção;\n• Perfumação delicada e prolongada;\n• Ideal para potencializar a fragrância do Body Splash.\n\nUse sozinho ou combine com o Body Splash [NOME DA FRAGRÂNCIA] para criar um ritual completo de perfumação, deixando sua pele hidratada, perfumada e ainda mais especial.\n\nMais do que um creme corporal, ele é:\n\n• um gesto de autocuidado;\n• um momento de carinho para você;\n• uma experiência perfumada;\n• um mimo pensado para elevar sua autoestima todos os dias.\n\n🌸 Mimos de Vó\n\nPorque cuidar da pele também é uma forma de demonstrar amor por si mesma.', NULL, 40.40, NULL, 53.00, NULL, NULL, NULL, 3, NULL, 1, '[]', '2026-06-10 14:29:03', '2026-06-11 15:47:23', 6),
(55, 'Sabonete Artesanal Scandal', 'Sabonete-Artesanal-Scandal', '🌹 Rosas da Vovó — Sabonete Artesanal Scandal 🌹\n\nTransforme o seu banho em um momento de beleza, cuidado e perfumação.\n\nO Sabonete Artesanal Scandal da Receita de Vovó foi criado para quem ama fragrâncias marcantes e experiências que vão além da limpeza diária.\n\nProduzido artesanalmente com base vegetal enriquecida com manteiga de karité, leite de cabra e lauril de milho, ele proporciona uma espuma cremosa, limpeza suave e uma sensação de pele macia e perfumada após o banho.\n\nSua fragrância inspirada em Scandal revela uma combinação envolvente, feminina e sofisticada, perfeita para mulheres que gostam de deixar sua presença marcada por onde passam.\n\nO destaque fica por conta da delicada rosa artesanal esculpida sobre cada barra, transformando cada sabonete em uma pequena obra de arte feita à mão.\n\n✨ Benefícios:\n\n• Limpeza suave sem ressecar a pele;\n• Espuma cremosa e agradável;\n• Manteiga de Karité que ajuda a nutrir e proteger;\n• Leite de Cabra que proporciona maciez e conforto;\n• Fragrância sofisticada e envolvente;\n• Produção artesanal feita com carinho.\n\nIdeal para:\n\n🌹 Momentos de autocuidado\n🌹 Presentear alguém especial\n🌹 Cestas de presente\n🌹 Banhos relaxantes e perfumados\n🌹 Quem ama produtos artesanais exclusivos\n\nMais do que um sabonete, ele é um convite para desacelerar, cuidar de si e transformar a rotina em um momento especial.', NULL, 40.40, NULL, 58.40, NULL, NULL, NULL, 2, NULL, 1, '[\"http://localhost:8000/storage/uploads/6a294de91d0d1.webp\"]', '2026-06-10 14:43:43', '2026-06-10 14:49:22', 10);
INSERT INTO `products` (`id`, `name`, `slug`, `description`, `short_description`, `price`, `unit_cost`, `old_price`, `discount_percent`, `promo_start`, `promo_end`, `stock`, `featured_image`, `is_active`, `images`, `created_at`, `updated_at`, `category_id`) VALUES
(56, 'Sabonete Artesanal Delina', 'Sabonete-Artesanal-Delina', '🌸 Rosas da Vovó — Sabonete Artesanal Delina 🌸\n\nDelicado, elegante e encantador em cada detalhe.\n\nO Sabonete Artesanal Delina da Receita de Vovó foi criado para transformar o banho em um momento de beleza, suavidade e autocuidado.\n\nProduzido artesanalmente com base vegetal, manteiga de karité, leite de cabra e lauril de milho, ele proporciona uma limpeza suave, espuma cremosa e uma agradável sensação de hidratação e conforto para a pele.\n\nInspirado na sofisticação das fragrâncias florais mais desejadas do mundo, seu perfume revela uma combinação delicada, feminina e inesquecível, envolvendo a pele com um aroma elegante que permanece após o banho.\n\nCada barra recebe uma delicada rosa artesanal esculpida à mão, tornando cada sabonete uma peça única, feita com carinho e atenção aos detalhes.\n\n✨ Benefícios\n\n• Limpa suavemente sem ressecar a pele;\n• Espuma cremosa e agradável;\n• Manteiga de Karité que auxilia na nutrição da pele;\n• Leite de Cabra que proporciona maciez e toque aveludado;\n• Fragrância floral sofisticada e delicada;\n• Produção artesanal exclusiva.\n\nIdeal para\n\n🌸 Momentos de autocuidado\n\n🌸 Presentear alguém especial\n\n🌸 Cestas de presentes e kits perfumados\n\n🌸 Mulheres românticas e elegantes\n\n🌸 Quem aprecia fragrâncias florais refinadas\n\nMais do que um sabonete, ele é um convite para desacelerar, cuidar de si e transformar o banho em um ritual de beleza e bem-estar.\n\nSua espuma cremosa, sua delicada rosa artesanal e sua fragrância encantadora fazem do Delina uma verdadeira experiência sensorial.', NULL, 40.40, NULL, 58.40, NULL, NULL, NULL, 2, 'http://localhost:8000/storage/uploads/6a294ec3a62a8.webp', 1, '[]', '2026-06-10 14:47:18', '2026-06-10 14:49:04', 10),
(57, 'Sabonete Artesanal Lavanda', 'Sabonete-Artesanal-Lavanda', '💜 Jardim de Lavanda — Sabonete Artesanal de Lavanda & Alfazema 💜\n\nUm momento de calma para o corpo, a mente e a alma.\n\nO Jardim de Lavanda da Receita de Vovó foi criado para transformar o banho em um ritual de tranquilidade, conforto e bem-estar.\n\nProduzido artesanalmente com base vegetal, manteiga de karité, leite de cabra e lauril de milho, proporciona uma limpeza suave, espuma cremosa e uma agradável sensação de maciez e hidratação na pele.\n\nSua fragrância combina a delicadeza da Lavanda com o toque tradicional da Alfazema, criando um aroma leve, fresco e relaxante que desperta sensações de paz, aconchego e equilíbrio.\n\nCada barra é produzida artesanalmente, respeitando o tempo da natureza e o cuidado que faz parte da essência da Receita de Vovó.\n\n✨ Benefícios\n\n• Limpa suavemente sem ressecar a pele;\n\n• Espuma cremosa e agradável;\n\n• Auxilia na sensação de relaxamento e bem-estar;\n\n• Manteiga de Karité que ajuda a nutrir a pele;\n\n• Leite de Cabra que proporciona maciez e suavidade;\n\n• Fragrância floral aromática delicada e acolhedora;\n\n• Produção artesanal feita com carinho.\n\nIdeal para\n\n💜 Banhos relaxantes ao final do dia\n\n💜 Momentos de autocuidado\n\n💜 Presentes especiais\n\n💜 Quem aprecia aromas suaves e naturais\n\n💜 Criar uma rotina de bem-estar e tranquilidade\n\nMais do que um sabonete, ele é um convite para desacelerar e cuidar de si com calma e carinho.\n\nSua espuma cremosa e seu perfume delicado transformam cada banho em uma experiência acolhedora, inspirada nos jardins floridos e nas receitas que atravessam gerações.', NULL, 15.20, NULL, 25.10, NULL, NULL, NULL, 4, 'http://localhost:8000/storage/uploads/6a295028b289b.webp', 1, '[]', '2026-06-10 14:53:15', '2026-06-10 14:58:11', 10),
(58, 'Sabonete Artesanal Alecrim', 'Sabonete-Artesanal-Alecrim', '💜 Jardim de Lavanda — Sabonete Artesanal de Lavanda & Alfazema 💜\n\nUm momento de calma para o corpo, a mente e a alma.\n\nO Jardim de Lavanda da Receita de Vovó foi criado para transformar o banho em um ritual de tranquilidade, conforto e bem-estar.\n\nProduzido artesanalmente com base vegetal, manteiga de karité, leite de cabra e lauril de milho, proporciona uma limpeza suave, espuma cremosa e uma agradável sensação de maciez e hidratação na pele.\n\nSua fragrância combina a delicadeza da Lavanda com o toque tradicional da Alfazema, criando um aroma leve, fresco e relaxante que desperta sensações de paz, aconchego e equilíbrio.\n\nCada barra é produzida artesanalmente, respeitando o tempo da natureza e o cuidado que faz parte da essência da Receita de Vovó.\n\n✨ Benefícios\n\n• Limpa suavemente sem ressecar a pele;\n\n• Espuma cremosa e agradável;\n\n• Auxilia na sensação de relaxamento e bem-estar;\n\n• Manteiga de Karité que ajuda a nutrir a pele;\n\n• Leite de Cabra que proporciona maciez e suavidade;\n\n• Fragrância floral aromática delicada e acolhedora;\n\n• Produção artesanal feita com carinho.\n\nIdeal para\n\n💜 Banhos relaxantes ao final do dia\n\n💜 Momentos de autocuidado\n\n💜 Presentes especiais\n\n💜 Quem aprecia aromas suaves e naturais\n\n💜 Criar uma rotina de bem-estar e tranquilidade\n\nMais do que um sabonete, ele é um convite para desacelerar e cuidar de si com calma e carinho.\n\nSua espuma cremosa e seu perfume delicado transformam cada banho em uma experiência acolhedora, inspirada nos jardins floridos e nas receitas que atravessam gerações.', NULL, 10.70, NULL, 22.40, NULL, NULL, NULL, 2, NULL, 1, '[]', '2026-06-10 16:16:36', '2026-06-10 16:16:36', 10),
(59, 'Creme Hidratante Corporal Delina', 'creme-hidratante-corporal-delina', '🌸 Mimos de Vó — Creme Corporal Delina 🌸\n\nDelicado como uma flor, sofisticado como um perfume inesquecível.\n\nO Creme Corporal Delina foi criado para mulheres que apreciam a beleza dos pequenos detalhes e transformam o autocuidado em um momento especial.\n\nInspirado na elegância das fragrâncias florais mais sofisticadas do mundo, ele combina hidratação, maciez e perfumação em uma experiência envolvente e extremamente feminina.\n\nSua fórmula foi desenvolvida para proporcionar toque sedoso, rápida absorção e uma agradável sensação de conforto, deixando a pele hidratada, macia e delicadamente perfumada ao longo do dia.\n\nA linha Mimos de Vó nasceu para transformar gestos simples em momentos de carinho, autoestima e bem-estar, levando para a rotina um toque de elegância e afeto.\n\nO Creme Corporal Delina revela uma fragrância floral refinada, romântica e sofisticada, perfeita para mulheres que amam perfumes delicados, mas memoráveis.\n\n✨ Benefícios\n\n• Hidratação diária da pele;\n\n• Toque macio e aveludado;\n\n• Rápida absorção;\n\n• Sensação de conforto e bem-estar;\n\n• Perfumação delicada e prolongada;\n\n• Ideal para complementar o Body Splash Delina.\n\nSeu aroma transmite:\n\n🌸 Feminilidade sofisticada\n\n🌸 Delicadeza marcante\n\n🌸 Elegância moderna\n\n🌸 Romance e suavidade\n\n🌸 Um toque irresistível de luxo floral\n\nPara uma experiência ainda mais completa, utilize juntamente com o Body Splash Delina, potencializando a fixação da fragrância e prolongando a sensação de frescor e perfumação na pele.\n\nMais do que um creme hidratante, ele é:\n\n• um gesto de autocuidado;\n\n• um momento de carinho para você;\n\n• uma experiência sensorial envolvente;\n\n• um mimo pensado para realçar sua beleza natural.\n\n🌸 Mimos de Vó\n\nPorque toda mulher merece florescer todos os dias.', NULL, 40.40, NULL, 53.00, NULL, NULL, NULL, 2, NULL, 1, '[]', '2026-06-10 16:21:35', '2026-06-10 16:21:35', 6),
(60, 'Creme Hidratante Corporal Good Girl', 'Creme-Corporal-Good-Girl', '🌙 Mimos de Vó — Creme Corporal Good Girl 🌙\n\nElegante, marcante e irresistivelmente feminina.\n\nO Creme Corporal Good Girl foi criado para mulheres que carregam força e delicadeza na mesma medida, revelando sua personalidade com confiança, charme e autenticidade.\n\nInspirado em fragrâncias sofisticadas e envolventes, ele transforma o momento de hidratação em um verdadeiro ritual de beleza e autoestima.\n\nSua fórmula proporciona hidratação diária, toque macio e rápida absorção, deixando a pele sedosa e delicadamente perfumada durante todo o dia.\n\nA linha Mimos de Vó nasceu para transformar pequenos momentos em experiências especiais, unindo cuidado, carinho e sofisticação em produtos desenvolvidos para mulheres que amam sentir-se bonitas e confiantes.\n\nO Creme Corporal Good Girl apresenta uma fragrância elegante e envolvente, que combina delicadeza e intensidade em perfeita harmonia.\n\n✨ Benefícios\n\n• Hidratação diária da pele;\n\n• Toque macio e aveludado;\n\n• Rápida absorção;\n\n• Sensação de conforto e bem-estar;\n\n• Perfumação sofisticada e prolongada;\n\n• Ideal para complementar o Body Splash Good Girl.\n\nSua fragrância transmite:\n\n✨ Feminilidade marcante\n\n✨ Elegância contemporânea\n\n✨ Sensualidade equilibrada\n\n✨ Confiança e autoestima\n\n✨ Sofisticação em cada detalhe\n\nPara uma experiência ainda mais completa, utilize juntamente com o Body Splash Good Girl, criando camadas de perfumação que prolongam a fragrância e deixam sua presença ainda mais memorável.\n\nMais do que um creme hidratante, ele é:\n\n• um momento de autocuidado;\n\n• um gesto de carinho para você;\n\n• uma experiência perfumada;\n\n• um mimo pensado para realçar sua melhor versão.\n\n🌸 Mimos de Vó\n\nPorque toda mulher carrega dentro de si delicadeza e força na medida certa.', NULL, 40.40, NULL, 53.00, NULL, NULL, NULL, 2, NULL, 1, '[]', '2026-06-10 16:24:07', '2026-06-10 16:24:07', 6),
(61, 'Creme Hidratante Corporal Royal Amber', 'Creme-Corporal-Royal-Amber', '✨ Mimos de Vó — Creme Corporal Royal Amber ✨\n\nO toque do luxo que abraça a pele.\n\nO Creme Corporal Royal Amber foi criado para mulheres que apreciam fragrâncias sofisticadas, envolventes e cheias de personalidade.\n\nInspirado na riqueza das notas ambaradas, ele transforma a hidratação diária em um ritual de conforto, elegância e bem-estar.\n\nSua textura leve e agradável proporciona hidratação diária, rápida absorção e toque aveludado, deixando a pele macia, perfumada e envolvida por uma fragrância quente e sofisticada.\n\nA linha Mimos de Vó nasceu para transformar momentos simples em experiências especiais, levando carinho, autoestima e sofisticação para a rotina de quem valoriza o autocuidado.\n\nO Royal Amber revela uma fragrância intensa e acolhedora, perfeita para mulheres que desejam transmitir elegância, confiança e presença de forma natural.\n\n✨ Benefícios\n\n• Hidratação diária da pele;\n\n• Toque macio e sedoso;\n\n• Rápida absorção;\n\n• Sensação prolongada de conforto;\n\n• Perfumação sofisticada e envolvente;\n\n• Ideal para complementar o Body Splash Royal Amber.\n\nSua fragrância transmite:\n\n✨ Sofisticação marcante\n\n✨ Elegância atemporal\n\n✨ Conforto acolhedor\n\n✨ Feminilidade intensa\n\n✨ Um toque irresistível de luxo\n\nPerfeito para quem gosta de perfumes envolventes que permanecem na memória e transformam pequenos momentos em experiências especiais.\n\nPara uma perfumação ainda mais duradoura, utilize juntamente com o Body Splash Royal Amber, criando um ritual completo de hidratação e fragrância.\n\nMais do que um creme hidratante, ele é:\n\n• um momento de autocuidado;\n\n• uma experiência sensorial acolhedora;\n\n• um gesto de carinho para você;\n\n• um mimo pensado para mulheres que gostam de se sentir elegantes todos os dias.\n\n✨ Mimos de Vó\n\nPorque algumas fragrâncias não apenas perfumam, elas deixam lembranças.', NULL, 40.40, NULL, 53.00, NULL, NULL, NULL, 2, NULL, 1, '[]', '2026-06-10 16:27:08', '2026-06-10 16:27:08', 6);

-- --------------------------------------------------------

--
-- Table structure for table `product_reviews`
--

CREATE TABLE `product_reviews` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `product_id` bigint UNSIGNED NOT NULL,
  `rating` tinyint UNSIGNED NOT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci,
  `is_approved` tinyint(1) NOT NULL DEFAULT '1',
  `is_verified_purchase` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_variants`
--

CREATE TABLE `product_variants` (
  `id` bigint UNSIGNED NOT NULL,
  `product_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `old_price` decimal(10,2) DEFAULT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `unit_cost` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `sku` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `volume` decimal(12,3) NOT NULL DEFAULT '1.000',
  `volume_unit` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ml',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_variants`
--

INSERT INTO `product_variants` (`id`, `product_id`, `name`, `price`, `old_price`, `stock`, `unit_cost`, `sku`, `volume`, `volume_unit`, `created_at`, `updated_at`) VALUES
(3, 45, 'Body Splash - Scandal - 200ml', 60.20, NULL, 7, 14.6067, NULL, 200.000, 'ml', '2026-06-03 17:21:31', '2026-06-04 18:22:55'),
(4, 45, 'Body Splash - Scandal - 100ml', 40.40, NULL, 1, 0.0730, NULL, 1.000, 'ml', '2026-06-03 17:21:31', '2026-06-11 21:22:49'),
(5, 46, '200', 60.20, NULL, 6, 0.0000, NULL, 1.000, 'ml', '2026-06-03 20:51:02', '2026-06-11 21:27:58'),
(6, 46, '100', 40.40, NULL, 2, 0.0000, NULL, 1.000, 'ml', '2026-06-03 20:51:02', '2026-06-03 20:51:02'),
(7, 47, '200', 60.20, NULL, 2, 0.0000, NULL, 1.000, 'ml', '2026-06-03 20:52:07', '2026-06-10 14:58:42'),
(8, 47, '100', 40.40, NULL, 1, 0.0000, NULL, 1.000, 'ml', '2026-06-03 20:52:07', '2026-06-03 20:52:07'),
(9, 49, 'Body Splash Bourbon Intense - 200', 60.20, NULL, 4, 0.0000, NULL, 1.000, 'ml', '2026-06-03 20:52:51', '2026-06-04 18:23:40'),
(10, 49, 'Body Splash Bourbon Intense - 100', 40.40, NULL, 1, 0.0000, NULL, 1.000, 'ml', '2026-06-03 20:52:51', '2026-06-04 18:23:40'),
(11, 54, '100ml', 40.40, NULL, 1, 0.0000, 'Creme-Corporal-Scandal', 100.000, 'ml', '2026-06-10 14:29:03', '2026-06-11 21:22:49'),
(12, 54, '200ml', 53.00, NULL, 0, 0.0000, 'Creme-Corporal-Scandal', 200.000, 'ml', '2026-06-10 14:29:03', '2026-06-10 14:29:03'),
(13, 55, 'Sabonete Artesanal Scandal - 200gr', 40.40, NULL, 1, 0.0000, 'Sabonete-Artesanal-Scandal-200', 200.000, 'g', '2026-06-10 14:43:43', '2026-06-10 14:58:42'),
(14, 56, 'Sabonete Artesanal Delina - 200gr', 40.40, NULL, 0, 0.0000, 'Sabonete Artesanal Delina-200', 200.000, 'g', '2026-06-10 14:47:18', '2026-06-11 21:27:58'),
(15, 57, 'Sabonete Artesanal Lavanda - 100gr', 15.20, NULL, 2, 0.0000, 'Sabonete-Artesanal-Lavanda-100', 100.000, 'g', '2026-06-10 14:53:15', '2026-06-10 14:58:11'),
(16, 57, 'Sabonete Artesanal Lavanda - 80gr', 10.60, NULL, 1, 0.0000, 'Sabonete-Artesanal-Lavanda-80', 80.000, 'g', '2026-06-10 14:53:15', '2026-06-10 14:58:42'),
(17, 59, '100ml', 40.40, NULL, 1, 0.0000, 'creme-hidratante-corporal-delina-100', 100.000, 'ml', '2026-06-10 16:21:35', '2026-06-11 21:27:58'),
(18, 59, '200ml', 53.00, NULL, 0, 0.0000, 'creme-hidratante-corporal-delina-200', 200.000, 'ml', '2026-06-10 16:21:35', '2026-06-10 16:21:35'),
(19, 60, '100ml', 40.40, NULL, 2, 0.0000, 'Creme-Corporal-Good-Girl-100', 100.000, 'ml', '2026-06-10 16:24:07', '2026-06-10 16:24:07'),
(20, 60, '200ml', 53.00, NULL, 0, 0.0000, 'Creme-Corporal-Good-Girl-200', 200.000, 'ml', '2026-06-10 16:24:07', '2026-06-10 16:24:07'),
(21, 61, '100ml', 40.40, NULL, 1, 0.0000, 'Creme-Corporal-Royal-Amber-100', 100.000, 'ml', '2026-06-10 16:27:08', '2026-06-11 02:36:46'),
(22, 61, '200ml', 53.00, NULL, 0, 0.0000, 'Creme-Corporal-Royal-Amber-200', 200.000, 'ml', '2026-06-10 16:27:08', '2026-06-10 16:27:08');

-- --------------------------------------------------------

--
-- Table structure for table `purchase_orders`
--

CREATE TABLE `purchase_orders` (
  `id` bigint UNSIGNED NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `supplier_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `status` enum('draft','sent','partial','received','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `total_planned` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_actual` decimal(12,2) DEFAULT NULL,
  `expected_at` date DEFAULT NULL,
  `sent_at` timestamp NULL DEFAULT NULL,
  `received_at` timestamp NULL DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `purchase_order_items`
--

CREATE TABLE `purchase_order_items` (
  `id` bigint UNSIGNED NOT NULL,
  `purchase_order_id` bigint UNSIGNED NOT NULL,
  `raw_material_id` bigint UNSIGNED NOT NULL,
  `quantity_ordered` decimal(12,4) NOT NULL,
  `quantity_received` decimal(12,4) DEFAULT NULL,
  `unit_price` decimal(10,4) NOT NULL,
  `actual_unit_price` decimal(10,4) DEFAULT NULL,
  `total_planned` decimal(12,4) NOT NULL,
  `total_actual` decimal(12,4) DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `quality_checks`
--

CREATE TABLE `quality_checks` (
  `id` bigint UNSIGNED NOT NULL,
  `checkable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `checkable_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `check_type` enum('receipt','production') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'receipt = inspeção de lote recebido; production = inspeção de produção',
  `status` enum('pending','approved','rejected','quarantine') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `checked_at` timestamp NULL DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `rejection_reason` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `quality_checks`
--

INSERT INTO `quality_checks` (`id`, `checkable_type`, `checkable_id`, `user_id`, `check_type`, `status`, `checked_at`, `notes`, `rejection_reason`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 1, 1, 'production', 'pending', NULL, 'Gerado automaticamente ao concluir OP OP-2026-0001', NULL, '2026-05-26 17:43:21', '2026-05-26 17:43:21', NULL),
(2, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 2, 1, 'production', 'pending', NULL, 'Gerado automaticamente ao concluir OP OP-2026-0002', NULL, '2026-05-26 18:05:17', '2026-05-26 18:05:17', NULL),
(3, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 3, 1, 'production', 'pending', NULL, 'Gerado automaticamente ao concluir OP OP-2026-0003', NULL, '2026-05-26 19:46:50', '2026-05-26 19:46:50', NULL),
(4, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 4, 1, 'production', 'pending', NULL, 'Gerado automaticamente ao concluir OP OP-2026-0004', NULL, '2026-05-26 19:47:12', '2026-05-26 19:47:12', NULL),
(5, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 8, 30, 'production', 'pending', NULL, 'Gerado automaticamente ao concluir OP OP-2026-0008', NULL, '2026-06-03 20:40:17', '2026-06-03 20:40:17', NULL),
(6, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 7, 30, 'production', 'pending', NULL, 'Gerado automaticamente ao concluir OP OP-2026-0007', NULL, '2026-06-03 20:40:54', '2026-06-03 20:40:54', NULL),
(7, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 6, 30, 'production', 'pending', NULL, 'Gerado automaticamente ao concluir OP OP-2026-0006', NULL, '2026-06-03 20:41:45', '2026-06-03 20:41:45', NULL),
(8, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 5, 30, 'production', 'approved', '2026-06-04 04:30:04', 'Produto final acabado está de acordo com os padrões de qualidade.', NULL, '2026-06-03 20:42:06', '2026-06-04 04:30:04', NULL),
(9, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 9, 30, 'production', 'pending', NULL, 'Gerado automaticamente ao concluir OP OP-2026-0009', NULL, '2026-06-09 15:42:15', '2026-06-09 15:42:15', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `quality_check_criteria`
--

CREATE TABLE `quality_check_criteria` (
  `id` bigint UNSIGNED NOT NULL,
  `quality_check_id` bigint UNSIGNED NOT NULL,
  `criterion` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `criterion_label` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `result` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `measured_value` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `quality_check_criteria`
--

INSERT INTO `quality_check_criteria` (`id`, `quality_check_id`, `criterion`, `criterion_label`, `result`, `measured_value`, `notes`, `created_at`, `updated_at`) VALUES
(1, 1, 'appearance', 'Aparência', NULL, NULL, NULL, '2026-05-26 17:43:21', '2026-05-26 17:43:21'),
(2, 1, 'smell', 'Odor', NULL, NULL, NULL, '2026-05-26 17:43:21', '2026-05-26 17:43:21'),
(3, 1, 'taste', 'Sabor', NULL, NULL, NULL, '2026-05-26 17:43:21', '2026-05-26 17:43:21'),
(4, 1, 'texture', 'Textura/Consistência', NULL, NULL, NULL, '2026-05-26 17:43:21', '2026-05-26 17:43:21'),
(5, 1, 'weight', 'Peso Líquido', NULL, NULL, NULL, '2026-05-26 17:43:21', '2026-05-26 17:43:21'),
(6, 1, 'packaging', 'Embalagem Final', NULL, NULL, NULL, '2026-05-26 17:43:21', '2026-05-26 17:43:21'),
(7, 2, 'appearance', 'Aparência', NULL, NULL, NULL, '2026-05-26 18:05:17', '2026-05-26 18:05:17'),
(8, 2, 'smell', 'Odor', NULL, NULL, NULL, '2026-05-26 18:05:17', '2026-05-26 18:05:17'),
(9, 2, 'taste', 'Sabor', NULL, NULL, NULL, '2026-05-26 18:05:17', '2026-05-26 18:05:17'),
(10, 2, 'texture', 'Textura/Consistência', NULL, NULL, NULL, '2026-05-26 18:05:17', '2026-05-26 18:05:17'),
(11, 2, 'weight', 'Peso Líquido', NULL, NULL, NULL, '2026-05-26 18:05:17', '2026-05-26 18:05:17'),
(12, 2, 'packaging', 'Embalagem Final', NULL, NULL, NULL, '2026-05-26 18:05:17', '2026-05-26 18:05:17'),
(13, 3, 'appearance', 'Aparência', NULL, NULL, NULL, '2026-05-26 19:46:50', '2026-05-26 19:46:50'),
(14, 3, 'smell', 'Odor', NULL, NULL, NULL, '2026-05-26 19:46:50', '2026-05-26 19:46:50'),
(15, 3, 'taste', 'Sabor', NULL, NULL, NULL, '2026-05-26 19:46:50', '2026-05-26 19:46:50'),
(16, 3, 'texture', 'Textura/Consistência', NULL, NULL, NULL, '2026-05-26 19:46:50', '2026-05-26 19:46:50'),
(17, 3, 'weight', 'Peso Líquido', NULL, NULL, NULL, '2026-05-26 19:46:50', '2026-05-26 19:46:50'),
(18, 3, 'packaging', 'Embalagem Final', NULL, NULL, NULL, '2026-05-26 19:46:50', '2026-05-26 19:46:50'),
(19, 4, 'appearance', 'Aparência', NULL, NULL, NULL, '2026-05-26 19:47:12', '2026-05-26 19:47:12'),
(20, 4, 'smell', 'Odor', NULL, NULL, NULL, '2026-05-26 19:47:12', '2026-05-26 19:47:12'),
(21, 4, 'taste', 'Sabor', NULL, NULL, NULL, '2026-05-26 19:47:12', '2026-05-26 19:47:12'),
(22, 4, 'texture', 'Textura/Consistência', NULL, NULL, NULL, '2026-05-26 19:47:12', '2026-05-26 19:47:12'),
(23, 4, 'weight', 'Peso Líquido', NULL, NULL, NULL, '2026-05-26 19:47:12', '2026-05-26 19:47:12'),
(24, 4, 'packaging', 'Embalagem Final', NULL, NULL, NULL, '2026-05-26 19:47:12', '2026-05-26 19:47:12'),
(25, 5, 'appearance', 'Aparência', NULL, NULL, NULL, '2026-06-03 20:40:17', '2026-06-03 20:40:17'),
(26, 5, 'smell', 'Odor', NULL, NULL, NULL, '2026-06-03 20:40:17', '2026-06-03 20:40:17'),
(27, 5, 'taste', 'Sabor', NULL, NULL, NULL, '2026-06-03 20:40:17', '2026-06-03 20:40:17'),
(28, 5, 'texture', 'Textura/Consistência', NULL, NULL, NULL, '2026-06-03 20:40:17', '2026-06-03 20:40:17'),
(29, 5, 'weight', 'Peso Líquido', NULL, NULL, NULL, '2026-06-03 20:40:17', '2026-06-03 20:40:17'),
(30, 5, 'packaging', 'Embalagem Final', NULL, NULL, NULL, '2026-06-03 20:40:17', '2026-06-03 20:40:17'),
(31, 6, 'appearance', 'Aparência', NULL, NULL, NULL, '2026-06-03 20:40:54', '2026-06-03 20:40:54'),
(32, 6, 'smell', 'Odor', NULL, NULL, NULL, '2026-06-03 20:40:54', '2026-06-03 20:40:54'),
(33, 6, 'taste', 'Sabor', NULL, NULL, NULL, '2026-06-03 20:40:54', '2026-06-03 20:40:54'),
(34, 6, 'texture', 'Textura/Consistência', NULL, NULL, NULL, '2026-06-03 20:40:54', '2026-06-03 20:40:54'),
(35, 6, 'weight', 'Peso Líquido', NULL, NULL, NULL, '2026-06-03 20:40:54', '2026-06-03 20:40:54'),
(36, 6, 'packaging', 'Embalagem Final', NULL, NULL, NULL, '2026-06-03 20:40:54', '2026-06-03 20:40:54'),
(37, 7, 'appearance', 'Aparência', NULL, NULL, NULL, '2026-06-03 20:41:45', '2026-06-03 20:41:45'),
(38, 7, 'smell', 'Odor', NULL, NULL, NULL, '2026-06-03 20:41:45', '2026-06-03 20:41:45'),
(39, 7, 'taste', 'Sabor', NULL, NULL, NULL, '2026-06-03 20:41:45', '2026-06-03 20:41:45'),
(40, 7, 'texture', 'Textura/Consistência', NULL, NULL, NULL, '2026-06-03 20:41:45', '2026-06-03 20:41:45'),
(41, 7, 'weight', 'Peso Líquido', NULL, NULL, NULL, '2026-06-03 20:41:45', '2026-06-03 20:41:45'),
(42, 7, 'packaging', 'Embalagem Final', NULL, NULL, NULL, '2026-06-03 20:41:45', '2026-06-03 20:41:45'),
(43, 8, 'appearance', 'Aparência', 'pass', NULL, NULL, '2026-06-03 20:42:06', '2026-06-04 04:30:04'),
(44, 8, 'smell', 'Odor', 'pass', NULL, NULL, '2026-06-03 20:42:06', '2026-06-04 04:30:04'),
(45, 8, 'taste', 'Sabor', 'pass', NULL, NULL, '2026-06-03 20:42:06', '2026-06-04 04:30:04'),
(46, 8, 'texture', 'Textura/Consistência', 'pass', NULL, NULL, '2026-06-03 20:42:06', '2026-06-04 04:30:04'),
(47, 8, 'weight', 'Peso Líquido', 'pass', NULL, NULL, '2026-06-03 20:42:06', '2026-06-04 04:30:04'),
(48, 8, 'packaging', 'Embalagem Final', 'pass', NULL, NULL, '2026-06-03 20:42:06', '2026-06-04 04:30:04'),
(49, 9, 'appearance', 'Aparência', NULL, NULL, NULL, '2026-06-09 15:42:15', '2026-06-09 15:42:15'),
(50, 9, 'smell', 'Odor', NULL, NULL, NULL, '2026-06-09 15:42:15', '2026-06-09 15:42:15'),
(51, 9, 'taste', 'Sabor', NULL, NULL, NULL, '2026-06-09 15:42:15', '2026-06-09 15:42:15'),
(52, 9, 'texture', 'Textura/Consistência', NULL, NULL, NULL, '2026-06-09 15:42:15', '2026-06-09 15:42:15'),
(53, 9, 'weight', 'Peso Líquido', NULL, NULL, NULL, '2026-06-09 15:42:15', '2026-06-09 15:42:15'),
(54, 9, 'packaging', 'Embalagem Final', NULL, NULL, NULL, '2026-06-09 15:42:15', '2026-06-09 15:42:15');

-- --------------------------------------------------------

--
-- Table structure for table `raw_materials`
--

CREATE TABLE `raw_materials` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unit` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `stock_quantity` decimal(12,3) NOT NULL DEFAULT '0.000',
  `min_stock_quantity` decimal(12,3) NOT NULL DEFAULT '0.000',
  `average_cost` decimal(10,4) NOT NULL DEFAULT '0.0000',
  `shelf_life_days` int DEFAULT NULL,
  `supplier_id` bigint UNSIGNED DEFAULT NULL,
  `image_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `raw_materials`
--

INSERT INTO `raw_materials` (`id`, `name`, `slug`, `description`, `unit`, `category`, `stock_quantity`, `min_stock_quantity`, `average_cost`, `shelf_life_days`, `supplier_id`, `image_path`, `is_active`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'BISNAGA BRANCA PE 60G – DZ', 'bisnaga-branca-pe-60g-dz', NULL, 'un', 'Embalagem', 0.000, 1.000, 1.2000, NULL, 1, 'http://localhost:8000/storage/uploads/6a0e40824f24b.webp', 1, '2026-05-21 02:15:17', '2026-05-21 14:18:42', NULL),
(2, 'ÓLEO-ESSENCIAL DE LARANJA DOCE - BALLON', 'oleo-essencial-de-laranja-doce-ballon', NULL, 'ml', 'Óleo Essencial', 10.000, 0.000, 1.5997, NULL, 2, NULL, 1, '2026-05-21 13:36:30', '2026-06-10 02:00:37', NULL),
(3, 'ÓLEO-ESSENCIAL DE LAVANDA - BALLON', 'oleo-essencial-de-lavanda-ballon', NULL, 'ml', 'Óleo Essencial', 10.000, 0.000, 2.5000, NULL, 2, NULL, 1, '2026-05-21 13:36:30', '2026-06-10 02:00:52', NULL),
(4, 'ESSÊNCIA DE LAVANDA INGLESA - OAK', 'ess-lavanda-inglesa-oak', NULL, 'ml', 'Essência', 200.000, 0.000, 0.2600, NULL, 2, NULL, 1, '2026-05-21 13:36:30', '2026-06-10 02:18:00', NULL),
(5, 'ESSÊNCIA DE LAVANDA FRANCESA - OAK', 'ess-lavanda-francesa-oak', NULL, 'ml', 'Essência', 200.000, 0.000, 0.2400, NULL, 2, NULL, 1, '2026-05-21 13:36:30', '2026-06-10 02:17:30', NULL),
(6, 'ESSÊNCIA DE LAVANDA & ALGODAO MAHOGANY- ISAN', 'ess-lavanda-algodao-mahogany-isan', NULL, 'ml', 'Essência', 400.000, 0.000, 0.2800, NULL, 2, NULL, 1, '2026-05-21 13:36:30', '2026-06-10 02:17:10', NULL),
(7, 'ESSÊNCIA DE LAVANDA PROVENCE - LESS', 'ess-lavanda-provence-less', NULL, 'ml', 'Essência', 200.000, 0.000, 0.2498, NULL, 2, NULL, 1, '2026-05-21 13:36:30', '2026-06-10 02:17:45', NULL),
(8, 'ESSÊNCIA  DE ALMISCAR - DOMO', 'ess-almiscar-domo', NULL, 'ml', 'Essência', 100.000, 0.000, 0.2796, NULL, 2, NULL, 1, '2026-05-21 13:36:30', '2026-06-10 02:14:51', NULL),
(9, 'ESSÊNCIA DE ROSAS BRANCAS- LESSENCE', 'ess-rosas-brancas-lessence', NULL, 'ml', 'Essência', 100.000, 0.000, 0.2200, NULL, 2, NULL, 1, '2026-05-21 13:36:30', '2026-06-10 02:19:05', NULL),
(10, 'FRASCO PET 220ML MALTA R. 24/415 LARANJA - INTIMO', 'frasco-pet-220ml-malta-r-24415-laranja', NULL, 'un', 'Embalagem', 10.000, 0.000, 0.8100, NULL, 3, NULL, 1, '2026-05-21 14:24:23', '2026-05-26 15:05:13', NULL),
(11, 'FRASCO PET 220ml MALTA R.24/415 AZUL - INTIMO', 'frasco-pet-220ml-malta-r24415-azul', NULL, 'un', 'Embalagem', 10.000, 0.000, 0.8100, NULL, 3, NULL, 1, '2026-05-21 14:26:03', '2026-05-26 15:05:51', NULL),
(12, 'FRASCO PET 220ml MALTA R.24/415 CRISTAL - INTIMO', 'frasco-pet-220ml-malta-r24415-cristal', NULL, 'un', NULL, 12.000, 0.000, 0.8300, NULL, 3, NULL, 1, '2026-05-21 14:26:44', '2026-05-26 15:06:25', NULL),
(13, 'FRASCO PET 300ml CILERETO SATURNO 24/410 - SHAMPOO', 'frasco-pet-300ml-cilreto-saturno-24410', NULL, 'un', 'Embalagem', 37.000, 0.000, 1.2000, NULL, 3, NULL, 1, '2026-05-21 14:27:49', '2026-05-26 15:07:05', NULL),
(14, 'TAMPA DISK TOP 24/410 LUXO PRATA FOSCO - SHAMPOO', 'tampa-disk-top-24410-luxo-prata-fosco', NULL, 'un', 'Embalagem', 37.000, 0.000, 1.1300, NULL, 3, NULL, 1, '2026-05-21 14:29:39', '2026-05-26 15:09:11', NULL),
(15, 'TAMPA DISK TOP 24/415 NATURAL R.27822 - INTIMO', 'tampa-disk-top-24415-natural-r27822', NULL, 'un', 'Embalagem', 12.000, 0.000, 0.8300, NULL, 3, NULL, 1, '2026-05-21 14:31:17', '2026-05-26 15:11:33', NULL),
(16, 'TAMPA DISK TOP 24/415 BRANCA 27827 - INTIMO', 'tampa-disk-top-24415-branca-27827', NULL, 'un', 'Embalagem', 10.000, 0.000, 0.6400, NULL, 3, NULL, 1, '2026-05-21 14:36:40', '2026-05-26 15:10:26', NULL),
(17, 'TAMPA DISK  TOP 24/415 LARANJA - INTIMO', 'tampa-disk-top-24415-laranja', NULL, 'un', 'Embalagem', 10.000, 0.000, 0.6400, NULL, 3, NULL, 1, '2026-05-21 14:39:20', '2026-05-26 15:10:59', NULL),
(18, 'BASE CREME HIDRATANTE CONCENTRADO 1x4 1kg YANTRA', 'creme-hidratante-concent-1x4-1kg-yantgi', NULL, 'kg', 'Base', 8.000, 0.000, 25.8350, NULL, 3, NULL, 1, '2026-05-21 14:42:12', '2026-06-03 22:33:15', NULL),
(19, 'LAURIL 2000 DECILGLUCOSIDEO 50 - MILHO', 'laauril-2000-decilglucosideo-50', NULL, 'ml', 'Tensoativo', 2000.000, 0.000, 0.0700, NULL, 1, NULL, 1, '2026-05-21 14:58:09', '2026-06-10 03:21:56', NULL),
(20, 'LAURIL', 'lauril-vegetal-vg', NULL, 'ml', 'Tensoativo', 1.000, 0.000, 32.5000, NULL, 1, NULL, 1, '2026-05-21 14:58:54', '2026-06-10 03:20:01', NULL),
(21, 'ESSÊNCIA G. ARMANI MY WAY FEM LINHA 1', 'ess-g-armani-my-way-fem-linha-1', NULL, 'ml', 'Essência', 30.000, 0.000, 1.3400, NULL, 1, NULL, 1, '2026-05-21 15:02:53', '2026-05-23 04:57:15', NULL),
(22, 'ESSÊNCIA INTERDIT FEM LINHA 1', 'ess-interditada-fem-linha-1', NULL, 'ml', 'Essência', 30.000, 0.000, 1.3400, NULL, 1, NULL, 1, '2026-05-21 15:03:28', '2026-05-23 04:57:57', NULL),
(23, 'ESSÊNCIA LA VITA LINHA 1', 'ess-la-vita-linha-1', NULL, 'ml', 'Essência', 30.000, 0.000, 1.3400, NULL, 1, NULL, 1, '2026-05-21 15:05:08', '2026-05-23 04:58:25', NULL),
(24, 'ESSÊNCIA LANCOM LA NUITE LINHA 1', 'essencia-lancom-la-nuite-linha-1', NULL, 'ml', 'Essência', 90.000, 0.000, 1.0933, NULL, 1, NULL, 1, '2026-05-21 15:05:34', '2026-06-08 21:03:43', NULL),
(25, 'ESSÊNCIA ARMAFI – CLUB DE NOITE INTENSO MASC (LINHA ARABE)', 'essencia-armafi-club-de-noite-intenso-masc-linha-arabe', NULL, 'ml', 'Essência', 30.000, 0.000, 1.7400, NULL, 1, NULL, 1, '2026-05-21 15:07:27', '2026-05-21 15:17:25', NULL),
(26, 'ESSÊNCIA DE BERGAMOTA ROSA', 'essencia-bergamota-rosa', NULL, 'ml', 'Essência', 100.000, 0.000, 0.2000, NULL, 1, NULL, 1, '2026-05-21 15:09:53', '2026-06-10 02:16:14', NULL),
(27, 'ESSÊNCIA DE BAMBOO', 'essencia-bamboo', NULL, 'ml', 'Essência', 200.000, 0.000, 0.2100, NULL, 1, NULL, 1, '2026-05-21 15:10:22', '2026-06-10 02:16:03', NULL),
(28, 'ESSÊNCIA LELLIS BRANCO ALECRIM', 'essencia-lis-branco-alecrim', NULL, 'ml', 'Essência', 100.000, 0.000, 0.2800, NULL, 1, NULL, 1, '2026-05-21 15:10:53', '2026-06-04 01:10:28', NULL),
(29, 'ESSÊNCIA DE CEDRO SABONETE', 'ess-cedro-sabonete', NULL, 'ml', 'Essência', 50.000, 0.000, 0.1500, NULL, 3, NULL, 1, '2026-05-21 16:55:01', '2026-06-10 02:16:37', NULL),
(30, 'ESSÊNCIA DE PATCHOLY', 'ess-p-kit-patcholy', NULL, 'ml', 'Essência', 50.000, 0.000, 0.1500, NULL, 3, NULL, 1, '2026-05-21 16:55:01', '2026-06-10 02:18:26', NULL),
(31, 'SABONETE LIQUIDO AROMAS YANTRA', 'sabonete-liquido-aromas-yantra', NULL, 'un', 'Base', 3.000, 0.000, 8.4267, NULL, 3, NULL, 1, '2026-05-21 16:55:01', '2026-05-23 05:40:43', NULL),
(32, 'VARETA OLHO GREGO MINI', 'vareta-olho-grego-mini', NULL, 'un', 'Acessório', 5.000, 0.000, 1.1500, NULL, 3, NULL, 1, '2026-05-21 16:55:01', '2026-05-21 16:55:01', NULL),
(33, 'VARETA ESTRELA MADEIRA PEQUENA', 'vareta-estrela-madeira-pequena', NULL, 'un', 'Acessório', 3.000, 0.000, 1.4900, NULL, 3, NULL, 1, '2026-05-21 16:55:01', '2026-05-21 16:55:01', NULL),
(34, 'VARETA FRAMBOESA MINI C/ARGOLA', 'vareta-framboesa-mini-cargola', NULL, 'un', 'Acessório', 5.000, 0.000, 0.9500, NULL, 3, NULL, 1, '2026-05-21 16:55:01', '2026-05-21 16:55:01', NULL),
(35, 'VARETA MINI C/ ARGOLA 12CM', 'vareta-mini-c-argola-12cm', NULL, 'un', 'Acessório', 3.000, 0.000, 0.6000, NULL, 3, NULL, 1, '2026-05-21 16:55:01', '2026-05-21 16:55:01', NULL),
(36, 'PINGENTE DIFUSOR C/PONTEIRA BOLA MADEIRA', 'pingente-difusor-cponteira-bola-madeira', NULL, 'un', 'Acessório', 7.000, 0.000, 1.6500, NULL, 3, NULL, 1, '2026-05-21 16:55:01', '2026-05-21 16:55:01', NULL),
(37, 'VIDRO AMBAR GPP 200ML 28/400 LAVADO', 'vidro-ambar-gpp-200ml-28400-lavado', NULL, 'un', 'Embalagem', 146.000, 0.000, 1.1000, NULL, 3, NULL, 1, '2026-05-23 03:55:48', '2026-06-03 18:05:23', NULL),
(38, 'VALVULA SPRAY LUXO 28/410 SAIA PRETA/NAT', 'valvula-spray-luxo-28410-saia-pretanat', NULL, 'un', 'Embalagem', 73.000, 0.000, 1.7300, NULL, 3, NULL, 1, '2026-05-23 03:55:48', '2026-06-03 18:05:23', NULL),
(39, 'VALVULA GATILHO MINI 28/410 PRETA C/TRV', 'valvula-gatilho-mini-28410-preta-ctrv', NULL, 'un', 'Embalagem', 73.000, 0.000, 1.4000, NULL, 3, NULL, 1, '2026-05-23 03:55:48', '2026-06-03 18:05:23', NULL),
(40, 'FRASCO PET   35ML BASE VITA 20/410 36/10', 'frasco-pet-35ml-base-vita-20410-3610', NULL, 'un', 'Embalagem', 10.000, 0.000, 0.5400, NULL, 3, NULL, 1, '2026-05-23 04:11:19', '2026-05-23 04:11:19', NULL),
(41, 'FRASCO PET   30ML OVAL 20/410 R.35/10', 'frasco-pet-30ml-oval-20410-r3510', NULL, 'un', 'Embalagem', 20.000, 0.000, 0.5500, NULL, 3, NULL, 1, '2026-05-23 04:11:19', '2026-05-23 04:11:19', NULL),
(42, 'FRASCO PVC  30ML OVAL CRISTAL 18/410 F22', 'frasco-pvc-30ml-oval-cristal-18410-f22', NULL, 'un', NULL, 10.000, 0.000, 0.5900, NULL, 3, NULL, 1, '2026-05-23 04:11:19', '2026-05-23 04:11:19', NULL),
(43, 'FRASCO PET   60ML OVAL 18/410 8G REF:120', 'frasco-pet-60ml-oval-18410-8g-ref120', NULL, 'un', 'Embalagem', 20.000, 0.000, 0.5600, NULL, 3, NULL, 1, '2026-05-23 04:11:19', '2026-05-23 04:11:19', NULL),
(44, 'FRASCO PET   10ML CILINDRICO 18/410 BCO', 'frasco-pet-10ml-cilindrico-18410-bco', NULL, 'un', 'Embalagem', 100.000, 0.000, 0.1900, NULL, 3, NULL, 1, '2026-05-23 04:11:20', '2026-05-23 04:11:20', NULL),
(45, 'TAMPA FLIP TOP 18/410 PINK ISOS', 'tampa-flip-top-18410-pink-isos', NULL, 'un', NULL, 50.000, 0.000, 0.2800, NULL, 3, NULL, 1, '2026-05-23 04:11:20', '2026-05-23 04:11:20', NULL),
(46, 'TAMPA FLIP TOP OMEGA 18/410 MARROM', 'tampa-flip-top-omega-18410-marrom', NULL, 'un', NULL, 60.000, 0.000, 0.1300, NULL, 3, NULL, 1, '2026-05-23 04:11:20', '2026-05-23 04:11:20', NULL),
(47, 'TAMPA FLIP TOP 18/410 PRETA ABAULADA IS', 'tampa-flip-top-18410-preta-abaulada-is', NULL, 'un', 'Embalagem', 20.000, 0.000, 0.2800, NULL, 3, NULL, 1, '2026-05-23 04:11:20', '2026-05-23 04:11:20', NULL),
(48, 'TAMPA FLIP TOP OMEGA 20/410 VERDE R.45', 'tampa-flip-top-omega-20410-verde-r45', NULL, 'un', 'Embalagem', 20.000, 0.000, 0.1600, NULL, 3, NULL, 1, '2026-05-23 04:11:20', '2026-05-23 04:11:20', NULL),
(49, 'TAMPA FLIP TOP OMEGA 20/410 LILAS 08', 'tampa-flip-top-omega-20410-lilas-08', NULL, 'un', 'Embalagem', 5.000, 0.000, 0.1500, NULL, 3, NULL, 1, '2026-05-23 04:11:20', '2026-05-23 04:11:20', NULL),
(50, 'FRASCO AMBAR PET  35ML BASE VIT 20/41 36', 'frasco-ambar-pet-35ml-base-vit-2041-36', NULL, 'un', 'Embalagem', 10.000, 0.000, 0.6000, NULL, 3, NULL, 1, '2026-05-23 04:11:20', '2026-05-23 04:11:20', NULL),
(51, 'FRASCO PET  140ML OVAL CRIST.24/415 5969 - Corporal', 'frasco-pet-140ml-oval-crist24415-5969', NULL, 'un', 'Embalagem', 50.000, 0.000, 1.2400, NULL, 3, NULL, 1, '2026-05-23 04:11:20', '2026-05-26 15:01:28', NULL),
(52, 'POTE  04GRS.CRISTAL/BRANCO C/TP CORES', 'pote-04grscristalbranco-ctp-cores', NULL, 'un', 'Embalagem', 2.000, 0.000, 25.9900, NULL, 3, NULL, 1, '2026-05-23 04:11:20', '2026-05-23 04:11:20', NULL),
(53, 'POTE 500GRS.OVAL PRATA TP FIO OURO/PRATA', 'pote-500grsoval-prata-tp-fio-ouroprata', NULL, 'un', 'Embalagem', 2.000, 0.000, 2.7000, NULL, 3, NULL, 1, '2026-05-23 04:11:20', '2026-05-23 04:11:20', NULL),
(54, 'ESSÊNCIA SCANDALO JEAN PAUL FEM - DOMO', 'ess-scandalo-jean-paul-fem-domo', NULL, 'ml', 'Essência', 175.000, 0.000, 0.4000, NULL, 2, NULL, 1, '2026-05-23 04:25:44', '2026-06-09 20:30:13', NULL),
(55, 'ESSÊNCIA ARABE FAKAR BLACK UNISEX 50ML', 'ess-arabe-fakar-black-unisex-50ml', NULL, 'ml', 'Essência', 50.000, 0.000, 0.9000, NULL, 2, NULL, 1, '2026-05-23 04:25:44', '2026-05-23 04:56:00', NULL),
(56, 'ESSÊNCIA ARABE ROYAL AMBER UNISEX', 'ess-arabe-royal-amber-unisex', NULL, 'un', 'Essência', 50.000, 0.000, 0.9000, NULL, 2, NULL, 1, '2026-05-23 04:25:44', '2026-06-10 03:48:57', NULL),
(57, 'ESSÊNCIA ARABE DELINIA LA ROSÉ FEM.', 'ess-arabe-delinia-la-rose-fem', NULL, 'ml', 'Essência', 146.000, 0.000, 0.5918, NULL, 2, NULL, 1, '2026-05-23 04:25:44', '2026-06-09 20:30:13', NULL),
(58, 'BASE PARA BODY SPLASH', 'base-para-body-splash', NULL, 'L', 'Base', 6.000, 0.000, 19.0000, NULL, 2, NULL, 1, '2026-05-23 04:25:44', '2026-06-09 20:30:13', NULL),
(59, 'FRASCO PET 200ML R 24/410 CRISTAL AURA C/TP - Body Splash', 'frasco-pet-200ml-r-24410-cristal-aura-ctp', NULL, 'un', 'Embalagem', 38.000, 0.000, 2.6500, NULL, 2, NULL, 1, '2026-05-23 04:25:44', '2026-06-09 20:30:13', NULL),
(60, 'VALVULA SPRAY R.24/410 OURO HOT STAMP - BODY SPLASH', 'valvula-spray-r24410-ouro-hot-stamp', NULL, 'un', 'Embalagem', 62.000, 0.000, 1.6500, NULL, 2, NULL, 1, '2026-05-23 04:25:44', '2026-06-09 20:30:13', NULL),
(61, 'BASE P PERFUME VEICULO 1LT', 'base-p-perfume-veiculo-1lt', NULL, 'L', 'Base', 7.000, 0.000, 16.1143, NULL, 2, NULL, 1, '2026-05-23 04:25:44', '2026-06-03 19:41:05', NULL),
(62, 'POTE DE VIDRO REDONDO 30ML C/TP', 'pote-de-vidro-redondo-30ml-ctp', NULL, 'un', 'Embalagem', 10.000, 0.000, 3.8500, NULL, 2, NULL, 1, '2026-05-23 04:25:44', '2026-05-23 04:25:44', NULL),
(63, 'TAMPA PLAST. POTE MET. DOURADA TRADITION', 'tampa-plast-pote-met-dourada-tradition', NULL, 'un', 'Embalagem', 1.000, 0.000, 2.0000, NULL, 4, NULL, 1, '2026-05-23 04:46:37', '2026-05-23 04:46:37', NULL),
(64, 'POTE PET 1LT WHEY ROSA', 'pote-pet-1lt-whey-rosa', NULL, 'un', 'Embalagem', 1.000, 0.000, 3.0000, NULL, 4, NULL, 1, '2026-05-23 04:46:37', '2026-05-23 04:46:37', NULL),
(65, 'ESSÊNCIA CLASSIC 7 ERVAS R.CC113 DOMO', 'essclassic-7-ervas-rcc113-domo', NULL, 'ml', 'Essência', 100.000, 0.000, 0.1800, NULL, 4, NULL, 1, '2026-05-23 04:46:37', '2026-05-23 05:02:18', NULL),
(66, 'ESSÊNCIA CLASSIC CAFE  R GC0059 DOMO', 'essclassic-cafe-r-gc0059-domo', NULL, 'ml', 'Essência', 100.000, 0.000, 0.2000, NULL, 4, NULL, 1, '2026-05-23 04:46:37', '2026-05-23 05:02:35', NULL),
(67, 'ESSÊNCIA CLASSIC DOVE  17.013 DOMO ZZZ', 'essclassic-dove-17013-domo-zzz', NULL, 'ml', 'Essência', 100.000, 0.000, 0.1800, NULL, 4, NULL, 1, '2026-05-23 04:46:37', '2026-05-23 05:03:07', NULL),
(68, 'ESSENCIA P/AROMATIZADOR MARVEL', 'essencia-paromatizador-marvel', NULL, 'ml', 'Essência', 200.000, 0.000, 0.1000, NULL, 4, NULL, 1, '2026-05-23 04:46:37', '2026-05-23 04:46:37', NULL),
(69, 'ESSÊNCIA AMACIANTE DOWNY AZUL', 'essencia-amaciante-downy-azul', NULL, 'ml', 'Essência', 100.000, 0.000, 0.2000, NULL, 5, NULL, 1, '2026-05-23 05:15:22', '2026-05-23 05:40:42', NULL),
(70, 'ESSÊNCIA DE ARTEMISA OAK', 'essencia-artemisa-oak', NULL, 'ml', 'Essência', 100.000, 0.000, 0.1900, NULL, 5, NULL, 1, '2026-05-23 05:19:15', '2026-06-10 02:15:51', NULL),
(71, 'ESSÊNCIA DE ALECRIM OAK', 'essencia-alecrim-oak', NULL, 'ml', 'Essência', 100.000, 0.000, 0.1900, NULL, 5, NULL, 1, '2026-05-23 05:19:49', '2026-06-10 02:15:18', NULL),
(72, 'ESSÊNCIA DASLU OAK', 'essencia-daslu-oak', NULL, 'ml', 'Essência', 100.000, 0.000, 0.1900, NULL, 5, NULL, 1, '2026-05-23 05:20:14', '2026-05-23 05:40:42', NULL),
(73, 'ESSÊNCIA DE ARRUDA OAK', 'essencia-arruda-oak', NULL, 'ml', 'Essência', 100.000, 0.000, 0.1900, NULL, 5, NULL, 1, '2026-05-23 05:21:34', '2026-06-10 02:15:41', NULL),
(74, 'BODY SPLASH NEUTRO YANTRA', 'body-splash-neutro-yantra', NULL, 'L', 'Base', 1.000, 0.000, 14.9900, NULL, 5, NULL, 1, '2026-05-23 05:22:05', '2026-05-23 05:40:43', NULL),
(75, 'ESSÊNCIA VIP BLACK VOLLMENS', 'essencia-vip-black-vollmens', NULL, 'ml', 'Essência', 100.000, 0.000, 0.6000, NULL, 5, NULL, 1, '2026-05-23 05:23:08', '2026-06-03 18:09:35', NULL),
(76, 'ESSÊNCIA DE CASCA E FOLHA OAK', 'essencia-casca-e-folha-oak', NULL, 'ml', 'Essência', 100.000, 0.000, 0.1900, NULL, 5, NULL, 1, '2026-05-23 05:23:48', '2026-06-10 02:16:26', NULL),
(77, 'TAMPA FLIP TOP OMEGA 24/415 BRANCA - CORPORAL', 'tampa-flip-top-omega-24415-branca', NULL, 'un', 'Embalagem', 50.000, 0.000, 0.4500, NULL, 5, NULL, 1, '2026-05-23 05:27:22', '2026-05-26 15:23:02', NULL),
(78, 'ESSÊNCIA GOOD GIRL FEM', 'essencia-good-girl-fem', NULL, 'ml', 'Essência', 25.000, 0.000, 0.6500, NULL, 5, NULL, 1, '2026-05-23 05:28:28', '2026-06-03 20:42:06', NULL),
(79, 'FRASCO PET 100ML R.24/410 CRISTAL ACQUA - Body Splash', 'frasco-pet-100ml-r24410-cristal-acqua-body-splash', NULL, 'un', 'Embalagem', 26.000, 0.000, 1.6500, NULL, 2, NULL, 1, '2026-06-03 18:01:49', '2026-06-03 22:19:48', NULL),
(80, 'ESSÊNCIA ARABE ASSAD BOURBON MASC.', 'ess-arabe-assad-bourbon-masc', NULL, 'ml', 'Essência', 25.000, 0.000, 0.9000, NULL, 2, NULL, 1, '2026-06-03 18:01:49', '2026-06-03 22:35:35', NULL),
(81, 'ESSÊNCIA ARABE ASSAD MASC. LESS', 'ess-arabe-assad-masc-less', NULL, 'ml', 'Essência', 25.000, 0.000, 0.9000, NULL, 2, NULL, 1, '2026-06-03 18:01:49', '2026-06-03 22:35:19', NULL),
(82, 'BASE PARA BODY SPLASH S/MICA', 'base-para-body-splash-smica', NULL, 'L', 'Base', 2.000, 0.000, 17.0000, NULL, 2, NULL, 1, '2026-06-03 18:01:49', '2026-06-09 20:30:13', NULL),
(83, 'VIDRO AMOSTRA 1.8ML TP PRESSAO F2', 'vidro-amostra-18ml-tp-pressao-f2', NULL, 'un', NULL, 100.000, 0.000, 0.4200, NULL, 3, NULL, 1, '2026-06-03 18:05:23', '2026-06-03 18:05:23', NULL),
(84, 'LACO DE STRASS CORES - Simples', 'laco-de-strass-cores-simples', NULL, 'un', 'Embalagem', 4.000, 0.000, 3.9900, NULL, 7, NULL, 1, '2026-06-03 19:41:05', '2026-06-03 19:41:05', NULL),
(85, 'LACO 2 FLORES CAMELIAS - Flores', 'laco-2-flores-camelias-flores', NULL, 'un', NULL, 13.000, 0.000, 6.4500, NULL, 7, NULL, 1, '2026-06-03 19:41:05', '2026-06-03 19:41:05', NULL),
(86, 'BASE CREME HIDRATANTE NEUTRO C/UREIA YANTAR', 'base-creme-hidratante-neutro-cureia-yantar', NULL, 'kg', 'Base', 2.000, 0.000, 14.9800, NULL, 7, NULL, 1, '2026-06-03 19:41:05', '2026-06-03 22:16:22', NULL),
(87, 'BASE SAB. LIQ. VEGETAL VG 1X4 TRANSPARENTE LT', 'base-sab-liq-vegetal-vg-1x4-transparente-lt', NULL, 'L', 'Base', 1.000, 0.000, 24.0000, NULL, 1, NULL, 1, '2026-06-03 20:06:22', '2026-06-03 20:06:22', NULL),
(88, 'ETIQUETA METALIZADA 3UN', 'etiqueta-metalizada-3un', NULL, 'un', 'Embalagem', 8.000, 0.000, 5.5000, NULL, 1, NULL, 1, '2026-06-03 20:06:22', '2026-06-08 22:28:46', NULL),
(89, 'DOSADOR 01ML', 'dosador-01ml', NULL, 'un', 'Utensílios', 2.000, 0.000, 0.5500, NULL, 1, NULL, 1, '2026-06-03 20:06:22', '2026-06-03 20:06:22', NULL),
(90, 'BASE SAB. LIQ. VEGETAL VG 1X4 PEROLADA LT', 'base-sab-liq-vegetal-vg-1x4-perolada-lt', NULL, 'L', 'Base', 1.000, 0.000, 24.0000, NULL, 1, NULL, 1, '2026-06-03 20:06:22', '2026-06-03 22:18:07', NULL),
(91, 'RENEX NONILFENOL ETOXILADO 95', 'renex-nonilfenol-etoxilado-95', NULL, 'ml', NULL, 100.000, 0.000, 0.0600, NULL, 1, NULL, 1, '2026-06-03 20:06:22', '2026-06-03 20:06:22', NULL),
(92, 'VIDRO IMP 050ML ARABE COLOR COM VALV. E CAPA UN', 'vidro-imp-050ml-arabe-color-com-valv-e-capa-un', NULL, 'un', 'Embalagem', 4.000, 0.000, 18.8000, NULL, 1, NULL, 1, '2026-06-03 20:06:22', '2026-06-03 20:06:22', NULL),
(93, 'ESSÊNCIA VICTORIA SECRET PEAR SUGAR LINHA A', 'ess-victori-secret-pear-sugar-linha-a', NULL, 'ml', 'Essência', 30.000, 0.000, 0.3000, NULL, 1, NULL, 1, '2026-06-03 20:06:22', '2026-06-03 22:34:59', NULL),
(94, 'PAPEL PH NACIONAL', 'papel-ph-nacional', NULL, 'un', NULL, 100.000, 0.000, 0.2200, NULL, 1, NULL, 1, '2026-06-03 20:06:22', '2026-06-03 20:06:22', NULL),
(95, 'ETIQUETAS DIVERSAS TRANSPARENTE C/ 20 UN', 'etiquetas-diversas-transparente-c-20-un', NULL, 'un', 'Etiqueta', 2.000, 0.000, 3.5000, NULL, 1, NULL, 1, '2026-06-03 20:06:22', '2026-06-03 22:19:27', NULL),
(96, 'EXTRATO DE ARNICA', 'essencia-de-arnica', NULL, 'ml', 'Extrato', 1000.000, 0.000, 0.0300, NULL, 8, NULL, 1, '2026-06-03 22:34:25', '2026-06-08 21:04:07', NULL),
(97, 'EXTRATO DE CALÊNDULA', 'extrato-de-calendula', NULL, 'ml', 'Extrato', 960.000, 0.000, 0.0300, NULL, 8, NULL, 1, '2026-06-03 22:37:15', '2026-06-09 15:42:10', NULL),
(98, 'EXTRATO DE PANACEIA', 'extrato-de-panaceia', NULL, 'ml', 'Extrato', 1000.000, 0.000, 0.0300, NULL, 8, NULL, 1, '2026-06-03 22:40:22', '2026-06-08 22:27:46', NULL),
(99, 'ÓLEO DE BABOSA', 'oleo-de-babosa', NULL, 'ml', 'Óleo', 100.000, 0.000, 0.1300, NULL, 1, NULL, 1, '2026-06-03 22:46:07', '2026-06-08 22:53:01', NULL),
(100, 'ÓLEO DE ARNICA', 'oleo-de-arnica', NULL, 'ml', 'Óleo', 100.000, 0.000, 0.1300, NULL, 1, NULL, 1, '2026-06-03 22:46:35', '2026-06-08 22:52:30', NULL),
(101, 'ÓLEO DE GIRASSOL', 'oleo-de-girassol', NULL, 'ml', 'Óleo', 100.000, 0.000, 0.0700, NULL, 1, NULL, 1, '2026-06-03 22:47:20', '2026-06-08 22:54:03', NULL),
(102, 'ÓLEO DE ROSA MOSQUETA MURIEL', 'oleo-de-rosa-mosqueta', NULL, 'ml', 'Óleo', 100.000, 0.000, 0.3900, NULL, 1, NULL, 1, '2026-06-03 22:47:47', '2026-06-10 02:12:19', NULL),
(103, 'ÓLEO DE ANDIROBA', 'oleo-de-andiroba', NULL, 'ml', 'Óleo', 100.000, 0.000, 0.2800, NULL, 1, NULL, 1, '2026-06-03 22:48:09', '2026-06-08 22:51:28', NULL),
(104, 'ÓLEO DE SEMENTE DE UVA', 'oleo-de-semente-de-uva', NULL, 'ml', 'Óleo', 100.000, 0.000, 0.0800, NULL, 1, NULL, 1, '2026-06-03 22:48:37', '2026-06-08 22:56:43', NULL),
(105, 'ÓLEO DE VITAMINA E', 'oleo-de-vitamina-e', NULL, 'ml', 'Óleo', 92.000, 0.000, 0.5400, NULL, 1, NULL, 1, '2026-06-03 22:49:41', '2026-06-09 15:42:10', NULL),
(106, 'ÓLEO DE MALALEUCA', 'oleo-de-malaleuca', NULL, 'ml', 'Óleo', 100.000, 0.000, 0.8800, NULL, 1, NULL, 1, '2026-06-03 22:50:10', '2026-06-08 22:55:20', NULL),
(107, 'ÓLEO DE CRAVO', 'oleo-de-cravo', NULL, 'ml', 'Óleo', 100.000, 0.000, 0.2400, NULL, 1, NULL, 1, '2026-06-03 22:51:02', '2026-06-08 22:53:37', NULL),
(108, 'EXTRATO DE BABOSA', 'extraato-de-babosa', NULL, 'ml', 'Extrato', 1000.000, 0.000, 0.0300, NULL, 8, NULL, 1, '2026-06-03 23:04:40', '2026-06-08 22:28:16', NULL),
(109, 'EXTRATO DE CONFREI', 'extrato-de-confrei', NULL, 'ml', 'Extrato', 1000.000, 0.000, 0.0300, NULL, 8, NULL, 1, '2026-06-03 23:05:09', '2026-06-08 22:27:33', NULL),
(110, 'ESSÊNCIA DE ROSAS VERMELHAS', 'essencia-rosas-vermelhas', NULL, 'ml', 'Essência', 100.000, 0.000, 0.2200, NULL, 1, NULL, 1, '2026-06-03 23:06:01', '2026-06-10 02:18:42', NULL),
(111, 'ÓLEO DE SILICONE', 'oleo-de-silicone', NULL, 'ml', 'Óleo', 100.000, 0.000, 0.1300, NULL, 1, NULL, 1, '2026-06-04 04:12:29', '2026-06-08 22:57:21', NULL),
(112, 'ANFOTERO BETAINICO COCCAMIDOPROPILBETAINA LITRO', 'anfotero-betainico-coccamidopropilbetaina-litro', NULL, 'ml', 'Tensoativo', 1000.000, 0.000, 0.0200, NULL, 1, NULL, 1, '2026-06-08 21:03:43', '2026-06-10 03:22:29', NULL),
(113, 'BASE CREME LIMNE C/ ROSA MOSQUETA KG 1993 ONU-1993', 'base-creme-limne-c-rosa-mosqueta-kg-1993-onu-1993', NULL, 'kg', 'Base', 0.000, 0.000, 33.0000, NULL, 1, NULL, 1, '2026-06-08 21:03:43', '2026-06-09 15:42:10', NULL),
(114, 'COR 100ML AGUA LILAS', 'cor-100ml-agua-lilas', NULL, 'ml', 'Corante', 100.000, 0.000, 0.0500, NULL, 1, NULL, 1, '2026-06-08 21:03:43', '2026-06-08 21:03:43', NULL),
(115, 'COR 100ML AGUA LARANJA', 'cor-100ml-agua-laranja', NULL, 'ml', NULL, 100.000, 0.000, 0.0500, NULL, 1, NULL, 1, '2026-06-08 21:03:43', '2026-06-08 21:03:43', NULL),
(116, 'COR ALIM 10ML BRANCO', 'cor-alim-10ml-branco', NULL, 'ml', NULL, 1.000, 0.000, 0.0300, NULL, 1, NULL, 1, '2026-06-08 21:03:43', '2026-06-08 21:03:43', NULL),
(117, 'ESSÊNCIA DIOR SAUVAGE MASC LINHA I', 'essencia-dior-sauvage-masc-linha-i', NULL, 'ml', 'Essência', 60.000, 0.000, 0.9700, NULL, 1, NULL, 1, '2026-06-08 21:03:43', '2026-06-08 21:03:43', NULL),
(118, 'EXTRATO GLICOLICO ABACATE', 'extrato-glicolico-abacate', NULL, 'ml', 'Extrato', 100.000, 0.000, 0.0700, NULL, 1, NULL, 1, '2026-06-08 21:03:43', '2026-06-08 21:03:43', NULL),
(119, 'PROMOCAO ESSENCIA', 'promocao-essencia', NULL, 'ml', 'Essência', 400.000, 0.000, 0.1500, NULL, 1, NULL, 1, '2026-06-08 21:03:43', '2026-06-08 21:03:43', NULL),
(120, 'F143 FORMA DE ACETATO CORACAO DECORADO 15 CAV', 'f143-forma-de-acetato-coracao-decorado-15-cav', NULL, 'un', 'Utensílios', 2.000, 0.000, 1.5000, NULL, 1, NULL, 1, '2026-06-08 21:03:43', '2026-06-08 21:03:43', NULL),
(121, 'F140 FORMA DE ACETATO CORACAO TORTO PEQ 12 CAV', 'f140-forma-de-acetato-coracao-torto-peq-12-cav', NULL, 'un', 'Utensílios', 2.000, 0.000, 1.5000, NULL, 1, NULL, 1, '2026-06-08 21:03:43', '2026-06-08 21:03:43', NULL),
(122, 'POTE VIDRO TRANSP 030G TAMPA PRATA', 'pote-vidro-transp-030g-tampa-prata', NULL, 'un', 'Embalagem', 2.000, 0.000, 4.6000, NULL, 1, NULL, 1, '2026-06-08 21:03:43', '2026-06-08 21:03:43', NULL),
(123, 'POTE VIDRO AMBAR 030G TAMPA DOURADA', 'pote-vidro-ambar-030g-tampa-dourada', NULL, 'un', 'Embalagem', 2.000, 0.000, 4.9000, NULL, 1, NULL, 1, '2026-06-08 21:03:43', '2026-06-08 21:03:43', NULL),
(124, 'Óxido de Zinco', 'oxido-de-zinco', NULL, 'g', 'Protetor', 80.000, 0.000, 0.1000, NULL, 1, NULL, 1, '2026-06-09 14:26:55', '2026-06-09 15:42:10', NULL),
(125, 'Niacinamida', 'niacinamida', NULL, 'g', 'Vitamina', 52.000, 0.000, 0.3800, NULL, 1, NULL, 1, '2026-06-09 14:30:34', '2026-06-09 15:42:10', NULL),
(126, 'ÓLEO DE SEMENTE DE FRAMBOESA', 'oleo-de-semente-de-framboesa', NULL, 'ml', 'Óleo', 72.000, 0.000, 0.1200, NULL, 1, NULL, 1, '2026-06-09 14:32:02', '2026-06-09 15:42:10', NULL),
(127, 'EXTRATO DE CHÁ VERDE', 'extrato-de-cha-verde', NULL, 'ml', 'Extrato', 80.000, 0.000, 0.6000, NULL, 1, NULL, 1, '2026-06-09 14:41:39', '2026-06-09 15:42:10', NULL),
(128, 'POTE REDONDO 30GR AZUL - FACIAL DIURNO', 'pote-redondo-30gr-azul-facial', NULL, 'un', 'Embalagem', 3.000, 0.000, 1.2000, NULL, 3, NULL, 1, '2026-06-09 14:46:37', '2026-06-10 01:23:14', NULL),
(129, 'EXTRATO DE CONFREI E CAMOMILA', 'extratode-confrei-e-camomila', NULL, 'ml', NULL, 1000.000, 0.000, 0.0300, NULL, 8, NULL, 1, '2026-06-09 15:55:45', '2026-06-09 15:56:34', NULL),
(130, 'ÓLEO DE ARNICA COM BÉTULA', 'oleo-de-arnica-com-betula', NULL, 'ml', 'Óleo', 1000.000, 0.000, 0.0800, NULL, 8, NULL, 1, '2026-06-09 15:58:04', '2026-06-09 15:59:01', NULL),
(132, 'EXTRATO DE ROSAS VERMELHAS', 'extrato-de-rosa-vermelha', NULL, 'ml', 'Extrato', 1000.000, 0.000, 0.0300, NULL, 8, NULL, 1, '2026-06-09 19:21:55', '2026-06-10 01:59:52', NULL),
(133, 'VALVULA SABONETE R.24/410 LUXO DOURADA/NATURAL - CREME CORPORAL', 'valvula-sabonete-r24410-luxo-douradanatural-creme-corporal', NULL, 'un', 'Embalagem', 12.000, 0.000, 2.8000, NULL, 2, NULL, 1, '2026-06-09 20:30:13', '2026-06-09 20:30:13', NULL),
(134, 'POTE REDONDO 30GR MARROM - FACIAL NOTURNO', 'pote-redondo-30gr-azul-facial-noturno', NULL, 'un', 'Embalagem', 33.000, 0.000, 1.2000, NULL, 3, NULL, 1, '2026-06-10 01:23:42', '2026-06-10 01:24:43', NULL),
(135, 'EXTRATO DE CAMOMILA', 'extrato-de-camomila', NULL, 'ml', 'Extrato', 1000.000, 0.000, 0.0300, NULL, 8, NULL, 1, '2026-06-10 01:58:48', '2026-06-10 01:59:06', NULL),
(136, 'ÓLEO DE ROSA MOSQUETA RUBIGINOSA', 'oleo-de-rosa-mosqueta-rubiginosa', NULL, 'ml', 'Óleo', 100.000, 0.000, 0.1600, NULL, 1, NULL, 1, '2026-06-10 02:04:58', '2026-06-10 02:10:41', NULL),
(137, 'ÓLEO DE ROSA MOSQUETA CANINA', 'oleo-de-rosa-mosqueta-canina', NULL, 'ml', 'Óleo', 100.000, 0.000, 0.1600, NULL, 1, NULL, 1, '2026-06-10 02:06:35', '2026-06-10 02:10:02', NULL),
(138, 'ÓLEO DE GIRASSOL MURIEL', 'oleo-de-girassol-muriel', NULL, 'ml', 'Óleo', 100.000, 0.000, 0.3900, NULL, 8, NULL, 1, '2026-06-10 02:09:04', '2026-06-10 02:09:25', NULL),
(139, 'ÓLEO DE AMENDOAS DOCE', 'oleo-de-amendoas-doce', NULL, 'ml', 'Óleo', 100.000, 0.000, 0.0900, NULL, 1, NULL, 1, '2026-06-10 02:13:01', '2026-06-10 02:13:34', NULL),
(140, 'ESSÊNCIA DE ANDIROBA', 'essencia-de-andiroba', NULL, 'ml', 'Essência', 500.000, 0.000, 0.1900, NULL, 5, NULL, 1, '2026-06-10 02:57:24', '2026-06-10 02:58:16', NULL),
(141, 'EXTRATO DE HORTELÃ', 'extrato-de-hortela', NULL, 'ml', 'Extrato', 1000.000, 0.000, 0.0300, NULL, 8, NULL, 1, '2026-06-10 03:09:03', '2026-06-10 03:18:13', NULL),
(142, 'EXTRATO DE ALECRIM', 'extrato-de-alecrim', NULL, 'ml', 'Extrato', 1000.000, 0.000, 0.0300, NULL, 8, NULL, 1, '2026-06-10 03:09:49', '2026-06-10 03:17:39', NULL),
(144, 'EXTRATO DE BARBATIMÃO', 'extrato-de-barbatimao', NULL, 'ml', 'Extrato', 1000.000, 0.000, 0.0300, NULL, 8, NULL, 1, '2026-06-10 03:10:46', '2026-06-10 03:17:56', NULL),
(145, 'EXTRATO DE UNHA DE GATO', 'extrato-de-unha-de-gato', NULL, 'ml', 'Extrato', 1000.000, 0.000, 0.0300, NULL, 8, NULL, 1, '2026-06-10 03:12:17', '2026-06-10 03:18:29', NULL),
(146, 'EXTRATO DE UXI AMARELO', 'extrato-de-uxi-amarelo', NULL, 'ml', 'Extrato', 1000.000, 0.000, 0.0300, NULL, 8, NULL, 1, '2026-06-10 03:12:45', '2026-06-10 03:18:47', NULL),
(147, 'EXTRATO DE MAÇÃ DE ELEFANTE', 'extrato-de-maca-de-elefante', NULL, 'ml', 'Extrato', 1000.000, 0.000, 0.0400, NULL, 8, NULL, 1, '2026-06-10 03:40:56', '2026-06-10 03:48:04', NULL),
(148, 'EXTRATO DE CÂNFORA', 'extrato-de-canfora', NULL, 'ml', 'Extrato', 100.000, 0.000, 0.3400, NULL, 8, NULL, 1, '2026-06-10 03:41:25', '2026-06-10 03:47:34', NULL),
(149, 'ESSÊNCIA DE CÂNFORA', 'essencia-de-canfora', NULL, 'ml', 'Essência', 100.000, 0.000, 0.3400, NULL, 1, NULL, 1, '2026-06-10 03:42:19', '2026-06-10 03:42:52', NULL),
(150, 'ESSÊNCIA DE SALICILATO DE MENTILA', 'essencia-de-salicilato-de-mentila', NULL, 'ml', 'Essência', 100.000, 0.000, 0.1500, NULL, 1, NULL, 1, '2026-06-10 03:44:05', '2026-06-10 03:44:34', NULL),
(151, 'EXTRATO COMPOSTO BIO ÁLIVIO 21', 'extrato-composto-bio-alivio-21', NULL, 'ml', 'Extrato', 1000.000, 0.000, 0.0400, NULL, 8, NULL, 1, '2026-06-10 03:52:22', '2026-06-10 03:53:21', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `raw_material_movements`
--

CREATE TABLE `raw_material_movements` (
  `id` bigint UNSIGNED NOT NULL,
  `raw_material_id` bigint UNSIGNED NOT NULL,
  `batch_id` bigint UNSIGNED DEFAULT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `type` enum('purchase','adjustment_in','adjustment_out','consumed','waste','return') COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` decimal(12,3) NOT NULL,
  `unit_cost` decimal(10,4) DEFAULT NULL,
  `total_cost` decimal(12,2) DEFAULT NULL,
  `stock_after` decimal(12,3) NOT NULL,
  `average_cost_after` decimal(10,4) NOT NULL,
  `reference_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference_id` bigint UNSIGNED DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `raw_material_movements`
--

INSERT INTO `raw_material_movements` (`id`, `raw_material_id`, `batch_id`, `user_id`, `type`, `quantity`, `unit_cost`, `total_cost`, `stock_after`, `average_cost_after`, `reference_type`, `reference_id`, `notes`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 'purchase', 1.000, 1.2000, 1.20, 2.000, 1.2000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 15, 'Recebimento lote: LOT-MWAE7YRB', '2026-05-21 02:48:19', '2026-05-21 14:12:15'),
(2, 2, 2, 1, 'purchase', 10.000, 1.5997, 16.00, 20.000, 1.5997, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 16, 'Recebimento lote: LOT-7G2A4LZQ', '2026-05-21 13:36:30', '2026-05-21 14:16:16'),
(3, 3, 3, 1, 'purchase', 10.000, 2.5000, 25.00, 20.000, 2.5000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 16, 'Recebimento lote: LOT-CLXIWO1G', '2026-05-21 13:36:30', '2026-05-21 14:15:55'),
(4, 4, 4, 1, 'purchase', 100.000, 0.2600, 26.00, 200.000, 0.2600, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 16, 'Recebimento lote: LOT-YMF89WQU', '2026-05-21 13:36:30', '2026-05-21 14:15:21'),
(5, 5, 5, 1, 'purchase', 100.000, 0.2400, 24.00, 200.000, 0.2400, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 16, 'Recebimento lote: LOT-I2DLHYEY', '2026-05-21 13:36:30', '2026-05-21 14:15:04'),
(6, 6, 6, 1, 'purchase', 100.000, 0.2800, 28.00, 200.000, 0.2800, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 16, 'Recebimento lote: LOT-TBR4REN0', '2026-05-21 13:36:30', '2026-05-21 14:14:50'),
(7, 7, 7, 1, 'purchase', 100.000, 0.2496, 24.96, 200.000, 0.2496, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 16, 'Recebimento lote: LOT-CMBDKE1W', '2026-05-21 13:36:30', '2026-05-21 14:14:34'),
(8, 8, 8, 1, 'purchase', 100.000, 0.2796, 27.96, 200.000, 0.2796, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 16, 'Recebimento lote: LOT-H7T1ZY7X', '2026-05-21 13:36:30', '2026-05-21 14:13:57'),
(9, 9, 9, 1, 'purchase', 100.000, 0.2200, 22.00, 200.000, 0.2200, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 16, 'Recebimento lote: LOT-YAZJSSLY', '2026-05-21 13:36:30', '2026-05-21 14:13:34'),
(10, 8, NULL, 1, 'adjustment_out', 100.000, 0.2796, 27.96, 100.000, 0.2796, NULL, NULL, NULL, '2026-05-21 14:17:20', '2026-05-21 14:17:20'),
(11, 6, NULL, 1, 'adjustment_out', 100.000, 0.2800, 28.00, 100.000, 0.2800, NULL, NULL, NULL, '2026-05-21 14:17:39', '2026-05-21 14:17:39'),
(12, 5, NULL, 1, 'adjustment_out', 100.000, 0.2400, 24.00, 100.000, 0.2400, NULL, NULL, NULL, '2026-05-21 14:17:53', '2026-05-21 14:17:53'),
(13, 4, NULL, 1, 'adjustment_out', 100.000, 0.2600, 26.00, 100.000, 0.2600, NULL, NULL, NULL, '2026-05-21 14:18:05', '2026-05-21 14:18:05'),
(14, 7, NULL, 1, 'adjustment_out', 100.000, 0.2496, 24.96, 100.000, 0.2496, NULL, NULL, NULL, '2026-05-21 14:18:17', '2026-05-21 14:18:17'),
(15, 9, NULL, 1, 'adjustment_out', 100.000, 0.2200, 22.00, 100.000, 0.2200, NULL, NULL, NULL, '2026-05-21 14:18:28', '2026-05-21 14:18:28'),
(16, 1, NULL, 1, 'adjustment_out', 2.000, 1.2000, 2.40, 0.000, 1.2000, NULL, NULL, NULL, '2026-05-21 14:18:42', '2026-05-21 14:18:42'),
(17, 2, NULL, 1, 'adjustment_out', 10.000, 1.5997, 16.00, 10.000, 1.5997, NULL, NULL, NULL, '2026-05-21 14:18:53', '2026-05-21 14:18:53'),
(18, 3, NULL, 1, 'adjustment_out', 10.000, 2.5000, 25.00, 10.000, 2.5000, NULL, NULL, NULL, '2026-05-21 14:19:03', '2026-05-21 14:19:03'),
(19, 10, 10, 1, 'purchase', 10.000, 0.8100, 8.10, 10.000, 0.8100, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 18, 'Recebimento lote: LOT-4K6Q9DVE', '2026-05-21 14:49:38', '2026-05-21 14:49:38'),
(20, 11, 11, 1, 'purchase', 10.000, 0.8100, 8.10, 10.000, 0.8100, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 18, 'Recebimento lote: LOT-X2EHABT7', '2026-05-21 14:49:38', '2026-05-21 14:49:38'),
(21, 12, 12, 1, 'purchase', 12.000, 0.8300, 9.96, 12.000, 0.8300, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 18, 'Recebimento lote: LOT-SUPJXRGL', '2026-05-21 14:49:38', '2026-05-21 14:49:38'),
(22, 14, 13, 1, 'purchase', 37.000, 1.1300, 41.81, 37.000, 1.1300, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 18, 'Recebimento lote: LOT-7X4JV413', '2026-05-21 14:49:38', '2026-05-21 14:49:38'),
(23, 13, 14, 1, 'purchase', 37.000, 1.2000, 44.40, 37.000, 1.2000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 18, 'Recebimento lote: LOT-YTVSTGFF', '2026-05-21 14:49:38', '2026-05-21 14:49:38'),
(24, 15, 15, 1, 'purchase', 12.000, 0.8300, 9.96, 12.000, 0.8300, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 18, 'Recebimento lote: LOT-LCURMTD4', '2026-05-21 14:49:38', '2026-05-21 14:49:38'),
(25, 16, 16, 1, 'purchase', 10.000, 0.6400, 6.40, 10.000, 0.6400, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 18, 'Recebimento lote: LOT-CTKZU2KQ', '2026-05-21 14:49:38', '2026-05-21 14:49:38'),
(26, 17, 17, 1, 'purchase', 10.000, 0.6400, 6.40, 10.000, 0.6400, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 18, 'Recebimento lote: LOT-9RHLVRX4', '2026-05-21 14:49:38', '2026-05-21 14:49:38'),
(27, 18, 18, 1, 'purchase', 4.000, 25.7500, 103.00, 4.000, 25.7500, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 18, 'Recebimento lote: LOT-QEOOQWRH', '2026-05-21 14:49:38', '2026-05-21 14:49:38'),
(28, 19, 19, 1, 'purchase', 1.000, 63.0000, 63.00, 1.000, 63.0000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 20, 'Recebimento lote: LOT-EI01AYJU', '2026-05-21 15:17:25', '2026-05-21 15:17:25'),
(29, 20, 20, 1, 'purchase', 1.000, 32.5000, 32.50, 1.000, 32.5000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 20, 'Recebimento lote: LOT-IXB25UET', '2026-05-21 15:17:25', '2026-05-21 15:17:25'),
(30, 21, 21, 1, 'purchase', 30.000, 1.3400, 40.20, 30.000, 1.3400, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 20, 'Recebimento lote: LOT-T4PDEGJO', '2026-05-21 15:17:25', '2026-05-21 15:17:25'),
(31, 22, 22, 1, 'purchase', 30.000, 1.3400, 40.20, 30.000, 1.3400, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 20, 'Recebimento lote: LOT-GIKPZLWK', '2026-05-21 15:17:25', '2026-05-21 15:17:25'),
(32, 23, 23, 1, 'purchase', 30.000, 1.3400, 40.20, 30.000, 1.3400, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 20, 'Recebimento lote: LOT-3EDYR9OD', '2026-05-21 15:17:25', '2026-05-21 15:17:25'),
(33, 24, 24, 1, 'purchase', 30.000, 1.3400, 40.20, 30.000, 1.3400, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 20, 'Recebimento lote: LOT-M08PKH6R', '2026-05-21 15:17:25', '2026-05-21 15:17:25'),
(34, 25, 25, 1, 'purchase', 30.000, 1.7400, 52.20, 30.000, 1.7400, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 20, 'Recebimento lote: LOT-RQLLHQMB', '2026-05-21 15:17:25', '2026-05-21 15:17:25'),
(35, 26, 26, 1, 'purchase', 100.000, 0.2000, 20.00, 100.000, 0.2000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 20, 'Recebimento lote: LOT-F4APM5OS', '2026-05-21 15:17:25', '2026-05-21 15:17:25'),
(36, 27, 27, 1, 'purchase', 100.000, 0.2300, 23.00, 100.000, 0.2300, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 20, 'Recebimento lote: LOT-GWGXM31C', '2026-05-21 15:17:25', '2026-05-21 15:17:25'),
(37, 28, 28, 1, 'purchase', 100.000, 0.2800, 28.00, 100.000, 0.2800, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 20, 'Recebimento lote: LOT-PRHH0LEI', '2026-05-21 15:17:25', '2026-05-21 15:17:25'),
(38, 29, 29, 1, 'purchase', 50.000, 0.1500, 7.50, 50.000, 0.1500, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 21, 'Recebimento lote: LOT-TUEYXJ9X', '2026-05-21 16:55:01', '2026-05-21 16:55:01'),
(39, 30, 30, 1, 'purchase', 50.000, 0.1500, 7.50, 50.000, 0.1500, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 21, 'Recebimento lote: LOT-KML0JKUP', '2026-05-21 16:55:01', '2026-05-21 16:55:01'),
(40, 31, 31, 1, 'purchase', 1.000, 7.3000, 7.30, 1.000, 7.3000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 21, 'Recebimento lote: LOT-7Z6BI7HV', '2026-05-21 16:55:01', '2026-05-21 16:55:01'),
(41, 32, 32, 1, 'purchase', 5.000, 1.1500, 5.75, 5.000, 1.1500, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 21, 'Recebimento lote: LOT-QEIOFBFO', '2026-05-21 16:55:01', '2026-05-21 16:55:01'),
(42, 33, 33, 1, 'purchase', 3.000, 1.4900, 4.47, 3.000, 1.4900, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 21, 'Recebimento lote: LOT-WF245RWX', '2026-05-21 16:55:01', '2026-05-21 16:55:01'),
(43, 34, 34, 1, 'purchase', 5.000, 0.9500, 4.75, 5.000, 0.9500, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 21, 'Recebimento lote: LOT-JKGKJM5E', '2026-05-21 16:55:01', '2026-05-21 16:55:01'),
(44, 35, 35, 1, 'purchase', 3.000, 0.6000, 1.80, 3.000, 0.6000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 21, 'Recebimento lote: LOT-ARE77TFP', '2026-05-21 16:55:01', '2026-05-21 16:55:01'),
(45, 36, 36, 1, 'purchase', 7.000, 1.6500, 11.55, 7.000, 1.6500, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 21, 'Recebimento lote: LOT-OWPKALPA', '2026-05-21 16:55:01', '2026-05-21 16:55:01'),
(46, 37, 37, 1, 'purchase', 20.000, 1.1000, 22.00, 20.000, 1.1000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 22, 'Recebimento lote: LOT-NBAGBNCE', '2026-05-23 03:55:48', '2026-05-23 03:55:48'),
(47, 38, 38, 1, 'purchase', 10.000, 1.7300, 17.30, 10.000, 1.7300, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 22, 'Recebimento lote: LOT-290IK6ZI', '2026-05-23 03:55:48', '2026-05-23 03:55:48'),
(48, 39, 39, 1, 'purchase', 10.000, 1.4000, 14.00, 10.000, 1.4000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 22, 'Recebimento lote: LOT-09ROKUCB', '2026-05-23 03:55:48', '2026-05-23 03:55:48'),
(49, 40, 40, 1, 'purchase', 10.000, 0.5400, 5.40, 10.000, 0.5400, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 23, 'Recebimento lote: LOT-PWHMKNFA', '2026-05-23 04:11:19', '2026-05-23 04:11:19'),
(50, 41, 41, 1, 'purchase', 20.000, 0.5500, 11.00, 20.000, 0.5500, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 23, 'Recebimento lote: LOT-AJI5SRA0', '2026-05-23 04:11:19', '2026-05-23 04:11:19'),
(51, 42, 42, 1, 'purchase', 10.000, 0.5900, 5.90, 10.000, 0.5900, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 23, 'Recebimento lote: LOT-0TUAVJXW', '2026-05-23 04:11:19', '2026-05-23 04:11:19'),
(52, 43, 43, 1, 'purchase', 20.000, 0.5600, 11.20, 20.000, 0.5600, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 23, 'Recebimento lote: LOT-1UI7AS1U', '2026-05-23 04:11:19', '2026-05-23 04:11:19'),
(53, 44, 44, 1, 'purchase', 100.000, 0.1900, 19.00, 100.000, 0.1900, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 23, 'Recebimento lote: LOT-ADEUZT8P', '2026-05-23 04:11:20', '2026-05-23 04:11:20'),
(54, 45, 45, 1, 'purchase', 50.000, 0.2800, 14.00, 50.000, 0.2800, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 23, 'Recebimento lote: LOT-XU2VSJRS', '2026-05-23 04:11:20', '2026-05-23 04:11:20'),
(55, 46, 46, 1, 'purchase', 60.000, 0.1300, 7.80, 60.000, 0.1300, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 23, 'Recebimento lote: LOT-AHTFSZS6', '2026-05-23 04:11:20', '2026-05-23 04:11:20'),
(56, 47, 47, 1, 'purchase', 20.000, 0.2800, 5.60, 20.000, 0.2800, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 23, 'Recebimento lote: LOT-0BDV6FFX', '2026-05-23 04:11:20', '2026-05-23 04:11:20'),
(57, 48, 48, 1, 'purchase', 20.000, 0.1600, 3.20, 20.000, 0.1600, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 23, 'Recebimento lote: LOT-XHV4PJCC', '2026-05-23 04:11:20', '2026-05-23 04:11:20'),
(58, 49, 49, 1, 'purchase', 5.000, 0.1500, 0.75, 5.000, 0.1500, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 23, 'Recebimento lote: LOT-M8LWOESO', '2026-05-23 04:11:20', '2026-05-23 04:11:20'),
(59, 50, 50, 1, 'purchase', 10.000, 0.6000, 6.00, 10.000, 0.6000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 23, 'Recebimento lote: LOT-BPMWFNMH', '2026-05-23 04:11:20', '2026-05-23 04:11:20'),
(60, 51, 51, 1, 'purchase', 50.000, 1.2400, 62.00, 50.000, 1.2400, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 23, 'Recebimento lote: LOT-ODH0XMNJ', '2026-05-23 04:11:20', '2026-05-23 04:11:20'),
(61, 52, 52, 1, 'purchase', 2.000, 25.9900, 51.98, 2.000, 25.9900, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 23, 'Recebimento lote: LOT-3QALVHEI', '2026-05-23 04:11:20', '2026-05-23 04:11:20'),
(62, 53, 53, 1, 'purchase', 2.000, 2.7000, 5.40, 2.000, 2.7000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 23, 'Recebimento lote: LOT-314EJOLA', '2026-05-23 04:11:20', '2026-05-23 04:11:20'),
(63, 6, 54, 1, 'purchase', 400.000, 0.2800, 112.00, 500.000, 0.2800, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 24, 'Recebimento lote: LOT-SLHY5AJB', '2026-05-23 04:25:44', '2026-05-23 04:25:44'),
(64, 54, 55, 1, 'purchase', 100.000, 0.4000, 40.00, 100.000, 0.4000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 24, 'Recebimento lote: LOT-7TTGPNMX', '2026-05-23 04:25:44', '2026-05-23 04:25:44'),
(65, 55, 56, 1, 'purchase', 50.000, 0.9000, 45.00, 50.000, 0.9000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 24, 'Recebimento lote: LOT-IVUYHLWS', '2026-05-23 04:25:44', '2026-05-23 04:25:44'),
(66, 56, 57, 1, 'purchase', 50.000, 0.9000, 45.00, 50.000, 0.9000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 24, 'Recebimento lote: LOT-W4XBLH08', '2026-05-23 04:25:44', '2026-05-23 04:25:44'),
(67, 57, 58, 1, 'purchase', 50.000, 0.9000, 45.00, 50.000, 0.9000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 24, 'Recebimento lote: LOT-NMDGEGGF', '2026-05-23 04:25:44', '2026-05-23 04:25:44'),
(68, 58, 59, 1, 'purchase', 2.000, 18.0000, 36.00, 2.000, 18.0000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 24, 'Recebimento lote: LOT-2D6BWJDO', '2026-05-23 04:25:44', '2026-05-23 04:25:44'),
(69, 59, 60, 1, 'purchase', 10.000, 2.6500, 26.50, 10.000, 2.6500, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 24, 'Recebimento lote: LOT-UC1MWDOL', '2026-05-23 04:25:44', '2026-05-23 04:25:44'),
(70, 60, 61, 1, 'purchase', 10.000, 1.6500, 16.50, 10.000, 1.6500, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 24, 'Recebimento lote: LOT-6XP7BDTW', '2026-05-23 04:25:44', '2026-05-23 04:25:44'),
(71, 61, 62, 1, 'purchase', 1.000, 18.0000, 18.00, 1.000, 18.0000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 24, 'Recebimento lote: LOT-ZFU97X2R', '2026-05-23 04:25:44', '2026-05-23 04:25:44'),
(72, 62, 63, 1, 'purchase', 10.000, 3.8500, 38.50, 10.000, 3.8500, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 24, 'Recebimento lote: LOT-AC4NTJWE', '2026-05-23 04:25:44', '2026-05-23 04:25:44'),
(73, 63, 64, 1, 'purchase', 1.000, 2.0000, 2.00, 1.000, 2.0000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 25, 'Recebimento lote: LOT-0Y8FQU40', '2026-05-23 04:46:37', '2026-05-23 04:46:37'),
(74, 64, 65, 1, 'purchase', 1.000, 3.0000, 3.00, 1.000, 3.0000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 25, 'Recebimento lote: LOT-QZXMUPRC', '2026-05-23 04:46:37', '2026-05-23 04:46:37'),
(75, 65, 66, 1, 'purchase', 100.000, 0.1800, 18.00, 100.000, 0.1800, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 25, 'Recebimento lote: LOT-FASU1BQY', '2026-05-23 04:46:37', '2026-05-23 04:46:37'),
(76, 66, 67, 1, 'purchase', 100.000, 0.2000, 20.00, 100.000, 0.2000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 25, 'Recebimento lote: LOT-TUFWL8MA', '2026-05-23 04:46:37', '2026-05-23 04:46:37'),
(77, 67, 68, 1, 'purchase', 100.000, 0.1800, 18.00, 100.000, 0.1800, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 25, 'Recebimento lote: LOT-HRRN9GEG', '2026-05-23 04:46:37', '2026-05-23 04:46:37'),
(78, 68, 69, 1, 'purchase', 200.000, 0.1000, 20.00, 200.000, 0.1000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 25, 'Recebimento lote: LOT-IQKR54UW', '2026-05-23 04:46:37', '2026-05-23 04:46:37'),
(79, 6, NULL, 1, 'adjustment_out', 100.000, 0.2800, 28.00, 400.000, 0.2800, NULL, NULL, 'Já utilizado em produção', '2026-05-23 04:59:53', '2026-05-23 04:59:53'),
(80, 18, 70, 1, 'purchase', 2.000, 27.4900, 54.98, 6.000, 26.3300, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 28, 'Recebimento lote: LOT-MCDL4HHJ', '2026-05-23 05:40:42', '2026-05-23 05:40:42'),
(81, 69, 71, 1, 'purchase', 100.000, 0.2000, 20.00, 100.000, 0.2000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 28, 'Recebimento lote: LOT-DPEJKBME', '2026-05-23 05:40:42', '2026-05-23 05:40:42'),
(82, 70, 72, 1, 'purchase', 100.000, 0.1900, 19.00, 100.000, 0.1900, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 28, 'Recebimento lote: LOT-FC0T4WOV', '2026-05-23 05:40:42', '2026-05-23 05:40:42'),
(83, 71, 73, 1, 'purchase', 100.000, 0.1900, 19.00, 100.000, 0.1900, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 28, 'Recebimento lote: LOT-M9Y9BH5A', '2026-05-23 05:40:42', '2026-05-23 05:40:42'),
(84, 72, 74, 1, 'purchase', 100.000, 0.1900, 19.00, 100.000, 0.1900, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 28, 'Recebimento lote: LOT-29EWWGLV', '2026-05-23 05:40:42', '2026-05-23 05:40:42'),
(85, 75, 75, 1, 'purchase', 50.000, 0.6000, 30.00, 50.000, 0.6000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 28, 'Recebimento lote: LOT-TJM4O8CN', '2026-05-23 05:40:42', '2026-05-23 05:40:42'),
(86, 78, 76, 1, 'purchase', 50.000, 0.6500, 32.50, 50.000, 0.6500, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 28, 'Recebimento lote: LOT-UIWUWPJU', '2026-05-23 05:40:42', '2026-05-23 05:40:42'),
(87, 73, 77, 1, 'purchase', 100.000, 0.1900, 19.00, 100.000, 0.1900, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 28, 'Recebimento lote: LOT-WWSS0OFW', '2026-05-23 05:40:43', '2026-05-23 05:40:43'),
(88, 74, 78, 1, 'purchase', 1.000, 14.9900, 14.99, 1.000, 14.9900, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 28, 'Recebimento lote: LOT-FOLQFU70', '2026-05-23 05:40:43', '2026-05-23 05:40:43'),
(89, 31, 79, 1, 'purchase', 2.000, 8.9900, 17.98, 3.000, 8.4267, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 28, 'Recebimento lote: LOT-U54B7JW4', '2026-05-23 05:40:43', '2026-05-23 05:40:43'),
(90, 27, 80, 1, 'purchase', 100.000, 0.1900, 19.00, 200.000, 0.2100, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 28, 'Recebimento lote: LOT-9GNVLV31', '2026-05-23 05:40:43', '2026-05-23 05:40:43'),
(91, 76, 81, 1, 'purchase', 100.000, 0.1900, 19.00, 100.000, 0.1900, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 28, 'Recebimento lote: LOT-PPVSFPMM', '2026-05-23 05:40:43', '2026-05-23 05:40:43'),
(92, 77, 82, 1, 'purchase', 50.000, 0.4500, 22.50, 50.000, 0.4500, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 28, 'Recebimento lote: LOT-CSCFDMC6', '2026-05-23 05:40:43', '2026-05-23 05:40:43'),
(93, 56, NULL, 1, 'consumed', 25.000, 0.9000, 22.50, 25.000, 0.9000, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 1, 'OP: OP-2026-0001', '2026-05-26 17:43:21', '2026-05-26 17:43:21'),
(94, 58, NULL, 1, 'consumed', 0.500, 18.0000, 9.00, 1.500, 18.0000, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 1, 'OP: OP-2026-0001', '2026-05-26 17:43:21', '2026-05-26 17:43:21'),
(95, 59, NULL, 1, 'consumed', 2.000, 2.6500, 5.30, 8.000, 2.6500, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 1, 'OP: OP-2026-0001', '2026-05-26 17:43:21', '2026-05-26 17:43:21'),
(96, 60, NULL, 1, 'consumed', 2.000, 1.6500, 3.30, 8.000, 1.6500, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 1, 'OP: OP-2026-0001', '2026-05-26 17:43:21', '2026-05-26 17:43:21'),
(97, 54, NULL, 1, 'consumed', 25.000, 0.4000, 10.00, 75.000, 0.4000, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 2, 'OP: OP-2026-0002', '2026-05-26 18:05:17', '2026-05-26 18:05:17'),
(98, 58, NULL, 1, 'consumed', 0.500, 18.0000, 9.00, 1.000, 18.0000, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 2, 'OP: OP-2026-0002', '2026-05-26 18:05:17', '2026-05-26 18:05:17'),
(99, 59, NULL, 1, 'consumed', 2.000, 2.6500, 5.30, 6.000, 2.6500, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 2, 'OP: OP-2026-0002', '2026-05-26 18:05:17', '2026-05-26 18:05:17'),
(100, 60, NULL, 1, 'consumed', 2.000, 1.6500, 3.30, 6.000, 1.6500, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 2, 'OP: OP-2026-0002', '2026-05-26 18:05:17', '2026-05-26 18:05:17'),
(101, 58, NULL, 1, 'consumed', 0.500, 18.0000, 9.00, 0.500, 18.0000, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 3, 'OP: OP-2026-0003', '2026-05-26 19:46:50', '2026-05-26 19:46:50'),
(102, 59, NULL, 1, 'consumed', 2.000, 2.6500, 5.30, 4.000, 2.6500, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 3, 'OP: OP-2026-0003', '2026-05-26 19:46:50', '2026-05-26 19:46:50'),
(103, 60, NULL, 1, 'consumed', 2.000, 1.6500, 3.30, 4.000, 1.6500, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 3, 'OP: OP-2026-0003', '2026-05-26 19:46:50', '2026-05-26 19:46:50'),
(104, 78, NULL, 1, 'consumed', 25.000, 0.6500, 16.25, 25.000, 0.6500, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 3, 'OP: OP-2026-0003', '2026-05-26 19:46:50', '2026-05-26 19:46:50'),
(105, 56, NULL, 1, 'consumed', 25.000, 0.9000, 22.50, 0.000, 0.9000, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 4, 'OP: OP-2026-0004', '2026-05-26 19:47:12', '2026-05-26 19:47:12'),
(106, 58, NULL, 1, 'consumed', 0.500, 18.0000, 9.00, 0.000, 18.0000, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 4, 'OP: OP-2026-0004', '2026-05-26 19:47:12', '2026-05-26 19:47:12'),
(107, 59, NULL, 1, 'consumed', 2.000, 2.6500, 5.30, 2.000, 2.6500, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 4, 'OP: OP-2026-0004', '2026-05-26 19:47:12', '2026-05-26 19:47:12'),
(108, 60, NULL, 1, 'consumed', 2.000, 1.6500, 3.30, 2.000, 1.6500, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 4, 'OP: OP-2026-0004', '2026-05-26 19:47:12', '2026-05-26 19:47:12'),
(109, 59, 83, 30, 'purchase', 30.000, 2.6500, 79.50, 32.000, 2.6500, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 29, 'Recebimento lote: LOT-QZQNM6CG', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(110, 79, 84, 30, 'purchase', 30.000, 1.6500, 49.50, 30.000, 1.6500, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 29, 'Recebimento lote: LOT-4VOZP41I', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(111, 60, 85, 30, 'purchase', 60.000, 1.6500, 99.00, 62.000, 1.6500, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 29, 'Recebimento lote: LOT-CCXPUFZ0', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(112, 56, 86, 30, 'purchase', 100.000, 0.9000, 90.00, 100.000, 0.9000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 29, 'Recebimento lote: LOT-T1FIB1JK', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(113, 4, 87, 30, 'purchase', 100.000, 0.2600, 26.00, 200.000, 0.2600, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 29, 'Recebimento lote: LOT-8ZCU6G0T', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(114, 5, 88, 30, 'purchase', 100.000, 0.2400, 24.00, 200.000, 0.2400, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 29, 'Recebimento lote: LOT-JDGKHGQE', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(115, 7, 89, 30, 'purchase', 100.000, 0.2500, 25.00, 200.000, 0.2498, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 29, 'Recebimento lote: LOT-X2S9Z6NZ', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(116, 54, 90, 30, 'purchase', 100.000, 0.4000, 40.00, 175.000, 0.4000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 29, 'Recebimento lote: LOT-QRBKPYMT', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(117, 80, 91, 30, 'purchase', 50.000, 0.9000, 45.00, 50.000, 0.9000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 29, 'Recebimento lote: LOT-QCBRILO7', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(118, 81, 92, 30, 'purchase', 50.000, 0.9000, 45.00, 50.000, 0.9000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 29, 'Recebimento lote: LOT-YXVLAGXR', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(119, 58, 93, 30, 'purchase', 8.000, 18.0000, 144.00, 8.000, 18.0000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 29, 'Recebimento lote: LOT-B87M6AG1', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(120, 82, 94, 30, 'purchase', 2.000, 16.0000, 32.00, 2.000, 16.0000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 29, 'Recebimento lote: LOT-DSAZ3IA7', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(121, 61, 95, 30, 'purchase', 2.000, 18.0000, 36.00, 3.000, 18.0000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 29, 'Recebimento lote: LOT-BLJOUUKN', '2026-06-03 18:01:49', '2026-06-03 18:01:49'),
(122, 37, 96, 30, 'purchase', 126.000, 1.1000, 138.60, 146.000, 1.1000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 30, 'Recebimento lote: LOT-IXQOXK0T', '2026-06-03 18:05:23', '2026-06-03 18:05:23'),
(123, 38, 97, 30, 'purchase', 63.000, 1.7300, 108.99, 73.000, 1.7300, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 30, 'Recebimento lote: LOT-IF0WLISZ', '2026-06-03 18:05:23', '2026-06-03 18:05:23'),
(124, 39, 98, 30, 'purchase', 63.000, 1.4000, 88.20, 73.000, 1.4000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 30, 'Recebimento lote: LOT-HCT2N2SQ', '2026-06-03 18:05:23', '2026-06-03 18:05:23'),
(125, 83, 99, 30, 'purchase', 100.000, 0.4200, 42.00, 100.000, 0.4200, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 30, 'Recebimento lote: LOT-JWIDIDTG', '2026-06-03 18:05:23', '2026-06-03 18:05:23'),
(126, 78, 100, 30, 'purchase', 50.000, 0.6500, 32.50, 75.000, 0.6500, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 32, 'Recebimento lote: LOT-APFLTY4A', '2026-06-03 18:09:35', '2026-06-03 18:09:35'),
(127, 75, 101, 30, 'purchase', 50.000, 0.6000, 30.00, 100.000, 0.6000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 32, 'Recebimento lote: LOT-DGLRZ90N', '2026-06-03 18:09:35', '2026-06-03 18:09:35'),
(128, 84, 102, 30, 'purchase', 4.000, 3.9900, 15.96, 4.000, 3.9900, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 35, 'Recebimento lote: LOT-F3FX45LK', '2026-06-03 19:41:05', '2026-06-03 19:41:05'),
(129, 85, 103, 30, 'purchase', 13.000, 6.4500, 83.85, 13.000, 6.4500, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 35, 'Recebimento lote: LOT-APE8BOEG', '2026-06-03 19:41:05', '2026-06-03 19:41:05'),
(130, 86, 104, 30, 'purchase', 2.000, 14.9800, 29.96, 2.000, 14.9800, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 35, 'Recebimento lote: LOT-DPRL2XIW', '2026-06-03 19:41:05', '2026-06-03 19:41:05'),
(131, 18, 105, 30, 'purchase', 2.000, 24.3500, 48.70, 8.000, 25.8350, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 35, 'Recebimento lote: LOT-YTWJU6WW', '2026-06-03 19:41:05', '2026-06-03 19:41:05'),
(132, 61, 106, 30, 'purchase', 4.000, 14.7000, 58.80, 7.000, 16.1143, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 35, 'Recebimento lote: LOT-YKHZOLKN', '2026-06-03 19:41:05', '2026-06-03 19:41:05'),
(133, 87, 107, 30, 'purchase', 1.000, 24.0000, 24.00, 1.000, 24.0000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 42, 'Recebimento lote: LOT-AHRKZVPQ', '2026-06-03 20:06:22', '2026-06-03 20:06:22'),
(134, 88, 108, 30, 'purchase', 8.000, 5.5000, 44.00, 8.000, 5.5000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 42, 'Recebimento lote: LOT-FPCWVL9X', '2026-06-03 20:06:22', '2026-06-03 20:06:22'),
(135, 89, 109, 30, 'purchase', 2.000, 0.5500, 1.10, 2.000, 0.5500, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 42, 'Recebimento lote: LOT-K32GBMS1', '2026-06-03 20:06:22', '2026-06-03 20:06:22'),
(136, 90, 110, 30, 'purchase', 1.000, 24.0000, 24.00, 1.000, 24.0000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 42, 'Recebimento lote: LOT-2UIEQ9KG', '2026-06-03 20:06:22', '2026-06-03 20:06:22'),
(137, 91, 111, 30, 'purchase', 100.000, 0.0600, 6.00, 100.000, 0.0600, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 42, 'Recebimento lote: LOT-DFBTP6I1', '2026-06-03 20:06:22', '2026-06-03 20:06:22'),
(138, 92, 112, 30, 'purchase', 4.000, 18.8000, 75.20, 4.000, 18.8000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 42, 'Recebimento lote: LOT-EYWUUQVT', '2026-06-03 20:06:22', '2026-06-03 20:06:22'),
(139, 93, 113, 30, 'purchase', 30.000, 0.3000, 9.00, 30.000, 0.3000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 42, 'Recebimento lote: LOT-2WDVPCAI', '2026-06-03 20:06:22', '2026-06-03 20:06:22'),
(140, 94, 114, 30, 'purchase', 100.000, 0.2200, 22.00, 100.000, 0.2200, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 42, 'Recebimento lote: LOT-LPZJXR4R', '2026-06-03 20:06:22', '2026-06-03 20:06:22'),
(141, 95, 115, 30, 'purchase', 2.000, 3.5000, 7.00, 2.000, 3.5000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 42, 'Recebimento lote: LOT-TBYQOCRB', '2026-06-03 20:06:22', '2026-06-03 20:06:22'),
(142, 59, NULL, 30, 'consumed', 4.000, 2.6500, 10.60, 28.000, 2.6500, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 8, 'OP: OP-2026-0008', '2026-06-03 20:40:17', '2026-06-03 20:40:17'),
(143, 60, NULL, 30, 'consumed', 5.000, 1.6500, 8.25, 57.000, 1.6500, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 8, 'OP: OP-2026-0008', '2026-06-03 20:40:17', '2026-06-03 20:40:17'),
(144, 79, NULL, 30, 'consumed', 1.000, 1.6500, 1.65, 29.000, 1.6500, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 8, 'OP: OP-2026-0008', '2026-06-03 20:40:17', '2026-06-03 20:40:17'),
(145, 80, NULL, 30, 'consumed', 25.000, 0.9000, 22.50, 25.000, 0.9000, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 8, 'OP: OP-2026-0008', '2026-06-03 20:40:17', '2026-06-03 20:40:17'),
(146, 81, NULL, 30, 'consumed', 25.000, 0.9000, 22.50, 25.000, 0.9000, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 8, 'OP: OP-2026-0008', '2026-06-03 20:40:17', '2026-06-03 20:40:17'),
(147, 82, NULL, 30, 'consumed', 1.000, 16.0000, 16.00, 1.000, 16.0000, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 8, 'OP: OP-2026-0008', '2026-06-03 20:40:17', '2026-06-03 20:40:17'),
(148, 56, NULL, 30, 'consumed', 100.000, 0.9000, 90.00, 0.000, 0.9000, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 7, 'OP: OP-2026-0007', '2026-06-03 20:40:53', '2026-06-03 20:40:53'),
(149, 58, NULL, 30, 'consumed', 2.000, 18.0000, 36.00, 6.000, 18.0000, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 7, 'OP: OP-2026-0007', '2026-06-03 20:40:53', '2026-06-03 20:40:53'),
(150, 59, NULL, 30, 'consumed', 8.000, 2.6500, 21.20, 20.000, 2.6500, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 7, 'OP: OP-2026-0007', '2026-06-03 20:40:53', '2026-06-03 20:40:53'),
(151, 60, NULL, 30, 'consumed', 10.000, 1.6500, 16.50, 47.000, 1.6500, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 7, 'OP: OP-2026-0007', '2026-06-03 20:40:53', '2026-06-03 20:40:53'),
(152, 54, NULL, 30, 'consumed', 100.000, 0.4000, 40.00, 75.000, 0.4000, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 6, 'OP: OP-2026-0006', '2026-06-03 20:41:45', '2026-06-03 20:41:45'),
(153, 58, NULL, 30, 'consumed', 2.000, 18.0000, 36.00, 4.000, 18.0000, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 6, 'OP: OP-2026-0006', '2026-06-03 20:41:45', '2026-06-03 20:41:45'),
(154, 59, NULL, 30, 'consumed', 8.000, 2.6500, 21.20, 12.000, 2.6500, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 6, 'OP: OP-2026-0006', '2026-06-03 20:41:45', '2026-06-03 20:41:45'),
(155, 60, NULL, 30, 'consumed', 10.000, 1.6500, 16.50, 37.000, 1.6500, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 6, 'OP: OP-2026-0006', '2026-06-03 20:41:45', '2026-06-03 20:41:45'),
(156, 79, NULL, 30, 'consumed', 2.000, 1.6500, 3.30, 27.000, 1.6500, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 6, 'OP: OP-2026-0006', '2026-06-03 20:41:45', '2026-06-03 20:41:45'),
(157, 58, NULL, 30, 'consumed', 1.000, 18.0000, 18.00, 3.000, 18.0000, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 5, 'OP: OP-2026-0005', '2026-06-03 20:42:06', '2026-06-03 20:42:06'),
(158, 59, NULL, 30, 'consumed', 4.000, 2.6500, 10.60, 8.000, 2.6500, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 5, 'OP: OP-2026-0005', '2026-06-03 20:42:06', '2026-06-03 20:42:06'),
(159, 60, NULL, 30, 'consumed', 5.000, 1.6500, 8.25, 32.000, 1.6500, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 5, 'OP: OP-2026-0005', '2026-06-03 20:42:06', '2026-06-03 20:42:06'),
(160, 78, NULL, 30, 'consumed', 50.000, 0.6500, 32.50, 25.000, 0.6500, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 5, 'OP: OP-2026-0005', '2026-06-03 20:42:06', '2026-06-03 20:42:06'),
(161, 79, NULL, 30, 'consumed', 1.000, 1.6500, 1.65, 26.000, 1.6500, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 5, 'OP: OP-2026-0005', '2026-06-03 20:42:06', '2026-06-03 20:42:06'),
(162, 19, 116, 30, 'purchase', 1.000, 63.0000, 63.00, 2.000, 63.0000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 43, 'Recebimento lote: LOT-5KVKBDDS', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(163, 112, 117, 30, 'purchase', 1.000, 19.0000, 19.00, 1.000, 19.0000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 43, 'Recebimento lote: LOT-SY0VPZII', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(164, 113, 118, 30, 'purchase', 1.000, 33.0000, 33.00, 1.000, 33.0000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 43, 'Recebimento lote: LOT-8JYNHQZO', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(165, 114, 119, 30, 'purchase', 100.000, 0.0500, 5.00, 100.000, 0.0500, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 43, 'Recebimento lote: LOT-3BMV0XGH', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(166, 115, 120, 30, 'purchase', 100.000, 0.0500, 5.00, 100.000, 0.0500, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 43, 'Recebimento lote: LOT-8ZPZMDLC', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(167, 116, 121, 30, 'purchase', 1.000, 0.0300, 0.03, 1.000, 0.0300, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 43, 'Recebimento lote: LOT-F9LOSFJ1', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(168, 117, 122, 30, 'purchase', 60.000, 0.9700, 58.20, 60.000, 0.9700, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 43, 'Recebimento lote: LOT-QGSV0TL0', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(169, 24, 123, 30, 'purchase', 60.000, 0.9700, 58.20, 90.000, 1.0933, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 43, 'Recebimento lote: LOT-WCFNX0U0', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(170, 118, 124, 30, 'purchase', 100.000, 0.0700, 7.00, 100.000, 0.0700, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 43, 'Recebimento lote: LOT-GRRVAGH0', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(171, 119, 125, 30, 'purchase', 400.000, 0.1500, 60.00, 400.000, 0.1500, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 43, 'Recebimento lote: LOT-NYW8J9AZ', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(172, 120, 126, 30, 'purchase', 2.000, 1.5000, 3.00, 2.000, 1.5000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 43, 'Recebimento lote: LOT-J1A5T8EA', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(173, 121, 127, 30, 'purchase', 2.000, 1.5000, 3.00, 2.000, 1.5000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 43, 'Recebimento lote: LOT-A9V3FFA9', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(174, 122, 128, 30, 'purchase', 2.000, 4.6000, 9.20, 2.000, 4.6000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 43, 'Recebimento lote: LOT-9WWUQUNO', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(175, 123, 129, 30, 'purchase', 2.000, 4.9000, 9.80, 2.000, 4.9000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 43, 'Recebimento lote: LOT-QXAXNRBV', '2026-06-08 21:03:43', '2026-06-08 21:03:43'),
(176, 96, 130, 30, 'purchase', 1000.000, 0.0300, 30.00, 1000.000, 0.0300, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 44, 'Recebimento lote: LOT-BFTUAI8V', '2026-06-08 21:04:07', '2026-06-08 21:04:07'),
(177, 108, NULL, 30, 'adjustment_in', 1000.000, 0.0300, 30.00, 1000.000, 0.0300, NULL, NULL, NULL, '2026-06-08 22:27:04', '2026-06-08 22:27:04'),
(178, 97, NULL, 30, 'adjustment_in', 1000.000, 0.0300, 30.00, 1000.000, 0.0300, NULL, NULL, NULL, '2026-06-08 22:27:21', '2026-06-08 22:27:21'),
(179, 109, NULL, 30, 'adjustment_in', 1000.000, 0.0300, 30.00, 1000.000, 0.0300, NULL, NULL, NULL, '2026-06-08 22:27:33', '2026-06-08 22:27:33'),
(180, 98, NULL, 30, 'adjustment_in', 1000.000, 0.0300, 30.00, 1000.000, 0.0300, NULL, NULL, NULL, '2026-06-08 22:27:46', '2026-06-08 22:27:46'),
(181, 103, NULL, 30, 'adjustment_in', 100.000, 0.2800, 28.00, 100.000, 0.2800, NULL, NULL, NULL, '2026-06-08 22:51:28', '2026-06-08 22:51:28'),
(182, 100, NULL, 30, 'adjustment_in', 100.000, 0.1300, 13.00, 100.000, 0.1300, NULL, NULL, NULL, '2026-06-08 22:52:30', '2026-06-08 22:52:30'),
(183, 99, NULL, 30, 'adjustment_in', 100.000, 0.1300, 13.00, 100.000, 0.1300, NULL, NULL, NULL, '2026-06-08 22:53:01', '2026-06-08 22:53:01'),
(184, 107, NULL, 30, 'adjustment_in', 100.000, 0.2400, 24.00, 100.000, 0.2400, NULL, NULL, NULL, '2026-06-08 22:53:37', '2026-06-08 22:53:37'),
(185, 101, NULL, 30, 'adjustment_in', 100.000, 0.0700, 7.00, 100.000, 0.0700, NULL, NULL, NULL, '2026-06-08 22:54:03', '2026-06-08 22:54:03'),
(186, 106, NULL, 30, 'adjustment_in', 100.000, 0.8800, 88.00, 100.000, 0.8800, NULL, NULL, NULL, '2026-06-08 22:55:20', '2026-06-08 22:55:20'),
(187, 102, NULL, 30, 'adjustment_in', 100.000, 0.1600, 16.00, 100.000, 0.1600, NULL, NULL, NULL, '2026-06-08 22:55:59', '2026-06-08 22:55:59'),
(188, 104, NULL, 30, 'adjustment_in', 100.000, 0.0800, 8.00, 100.000, 0.0800, NULL, NULL, NULL, '2026-06-08 22:56:43', '2026-06-08 22:56:43'),
(189, 111, NULL, 30, 'adjustment_in', 100.000, 0.1300, 13.00, 100.000, 0.1300, NULL, NULL, NULL, '2026-06-08 22:57:21', '2026-06-08 22:57:21'),
(190, 105, NULL, 30, 'adjustment_in', 100.000, 0.5400, 54.00, 100.000, 0.5400, NULL, NULL, NULL, '2026-06-08 23:00:25', '2026-06-08 23:00:25'),
(191, 124, NULL, 30, 'adjustment_in', 100.000, 0.1000, 10.00, 100.000, 0.1000, NULL, NULL, NULL, '2026-06-09 14:27:42', '2026-06-09 14:27:42'),
(192, 125, NULL, 30, 'adjustment_in', 100.000, 0.3800, 38.00, 100.000, 0.3800, NULL, NULL, NULL, '2026-06-09 14:31:07', '2026-06-09 14:31:07'),
(193, 126, NULL, 30, 'adjustment_in', 100.000, 0.1200, 12.00, 100.000, 0.1200, NULL, NULL, NULL, '2026-06-09 14:33:54', '2026-06-09 14:33:54'),
(194, 127, NULL, 30, 'adjustment_in', 100.000, 0.6000, 60.00, 100.000, 0.6000, NULL, NULL, NULL, '2026-06-09 14:42:31', '2026-06-09 14:42:31'),
(195, 128, NULL, 30, 'adjustment_in', 33.000, 1.2000, 39.60, 33.000, 1.2000, NULL, NULL, NULL, '2026-06-09 14:47:09', '2026-06-09 14:47:09'),
(196, 57, NULL, 30, 'consumed', 4.000, 0.9000, 3.60, 46.000, 0.9000, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 9, 'OP: OP-2026-0009', '2026-06-09 15:42:10', '2026-06-09 15:42:10'),
(197, 97, NULL, 30, 'consumed', 40.000, 0.0300, 1.20, 960.000, 0.0300, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 9, 'OP: OP-2026-0009', '2026-06-09 15:42:10', '2026-06-09 15:42:10'),
(198, 102, NULL, 30, 'consumed', 20.000, 0.1600, 3.20, 80.000, 0.1600, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 9, 'OP: OP-2026-0009', '2026-06-09 15:42:10', '2026-06-09 15:42:10'),
(199, 105, NULL, 30, 'consumed', 8.000, 0.5400, 4.32, 92.000, 0.5400, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 9, 'OP: OP-2026-0009', '2026-06-09 15:42:10', '2026-06-09 15:42:10'),
(200, 113, NULL, 30, 'consumed', 1.000, 33.0000, 33.00, 0.000, 33.0000, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 9, 'OP: OP-2026-0009', '2026-06-09 15:42:10', '2026-06-09 15:42:10'),
(201, 124, NULL, 30, 'consumed', 20.000, 0.1000, 2.00, 80.000, 0.1000, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 9, 'OP: OP-2026-0009', '2026-06-09 15:42:10', '2026-06-09 15:42:10'),
(202, 125, NULL, 30, 'consumed', 48.000, 0.3800, 18.24, 52.000, 0.3800, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 9, 'OP: OP-2026-0009', '2026-06-09 15:42:10', '2026-06-09 15:42:10'),
(203, 126, NULL, 30, 'consumed', 28.000, 0.1200, 3.36, 72.000, 0.1200, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 9, 'OP: OP-2026-0009', '2026-06-09 15:42:10', '2026-06-09 15:42:10'),
(204, 127, NULL, 30, 'consumed', 20.000, 0.6000, 12.00, 80.000, 0.6000, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 9, 'OP: OP-2026-0009', '2026-06-09 15:42:10', '2026-06-09 15:42:10'),
(205, 128, NULL, 30, 'consumed', 30.000, 1.2000, 36.00, 3.000, 1.2000, 'App\\Modules\\Inventory\\Models\\ProductionOrder', 9, 'OP: OP-2026-0009', '2026-06-09 15:42:10', '2026-06-09 15:42:10'),
(206, 129, NULL, 30, 'adjustment_in', 1000.000, 0.0300, 30.00, 1000.000, 0.0300, NULL, NULL, NULL, '2026-06-09 15:56:34', '2026-06-09 15:56:34'),
(207, 130, NULL, 30, 'adjustment_in', 1000.000, 0.0800, 80.00, 1000.000, 0.0800, NULL, NULL, NULL, '2026-06-09 15:59:01', '2026-06-09 15:59:01'),
(208, 58, 131, 30, 'purchase', 3.000, 20.0000, 60.00, 6.000, 19.0000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 46, 'Recebimento lote: LOT-5SXOEXWJ', '2026-06-09 20:30:13', '2026-06-09 20:30:13'),
(209, 82, 132, 30, 'purchase', 1.000, 18.0000, 18.00, 2.000, 17.0000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 46, 'Recebimento lote: LOT-8CHHYOIS', '2026-06-09 20:30:13', '2026-06-09 20:30:13'),
(210, 59, 133, 30, 'purchase', 30.000, 2.6500, 79.50, 38.000, 2.6500, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 46, 'Recebimento lote: LOT-YBAUJ16Y', '2026-06-09 20:30:13', '2026-06-09 20:30:13'),
(211, 60, 134, 30, 'purchase', 30.000, 1.6500, 49.50, 62.000, 1.6500, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 46, 'Recebimento lote: LOT-VREVQDXY', '2026-06-09 20:30:13', '2026-06-09 20:30:13'),
(212, 133, 135, 30, 'purchase', 12.000, 2.8000, 33.60, 12.000, 2.8000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 46, 'Recebimento lote: LOT-X3L0HJX4', '2026-06-09 20:30:13', '2026-06-09 20:30:13'),
(213, 54, 136, 30, 'purchase', 100.000, 0.4000, 40.00, 175.000, 0.4000, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 46, 'Recebimento lote: LOT-UJYTECJF', '2026-06-09 20:30:13', '2026-06-09 20:30:13'),
(214, 57, 137, 30, 'purchase', 100.000, 0.4500, 45.00, 146.000, 0.5918, 'App\\Modules\\SmartInventory\\Models\\SmartInputSession', 46, 'Recebimento lote: LOT-QD0YTTEH', '2026-06-09 20:30:13', '2026-06-09 20:30:13'),
(215, 132, NULL, 30, 'adjustment_in', 1000.000, 0.0300, 30.00, 1000.000, 0.0300, NULL, NULL, NULL, '2026-06-10 01:22:32', '2026-06-10 01:22:32'),
(216, 134, NULL, 30, 'adjustment_in', 33.000, 1.2000, 39.60, 33.000, 1.2000, NULL, NULL, NULL, '2026-06-10 01:24:43', '2026-06-10 01:24:43'),
(217, 110, NULL, 30, 'adjustment_in', 100.000, 0.2200, 22.00, 100.000, 0.2200, NULL, NULL, NULL, '2026-06-10 01:33:01', '2026-06-10 01:33:01'),
(218, 135, NULL, 30, 'adjustment_in', 1000.000, 0.0300, 30.00, 1000.000, 0.0300, NULL, NULL, NULL, '2026-06-10 01:59:06', '2026-06-10 01:59:06'),
(219, 138, NULL, 30, 'adjustment_in', 100.000, 0.3900, 39.00, 100.000, 0.3900, NULL, NULL, NULL, '2026-06-10 02:09:25', '2026-06-10 02:09:25'),
(220, 137, NULL, 30, 'adjustment_in', 100.000, 0.1600, 16.00, 100.000, 0.1600, NULL, NULL, NULL, '2026-06-10 02:10:02', '2026-06-10 02:10:02'),
(221, 136, NULL, 30, 'adjustment_in', 100.000, 0.1600, 16.00, 100.000, 0.1600, NULL, NULL, NULL, '2026-06-10 02:10:41', '2026-06-10 02:10:41'),
(222, 102, NULL, 30, 'adjustment_in', 20.000, 0.3900, 7.80, 100.000, 0.2060, NULL, NULL, NULL, '2026-06-10 02:11:26', '2026-06-10 02:11:26'),
(223, 102, NULL, 30, 'adjustment_out', 100.000, 0.2060, 20.60, 0.000, 0.2060, NULL, NULL, NULL, '2026-06-10 02:12:00', '2026-06-10 02:12:00'),
(224, 102, NULL, 30, 'adjustment_in', 100.000, 0.3900, 39.00, 100.000, 0.3900, NULL, NULL, NULL, '2026-06-10 02:12:19', '2026-06-10 02:12:19'),
(225, 139, NULL, 30, 'adjustment_in', 100.000, 0.0900, 9.00, 100.000, 0.0900, NULL, NULL, NULL, '2026-06-10 02:13:34', '2026-06-10 02:13:34'),
(226, 140, NULL, 30, 'adjustment_in', 500.000, 0.1900, 95.00, 500.000, 0.1900, NULL, NULL, NULL, '2026-06-10 02:58:16', '2026-06-10 02:58:16'),
(227, 142, NULL, 30, 'adjustment_in', 1000.000, 0.0300, 30.00, 1000.000, 0.0300, NULL, NULL, NULL, '2026-06-10 03:17:39', '2026-06-10 03:17:39'),
(228, 144, NULL, 30, 'adjustment_in', 1000.000, 0.0300, 30.00, 1000.000, 0.0300, NULL, NULL, NULL, '2026-06-10 03:17:56', '2026-06-10 03:17:56'),
(229, 141, NULL, 30, 'adjustment_in', 1000.000, 0.0300, 30.00, 1000.000, 0.0300, NULL, NULL, NULL, '2026-06-10 03:18:13', '2026-06-10 03:18:13'),
(230, 145, NULL, 30, 'adjustment_in', 1000.000, 0.0300, 30.00, 1000.000, 0.0300, NULL, NULL, NULL, '2026-06-10 03:18:29', '2026-06-10 03:18:29'),
(231, 146, NULL, 30, 'adjustment_in', 1000.000, 0.0300, 30.00, 1000.000, 0.0300, NULL, NULL, NULL, '2026-06-10 03:18:47', '2026-06-10 03:18:47'),
(232, 19, NULL, 30, 'adjustment_out', 2.000, 63.0000, 126.00, 0.000, 63.0000, NULL, NULL, NULL, '2026-06-10 03:21:18', '2026-06-10 03:21:18'),
(233, 19, NULL, 30, 'adjustment_in', 2000.000, 0.0700, 140.00, 2000.000, 0.0700, NULL, NULL, NULL, '2026-06-10 03:21:56', '2026-06-10 03:21:56'),
(234, 112, NULL, 30, 'adjustment_out', 1.000, 19.0000, 19.00, 0.000, 19.0000, NULL, NULL, NULL, '2026-06-10 03:22:07', '2026-06-10 03:22:07'),
(235, 112, NULL, 30, 'adjustment_in', 1000.000, 0.0200, 20.00, 1000.000, 0.0200, NULL, NULL, NULL, '2026-06-10 03:22:29', '2026-06-10 03:22:29'),
(236, 149, NULL, 30, 'adjustment_in', 100.000, 0.3400, 34.00, 100.000, 0.3400, NULL, NULL, NULL, '2026-06-10 03:42:52', '2026-06-10 03:42:52'),
(237, 150, NULL, 30, 'adjustment_in', 100.000, 0.1500, 15.00, 100.000, 0.1500, NULL, NULL, NULL, '2026-06-10 03:44:34', '2026-06-10 03:44:34'),
(238, 148, NULL, 30, 'adjustment_in', 100.000, 0.3400, 34.00, 100.000, 0.3400, NULL, NULL, NULL, '2026-06-10 03:47:34', '2026-06-10 03:47:34'),
(239, 147, NULL, 30, 'adjustment_in', 1000.000, 0.0400, 40.00, 1000.000, 0.0400, NULL, NULL, NULL, '2026-06-10 03:48:04', '2026-06-10 03:48:04'),
(240, 56, NULL, 30, 'adjustment_in', 50.000, 0.9000, 45.00, 50.000, 0.9000, NULL, NULL, NULL, '2026-06-10 03:48:57', '2026-06-10 03:48:57'),
(241, 151, NULL, 30, 'adjustment_in', 1000.000, 0.0400, 40.00, 1000.000, 0.0400, NULL, NULL, NULL, '2026-06-10 03:53:21', '2026-06-10 03:53:21');

-- --------------------------------------------------------

--
-- Table structure for table `recipes`
--

CREATE TABLE `recipes` (
  `id` bigint UNSIGNED NOT NULL,
  `product_id` bigint UNSIGNED DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `instructions` text COLLATE utf8mb4_unicode_ci,
  `yield_quantity` decimal(10,3) NOT NULL,
  `yield_unit` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `waste_percent` decimal(5,2) NOT NULL DEFAULT '0.00',
  `prep_time_minutes` int DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `recipes`
--

INSERT INTO `recipes` (`id`, `product_id`, `name`, `slug`, `description`, `instructions`, `yield_quantity`, `yield_unit`, `waste_percent`, `prep_time_minutes`, `is_active`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 44, 'BODY SPLASH - MARLY DELINA', 'body-splash-marly-delina', 'É uma colônia corporal com fragrância leve e refrescante', NULL, 5.000, 'un', 0.00, 45, 1, '2026-05-24 19:49:30', '2026-06-09 19:17:46', NULL),
(2, 45, 'BODY SPLASH - SCANDAL', 'body-splash-scandal', NULL, 'Adicionar a base do body splash em um backer\nAdicionar a Essência Scandal no backer\nMisturar bem com uma espatula\nDeixar descansar por uns 10 minutos\nEnvasar', 5.000, 'un', 0.00, 45, 1, '2026-05-26 17:53:25', '2026-06-09 19:17:08', NULL),
(8, 47, 'BODY SPLASH - GOOD GIRL', 'body-splash-good-girl', NULL, 'Adicionar a base body splash em um backer\nAdicionar a essência Good Girl\nmisturar bem com uma espatula\nDeixar descansar por 10 minutos\nEnvasar.', 5.000, 'un', 0.00, 45, 1, '2026-05-26 18:25:01', '2026-06-09 19:18:22', NULL),
(11, 46, 'BODY SPLASH ROYAL AMBAR', 'body-splash-royal-ambar', NULL, 'Adicione a base body splash em um backer\nAdicione a essência no backer\nMiture bem com uma espatula\nDeixe descançar por 10 minutos\nEnvasar', 5.000, 'un', 0.00, 45, 1, '2026-05-26 19:45:40', '2026-06-09 16:02:30', NULL),
(12, 49, 'BODY SPLASH - BOURBON INTESE', 'body-splash-bourbon-intese', NULL, 'Adicionar a base em um Backer\nAdicionar as essências e misturar bem\nDeixar descansar por 10 minutos\nEvazar todos os frascos.', 5.000, 'un', 0.00, NULL, 1, '2026-06-03 20:39:12', '2026-06-09 19:19:40', NULL),
(13, 43, 'CREME HIDRATANTE PARA OS PÉS', 'creme-hidratante-para-os-pes', NULL, NULL, 16.000, 'un', 0.00, 90, 1, '2026-06-04 01:27:23', '2026-06-09 16:01:43', NULL),
(14, 35, 'CREME HIDRATANTE PARA AS MÃOS', 'creme-hidratante-para-as-maos', NULL, NULL, 17.000, 'un', 0.00, NULL, 1, '2026-06-04 04:11:44', '2026-06-04 04:11:44', NULL),
(15, 53, 'CREME HIDRATANTE FACIAL DIURNO', 'creme-hidratante-facial-diurno', NULL, 'Em um backer adiciona a base de creme;\nEm outro backer junte a extrato de calêndula e o extrato de chá verde e adicione o óxido de zinco e misture até dissover completamente e estar homogenio;\nNessa mistura adicione a niacimida e misture bem até dissover completamente deixando uma base homogenea;\nAdiciona essa mistura pouco a pouco na base e misture até incorporar completamente;\nAdicione os óleos em outro backer e leve ao banho maria para aquecer levemente por uns 5 minutos;\nApós aquecer adicione os óleos junto da base e misture bem até estar homogeneo a base e os óleos;\nAdicione a essência e misture bem;\nApós todos os ingredientes unidos deixe descansar por uns 15 minutos;\nAdicione nos potes.', 30.000, 'un', 0.00, 90, 1, '2026-06-09 14:41:02', '2026-06-09 18:18:25', NULL),
(16, 41, 'LOÇÃO DE PANACEIA', 'locao-de-panaceia', NULL, NULL, 7.000, 'un', 0.00, NULL, 1, '2026-06-09 15:54:53', '2026-06-09 16:00:46', NULL),
(17, 36, 'CREME HIDRATANTE FACIAL NOTURNO', 'creme-hidratante-facial-noturno', NULL, NULL, 30.000, 'un', 0.00, 90, 1, '2026-06-10 01:21:28', '2026-06-10 01:26:20', NULL),
(21, 37, 'CREME HIDRATANTE CORPORAL - TOQUE DE ROSAS', 'creme-hidratante-corporal-toque-de-rosas', NULL, 'Em um backer adicionar a base e reservar;\nEm um outro backer adicionar todos os óleos e aquecer em banho maria por uns 3 minutos;\nAdicionar os óleos na base e misturar bem;\nEm outro backer adicionar todos os extratos e aquecer em banho maria por uns 3 minutos;\nAdicionar os extratos na base e misturar bem até obter um creme homogeneo;\nAdicionar as essências e misturar novamente até incorporar;\nDeixar descansar por aproximadamente 15 minutos;\nDepois disso encher os frascos.', 7.000, 'un', 0.00, 90, 1, '2026-06-10 02:55:46', '2026-06-10 02:55:46', NULL),
(22, 39, 'SABONETE ÍNTIMO', 'sabonete-intimo', NULL, NULL, 9.000, 'un', 0.00, 60, 1, '2026-06-10 03:17:15', '2026-06-10 03:24:49', NULL),
(23, 40, 'BIO ÁLIVIO 21', 'bio-alivio-21', NULL, NULL, 6.000, 'un', 0.00, 90, 1, '2026-06-10 03:40:28', '2026-06-10 03:40:28', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `recipe_ingredients`
--

CREATE TABLE `recipe_ingredients` (
  `id` bigint UNSIGNED NOT NULL,
  `recipe_id` bigint UNSIGNED NOT NULL,
  `raw_material_id` bigint UNSIGNED NOT NULL,
  `quantity` decimal(12,4) NOT NULL,
  `waste_percent` decimal(5,2) NOT NULL DEFAULT '0.00',
  `notes` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `recipe_ingredients`
--

INSERT INTO `recipe_ingredients` (`id`, `recipe_id`, `raw_material_id`, `quantity`, `waste_percent`, `notes`, `created_at`, `updated_at`) VALUES
(94, 14, 111, 20.0000, 0.00, NULL, '2026-06-04 04:13:16', '2026-06-04 04:13:16'),
(95, 14, 7, 5.0000, 0.00, NULL, '2026-06-04 04:13:16', '2026-06-04 04:13:16'),
(96, 14, 5, 10.0000, 0.00, NULL, '2026-06-04 04:13:16', '2026-06-04 04:13:16'),
(97, 14, 30, 10.0000, 0.00, NULL, '2026-06-04 04:13:16', '2026-06-04 04:13:16'),
(98, 14, 8, 10.0000, 0.00, NULL, '2026-06-04 04:13:16', '2026-06-04 04:13:16'),
(99, 14, 6, 30.0000, 0.00, NULL, '2026-06-04 04:13:16', '2026-06-04 04:13:16'),
(100, 14, 101, 10.0000, 0.00, NULL, '2026-06-04 04:13:16', '2026-06-04 04:13:16'),
(101, 14, 99, 10.0000, 0.00, NULL, '2026-06-04 04:13:16', '2026-06-04 04:13:16'),
(102, 14, 103, 10.0000, 0.00, NULL, '2026-06-04 04:13:16', '2026-06-04 04:13:16'),
(103, 14, 104, 30.0000, 0.00, NULL, '2026-06-04 04:13:16', '2026-06-04 04:13:16'),
(104, 14, 98, 50.0000, 0.00, NULL, '2026-06-04 04:13:16', '2026-06-04 04:13:16'),
(105, 14, 108, 50.0000, 0.00, NULL, '2026-06-04 04:13:16', '2026-06-04 04:13:16'),
(106, 14, 109, 50.0000, 0.00, NULL, '2026-06-04 04:13:16', '2026-06-04 04:13:16'),
(107, 14, 97, 50.0000, 0.00, NULL, '2026-06-04 04:13:16', '2026-06-04 04:13:16'),
(108, 14, 18, 1.0000, 0.00, NULL, '2026-06-04 04:13:16', '2026-06-04 04:13:16'),
(166, 16, 129, 50.0000, 0.00, NULL, '2026-06-09 16:00:46', '2026-06-09 16:00:46'),
(167, 16, 130, 15.0000, 0.00, NULL, '2026-06-09 16:00:46', '2026-06-09 16:00:46'),
(168, 16, 77, 7.0000, 0.00, NULL, '2026-06-09 16:00:46', '2026-06-09 16:00:46'),
(169, 16, 51, 7.0000, 0.00, NULL, '2026-06-09 16:00:46', '2026-06-09 16:00:46'),
(170, 16, 103, 5.0000, 0.00, NULL, '2026-06-09 16:00:46', '2026-06-09 16:00:46'),
(171, 16, 108, 100.0000, 0.00, NULL, '2026-06-09 16:00:46', '2026-06-09 16:00:46'),
(172, 16, 98, 150.0000, 0.00, NULL, '2026-06-09 16:00:46', '2026-06-09 16:00:46'),
(173, 16, 18, 1.0000, 0.00, NULL, '2026-06-09 16:00:46', '2026-06-09 16:00:46'),
(174, 13, 111, 10.0000, 0.00, NULL, '2026-06-09 16:01:43', '2026-06-09 16:01:43'),
(175, 13, 109, 25.0000, 0.00, NULL, '2026-06-09 16:01:43', '2026-06-09 16:01:43'),
(176, 13, 110, 10.0000, 0.00, NULL, '2026-06-09 16:01:43', '2026-06-09 16:01:43'),
(177, 13, 108, 25.0000, 0.00, NULL, '2026-06-09 16:01:43', '2026-06-09 16:01:43'),
(178, 13, 105, 10.0000, 0.00, NULL, '2026-06-09 16:01:43', '2026-06-09 16:01:43'),
(179, 13, 104, 20.0000, 0.00, NULL, '2026-06-09 16:01:43', '2026-06-09 16:01:43'),
(180, 13, 103, 20.0000, 0.00, NULL, '2026-06-09 16:01:43', '2026-06-09 16:01:43'),
(181, 13, 102, 20.0000, 0.00, NULL, '2026-06-09 16:01:43', '2026-06-09 16:01:43'),
(182, 13, 101, 20.0000, 0.00, NULL, '2026-06-09 16:01:43', '2026-06-09 16:01:43'),
(183, 13, 100, 20.0000, 0.00, NULL, '2026-06-09 16:01:43', '2026-06-09 16:01:43'),
(184, 13, 99, 20.0000, 0.00, NULL, '2026-06-09 16:01:43', '2026-06-09 16:01:43'),
(185, 13, 98, 25.0000, 0.00, NULL, '2026-06-09 16:01:43', '2026-06-09 16:01:43'),
(186, 13, 97, 25.0000, 0.00, NULL, '2026-06-09 16:01:43', '2026-06-09 16:01:43'),
(187, 13, 96, 25.0000, 0.00, NULL, '2026-06-09 16:01:43', '2026-06-09 16:01:43'),
(188, 13, 86, 1.0000, 0.00, NULL, '2026-06-09 16:01:43', '2026-06-09 16:01:43'),
(189, 11, 58, 1.0000, 0.00, NULL, '2026-06-09 16:02:30', '2026-06-09 16:02:30'),
(190, 11, 56, 50.0000, 0.00, NULL, '2026-06-09 16:02:30', '2026-06-09 16:02:30'),
(191, 11, 59, 4.0000, 0.00, NULL, '2026-06-09 16:02:30', '2026-06-09 16:02:30'),
(192, 11, 60, 5.0000, 0.00, NULL, '2026-06-09 16:02:30', '2026-06-09 16:02:30'),
(203, 15, 128, 30.0000, 0.00, NULL, '2026-06-09 18:18:25', '2026-06-09 18:18:25'),
(204, 15, 127, 20.0000, 0.00, NULL, '2026-06-09 18:18:25', '2026-06-09 18:18:25'),
(205, 15, 57, 4.0000, 0.00, NULL, '2026-06-09 18:18:25', '2026-06-09 18:18:25'),
(206, 15, 97, 40.0000, 0.00, NULL, '2026-06-09 18:18:25', '2026-06-09 18:18:25'),
(207, 15, 105, 8.0000, 0.00, NULL, '2026-06-09 18:18:25', '2026-06-09 18:18:25'),
(208, 15, 102, 20.0000, 0.00, NULL, '2026-06-09 18:18:25', '2026-06-09 18:18:25'),
(209, 15, 126, 28.0000, 0.00, NULL, '2026-06-09 18:18:25', '2026-06-09 18:18:25'),
(210, 15, 125, 48.0000, 0.00, NULL, '2026-06-09 18:18:25', '2026-06-09 18:18:25'),
(211, 15, 124, 20.0000, 0.00, NULL, '2026-06-09 18:18:25', '2026-06-09 18:18:25'),
(212, 15, 113, 1.0000, 0.00, NULL, '2026-06-09 18:18:25', '2026-06-09 18:18:25'),
(218, 2, 58, 1.0000, 0.00, NULL, '2026-06-09 19:17:09', '2026-06-09 19:17:09'),
(219, 2, 54, 50.0000, 0.00, NULL, '2026-06-09 19:17:09', '2026-06-09 19:17:09'),
(220, 2, 59, 4.0000, 0.00, NULL, '2026-06-09 19:17:09', '2026-06-09 19:17:09'),
(221, 2, 60, 5.0000, 0.00, NULL, '2026-06-09 19:17:09', '2026-06-09 19:17:09'),
(222, 2, 79, 1.0000, 0.00, NULL, '2026-06-09 19:17:09', '2026-06-09 19:17:09'),
(223, 1, 56, 50.0000, 0.00, NULL, '2026-06-09 19:17:46', '2026-06-09 19:17:46'),
(224, 1, 58, 1.0000, 0.00, NULL, '2026-06-09 19:17:46', '2026-06-09 19:17:46'),
(225, 1, 59, 4.0000, 0.00, NULL, '2026-06-09 19:17:46', '2026-06-09 19:17:46'),
(226, 1, 60, 5.0000, 0.00, NULL, '2026-06-09 19:17:46', '2026-06-09 19:17:46'),
(227, 1, 79, 1.0000, 0.00, NULL, '2026-06-09 19:17:46', '2026-06-09 19:17:46'),
(228, 8, 58, 1.0000, 0.00, NULL, '2026-06-09 19:18:23', '2026-06-09 19:18:23'),
(229, 8, 78, 50.0000, 0.00, NULL, '2026-06-09 19:18:23', '2026-06-09 19:18:23'),
(230, 8, 59, 4.0000, 0.00, NULL, '2026-06-09 19:18:23', '2026-06-09 19:18:23'),
(231, 8, 60, 5.0000, 0.00, NULL, '2026-06-09 19:18:23', '2026-06-09 19:18:23'),
(232, 8, 79, 1.0000, 0.00, NULL, '2026-06-09 19:18:23', '2026-06-09 19:18:23'),
(239, 12, 82, 1.0000, 0.00, NULL, '2026-06-09 19:19:40', '2026-06-09 19:19:40'),
(240, 12, 80, 25.0000, 0.00, NULL, '2026-06-09 19:19:40', '2026-06-09 19:19:40'),
(241, 12, 81, 25.0000, 0.00, NULL, '2026-06-09 19:19:40', '2026-06-09 19:19:40'),
(242, 12, 79, 1.0000, 0.00, NULL, '2026-06-09 19:19:40', '2026-06-09 19:19:40'),
(243, 12, 59, 4.0000, 0.00, NULL, '2026-06-09 19:19:40', '2026-06-09 19:19:40'),
(244, 12, 60, 5.0000, 0.00, NULL, '2026-06-09 19:19:40', '2026-06-09 19:19:40'),
(252, 17, 134, 30.0000, 0.00, NULL, '2026-06-10 01:26:20', '2026-06-10 01:26:20'),
(253, 17, 24, 2.0000, 0.00, NULL, '2026-06-10 01:26:20', '2026-06-10 01:26:20'),
(254, 17, 9, 5.0000, 0.00, NULL, '2026-06-10 01:26:20', '2026-06-10 01:26:20'),
(255, 17, 110, 10.0000, 0.00, NULL, '2026-06-10 01:26:20', '2026-06-10 01:26:20'),
(256, 17, 105, 5.0000, 0.00, NULL, '2026-06-10 01:26:20', '2026-06-10 01:26:20'),
(257, 17, 102, 10.0000, 0.00, NULL, '2026-06-10 01:26:20', '2026-06-10 01:26:20'),
(258, 17, 132, 100.0000, 0.00, NULL, '2026-06-10 01:26:20', '2026-06-10 01:26:20'),
(259, 17, 18, 1.0000, 0.00, NULL, '2026-06-10 01:26:20', '2026-06-10 01:26:20'),
(296, 21, 140, 5.0000, 0.00, NULL, '2026-06-10 02:58:58', '2026-06-10 02:58:58'),
(297, 21, 77, 7.0000, 0.00, NULL, '2026-06-10 02:58:58', '2026-06-10 02:58:58'),
(298, 21, 51, 7.0000, 0.00, NULL, '2026-06-10 02:58:58', '2026-06-10 02:58:58'),
(299, 21, 24, 25.0000, 0.00, NULL, '2026-06-10 02:58:58', '2026-06-10 02:58:58'),
(300, 21, 99, 5.0000, 0.00, NULL, '2026-06-10 02:58:58', '2026-06-10 02:58:58'),
(301, 21, 105, 5.0000, 0.00, NULL, '2026-06-10 02:58:58', '2026-06-10 02:58:58'),
(302, 21, 110, 10.0000, 0.00, NULL, '2026-06-10 02:58:58', '2026-06-10 02:58:58'),
(303, 21, 136, 10.0000, 0.00, NULL, '2026-06-10 02:58:58', '2026-06-10 02:58:58'),
(304, 21, 138, 10.0000, 0.00, NULL, '2026-06-10 02:58:58', '2026-06-10 02:58:58'),
(305, 21, 104, 10.0000, 0.00, NULL, '2026-06-10 02:58:58', '2026-06-10 02:58:58'),
(306, 21, 139, 10.0000, 0.00, NULL, '2026-06-10 02:58:58', '2026-06-10 02:58:58'),
(307, 21, 102, 10.0000, 0.00, NULL, '2026-06-10 02:58:58', '2026-06-10 02:58:58'),
(308, 21, 132, 100.0000, 0.00, NULL, '2026-06-10 02:58:58', '2026-06-10 02:58:58'),
(309, 21, 135, 50.0000, 0.00, NULL, '2026-06-10 02:58:58', '2026-06-10 02:58:58'),
(310, 21, 18, 1.0000, 0.00, NULL, '2026-06-10 02:58:58', '2026-06-10 02:58:58'),
(333, 22, 17, 9.0000, 0.00, NULL, '2026-06-10 03:24:49', '2026-06-10 03:24:49'),
(334, 22, 10, 9.0000, 0.00, NULL, '2026-06-10 03:24:49', '2026-06-10 03:24:49'),
(335, 22, 19, 200.0000, 0.00, NULL, '2026-06-10 03:24:49', '2026-06-10 03:24:49'),
(336, 22, 112, 300.0000, 0.00, NULL, '2026-06-10 03:24:49', '2026-06-10 03:24:49'),
(337, 22, 146, 10.0000, 0.00, NULL, '2026-06-10 03:24:49', '2026-06-10 03:24:49'),
(338, 22, 145, 10.0000, 0.00, NULL, '2026-06-10 03:24:49', '2026-06-10 03:24:49'),
(339, 22, 144, 20.0000, 0.00, NULL, '2026-06-10 03:24:49', '2026-06-10 03:24:49'),
(340, 22, 97, 20.0000, 0.00, NULL, '2026-06-10 03:24:49', '2026-06-10 03:24:49'),
(341, 22, 142, 20.0000, 0.00, NULL, '2026-06-10 03:24:49', '2026-06-10 03:24:49'),
(342, 22, 141, 20.0000, 0.00, NULL, '2026-06-10 03:24:49', '2026-06-10 03:24:49'),
(343, 22, 98, 100.0000, 0.00, NULL, '2026-06-10 03:24:49', '2026-06-10 03:24:49'),
(344, 22, 87, 1.0000, 0.00, NULL, '2026-06-10 03:24:49', '2026-06-10 03:24:49'),
(361, 23, 151, 200.0000, 0.00, NULL, '2026-06-10 03:54:09', '2026-06-10 03:54:09'),
(362, 23, 150, 10.0000, 0.00, NULL, '2026-06-10 03:54:09', '2026-06-10 03:54:09'),
(363, 23, 149, 10.0000, 0.00, NULL, '2026-06-10 03:54:09', '2026-06-10 03:54:09'),
(364, 23, 148, 20.0000, 0.00, NULL, '2026-06-10 03:54:09', '2026-06-10 03:54:09'),
(365, 23, 147, 20.0000, 0.00, NULL, '2026-06-10 03:54:09', '2026-06-10 03:54:09'),
(366, 23, 130, 20.0000, 0.00, NULL, '2026-06-10 03:54:09', '2026-06-10 03:54:09'),
(367, 23, 100, 10.0000, 0.00, NULL, '2026-06-10 03:54:09', '2026-06-10 03:54:09'),
(368, 23, 103, 10.0000, 0.00, NULL, '2026-06-10 03:54:09', '2026-06-10 03:54:09'),
(369, 23, 96, 20.0000, 0.00, NULL, '2026-06-10 03:54:09', '2026-06-10 03:54:09'),
(370, 23, 141, 20.0000, 0.00, NULL, '2026-06-10 03:54:09', '2026-06-10 03:54:09'),
(371, 23, 18, 1.0000, 0.00, NULL, '2026-06-10 03:54:09', '2026-06-10 03:54:09');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `smart_input_items`
--

CREATE TABLE `smart_input_items` (
  `id` bigint UNSIGNED NOT NULL,
  `session_id` bigint UNSIGNED NOT NULL,
  `description_raw` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` decimal(12,4) NOT NULL,
  `unit_raw` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unit_normalized` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unit_price` decimal(10,4) DEFAULT NULL,
  `total_price` decimal(12,2) DEFAULT NULL,
  `raw_material_id` bigint UNSIGNED DEFAULT NULL,
  `match_confidence` double DEFAULT NULL,
  `match_suggestions` json DEFAULT NULL,
  `batch_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `expires_at` date DEFAULT NULL,
  `manufactured_at` date DEFAULT NULL,
  `is_confirmed` tinyint(1) NOT NULL DEFAULT '0',
  `is_skipped` tinyint(1) NOT NULL DEFAULT '0',
  `is_new_material` tinyint(1) NOT NULL DEFAULT '0',
  `new_material_category` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `smart_input_items`
--

INSERT INTO `smart_input_items` (`id`, `session_id`, `description_raw`, `quantity`, `unit_raw`, `unit_normalized`, `unit_price`, `total_price`, `raw_material_id`, `match_confidence`, `match_suggestions`, `batch_number`, `expires_at`, `manufactured_at`, `is_confirmed`, `is_skipped`, `is_new_material`, `new_material_category`, `notes`, `created_at`, `updated_at`) VALUES
(1, 15, 'BISNAGA BRANCA PE 60G – DZ', 1.0000, 'un', 'un', 14.4000, NULL, 1, 1, '[{\"name\": \"BISNAGA BRANCA PE 60G – DZ\", \"unit\": \"un\", \"confidence\": 1, \"raw_material_id\": 1}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-21 02:47:48', '2026-05-21 02:48:09'),
(2, 16, 'OLEO- ESSENCIAL DE LARANJA DOCE - BALLON', 10.0000, 'UN', 'ml', 16.0000, 16.00, NULL, 0.3056, '[{\"name\": \"BISNAGA BRANCA PE 60G – DZ\", \"unit\": \"un\", \"confidence\": 0.3056, \"raw_material_id\": 1}]', NULL, NULL, NULL, 1, 0, 1, 'Óleo Essencial', NULL, '2026-05-21 13:26:33', '2026-05-21 13:31:59'),
(3, 16, 'OLEO- ESSENCIAL DE LAVANDA - BALLON', 10.0000, 'UN', 'ml', 25.0000, 25.00, NULL, NULL, '[]', NULL, NULL, NULL, 1, 0, 1, 'Óleo essencial', NULL, '2026-05-21 13:26:33', '2026-05-21 13:32:58'),
(4, 16, 'ESS LAVANDA INGLESA - OAK', 100.0000, 'LT', 'ml', 26.0000, 26.00, NULL, NULL, '[]', NULL, NULL, NULL, 1, 0, 1, 'Essência', NULL, '2026-05-21 13:26:33', '2026-05-21 13:34:06'),
(5, 16, 'ESS LAVANDA FRANCESA - OAK', 100.0000, 'LT', 'ml', 24.0000, 24.00, NULL, 0.3333, '[{\"name\": \"BISNAGA BRANCA PE 60G – DZ\", \"unit\": \"un\", \"confidence\": 0.3333, \"raw_material_id\": 1}]', NULL, NULL, NULL, 1, 0, 1, 'Essência', NULL, '2026-05-21 13:26:33', '2026-05-21 13:34:45'),
(6, 16, 'ESS LAVANDA & ALGODAO MAHOGANY- ISAN', 100.0000, 'LT', 'ml', 28.0000, 28.00, NULL, NULL, '[]', NULL, NULL, NULL, 1, 0, 1, 'Essência', NULL, '2026-05-21 13:26:33', '2026-05-21 13:35:14'),
(7, 16, 'ESS LAVANDA PROVENCE - LESS', 100.0000, 'LT', 'ml', 25.0000, 25.00, NULL, 0.3004, '[{\"name\": \"BISNAGA BRANCA PE 60G – DZ\", \"unit\": \"un\", \"confidence\": 0.3004, \"raw_material_id\": 1}]', NULL, NULL, NULL, 1, 0, 1, 'Essência', NULL, '2026-05-21 13:26:33', '2026-05-21 13:35:36'),
(8, 16, 'ESS ALMISCAR - DOMO', 100.0000, 'LT', 'ml', 28.0000, 28.00, NULL, NULL, '[]', NULL, NULL, NULL, 1, 0, 1, 'Essência', NULL, '2026-05-21 13:26:33', '2026-05-21 13:36:00'),
(9, 16, 'ESS ROSAS BRANCAS- LESSENCE', 100.0000, 'LT', 'ml', 22.0000, 22.00, NULL, 0.4178, '[{\"name\": \"BISNAGA BRANCA PE 60G – DZ\", \"unit\": \"un\", \"confidence\": 0.4178, \"raw_material_id\": 1}]', NULL, NULL, NULL, 1, 0, 1, 'Essência', NULL, '2026-05-21 13:26:33', '2026-05-21 13:36:21'),
(10, 18, 'Frasco PET 220ML Malta R. 24/415 Laranja', 10.0000, 'un', 'un', 0.8100, NULL, 10, 1, '[{\"name\": \"Frasco PET 220ML Malta R. 24/415 Laranja\", \"unit\": \"un\", \"confidence\": 1, \"raw_material_id\": 10}, {\"name\": \"Frasco PET 220ml Malta R.24/415 Azul\", \"unit\": \"un\", \"confidence\": 1, \"raw_material_id\": 11}, {\"name\": \"Frasco PET 220ml Malta R.24/415 Cristal\", \"unit\": \"un\", \"confidence\": 1, \"raw_material_id\": 12}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-21 14:49:26', '2026-05-21 14:49:26'),
(11, 18, 'Frasco PET 220ml Malta R.24/415 Azul', 10.0000, 'un', 'un', 0.8100, NULL, 11, 1, '[{\"name\": \"Frasco PET 220ML Malta R. 24/415 Laranja\", \"unit\": \"un\", \"confidence\": 1, \"raw_material_id\": 10}, {\"name\": \"Frasco PET 220ml Malta R.24/415 Azul\", \"unit\": \"un\", \"confidence\": 1, \"raw_material_id\": 11}, {\"name\": \"Frasco PET 220ml Malta R.24/415 Cristal\", \"unit\": \"un\", \"confidence\": 1, \"raw_material_id\": 12}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-21 14:49:26', '2026-05-21 14:49:26'),
(12, 18, 'Frasco PET 220ml Malta R.24/415 Cristal', 12.0000, 'un', 'un', 0.8300, NULL, 12, 1, '[{\"name\": \"Frasco PET 220ML Malta R. 24/415 Laranja\", \"unit\": \"un\", \"confidence\": 1, \"raw_material_id\": 10}, {\"name\": \"Frasco PET 220ml Malta R.24/415 Azul\", \"unit\": \"un\", \"confidence\": 1, \"raw_material_id\": 11}, {\"name\": \"Frasco PET 220ml Malta R.24/415 Cristal\", \"unit\": \"un\", \"confidence\": 1, \"raw_material_id\": 12}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-21 14:49:26', '2026-05-21 14:49:26'),
(13, 18, 'Tampa Disk TOP 24/410 Luxo Prata Fosco', 37.0000, 'un', 'un', 1.1300, NULL, 14, 1, '[{\"name\": \"Tampa Disk TOP 24/410 Luxo Prata Fosco\", \"unit\": \"un\", \"confidence\": 1, \"raw_material_id\": 14}, {\"name\": \"Tampa Disk TOP 24/415 Laranja\", \"unit\": \"un\", \"confidence\": 0.7861, \"raw_material_id\": 17}, {\"name\": \"Tampa Disk TOP 24/415 Branca 27827\", \"unit\": \"un\", \"confidence\": 0.755, \"raw_material_id\": 16}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-21 14:49:27', '2026-05-21 14:49:27'),
(14, 18, 'Frasco PET 300ml Cilreto saturno 24/410', 37.0000, 'un', 'un', 1.2000, NULL, 13, 1, '[{\"name\": \"Frasco PET 300ml Cilreto saturno 24/410\", \"unit\": \"un\", \"confidence\": 1, \"raw_material_id\": 13}, {\"name\": \"Frasco PET 220ml Malta R.24/415 Azul\", \"unit\": \"un\", \"confidence\": 0.6398, \"raw_material_id\": 11}, {\"name\": \"Frasco PET 220ML Malta R. 24/415 Laranja\", \"unit\": \"un\", \"confidence\": 0.5949, \"raw_material_id\": 10}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-21 14:49:27', '2026-05-21 14:49:27'),
(15, 18, 'Tampa Disk TOP 24/415 Natural R.27822', 12.0000, 'un', 'un', 0.8300, NULL, 15, 1, '[{\"name\": \"Tampa Disk TOP 24/415 Natural R.27822\", \"unit\": \"un\", \"confidence\": 1, \"raw_material_id\": 15}, {\"name\": \"Tampa Disk TOP 24/415 Branca 27827\", \"unit\": \"un\", \"confidence\": 0.937, \"raw_material_id\": 16}, {\"name\": \"Tampa Disk TOP 24/415 Laranja\", \"unit\": \"un\", \"confidence\": 0.8581, \"raw_material_id\": 17}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-21 14:49:27', '2026-05-21 14:49:27'),
(16, 18, 'Tampa Disk TOP 24/415 Branca 27827', 10.0000, 'un', 'un', 0.6400, NULL, 16, 1, '[{\"name\": \"Tampa Disk TOP 24/415 Branca 27827\", \"unit\": \"un\", \"confidence\": 1, \"raw_material_id\": 16}, {\"name\": \"Tampa Disk TOP 24/415 Natural R.27822\", \"unit\": \"un\", \"confidence\": 0.937, \"raw_material_id\": 15}, {\"name\": \"Tampa Disk TOP 24/415 Laranja\", \"unit\": \"un\", \"confidence\": 0.9227, \"raw_material_id\": 17}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-21 14:49:27', '2026-05-21 14:49:27'),
(17, 18, 'Tampa Disk TOP 24/415 Laranja', 10.0000, 'un', 'un', 0.6400, NULL, 17, 1, '[{\"name\": \"Tampa Disk TOP 24/415 Laranja\", \"unit\": \"un\", \"confidence\": 1, \"raw_material_id\": 17}, {\"name\": \"Tampa Disk TOP 24/415 Branca 27827\", \"unit\": \"un\", \"confidence\": 0.9494, \"raw_material_id\": 16}, {\"name\": \"Tampa Disk TOP 24/415 Natural R.27822\", \"unit\": \"un\", \"confidence\": 0.8848, \"raw_material_id\": 15}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-21 14:49:27', '2026-05-21 14:49:27'),
(18, 18, 'Creme Hidratante Concent 1x4 1kg yant/gi', 4.0000, 'un', 'un', 25.7500, NULL, 18, 1, '[{\"name\": \"Creme Hidratante Concent 1x4 1kg yant/gi\", \"unit\": \"kg\", \"confidence\": 1, \"raw_material_id\": 18}, {\"name\": \"ESS LAVANDA & ALGODAO MAHOGANY- ISAN\", \"unit\": \"ml\", \"confidence\": 0.3037, \"raw_material_id\": 6}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-21 14:49:27', '2026-05-21 14:49:27'),
(19, 20, 'Laauril 2000 Decilglucosideo 50', 1.0000, 'L', NULL, 63.0000, NULL, 19, 1, '[{\"name\": \"Laauril 2000 Decilglucosideo 50\", \"unit\": \"L\", \"confidence\": 1, \"raw_material_id\": 19}, {\"name\": \"Lauril Vegetal VG\", \"unit\": \"L\", \"confidence\": 0.354, \"raw_material_id\": 20}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-21 15:17:20', '2026-05-21 15:17:20'),
(20, 20, 'Lauril Vegetal VG', 1.0000, 'L', NULL, 32.5000, NULL, 20, 1, '[{\"name\": \"Lauril Vegetal VG\", \"unit\": \"L\", \"confidence\": 1, \"raw_material_id\": 20}, {\"name\": \"Laauril 2000 Decilglucosideo 50\", \"unit\": \"L\", \"confidence\": 0.404, \"raw_material_id\": 19}, {\"name\": \"ESS La Vita Linha 1\", \"unit\": \"ml\", \"confidence\": 0.3298, \"raw_material_id\": 23}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-21 15:17:20', '2026-05-21 15:17:20'),
(21, 20, 'ESS G. Armani My Way FEM Linha 1', 30.0000, 'ml', 'ml', 1.3400, NULL, 21, 1, '[{\"name\": \"ESS G. Armani My Way FEM Linha 1\", \"unit\": \"ml\", \"confidence\": 1, \"raw_material_id\": 21}, {\"name\": \"ESS Interditada FEM Linha 1\", \"unit\": \"ml\", \"confidence\": 0.7247, \"raw_material_id\": 22}, {\"name\": \"ESS La Vita Linha 1\", \"unit\": \"ml\", \"confidence\": 0.6095, \"raw_material_id\": 23}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-21 15:17:20', '2026-05-21 15:17:20'),
(22, 20, 'ESS Interditada FEM Linha 1', 30.0000, 'ml', 'ml', 1.3400, NULL, 22, 1, '[{\"name\": \"ESS Interditada FEM Linha 1\", \"unit\": \"ml\", \"confidence\": 1, \"raw_material_id\": 22}, {\"name\": \"ESS G. Armani My Way FEM Linha 1\", \"unit\": \"ml\", \"confidence\": 0.7547, \"raw_material_id\": 21}, {\"name\": \"ESS La Vita Linha 1\", \"unit\": \"ml\", \"confidence\": 0.7135, \"raw_material_id\": 23}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-21 15:17:20', '2026-05-21 15:17:20'),
(23, 20, 'ESS La Vita Linha 1', 30.0000, 'ml', 'ml', 1.3400, NULL, 23, 1, '[{\"name\": \"ESS La Vita Linha 1\", \"unit\": \"ml\", \"confidence\": 1, \"raw_material_id\": 23}, {\"name\": \"ESS Interditada FEM Linha 1\", \"unit\": \"ml\", \"confidence\": 0.7469, \"raw_material_id\": 22}, {\"name\": \"ESS G. Armani My Way FEM Linha 1\", \"unit\": \"ml\", \"confidence\": 0.6869, \"raw_material_id\": 21}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-21 15:17:20', '2026-05-21 15:17:20'),
(24, 20, 'ESSÊNCIA LANCOM LA NUITE LINHA 1', 30.0000, 'ml', 'ml', 1.3400, NULL, 24, 1, '[{\"name\": \"ESSÊNCIA LANCOM LA NUITE LINHA 1\", \"unit\": \"ml\", \"confidence\": 1, \"raw_material_id\": 24}, {\"name\": \"ESS La Vita Linha 1\", \"unit\": \"ml\", \"confidence\": 0.6625, \"raw_material_id\": 23}, {\"name\": \"ESS G. Armani My Way FEM Linha 1\", \"unit\": \"ml\", \"confidence\": 0.6119, \"raw_material_id\": 21}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-21 15:17:20', '2026-05-21 15:17:20'),
(25, 20, 'ESSÊNCIA ARMAFI – CLUB DE NOITE INTENSO MASC (LINHA ARABE)', 30.0000, 'ml', 'ml', 1.7400, NULL, 25, 1, '[{\"name\": \"ESSÊNCIA ARMAFI – CLUB DE NOITE INTENSO MASC (LINHA ARABE)\", \"unit\": \"ml\", \"confidence\": 1, \"raw_material_id\": 25}, {\"name\": \"ESSÊNCIA LANCOM LA NUITE LINHA 1\", \"unit\": \"ml\", \"confidence\": 0.5627, \"raw_material_id\": 24}, {\"name\": \"ESS G. Armani My Way FEM Linha 1\", \"unit\": \"ml\", \"confidence\": 0.4629, \"raw_material_id\": 21}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-21 15:17:20', '2026-05-21 15:17:20'),
(26, 20, 'ESSÊNCIA BERGAMOTA ROSA', 100.0000, 'un', 'un', 0.2000, NULL, 26, 1, '[{\"name\": \"ESSÊNCIA BERGAMOTA ROSA\", \"unit\": \"ml\", \"confidence\": 1, \"raw_material_id\": 26}, {\"name\": \"ESSÊNCIA BAMBOO\", \"unit\": \"ml\", \"confidence\": 0.7349, \"raw_material_id\": 27}, {\"name\": \"ESSÊNCIA LIS BRANCO ALECRIM\", \"unit\": \"ml\", \"confidence\": 0.5564, \"raw_material_id\": 28}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-21 15:17:20', '2026-05-21 15:17:20'),
(27, 20, 'ESSÊNCIA BAMBOO', 100.0000, 'un', 'un', 0.2300, NULL, 27, 1, '[{\"name\": \"ESSÊNCIA BAMBOO\", \"unit\": \"ml\", \"confidence\": 1, \"raw_material_id\": 27}, {\"name\": \"ESSÊNCIA BERGAMOTA ROSA\", \"unit\": \"ml\", \"confidence\": 0.7682, \"raw_material_id\": 26}, {\"name\": \"ESSÊNCIA LIS BRANCO ALECRIM\", \"unit\": \"ml\", \"confidence\": 0.6206, \"raw_material_id\": 28}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-21 15:17:20', '2026-05-21 15:17:20'),
(28, 20, 'ESSÊNCIA LIS BRANCO ALECRIM', 100.0000, 'ml', 'ml', 0.2800, NULL, 28, 1, '[{\"name\": \"ESSÊNCIA LIS BRANCO ALECRIM\", \"unit\": \"ml\", \"confidence\": 1, \"raw_material_id\": 28}, {\"name\": \"ESSÊNCIA LANCOM LA NUITE LINHA 1\", \"unit\": \"ml\", \"confidence\": 0.5786, \"raw_material_id\": 24}, {\"name\": \"ESSÊNCIA BAMBOO\", \"unit\": \"ml\", \"confidence\": 0.5706, \"raw_material_id\": 27}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-21 15:17:20', '2026-05-21 15:17:20'),
(29, 21, 'ESS CEDRO SABONETE', 50.0000, 'un', 'ml', 0.1500, 7.50, NULL, 0.4521, '[{\"name\": \"ESS ALMISCAR - DOMO\", \"unit\": \"ml\", \"confidence\": 0.4521, \"raw_material_id\": 8}, {\"name\": \"ESS LAVANDA FRANCESA - OAK\", \"unit\": \"ml\", \"confidence\": 0.4405, \"raw_material_id\": 5}, {\"name\": \"ESS LAVANDA & ALGODAO MAHOGANY- ISAN\", \"unit\": \"ml\", \"confidence\": 0.4232, \"raw_material_id\": 6}]', NULL, NULL, NULL, 1, 0, 1, 'Essência', NULL, '2026-05-21 16:48:44', '2026-05-21 16:51:22'),
(30, 21, 'ESS P KIT PATCHOLY', 50.0000, 'un', 'ml', 0.1500, 7.50, NULL, 0.527, '[{\"name\": \"ESS La Vita Linha 1\", \"unit\": \"ml\", \"confidence\": 0.527, \"raw_material_id\": 23}, {\"name\": \"ESS ALMISCAR - DOMO\", \"unit\": \"ml\", \"confidence\": 0.4279, \"raw_material_id\": 8}, {\"name\": \"ESS LAVANDA PROVENCE - LESS\", \"unit\": \"ml\", \"confidence\": 0.4179, \"raw_material_id\": 7}]', NULL, NULL, NULL, 1, 0, 1, NULL, NULL, '2026-05-21 16:48:44', '2026-05-21 16:52:20'),
(31, 21, 'SABONETE LIQUIDO AROMAS YANTRA', 1.0000, 'un', 'un', 7.3000, 7.30, NULL, 0.3159, '[{\"name\": \"OLEO- ESSENCIAL DE LARANJA DOCE - BALLON\", \"unit\": \"ml\", \"confidence\": 0.3159, \"raw_material_id\": 2}, {\"name\": \"Creme Hidratante Concent 1x4 1kg yant/gi\", \"unit\": \"kg\", \"confidence\": 0.3057, \"raw_material_id\": 18}, {\"name\": \"ESSÊNCIA LIS BRANCO ALECRIM\", \"unit\": \"ml\", \"confidence\": 0.3039, \"raw_material_id\": 28}]', NULL, NULL, NULL, 1, 0, 1, 'Base', NULL, '2026-05-21 16:48:44', '2026-05-21 16:52:44'),
(32, 21, 'VARETA OLHO GREGO MINI', 5.0000, 'un', 'un', 1.1500, 5.75, NULL, 0.3222, '[{\"name\": \"ESSÊNCIA LANCOM LA NUITE LINHA 1\", \"unit\": \"ml\", \"confidence\": 0.3222, \"raw_material_id\": 24}, {\"name\": \"ESS LAVANDA & ALGODAO MAHOGANY- ISAN\", \"unit\": \"ml\", \"confidence\": 0.3152, \"raw_material_id\": 6}, {\"name\": \"ESSÊNCIA LIS BRANCO ALECRIM\", \"unit\": \"ml\", \"confidence\": 0.3144, \"raw_material_id\": 28}]', NULL, NULL, NULL, 1, 0, 1, 'Acessório', NULL, '2026-05-21 16:48:44', '2026-05-21 16:53:20'),
(33, 21, 'VARETA ESTRELA MADEIRA PEQUENA', 3.0000, 'un', 'un', 1.4900, 4.47, NULL, 0.329, '[{\"name\": \"ESS ROSAS BRANCAS- LESSENCE\", \"unit\": \"ml\", \"confidence\": 0.329, \"raw_material_id\": 9}, {\"name\": \"OLEO- ESSENCIAL DE LAVANDA - BALLON\", \"unit\": \"ml\", \"confidence\": 0.3198, \"raw_material_id\": 3}, {\"name\": \"OLEO- ESSENCIAL DE LARANJA DOCE - BALLON\", \"unit\": \"ml\", \"confidence\": 0.3014, \"raw_material_id\": 2}]', NULL, NULL, NULL, 1, 0, 1, 'Acessório', NULL, '2026-05-21 16:48:44', '2026-05-21 16:53:40'),
(34, 21, 'VARETA FRAMBOESA MINI C/ARGOLA', 5.0000, 'un', 'un', 0.9500, 4.75, NULL, 0.36, '[{\"name\": \"ESS LAVANDA FRANCESA - OAK\", \"unit\": \"ml\", \"confidence\": 0.36, \"raw_material_id\": 5}, {\"name\": \"ESS LAVANDA INGLESA - OAK\", \"unit\": \"ml\", \"confidence\": 0.3238, \"raw_material_id\": 4}, {\"name\": \"ESSÊNCIA BERGAMOTA ROSA\", \"unit\": \"ml\", \"confidence\": 0.3238, \"raw_material_id\": 26}]', NULL, NULL, NULL, 1, 0, 1, 'Acessório', NULL, '2026-05-21 16:48:44', '2026-05-21 16:53:57'),
(35, 21, 'VARETA MINI C/ ARGOLA 12CM', 3.0000, 'un', 'un', 0.6000, 1.80, NULL, 0.3604, '[{\"name\": \"ESS G. Armani My Way FEM Linha 1\", \"unit\": \"ml\", \"confidence\": 0.3604, \"raw_material_id\": 21}, {\"name\": \"ESS La Vita Linha 1\", \"unit\": \"ml\", \"confidence\": 0.3575, \"raw_material_id\": 23}, {\"name\": \"ESSÊNCIA LIS BRANCO ALECRIM\", \"unit\": \"ml\", \"confidence\": 0.3493, \"raw_material_id\": 28}]', NULL, NULL, NULL, 1, 0, 1, 'Acessório', NULL, '2026-05-21 16:48:44', '2026-05-21 16:54:14'),
(36, 21, 'PINGENTE DIFUSOR C/PONTEIRA BOLA MADEIRA', 7.0000, 'un', 'un', 1.6500, 11.55, NULL, 0.3149, '[{\"name\": \"ESS Interditada FEM Linha 1\", \"unit\": \"ml\", \"confidence\": 0.3149, \"raw_material_id\": 22}, {\"name\": \"ESSÊNCIA LIS BRANCO ALECRIM\", \"unit\": \"ml\", \"confidence\": 0.307, \"raw_material_id\": 28}, {\"name\": \"Tampa Disk TOP 24/415 Laranja\", \"unit\": \"un\", \"confidence\": 0.3013, \"raw_material_id\": 17}]', NULL, NULL, NULL, 1, 0, 1, 'Acessório', NULL, '2026-05-21 16:48:44', '2026-05-21 16:54:26'),
(37, 22, 'VIDRO AMBAR GPP 200ML 28/400 LAVADO', 20.0000, 'un', 'un', 1.1000, 22.00, NULL, 0.3885, '[{\"name\": \"Frasco PET 220ML Malta R. 24/415 Laranja\", \"unit\": \"un\", \"confidence\": 0.3885, \"raw_material_id\": 10}, {\"name\": \"Tampa Disk TOP 24/415 Laranja\", \"unit\": \"un\", \"confidence\": 0.3695, \"raw_material_id\": 17}, {\"name\": \"Frasco PET 220ml Malta R.24/415 Azul\", \"unit\": \"un\", \"confidence\": 0.3313, \"raw_material_id\": 11}]', NULL, NULL, NULL, 1, 0, 1, 'Embalagem', NULL, '2026-05-23 03:50:51', '2026-05-23 03:53:19'),
(38, 22, 'VALVULA SPRAY LUXO 28/410 SAIA PRETA/NAT', 10.0000, 'un', 'un', 1.7300, 17.28, NULL, 0.4533, '[{\"name\": \"Tampa Disk TOP 24/410 Luxo Prata Fosco\", \"unit\": \"un\", \"confidence\": 0.4533, \"raw_material_id\": 14}, {\"name\": \"Tampa Disk TOP 24/415 Laranja\", \"unit\": \"un\", \"confidence\": 0.3835, \"raw_material_id\": 17}, {\"name\": \"Tampa Disk TOP 24/415 Branca 27827\", \"unit\": \"un\", \"confidence\": 0.337, \"raw_material_id\": 16}]', NULL, NULL, NULL, 1, 0, 1, 'Embalagem', NULL, '2026-05-23 03:50:51', '2026-05-23 03:54:53'),
(39, 22, 'VALVULA GATILHO MINI 28/410 PRETA C/TRV', 10.0000, 'un', 'un', 1.4000, 13.99, NULL, 0.4369, '[{\"name\": \"Tampa Disk TOP 24/410 Luxo Prata Fosco\", \"unit\": \"un\", \"confidence\": 0.4369, \"raw_material_id\": 14}, {\"name\": \"VARETA MINI C/ ARGOLA 12CM\", \"unit\": \"un\", \"confidence\": 0.4189, \"raw_material_id\": 35}, {\"name\": \"VARETA FRAMBOESA MINI C/ARGOLA\", \"unit\": \"un\", \"confidence\": 0.407, \"raw_material_id\": 34}]', NULL, NULL, NULL, 1, 0, 1, 'Embalagem', NULL, '2026-05-23 03:50:51', '2026-05-23 03:55:34'),
(40, 23, 'FRASCO PET   35ML BASE VITA 20/410 36/10', 10.0000, 'un', 'un', 0.5400, 5.43, NULL, 0.6533, '[{\"name\": \"Frasco PET 300ml Cilreto saturno 24/410\", \"unit\": \"un\", \"confidence\": 0.6533, \"raw_material_id\": 13}, {\"name\": \"Frasco PET 220ml Malta R.24/415 Azul\", \"unit\": \"un\", \"confidence\": 0.6502, \"raw_material_id\": 11}, {\"name\": \"Frasco PET 220ML Malta R. 24/415 Laranja\", \"unit\": \"un\", \"confidence\": 0.62, \"raw_material_id\": 10}]', NULL, NULL, NULL, 1, 0, 1, 'Embalagem', NULL, '2026-05-23 03:57:11', '2026-05-23 03:59:48'),
(41, 23, 'FRASCO PET   30ML OVAL 20/410 R.35/10', 20.0000, 'un', 'un', 0.5500, 11.00, NULL, 0.7348, '[{\"name\": \"Frasco PET 300ml Cilreto saturno 24/410\", \"unit\": \"un\", \"confidence\": 0.7348, \"raw_material_id\": 13}, {\"name\": \"Frasco PET 220ml Malta R.24/415 Azul\", \"unit\": \"un\", \"confidence\": 0.6967, \"raw_material_id\": 11}, {\"name\": \"Frasco PET 220ML Malta R. 24/415 Laranja\", \"unit\": \"un\", \"confidence\": 0.6948, \"raw_material_id\": 10}]', NULL, NULL, NULL, 1, 0, 1, 'Embalagem', NULL, '2026-05-23 03:57:11', '2026-05-23 04:00:59'),
(42, 23, 'FRASCO PVC  30ML OVAL CRISTAL 18/410 F22', 10.0000, 'un', 'un', 0.5900, 5.95, NULL, 0.5754, '[{\"name\": \"Frasco PET 220ml Malta R.24/415 Azul\", \"unit\": \"un\", \"confidence\": 0.5754, \"raw_material_id\": 11}, {\"name\": \"Frasco PET 220ml Malta R.24/415 Cristal\", \"unit\": \"un\", \"confidence\": 0.5751, \"raw_material_id\": 12}, {\"name\": \"Frasco PET 300ml Cilreto saturno 24/410\", \"unit\": \"un\", \"confidence\": 0.5546, \"raw_material_id\": 13}]', NULL, NULL, NULL, 1, 0, 1, NULL, NULL, '2026-05-23 03:57:11', '2026-05-23 04:01:40'),
(43, 23, 'FRASCO PET   60ML OVAL 18/410 8G REF:120', 20.0000, 'un', 'un', 0.5600, 11.10, NULL, 0.6139, '[{\"name\": \"Frasco PET 220ml Malta R.24/415 Azul\", \"unit\": \"un\", \"confidence\": 0.6139, \"raw_material_id\": 11}, {\"name\": \"Frasco PET 300ml Cilreto saturno 24/410\", \"unit\": \"un\", \"confidence\": 0.6132, \"raw_material_id\": 13}, {\"name\": \"Frasco PET 220ML Malta R. 24/415 Laranja\", \"unit\": \"un\", \"confidence\": 0.6105, \"raw_material_id\": 10}]', NULL, NULL, NULL, 1, 0, 1, 'Embalagem', NULL, '2026-05-23 03:57:11', '2026-05-23 04:02:42'),
(44, 23, 'FRASCO PET   10ML CILINDRICO 18/410 BCO', 100.0000, 'un', 'un', 0.1900, 28.80, NULL, 0.6999, '[{\"name\": \"Frasco PET 300ml Cilreto saturno 24/410\", \"unit\": \"un\", \"confidence\": 0.6999, \"raw_material_id\": 13}, {\"name\": \"Frasco PET 220ml Malta R.24/415 Azul\", \"unit\": \"un\", \"confidence\": 0.6445, \"raw_material_id\": 11}, {\"name\": \"Frasco PET 220ml Malta R.24/415 Cristal\", \"unit\": \"un\", \"confidence\": 0.635, \"raw_material_id\": 12}]', NULL, NULL, NULL, 1, 0, 1, 'Embalagem', NULL, '2026-05-23 03:57:11', '2026-05-23 04:03:15'),
(45, 23, 'TAMPA FLIP TOP 18/410 PINK ISOS', 50.0000, 'un', 'un', 0.2800, 13.55, NULL, 0.6652, '[{\"name\": \"Tampa Disk TOP 24/410 Luxo Prata Fosco\", \"unit\": \"un\", \"confidence\": 0.6652, \"raw_material_id\": 14}, {\"name\": \"Tampa Disk TOP 24/415 Laranja\", \"unit\": \"un\", \"confidence\": 0.6002, \"raw_material_id\": 17}, {\"name\": \"Tampa Disk TOP 24/415 Branca 27827\", \"unit\": \"un\", \"confidence\": 0.599, \"raw_material_id\": 16}]', NULL, NULL, NULL, 1, 0, 1, NULL, NULL, '2026-05-23 03:57:11', '2026-05-23 04:03:52'),
(46, 23, 'TAMPA FLIP TOP OMEGA 18/410 MARROM', 60.0000, 'un', 'un', 0.1300, 7.50, NULL, 0.5978, '[{\"name\": \"Tampa Disk TOP 24/415 Laranja\", \"unit\": \"un\", \"confidence\": 0.5978, \"raw_material_id\": 17}, {\"name\": \"Tampa Disk TOP 24/410 Luxo Prata Fosco\", \"unit\": \"un\", \"confidence\": 0.564, \"raw_material_id\": 14}, {\"name\": \"Tampa Disk TOP 24/415 Natural R.27822\", \"unit\": \"un\", \"confidence\": 0.5283, \"raw_material_id\": 15}]', NULL, NULL, NULL, 1, 0, 1, NULL, NULL, '2026-05-23 03:57:11', '2026-05-23 04:05:06'),
(47, 23, 'TAMPA FLIP TOP 18/410 PRETA ABAULADA IS', 20.0000, 'un', 'un', 0.2800, 5.42, NULL, 0.6431, '[{\"name\": \"Tampa Disk TOP 24/410 Luxo Prata Fosco\", \"unit\": \"un\", \"confidence\": 0.6431, \"raw_material_id\": 14}, {\"name\": \"Tampa Disk TOP 24/415 Laranja\", \"unit\": \"un\", \"confidence\": 0.5866, \"raw_material_id\": 17}, {\"name\": \"Tampa Disk TOP 24/415 Branca 27827\", \"unit\": \"un\", \"confidence\": 0.5636, \"raw_material_id\": 16}]', NULL, NULL, NULL, 1, 0, 1, 'Embalagem', NULL, '2026-05-23 03:57:11', '2026-05-23 04:05:51'),
(48, 23, 'TAMPA FLIP TOP OMEGA 20/410 VERDE R.45', 20.0000, 'un', 'un', 0.1600, 3.10, NULL, 0.568, '[{\"name\": \"Tampa Disk TOP 24/415 Laranja\", \"unit\": \"un\", \"confidence\": 0.568, \"raw_material_id\": 17}, {\"name\": \"Tampa Disk TOP 24/415 Natural R.27822\", \"unit\": \"un\", \"confidence\": 0.5606, \"raw_material_id\": 15}, {\"name\": \"Tampa Disk TOP 24/410 Luxo Prata Fosco\", \"unit\": \"un\", \"confidence\": 0.5526, \"raw_material_id\": 14}]', NULL, NULL, NULL, 1, 0, 1, 'Embalagem', NULL, '2026-05-23 03:57:12', '2026-05-23 04:06:37'),
(49, 23, 'TAMPA FLIP TOP OMEGA 20/410 LILAS 08', 5.0000, 'un', 'un', 0.1500, 0.75, NULL, 0.6174, '[{\"name\": \"Tampa Disk TOP 24/415 Laranja\", \"unit\": \"un\", \"confidence\": 0.6174, \"raw_material_id\": 17}, {\"name\": \"Tampa Disk TOP 24/410 Luxo Prata Fosco\", \"unit\": \"un\", \"confidence\": 0.5879, \"raw_material_id\": 14}, {\"name\": \"Tampa Disk TOP 24/415 Natural R.27822\", \"unit\": \"un\", \"confidence\": 0.536, \"raw_material_id\": 15}]', NULL, NULL, NULL, 1, 0, 1, 'Embalagem', NULL, '2026-05-23 03:57:12', '2026-05-23 04:07:27'),
(50, 23, 'FRASCO AMBAR PET  35ML BASE VIT 20/41 36', 10.0000, 'un', 'un', 0.6000, 0.60, NULL, 0.593, '[{\"name\": \"Frasco PET 220ml Malta R.24/415 Azul\", \"unit\": \"un\", \"confidence\": 0.593, \"raw_material_id\": 11}, {\"name\": \"Frasco PET 300ml Cilreto saturno 24/410\", \"unit\": \"un\", \"confidence\": 0.559, \"raw_material_id\": 13}, {\"name\": \"Frasco PET 220ML Malta R. 24/415 Laranja\", \"unit\": \"un\", \"confidence\": 0.5487, \"raw_material_id\": 10}]', NULL, NULL, NULL, 1, 0, 1, 'Embalagem', NULL, '2026-05-23 03:57:12', '2026-05-23 04:08:15'),
(51, 23, 'FRASCO PET  140ML OVAL CRIST.24/415 5969', 50.0000, 'un', 'un', 1.2400, 61.80, NULL, 0.7741, '[{\"name\": \"Frasco PET 220ml Malta R.24/415 Azul\", \"unit\": \"un\", \"confidence\": 0.7741, \"raw_material_id\": 11}, {\"name\": \"Frasco PET 220ML Malta R. 24/415 Laranja\", \"unit\": \"un\", \"confidence\": 0.7267, \"raw_material_id\": 10}, {\"name\": \"Frasco PET 220ml Malta R.24/415 Cristal\", \"unit\": \"un\", \"confidence\": 0.7267, \"raw_material_id\": 12}]', NULL, NULL, NULL, 1, 0, 1, 'Embalagem', NULL, '2026-05-23 03:57:12', '2026-05-23 04:09:04'),
(52, 23, 'POTE  04GRS.CRISTAL/BRANCO C/TP CORES', 2.0000, 'un', 'un', 25.9900, 52.00, NULL, 0.4622, '[{\"name\": \"ESSÊNCIA LIS BRANCO ALECRIM\", \"unit\": \"ml\", \"confidence\": 0.4622, \"raw_material_id\": 28}, {\"name\": \"ESS ROSAS BRANCAS- LESSENCE\", \"unit\": \"ml\", \"confidence\": 0.4348, \"raw_material_id\": 9}, {\"name\": \"BISNAGA BRANCA PE 60G – DZ\", \"unit\": \"un\", \"confidence\": 0.34, \"raw_material_id\": 1}]', NULL, NULL, NULL, 1, 0, 1, 'Embalagem', NULL, '2026-05-23 03:57:12', '2026-05-23 04:10:48'),
(53, 23, 'POTE 500GRS.OVAL PRATA TP FIO OURO/PRATA', 2.0000, 'un', 'un', 2.7000, 5.40, NULL, 0.3833, '[{\"name\": \"Tampa Disk TOP 24/410 Luxo Prata Fosco\", \"unit\": \"un\", \"confidence\": 0.3833, \"raw_material_id\": 14}, {\"name\": \"Frasco PET 220ML Malta R. 24/415 Laranja\", \"unit\": \"un\", \"confidence\": 0.333, \"raw_material_id\": 10}, {\"name\": \"ESS LAVANDA FRANCESA - OAK\", \"unit\": \"ml\", \"confidence\": 0.325, \"raw_material_id\": 5}]', NULL, NULL, NULL, 1, 0, 1, 'Embalagem', NULL, '2026-05-23 03:57:12', '2026-05-23 04:11:13'),
(54, 24, 'ESS LAVANDA & ALGODAO MAHOGANY-ISAN', 400.0000, 'LT', 'ml', 0.2800, 112.00, 6, 1, '[{\"name\": \"ESS LAVANDA & ALGODAO MAHOGANY- ISAN\", \"unit\": \"ml\", \"confidence\": 1, \"raw_material_id\": 6}, {\"name\": \"ESS LAVANDA FRANCESA - OAK\", \"unit\": \"ml\", \"confidence\": 0.6108, \"raw_material_id\": 5}, {\"name\": \"ESS LAVANDA INGLESA - OAK\", \"unit\": \"ml\", \"confidence\": 0.5954, \"raw_material_id\": 4}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-23 04:12:01', '2026-05-23 04:25:32'),
(55, 24, 'ESS SCANDALO JEAN PAUL FEM - DOMO', 100.0000, 'LT', 'ml', 0.4000, 40.00, NULL, 0.5215, '[{\"name\": \"ESS ALMISCAR - DOMO\", \"unit\": \"ml\", \"confidence\": 0.5215, \"raw_material_id\": 8}, {\"name\": \"ESS LAVANDA FRANCESA - OAK\", \"unit\": \"ml\", \"confidence\": 0.4718, \"raw_material_id\": 5}, {\"name\": \"ESS LAVANDA & ALGODAO MAHOGANY- ISAN\", \"unit\": \"ml\", \"confidence\": 0.46, \"raw_material_id\": 6}]', NULL, NULL, NULL, 1, 0, 1, 'Essência', NULL, '2026-05-23 04:12:01', '2026-05-23 04:16:01'),
(56, 24, 'ESS ARABE FAKAR BLACK UNISEX 50ML', 50.0000, 'UN', 'ml', 0.9000, 45.00, NULL, 0.3861, '[{\"name\": \"ESS LAVANDA FRANCESA - OAK\", \"unit\": \"ml\", \"confidence\": 0.3861, \"raw_material_id\": 5}, {\"name\": \"ESS La Vita Linha 1\", \"unit\": \"ml\", \"confidence\": 0.3744, \"raw_material_id\": 23}, {\"name\": \"ESS ROSAS BRANCAS- LESSENCE\", \"unit\": \"ml\", \"confidence\": 0.3701, \"raw_material_id\": 9}]', NULL, NULL, NULL, 1, 0, 1, 'Essência', NULL, '2026-05-23 04:12:01', '2026-05-23 04:18:25'),
(57, 24, 'ESS ARABE ROYAL AMBER UNISEX', 50.0000, 'UN', 'un', 0.9000, 45.00, NULL, 0.473, '[{\"name\": \"ESS LAVANDA & ALGODAO MAHOGANY- ISAN\", \"unit\": \"ml\", \"confidence\": 0.473, \"raw_material_id\": 6}, {\"name\": \"ESS CEDRO SABONETE\", \"unit\": \"ml\", \"confidence\": 0.4319, \"raw_material_id\": 29}, {\"name\": \"ESS LAVANDA PROVENCE - LESS\", \"unit\": \"ml\", \"confidence\": 0.4176, \"raw_material_id\": 7}]', NULL, NULL, NULL, 1, 0, 1, 'Essência', NULL, '2026-05-23 04:12:01', '2026-05-23 04:20:05'),
(58, 24, 'ESS ARABE DELINIA LA ROSÉ FEM.', 50.0000, 'UN', 'ml', 0.9000, 45.00, NULL, 0.4915, '[{\"name\": \"ESS G. Armani My Way FEM Linha 1\", \"unit\": \"ml\", \"confidence\": 0.4915, \"raw_material_id\": 21}, {\"name\": \"ESS Interditada FEM Linha 1\", \"unit\": \"ml\", \"confidence\": 0.4912, \"raw_material_id\": 22}, {\"name\": \"ESS La Vita Linha 1\", \"unit\": \"ml\", \"confidence\": 0.4344, \"raw_material_id\": 23}]', NULL, NULL, NULL, 1, 0, 1, 'Essência', NULL, '2026-05-23 04:12:01', '2026-05-23 04:21:11'),
(59, 24, 'BASE PARA BODY SPLASH', 2.0000, 'LT', 'L', 18.0000, 36.00, NULL, 0.3498, '[{\"name\": \"ESSÊNCIA BERGAMOTA ROSA\", \"unit\": \"ml\", \"confidence\": 0.3498, \"raw_material_id\": 26}, {\"name\": \"VARETA ESTRELA MADEIRA PEQUENA\", \"unit\": \"un\", \"confidence\": 0.342, \"raw_material_id\": 33}, {\"name\": \"ESS LAVANDA & ALGODAO MAHOGANY- ISAN\", \"unit\": \"ml\", \"confidence\": 0.3313, \"raw_material_id\": 6}]', NULL, NULL, NULL, 1, 0, 1, 'Base', NULL, '2026-05-23 04:12:01', '2026-05-23 04:21:38'),
(60, 24, 'FRASCO PET 200ML R 24/410 CRISTAL AURA C/TP', 10.0000, 'UN', 'un', 2.6500, 26.50, NULL, 0.7862, '[{\"name\": \"Frasco PET 220ml Malta R.24/415 Cristal\", \"unit\": \"un\", \"confidence\": 0.7862, \"raw_material_id\": 12}, {\"name\": \"FRASCO PET   30ML OVAL 20/410 R.35/10\", \"unit\": \"un\", \"confidence\": 0.6893, \"raw_material_id\": 41}, {\"name\": \"Frasco PET 220ML Malta R. 24/415 Laranja\", \"unit\": \"un\", \"confidence\": 0.6664, \"raw_material_id\": 10}]', NULL, NULL, NULL, 1, 0, 1, 'Embalagem', NULL, '2026-05-23 04:12:01', '2026-05-23 04:22:09'),
(61, 24, 'VALVULA SPRAY R.24/410 OURO HOT STAMP', 10.0000, 'UN', 'un', 1.6500, 16.50, NULL, 0.704, '[{\"name\": \"VALVULA SPRAY LUXO 28/410 SAIA PRETA/NAT\", \"unit\": \"un\", \"confidence\": 0.704, \"raw_material_id\": 38}, {\"name\": \"VALVULA GATILHO MINI 28/410 PRETA C/TRV\", \"unit\": \"un\", \"confidence\": 0.5466, \"raw_material_id\": 39}, {\"name\": \"Tampa Disk TOP 24/410 Luxo Prata Fosco\", \"unit\": \"un\", \"confidence\": 0.4687, \"raw_material_id\": 14}]', NULL, NULL, NULL, 1, 0, 1, 'Embalagem', NULL, '2026-05-23 04:12:01', '2026-05-23 04:22:25'),
(62, 24, 'BASE P PERFUME VEICULO 1LT', 1.0000, 'LT', 'L', 18.0000, 18.00, NULL, 0.324, '[{\"name\": \"FRASCO PET   35ML BASE VITA 20/410 36/10\", \"unit\": \"un\", \"confidence\": 0.324, \"raw_material_id\": 40}, {\"name\": \"FRASCO AMBAR PET  35ML BASE VIT 20/41 36\", \"unit\": \"un\", \"confidence\": 0.3208, \"raw_material_id\": 50}, {\"name\": \"FRASCO PET   10ML CILINDRICO 18/410 BCO\", \"unit\": \"un\", \"confidence\": 0.3176, \"raw_material_id\": 44}]', NULL, NULL, NULL, 1, 0, 1, 'Base', NULL, '2026-05-23 04:12:01', '2026-05-23 04:24:50'),
(63, 24, 'POTE DE VIDRO REDONDO 30ML C/TP', 10.0000, 'UN', 'un', 3.8500, 38.50, NULL, 0.4341, '[{\"name\": \"POTE  04GRS.CRISTAL/BRANCO C/TP CORES\", \"unit\": \"un\", \"confidence\": 0.4341, \"raw_material_id\": 52}, {\"name\": \"POTE 500GRS.OVAL PRATA TP FIO OURO/PRATA\", \"unit\": \"un\", \"confidence\": 0.3897, \"raw_material_id\": 53}, {\"name\": \"ESS CEDRO SABONETE\", \"unit\": \"ml\", \"confidence\": 0.361, \"raw_material_id\": 29}]', NULL, NULL, NULL, 1, 0, 1, 'Embalagem', NULL, '2026-05-23 04:12:01', '2026-05-23 04:25:15'),
(64, 25, 'TAMPA PLAST. POTE MET. DOURADA TRADITION', 1.0000, 'PC', 'un', 2.0000, 2.00, NULL, 0.4833, '[{\"name\": \"TAMPA FLIP TOP 18/410 PRETA ABAULADA IS\", \"unit\": \"un\", \"confidence\": 0.4833, \"raw_material_id\": 47}, {\"name\": \"Tampa Disk TOP 24/415 Branca 27827\", \"unit\": \"un\", \"confidence\": 0.4035, \"raw_material_id\": 16}, {\"name\": \"Tampa Disk TOP 24/410 Luxo Prata Fosco\", \"unit\": \"un\", \"confidence\": 0.3965, \"raw_material_id\": 14}]', NULL, NULL, NULL, 1, 0, 1, 'Embalagem', NULL, '2026-05-23 04:39:15', '2026-05-23 04:41:28'),
(65, 25, 'POTE PET 1LT WHEY ROSA', 1.0000, 'UN', 'un', 3.0000, 3.00, NULL, 0.441, '[{\"name\": \"POTE 500GRS.OVAL PRATA TP FIO OURO/PRATA\", \"unit\": \"un\", \"confidence\": 0.441, \"raw_material_id\": 53}, {\"name\": \"Frasco PET 220ml Malta R.24/415 Cristal\", \"unit\": \"un\", \"confidence\": 0.3991, \"raw_material_id\": 12}, {\"name\": \"POTE DE VIDRO REDONDO 30ML C/TP\", \"unit\": \"un\", \"confidence\": 0.3825, \"raw_material_id\": 62}]', NULL, NULL, NULL, 1, 0, 1, 'Embalagem', NULL, '2026-05-23 04:39:15', '2026-05-23 04:42:01'),
(66, 25, 'ESS.CLASSIC 7 ERVAS R.CC113 DOMO', 100.0000, 'UN', 'ml', 0.1800, 20.00, NULL, 0.5028, '[{\"name\": \"ESS SCANDALO JEAN PAUL FEM - DOMO\", \"unit\": \"ml\", \"confidence\": 0.5028, \"raw_material_id\": 54}, {\"name\": \"ESS ALMISCAR - DOMO\", \"unit\": \"ml\", \"confidence\": 0.4759, \"raw_material_id\": 8}, {\"name\": \"ESS La Vita Linha 1\", \"unit\": \"ml\", \"confidence\": 0.3807, \"raw_material_id\": 23}]', NULL, NULL, NULL, 1, 0, 1, 'Essência', NULL, '2026-05-23 04:39:15', '2026-05-23 04:43:01'),
(67, 25, 'ESS.CLASSIC CAFE  R GC0059 DOMO', 100.0000, 'UN', 'ml', 0.2000, 20.00, NULL, 0.5392, '[{\"name\": \"ESS ALMISCAR - DOMO\", \"unit\": \"ml\", \"confidence\": 0.5392, \"raw_material_id\": 8}, {\"name\": \"ESS SCANDALO JEAN PAUL FEM - DOMO\", \"unit\": \"ml\", \"confidence\": 0.4798, \"raw_material_id\": 54}, {\"name\": \"ESS La Vita Linha 1\", \"unit\": \"ml\", \"confidence\": 0.3956, \"raw_material_id\": 23}]', NULL, NULL, NULL, 1, 0, 1, 'Essência', NULL, '2026-05-23 04:39:15', '2026-05-23 04:44:05'),
(68, 25, 'ESS.CLASSIC DOVE  17.013 DOMO ZZZ', 100.0000, 'UN', 'ml', 0.1800, 16.00, NULL, 0.4549, '[{\"name\": \"ESS SCANDALO JEAN PAUL FEM - DOMO\", \"unit\": \"ml\", \"confidence\": 0.4549, \"raw_material_id\": 54}, {\"name\": \"ESS ALMISCAR - DOMO\", \"unit\": \"ml\", \"confidence\": 0.4235, \"raw_material_id\": 8}, {\"name\": \"ESS LAVANDA PROVENCE - LESS\", \"unit\": \"ml\", \"confidence\": 0.3519, \"raw_material_id\": 7}]', NULL, NULL, NULL, 1, 0, 1, 'Essência', NULL, '2026-05-23 04:39:15', '2026-05-23 04:44:50'),
(69, 25, 'ESSENCIA P/AROMATIZADOR MARVEL', 200.0000, 'UN', 'ml', 0.1000, 20.00, NULL, 0.4784, '[{\"name\": \"ESSÊNCIA BERGAMOTA ROSA\", \"unit\": \"ml\", \"confidence\": 0.4784, \"raw_material_id\": 26}, {\"name\": \"ESSÊNCIA LANCOM LA NUITE LINHA 1\", \"unit\": \"ml\", \"confidence\": 0.4758, \"raw_material_id\": 24}, {\"name\": \"ESSÊNCIA BAMBOO\", \"unit\": \"ml\", \"confidence\": 0.434, \"raw_material_id\": 27}]', NULL, NULL, NULL, 1, 0, 1, 'Essência', NULL, '2026-05-23 04:39:15', '2026-05-23 04:46:29'),
(70, 28, 'Creme Hidratante Concent 1x4 1kg yant/gi', 2.0000, 'un', 'un', 27.4900, NULL, 18, 1, '[{\"name\": \"Creme Hidratante Concent 1x4 1kg yant/gi\", \"unit\": \"kg\", \"confidence\": 1, \"raw_material_id\": 18}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-23 05:40:37', '2026-05-23 05:40:37'),
(71, 28, 'ESSÊNCIA AMACIANTE DOWNY AZUL', 100.0000, 'ml', 'ml', 0.2000, NULL, 69, 1, '[{\"name\": \"ESSÊNCIA AMACIANTE DOWNY AZUL\", \"unit\": \"ml\", \"confidence\": 1, \"raw_material_id\": 69}, {\"name\": \"ESSENCIA P/AROMATIZADOR MARVEL\", \"unit\": \"ml\", \"confidence\": 0.6231, \"raw_material_id\": 68}, {\"name\": \"ESSÊNCIA CASCA E FOLHA OAK\", \"unit\": \"ml\", \"confidence\": 0.606, \"raw_material_id\": 76}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-23 05:40:37', '2026-05-23 05:40:37'),
(72, 28, 'ESSÊNCIA ARTEMISA OAK', 100.0000, 'ml', 'ml', 0.1900, NULL, 70, 1, '[{\"name\": \"ESSÊNCIA ARTEMISA OAK\", \"unit\": \"ml\", \"confidence\": 1, \"raw_material_id\": 70}, {\"name\": \"ESSÊNCIA ARRUDA OAK\", \"unit\": \"ml\", \"confidence\": 0.9181, \"raw_material_id\": 73}, {\"name\": \"ESSÊNCIA ALECRIM OAK\", \"unit\": \"ml\", \"confidence\": 0.8873, \"raw_material_id\": 71}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-23 05:40:37', '2026-05-23 05:40:37'),
(73, 28, 'ESSÊNCIA ALECRIM OAK', 100.0000, 'ml', 'ml', 0.1900, NULL, 71, 1, '[{\"name\": \"ESSÊNCIA ALECRIM OAK\", \"unit\": \"ml\", \"confidence\": 1, \"raw_material_id\": 71}, {\"name\": \"ESSÊNCIA ARTEMISA OAK\", \"unit\": \"ml\", \"confidence\": 0.8873, \"raw_material_id\": 70}, {\"name\": \"ESSÊNCIA ARRUDA OAK\", \"unit\": \"ml\", \"confidence\": 0.8749, \"raw_material_id\": 73}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-23 05:40:37', '2026-05-23 05:40:37'),
(74, 28, 'ESSÊNCIA DASLU OAK', 100.0000, 'ml', 'ml', 0.1900, NULL, 72, 1, '[{\"name\": \"ESSÊNCIA DASLU OAK\", \"unit\": \"ml\", \"confidence\": 1, \"raw_material_id\": 72}, {\"name\": \"ESSÊNCIA ARRUDA OAK\", \"unit\": \"ml\", \"confidence\": 0.9146, \"raw_material_id\": 73}, {\"name\": \"ESSÊNCIA ALECRIM OAK\", \"unit\": \"ml\", \"confidence\": 0.867, \"raw_material_id\": 71}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-23 05:40:37', '2026-05-23 05:40:37'),
(75, 28, 'ESSÊNCIA VIP BLACK VOLLMENS', 50.0000, 'ml', 'ml', 0.6000, NULL, 75, 1, '[{\"name\": \"ESSÊNCIA VIP BLACK VOLLMENS\", \"unit\": \"ml\", \"confidence\": 1, \"raw_material_id\": 75}, {\"name\": \"ESSÊNCIA PATCHOLY\", \"unit\": \"ml\", \"confidence\": 0.6244, \"raw_material_id\": 30}, {\"name\": \"ESSÊNCIA LIS BRANCO ALECRIM\", \"unit\": \"ml\", \"confidence\": 0.6056, \"raw_material_id\": 28}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-23 05:40:37', '2026-05-23 05:40:37'),
(76, 28, 'ESSÊNCIA GOOD GIRL FEM', 50.0000, 'ml', 'ml', 0.6500, NULL, 78, 1, '[{\"name\": \"ESSÊNCIA GOOD GIRL FEM\", \"unit\": \"ml\", \"confidence\": 1, \"raw_material_id\": 78}, {\"name\": \"ESSÊNCIA INTERDIT FEM LINHA 1\", \"unit\": \"ml\", \"confidence\": 0.6323, \"raw_material_id\": 22}, {\"name\": \"ESSÊNCIA SCANDALO JEAN PAUL FEM - DOMO\", \"unit\": \"ml\", \"confidence\": 0.6088, \"raw_material_id\": 54}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-23 05:40:37', '2026-05-23 05:40:37'),
(77, 28, 'ESSÊNCIA ARRUDA OAK', 100.0000, 'ml', 'ml', 0.1900, NULL, 73, 1, '[{\"name\": \"ESSÊNCIA ARRUDA OAK\", \"unit\": \"ml\", \"confidence\": 1, \"raw_material_id\": 73}, {\"name\": \"ESSÊNCIA ARTEMISA OAK\", \"unit\": \"ml\", \"confidence\": 0.9181, \"raw_material_id\": 70}, {\"name\": \"ESSÊNCIA DASLU OAK\", \"unit\": \"ml\", \"confidence\": 0.9146, \"raw_material_id\": 72}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-23 05:40:37', '2026-05-23 05:40:37'),
(78, 28, 'BODY SPLASH NEUTRO YANTRA', 1.0000, 'L', NULL, 14.9900, NULL, 74, 1, '[{\"name\": \"BODY SPLASH NEUTRO YANTRA\", \"unit\": \"L\", \"confidence\": 1, \"raw_material_id\": 74}, {\"name\": \"SABONETE LIQUIDO AROMAS YANTRA\", \"unit\": \"un\", \"confidence\": 0.4936, \"raw_material_id\": 31}, {\"name\": \"BASE PARA BODY SPLASH\", \"unit\": \"L\", \"confidence\": 0.483, \"raw_material_id\": 58}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-23 05:40:37', '2026-05-23 05:40:37'),
(79, 28, 'SABONETE LIQUIDO AROMAS YANTRA', 2.0000, 'L', NULL, 8.9900, NULL, 31, 1, '[{\"name\": \"SABONETE LIQUIDO AROMAS YANTRA\", \"unit\": \"un\", \"confidence\": 1, \"raw_material_id\": 31}, {\"name\": \"BODY SPLASH NEUTRO YANTRA\", \"unit\": \"L\", \"confidence\": 0.5155, \"raw_material_id\": 74}, {\"name\": \"VARETA MINI C/ ARGOLA 12CM\", \"unit\": \"un\", \"confidence\": 0.3867, \"raw_material_id\": 35}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-23 05:40:37', '2026-05-23 05:40:37'),
(80, 28, 'ESSÊNCIA BAMBOO', 100.0000, 'ml', 'ml', 0.1900, NULL, 27, 1, '[{\"name\": \"ESSÊNCIA BAMBOO\", \"unit\": \"ml\", \"confidence\": 1, \"raw_material_id\": 27}, {\"name\": \"ESSÊNCIA PATCHOLY\", \"unit\": \"ml\", \"confidence\": 0.7713, \"raw_material_id\": 30}, {\"name\": \"ESSÊNCIA BERGAMOTA ROSA\", \"unit\": \"ml\", \"confidence\": 0.7682, \"raw_material_id\": 26}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-23 05:40:37', '2026-05-23 05:40:37'),
(81, 28, 'ESSÊNCIA CASCA E FOLHA OAK', 100.0000, 'ml', 'ml', 0.1900, NULL, 76, 1, '[{\"name\": \"ESSÊNCIA CASCA E FOLHA OAK\", \"unit\": \"ml\", \"confidence\": 1, \"raw_material_id\": 76}, {\"name\": \"ESSÊNCIA DASLU OAK\", \"unit\": \"ml\", \"confidence\": 0.7825, \"raw_material_id\": 72}, {\"name\": \"ESSÊNCIA ARTEMISA OAK\", \"unit\": \"ml\", \"confidence\": 0.7547, \"raw_material_id\": 70}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-23 05:40:37', '2026-05-23 05:40:37'),
(82, 28, 'TAMPA FLIP TOP OMEGA 24/415 BRANCA', 50.0000, 'un', 'un', 0.4500, NULL, 77, 1, '[{\"name\": \"TAMPA FLIP TOP OMEGA 24/415 BRANCA\", \"unit\": \"un\", \"confidence\": 1, \"raw_material_id\": 77}, {\"name\": \"TAMPA FLIP TOP OMEGA 20/410 LILAS 08\", \"unit\": \"un\", \"confidence\": 0.8962, \"raw_material_id\": 49}, {\"name\": \"TAMPA FLIP TOP OMEGA 18/410 MARROM\", \"unit\": \"un\", \"confidence\": 0.8863, \"raw_material_id\": 46}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-05-23 05:40:37', '2026-05-23 05:40:37'),
(83, 29, 'FRASCO PET 200ML R.24/410 CRISTAL AURA C/TP', 30.0000, 'UN', 'un', 2.6500, 79.50, 59, 1, '[{\"name\": \"FRASCO PET 200ML R 24/410 CRISTAL AURA C/TP - Body Splash\", \"unit\": \"un\", \"confidence\": 1, \"raw_material_id\": 59}, {\"name\": \"FRASCO PET 220ml MALTA R.24/415 CRISTAL - INTIMO\", \"unit\": \"un\", \"confidence\": 0.7971, \"raw_material_id\": 12}, {\"name\": \"FRASCO PET   30ML OVAL 20/410 R.35/10\", \"unit\": \"un\", \"confidence\": 0.6893, \"raw_material_id\": 41}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-03 17:52:37', '2026-06-03 17:53:36'),
(84, 29, 'FRASCO PET 100ML R.24/410 CRISTAL ACQUA - Body Splash', 30.0000, 'PC', 'un', 1.6500, 49.50, NULL, 0.8547, '[{\"name\": \"FRASCO PET 200ML R 24/410 CRISTAL AURA C/TP - Body Splash\", \"unit\": \"un\", \"confidence\": 0.8547, \"raw_material_id\": 59}, {\"name\": \"FRASCO PET 220ml MALTA R.24/415 CRISTAL - INTIMO\", \"unit\": \"un\", \"confidence\": 0.8072, \"raw_material_id\": 12}, {\"name\": \"FRASCO PET   30ML OVAL 20/410 R.35/10\", \"unit\": \"un\", \"confidence\": 0.7046, \"raw_material_id\": 41}]', NULL, NULL, NULL, 1, 0, 1, NULL, NULL, '2026-06-03 17:52:37', '2026-06-03 17:54:57'),
(85, 29, 'VALVULA SPRAY R.24/410 OURO HOT STAMP', 60.0000, 'UN', 'un', 1.6500, 99.00, 60, 1, '[{\"name\": \"VALVULA SPRAY R.24/410 OURO HOT STAMP - BODY SPLASH\", \"unit\": \"un\", \"confidence\": 1, \"raw_material_id\": 60}, {\"name\": \"VALVULA SPRAY LUXO 28/410 SAIA PRETA/NAT\", \"unit\": \"un\", \"confidence\": 0.704, \"raw_material_id\": 38}, {\"name\": \"VALVULA GATILHO MINI 28/410 PRETA C/TRV\", \"unit\": \"un\", \"confidence\": 0.5466, \"raw_material_id\": 39}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-03 17:52:37', '2026-06-03 17:55:09'),
(86, 29, 'ESS ARABE ROYAL AMBER UNISEX LESS', 100.0000, 'UN', 'ml', 0.9000, 90.00, 56, 1, '[{\"name\": \"ESSÊNCIA ARABE ROYAL AMBER UNISEX\", \"unit\": \"un\", \"confidence\": 0.9212, \"raw_material_id\": 56}, {\"name\": \"ESSÊNCIA ARABE FAKAR BLACK UNISEX 50ML\", \"unit\": \"ml\", \"confidence\": 0.6321, \"raw_material_id\": 55}, {\"name\": \"ESSÊNCIA LAVANDA PROVENCE - LESS\", \"unit\": \"ml\", \"confidence\": 0.5147, \"raw_material_id\": 7}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-03 17:52:37', '2026-06-03 17:56:42'),
(87, 29, 'ESS LAVANDA INGLESA - OAK OAK - 5169', 100.0000, 'LT', 'ml', 0.2600, 26.00, 4, 1, '[{\"name\": \"ESSÊNCIA LAVANDA INGLESA - OAK\", \"unit\": \"ml\", \"confidence\": 0.8183, \"raw_material_id\": 4}, {\"name\": \"ESSÊNCIA LAVANDA FRANCESA - OAK\", \"unit\": \"ml\", \"confidence\": 0.6559, \"raw_material_id\": 5}, {\"name\": \"ESSÊNCIA ARTEMISA OAK\", \"unit\": \"ml\", \"confidence\": 0.4985, \"raw_material_id\": 70}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-03 17:52:37', '2026-06-03 17:57:20'),
(88, 29, 'ESS LAVANDA FRANCESA - OAK OAK 51690', 100.0000, 'LT', 'ml', 0.2400, 24.00, 5, 1, '[{\"name\": \"ESSÊNCIA LAVANDA FRANCESA - OAK\", \"unit\": \"ml\", \"confidence\": 0.814, \"raw_material_id\": 5}, {\"name\": \"ESSÊNCIA LAVANDA INGLESA - OAK\", \"unit\": \"ml\", \"confidence\": 0.6518, \"raw_material_id\": 4}, {\"name\": \"ESSÊNCIA ARTEMISA OAK\", \"unit\": \"ml\", \"confidence\": 0.5133, \"raw_material_id\": 70}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-03 17:52:37', '2026-06-03 17:57:39'),
(89, 29, 'ESS LAVANDA PROVENCE - LESS LAP 28675', 100.0000, 'LT', 'ml', 0.2500, 25.00, 7, 1, '[{\"name\": \"ESSÊNCIA LAVANDA PROVENCE - LESS\", \"unit\": \"ml\", \"confidence\": 0.7901, \"raw_material_id\": 7}, {\"name\": \"ESSÊNCIA LAVANDA FRANCESA - OAK\", \"unit\": \"ml\", \"confidence\": 0.5308, \"raw_material_id\": 5}, {\"name\": \"ESSÊNCIA LAVANDA INGLESA - OAK\", \"unit\": \"ml\", \"confidence\": 0.5248, \"raw_material_id\": 4}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-03 17:52:37', '2026-06-03 17:57:57'),
(90, 29, 'ESS SCANDALO JEAN PAUL FEM - DOMO', 100.0000, 'LT', 'ml', 0.4000, 40.00, 54, 1, '[{\"name\": \"ESSÊNCIA SCANDALO JEAN PAUL FEM - DOMO\", \"unit\": \"ml\", \"confidence\": 1, \"raw_material_id\": 54}, {\"name\": \"ESSÊNCIA  ALMISCAR - DOMO\", \"unit\": \"ml\", \"confidence\": 0.4599, \"raw_material_id\": 8}, {\"name\": \"ESSÊNCIA GOOD GIRL FEM\", \"unit\": \"ml\", \"confidence\": 0.4372, \"raw_material_id\": 78}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-03 17:52:37', '2026-06-03 17:58:21'),
(91, 29, 'ESS ARABE ASSAD BOURBON MASC.', 50.0000, 'UN', 'ml', 0.9000, 45.00, NULL, 0.628, '[{\"name\": \"ESSÊNCIA ARABE FAKAR BLACK UNISEX 50ML\", \"unit\": \"ml\", \"confidence\": 0.628, \"raw_material_id\": 55}, {\"name\": \"ESSENCIA P/AROMATIZADOR MARVEL\", \"unit\": \"ml\", \"confidence\": 0.4069, \"raw_material_id\": 68}, {\"name\": \"ESSÊNCIA ARABE DELINIA LA ROSÉ FEM.\", \"unit\": \"ml\", \"confidence\": 0.4017, \"raw_material_id\": 57}]', NULL, NULL, NULL, 1, 0, 1, NULL, NULL, '2026-06-03 17:52:37', '2026-06-03 17:59:21'),
(92, 29, 'ESS ARABE ASSAD MASC. LESS', 50.0000, 'UN', 'ml', 0.9000, 45.00, NULL, 0.5246, '[{\"name\": \"ESSÊNCIA ARABE FAKAR BLACK UNISEX 50ML\", \"unit\": \"ml\", \"confidence\": 0.5246, \"raw_material_id\": 55}, {\"name\": \"ESSÊNCIA ARABE ROYAL AMBER UNISEX\", \"unit\": \"un\", \"confidence\": 0.4645, \"raw_material_id\": 56}, {\"name\": \"ESSÊNCIA ARABE DELINIA LA ROSÉ FEM.\", \"unit\": \"ml\", \"confidence\": 0.437, \"raw_material_id\": 57}]', NULL, NULL, NULL, 1, 0, 1, NULL, NULL, '2026-06-03 17:52:37', '2026-06-03 17:59:58'),
(93, 29, 'BASE PARA BODY SPLASH', 8.0000, 'LT', 'L', 18.0000, 144.00, 58, 1, '[{\"name\": \"BASE PARA BODY SPLASH\", \"unit\": \"L\", \"confidence\": 1, \"raw_material_id\": 58}, {\"name\": \"VALVULA SPRAY R.24/410 OURO HOT STAMP - BODY SPLASH\", \"unit\": \"un\", \"confidence\": 0.5384, \"raw_material_id\": 60}, {\"name\": \"FRASCO PET 200ML R 24/410 CRISTAL AURA C/TP - Body Splash\", \"unit\": \"un\", \"confidence\": 0.5382, \"raw_material_id\": 59}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-03 17:52:37', '2026-06-03 18:00:22'),
(94, 29, 'BASE PARA BODY SPLASH S/MICA', 2.0000, 'PC', 'L', 16.0000, 32.00, NULL, 0.9743, '[{\"name\": \"BASE PARA BODY SPLASH\", \"unit\": \"L\", \"confidence\": 0.9743, \"raw_material_id\": 58}, {\"name\": \"BODY SPLASH NEUTRO YANTRA\", \"unit\": \"L\", \"confidence\": 0.497, \"raw_material_id\": 74}, {\"name\": \"VALVULA SPRAY R.24/410 OURO HOT STAMP - BODY SPLASH\", \"unit\": \"un\", \"confidence\": 0.4429, \"raw_material_id\": 60}]', NULL, NULL, NULL, 1, 0, 1, NULL, NULL, '2026-06-03 17:52:37', '2026-06-03 18:01:34'),
(95, 29, 'BASE P PERFUME VEICULO 1LT', 2.0000, 'LT', 'L', 18.0000, 36.00, 61, 1, '[{\"name\": \"BASE P PERFUME VEICULO 1LT\", \"unit\": \"L\", \"confidence\": 1, \"raw_material_id\": 61}, {\"name\": \"BASE PARA BODY SPLASH\", \"unit\": \"L\", \"confidence\": 0.4029, \"raw_material_id\": 58}, {\"name\": \"POTE PET 1LT WHEY ROSA\", \"unit\": \"un\", \"confidence\": 0.3423, \"raw_material_id\": 64}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-03 17:52:37', '2026-06-03 18:01:45'),
(96, 30, 'VIDRO AMBAR GPP 200ML 28/400 LAVADO', 126.0000, 'un', 'un', 1.1000, 138.60, 37, 1, '[{\"name\": \"VIDRO AMBAR GPP 200ML 28/400 LAVADO\", \"unit\": \"un\", \"confidence\": 1, \"raw_material_id\": 37}, {\"name\": \"FRASCO AMBAR PET  35ML BASE VIT 20/41 36\", \"unit\": \"un\", \"confidence\": 0.4261, \"raw_material_id\": 50}, {\"name\": \"TAMPA FLIP TOP OMEGA 18/410 MARROM\", \"unit\": \"un\", \"confidence\": 0.3866, \"raw_material_id\": 46}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-03 18:02:32', '2026-06-03 18:03:01'),
(97, 30, 'VALVULA SPRAY LUXO 28/410 SAIA PRETA/NAT', 63.0000, 'un', 'un', 1.7300, 108.86, 38, 1, '[{\"name\": \"VALVULA SPRAY LUXO 28/410 SAIA PRETA/NAT\", \"unit\": \"un\", \"confidence\": 1, \"raw_material_id\": 38}, {\"name\": \"VALVULA GATILHO MINI 28/410 PRETA C/TRV\", \"unit\": \"un\", \"confidence\": 0.6655, \"raw_material_id\": 39}, {\"name\": \"VALVULA SPRAY R.24/410 OURO HOT STAMP - BODY SPLASH\", \"unit\": \"un\", \"confidence\": 0.624, \"raw_material_id\": 60}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-03 18:02:32', '2026-06-03 18:04:14'),
(98, 30, 'VALVULA GATILHO MINI 28/410 PRETA C/TRV', 63.0000, 'un', 'un', 1.4000, 88.14, 39, 1, '[{\"name\": \"VALVULA GATILHO MINI 28/410 PRETA C/TRV\", \"unit\": \"un\", \"confidence\": 1, \"raw_material_id\": 39}, {\"name\": \"VALVULA SPRAY LUXO 28/410 SAIA PRETA/NAT\", \"unit\": \"un\", \"confidence\": 0.6949, \"raw_material_id\": 38}, {\"name\": \"VALVULA SPRAY R.24/410 OURO HOT STAMP - BODY SPLASH\", \"unit\": \"un\", \"confidence\": 0.4973, \"raw_material_id\": 60}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-03 18:02:32', '2026-06-03 18:04:28'),
(99, 30, 'VIDRO AMOSTRA 1.8ML TP PRESSAO F2', 100.0000, 'un', 'un', 0.4200, 42.00, NULL, 0.51, '[{\"name\": \"VIDRO AMBAR GPP 200ML 28/400 LAVADO\", \"unit\": \"un\", \"confidence\": 0.51, \"raw_material_id\": 37}, {\"name\": \"VARETA ESTRELA MADEIRA PEQUENA\", \"unit\": \"un\", \"confidence\": 0.3567, \"raw_material_id\": 33}, {\"name\": \"POTE DE VIDRO REDONDO 30ML C/TP\", \"unit\": \"un\", \"confidence\": 0.3422, \"raw_material_id\": 62}]', NULL, NULL, NULL, 1, 0, 1, NULL, NULL, '2026-06-03 18:02:32', '2026-06-03 18:05:13');
INSERT INTO `smart_input_items` (`id`, `session_id`, `description_raw`, `quantity`, `unit_raw`, `unit_normalized`, `unit_price`, `total_price`, `raw_material_id`, `match_confidence`, `match_suggestions`, `batch_number`, `expires_at`, `manufactured_at`, `is_confirmed`, `is_skipped`, `is_new_material`, `new_material_category`, `notes`, `created_at`, `updated_at`) VALUES
(100, 32, 'ESSÊNCIA GOOD GIRL FEM', 50.0000, 'ml', 'ml', 0.6500, NULL, 78, 1, '[{\"name\": \"ESSÊNCIA GOOD GIRL FEM\", \"unit\": \"ml\", \"confidence\": 1, \"raw_material_id\": 78}, {\"name\": \"ESSÊNCIA INTERDIT FEM LINHA 1\", \"unit\": \"ml\", \"confidence\": 0.6323, \"raw_material_id\": 22}, {\"name\": \"ESSÊNCIA SCANDALO JEAN PAUL FEM - DOMO\", \"unit\": \"ml\", \"confidence\": 0.6088, \"raw_material_id\": 54}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-03 18:09:30', '2026-06-03 18:09:30'),
(101, 32, 'ESSÊNCIA VIP BLACK VOLLMENS', 50.0000, 'ml', 'ml', 0.6000, NULL, 75, 1, '[{\"name\": \"ESSÊNCIA VIP BLACK VOLLMENS\", \"unit\": \"ml\", \"confidence\": 1, \"raw_material_id\": 75}, {\"name\": \"ESSÊNCIA PATCHOLY\", \"unit\": \"ml\", \"confidence\": 0.6244, \"raw_material_id\": 30}, {\"name\": \"ESSÊNCIA LIS BRANCO ALECRIM\", \"unit\": \"ml\", \"confidence\": 0.6056, \"raw_material_id\": 28}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-03 18:09:30', '2026-06-03 18:09:30'),
(102, 35, 'LACO DE STRASS CORES - Simples', 4.0000, 'un', 'un', 3.9900, 15.96, NULL, 0.4786, '[{\"name\": \"POTE  04GRS.CRISTAL/BRANCO C/TP CORES\", \"unit\": \"un\", \"confidence\": 0.4786, \"raw_material_id\": 52}, {\"name\": \"ESS ARABE ASSAD MASC. LESS\", \"unit\": \"ml\", \"confidence\": 0.3787, \"raw_material_id\": 81}, {\"name\": \"OLEO- ESSENCIAL DE LARANJA DOCE - BALLON\", \"unit\": \"ml\", \"confidence\": 0.3505, \"raw_material_id\": 2}]', NULL, NULL, NULL, 1, 0, 1, 'Embalagem', NULL, '2026-06-03 18:16:04', '2026-06-03 18:19:49'),
(103, 35, 'LACO 2 FLORES CAMELIAS - Flores', 13.0000, 'un', 'un', 6.4500, 83.85, NULL, 0.3444, '[{\"name\": \"ESSÊNCIA LANCOM LA NUITE LINHA 1\", \"unit\": \"ml\", \"confidence\": 0.3444, \"raw_material_id\": 24}, {\"name\": \"FRASCO PET 220ml MALTA R.24/415 CRISTAL - INTIMO\", \"unit\": \"un\", \"confidence\": 0.3161, \"raw_material_id\": 12}, {\"name\": \"VARETA OLHO GREGO MINI\", \"unit\": \"un\", \"confidence\": 0.3091, \"raw_material_id\": 32}]', NULL, NULL, NULL, 1, 0, 1, NULL, NULL, '2026-06-03 18:16:04', '2026-06-03 18:24:38'),
(104, 35, 'BASE CREME HIDRATANTE NEUTRO C/UREIA YANTAR', 2.0000, 'un', 'kg', 14.9800, 29.96, NULL, 0.6367, '[{\"name\": \"Creme Hidratante Concent 1x4 1kg yant/gi\", \"unit\": \"kg\", \"confidence\": 0.6367, \"raw_material_id\": 18}, {\"name\": \"BODY SPLASH NEUTRO YANTRA\", \"unit\": \"L\", \"confidence\": 0.4303, \"raw_material_id\": 74}, {\"name\": \"BASE P PERFUME VEICULO 1LT\", \"unit\": \"L\", \"confidence\": 0.4279, \"raw_material_id\": 61}]', NULL, NULL, NULL, 1, 0, 1, NULL, NULL, '2026-06-03 18:16:04', '2026-06-03 19:41:00'),
(105, 35, 'BASE CREME HIDRATANTE 1.4 1KG-YANTRA', 2.0000, 'un', 'kg', 24.3500, 48.70, 18, 1, '[{\"name\": \"Creme Hidratante Concent 1x4 1kg yant/gi\", \"unit\": \"kg\", \"confidence\": 0.7921, \"raw_material_id\": 18}, {\"name\": \"SABONETE LIQUIDO AROMAS YANTRA\", \"unit\": \"un\", \"confidence\": 0.4208, \"raw_material_id\": 31}, {\"name\": \"BASE P PERFUME VEICULO 1LT\", \"unit\": \"L\", \"confidence\": 0.4138, \"raw_material_id\": 61}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-03 18:16:04', '2026-06-03 19:40:00'),
(106, 35, 'BASE PARA PERFUME 1LITRO YANTRA', 4.0000, 'un', 'L', 14.7000, 58.80, 61, 1, '[{\"name\": \"BASE P PERFUME VEICULO 1LT\", \"unit\": \"L\", \"confidence\": 0.6912, \"raw_material_id\": 61}, {\"name\": \"BODY SPLASH NEUTRO YANTRA\", \"unit\": \"L\", \"confidence\": 0.555, \"raw_material_id\": 74}, {\"name\": \"BASE PARA BODY SPLASH\", \"unit\": \"L\", \"confidence\": 0.5348, \"raw_material_id\": 58}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-03 18:16:04', '2026-06-03 19:40:35'),
(107, 42, 'BASE SAB. LIQ. VEGETAL VG 1X4 TRANSPARENTE LT', 1.0000, 'UN', 'L', 24.0000, 23.05, NULL, 0.4143, '[{\"name\": \"LAURIL VEGETAL VG\", \"unit\": \"L\", \"confidence\": 0.4143, \"raw_material_id\": 20}, {\"name\": \"BASE P PERFUME VEICULO 1LT\", \"unit\": \"L\", \"confidence\": 0.3791, \"raw_material_id\": 61}, {\"name\": \"Creme Hidratante Concent 1x4 1kg yant/gi\", \"unit\": \"kg\", \"confidence\": 0.3525, \"raw_material_id\": 18}]', NULL, NULL, NULL, 1, 0, 1, 'Base', NULL, '2026-06-03 20:00:09', '2026-06-03 20:01:38'),
(108, 42, 'ETIQUETA METALIZADA 3UN', 8.0000, 'UN', 'un', 5.5000, 42.26, NULL, 0.3824, '[{\"name\": \"VARETA ESTRELA MADEIRA PEQUENA\", \"unit\": \"un\", \"confidence\": 0.3824, \"raw_material_id\": 33}, {\"name\": \"ESSENCIA P/AROMATIZADOR MARVEL\", \"unit\": \"ml\", \"confidence\": 0.3691, \"raw_material_id\": 68}, {\"name\": \"ESSÊNCIA ARRUDA OAK\", \"unit\": \"ml\", \"confidence\": 0.3503, \"raw_material_id\": 73}]', NULL, NULL, NULL, 1, 0, 1, 'Emblagem', NULL, '2026-06-03 20:00:09', '2026-06-03 20:02:01'),
(109, 42, 'DOSADOR 01ML', 2.0000, 'UN', 'un', 0.5500, 1.06, NULL, 0.3543, '[{\"name\": \"LACO DE STRASS CORES - Simples\", \"unit\": \"un\", \"confidence\": 0.3543, \"raw_material_id\": 84}, {\"name\": \"ESSENCIA P/AROMATIZADOR MARVEL\", \"unit\": \"ml\", \"confidence\": 0.3219, \"raw_material_id\": 68}, {\"name\": \"POTE DE VIDRO REDONDO 30ML C/TP\", \"unit\": \"un\", \"confidence\": 0.3136, \"raw_material_id\": 62}]', NULL, NULL, NULL, 1, 0, 1, 'Utensílios', NULL, '2026-06-03 20:00:09', '2026-06-03 20:02:48'),
(110, 42, 'BASE SAB. LIQ. VEGETAL VG 1X4 PEROLADA LT', 1.0000, 'UN', 'L', 24.0000, 23.05, NULL, 0.4452, '[{\"name\": \"LAURIL VEGETAL VG\", \"unit\": \"L\", \"confidence\": 0.4452, \"raw_material_id\": 20}, {\"name\": \"BASE P PERFUME VEICULO 1LT\", \"unit\": \"L\", \"confidence\": 0.3964, \"raw_material_id\": 61}, {\"name\": \"BASE CREME HIDRATANTE NEUTRO C/UREIA YANTAR\", \"unit\": \"kg\", \"confidence\": 0.3645, \"raw_material_id\": 86}]', NULL, NULL, NULL, 1, 0, 1, NULL, NULL, '2026-06-03 20:00:09', '2026-06-03 20:03:11'),
(111, 42, 'RENEX NONILFENOL ETOXILADO 95', 100.0000, 'UN', 'ml', 0.0600, 5.76, NULL, 0.3512, '[{\"name\": \"FRASCO PET 300ml CILERETO SATURNO 24/410 - SHAMPOO\", \"unit\": \"un\", \"confidence\": 0.3512, \"raw_material_id\": 13}, {\"name\": \"VARETA MINI C/ ARGOLA 12CM\", \"unit\": \"un\", \"confidence\": 0.3164, \"raw_material_id\": 35}, {\"name\": \"ESSENCIA P/AROMATIZADOR MARVEL\", \"unit\": \"ml\", \"confidence\": 0.3, \"raw_material_id\": 68}]', NULL, NULL, NULL, 1, 0, 1, NULL, NULL, '2026-06-03 20:00:09', '2026-06-03 20:03:48'),
(112, 42, 'VIDRO IMP 050ML ARABE COLOR COM VALV. E CAPA UN', 4.0000, 'UN', 'un', 18.8000, 72.25, NULL, 0.3835, '[{\"name\": \"ESSÊNCIA ARABE ROYAL AMBER UNISEX\", \"unit\": \"un\", \"confidence\": 0.3835, \"raw_material_id\": 56}, {\"name\": \"ESSÊNCIA ARABE FAKAR BLACK UNISEX 50ML\", \"unit\": \"ml\", \"confidence\": 0.329, \"raw_material_id\": 55}, {\"name\": \"FRASCO PET 100ML R.24/410 CRISTAL ACQUA - Body Splash\", \"unit\": \"un\", \"confidence\": 0.3161, \"raw_material_id\": 79}]', NULL, NULL, NULL, 1, 0, 1, 'Embalagem', NULL, '2026-06-03 20:00:09', '2026-06-03 20:04:31'),
(113, 42, 'ESS VICTORI SECRET PEAR SUGAR LINHA A', 30.0000, 'UN', 'ml', 0.3000, 28.82, NULL, 0.4914, '[{\"name\": \"ESSÊNCIA LA VITA LINHA 1\", \"unit\": \"ml\", \"confidence\": 0.4914, \"raw_material_id\": 23}, {\"name\": \"ESSÊNCIA G. ARMANI MY WAY FEM LINHA 1\", \"unit\": \"ml\", \"confidence\": 0.4377, \"raw_material_id\": 21}, {\"name\": \"ESSÊNCIA INTERDIT FEM LINHA 1\", \"unit\": \"ml\", \"confidence\": 0.4161, \"raw_material_id\": 22}]', NULL, NULL, NULL, 1, 0, 1, 'Essência', NULL, '2026-06-03 20:00:09', '2026-06-03 20:05:30'),
(114, 42, 'PAPEL PH NACIONAL', 100.0000, 'UN', 'un', 0.2200, 21.13, NULL, 0.3626, '[{\"name\": \"FRASCO PET   30ML OVAL 20/410 R.35/10\", \"unit\": \"un\", \"confidence\": 0.3626, \"raw_material_id\": 41}, {\"name\": \"FRASCO PET   60ML OVAL 18/410 8G REF:120\", \"unit\": \"un\", \"confidence\": 0.3413, \"raw_material_id\": 43}, {\"name\": \"FRASCO PVC  30ML OVAL CRISTAL 18/410 F22\", \"unit\": \"un\", \"confidence\": 0.336, \"raw_material_id\": 42}]', NULL, NULL, NULL, 1, 0, 1, NULL, NULL, '2026-06-03 20:00:09', '2026-06-03 20:06:01'),
(115, 42, 'ETIQUETAS DIVERSAS TRANSPARENTE C/ 20 UN', 2.0000, 'UN', 'un', 3.5000, 6.72, NULL, 0.3974, '[{\"name\": \"ESSÊNCIA ROSAS BRANCAS- LESSENCE\", \"unit\": \"ml\", \"confidence\": 0.3974, \"raw_material_id\": 9}, {\"name\": \"ESSÊNCIA LAVANDA FRANCESA - OAK\", \"unit\": \"ml\", \"confidence\": 0.3422, \"raw_material_id\": 5}, {\"name\": \"LACO DE STRASS CORES - Simples\", \"unit\": \"un\", \"confidence\": 0.3175, \"raw_material_id\": 84}]', NULL, NULL, NULL, 1, 0, 1, NULL, NULL, '2026-06-03 20:00:09', '2026-06-03 20:06:17'),
(116, 43, 'LAURIL 2000 DECILGLUCOSIDEO 50 1 LT', 1.0000, 'un', 'L', 63.0000, 60.51, 19, 1, '[{\"name\": \"LAURIL 2000 DECILGLUCOSIDEO 50\", \"unit\": \"L\", \"confidence\": 1, \"raw_material_id\": 19}, {\"name\": \"LAURIL VEGETAL VG\", \"unit\": \"L\", \"confidence\": 0.4001, \"raw_material_id\": 20}, {\"name\": \"DOSADOR 01ML\", \"unit\": \"un\", \"confidence\": 0.3212, \"raw_material_id\": 89}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-03 20:08:03', '2026-06-03 20:09:14'),
(117, 43, 'ANFOTERO BETAINICO COCCAMIDOPROPILBETAINA LITRO', 1.0000, 'un', 'L', 19.0000, 18.25, NULL, 0.3444, '[{\"name\": \"SABONETE LIQUIDO AROMAS YANTRA\", \"unit\": \"un\", \"confidence\": 0.3444, \"raw_material_id\": 31}, {\"name\": \"VARETA MINI C/ ARGOLA 12CM\", \"unit\": \"un\", \"confidence\": 0.3355, \"raw_material_id\": 35}, {\"name\": \"TAMPA PLAST. POTE MET. DOURADA TRADITION\", \"unit\": \"un\", \"confidence\": 0.3251, \"raw_material_id\": 63}]', NULL, NULL, NULL, 1, 0, 1, 'Tensoativo', NULL, '2026-06-03 20:08:03', '2026-06-08 20:59:34'),
(118, 43, 'BASE CREME LIMNE C/ ROSA MOSQUETA KG 1993 ONU-1993', 1.0000, 'un', 'kg', 33.0000, 31.70, NULL, 0.4676, '[{\"name\": \"BASE CREME HIDRATANTE NEUTRO C/UREIA YANTAR\", \"unit\": \"kg\", \"confidence\": 0.4676, \"raw_material_id\": 86}, {\"name\": \"BASE SAB. LIQ. VEGETAL VG 1X4 PEROLADA LT\", \"unit\": \"L\", \"confidence\": 0.3984, \"raw_material_id\": 90}, {\"name\": \"Creme Hidratante Concent 1x4 1kg yant/gi\", \"unit\": \"kg\", \"confidence\": 0.3685, \"raw_material_id\": 18}]', NULL, NULL, NULL, 1, 0, 1, 'Base', NULL, '2026-06-03 20:08:03', '2026-06-08 20:59:43'),
(119, 43, 'COR 100ML AGUA LILAS', 100.0000, 'un', 'ml', 0.0500, 4.32, NULL, 0.4459, '[{\"name\": \"FRASCO PET 100ML R.24/410 CRISTAL ACQUA - Body Splash\", \"unit\": \"un\", \"confidence\": 0.4459, \"raw_material_id\": 79}, {\"name\": \"ESS VICTORI SECRET PEAR SUGAR LINHA A\", \"unit\": \"ml\", \"confidence\": 0.3824, \"raw_material_id\": 93}, {\"name\": \"VIDRO AMBAR GPP 200ML 28/400 LAVADO\", \"unit\": \"un\", \"confidence\": 0.3657, \"raw_material_id\": 37}]', NULL, NULL, NULL, 1, 0, 1, 'Corante', NULL, '2026-06-03 20:08:03', '2026-06-08 21:00:13'),
(120, 43, 'COR 100ML AGUA LARANJA', 100.0000, 'un', 'ml', 0.0500, 4.32, NULL, 0.4978, '[{\"name\": \"FRASCO PET 220ML MALTA R. 24/415 LARANJA - INTIMO\", \"unit\": \"un\", \"confidence\": 0.4978, \"raw_material_id\": 10}, {\"name\": \"FRASCO PET 100ML R.24/410 CRISTAL ACQUA - Body Splash\", \"unit\": \"un\", \"confidence\": 0.4064, \"raw_material_id\": 79}, {\"name\": \"TAMPA DISK  TOP 24/415 LARANJA - INTIMO\", \"unit\": \"un\", \"confidence\": 0.3887, \"raw_material_id\": 17}]', NULL, NULL, NULL, 1, 0, 1, NULL, NULL, '2026-06-03 20:08:04', '2026-06-03 20:10:54'),
(121, 43, 'COR ALIM 10ML BRANCO', 1.0000, 'un', 'ml', 0.0300, 2.79, NULL, 0.4494, '[{\"name\": \"ESSÊNCIA LIS BRANCO ALECRIM\", \"unit\": \"ml\", \"confidence\": 0.4494, \"raw_material_id\": 28}, {\"name\": \"FRASCO PET   10ML CILINDRICO 18/410 BCO\", \"unit\": \"un\", \"confidence\": 0.4107, \"raw_material_id\": 44}, {\"name\": \"POTE  04GRS.CRISTAL/BRANCO C/TP CORES\", \"unit\": \"un\", \"confidence\": 0.4079, \"raw_material_id\": 52}]', NULL, NULL, NULL, 1, 0, 1, NULL, NULL, '2026-06-03 20:08:04', '2026-06-03 20:11:14'),
(122, 43, 'ESSÊNCIA DIOR SAUVAGE MASC LINHA I', 60.0000, 'un', 'ml', 0.9700, 55.71, NULL, 0.5358, '[{\"name\": \"ESS ARABE ASSAD MASC. LESS\", \"unit\": \"ml\", \"confidence\": 0.5358, \"raw_material_id\": 81}, {\"name\": \"ESS VICTORI SECRET PEAR SUGAR LINHA A\", \"unit\": \"ml\", \"confidence\": 0.512, \"raw_material_id\": 93}, {\"name\": \"ESSÊNCIA LA VITA LINHA 1\", \"unit\": \"ml\", \"confidence\": 0.5044, \"raw_material_id\": 23}]', NULL, NULL, NULL, 1, 0, 1, 'Essência', NULL, '2026-06-03 20:08:04', '2026-06-08 21:02:19'),
(123, 43, 'ESS LANCOM LA NUITE LINHA I 060ML', 60.0000, 'un', 'ml', 0.9700, 55.71, 24, 1, '[{\"name\": \"ESSÊNCIA LANCOM LA NUITE LINHA 1\", \"unit\": \"ml\", \"confidence\": 0.8545, \"raw_material_id\": 24}, {\"name\": \"ESSÊNCIA LA VITA LINHA 1\", \"unit\": \"ml\", \"confidence\": 0.6371, \"raw_material_id\": 23}, {\"name\": \"ESSÊNCIA INTERDIT FEM LINHA 1\", \"unit\": \"ml\", \"confidence\": 0.5338, \"raw_material_id\": 22}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-03 20:08:04', '2026-06-03 20:13:13'),
(124, 43, 'EXTRATO GLICOLICO ABACATE', 100.0000, 'un', 'ml', 0.0700, 5.96, NULL, 0.3862, '[{\"name\": \"VIDRO AMOSTRA 1.8ML TP PRESSAO F2\", \"unit\": \"un\", \"confidence\": 0.3862, \"raw_material_id\": 83}, {\"name\": \"ESSÊNCIA CLASSIC DOVE  17.013 DOMO ZZZ\", \"unit\": \"ml\", \"confidence\": 0.3347, \"raw_material_id\": 67}, {\"name\": \"SABONETE LIQUIDO AROMAS YANTRA\", \"unit\": \"un\", \"confidence\": 0.3207, \"raw_material_id\": 31}]', NULL, NULL, NULL, 1, 0, 1, 'Extrato', NULL, '2026-06-03 20:08:04', '2026-06-08 21:02:45'),
(125, 43, 'PROMOCAO ESSENCIA', 400.0000, 'un', 'ml', 0.1500, 57.63, NULL, 0.5216, '[{\"name\": \"ESSÊNCIA BAMBOO\", \"unit\": \"ml\", \"confidence\": 0.5216, \"raw_material_id\": 27}, {\"name\": \"ESSÊNCIA PATCHOLY\", \"unit\": \"ml\", \"confidence\": 0.4884, \"raw_material_id\": 30}, {\"name\": \"ESSÊNCIA DASLU OAK\", \"unit\": \"ml\", \"confidence\": 0.4463, \"raw_material_id\": 72}]', NULL, NULL, NULL, 1, 0, 1, 'Essência', NULL, '2026-06-03 20:08:04', '2026-06-08 21:03:00'),
(126, 43, 'F143 FORMA DE ACETATO CORACAO DECORADO 15 CAV', 2.0000, 'un', 'un', 1.5000, 2.88, NULL, 0.3207, '[{\"name\": \"TAMPA FLIP TOP OMEGA 24/415 BRANCA - CORPORAL\", \"unit\": \"un\", \"confidence\": 0.3207, \"raw_material_id\": 77}, {\"name\": \"POTE DE VIDRO REDONDO 30ML C/TP\", \"unit\": \"un\", \"confidence\": 0.3119, \"raw_material_id\": 62}, {\"name\": \"Creme Hidratante Concent 1x4 1kg yant/gi\", \"unit\": \"kg\", \"confidence\": 0.3111, \"raw_material_id\": 18}]', NULL, NULL, NULL, 1, 0, 1, 'Utensílios', NULL, '2026-06-03 20:08:04', '2026-06-08 21:03:13'),
(127, 43, 'F140 FORMA DE ACETATO CORACAO TORTO PEQ 12 CAV', 2.0000, 'un', 'un', 1.5000, 2.88, NULL, 0.3242, '[{\"name\": \"Creme Hidratante Concent 1x4 1kg yant/gi\", \"unit\": \"kg\", \"confidence\": 0.3242, \"raw_material_id\": 18}, {\"name\": \"VARETA ESTRELA MADEIRA PEQUENA\", \"unit\": \"un\", \"confidence\": 0.3183, \"raw_material_id\": 33}, {\"name\": \"LACO DE STRASS CORES - Simples\", \"unit\": \"un\", \"confidence\": 0.3152, \"raw_material_id\": 84}]', NULL, NULL, NULL, 1, 0, 1, 'Utensílios', NULL, '2026-06-03 20:08:04', '2026-06-08 21:03:22'),
(128, 43, 'POTE VIDRO TRANSP 030G TAMPA PRATA', 2.0000, 'un', 'un', 4.6000, 8.84, NULL, 0.5104, '[{\"name\": \"POTE 500GRS.OVAL PRATA TP FIO OURO/PRATA\", \"unit\": \"un\", \"confidence\": 0.5104, \"raw_material_id\": 53}, {\"name\": \"POTE PET 1LT WHEY ROSA\", \"unit\": \"un\", \"confidence\": 0.3857, \"raw_material_id\": 64}, {\"name\": \"POTE  04GRS.CRISTAL/BRANCO C/TP CORES\", \"unit\": \"un\", \"confidence\": 0.3839, \"raw_material_id\": 52}]', NULL, NULL, NULL, 1, 0, 1, 'Embalagem', NULL, '2026-06-03 20:08:04', '2026-06-08 21:03:31'),
(129, 43, 'POTE VIDRO AMBAR 030G TAMPA DOURADA', 2.0000, 'un', 'un', 4.9000, 9.41, NULL, 0.4719, '[{\"name\": \"TAMPA PLAST. POTE MET. DOURADA TRADITION\", \"unit\": \"un\", \"confidence\": 0.4719, \"raw_material_id\": 63}, {\"name\": \"POTE 500GRS.OVAL PRATA TP FIO OURO/PRATA\", \"unit\": \"un\", \"confidence\": 0.4633, \"raw_material_id\": 53}, {\"name\": \"POTE  04GRS.CRISTAL/BRANCO C/TP CORES\", \"unit\": \"un\", \"confidence\": 0.4335, \"raw_material_id\": 52}]', NULL, NULL, NULL, 1, 0, 1, 'Embalagem', NULL, '2026-06-03 20:08:04', '2026-06-08 21:03:38'),
(130, 44, 'EXTRATO DE ARNICA', 1000.0000, 'ml', 'ml', 0.0300, NULL, 96, 1, '[{\"name\": \"EXTRATO DE ARNICA\", \"unit\": \"ml\", \"confidence\": 1, \"raw_material_id\": 96}, {\"name\": \"EXTRATO DE PANACEIA\", \"unit\": \"ml\", \"confidence\": 0.8947, \"raw_material_id\": 98}, {\"name\": \"EXTRATO DE BABOSA\", \"unit\": \"ml\", \"confidence\": 0.8412, \"raw_material_id\": 108}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-08 20:56:56', '2026-06-08 20:56:56'),
(131, 46, 'BASE PARA BODY SPLASH', 3.0000, 'LT', 'L', 20.0000, 60.00, 58, 1, '[{\"name\": \"BASE PARA BODY SPLASH\", \"unit\": \"L\", \"confidence\": 1, \"raw_material_id\": 58}, {\"name\": \"BASE PARA BODY SPLASH S/MICA\", \"unit\": \"L\", \"confidence\": 1, \"raw_material_id\": 82}, {\"name\": \"FRASCO PET 100ML R.24/410 CRISTAL ACQUA - Body Splash\", \"unit\": \"un\", \"confidence\": 0.5412, \"raw_material_id\": 79}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-09 20:26:02', '2026-06-09 20:27:12'),
(132, 46, 'BASE PARA BODY SPLASH S/MICA', 1.0000, 'PC', 'L', 18.0000, 18.00, 82, 1, '[{\"name\": \"BASE PARA BODY SPLASH S/MICA\", \"unit\": \"L\", \"confidence\": 1, \"raw_material_id\": 82}, {\"name\": \"BASE PARA BODY SPLASH\", \"unit\": \"L\", \"confidence\": 0.9743, \"raw_material_id\": 58}, {\"name\": \"BODY SPLASH NEUTRO YANTRA\", \"unit\": \"L\", \"confidence\": 0.497, \"raw_material_id\": 74}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-09 20:26:02', '2026-06-09 20:27:27'),
(133, 46, 'FRASCO PET 200ML R.24/410 CRISTAL AURA C/TP', 30.0000, 'UN', 'un', 2.6500, 79.50, 59, 1, '[{\"name\": \"FRASCO PET 200ML R 24/410 CRISTAL AURA C/TP - Body Splash\", \"unit\": \"un\", \"confidence\": 1, \"raw_material_id\": 59}, {\"name\": \"FRASCO PET 100ML R.24/410 CRISTAL ACQUA - Body Splash\", \"unit\": \"un\", \"confidence\": 0.9292, \"raw_material_id\": 79}, {\"name\": \"FRASCO PET 220ml MALTA R.24/415 CRISTAL - INTIMO\", \"unit\": \"un\", \"confidence\": 0.7971, \"raw_material_id\": 12}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-09 20:26:02', '2026-06-09 20:27:35'),
(134, 46, 'VALVULA SPRAY R 24/410 OURO HOT STAMP', 30.0000, 'UN', 'un', 1.6500, 49.50, 60, 1, '[{\"name\": \"VALVULA SPRAY R.24/410 OURO HOT STAMP - BODY SPLASH\", \"unit\": \"un\", \"confidence\": 1, \"raw_material_id\": 60}, {\"name\": \"VALVULA SPRAY LUXO 28/410 SAIA PRETA/NAT\", \"unit\": \"un\", \"confidence\": 0.704, \"raw_material_id\": 38}, {\"name\": \"VALVULA GATILHO MINI 28/410 PRETA C/TRV\", \"unit\": \"un\", \"confidence\": 0.5466, \"raw_material_id\": 39}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-09 20:26:02', '2026-06-09 20:27:44'),
(135, 46, 'VALVULA SABONETE R.24/410 LUXO DOURADA/NATURAL - CREME CORPORAL', 12.0000, 'UN', 'un', 2.8000, 33.60, NULL, 0.618, '[{\"name\": \"VALVULA SPRAY R.24/410 OURO HOT STAMP - BODY SPLASH\", \"unit\": \"un\", \"confidence\": 0.618, \"raw_material_id\": 60}, {\"name\": \"VALVULA SPRAY LUXO 28/410 SAIA PRETA/NAT\", \"unit\": \"un\", \"confidence\": 0.6134, \"raw_material_id\": 38}, {\"name\": \"VALVULA GATILHO MINI 28/410 PRETA C/TRV\", \"unit\": \"un\", \"confidence\": 0.5614, \"raw_material_id\": 39}]', NULL, NULL, NULL, 1, 0, 1, 'Embalagem', NULL, '2026-06-09 20:26:02', '2026-06-09 20:29:03'),
(136, 46, 'ESS SCANDALO JEAN PAUL FEM - DOMO', 100.0000, 'LT', 'ml', 0.4000, 40.00, 54, 1, '[{\"name\": \"ESSÊNCIA SCANDALO JEAN PAUL FEM - DOMO\", \"unit\": \"ml\", \"confidence\": 1, \"raw_material_id\": 54}, {\"name\": \"ESSÊNCIA  ALMISCAR - DOMO\", \"unit\": \"ml\", \"confidence\": 0.4599, \"raw_material_id\": 8}, {\"name\": \"ESSÊNCIA GOOD GIRL FEM\", \"unit\": \"ml\", \"confidence\": 0.4372, \"raw_material_id\": 78}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-09 20:26:02', '2026-06-09 20:29:40'),
(137, 46, 'ESS ARABE DELINIA LA ROSÉ FEM. 50ML', 100.0000, 'UN', 'ml', 0.4500, 45.00, 57, 1, '[{\"name\": \"ESSÊNCIA ARABE DELINIA LA ROSÉ FEM.\", \"unit\": \"ml\", \"confidence\": 0.9275, \"raw_material_id\": 57}, {\"name\": \"ESSÊNCIA ARABE FAKAR BLACK UNISEX 50ML\", \"unit\": \"ml\", \"confidence\": 0.5789, \"raw_material_id\": 55}, {\"name\": \"ESSÊNCIA SCANDALO JEAN PAUL FEM - DOMO\", \"unit\": \"ml\", \"confidence\": 0.4692, \"raw_material_id\": 54}]', NULL, NULL, NULL, 1, 0, 0, NULL, NULL, '2026-06-09 20:26:02', '2026-06-09 20:30:03');

-- --------------------------------------------------------

--
-- Table structure for table `smart_input_sessions`
--

CREATE TABLE `smart_input_sessions` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `status` enum('pending','processing','needs_review','confirmed','completed','failed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `document_type` enum('image','pdf','manual') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'manual',
  `document_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `document_original_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `raw_ocr_text` text COLLATE utf8mb4_unicode_ci,
  `parsed_json` json DEFAULT NULL,
  `supplier_id` bigint UNSIGNED DEFAULT NULL,
  `supplier_name_raw` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `purchase_date` date DEFAULT NULL,
  `document_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_value` decimal(12,2) DEFAULT NULL,
  `error_message` text COLLATE utf8mb4_unicode_ci,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `confirmed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `smart_input_sessions`
--

INSERT INTO `smart_input_sessions` (`id`, `user_id`, `status`, `document_type`, `document_path`, `document_original_name`, `raw_ocr_text`, `parsed_json`, `supplier_id`, `supplier_name_raw`, `purchase_date`, `document_number`, `total_value`, `error_message`, `notes`, `confirmed_at`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'failed', 'pdf', 'smart_input/1/nQeNRewm0RfFzBiQtGyNOqrdpe4Vm9DUmU9vcY08.pdf', 'CamScanner 11-05-2026 17.25.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-19 14:53:06', '2026-05-19 16:53:21', '2026-05-19 16:53:21'),
(2, 1, 'failed', 'pdf', 'smart_input/1/q8w4PYBR1a3yv2HEulIs25R5YgHNeDPqTExiZ1s2.pdf', 'CamScanner 11-05-2026 17.25.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-19 14:55:21', '2026-05-19 16:53:25', '2026-05-19 16:53:25'),
(3, 1, 'failed', 'pdf', 'smart_input/1/wPSorF51f8GIE9S9BimDM4pTyrkaIYT5Cg7e7pqP.pdf', 'CamScanner 11-05-2026 17.25.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-19 15:03:39', '2026-05-19 16:53:37', '2026-05-19 16:53:37'),
(4, 1, 'failed', 'pdf', 'smart_input/1/o6bApt3I0dcM8jgXJPxIvNIJdWJDuf9nT4ay5qS4.pdf', 'CamScanner 11-05-2026 17.25.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Arquivo não encontrado: smart_input/1/o6bApt3I0dcM8jgXJPxIvNIJdWJDuf9nT4ay5qS4.pdf', NULL, NULL, '2026-05-19 15:30:38', '2026-05-19 16:53:27', '2026-05-19 16:53:27'),
(5, 1, 'failed', 'pdf', 'smart_input/1/6BK1ahoxka7g7ZpjLzMMdTSRfxod5hk5h2bBLFHI.pdf', 'CamScanner 11-05-2026 17.25.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Arquivo não encontrado: smart_input/1/6BK1ahoxka7g7ZpjLzMMdTSRfxod5hk5h2bBLFHI.pdf', NULL, NULL, '2026-05-19 15:31:05', '2026-05-19 16:53:34', '2026-05-19 16:53:34'),
(6, 1, 'failed', 'pdf', 'smart_input/1/nMMoelbm3wrfxjd2Tj6ZtxeuMadRfhXO1Y2omnQq.pdf', 'CamScanner 11-05-2026 17.25.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Arquivo não encontrado: smart_input/1/nMMoelbm3wrfxjd2Tj6ZtxeuMadRfhXO1Y2omnQq.pdf', NULL, NULL, '2026-05-19 15:31:46', '2026-05-19 16:53:30', '2026-05-19 16:53:30'),
(7, 1, 'failed', 'pdf', 'smart_input/1/VSacyd9nwQKOCONNWKYW9L01j52xLrQL6oa28NEW.pdf', 'CamScanner 11-05-2026 17.25.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'cURL error 77: error setting certificate file: D:\\Projects\\Laragon-installer\\8.0-W64\\etc\\ssl\\cacert.pem (see https://curl.haxx.se/libcurl/c/libcurl-errors.html) for https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=AIzaSy...AIzaSyCgaQMq9t1APi5gzpERo0NFkbpczPT0QHI', NULL, NULL, '2026-05-19 15:36:03', '2026-05-19 16:53:32', '2026-05-19 16:53:32'),
(8, 1, 'failed', 'pdf', 'smart_input/1/l1zZo8G3hIboiLxFvfPaXAbmWLCPAoWHcrGsKsvo.pdf', 'CamScanner 11-05-2026 17.25.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Erro na API Gemini: API key not valid. Please pass a valid API key.', NULL, NULL, '2026-05-19 15:40:49', '2026-05-19 16:53:40', '2026-05-19 16:53:40'),
(9, 1, 'failed', 'pdf', 'smart_input/1/d9Mxthq0zTOwEkiM1DChNapw38bzysHAPrBTIfk8.pdf', 'CamScanner 11-05-2026 17.25.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Erro na API Gemini: models/gemini-1.5-flash is not found for API version v1beta, or is not supported for generateContent. Call ModelService.ListModels to see the list of available models and their supported methods.', NULL, NULL, '2026-05-19 15:42:57', '2026-05-19 16:53:44', '2026-05-19 16:53:44'),
(10, 1, 'failed', 'pdf', 'smart_input/1/8MFLvEnycdbILApOgkMk67pKmVsHi1CyQwR3mA6r.pdf', 'CamScanner 11-05-2026 17.25.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Erro na API Gemini: You exceeded your current quota, please check your plan and billing details. For more information on this error, head to: https://ai.google.dev/gemini-api/docs/rate-limits. To monitor your current usage, head to: https://ai.dev/rate-limit. \n* Quota exceeded for metric: generativelanguage.googleapis.com/generate_content_free_tier_input_token_count, limit: 0, model: gemini-2.0-flash\n* Quota exceeded for metric: generativelanguage.googleapis.com/generate_content_free_tier_requests, limit: 0, model: gemini-2.0-flash\n* Quota exceeded for metric: generativelanguage.googleapis.com/generate_content_free_tier_requests, limit: 0, model: gemini-2.0-flash\nPlease retry in 47.981608955s.', NULL, NULL, '2026-05-19 16:35:06', '2026-05-19 16:53:46', '2026-05-19 16:53:46'),
(11, 1, 'failed', 'pdf', 'smart_input/1/mCxQyidAJodgGkN8n39gz2zI3fSIn3s6BcBSr2XJ.pdf', 'CamScanner 11-05-2026 17.25.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Erro na API Gemini: models/gemini-1.5-flash is not found for API version v1beta, or is not supported for generateContent. Call ModelService.ListModels to see the list of available models and their supported methods.', NULL, NULL, '2026-05-19 16:41:07', '2026-05-19 17:24:27', '2026-05-19 17:24:27'),
(12, 1, 'failed', 'pdf', 'smart_input/1/eWpCFkznQdSHxM9BQoR5aDZ11dwezP4C7U5hzPSR.pdf', 'CamScanner 11-05-2026 17.25.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Erro na API Gemini: models/gemini-1.5-flash is not found for API version v1beta, or is not supported for generateContent. Call ModelService.ListModels to see the list of available models and their supported methods.', NULL, NULL, '2026-05-19 17:13:49', '2026-05-19 17:26:08', '2026-05-19 17:26:08'),
(13, 1, 'failed', 'pdf', 'smart_input/1/yCo13SveXwlRNzT67HUgZBmPD4nkSiHsHf9uSkEy.pdf', 'CamScanner 11-05-2026 17.25.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Erro na API Gemini: You exceeded your current quota, please check your plan and billing details. For more information on this error, head to: https://ai.google.dev/gemini-api/docs/rate-limits. To monitor your current usage, head to: https://ai.dev/rate-limit. \n* Quota exceeded for metric: generativelanguage.googleapis.com/generate_content_free_tier_input_token_count, limit: 0, model: gemini-2.0-flash\n* Quota exceeded for metric: generativelanguage.googleapis.com/generate_content_free_tier_requests, limit: 0, model: gemini-2.0-flash\n* Quota exceeded for metric: generativelanguage.googleapis.com/generate_content_free_tier_requests, limit: 0, model: gemini-2.0-flash\nPlease retry in 16.742902454s.', NULL, NULL, '2026-05-19 17:26:37', '2026-05-21 02:48:30', '2026-05-21 02:48:30'),
(14, 1, 'failed', 'pdf', 'smart_input/1/uWriquGkBmKeVMSasQjFO2LcWvRuol1ajPogZS8z.pdf', 'CamScanner 11-05-2026 17.25.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Erro na API Gemini: You exceeded your current quota, please check your plan and billing details. For more information on this error, head to: https://ai.google.dev/gemini-api/docs/rate-limits. To monitor your current usage, head to: https://ai.dev/rate-limit. \n* Quota exceeded for metric: generativelanguage.googleapis.com/generate_content_free_tier_requests, limit: 0, model: gemini-2.0-flash\n* Quota exceeded for metric: generativelanguage.googleapis.com/generate_content_free_tier_requests, limit: 0, model: gemini-2.0-flash\n* Quota exceeded for metric: generativelanguage.googleapis.com/generate_content_free_tier_input_token_count, limit: 0, model: gemini-2.0-flash\nPlease retry in 32.607494001s.', NULL, NULL, '2026-05-20 04:32:23', '2026-05-21 02:48:33', '2026-05-21 02:48:33'),
(15, 1, 'completed', 'manual', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-21 02:48:19', '2026-05-21 02:47:47', '2026-05-21 02:48:19', NULL),
(16, 1, 'completed', 'image', 'smart_input/1/xIbOYktO8XehD8DdzQsigY8d8WqbAKpcixdOXjhu.jpg', 'Nota01_20-04-26.jpeg', '{\"supplier\":\"W.ESSENCIAS - COMERCIO E ARTESANATO\",\"purchase_date\":\"2026-04-20\",\"document_number\":\"067130\",\"total_value\":194,\"items\":[{\"description\":\"OLEO- ESSENCIAL DE LARANJA DOCE 10ML - BALLON\",\"quantity\":1,\"unit\":\"UN\",\"unit_price\":16,\"total_price\":16},{\"description\":\"OLEO- ESSENCIAL DE LAVANDA 10ML - BALLON\",\"quantity\":1,\"unit\":\"UN\",\"unit_price\":25,\"total_price\":25},{\"description\":\"ESS LAVANDA INGLESA - OAK\",\"quantity\":0.1,\"unit\":\"LT\",\"unit_price\":260,\"total_price\":26},{\"description\":\"ESS LAVANDA FRANCESA - OAK\",\"quantity\":0.1,\"unit\":\"LT\",\"unit_price\":240,\"total_price\":24},{\"description\":\"ESS LAVANDA & ALGODAO MAHOGANY- ISAN\",\"quantity\":0.1,\"unit\":\"LT\",\"unit_price\":280,\"total_price\":28},{\"description\":\"ESS LAVANDA PROVENCE - LESS\",\"quantity\":0.1,\"unit\":\"LT\",\"unit_price\":250,\"total_price\":25},{\"description\":\"ESS ALMISCAR - DOMO\",\"quantity\":0.1,\"unit\":\"LT\",\"unit_price\":280,\"total_price\":28},{\"description\":\"ESS ROSAS BRANCAS- LESSENCE\",\"quantity\":0.1,\"unit\":\"LT\",\"unit_price\":220,\"total_price\":22}]}', '{\"items\": [{\"unit\": \"UN\", \"quantity\": 1, \"unit_price\": 16, \"description\": \"OLEO- ESSENCIAL DE LARANJA DOCE 10ML - BALLON\", \"total_price\": 16}, {\"unit\": \"UN\", \"quantity\": 1, \"unit_price\": 25, \"description\": \"OLEO- ESSENCIAL DE LAVANDA 10ML - BALLON\", \"total_price\": 25}, {\"unit\": \"LT\", \"quantity\": 0.1, \"unit_price\": 260, \"description\": \"ESS LAVANDA INGLESA - OAK\", \"total_price\": 26}, {\"unit\": \"LT\", \"quantity\": 0.1, \"unit_price\": 240, \"description\": \"ESS LAVANDA FRANCESA - OAK\", \"total_price\": 24}, {\"unit\": \"LT\", \"quantity\": 0.1, \"unit_price\": 280, \"description\": \"ESS LAVANDA & ALGODAO MAHOGANY- ISAN\", \"total_price\": 28}, {\"unit\": \"LT\", \"quantity\": 0.1, \"unit_price\": 250, \"description\": \"ESS LAVANDA PROVENCE - LESS\", \"total_price\": 25}, {\"unit\": \"LT\", \"quantity\": 0.1, \"unit_price\": 280, \"description\": \"ESS ALMISCAR - DOMO\", \"total_price\": 28}, {\"unit\": \"LT\", \"quantity\": 0.1, \"unit_price\": 220, \"description\": \"ESS ROSAS BRANCAS- LESSENCE\", \"total_price\": 22}], \"supplier\": \"W.ESSENCIAS - COMERCIO E ARTESANATO\", \"total_value\": 194, \"purchase_date\": \"2026-04-20\", \"document_number\": \"067130\"}', 2, 'W.ESSENCIAS - COMERCIO E ARTESANATO', '2026-04-20', '067130', 194.00, NULL, NULL, '2026-05-21 13:36:30', '2026-05-21 13:26:19', '2026-05-21 13:36:30', NULL),
(17, 1, 'failed', 'image', 'smart_input/1/TcPW07aja7Fr9VPmzk2cRvr3igCoheWBFJXjxfUP.jpg', 'Nota01_04-03-26.jpeg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'A IA não retornou um JSON válido. Verifique a qualidade da imagem e tente novamente.', NULL, NULL, '2026-05-21 14:19:28', '2026-05-21 14:52:17', '2026-05-21 14:52:17'),
(18, 1, 'completed', 'manual', NULL, NULL, NULL, NULL, 3, NULL, '2026-03-06', NULL, NULL, NULL, NULL, '2026-05-21 14:49:38', '2026-05-21 14:49:26', '2026-05-21 14:49:38', NULL),
(19, 1, 'failed', 'image', 'smart_input/1/aZ54xSghFGMEvB9HsWIDjCCzbfFkScKwig3gUe5S.jpg', 'Nota02_04-03-26.jpeg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'A IA não retornou um JSON válido. Verifique a qualidade da imagem e tente novamente.', NULL, NULL, '2026-05-21 14:50:59', '2026-05-21 15:23:13', '2026-05-21 15:23:13'),
(20, 1, 'completed', 'manual', NULL, NULL, NULL, NULL, 1, NULL, '2026-03-06', NULL, NULL, NULL, NULL, '2026-05-21 15:17:25', '2026-05-21 15:17:19', '2026-05-21 15:17:25', NULL),
(21, 1, 'completed', 'image', 'smart_input/1/BAB8Ck8VnrNLK7iGevXcujoYocgDTaQTmqi0y3AT.jpg', 'Nota05_20-04-26.jpeg', '{\"supplier\":\"ANINHA DAS ESSENCIAS\",\"purchase_date\":\"2026-04-20\",\"document_number\":\"438160\",\"total_value\":50.62,\"items\":[{\"description\":\"ESS CEDRO SABONETE\",\"quantity\":50,\"unit\":\"un\",\"unit_price\":0.15,\"total_price\":7.5},{\"description\":\"ESS P KIT PATCHOLY\",\"quantity\":50,\"unit\":\"un\",\"unit_price\":0.15,\"total_price\":7.5},{\"description\":\"SABONETE LIQUIDO AROMAS YANTRA\",\"quantity\":1,\"unit\":\"un\",\"unit_price\":7.3,\"total_price\":7.3},{\"description\":\"VARETA OLHO GREGO MINI\",\"quantity\":5,\"unit\":\"un\",\"unit_price\":1.15,\"total_price\":5.75},{\"description\":\"VARETA ESTRELA MADEIRA PEQUENA\",\"quantity\":3,\"unit\":\"un\",\"unit_price\":1.49,\"total_price\":4.47},{\"description\":\"VARETA FRAMBOESA MINI C\\/ARGOLA\",\"quantity\":5,\"unit\":\"un\",\"unit_price\":0.95,\"total_price\":4.75},{\"description\":\"VARETA MINI C\\/ ARGOLA 12CM\",\"quantity\":3,\"unit\":\"un\",\"unit_price\":0.6,\"total_price\":1.8},{\"description\":\"PINGENTE DIFUSOR C\\/PONTEIRA BOLA MADEIRA\",\"quantity\":7,\"unit\":\"un\",\"unit_price\":1.65,\"total_price\":11.55}]}', '{\"items\": [{\"unit\": \"un\", \"quantity\": 50, \"unit_price\": 0.15, \"description\": \"ESS CEDRO SABONETE\", \"total_price\": 7.5}, {\"unit\": \"un\", \"quantity\": 50, \"unit_price\": 0.15, \"description\": \"ESS P KIT PATCHOLY\", \"total_price\": 7.5}, {\"unit\": \"un\", \"quantity\": 1, \"unit_price\": 7.3, \"description\": \"SABONETE LIQUIDO AROMAS YANTRA\", \"total_price\": 7.3}, {\"unit\": \"un\", \"quantity\": 5, \"unit_price\": 1.15, \"description\": \"VARETA OLHO GREGO MINI\", \"total_price\": 5.75}, {\"unit\": \"un\", \"quantity\": 3, \"unit_price\": 1.49, \"description\": \"VARETA ESTRELA MADEIRA PEQUENA\", \"total_price\": 4.47}, {\"unit\": \"un\", \"quantity\": 5, \"unit_price\": 0.95, \"description\": \"VARETA FRAMBOESA MINI C/ARGOLA\", \"total_price\": 4.75}, {\"unit\": \"un\", \"quantity\": 3, \"unit_price\": 0.6, \"description\": \"VARETA MINI C/ ARGOLA 12CM\", \"total_price\": 1.8}, {\"unit\": \"un\", \"quantity\": 7, \"unit_price\": 1.65, \"description\": \"PINGENTE DIFUSOR C/PONTEIRA BOLA MADEIRA\", \"total_price\": 11.55}], \"supplier\": \"ANINHA DAS ESSENCIAS\", \"total_value\": 50.62, \"purchase_date\": \"2026-04-20\", \"document_number\": \"438160\"}', 3, 'ANINHA DAS ESSENCIAS', '2026-04-20', '438160', 50.62, NULL, NULL, '2026-05-21 16:55:01', '2026-05-21 16:48:32', '2026-05-21 16:55:01', NULL),
(22, 1, 'completed', 'image', 'smart_input/1/KkeeFXRmhFMiW67LzfAPJgdzZGv8wAfIKD5fgsLE.jpg', 'Nota06_22-05-26.jpeg', '{\"supplier\":null,\"purchase_date\":\"2026-05-22\",\"document_number\":\"42081\",\"total_value\":53.27,\"items\":[{\"description\":\"VIDRO AMBAR GPP 200ML 28\\/400 LAVADO\",\"quantity\":20,\"unit\":\"un\",\"unit_price\":1.1,\"total_price\":22},{\"description\":\"VALVULA SPRAY LUXO 28\\/410 SAIA PRETA\\/NAT\",\"quantity\":0.01,\"unit\":\"un\",\"unit_price\":1728,\"total_price\":17.28},{\"description\":\"VALVULA GATILHO MINI 28\\/410 PRETA C\\/TRV\",\"quantity\":0.01,\"unit\":\"un\",\"unit_price\":1399,\"total_price\":13.99}]}', '{\"items\": [{\"unit\": \"un\", \"quantity\": 20, \"unit_price\": 1.1, \"description\": \"VIDRO AMBAR GPP 200ML 28/400 LAVADO\", \"total_price\": 22}, {\"unit\": \"un\", \"quantity\": 0.01, \"unit_price\": 1728, \"description\": \"VALVULA SPRAY LUXO 28/410 SAIA PRETA/NAT\", \"total_price\": 17.28}, {\"unit\": \"un\", \"quantity\": 0.01, \"unit_price\": 1399, \"description\": \"VALVULA GATILHO MINI 28/410 PRETA C/TRV\", \"total_price\": 13.99}], \"supplier\": null, \"total_value\": 53.27, \"purchase_date\": \"2026-05-22\", \"document_number\": \"42081\"}', 3, NULL, '2026-05-22', '42081', 53.27, NULL, NULL, '2026-05-23 03:55:48', '2026-05-23 03:50:41', '2026-05-23 03:55:48', NULL),
(23, 1, 'completed', 'image', 'smart_input/1/lGwwaRr2QQAArlvvIEDLzu1vIakzXQbsaamy5rQA.jpg', 'Nota07_22-05-26.jpeg', '{\"supplier\":null,\"purchase_date\":\"2026-05-22\",\"document_number\":\"42078\",\"total_value\":212.4,\"items\":[{\"description\":\"FRASCO PET   35ML BASE VITA 20\\/410 36\\/10\",\"quantity\":0.01,\"unit\":\"un\",\"unit_price\":543,\"total_price\":5.43},{\"description\":\"FRASCO PET   30ML OVAL 20\\/410 R.35\\/10\",\"quantity\":0.02,\"unit\":\"un\",\"unit_price\":550,\"total_price\":11},{\"description\":\"FRASCO PVC  30ML OVAL CRISTAL 18\\/410 F22\",\"quantity\":0.01,\"unit\":\"un\",\"unit_price\":595,\"total_price\":5.95},{\"description\":\"FRASCO PET   60ML OVAL 18\\/410 8G REF:120\",\"quantity\":0.02,\"unit\":\"un\",\"unit_price\":555,\"total_price\":11.1},{\"description\":\"FRASCO PET   10ML CILINDRICO 18\\/410 BCO\",\"quantity\":0.1,\"unit\":\"un\",\"unit_price\":288,\"total_price\":28.8},{\"description\":\"TAMPA FLIP TOP 18\\/410 PINK ISOS\",\"quantity\":0.05,\"unit\":\"un\",\"unit_price\":271,\"total_price\":13.55},{\"description\":\"TAMPA FLIP TOP OMEGA 18\\/410 MARROM\",\"quantity\":0.06,\"unit\":\"un\",\"unit_price\":125,\"total_price\":7.5},{\"description\":\"TAMPA FLIP TOP 18\\/410 PRETA ABAULADA IS\",\"quantity\":0.02,\"unit\":\"un\",\"unit_price\":271,\"total_price\":5.42},{\"description\":\"TAMPA FLIP TOP OMEGA 20\\/410 VERDE R.45\",\"quantity\":0.02,\"unit\":\"un\",\"unit_price\":155,\"total_price\":3.1},{\"description\":\"TAMPA FLIP TOP OMEGA 20\\/410 LILAS 08\",\"quantity\":0.005,\"unit\":\"un\",\"unit_price\":150,\"total_price\":0.75},{\"description\":\"FRASCO AMBAR PET  35ML BASE VIT 20\\/41 36\",\"quantity\":0.001,\"unit\":\"un\",\"unit_price\":597,\"total_price\":0.6},{\"description\":\"FRASCO PET  140ML OVAL CRIST.24\\/415 5969\",\"quantity\":0.05,\"unit\":\"un\",\"unit_price\":1236,\"total_price\":61.8},{\"description\":\"POTE  04GRS.CRISTAL\\/BRANCO C\\/TP CORES\",\"quantity\":0.2,\"unit\":\"un\",\"unit_price\":260,\"total_price\":52},{\"description\":\"POTE 500GRS.OVAL PRATA TP FIO OURO\\/PRATA\",\"quantity\":2,\"unit\":\"un\",\"unit_price\":2.7,\"total_price\":5.4}]}', '{\"items\": [{\"unit\": \"un\", \"quantity\": 0.01, \"unit_price\": 543, \"description\": \"FRASCO PET   35ML BASE VITA 20/410 36/10\", \"total_price\": 5.43}, {\"unit\": \"un\", \"quantity\": 0.02, \"unit_price\": 550, \"description\": \"FRASCO PET   30ML OVAL 20/410 R.35/10\", \"total_price\": 11}, {\"unit\": \"un\", \"quantity\": 0.01, \"unit_price\": 595, \"description\": \"FRASCO PVC  30ML OVAL CRISTAL 18/410 F22\", \"total_price\": 5.95}, {\"unit\": \"un\", \"quantity\": 0.02, \"unit_price\": 555, \"description\": \"FRASCO PET   60ML OVAL 18/410 8G REF:120\", \"total_price\": 11.1}, {\"unit\": \"un\", \"quantity\": 0.1, \"unit_price\": 288, \"description\": \"FRASCO PET   10ML CILINDRICO 18/410 BCO\", \"total_price\": 28.8}, {\"unit\": \"un\", \"quantity\": 0.05, \"unit_price\": 271, \"description\": \"TAMPA FLIP TOP 18/410 PINK ISOS\", \"total_price\": 13.55}, {\"unit\": \"un\", \"quantity\": 0.06, \"unit_price\": 125, \"description\": \"TAMPA FLIP TOP OMEGA 18/410 MARROM\", \"total_price\": 7.5}, {\"unit\": \"un\", \"quantity\": 0.02, \"unit_price\": 271, \"description\": \"TAMPA FLIP TOP 18/410 PRETA ABAULADA IS\", \"total_price\": 5.42}, {\"unit\": \"un\", \"quantity\": 0.02, \"unit_price\": 155, \"description\": \"TAMPA FLIP TOP OMEGA 20/410 VERDE R.45\", \"total_price\": 3.1}, {\"unit\": \"un\", \"quantity\": 0.005, \"unit_price\": 150, \"description\": \"TAMPA FLIP TOP OMEGA 20/410 LILAS 08\", \"total_price\": 0.75}, {\"unit\": \"un\", \"quantity\": 0.001, \"unit_price\": 597, \"description\": \"FRASCO AMBAR PET  35ML BASE VIT 20/41 36\", \"total_price\": 0.6}, {\"unit\": \"un\", \"quantity\": 0.05, \"unit_price\": 1236, \"description\": \"FRASCO PET  140ML OVAL CRIST.24/415 5969\", \"total_price\": 61.8}, {\"unit\": \"un\", \"quantity\": 0.2, \"unit_price\": 260, \"description\": \"POTE  04GRS.CRISTAL/BRANCO C/TP CORES\", \"total_price\": 52}, {\"unit\": \"un\", \"quantity\": 2, \"unit_price\": 2.7, \"description\": \"POTE 500GRS.OVAL PRATA TP FIO OURO/PRATA\", \"total_price\": 5.4}], \"supplier\": null, \"total_value\": 212.4, \"purchase_date\": \"2026-05-22\", \"document_number\": \"42078\"}', 3, NULL, '2026-05-22', '42078', 212.40, NULL, NULL, '2026-05-23 04:11:20', '2026-05-23 03:56:55', '2026-05-23 04:11:20', NULL),
(24, 1, 'completed', 'image', 'smart_input/1/YXZNCmcUwAutmF22JHzPTycYwPTeM81jPL5wmZA9.jpg', 'Nota08_22-05-26.jpeg', '{\"supplier\":\"W.ESSENCIAS - COMERCIO E ARTESANATO\",\"purchase_date\":\"2026-05-22\",\"document_number\":\"068090\",\"total_value\":403,\"items\":[{\"description\":\"ESS LAVANDA & ALGODAO MAHOGANY-ISAN\",\"quantity\":0.4,\"unit\":\"LT\",\"unit_price\":280,\"total_price\":112},{\"description\":\"ESS SCANDALO JEAN PAUL FEM - DOMO\",\"quantity\":0.1,\"unit\":\"LT\",\"unit_price\":400,\"total_price\":40},{\"description\":\"ESS ARABE FAKAR BLACK UNISEX 50ML\",\"quantity\":1,\"unit\":\"UN\",\"unit_price\":45,\"total_price\":45},{\"description\":\"ESS ARABE ROYAL AMBER UNISEX\",\"quantity\":1,\"unit\":\"UN\",\"unit_price\":45,\"total_price\":45},{\"description\":\"ESS ARABE DELINIA LA ROSÉ FEM. 50ML\",\"quantity\":1,\"unit\":\"UN\",\"unit_price\":45,\"total_price\":45},{\"description\":\"BASE PARA BODY SPLASH\",\"quantity\":2,\"unit\":\"LT\",\"unit_price\":18,\"total_price\":36},{\"description\":\"FRASCO PET 200ML R 24\\/410 CRISTAL AURA C\\/TP\",\"quantity\":10,\"unit\":\"UN\",\"unit_price\":2.65,\"total_price\":26.5},{\"description\":\"VALVULA SPRAY R.24\\/410 OURO HOT STAMP\",\"quantity\":10,\"unit\":\"UN\",\"unit_price\":1.65,\"total_price\":16.5},{\"description\":\"BASE P PERFUME VEICULO 1LT\",\"quantity\":1,\"unit\":\"LT\",\"unit_price\":18,\"total_price\":18},{\"description\":\"POTE DE VIDRO REDONDO 30ML C\\/TP\",\"quantity\":10,\"unit\":\"UN\",\"unit_price\":3.85,\"total_price\":38.5}]}', '{\"items\": [{\"unit\": \"LT\", \"quantity\": 0.4, \"unit_price\": 280, \"description\": \"ESS LAVANDA & ALGODAO MAHOGANY-ISAN\", \"total_price\": 112}, {\"unit\": \"LT\", \"quantity\": 0.1, \"unit_price\": 400, \"description\": \"ESS SCANDALO JEAN PAUL FEM - DOMO\", \"total_price\": 40}, {\"unit\": \"UN\", \"quantity\": 1, \"unit_price\": 45, \"description\": \"ESS ARABE FAKAR BLACK UNISEX 50ML\", \"total_price\": 45}, {\"unit\": \"UN\", \"quantity\": 1, \"unit_price\": 45, \"description\": \"ESS ARABE ROYAL AMBER UNISEX\", \"total_price\": 45}, {\"unit\": \"UN\", \"quantity\": 1, \"unit_price\": 45, \"description\": \"ESS ARABE DELINIA LA ROSÉ FEM. 50ML\", \"total_price\": 45}, {\"unit\": \"LT\", \"quantity\": 2, \"unit_price\": 18, \"description\": \"BASE PARA BODY SPLASH\", \"total_price\": 36}, {\"unit\": \"UN\", \"quantity\": 10, \"unit_price\": 2.65, \"description\": \"FRASCO PET 200ML R 24/410 CRISTAL AURA C/TP\", \"total_price\": 26.5}, {\"unit\": \"UN\", \"quantity\": 10, \"unit_price\": 1.65, \"description\": \"VALVULA SPRAY R.24/410 OURO HOT STAMP\", \"total_price\": 16.5}, {\"unit\": \"LT\", \"quantity\": 1, \"unit_price\": 18, \"description\": \"BASE P PERFUME VEICULO 1LT\", \"total_price\": 18}, {\"unit\": \"UN\", \"quantity\": 10, \"unit_price\": 3.85, \"description\": \"POTE DE VIDRO REDONDO 30ML C/TP\", \"total_price\": 38.5}], \"supplier\": \"W.ESSENCIAS - COMERCIO E ARTESANATO\", \"total_value\": 403, \"purchase_date\": \"2026-05-22\", \"document_number\": \"068090\"}', 2, 'W.ESSENCIAS - COMERCIO E ARTESANATO', '2026-05-22', '068090', 403.00, NULL, NULL, '2026-05-23 04:25:44', '2026-05-23 04:11:50', '2026-05-23 04:25:44', NULL),
(25, 1, 'completed', 'image', 'smart_input/1/MyGh3iFzSbcp084sp6v4oRU3JfUfCGGPIW6KsyXP.jpg', 'Nota09_22-05-26.jpeg', '{\"supplier\":\"PARIS ESSENCIAS\",\"purchase_date\":\"2026-05-22\",\"document_number\":\"0231398\",\"total_value\":80,\"items\":[{\"description\":\"TAMPA PLAST. POTE MET. DOURADA TRADITION\",\"quantity\":1,\"unit\":\"PC\",\"unit_price\":2,\"total_price\":2},{\"description\":\"POTE PET 1LT WHEY ROSA\",\"quantity\":1,\"unit\":\"UN\",\"unit_price\":3,\"total_price\":3},{\"description\":\"ESS.CLASSIC 7 ERVAS 100ML R.CC113 DOMO\",\"quantity\":1,\"unit\":\"UN\",\"unit_price\":20,\"total_price\":20},{\"description\":\"ESS.CLASSIC CAFE 100ML R GC0059 DOMO\",\"quantity\":1,\"unit\":\"UN\",\"unit_price\":20,\"total_price\":20},{\"description\":\"ESS.CLASSIC DOVE 100ML 17.013 DOMO ZZZ\",\"quantity\":1,\"unit\":\"UN\",\"unit_price\":18,\"total_price\":16},{\"description\":\"ESSENCIA P\\/AROMATIZADOR DIVERSAS PROMOCAO\",\"quantity\":2,\"unit\":\"UN\",\"unit_price\":10,\"total_price\":20}]}', '{\"items\": [{\"unit\": \"PC\", \"quantity\": 1, \"unit_price\": 2, \"description\": \"TAMPA PLAST. POTE MET. DOURADA TRADITION\", \"total_price\": 2}, {\"unit\": \"UN\", \"quantity\": 1, \"unit_price\": 3, \"description\": \"POTE PET 1LT WHEY ROSA\", \"total_price\": 3}, {\"unit\": \"UN\", \"quantity\": 1, \"unit_price\": 20, \"description\": \"ESS.CLASSIC 7 ERVAS 100ML R.CC113 DOMO\", \"total_price\": 20}, {\"unit\": \"UN\", \"quantity\": 1, \"unit_price\": 20, \"description\": \"ESS.CLASSIC CAFE 100ML R GC0059 DOMO\", \"total_price\": 20}, {\"unit\": \"UN\", \"quantity\": 1, \"unit_price\": 18, \"description\": \"ESS.CLASSIC DOVE 100ML 17.013 DOMO ZZZ\", \"total_price\": 16}, {\"unit\": \"UN\", \"quantity\": 2, \"unit_price\": 10, \"description\": \"ESSENCIA P/AROMATIZADOR DIVERSAS PROMOCAO\", \"total_price\": 20}], \"supplier\": \"PARIS ESSENCIAS\", \"total_value\": 80, \"purchase_date\": \"2026-05-22\", \"document_number\": \"0231398\"}', 4, 'PARIS ESSENCIAS', '2026-05-22', '0231398', 80.00, NULL, NULL, '2026-05-23 04:46:37', '2026-05-23 04:35:31', '2026-05-23 04:46:37', NULL),
(26, 1, 'failed', 'image', 'smart_input/1/IcuTIEUxbbezXvpOlphgRoB8ovORaw0agUt3LUoC.jpg', 'Nota10_22-05-26.jpeg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'A IA não retornou um JSON válido. Verifique a qualidade da imagem e tente novamente.', NULL, NULL, '2026-05-23 04:46:58', '2026-05-23 04:50:54', '2026-05-23 04:50:54'),
(27, 1, 'failed', 'image', 'smart_input/1/U90wCFWRsxqvccn1Zodw8dcg2FfBjFyLCbpPkjZh.jpg', 'Nota10_22-05-26.jpeg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'A IA não retornou um JSON válido. Verifique a qualidade da imagem e tente novamente.', NULL, NULL, '2026-05-23 04:50:12', '2026-05-23 05:40:52', '2026-05-23 05:40:52'),
(28, 1, 'completed', 'manual', NULL, NULL, NULL, NULL, 5, NULL, '2026-05-22', '177245', NULL, NULL, NULL, '2026-05-23 05:40:43', '2026-05-23 05:40:37', '2026-05-23 05:40:43', NULL),
(29, 30, 'completed', 'image', 'smart_input/30/zJN8gh0l6YMVWn9o8OGf1QmlDHUUzhoFlCTX87Ci.jpg', 'Nota11_29-05-26.jpeg', '{\"supplier\":\"W.ESSENCIAS - COMERCIO E ARTESANATO\",\"purchase_date\":\"2026-05-29\",\"document_number\":\"068269\",\"total_value\":735,\"items\":[{\"description\":\"FRASCO PET 200ML R.24\\/410 CRISTAL AURA C\\/TP\",\"quantity\":30,\"unit\":\"UN\",\"unit_price\":2.65,\"total_price\":79.5},{\"description\":\"FRASCO PET 100ML R.24\\/410 CRISTAL ACQUA\",\"quantity\":30,\"unit\":\"PC\",\"unit_price\":1.65,\"total_price\":49.5},{\"description\":\"VALVULA SPRAY R.24\\/410 OURO HOT STAMP\",\"quantity\":60,\"unit\":\"UN\",\"unit_price\":1.65,\"total_price\":99},{\"description\":\"ESS ARABE ROYAL AMBER UNISEX LESS\",\"quantity\":2,\"unit\":\"UN\",\"unit_price\":45,\"total_price\":90},{\"description\":\"ESS LAVANDA INGLESA - OAK OAK - 5169\",\"quantity\":0.1,\"unit\":\"LT\",\"unit_price\":260,\"total_price\":26},{\"description\":\"ESS LAVANDA FRANCESA - OAK OAK 51690\",\"quantity\":0.1,\"unit\":\"LT\",\"unit_price\":240,\"total_price\":24},{\"description\":\"ESS LAVANDA PROVENCE - LESS LAP 28675\",\"quantity\":0.1,\"unit\":\"LT\",\"unit_price\":250,\"total_price\":25},{\"description\":\"ESS SCANDALO JEAN PAUL FEM - DOMO\",\"quantity\":0.1,\"unit\":\"LT\",\"unit_price\":400,\"total_price\":40},{\"description\":\"ESS ARABE ASSAD BOURBON MASC. 50ML\",\"quantity\":1,\"unit\":\"UN\",\"unit_price\":45,\"total_price\":45},{\"description\":\"ESS ARABE ASSAD MASC. 50ML LESS\",\"quantity\":1,\"unit\":\"UN\",\"unit_price\":45,\"total_price\":45},{\"description\":\"BASE PARA BODY SPLASH\",\"quantity\":8,\"unit\":\"LT\",\"unit_price\":18,\"total_price\":144},{\"description\":\"BASE PARA BODY SPLASH S\\/MICA\",\"quantity\":2,\"unit\":\"PC\",\"unit_price\":16,\"total_price\":32},{\"description\":\"BASE P PERFUME VEICULO 1LT\",\"quantity\":2,\"unit\":\"LT\",\"unit_price\":18,\"total_price\":36}]}', '{\"items\": [{\"unit\": \"UN\", \"quantity\": 30, \"unit_price\": 2.65, \"description\": \"FRASCO PET 200ML R.24/410 CRISTAL AURA C/TP\", \"total_price\": 79.5}, {\"unit\": \"PC\", \"quantity\": 30, \"unit_price\": 1.65, \"description\": \"FRASCO PET 100ML R.24/410 CRISTAL ACQUA\", \"total_price\": 49.5}, {\"unit\": \"UN\", \"quantity\": 60, \"unit_price\": 1.65, \"description\": \"VALVULA SPRAY R.24/410 OURO HOT STAMP\", \"total_price\": 99}, {\"unit\": \"UN\", \"quantity\": 2, \"unit_price\": 45, \"description\": \"ESS ARABE ROYAL AMBER UNISEX LESS\", \"total_price\": 90}, {\"unit\": \"LT\", \"quantity\": 0.1, \"unit_price\": 260, \"description\": \"ESS LAVANDA INGLESA - OAK OAK - 5169\", \"total_price\": 26}, {\"unit\": \"LT\", \"quantity\": 0.1, \"unit_price\": 240, \"description\": \"ESS LAVANDA FRANCESA - OAK OAK 51690\", \"total_price\": 24}, {\"unit\": \"LT\", \"quantity\": 0.1, \"unit_price\": 250, \"description\": \"ESS LAVANDA PROVENCE - LESS LAP 28675\", \"total_price\": 25}, {\"unit\": \"LT\", \"quantity\": 0.1, \"unit_price\": 400, \"description\": \"ESS SCANDALO JEAN PAUL FEM - DOMO\", \"total_price\": 40}, {\"unit\": \"UN\", \"quantity\": 1, \"unit_price\": 45, \"description\": \"ESS ARABE ASSAD BOURBON MASC. 50ML\", \"total_price\": 45}, {\"unit\": \"UN\", \"quantity\": 1, \"unit_price\": 45, \"description\": \"ESS ARABE ASSAD MASC. 50ML LESS\", \"total_price\": 45}, {\"unit\": \"LT\", \"quantity\": 8, \"unit_price\": 18, \"description\": \"BASE PARA BODY SPLASH\", \"total_price\": 144}, {\"unit\": \"PC\", \"quantity\": 2, \"unit_price\": 16, \"description\": \"BASE PARA BODY SPLASH S/MICA\", \"total_price\": 32}, {\"unit\": \"LT\", \"quantity\": 2, \"unit_price\": 18, \"description\": \"BASE P PERFUME VEICULO 1LT\", \"total_price\": 36}], \"supplier\": \"W.ESSENCIAS - COMERCIO E ARTESANATO\", \"total_value\": 735, \"purchase_date\": \"2026-05-29\", \"document_number\": \"068269\"}', 2, 'W.ESSENCIAS - COMERCIO E ARTESANATO', '2026-05-29', '068269', 735.00, NULL, NULL, '2026-06-03 18:01:49', '2026-06-03 17:50:42', '2026-06-03 18:01:49', NULL),
(30, 30, 'completed', 'image', 'smart_input/30/4mVBVxb86bGmwj2QzgpShL8iYm2r8anAFN2jUfPB.jpg', 'Nota12_29-05-26.jpeg', '{\"supplier\":null,\"purchase_date\":\"2026-05-29\",\"document_number\":\"42923\",\"total_value\":377.6,\"items\":[{\"description\":\"VIDRO AMBAR GPP 200ML 28\\/400 LAVADO\",\"quantity\":126,\"unit\":\"un\",\"unit_price\":1.1,\"total_price\":138.6},{\"description\":\"VALVULA SPRAY LUXO 28\\/410 SAIA PRETA\\/NAT\",\"quantity\":0.063,\"unit\":\"un\",\"unit_price\":1728,\"total_price\":108.86},{\"description\":\"VALVULA GATILHO MINI 28\\/410 PRETA C\\/TRV\",\"quantity\":0.063,\"unit\":\"un\",\"unit_price\":1399,\"total_price\":88.14},{\"description\":\"VIDRO AMOSTRA 1.8ML TP PRESSAO F2\",\"quantity\":0.1,\"unit\":\"un\",\"unit_price\":420,\"total_price\":42}]}', '{\"items\": [{\"unit\": \"un\", \"quantity\": 126, \"unit_price\": 1.1, \"description\": \"VIDRO AMBAR GPP 200ML 28/400 LAVADO\", \"total_price\": 138.6}, {\"unit\": \"un\", \"quantity\": 0.063, \"unit_price\": 1728, \"description\": \"VALVULA SPRAY LUXO 28/410 SAIA PRETA/NAT\", \"total_price\": 108.86}, {\"unit\": \"un\", \"quantity\": 0.063, \"unit_price\": 1399, \"description\": \"VALVULA GATILHO MINI 28/410 PRETA C/TRV\", \"total_price\": 88.14}, {\"unit\": \"un\", \"quantity\": 0.1, \"unit_price\": 420, \"description\": \"VIDRO AMOSTRA 1.8ML TP PRESSAO F2\", \"total_price\": 42}], \"supplier\": null, \"total_value\": 377.6, \"purchase_date\": \"2026-05-29\", \"document_number\": \"42923\"}', 3, NULL, '2026-05-29', '42923', 377.60, NULL, NULL, '2026-06-03 18:05:23', '2026-06-03 18:02:14', '2026-06-03 18:05:23', NULL),
(31, 30, 'failed', 'image', 'smart_input/30/0Ujnkrt7DSkoGo6gYKh2oqhvvAIzvK7lbn3fOWwh.jpg', 'Nota13_29-05-26.jpeg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Erro na API Gemini: This model is currently experiencing high demand. Spikes in demand are usually temporary. Please try again later.', NULL, NULL, '2026-06-03 18:06:22', '2026-06-03 18:09:41', '2026-06-03 18:09:41'),
(32, 30, 'completed', 'manual', NULL, NULL, NULL, NULL, 5, NULL, '2026-05-29', NULL, NULL, NULL, NULL, '2026-06-03 18:09:35', '2026-06-03 18:09:30', '2026-06-03 18:09:35', NULL),
(33, 30, 'failed', 'image', 'smart_input/30/wf5l1vkg8yaD6pUpkGAbc69o6aYo8zpVHLqkF593.jpg', 'Nota14_29-05-26.jpeg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Erro na API Gemini: This model is currently experiencing high demand. Spikes in demand are usually temporary. Please try again later.', NULL, NULL, '2026-06-03 18:10:00', '2026-06-03 19:41:12', '2026-06-03 19:41:12'),
(34, 30, 'failed', 'image', 'smart_input/30/CffMHHqImdwZbPKnvBOrCAfIUA0BMouhhnqa83qJ.jpg', 'Nota15_29-05-26.jpeg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Erro na API Gemini: This model is currently experiencing high demand. Spikes in demand are usually temporary. Please try again later.', NULL, NULL, '2026-06-03 18:14:39', '2026-06-03 19:41:14', '2026-06-03 19:41:14'),
(35, 30, 'completed', 'image', 'smart_input/30/XSBc18BK2OjHHaEhohdJeIx8aZXVziV6UHyL5PwS.jpg', 'Nota15_29-05-26.jpeg', '{\"supplier\":\"ANINHA DAS ESSENCIAS\",\"purchase_date\":\"2026-05-29\",\"document_number\":\"443019\",\"total_value\":237.27,\"items\":[{\"description\":\"LACO DE STRASS CORES\",\"quantity\":4,\"unit\":\"un\",\"unit_price\":3.99,\"total_price\":15.96},{\"description\":\"LACO 2 FLORES CAMELIAS\",\"quantity\":13,\"unit\":\"un\",\"unit_price\":6.45,\"total_price\":83.85},{\"description\":\"BASE CREME HIDRATANTE NEUTRO C\\/UREIA YNT\",\"quantity\":2,\"unit\":\"un\",\"unit_price\":14.98,\"total_price\":29.96},{\"description\":\"BASE CREME HIDRATANTE 1.4 1KG-YANTRA\",\"quantity\":2,\"unit\":\"un\",\"unit_price\":24.35,\"total_price\":48.7},{\"description\":\"BASE PARA PERFUME 1LITRO YANTRA\",\"quantity\":4,\"unit\":\"un\",\"unit_price\":14.7,\"total_price\":58.8}]}', '{\"items\": [{\"unit\": \"un\", \"quantity\": 4, \"unit_price\": 3.99, \"description\": \"LACO DE STRASS CORES\", \"total_price\": 15.96}, {\"unit\": \"un\", \"quantity\": 13, \"unit_price\": 6.45, \"description\": \"LACO 2 FLORES CAMELIAS\", \"total_price\": 83.85}, {\"unit\": \"un\", \"quantity\": 2, \"unit_price\": 14.98, \"description\": \"BASE CREME HIDRATANTE NEUTRO C/UREIA YNT\", \"total_price\": 29.96}, {\"unit\": \"un\", \"quantity\": 2, \"unit_price\": 24.35, \"description\": \"BASE CREME HIDRATANTE 1.4 1KG-YANTRA\", \"total_price\": 48.7}, {\"unit\": \"un\", \"quantity\": 4, \"unit_price\": 14.7, \"description\": \"BASE PARA PERFUME 1LITRO YANTRA\", \"total_price\": 58.8}], \"supplier\": \"ANINHA DAS ESSENCIAS\", \"total_value\": 237.27, \"purchase_date\": \"2026-05-29\", \"document_number\": \"443019\"}', 7, 'ANINHA DAS ESSENCIAS', '2026-05-29', '443019', 237.27, NULL, NULL, '2026-06-03 19:41:05', '2026-06-03 18:15:44', '2026-06-03 19:41:05', NULL),
(36, 30, 'failed', 'image', 'smart_input/30/VdGKSen2a2EvSKeN1m4RNiJt9XBQpxFoQYVliT6X.jpg', 'Nota16_29-05-26.jpeg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'A IA não retornou um JSON válido. Verifique a qualidade da imagem e tente novamente.', NULL, NULL, '2026-06-03 19:41:51', '2026-06-03 20:06:43', '2026-06-03 20:06:43'),
(37, 30, 'failed', 'image', 'smart_input/30/o935tfTXb64PEoOMjZlsgYcV4pxVmV8CcY5sjdpb.jpg', 'Nota16_29-05-26.jpeg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'A IA não retornou um JSON válido. Verifique a qualidade da imagem e tente novamente.', NULL, NULL, '2026-06-03 19:43:08', '2026-06-03 20:06:38', '2026-06-03 20:06:38'),
(38, 30, 'failed', 'image', 'smart_input/30/PNmCpG0Z1SUlWQoL9VwGRw9iZzpatfv62fyM3lC2.jpg', 'Nota16_29-05-26.jpeg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'A IA não retornou um JSON válido. Verifique a qualidade da imagem e tente novamente.', NULL, NULL, '2026-06-03 19:54:26', '2026-06-03 20:06:36', '2026-06-03 20:06:36'),
(39, 30, 'failed', 'image', 'smart_input/30/6Gy5crfYgBTFdApiFCHxqMVuOcaQ3jLbNy2s244b.jpg', 'Nota16_29-05-26.jpeg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'A IA não retornou um JSON válido. Verifique a qualidade da imagem e tente novamente.', NULL, NULL, '2026-06-03 19:55:04', '2026-06-03 20:06:33', '2026-06-03 20:06:33'),
(40, 30, 'failed', 'image', 'smart_input/30/8Af5FnPo1RIvqPfMF99U6vw1DOl9MGtrLiZ4LmKT.jpg', 'Nota16_29-05-26.jpeg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'A IA não retornou um JSON válido. Verifique a qualidade da imagem e tente novamente.', NULL, NULL, '2026-06-03 19:56:31', '2026-06-03 20:06:40', '2026-06-03 20:06:40'),
(41, 30, 'failed', 'image', 'smart_input/30/blckDA3yXsBn2XwQDBY5Mh1bmaGstLyRCgdHuL77.jpg', 'Nota16_29-05-26.jpeg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'A IA não retornou um JSON válido. Verifique a qualidade da imagem e tente novamente.', NULL, NULL, '2026-06-03 19:58:34', '2026-06-03 20:06:28', '2026-06-03 20:06:28'),
(42, 30, 'completed', 'image', 'smart_input/30/6J4uOrYCEc5rB1Rf72l92BZM6CHTzW9t8EVwvrzR.jpg', 'Nota17_29-05-26.jpeg', '{\"supplier\":\"COMERCIO DE OLEOS E ESSENCIAS SILEIRA MARTINS LTDA\",\"purchase_date\":\"2026-05-29\",\"document_number\":\"000039668\",\"total_value\":545.01,\"items\":[{\"description\":\"BASE SAB. LIQ. VEGETAL VG 1X4 TRANSPARENTE LT\",\"quantity\":1,\"unit\":\"UN\",\"unit_price\":24,\"total_price\":23.05},{\"description\":\"ETIQUETA METALIZADA 3UN\",\"quantity\":8,\"unit\":\"UN\",\"unit_price\":5.5,\"total_price\":42.26},{\"description\":\"DOSADOR 01ML\",\"quantity\":2,\"unit\":\"UN\",\"unit_price\":0.55,\"total_price\":1.06},{\"description\":\"BASE SAB. LIQ. VEGETAL VG 1X4 PEROLADA LT\",\"quantity\":1,\"unit\":\"UN\",\"unit_price\":24,\"total_price\":23.05},{\"description\":\"RENEX NONILFENOL ETOXILADO 95 100 ML\",\"quantity\":1,\"unit\":\"UN\",\"unit_price\":6,\"total_price\":5.76},{\"description\":\"VD IMP 050ML ARABE COLOR COM VALV. E CAPA UN\",\"quantity\":4,\"unit\":\"UN\",\"unit_price\":18.8,\"total_price\":72.25},{\"description\":\"ESS V.S. PEAR SUGAR LINHA A 30ML\",\"quantity\":1,\"unit\":\"UN\",\"unit_price\":30,\"total_price\":28.82},{\"description\":\"PAPEL PH NACIONAL 100UN\",\"quantity\":1,\"unit\":\"UN\",\"unit_price\":22,\"total_price\":21.13},{\"description\":\"ETIQUETAS DIVERSAS TRANSPARENTE C\\/ 20 UN\",\"quantity\":2,\"unit\":\"UN\",\"unit_price\":3.5,\"total_price\":6.72}]}', '{\"items\": [{\"unit\": \"UN\", \"quantity\": 1, \"unit_price\": 24, \"description\": \"BASE SAB. LIQ. VEGETAL VG 1X4 TRANSPARENTE LT\", \"total_price\": 23.05}, {\"unit\": \"UN\", \"quantity\": 8, \"unit_price\": 5.5, \"description\": \"ETIQUETA METALIZADA 3UN\", \"total_price\": 42.26}, {\"unit\": \"UN\", \"quantity\": 2, \"unit_price\": 0.55, \"description\": \"DOSADOR 01ML\", \"total_price\": 1.06}, {\"unit\": \"UN\", \"quantity\": 1, \"unit_price\": 24, \"description\": \"BASE SAB. LIQ. VEGETAL VG 1X4 PEROLADA LT\", \"total_price\": 23.05}, {\"unit\": \"UN\", \"quantity\": 1, \"unit_price\": 6, \"description\": \"RENEX NONILFENOL ETOXILADO 95 100 ML\", \"total_price\": 5.76}, {\"unit\": \"UN\", \"quantity\": 4, \"unit_price\": 18.8, \"description\": \"VD IMP 050ML ARABE COLOR COM VALV. E CAPA UN\", \"total_price\": 72.25}, {\"unit\": \"UN\", \"quantity\": 1, \"unit_price\": 30, \"description\": \"ESS V.S. PEAR SUGAR LINHA A 30ML\", \"total_price\": 28.82}, {\"unit\": \"UN\", \"quantity\": 1, \"unit_price\": 22, \"description\": \"PAPEL PH NACIONAL 100UN\", \"total_price\": 21.13}, {\"unit\": \"UN\", \"quantity\": 2, \"unit_price\": 3.5, \"description\": \"ETIQUETAS DIVERSAS TRANSPARENTE C/ 20 UN\", \"total_price\": 6.72}], \"supplier\": \"COMERCIO DE OLEOS E ESSENCIAS SILEIRA MARTINS LTDA\", \"total_value\": 545.01, \"purchase_date\": \"2026-05-29\", \"document_number\": \"000039668\"}', 1, 'COMERCIO DE OLEOS E ESSENCIAS SILEIRA MARTINS LTDA', '2026-05-29', '000039668', 545.01, NULL, NULL, '2026-06-03 20:06:22', '2026-06-03 19:59:52', '2026-06-03 20:06:22', NULL),
(43, 30, 'completed', 'image', 'smart_input/30/oiM0ZsCcCBdLIcYwEWCFSL4ViOPmA6rm7CSSfVDa.jpg', 'Nota16_29-05-26.jpeg', '{\"supplier\":\"COMERCIO DE OLEOS E ESSENCIAS SILEIRA MARTINS LTDA\",\"purchase_date\":null,\"document_number\":null,\"total_value\":null,\"items\":[{\"description\":\"LAURIL 2000 DECILGLUCOSIDEO 50 1 LT\",\"quantity\":1,\"unit\":\"un\",\"unit_price\":63,\"total_price\":60.51},{\"description\":\"ANFOTERO BETAINICO COCCAMIDOPROPILBETAINA LITRO\",\"quantity\":1,\"unit\":\"un\",\"unit_price\":19,\"total_price\":18.25},{\"description\":\"BASE CREME LIMNE C\\/ ROSA MOSQUETA KG 1993 ONU-1993\",\"quantity\":1,\"unit\":\"un\",\"unit_price\":33,\"total_price\":31.7},{\"description\":\"COR 100ML AGUA LILAS\",\"quantity\":1,\"unit\":\"un\",\"unit_price\":4.5,\"total_price\":4.32},{\"description\":\"COR 100ML AGUA LARANJA\",\"quantity\":1,\"unit\":\"un\",\"unit_price\":4.5,\"total_price\":4.32},{\"description\":\"COR ALIM 10ML BRANCO\",\"quantity\":1,\"unit\":\"un\",\"unit_price\":2.9,\"total_price\":2.79},{\"description\":\"ESS DIOR SAUVA MASC LINHA I 60 ML\",\"quantity\":1,\"unit\":\"un\",\"unit_price\":58,\"total_price\":55.71},{\"description\":\"ESS LANCOM LA NUITE LINHA I 060ML\",\"quantity\":1,\"unit\":\"un\",\"unit_price\":58,\"total_price\":55.71},{\"description\":\"EXT GLICOLICO ABACATE 100ML PROMOCAO 2\",\"quantity\":1,\"unit\":\"un\",\"unit_price\":6.21,\"total_price\":5.96},{\"description\":\"PROMOCAO ESSENCIA 100ML\",\"quantity\":4,\"unit\":\"un\",\"unit_price\":15,\"total_price\":57.63},{\"description\":\"F143 FORMA DE ACETATO CORACAO DECORADO 15 CAV\",\"quantity\":2,\"unit\":\"un\",\"unit_price\":1.5,\"total_price\":2.88},{\"description\":\"F140 FORMA DE ACETATO CORACAO TORTO PEQ 12 CAV\",\"quantity\":2,\"unit\":\"un\",\"unit_price\":1.5,\"total_price\":2.88},{\"description\":\"POTE VD TRANSP 030G TAMPA PRATA\",\"quantity\":2,\"unit\":\"un\",\"unit_price\":4.6,\"total_price\":8.84},{\"description\":\"POTE VD AMBAR 030G TAMPA DOURADA\",\"quantity\":2,\"unit\":\"un\",\"unit_price\":4.9,\"total_price\":9.41}]}', '{\"items\": [{\"unit\": \"un\", \"quantity\": 1, \"unit_price\": 63, \"description\": \"LAURIL 2000 DECILGLUCOSIDEO 50 1 LT\", \"total_price\": 60.51}, {\"unit\": \"un\", \"quantity\": 1, \"unit_price\": 19, \"description\": \"ANFOTERO BETAINICO COCCAMIDOPROPILBETAINA LITRO\", \"total_price\": 18.25}, {\"unit\": \"un\", \"quantity\": 1, \"unit_price\": 33, \"description\": \"BASE CREME LIMNE C/ ROSA MOSQUETA KG 1993 ONU-1993\", \"total_price\": 31.7}, {\"unit\": \"un\", \"quantity\": 1, \"unit_price\": 4.5, \"description\": \"COR 100ML AGUA LILAS\", \"total_price\": 4.32}, {\"unit\": \"un\", \"quantity\": 1, \"unit_price\": 4.5, \"description\": \"COR 100ML AGUA LARANJA\", \"total_price\": 4.32}, {\"unit\": \"un\", \"quantity\": 1, \"unit_price\": 2.9, \"description\": \"COR ALIM 10ML BRANCO\", \"total_price\": 2.79}, {\"unit\": \"un\", \"quantity\": 1, \"unit_price\": 58, \"description\": \"ESS DIOR SAUVA MASC LINHA I 60 ML\", \"total_price\": 55.71}, {\"unit\": \"un\", \"quantity\": 1, \"unit_price\": 58, \"description\": \"ESS LANCOM LA NUITE LINHA I 060ML\", \"total_price\": 55.71}, {\"unit\": \"un\", \"quantity\": 1, \"unit_price\": 6.21, \"description\": \"EXT GLICOLICO ABACATE 100ML PROMOCAO 2\", \"total_price\": 5.96}, {\"unit\": \"un\", \"quantity\": 4, \"unit_price\": 15, \"description\": \"PROMOCAO ESSENCIA 100ML\", \"total_price\": 57.63}, {\"unit\": \"un\", \"quantity\": 2, \"unit_price\": 1.5, \"description\": \"F143 FORMA DE ACETATO CORACAO DECORADO 15 CAV\", \"total_price\": 2.88}, {\"unit\": \"un\", \"quantity\": 2, \"unit_price\": 1.5, \"description\": \"F140 FORMA DE ACETATO CORACAO TORTO PEQ 12 CAV\", \"total_price\": 2.88}, {\"unit\": \"un\", \"quantity\": 2, \"unit_price\": 4.6, \"description\": \"POTE VD TRANSP 030G TAMPA PRATA\", \"total_price\": 8.84}, {\"unit\": \"un\", \"quantity\": 2, \"unit_price\": 4.9, \"description\": \"POTE VD AMBAR 030G TAMPA DOURADA\", \"total_price\": 9.41}], \"supplier\": \"COMERCIO DE OLEOS E ESSENCIAS SILEIRA MARTINS LTDA\", \"total_value\": null, \"purchase_date\": null, \"document_number\": null}', 1, 'COMERCIO DE OLEOS E ESSENCIAS SILEIRA MARTINS LTDA', NULL, NULL, NULL, NULL, NULL, '2026-06-08 21:03:43', '2026-06-03 20:07:42', '2026-06-08 21:03:43', NULL),
(44, 30, 'completed', 'manual', NULL, NULL, NULL, NULL, 8, NULL, '2026-06-08', NULL, NULL, NULL, 'Entrada de Extratos em estoque', '2026-06-08 21:04:07', '2026-06-08 20:56:56', '2026-06-08 21:04:07', NULL),
(45, 30, 'failed', 'image', 'smart_input/30/WniG84MrNqyZwoL3q7HmjmwIu37lDMMHP6sj4QN4.jpg', 'Nota18_05-06-26.jpeg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Erro na API Gemini: This model is currently experiencing high demand. Spikes in demand are usually temporary. Please try again later.', NULL, NULL, '2026-06-09 20:24:21', '2026-06-09 20:24:26', NULL),
(46, 30, 'completed', 'image', 'smart_input/30/oDiidqJW97A0jJAHPckfd9JztI2qdKJdxCGIzTtW.jpg', 'Nota18_05-06-26.jpeg', '{\"supplier\":\"W.ESSENCIAS - COMERCIO E ARTESANATO\",\"purchase_date\":\"2026-06-05\",\"document_number\":\"068501\",\"total_value\":325.6,\"items\":[{\"description\":\"BASE PARA BODY SPLASH\",\"quantity\":3,\"unit\":\"LT\",\"unit_price\":20,\"total_price\":60},{\"description\":\"BASE PARA BODY SPLASH S\\/MICA\",\"quantity\":1,\"unit\":\"PC\",\"unit_price\":18,\"total_price\":18},{\"description\":\"FRASCO PET 200ML R.24\\/410 CRISTAL AURA C\\/TP\",\"quantity\":30,\"unit\":\"UN\",\"unit_price\":2.65,\"total_price\":79.5},{\"description\":\"VALVULA SPRAY R 24\\/410 OURO HOT STAMP\",\"quantity\":30,\"unit\":\"UN\",\"unit_price\":1.65,\"total_price\":49.5},{\"description\":\"VALVULA SABON. R.24\\/410 LUXO DOURADA\\/NATURAL\",\"quantity\":12,\"unit\":\"UN\",\"unit_price\":2.8,\"total_price\":33.6},{\"description\":\"ESS SCANDALO JEAN PAUL FEM - DOMO\",\"quantity\":0.1,\"unit\":\"LT\",\"unit_price\":400,\"total_price\":40},{\"description\":\"ESS ARABE DELINIA LA ROSÉ FEM. 50ML\",\"quantity\":1,\"unit\":\"UN\",\"unit_price\":45,\"total_price\":45}]}', '{\"items\": [{\"unit\": \"LT\", \"quantity\": 3, \"unit_price\": 20, \"description\": \"BASE PARA BODY SPLASH\", \"total_price\": 60}, {\"unit\": \"PC\", \"quantity\": 1, \"unit_price\": 18, \"description\": \"BASE PARA BODY SPLASH S/MICA\", \"total_price\": 18}, {\"unit\": \"UN\", \"quantity\": 30, \"unit_price\": 2.65, \"description\": \"FRASCO PET 200ML R.24/410 CRISTAL AURA C/TP\", \"total_price\": 79.5}, {\"unit\": \"UN\", \"quantity\": 30, \"unit_price\": 1.65, \"description\": \"VALVULA SPRAY R 24/410 OURO HOT STAMP\", \"total_price\": 49.5}, {\"unit\": \"UN\", \"quantity\": 12, \"unit_price\": 2.8, \"description\": \"VALVULA SABON. R.24/410 LUXO DOURADA/NATURAL\", \"total_price\": 33.6}, {\"unit\": \"LT\", \"quantity\": 0.1, \"unit_price\": 400, \"description\": \"ESS SCANDALO JEAN PAUL FEM - DOMO\", \"total_price\": 40}, {\"unit\": \"UN\", \"quantity\": 1, \"unit_price\": 45, \"description\": \"ESS ARABE DELINIA LA ROSÉ FEM. 50ML\", \"total_price\": 45}], \"supplier\": \"W.ESSENCIAS - COMERCIO E ARTESANATO\", \"total_value\": 325.6, \"purchase_date\": \"2026-06-05\", \"document_number\": \"068501\"}', 2, 'W.ESSENCIAS - COMERCIO E ARTESANATO', '2026-06-05', '068501', 325.60, NULL, NULL, '2026-06-09 20:30:13', '2026-06-09 20:25:29', '2026-06-09 20:30:13', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cnpj` varchar(18) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `website` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `instagram` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`id`, `name`, `cnpj`, `contact_name`, `email`, `phone`, `website`, `address`, `instagram`, `notes`, `is_active`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'COMÉRCIO DE ÓLEOS E ESSENCIAS SILVERIA MARTINS LTDA', '53.037.016/0001-35', NULL, NULL, '( 11 ) 99512-5530', 'https://casadasessencias.com/', NULL, NULL, NULL, 1, '2026-05-21 02:12:45', '2026-05-21 02:12:45', NULL),
(2, 'W.ESSENCIAS - COMERCIO E ARTESANATO', '12548771000105', NULL, 'jetessencia@hotmail', '11964241137', NULL, NULL, NULL, NULL, 1, '2026-05-21 13:28:19', '2026-05-21 13:28:19', NULL),
(3, 'Paraiso das Essências', NULL, NULL, NULL, '(11) 98359-4166', 'https://www.paraisodasessencias.com.br/', 'Rua Tabatinguera,187-Centro-SP', NULL, NULL, 1, '2026-05-21 14:23:14', '2026-05-21 14:23:14', NULL),
(4, 'PARIS ESSENCIAS', '45122200000155', NULL, NULL, '1131079194', NULL, NULL, NULL, NULL, 1, '2026-05-23 04:40:54', '2026-05-23 04:40:54', NULL),
(5, 'FONTE DAS ESSÊNCIAS 2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-05-23 04:51:53', '2026-05-23 04:51:53', NULL),
(6, 'Matriz Embalagens e Essências', NULL, NULL, NULL, '1131167844', NULL, 'Rua Silveira Martin, 141', NULL, NULL, 1, '2026-06-03 18:13:53', '2026-06-03 18:13:53', NULL),
(7, 'ANINHA DAS ESSENCIAS', NULL, NULL, NULL, '11967962742', NULL, NULL, NULL, NULL, 1, '2026-06-03 18:18:40', '2026-06-03 18:18:40', NULL),
(8, 'RECEITA DE VOVÓ ERVAS MEDICINAIS', NULL, 'YOHANA', 'RECEITADEVOVO@RECEITADEVOVOEM.COM.BR', '11983957146', 'www.receitadevovoem.com.br', NULL, '@receitadevovoem', NULL, 1, '2026-06-03 22:38:30', '2026-06-03 22:39:27', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `google_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `whatsapp` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cpf` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `consent_accepted_at` timestamp NULL DEFAULT NULL,
  `privacy_policy_version` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `google_id`, `avatar_path`, `whatsapp`, `phone`, `cpf`, `email_verified_at`, `password`, `is_admin`, `is_active`, `consent_accepted_at`, `privacy_policy_version`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Vovó Artesã', 'contato@receitadevovo.com', NULL, NULL, '11983957146', NULL, NULL, NULL, '$2y$12$65bHNG.KxbuoCB.2ebo5ausgbKz8qJ9MgIN5QFcX9QGDXOBxGnLhW', 1, 1, NULL, NULL, NULL, '2026-05-14 15:28:19', '2026-05-20 16:40:02'),
(2, 'Wagner Gusmão', 'wagnerpro@gmail.com', NULL, 'uploads/6a2af2d23ae51.webp', 'det:Em0/ulPkHNj3n0bk6LCHwA==', NULL, '26432620856', NULL, '$2y$12$dpHL1FQGbVfTw8mNZGW2.uK6hdju9vZShvyUIZdeVhP2egsyiZXKi', 0, 1, NULL, NULL, NULL, '2026-05-15 17:33:48', '2026-06-11 20:39:48'),
(4, 'Gidalva Ferreira das Virgens', '11984918757@balcao.receitadevovo.local', NULL, NULL, '11984918757', NULL, NULL, NULL, '$2y$12$1bks5UaiJmgt1ZjAlWZvjuIupFKOGYLKRTOjo3GthbucIm2pnUsXW', 0, 1, NULL, NULL, NULL, '2026-05-21 03:48:43', '2026-05-21 03:48:43'),
(5, 'Marcia da Silva Rocha', '11995694616@balcao.receitadevovo.local', NULL, NULL, '11995694616', NULL, NULL, NULL, '$2y$12$z3S8QLPCjp1VxYXRGWXKouYMq198RTaizsJDtgYeV98NjdWwBlDi2', 0, 1, NULL, NULL, NULL, '2026-05-21 03:50:49', '2026-05-21 03:50:49'),
(6, 'Sandra Alves Freitas', '11995203235@balcao.receitadevovo.local', NULL, NULL, '11995203235', NULL, NULL, NULL, '$2y$12$IvWVTVZkJCqYcr.5d9Yt.eB1RvtmE2g1tJtSoxax.zbTAPTfv/xdK', 0, 1, NULL, NULL, NULL, '2026-05-21 04:05:51', '2026-05-21 04:05:51'),
(7, 'Luciana Ayres de Araujo Pereira', '11947451690@balcao.receitadevovo.local', NULL, NULL, '11947451690', NULL, NULL, NULL, '$2y$12$iryMor3ZtgXsXfG0R6OsNuU/WFSi0ZA.y2Bv.bmgyX0563Al9dM/G', 0, 1, NULL, NULL, NULL, '2026-05-21 04:07:43', '2026-05-21 04:07:43'),
(8, 'Monaliza Magdalene da Silva Oliveira', '11963533592@balcao.receitadevovo.local', NULL, NULL, '11963533592', NULL, NULL, NULL, '$2y$12$PqIEeY6Aa1i0NZWSo0AOpuC0IVEIE/E3dLSD40ZmKq7fJKzrHcpam', 0, 1, NULL, NULL, NULL, '2026-05-21 04:09:58', '2026-05-21 04:20:05'),
(9, 'Elaine Garrido', '11964658018@balcao.receitadevovo.local', NULL, NULL, '11964658018', NULL, NULL, NULL, '$2y$12$bk5xjYJcKNgu9J3rqJmk9uIgLPo8hvZs2S17gzUNjpt.bECf9uW6G', 0, 1, NULL, NULL, NULL, '2026-05-21 13:13:13', '2026-05-21 13:13:13'),
(10, 'Janete Carregosa', '11997192369@balcao.receitadevovo.local', NULL, NULL, '11997192369', NULL, NULL, NULL, '$2y$12$4asH2.r5GAOoV9MEfyED.eXUtTSX0/c.zlNJrCc/TwZ6vIv2eJiDW', 0, 1, NULL, NULL, NULL, '2026-05-22 01:43:37', '2026-05-22 01:43:37'),
(11, 'Isabel Cristina', '11998726679@balcao.receitadevovo.local', NULL, NULL, '11998726679', NULL, NULL, NULL, '$2y$12$IVYzAk5jOjVcElpvScHJquUbj2QnpavToS2Ho.VCnG0wVv8YhMwuq', 0, 1, NULL, NULL, NULL, '2026-05-26 19:48:56', '2026-05-26 19:48:56'),
(12, 'Daiane', '11984895213@balcao.receitadevovo.local', NULL, NULL, '11984895213', NULL, NULL, NULL, '$2y$12$cz797q35XWSk5psSn/z3ou9glIc.VVknplaSo2I6DqS8Eq5uPb7Qu', 0, 1, NULL, NULL, NULL, '2026-05-26 19:50:39', '2026-05-26 19:50:39'),
(13, 'Ana', '11961654915@balcao.receitadevovo.local', NULL, NULL, '11961654915', NULL, NULL, NULL, '$2y$12$dqi4XwbGKqWUoWTDNppeWO5xb0ZLoOi7dRozkznqoumQpTX6DUS6i', 0, 1, NULL, NULL, NULL, '2026-05-26 19:52:47', '2026-05-26 19:52:47'),
(14, 'Lidia', '11979951899@balcao.receitadevovo.local', NULL, NULL, '11979951899', NULL, NULL, NULL, '$2y$12$IvETKBKi0UjZTTCpJkZ2cuzi/FAkbtvFv5RxAN8Jx5hPu1ibqCX7i', 0, 1, NULL, NULL, NULL, '2026-05-26 19:53:46', '2026-05-26 19:53:46'),
(15, 'Rubelita', '11984225297@balcao.receitadevovo.local', NULL, NULL, '11984225297', NULL, NULL, NULL, '$2y$12$crxaQuTXisVcDb6t.3sB2uLoCRw7ntrMXe0uNAKcR43fXNjS/cPd.', 0, 1, NULL, NULL, NULL, '2026-05-26 19:54:55', '2026-05-26 19:54:55'),
(16, 'Eduardo', '11994633188@balcao.receitadevovo.local', NULL, NULL, '11994633188', NULL, NULL, NULL, '$2y$12$zRlzcvv2SdSJvCxLE5Oi.efwKw6E51YfaVw2v9e5/1jA8Tu3B.w1K', 0, 1, NULL, NULL, NULL, '2026-05-26 19:56:03', '2026-05-26 19:56:03'),
(17, 'Roseli', '11967715820@balcao.receitadevovo.local', NULL, NULL, '11967715820', NULL, NULL, NULL, '$2y$12$Efd0iGB5iFLrrewnGbVUF.IioijkBgv2GHo2ciZ28r3aTx5U6aHza', 0, 1, NULL, NULL, NULL, '2026-05-26 19:57:06', '2026-05-26 19:57:06'),
(18, 'Fabiana Moreno', '15997077059@balcao.receitadevovo.local', NULL, NULL, '15997077059', NULL, NULL, NULL, '$2y$12$T1xp57uGFyuXnNC3w68ioO3se6VaCD7qpw8HeEkLCyrrJ3yhyruWm', 0, 1, NULL, NULL, NULL, '2026-05-26 19:58:34', '2026-05-26 19:58:34'),
(19, 'Juliana Cornatioli', '11984998363@balcao.receitadevovo.local', NULL, NULL, '11984998363', NULL, NULL, NULL, '$2y$12$D78iR.nvm1ZFsJTsTSYqY.KRUIuyJfeYTJTAB09ZPBgt.MLo2J5gC', 0, 1, NULL, NULL, NULL, '2026-05-26 20:03:11', '2026-05-26 20:03:11'),
(20, 'Jorge', '11981204485@balcao.receitadevovo.local', NULL, NULL, '11981204485', NULL, NULL, NULL, '$2y$12$kJYtuYcgibyRypwTZrU4gOruNDT/WunqsjXkC3J2d0Q4uJ14getnG', 0, 1, NULL, NULL, NULL, '2026-05-26 20:09:10', '2026-05-26 20:09:10'),
(21, 'Andreia Pereira', '11963811062@balcao.receitadevovo.local', NULL, NULL, '11963811062', NULL, NULL, NULL, '$2y$12$LusuF8Ehg.ed4CLRe6JcFO5gTLkKejnWRTM6yDsinncL2jdY/e3bO', 0, 1, NULL, NULL, NULL, '2026-05-26 20:10:45', '2026-05-26 20:10:45'),
(22, 'Emilene Giacometti', '11997127454@balcao.receitadevovo.local', NULL, NULL, '11997127454', NULL, NULL, NULL, '$2y$12$rycGzA7XaPVUQaSHjDvHeuf4iZy7TnYsAQM1VnRrvUCKuN0ET6GRi', 0, 1, NULL, NULL, NULL, '2026-05-27 04:07:55', '2026-05-27 04:07:55'),
(23, 'Antônia Matos', '11966561187@balcao.receitadevovo.local', NULL, NULL, '11966561187', NULL, NULL, NULL, '$2y$12$96w4UU8BoR7OcgTqcS9jBO1v3bgG0twEhuw.JwidtSW2el09VQ9tO', 0, 1, NULL, NULL, NULL, '2026-05-27 14:03:25', '2026-05-27 14:03:25'),
(24, 'Debora', '11997477935@balcao.receitadevovo.local', NULL, NULL, '11997477935', NULL, NULL, NULL, '$2y$12$hoKaq6ttc9JBHB0pT.2z8e/Tq4Orukw0H46dq2OriWGHG0JbNoEXi', 0, 1, NULL, NULL, NULL, '2026-05-27 16:35:28', '2026-05-27 16:35:28'),
(25, 'Andrea Jorge Felix', 'andreabaixista@yahoo.com.br', NULL, NULL, '11970390927', NULL, '16091452835', NULL, '$2y$12$1wAHZkGEpiMRvbwgfJYKU.dcBS8aft34Kj8MTqUxv39NUyWJF89pG', 0, 1, NULL, NULL, NULL, '2026-05-28 14:51:58', '2026-05-28 14:57:52'),
(26, 'Andreia Thomé', '11991445145@balcao.receitadevovo.local', NULL, NULL, '11991445145', NULL, NULL, NULL, '$2y$12$SPopr1rRirrJavLMOfuVN.Cyi94cBifpV4hPZF10MVlU.8kJXaioC', 0, 1, NULL, NULL, NULL, '2026-05-30 14:47:32', '2026-05-30 14:47:32'),
(27, 'Ivan Rocha', '11999698484@balcao.receitadevovo.local', NULL, NULL, '11999698484', NULL, NULL, NULL, '$2y$12$LDRe.dwCQ4raMYgRBA/lPup1vXsr5N0Es0eS6.g01lToW/5TW6ox2', 0, 1, NULL, NULL, NULL, '2026-06-03 15:29:24', '2026-06-03 15:29:24'),
(28, 'Narciso ITB', '11969149085@balcao.receitadevovo.local', NULL, NULL, '11969149085', NULL, NULL, NULL, '$2y$12$z9OhqJf5zlPqfY/HH7VW3uiZIsywI886qN5S2dExmQ0./GfzYgh2S', 0, 1, NULL, NULL, NULL, '2026-06-03 15:36:37', '2026-06-03 15:36:37'),
(29, 'Rose Duarte', '11982912522@balcao.receitadevovo.local', NULL, NULL, '11982912522', NULL, NULL, NULL, '$2y$12$rYAPCaCOZYaI8ThNDvcj3OTLbJIwAEC7wM.U.XOc5GM6QqwOQStTi', 0, 1, NULL, NULL, NULL, '2026-06-03 16:13:33', '2026-06-03 16:13:33'),
(30, 'Yohana Santos de Oliveira Gusmão', 'yohanasogusmao@gmail.com', NULL, NULL, 'det:VjGS8MF6BqvTjOhA2e+62w==', NULL, NULL, NULL, '$2y$12$gGD/J.8f5GDaa/V5QN7Qnu.hrDiLTlfhlhN7IOKrP5lROGG3tCjDy', 1, 1, NULL, NULL, NULL, '2026-06-03 16:41:55', '2026-06-11 02:30:27'),
(31, 'Fernanda', '11933779576@balcao.receitadevovo.local', NULL, NULL, '11933779576', NULL, NULL, NULL, '$2y$12$hNUSogdIBOPr7An1m6DtJ.ZRdxJvfYpdFJjlv58E6ELkiVCKlerqG', 0, 1, NULL, NULL, NULL, '2026-06-04 04:35:23', '2026-06-04 04:35:23'),
(32, 'Vó Gioma', '11969404663@balcao.receitadevovo.local', NULL, NULL, '11969404663', NULL, NULL, NULL, '$2y$12$knJ/OUVWyjVVE127v5r8wOynEXAASx63y.Lxz9TlhnA8RuQC0cRDy', 0, 1, NULL, NULL, NULL, '2026-06-04 04:36:28', '2026-06-04 04:36:28'),
(33, 'Claudia Ronquini', '11994040697@balcao.receitadevovo.local', NULL, NULL, '11994040697', NULL, NULL, NULL, '$2y$12$Pq9EKWVUVq7.IINSky2gZ.Ty5/LCTkQbZ8aECmvFNMRk4eM/S56uu', 0, 1, NULL, NULL, NULL, '2026-06-08 18:09:47', '2026-06-08 18:09:47'),
(34, 'Antônia Diretoria', '11999999999@balcao.receitadevovo.local', NULL, NULL, '11999999999', NULL, NULL, NULL, '$2y$12$d2cjH53vbtB6k4zFgL3G1uB8jzhoyVOOkrE/.T0NAaYR.IFeYoyiO', 0, 1, NULL, NULL, NULL, '2026-06-08 18:19:34', '2026-06-08 18:19:34'),
(35, 'Hagta Cavalcante Mendes', '11985619902@balcao.receitadevovo.local', NULL, NULL, '11985619902', NULL, NULL, NULL, '$2y$12$V8uCHQZoa/yycvooHvv4QOCcSfuzpfmW9Griux9wA8xfKMgpbETou', 0, 1, NULL, NULL, NULL, '2026-06-08 18:21:41', '2026-06-08 18:21:41'),
(36, 'Maria Cecilia', '11932192387@balcao.receitadevovo.local', NULL, NULL, '11932192387', NULL, NULL, NULL, '$2y$12$zUBqIaqVPDownAjuhgep4uiJBAMSWYk.Cxlpkqrt98m4Tx6E6okwi', 0, 1, NULL, NULL, NULL, '2026-06-10 04:11:36', '2026-06-10 04:11:36'),
(37, 'Claudio Barros', '11991160337@balcao.receitadevovo.local', NULL, NULL, '11991160337', NULL, NULL, NULL, '$2y$12$P6OgfQE/dn/YoiXiEDSSw.6hwoOAl2JLPBXmX/Mwv5nexSNBagR4.', 0, 1, NULL, NULL, NULL, '2026-06-10 14:21:54', '2026-06-10 14:21:54'),
(38, 'Elisangela Santos', '11969645996@balcao.receitadevovo.local', NULL, NULL, 'det:3NzrUNKgeU2MexWZma6Fvg==', NULL, NULL, NULL, '$2y$12$HSH61E1te7hXYZDeY91knO2SHqdFyvD4AB28008FXh3eDnzMEz/ia', 0, 1, NULL, NULL, NULL, '2026-06-11 21:22:45', '2026-06-11 21:22:45'),
(39, 'Marli', '11986369763@balcao.receitadevovo.local', NULL, NULL, 'det:iROdKYOBJ/Q9+57W7s/HyA==', NULL, NULL, NULL, '$2y$12$pDsasioWr7HaGeAMt6mPaeGmRGV7TokpJLjISN20cVGm6gyoXFV7i', 0, 1, NULL, NULL, NULL, '2026-06-11 21:25:35', '2026-06-11 21:25:35');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addresses`
--
ALTER TABLE `addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `addresses_user_id_is_default_index` (`user_id`,`is_default`),
  ADD KEY `addresses_cep_index` (`cep`);

--
-- Indexes for table `batches`
--
ALTER TABLE `batches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `batches_internal_code_unique` (`internal_code`),
  ADD KEY `batches_supplier_id_foreign` (`supplier_id`),
  ADD KEY `batches_raw_material_id_status_index` (`raw_material_id`,`status`),
  ADD KEY `batches_expires_at_index` (`expires_at`);

--
-- Indexes for table `benefits`
--
ALTER TABLE `benefits`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `benefits_name_unique` (`name`),
  ADD UNIQUE KEY `benefits_slug_unique` (`slug`);

--
-- Indexes for table `benefit_herb`
--
ALTER TABLE `benefit_herb`
  ADD PRIMARY KEY (`id`),
  ADD KEY `benefit_herb_benefit_id_foreign` (`benefit_id`),
  ADD KEY `benefit_herb_herb_id_foreign` (`herb_id`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `categories_slug_unique` (`slug`);

--
-- Indexes for table `comodato_audits`
--
ALTER TABLE `comodato_audits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `comodato_audits_partner_id_foreign` (`partner_id`);

--
-- Indexes for table `comodato_audit_items`
--
ALTER TABLE `comodato_audit_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `comodato_audit_items_comodato_audit_id_foreign` (`comodato_audit_id`);

--
-- Indexes for table `comodato_movements`
--
ALTER TABLE `comodato_movements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `comodato_movements_partner_id_foreign` (`partner_id`);

--
-- Indexes for table `comodato_partners`
--
ALTER TABLE `comodato_partners`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `comodato_stocks`
--
ALTER TABLE `comodato_stocks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `comodato_stocks_unique` (`partner_id`,`itemable_type`,`itemable_id`);

--
-- Indexes for table `emotions`
--
ALTER TABLE `emotions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `emotions_name_unique` (`name`),
  ADD UNIQUE KEY `emotions_slug_unique` (`slug`);

--
-- Indexes for table `emotion_herb`
--
ALTER TABLE `emotion_herb`
  ADD PRIMARY KEY (`id`),
  ADD KEY `emotion_herb_emotion_id_foreign` (`emotion_id`),
  ADD KEY `emotion_herb_herb_id_foreign` (`herb_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`),
  ADD KEY `failed_jobs_connection_queue_failed_at_index` (`connection`,`queue`,`failed_at`);

--
-- Indexes for table `herbs`
--
ALTER TABLE `herbs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `herbs_name_unique` (`name`),
  ADD UNIQUE KEY `herbs_slug_unique` (`slug`);

--
-- Indexes for table `herb_product`
--
ALTER TABLE `herb_product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `herb_product_herb_id_foreign` (`herb_id`),
  ADD KEY `herb_product_product_id_foreign` (`product_id`);

--
-- Indexes for table `inventory_movements`
--
ALTER TABLE `inventory_movements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inventory_movements_itemable_type_itemable_id_index` (`itemable_type`,`itemable_id`),
  ADD KEY `inventory_movements_order_id_foreign` (`order_id`),
  ADD KEY `inventory_movements_user_id_foreign` (`user_id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `kits`
--
ALTER TABLE `kits`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kits_slug_unique` (`slug`);

--
-- Indexes for table `kit_product`
--
ALTER TABLE `kit_product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `kit_product_kit_id_foreign` (`kit_id`),
  ADD KEY `kit_product_product_id_foreign` (`product_id`);

--
-- Indexes for table `loyalty_levels`
--
ALTER TABLE `loyalty_levels`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `loyalty_offers`
--
ALTER TABLE `loyalty_offers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `loyalty_offers_product_id_foreign` (`product_id`),
  ADD KEY `loyalty_offers_loyalty_level_id_foreign` (`loyalty_level_id`);

--
-- Indexes for table `loyalty_redemptions`
--
ALTER TABLE `loyalty_redemptions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `loyalty_redemptions_user_id_foreign` (`user_id`),
  ADD KEY `loyalty_redemptions_loyalty_reward_id_foreign` (`loyalty_reward_id`);

--
-- Indexes for table `loyalty_rewards`
--
ALTER TABLE `loyalty_rewards`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `loyalty_transactions`
--
ALTER TABLE `loyalty_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `loyalty_transactions_user_id_foreign` (`user_id`),
  ADD KEY `loyalty_transactions_order_id_foreign` (`order_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `newsletter_subscribers`
--
ALTER TABLE `newsletter_subscribers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `newsletter_subscribers_email_unique` (`email`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `orders_order_number_unique` (`order_number`),
  ADD KEY `orders_user_id_foreign` (`user_id`);

--
-- Indexes for table `order_installments`
--
ALTER TABLE `order_installments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_installments_order_id_foreign` (`order_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_items_order_id_foreign` (`order_id`),
  ADD KEY `order_items_itemable_type_itemable_id_index` (`itemable_type`,`itemable_id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `posts_slug_unique` (`slug`),
  ADD KEY `posts_user_id_foreign` (`user_id`),
  ADD KEY `posts_category_id_foreign` (`category_id`);

--
-- Indexes for table `post_categories`
--
ALTER TABLE `post_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `post_categories_name_unique` (`name`),
  ADD UNIQUE KEY `post_categories_slug_unique` (`slug`);

--
-- Indexes for table `production_orders`
--
ALTER TABLE `production_orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `production_orders_code_unique` (`code`),
  ADD KEY `production_orders_recipe_id_foreign` (`recipe_id`),
  ADD KEY `production_orders_user_id_foreign` (`user_id`),
  ADD KEY `production_orders_status_created_at_index` (`status`,`created_at`),
  ADD KEY `production_orders_product_id_index` (`product_id`);

--
-- Indexes for table `production_order_items`
--
ALTER TABLE `production_order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `production_order_items_batch_id_foreign` (`batch_id`),
  ADD KEY `production_order_items_raw_material_id_index` (`raw_material_id`),
  ADD KEY `production_order_items_production_order_id_raw_material_id_index` (`production_order_id`,`raw_material_id`);

--
-- Indexes for table `production_order_outputs`
--
ALTER TABLE `production_order_outputs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `production_order_outputs_production_order_id_foreign` (`production_order_id`),
  ADD KEY `production_order_outputs_itemable_type_itemable_id_index` (`itemable_type`,`itemable_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `products_slug_unique` (`slug`),
  ADD KEY `products_category_id_foreign` (`category_id`);

--
-- Indexes for table `product_reviews`
--
ALTER TABLE `product_reviews`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `product_reviews_user_id_product_id_unique` (`user_id`,`product_id`),
  ADD KEY `product_reviews_product_id_foreign` (`product_id`);

--
-- Indexes for table `product_variants`
--
ALTER TABLE `product_variants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_variants_product_id_foreign` (`product_id`);

--
-- Indexes for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `purchase_orders_code_unique` (`code`),
  ADD KEY `purchase_orders_user_id_foreign` (`user_id`),
  ADD KEY `purchase_orders_status_created_at_index` (`status`,`created_at`),
  ADD KEY `purchase_orders_supplier_id_index` (`supplier_id`);

--
-- Indexes for table `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `purchase_order_items_raw_material_id_foreign` (`raw_material_id`),
  ADD KEY `purchase_order_items_purchase_order_id_raw_material_id_index` (`purchase_order_id`,`raw_material_id`);

--
-- Indexes for table `quality_checks`
--
ALTER TABLE `quality_checks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `quality_checks_checkable_type_checkable_id_index` (`checkable_type`,`checkable_id`),
  ADD KEY `quality_checks_user_id_foreign` (`user_id`),
  ADD KEY `quality_checks_status_check_type_index` (`status`,`check_type`),
  ADD KEY `quality_checks_created_at_index` (`created_at`);

--
-- Indexes for table `quality_check_criteria`
--
ALTER TABLE `quality_check_criteria`
  ADD PRIMARY KEY (`id`),
  ADD KEY `quality_check_criteria_quality_check_id_criterion_index` (`quality_check_id`,`criterion`);

--
-- Indexes for table `raw_materials`
--
ALTER TABLE `raw_materials`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `raw_materials_slug_unique` (`slug`),
  ADD KEY `raw_materials_is_active_stock_quantity_index` (`is_active`,`stock_quantity`),
  ADD KEY `raw_materials_supplier_id_index` (`supplier_id`);

--
-- Indexes for table `raw_material_movements`
--
ALTER TABLE `raw_material_movements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `raw_material_movements_batch_id_foreign` (`batch_id`),
  ADD KEY `raw_material_movements_user_id_foreign` (`user_id`),
  ADD KEY `raw_material_movements_raw_material_id_type_index` (`raw_material_id`,`type`),
  ADD KEY `raw_material_movements_reference_type_reference_id_index` (`reference_type`,`reference_id`);

--
-- Indexes for table `recipes`
--
ALTER TABLE `recipes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `recipes_slug_unique` (`slug`),
  ADD KEY `recipes_product_id_is_active_index` (`product_id`,`is_active`);

--
-- Indexes for table `recipe_ingredients`
--
ALTER TABLE `recipe_ingredients`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `recipe_ingredients_recipe_id_raw_material_id_unique` (`recipe_id`,`raw_material_id`),
  ADD KEY `recipe_ingredients_raw_material_id_index` (`raw_material_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `smart_input_items`
--
ALTER TABLE `smart_input_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `smart_input_items_raw_material_id_foreign` (`raw_material_id`),
  ADD KEY `smart_input_items_session_id_is_confirmed_index` (`session_id`,`is_confirmed`);

--
-- Indexes for table `smart_input_sessions`
--
ALTER TABLE `smart_input_sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `smart_input_sessions_supplier_id_foreign` (`supplier_id`),
  ADD KEY `smart_input_sessions_user_id_status_index` (`user_id`,`status`),
  ADD KEY `smart_input_sessions_created_at_index` (`created_at`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `suppliers_cnpj_unique` (`cnpj`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD UNIQUE KEY `users_google_id_unique` (`google_id`),
  ADD KEY `users_whatsapp_index` (`whatsapp`),
  ADD KEY `users_cpf_index` (`cpf`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addresses`
--
ALTER TABLE `addresses`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `batches`
--
ALTER TABLE `batches`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=138;

--
-- AUTO_INCREMENT for table `benefits`
--
ALTER TABLE `benefits`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `benefit_herb`
--
ALTER TABLE `benefit_herb`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=719;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `comodato_audits`
--
ALTER TABLE `comodato_audits`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `comodato_audit_items`
--
ALTER TABLE `comodato_audit_items`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `comodato_movements`
--
ALTER TABLE `comodato_movements`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `comodato_partners`
--
ALTER TABLE `comodato_partners`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `comodato_stocks`
--
ALTER TABLE `comodato_stocks`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `emotions`
--
ALTER TABLE `emotions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `emotion_herb`
--
ALTER TABLE `emotion_herb`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=381;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `herbs`
--
ALTER TABLE `herbs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=251;

--
-- AUTO_INCREMENT for table `herb_product`
--
ALTER TABLE `herb_product`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT for table `inventory_movements`
--
ALTER TABLE `inventory_movements`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=116;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `kits`
--
ALTER TABLE `kits`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `kit_product`
--
ALTER TABLE `kit_product`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `loyalty_levels`
--
ALTER TABLE `loyalty_levels`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `loyalty_offers`
--
ALTER TABLE `loyalty_offers`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `loyalty_redemptions`
--
ALTER TABLE `loyalty_redemptions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `loyalty_rewards`
--
ALTER TABLE `loyalty_rewards`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `loyalty_transactions`
--
ALTER TABLE `loyalty_transactions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `newsletter_subscribers`
--
ALTER TABLE `newsletter_subscribers`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `order_installments`
--
ALTER TABLE `order_installments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=97;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=89;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `post_categories`
--
ALTER TABLE `post_categories`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `production_orders`
--
ALTER TABLE `production_orders`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `production_order_items`
--
ALTER TABLE `production_order_items`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `production_order_outputs`
--
ALTER TABLE `production_order_outputs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `product_reviews`
--
ALTER TABLE `product_reviews`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_variants`
--
ALTER TABLE `product_variants`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `quality_checks`
--
ALTER TABLE `quality_checks`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `quality_check_criteria`
--
ALTER TABLE `quality_check_criteria`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `raw_materials`
--
ALTER TABLE `raw_materials`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=152;

--
-- AUTO_INCREMENT for table `raw_material_movements`
--
ALTER TABLE `raw_material_movements`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=242;

--
-- AUTO_INCREMENT for table `recipes`
--
ALTER TABLE `recipes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `recipe_ingredients`
--
ALTER TABLE `recipe_ingredients`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=372;

--
-- AUTO_INCREMENT for table `smart_input_items`
--
ALTER TABLE `smart_input_items`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=138;

--
-- AUTO_INCREMENT for table `smart_input_sessions`
--
ALTER TABLE `smart_input_sessions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `addresses`
--
ALTER TABLE `addresses`
  ADD CONSTRAINT `addresses_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `batches`
--
ALTER TABLE `batches`
  ADD CONSTRAINT `batches_raw_material_id_foreign` FOREIGN KEY (`raw_material_id`) REFERENCES `raw_materials` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `batches_supplier_id_foreign` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `benefit_herb`
--
ALTER TABLE `benefit_herb`
  ADD CONSTRAINT `benefit_herb_benefit_id_foreign` FOREIGN KEY (`benefit_id`) REFERENCES `benefits` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `benefit_herb_herb_id_foreign` FOREIGN KEY (`herb_id`) REFERENCES `herbs` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `comodato_audits`
--
ALTER TABLE `comodato_audits`
  ADD CONSTRAINT `comodato_audits_partner_id_foreign` FOREIGN KEY (`partner_id`) REFERENCES `comodato_partners` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `comodato_audit_items`
--
ALTER TABLE `comodato_audit_items`
  ADD CONSTRAINT `comodato_audit_items_comodato_audit_id_foreign` FOREIGN KEY (`comodato_audit_id`) REFERENCES `comodato_audits` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `comodato_movements`
--
ALTER TABLE `comodato_movements`
  ADD CONSTRAINT `comodato_movements_partner_id_foreign` FOREIGN KEY (`partner_id`) REFERENCES `comodato_partners` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `comodato_stocks`
--
ALTER TABLE `comodato_stocks`
  ADD CONSTRAINT `comodato_stocks_partner_id_foreign` FOREIGN KEY (`partner_id`) REFERENCES `comodato_partners` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `emotion_herb`
--
ALTER TABLE `emotion_herb`
  ADD CONSTRAINT `emotion_herb_emotion_id_foreign` FOREIGN KEY (`emotion_id`) REFERENCES `emotions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `emotion_herb_herb_id_foreign` FOREIGN KEY (`herb_id`) REFERENCES `herbs` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `herb_product`
--
ALTER TABLE `herb_product`
  ADD CONSTRAINT `herb_product_herb_id_foreign` FOREIGN KEY (`herb_id`) REFERENCES `herbs` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `herb_product_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `inventory_movements`
--
ALTER TABLE `inventory_movements`
  ADD CONSTRAINT `inventory_movements_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `inventory_movements_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `kit_product`
--
ALTER TABLE `kit_product`
  ADD CONSTRAINT `kit_product_kit_id_foreign` FOREIGN KEY (`kit_id`) REFERENCES `kits` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `kit_product_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `loyalty_offers`
--
ALTER TABLE `loyalty_offers`
  ADD CONSTRAINT `loyalty_offers_loyalty_level_id_foreign` FOREIGN KEY (`loyalty_level_id`) REFERENCES `loyalty_levels` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `loyalty_offers_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `loyalty_redemptions`
--
ALTER TABLE `loyalty_redemptions`
  ADD CONSTRAINT `loyalty_redemptions_loyalty_reward_id_foreign` FOREIGN KEY (`loyalty_reward_id`) REFERENCES `loyalty_rewards` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `loyalty_redemptions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `loyalty_transactions`
--
ALTER TABLE `loyalty_transactions`
  ADD CONSTRAINT `loyalty_transactions_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `loyalty_transactions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_installments`
--
ALTER TABLE `order_installments`
  ADD CONSTRAINT `order_installments_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `post_categories` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `posts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `production_orders`
--
ALTER TABLE `production_orders`
  ADD CONSTRAINT `production_orders_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `production_orders_recipe_id_foreign` FOREIGN KEY (`recipe_id`) REFERENCES `recipes` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `production_orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `production_order_items`
--
ALTER TABLE `production_order_items`
  ADD CONSTRAINT `production_order_items_batch_id_foreign` FOREIGN KEY (`batch_id`) REFERENCES `batches` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `production_order_items_production_order_id_foreign` FOREIGN KEY (`production_order_id`) REFERENCES `production_orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `production_order_items_raw_material_id_foreign` FOREIGN KEY (`raw_material_id`) REFERENCES `raw_materials` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `production_order_outputs`
--
ALTER TABLE `production_order_outputs`
  ADD CONSTRAINT `production_order_outputs_production_order_id_foreign` FOREIGN KEY (`production_order_id`) REFERENCES `production_orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `product_reviews`
--
ALTER TABLE `product_reviews`
  ADD CONSTRAINT `product_reviews_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_reviews_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_variants`
--
ALTER TABLE `product_variants`
  ADD CONSTRAINT `product_variants_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  ADD CONSTRAINT `purchase_orders_supplier_id_foreign` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `purchase_orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  ADD CONSTRAINT `purchase_order_items_purchase_order_id_foreign` FOREIGN KEY (`purchase_order_id`) REFERENCES `purchase_orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `purchase_order_items_raw_material_id_foreign` FOREIGN KEY (`raw_material_id`) REFERENCES `raw_materials` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `quality_checks`
--
ALTER TABLE `quality_checks`
  ADD CONSTRAINT `quality_checks_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `quality_check_criteria`
--
ALTER TABLE `quality_check_criteria`
  ADD CONSTRAINT `quality_check_criteria_quality_check_id_foreign` FOREIGN KEY (`quality_check_id`) REFERENCES `quality_checks` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `raw_materials`
--
ALTER TABLE `raw_materials`
  ADD CONSTRAINT `raw_materials_supplier_id_foreign` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `raw_material_movements`
--
ALTER TABLE `raw_material_movements`
  ADD CONSTRAINT `raw_material_movements_batch_id_foreign` FOREIGN KEY (`batch_id`) REFERENCES `batches` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `raw_material_movements_raw_material_id_foreign` FOREIGN KEY (`raw_material_id`) REFERENCES `raw_materials` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `raw_material_movements_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `recipes`
--
ALTER TABLE `recipes`
  ADD CONSTRAINT `recipes_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `recipe_ingredients`
--
ALTER TABLE `recipe_ingredients`
  ADD CONSTRAINT `recipe_ingredients_raw_material_id_foreign` FOREIGN KEY (`raw_material_id`) REFERENCES `raw_materials` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `recipe_ingredients_recipe_id_foreign` FOREIGN KEY (`recipe_id`) REFERENCES `recipes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `smart_input_items`
--
ALTER TABLE `smart_input_items`
  ADD CONSTRAINT `smart_input_items_raw_material_id_foreign` FOREIGN KEY (`raw_material_id`) REFERENCES `raw_materials` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `smart_input_items_session_id_foreign` FOREIGN KEY (`session_id`) REFERENCES `smart_input_sessions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `smart_input_sessions`
--
ALTER TABLE `smart_input_sessions`
  ADD CONSTRAINT `smart_input_sessions_supplier_id_foreign` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `smart_input_sessions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
