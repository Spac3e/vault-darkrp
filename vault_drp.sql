-- --------------------------------------------------------
-- Хост:                         167.235.139.33
-- Версия сервера:               10.3.38-MariaDB-0ubuntu0.20.04.1 - Ubuntu 20.04
-- Операционная система:         debian-linux-gnu
-- HeidiSQL Версия:              12.5.0.6677
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Дамп данных таблицы s237_gmod_dev.ba_admins: 0 rows
/*!40000 ALTER TABLE `ba_admins` DISABLE KEYS */;
/*!40000 ALTER TABLE `ba_admins` ENABLE KEYS */;

-- Дамп данных таблицы s237_gmod_dev.ba_bans: 0 rows
/*!40000 ALTER TABLE `ba_bans` DISABLE KEYS */;
/*!40000 ALTER TABLE `ba_bans` ENABLE KEYS */;

-- Дамп данных таблицы s237_gmod_dev.ba_cheaters: 0 rows
/*!40000 ALTER TABLE `ba_cheaters` DISABLE KEYS */;
/*!40000 ALTER TABLE `ba_cheaters` ENABLE KEYS */;

-- Дамп данных таблицы s237_gmod_dev.ba_hashlog: 12 rows
/*!40000 ALTER TABLE `ba_hashlog` DISABLE KEYS */;
INSERT INTO `ba_hashlog` (`steamid`, `lastseen`, `hashid`) VALUES
	(76561198432845546, 1690882109, '753c59d6cb7977efb2f650715665bcc1cf2a069b19fae8604faf49db1a4a3771'),
	(76561198979903152, 1690883692, 'cacfbd88af9c65c1f164233ebd6d2f51e0bed89727b5564a71010e7de4cc8427'),
	(76561198396396064, 1690885197, '0c8870ae7864383987cce19cfbaa9fe2ec5249f54e291e777fecef685a6860cf'),
	(76561198797549224, 1690963429, 'f6ce2e791a8004a9f4c5d740d65a986c556393ff02cb1a3aa8bbc35fbb5b4e39'),
	(76561198959253828, 1690892496, '0fd18a99460909a529451d8247f54befd0d0e2b8d80c3060e781328a9a7f40bb'),
	(76561198361055555, 1690892573, 'a62182b6499cbb9e2cfb85688a402f4af9ab4e0674d5ed502e11d4d750c5d477'),
	(76561198028237108, 1690894007, '84ac5f2551a1b903a6f508884eeeb024b49e0a0671daeb8837852518aa513354'),
	(76561198856884502, 1690909684, 'ed61edd51aec6ed3a925476a4f4527f7592650b49870cfcd952c45d1b1f804c4'),
	(76561198425444073, 1690896720, 'cb045b38393ca6e9088d5dd8e73febaf7a944b88b3b5a236b5f4960962c2e69c'),
	(76561198257121734, 1690909081, '248c769ef9080f62589ad4bab8a880ee050e98efdfab3ffbd784c2fa443a257f'),
	(76561198801794286, 1690909906, 'a2f926eb4147b519cd9f125235f613f93c4c04ec804968edc7f2fcca0e17ca4e'),
	(76561199466507327, 1690911238, '32b7ab30f85a34c41127d6ce2e7cb3b0ef936727da41a051a054adf90a2942da');
/*!40000 ALTER TABLE `ba_hashlog` ENABLE KEYS */;

