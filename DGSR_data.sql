-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: dgsr
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
-- Dumping data for table `absence`
--

LOCK TABLES `absence` WRITE;
/*!40000 ALTER TABLE `absence` DISABLE KEYS */;
INSERT INTO `absence` VALUES (1,1,'2024-08-15','2024-08-16'),(2,2,'2024-08-20','2024-08-22'),(3,3,'2024-08-25','2024-08-25'),(4,4,'2024-09-01','2024-09-03');
/*!40000 ALTER TABLE `absence` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `departement`
--

LOCK TABLES `departement` WRITE;
/*!40000 ALTER TABLE `departement` DISABLE KEYS */;
INSERT INTO `departement` VALUES (1,'Ressources Humaines','Gestion du personnel et des ressources humaines','Marie Dupont'),(2,'Informatique','Développement et maintenance des systèmes informatiques','Jean Martin'),(3,'Comptabilité','Gestion financière et comptable','Pierre Durand'),(4,'Marketing','Promotion et communication de l\'entreprise','Sophie Bernard'),(5,'Production','Fabrication et contrôle qualité des produits','Luc Moreau');
/*!40000 ALTER TABLE `departement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `heuredetravail`
--

LOCK TABLES `heuredetravail` WRITE;
/*!40000 ALTER TABLE `heuredetravail` DISABLE KEYS */;
/*!40000 ALTER TABLE `heuredetravail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `personnel`
--

LOCK TABLES `personnel` WRITE;
/*!40000 ALTER TABLE `personnel` DISABLE KEYS */;
INSERT INTO `personnel` VALUES (1,'Dupont','Marie','	0321456988','Ressources Humaines','marie.dupont@dgsr.com','QR001'),(2,'Martin','Jean','0326655497','Informatique','jean.martin@dgsr.com','QR002'),(3,'Durand','Pierre','0331469782','Comptabilité','pierre.durand@dgsr.com','QR003'),(4,'Bernard','Sophie','0321456987','Marketing','sophie.bernard@dgsr.com','QR006'),(5,'Moreau','Luc','0348796521','Informatique','luc.moreau@dgsr.com','QR005');
/*!40000 ALTER TABLE `personnel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `pointage`
--

LOCK TABLES `pointage` WRITE;
/*!40000 ALTER TABLE `pointage` DISABLE KEYS */;
INSERT INTO `pointage` VALUES (33,'2025-09-14 18:36:10','entree',1,2,'en train de travailler','Pointage enregistré via scan QR'),(34,'2025-09-15 05:38:40','entree',1,2,'en train de travailler','Pointage enregistré via scan QR'),(35,'2025-09-15 05:38:47','sortie',1,2,'Sortie','Pointage enregistré via scan QR'),(36,'2025-09-15 08:26:34','entree',1,2,'en train de travailler','Pointage enregistré via scan QR'),(37,'2025-09-16 05:17:01','entree',1,2,'en train de travailler','Pointage enregistré via scan QR'),(38,'2025-09-16 08:31:11','sortie',1,2,'Sortie','Pointage enregistré via scan QR'),(39,'2025-09-17 09:59:12','entree',1,2,'En train de travailler','Pointage enregistré via scan QR'),(40,'2025-09-17 10:34:16','sortie',1,2,'sortie','Pointage enregistré via scan QR'),(41,'2025-09-17 13:23:24','entree',1,2,'en train de travailler','Pointage enregistré via scan QR'),(42,'2025-09-17 13:51:24','sortie',1,2,'Sortie','Pointage enregistré via scan QR'),(43,'2025-09-18 09:46:22','entree',1,2,'en train de travailler','Pointage enregistré via scan QR'),(44,'2025-09-18 09:46:22','entree',1,2,'en train de travailler','Pointage enregistré via scan QR'),(45,'2025-09-18 09:46:22','entree',1,2,'en train de travailler','Pointage enregistré via scan QR'),(46,'2025-09-18 09:46:22','sortie',1,2,'Sortie','Pointage enregistré via scan QR'),(47,'2025-09-18 09:46:23','sortie',1,2,'Sortie','Pointage enregistré via scan QR'),(48,'2025-09-18 09:46:23','entree',1,2,'en train de travailler','Pointage enregistré via scan QR'),(49,'2025-09-18 09:46:23','entree',1,2,'en train de travailler','Pointage enregistré via scan QR'),(50,'2025-09-18 09:46:24','entree',1,2,'en train de travailler','Pointage enregistré via scan QR'),(51,'2025-09-18 09:46:24','sortie',1,2,'Sortie','Pointage enregistré via scan QR'),(52,'2025-09-18 09:46:24','sortie',1,2,'Sortie','Pointage enregistré via scan QR'),(53,'2025-09-18 09:47:47','sortie',1,2,'Sortie','Pointage enregistré via scan QR'),(54,'2025-09-18 09:48:04','entree',1,2,'en train de travailler','Pointage enregistré via scan QR'),(55,'2025-09-18 09:48:04','sortie',1,2,'Sortie','Pointage enregistré via scan QR'),(56,'2025-09-18 10:02:11','sortie',1,2,'Sortie','Pointage enregistré via scan QR'),(57,'2025-09-18 10:02:21','entree',1,2,'en train de travailler','Pointage enregistré via scan QR'),(58,'2025-09-18 10:02:22','sortie',1,2,'Sortie','Pointage enregistré via scan QR'),(59,'2025-09-18 10:02:46','entree',1,2,'en train de travailler','Pointage enregistré via scan QR'),(60,'2025-09-18 10:02:46','sortie',1,2,'Sortie','Pointage enregistré via scan QR'),(61,'2025-09-19 09:47:24','entree',1,2,'en train de travailler','Pointage enregistré via scan QR'),(62,'2025-09-19 09:47:24','entree',1,2,'en train de travailler','Pointage enregistré via scan QR'),(63,'2025-09-19 09:47:24','entree',1,2,'en train de travailler','Pointage enregistré via scan QR'),(64,'2025-09-19 09:47:24','sortie',1,2,'Sortie','Pointage enregistré via scan QR'),(65,'2025-09-19 09:47:24','sortie',1,2,'Sortie','Pointage enregistré via scan QR'),(66,'2025-09-19 09:47:24','sortie',1,2,'Sortie','Pointage enregistré via scan QR'),(67,'2025-09-19 09:47:24','sortie',1,2,'Sortie','Pointage enregistré via scan QR'),(68,'2025-09-19 09:47:24','sortie',1,2,'Sortie','Pointage enregistré via scan QR'),(69,'2025-09-19 09:47:25','sortie',1,2,'Sortie','Pointage enregistré via scan QR'),(70,'2025-09-19 09:47:25','entree',1,2,'en train de travailler','Pointage enregistré via scan QR'),(71,'2025-09-19 09:47:25','entree',1,2,'en train de travailler','Pointage enregistré via scan QR'),(72,'2025-09-19 09:47:25','entree',1,2,'en train de travailler','Pointage enregistré via scan QR'),(73,'2025-09-19 09:47:25','entree',1,2,'en train de travailler','Pointage enregistré via scan QR'),(74,'2025-09-19 12:23:03','entree',1,2,'en train de travailler','Pointage enregistré via scan QR'),(75,'2025-09-19 12:42:56','sortie',1,2,'Sortie','Pointage enregistré via scan QR'),(76,'2025-09-19 12:43:04','entree',1,2,'en train de travailler','Pointage enregistré via scan QR'),(77,'2025-09-19 14:05:21','entree',4,2,'en train de travailler','Pointage enregistré via scan QR'),(78,'2025-09-19 14:13:36','sortie',4,2,'Sortie','Pointage enregistré via scan QR'),(79,'2025-09-19 14:17:40','entree',4,2,'en train de travailler','Pointage enregistré via scan QR'),(80,'2025-09-19 14:52:29','sortie',4,2,'Sortie','Pointage enregistré via scan QR'),(81,'2025-09-19 16:58:17','entree',4,2,'en train de travailler','Pointage enregistré via scan QR'),(82,'2025-09-19 17:01:08','sortie',4,2,'Sortie','Pointage enregistré via scan QR'),(83,'2025-09-21 13:52:20','entree',1,2,'en train de travailler','Pointage enregistré via scan QR'),(84,'2025-09-21 13:53:01','sortie',1,2,'Sortie','Pointage enregistré via scan QR'),(85,'2025-09-21 13:53:57','entree',1,2,'en train de travailler','Pointage enregistré via scan QR');
/*!40000 ALTER TABLE `pointage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `rapport`
--

LOCK TABLES `rapport` WRITE;
/*!40000 ALTER TABLE `rapport` DISABLE KEYS */;
/*!40000 ALTER TABLE `rapport` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `rapport_absence`
--

LOCK TABLES `rapport_absence` WRITE;
/*!40000 ALTER TABLE `rapport_absence` DISABLE KEYS */;
/*!40000 ALTER TABLE `rapport_absence` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `rapport_heure`
--

LOCK TABLES `rapport_heure` WRITE;
/*!40000 ALTER TABLE `rapport_heure` DISABLE KEYS */;
/*!40000 ALTER TABLE `rapport_heure` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `rapport_pointage`
--

LOCK TABLES `rapport_pointage` WRITE;
/*!40000 ALTER TABLE `rapport_pointage` DISABLE KEYS */;
/*!40000 ALTER TABLE `rapport_pointage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `utilisateur`
--

LOCK TABLES `utilisateur` WRITE;
/*!40000 ALTER TABLE `utilisateur` DISABLE KEYS */;
INSERT INTO `utilisateur` VALUES (1,'Rakotonirina','Safidy','Safidyadmin@gmail.com','admin','admin','2025-09-05 09:19:26','Alarobia'),(2,'Scanner','Principal','scanner@dgsr.com','scanner','scanner','2025-09-05 09:19:26','Alarobia'),(3,'Andriampionona','Orlando','Orlandoadmin@dgsr.com','admin','admin','2025-09-05 09:19:26','ByPass'),(4,'Scanner','Secondaire','scanner2@dgsr.com','scanner','scanner','2025-09-05 09:19:26','ByPass');
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

-- Dump completed on 2025-09-29 13:09:52
