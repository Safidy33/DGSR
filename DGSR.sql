-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: dgsr
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `absence`
--

DROP TABLE IF EXISTS `absence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `absence` (
  `id` int NOT NULL AUTO_INCREMENT,
  `personnel_id` int DEFAULT NULL,
  `date_debut` date DEFAULT NULL,
  `date_fin` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `personnel_id` (`personnel_id`),
  CONSTRAINT `absence_ibfk_1` FOREIGN KEY (`personnel_id`) REFERENCES `personnel` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `absence`
--

LOCK TABLES `absence` WRITE;
/*!40000 ALTER TABLE `absence` DISABLE KEYS */;
/*!40000 ALTER TABLE `absence` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departement`
--

DROP TABLE IF EXISTS `departement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departement` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) DEFAULT NULL,
  `description` text,
  `responsable` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nom` (`nom`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departement`
--

LOCK TABLES `departement` WRITE;
/*!40000 ALTER TABLE `departement` DISABLE KEYS */;
/*!40000 ALTER TABLE `departement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `heuredetravail`
--

DROP TABLE IF EXISTS `heuredetravail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `heuredetravail` (
  `id` int NOT NULL AUTO_INCREMENT,
  `personnel_id` int DEFAULT NULL,
  `date_travail` date DEFAULT NULL,
  `heures_jour` double DEFAULT NULL,
  `heures_semaine` double DEFAULT NULL,
  `heures_mois` double DEFAULT NULL,
  `heures_supplementaires` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `personnel_id` (`personnel_id`),
  CONSTRAINT `heuredetravail_ibfk_1` FOREIGN KEY (`personnel_id`) REFERENCES `personnel` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `heuredetravail`
--

LOCK TABLES `heuredetravail` WRITE;
/*!40000 ALTER TABLE `heuredetravail` DISABLE KEYS */;
/*!40000 ALTER TABLE `heuredetravail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personnel`
--

DROP TABLE IF EXISTS `personnel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personnel` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) DEFAULT NULL,
  `prenom` varchar(100) DEFAULT NULL,
  `numero_employe` varchar(50) DEFAULT NULL,
  `departement` varchar(100) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `qr_code` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `numero_employe` (`numero_employe`),
  UNIQUE KEY `Email` (`Email`),
  UNIQUE KEY `qr_code` (`qr_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personnel`
--

LOCK TABLES `personnel` WRITE;
/*!40000 ALTER TABLE `personnel` DISABLE KEYS */;
/*!40000 ALTER TABLE `personnel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pointage`
--

DROP TABLE IF EXISTS `pointage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pointage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date_pointage` datetime DEFAULT NULL,
  `type` enum('entree','sortie') DEFAULT NULL,
  `personnel_id` int DEFAULT NULL,
  `scanner_id` int DEFAULT NULL,
  `statut` enum('en train de travailler','Sortie') DEFAULT 'en train de travailler',
  `commentaire` text,
  `localisation` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `personnel_id` (`personnel_id`),
  KEY `scanner_id` (`scanner_id`),
  CONSTRAINT `pointage_ibfk_1` FOREIGN KEY (`personnel_id`) REFERENCES `personnel` (`id`) ON DELETE CASCADE,
  CONSTRAINT `pointage_ibfk_2` FOREIGN KEY (`scanner_id`) REFERENCES `utilisateur` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pointage`
--

LOCK TABLES `pointage` WRITE;
/*!40000 ALTER TABLE `pointage` DISABLE KEYS */;
/*!40000 ALTER TABLE `pointage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rapport`
--

DROP TABLE IF EXISTS `rapport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rapport` (
  `id` int NOT NULL AUTO_INCREMENT,
  `contenu` text,
  `date_generation` datetime DEFAULT CURRENT_TIMESTAMP,
  `type_rapport` varchar(100) DEFAULT NULL,
  `periode_debut` date DEFAULT NULL,
  `periode_fin` date DEFAULT NULL,
  `format_export` varchar(20) DEFAULT NULL,
  `admin_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `admin_id` (`admin_id`),
  CONSTRAINT `rapport_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `utilisateur` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rapport`
--

LOCK TABLES `rapport` WRITE;
/*!40000 ALTER TABLE `rapport` DISABLE KEYS */;
/*!40000 ALTER TABLE `rapport` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rapport_absence`
--

DROP TABLE IF EXISTS `rapport_absence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rapport_absence` (
  `rapport_id` int NOT NULL,
  `absence_id` int NOT NULL,
  PRIMARY KEY (`rapport_id`,`absence_id`),
  KEY `absence_id` (`absence_id`),
  CONSTRAINT `rapport_absence_ibfk_1` FOREIGN KEY (`rapport_id`) REFERENCES `rapport` (`id`) ON DELETE CASCADE,
  CONSTRAINT `rapport_absence_ibfk_2` FOREIGN KEY (`absence_id`) REFERENCES `absence` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rapport_absence`
--

LOCK TABLES `rapport_absence` WRITE;
/*!40000 ALTER TABLE `rapport_absence` DISABLE KEYS */;
/*!40000 ALTER TABLE `rapport_absence` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rapport_heure`
--

DROP TABLE IF EXISTS `rapport_heure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rapport_heure` (
  `rapport_id` int NOT NULL,
  `heure_id` int NOT NULL,
  PRIMARY KEY (`rapport_id`,`heure_id`),
  KEY `heure_id` (`heure_id`),
  CONSTRAINT `rapport_heure_ibfk_1` FOREIGN KEY (`rapport_id`) REFERENCES `rapport` (`id`) ON DELETE CASCADE,
  CONSTRAINT `rapport_heure_ibfk_2` FOREIGN KEY (`heure_id`) REFERENCES `heuredetravail` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rapport_heure`
--

LOCK TABLES `rapport_heure` WRITE;
/*!40000 ALTER TABLE `rapport_heure` DISABLE KEYS */;
/*!40000 ALTER TABLE `rapport_heure` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rapport_pointage`
--

DROP TABLE IF EXISTS `rapport_pointage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rapport_pointage` (
  `rapport_id` int NOT NULL,
  `pointage_id` int NOT NULL,
  PRIMARY KEY (`rapport_id`,`pointage_id`),
  KEY `pointage_id` (`pointage_id`),
  CONSTRAINT `rapport_pointage_ibfk_1` FOREIGN KEY (`rapport_id`) REFERENCES `rapport` (`id`) ON DELETE CASCADE,
  CONSTRAINT `rapport_pointage_ibfk_2` FOREIGN KEY (`pointage_id`) REFERENCES `pointage` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rapport_pointage`
--

LOCK TABLES `rapport_pointage` WRITE;
/*!40000 ALTER TABLE `rapport_pointage` DISABLE KEYS */;
/*!40000 ALTER TABLE `rapport_pointage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utilisateur`
--

DROP TABLE IF EXISTS `utilisateur`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utilisateur` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) DEFAULT NULL,
  `prenom` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `mot_de_passe` varchar(255) DEFAULT NULL,
  `role` enum('admin','scanner') NOT NULL,
  `date_creation` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utilisateur`
--

LOCK TABLES `utilisateur` WRITE;
/*!40000 ALTER TABLE `utilisateur` DISABLE KEYS */;
/*!40000 ALTER TABLE `utilisateur` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-05 14:18:14