-- Дамп данных таблицы s237_gmod_dev.ba_iplog: 14 rows
/*!40000 ALTER TABLE `ba_iplog` DISABLE KEYS */;
INSERT INTO `ba_iplog` (`steamid`, `lastseen`, `ip`) VALUES
	(76561198432845546, 1690882101, '213.230.88.254'),
	(76561198979903152, 1690883684, '37.194.125.66'),
	(76561198396396064, 1690884022, '194.156.125.124'),
	(76561198396396064, 1690885188, '194.156.125.51'),
	(76561198797549224, 1690963421, '192.168.1.22'),
	(76561198797549224, 1690892357, '95.24.54.136'),
	(76561198959253828, 1690892487, '92.62.56.11'),
	(76561198361055555, 1690892561, '46.191.137.178'),
	(76561198028237108, 1690893999, '91.102.72.201'),
	(76561198856884502, 1690909673, '212.164.38.125'),
	(76561198425444073, 1690896712, '91.210.24.186'),
	(76561198257121734, 1690909071, '178.217.152.237'),
	(76561198801794286, 1690909900, '91.132.107.131'),
	(76561199466507327, 1690911221, '37.55.121.48');
/*!40000 ALTER TABLE `ba_iplog` ENABLE KEYS */;

-- Дамп данных таблицы s237_gmod_dev.ba_keys: 0 rows
/*!40000 ALTER TABLE `ba_keys` DISABLE KEYS */;
/*!40000 ALTER TABLE `ba_keys` ENABLE KEYS */;

-- Дамп данных таблицы s237_gmod_dev.ba_ranks: 53 rows
/*!40000 ALTER TABLE `ba_ranks` DISABLE KEYS */;
INSERT INTO `ba_ranks` (`steamid`, `sv_id`, `rank`, `expire_rank`, `expire_time`) VALUES
	(76561198797549224, 'NO_ID', 16, 16, 0),
	(76561199020306757, 'NOT_SET', 1, 1, 0),
	(76561198322134952, 'NOT_SET', 1, 1, 0),
	(76561198028237108, 'NOT_SET', 1, 1, 0),
	(76561199048552884, 'NOT_SET', 1, 1, 0),
	(76561198856884502, 'NOT_SET', 1, 1, 0),
	(76561198959253828, 'NO_ID', 16, 16, 0),
	(76561198988795607, 'NOT_SET', 1, 1, 0),
	(76561199102537119, 'NOT_SET', 1, 1, 0),
	(76561198396396064, 'NOT_SET', 1, 1, 0),
	(76561199183316980, 'NOT_SET', 1, 1, 0),
	(76561199031710317, 'NOT_SET', 1, 1, 0),
	(76561198170506041, 'NOT_SET', 1, 1, 0),
	(76561198055957780, 'NOT_SET', 1, 1, 0),
	(76561198425444073, 'NOT_SET', 1, 1, 0),
	(76561199230652199, 'NOT_SET', 1, 1, 0),
	(76561198841846666, 'NOT_SET', 1, 1, 0),
	(76561198264495511, 'NOT_SET', 1, 1, 0),
	(76561198023029298, 'NOT_SET', 1, 1, 0),
	(76561198080060935, 'NOT_SET', 1, 1, 0),
	(76561198080060935, 'NOT_SET', 2, 2, 0),
	(76561199003277869, 'NOT_SET', 1, 1, 0),
	(76561198260336186, 'NOT_SET', 1, 1, 0),
	(76561198963571042, 'NOT_SET', 1, 1, 0),
	(76561198876936455, 'NOT_SET', 1, 1, 0),
	(76561199003277869, 'NOT_SET', 2, 2, 0),
	(76561198322134952, 'NOT_SET', 2, 2, 0),
	(76561198929754148, 'NOT_SET', 1, 1, 0),
	(76561198208170995, 'NOT_SET', 1, 1, 0),
	(76561198979903152, 'NOT_SET', 1, 1, 0),
	(76561199052641384, 'NOT_SET', 1, 1, 0),
	(76561198038575959, 'NOT_SET', 1, 1, 0),
	(76561198361055555, 'NOT_SET', 1, 1, 0),
	(76561198405074930, 'NOT_SET', 1, 1, 0),
	(76561198856884502, 'NOT_SET', 2, 2, 0),
	(76561198350467007, 'NOT_SET', 1, 1, 0),
	(76561199496268709, 'NOT_SET', 1, 1, 0),
	(76561199003277869, 'NOT_SET', 2, 2, 0),
	(76561198843576131, 'NOT_SET', 1, 1, 0),
	(76561198219530143, 'NOT_SET', 1, 1, 0),
	(76561199388733900, 'NOT_SET', 1, 1, 0),
	(76561198023029298, 'NOT_SET', 2, 2, 0),
	(76561198856884502, 'NOT_SET', 2, 2, 0),
	(76561199153773219, 'NOT_SET', 1, 1, 0),
	(76561198856884502, 'NOT_SET', 2, 2, 0),
	(76561199228733447, 'NOT_SET', 1, 1, 0),
	(76561198023029298, 'NOT_SET', 2, 2, 0),
	(76561199511279047, 'NOT_SET', 1, 1, 0),
	(76561199102537119, 'NOT_SET', 2, 2, 0),
	(76561198432845546, 'NOT_SET', 1, 1, 0),
	(76561198257121734, 'NOT_SET', 1, 1, 0),
	(76561198801794286, 'NOT_SET', 1, 1, 0),
	(76561199466507327, 'NOT_SET', 1, 1, 0);
