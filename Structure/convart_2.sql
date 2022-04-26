-- phpMyAdmin SQL Dump
-- version 4.6.6deb5
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Apr 26, 2022 at 12:39 PM
-- Server version: 10.1.44-MariaDB-0ubuntu0.18.04.1
-- PHP Version: 7.2.24-0ubuntu0.18.04.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `convart_2`
--

-- --------------------------------------------------------

--
-- Table structure for table `convart_gene`
--

CREATE TABLE `convart_gene` (
  `id` int(32) NOT NULL,
  `sequence` text NOT NULL,
  `species_id` varchar(55) NOT NULL,
  `hash` varchar(150) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `convart_gene_to_db`
--

CREATE TABLE `convart_gene_to_db` (
  `convart_gene_id` int(11) NOT NULL,
  `db` varchar(25) NOT NULL,
  `db_id` varchar(50) NOT NULL,
  `db_id_version` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `ensembl_meta_data`
--

CREATE TABLE `ensembl_meta_data` (
  `id` int(11) NOT NULL,
  `name` varchar(50) CHARACTER SET utf8 NOT NULL,
  `transcript` varchar(50) CHARACTER SET utf8 NOT NULL,
  `gene` varchar(50) CHARACTER SET utf8 NOT NULL,
  `chromosome` varchar(50) CHARACTER SET utf8 NOT NULL,
  `gene symbol` varchar(25) CHARACTER SET utf8 NOT NULL,
  `specie` varchar(50) CHARACTER SET utf8 NOT NULL,
  `annotation` text CHARACTER SET utf8 NOT NULL,
  `sequence` text CHARACTER SET utf8 NOT NULL,
  `creation_date` varchar(35) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `ncbi_meta_data`
--

CREATE TABLE `ncbi_meta_data` (
  `id` int(11) NOT NULL,
  `name` varchar(50) CHARACTER SET utf8 NOT NULL,
  `specie` varchar(50) CHARACTER SET utf8 NOT NULL,
  `annotation` text CHARACTER SET utf8 NOT NULL,
  `sequence` text CHARACTER SET utf8 NOT NULL,
  `creation_date` varchar(35) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `convart_gene`
--
ALTER TABLE `convart_gene`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `hash` (`hash`),
  ADD KEY `species` (`species_id`);

--
-- Indexes for table `convart_gene_to_db`
--
ALTER TABLE `convart_gene_to_db`
  ADD PRIMARY KEY (`convart_gene_id`,`db`,`db_id`),
  ADD KEY `db` (`db`),
  ADD KEY `db_id` (`db_id`),
  ADD KEY `convart_gene_id` (`convart_gene_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `convart_gene`
--
ALTER TABLE `convart_gene`
  MODIFY `id` int(32) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=432702;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