/*!40000 ALTER TABLE `ba_ranks` ENABLE KEYS */;

-- Дамп данных таблицы s237_gmod_dev.ba_rating: ~0 rows (приблизительно)

-- Дамп данных таблицы s237_gmod_dev.ba_ratinglogs: ~0 rows (приблизительно)

-- Дамп данных таблицы s237_gmod_dev.ba_server_vars: 0 rows
/*!40000 ALTER TABLE `ba_server_vars` DISABLE KEYS */;
/*!40000 ALTER TABLE `ba_server_vars` ENABLE KEYS */;

-- Дамп данных таблицы s237_gmod_dev.ba_users: 12 rows
/*!40000 ALTER TABLE `ba_users` DISABLE KEYS */;
INSERT INTO `ba_users` (`steamid`, `name`, `firstjoined`, `lastseen`, `playtime`) VALUES
	(76561198432845546, '[GoTeam] PaRadoX', 1690882101, 1690882642, 541),
	(76561198979903152, 'Schwarzkopf (ITL)', 1690883684, 1690885329, 1644),
	(76561198396396064, 'superbatya891', 1690884022, 1690885361, 871),
	(76561198797549224, '-Spac3', 1690891147, 1690963900, 3014),
	(76561198959253828, 'wentyy', 1690892487, 1690896018, 3531),
	(76561198361055555, 'ÐŸÐÐ ÐÐ¨Ð®Ð¢:D', 1690892561, 1690896012, 3451),
	(76561198028237108, 'REALbad', 1690893999, 1690894763, 764),
	(76561198856884502, 'RevSonger', 1690894150, 1690910072, 913),
	(76561198425444073, 'Will0w18', 1690896712, 1690897283, 571),
	(76561198257121734, 'Alpha', 1690909071, 1690912774, 3704),
	(76561198801794286, 'Phyzik', 1690909900, 1690909975, 76),
	(76561199466507327, 'ko4etov19887', 1690911221, 1690912311, 1090);
/*!40000 ALTER TABLE `ba_users` ENABLE KEYS */;

-- Дамп данных таблицы s237_gmod_dev.ba_warns: ~0 rows (приблизительно)

-- Дамп данных таблицы s237_gmod_dev.kshop_credits_transactions: 0 rows
/*!40000 ALTER TABLE `kshop_credits_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `kshop_credits_transactions` ENABLE KEYS */;

-- Дамп данных таблицы s237_gmod_dev.kshop_currency_conversions: 0 rows
/*!40000 ALTER TABLE `kshop_currency_conversions` DISABLE KEYS */;
/*!40000 ALTER TABLE `kshop_currency_conversions` ENABLE KEYS */;

-- Дамп данных таблицы s237_gmod_dev.kshop_ipn_transactions: 0 rows
/*!40000 ALTER TABLE `kshop_ipn_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `kshop_ipn_transactions` ENABLE KEYS */;

-- Дамп данных таблицы s237_gmod_dev.kshop_purchases: 0 rows
/*!40000 ALTER TABLE `kshop_purchases` DISABLE KEYS */;
/*!40000 ALTER TABLE `kshop_purchases` ENABLE KEYS */;

-- Дамп данных таблицы s237_gmod_dev.kshop_servers: ~0 rows (приблизительно)

-- Дамп данных таблицы s237_gmod_dev.orgs: 0 rows
/*!40000 ALTER TABLE `orgs` DISABLE KEYS */;
/*!40000 ALTER TABLE `orgs` ENABLE KEYS */;

-- Дамп данных таблицы s237_gmod_dev.org_player: 0 rows
/*!40000 ALTER TABLE `org_player` DISABLE KEYS */;
/*!40000 ALTER TABLE `org_player` ENABLE KEYS */;

-- Дамп данных таблицы s237_gmod_dev.org_rank: 0 rows
/*!40000 ALTER TABLE `org_rank` DISABLE KEYS */;
/*!40000 ALTER TABLE `org_rank` ENABLE KEYS */;

-- Дамп данных таблицы s237_gmod_dev.player_cooldowns: 0 rows
/*!40000 ALTER TABLE `player_cooldowns` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_cooldowns` ENABLE KEYS */;

-- Дамп данных таблицы s237_gmod_dev.player_data: 12 rows
/*!40000 ALTER TABLE `player_data` DISABLE KEYS */;
INSERT INTO `player_data` (`SteamID`, `Name`, `Money`, `Karma`, `Achs`, `Pocket`) VALUES
	(76561198432845546, 'Azucen Tindel', 21263, 1000, '{"3442423846":8.0}', '[]'),
	(76561198979903152, 'Aniss Fiebig', 24200, 1000, '{}', '[}'),
	(76561198797549224, 'Ba Gautney', 24370, 1000, '{"2020843373":2.0}', '[]'),
	(76561198396396064, 'Ild Kuehler', 24730, 1000, '{}', '[]'),
	(76561198959253828, 'Ninf Haviland', 70687, 213100, '{"2638459492":5.0,"3442423846":1.0}', '[]'),
	(76561198361055555, 'Dust Farhart', 65382, 1050, '{"3467375797":1.0,"3442423846":1.0}', '[]'),
	(76561198028237108, 'Janiec Roll', 24585, 1000, '{}', '[]'),
	(76561198856884502, 'Rev Songer', 1713090, 0, '{}', '{[\'contents;Xe;\'count;Xa;\'Model;\'models/sup/shipment/shimpmentcrate.mdl;\'Class;\'spawned_shipment;}[(3)X1d;(4)Xa;(5)(6)(7)(8)}[(3)X1a;(4)Xa;(5)(6)(7)(8)}~}'),
	(76561198425444073, 'Jennife Pitner', 69000, 1000, '{}', '[]'),
	(76561198257121734, 'Yo Kennealy', 135164, 1050, '{"3442423846":1.0,"3467375797":5.0}', '[}'),
	(76561198801794286, 'Eln Schmierer', 25000, 1000, '{}', '[]'),
	(76561199466507327, 'Alon Sughrue', 25000, 1000, '{"3467375797":6.0}', '[]');
/*!40000 ALTER TABLE `player_data` ENABLE KEYS */;

-- Дамп данных таблицы s237_gmod_dev.player_hats: 0 rows
/*!40000 ALTER TABLE `player_hats` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_hats` ENABLE KEYS */;

-- Дамп данных таблицы s237_gmod_dev.sessions: ~0 rows (приблизительно)

-- Дамп данных таблицы s237_gmod_dev.wep_active: ~0 rows (приблизительно)

-- Дамп данных таблицы s237_gmod_dev.wep_skins: ~0 rows (приблизительно)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
