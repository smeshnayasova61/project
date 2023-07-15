/* Требования к курсовому проекту: 
1.Составить общее текстовое описание БД и решаемых ею задач; 
2.минимальное количество таблиц - 10; 
3.скрипты создания структуры БД (с первичными ключами, индексами, внешними ключами); 
4.создать ERDiagram для БД; 
5.скрипты наполнения БД данными; 
6.скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы);
7.представления (минимум 2); 
8.хранимые процедуры / триггеры; 
Примеры:описать модель хранения данных популярноговеб-сайта: кинопоиск,
booking.com, wikipedia, интернет-магазин, geekbrains, госуслуги... Думайте об этом задании, как о том, 
чем Вы похвастаетесь на своем следующем собеседовании. Удачи! */

/*Курсовой проект описать модель хранения данных популярного веб-сайта госуслуги:

1.Составить общее текстовое описание БД и решаемых ею задач; 
Текстовое описание БД и решаемых задач:
БД для сайта госуслуги предназначена для хранения информации 
о гражданах, оказываемых им государственных услугах, платежах,
подаче заявлений и запросов, а также для автоматизации процессов
обработки заявлений и запросов. БД позволяет следить за сроками обработки заявлений и запросов, обеспечивает контроль за ходом выполнения работы сотрудниками государственных органов, а также упрощает процесс платежей.


2.минимальное количество таблиц - 10; 
Структура БД будет состоять из 10 таблиц:
1. Пользователи (id, ФИО, email, пароль и т.д.) - Users;
2. Контактные данные гражданина (id, id пользователя, ФИО, адрес, телефон и т.д.) - CitizenContacts;
3. Государственные услуги (id, название, описание, стоимость и т.д.) -  GovernmentServices;
4. Заявления (id, id гражданина, id государственной услуги, дата подачи, статус и т.д.) - Applications;
5. Запросы на информацию (id, id гражданина, id государственной услуги, дата подачи, статус и т.д.) - Requests;
6. Платежи (id, id заявления, дата оплаты, сумма и т.д.) - Payments;
7. Ответы на запросы (id, id гражданина, id государственной услуги, id запроса, дата отправки, текст ответа и т.д.) - Responses;
8. Статусы заявлений и запросов (id, название, описание) - ApplicationStatuses, RequestStatuses;
9. История изменений статусов заявлений и запросов (id, id заявления/запроса, id статуса, дата изменения) - StatusChanges;
10. Сотрудники государственных органов (id, ФИО, должность и т.д.). - GovernmentWorkers*/


/*3.скрипты создания структуры БД (с первичными ключами, индексами, внешними ключами); */

DROP DATABASE IF EXISTS GOSUSLUGI;
CREATE DATABASE GOSUSLUGI;

USE GOSUSLUGi;

-- DROP TABLE IF EXISTS Users; 
CREATE TABLE Users (
   id INT NOT NULL AUTO_INCREMENT,
   name VARCHAR(50) NOT NULL,
   email VARCHAR(50) NOT NULL,
   password VARCHAR(50) NOT NULL,
   PRIMARY KEY (id)
);

-- DROP TABLE IF EXISTS CitizenContacts; 
CREATE TABLE CitizenContacts (
   id INT NOT NULL AUTO_INCREMENT,
   userId INT NOT NULL,
   name VARCHAR(50) NOT NULL,
   address VARCHAR(100) NOT NULL,
   phone VARCHAR(20) NOT NULL,
   PRIMARY KEY (id),
   FOREIGN KEY (userId) REFERENCES Users(id) ON DELETE CASCADE
);

-- DROP TABLE IF EXISTS GovernmentServices; 
CREATE TABLE GovernmentServices (
   id INT NOT NULL AUTO_INCREMENT,
   name VARCHAR(50) NOT NULL,
   description VARCHAR(200) NOT NULL,
   cost DECIMAL(10, 2) NOT NULL,
   PRIMARY KEY (id)
);

-- DROP TABLE IF EXISTS ApplicationStatuses; 
CREATE TABLE ApplicationStatuses (
   id INT NOT NULL AUTO_INCREMENT,
   name VARCHAR(50) NOT NULL,
   description VARCHAR(200) NOT NULL,
   PRIMARY KEY (id)
);

-- DROP TABLE IF EXISTS Applications; 
CREATE TABLE Applications (
   id INT NOT NULL AUTO_INCREMENT,
   citizenId INT NOT NULL,
   governmentServiceId INT NOT NULL,
   applicationDate DATETIME NOT NULL,
   statusId INT NOT NULL,
   PRIMARY KEY (id),
   FOREIGN KEY (citizenId) REFERENCES CitizenContacts(id) ON DELETE CASCADE,
   FOREIGN KEY (governmentServiceId) REFERENCES GovernmentServices(id) ON DELETE CASCADE,
   FOREIGN KEY (statusId) REFERENCES ApplicationStatuses(id) ON DELETE CASCADE
);

-- DROP TABLE IF EXISTS RequestStatuses; 
CREATE TABLE RequestStatuses (
   id INT NOT NULL AUTO_INCREMENT,
   name VARCHAR(50) NOT NULL,
   description VARCHAR(200) NOT NULL,
   PRIMARY KEY (id)
);
   
-- DROP TABLE IF EXISTS Requests; 
CREATE TABLE Requests (
   id INT NOT NULL AUTO_INCREMENT,
   citizenId INT NOT NULL,
   governmentServiceId INT NOT NULL,
   requestDate DATETIME NOT NULL,
   statusId INT NOT NULL,
   PRIMARY KEY (id),
   FOREIGN KEY (citizenId) REFERENCES CitizenContacts(id) ON DELETE CASCADE,
   FOREIGN KEY (governmentServiceId) REFERENCES GovernmentServices(id) ON DELETE CASCADE,
   FOREIGN KEY (statusId) REFERENCES RequestStatuses(id) ON DELETE CASCADE
);

-- DROP TABLE IF EXISTS Payments; 
CREATE TABLE Payments (
   id INT NOT NULL AUTO_INCREMENT,
   applicationId INT NOT NULL,
   paymentDate DATETIME NOT NULL,
   amount DECIMAL(10, 2) NOT NULL,
   PRIMARY KEY (id),
   FOREIGN KEY (applicationId) REFERENCES Applications(id) ON DELETE CASCADE
);

-- DROP TABLE IF EXISTS Responses; 
CREATE TABLE Responses (
   id INT NOT NULL AUTO_INCREMENT,
   citizenId INT NOT NULL,
   governmentServiceId INT NOT NULL,
   requestId INT NOT NULL,
   responseDate DATETIME NOT NULL,
   text VARCHAR(200) NOT NULL,
   PRIMARY KEY (id),
   FOREIGN KEY (citizenId) REFERENCES CitizenContacts(id) ON DELETE CASCADE,
   FOREIGN KEY (governmentServiceId) REFERENCES GovernmentServices(id) ON DELETE CASCADE,
   FOREIGN KEY (requestId) REFERENCES Requests(id) ON DELETE CASCADE
);

-- DROP TABLE IF EXISTS StatusChanges; 
CREATE TABLE StatusChanges (
   id INT NOT NULL AUTO_INCREMENT,
   applicationId INT,
   requestId INT,
   statusId INT NOT NULL,
   changeDate DATETIME NOT NULL,
   PRIMARY KEY (id),
   FOREIGN KEY (applicationId) REFERENCES Applications(id) ON DELETE CASCADE,
   FOREIGN KEY (requestId) REFERENCES Requests(id) ON DELETE CASCADE,
   FOREIGN KEY (statusId) REFERENCES ApplicationStatuses(id) ON DELETE CASCADE
);

-- DROP TABLE IF EXISTS GovernmentWorkers;
CREATE TABLE GovernmentWorkers (
   id INT NOT NULL AUTO_INCREMENT,
   name VARCHAR(50) NOT NULL,
   statusId INT NOT NULL,
   position VARCHAR(50) NOT NULL,
   PRIMARY KEY (id),
   FOREIGN KEY (statusId) REFERENCES StatusChanges(id) ON DELETE CASCADE
);

/*4.создать ERDiagram для БД; */

-- https://drive.google.com/file/d/1zOxoFBToLQ0AWKVTzFJDv3KNQ_WL8Xrw/view?usp=sharing

/*5.скрипты наполнения БД данными;*/


USE GOSUSLUGi;
DROP TABLE IF EXISTS `GovernmentWorkers`;
DROP TABLE IF EXISTS `StatusChanges`;
DROP TABLE IF EXISTS `Payments`;
DROP TABLE IF EXISTS `Applications`;
DROP TABLE IF EXISTS `ApplicationStatuses`;
DROP TABLE IF EXISTS `Responses`;
DROP TABLE IF EXISTS `Requests`;
DROP TABLE IF EXISTS `RequestStatuses`;
DROP TABLE IF EXISTS `CitizenContacts`;
DROP TABLE IF EXISTS `GovernmentServices`;
DROP TABLE IF EXISTS `Users`;

#
# TABLE STRUCTURE FOR: Users
#

-- DROP TABLE IF EXISTS `Users`;

CREATE TABLE `Users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `Users` (`id`, `name`, `email`, `password`)
VALUES 
(1, 'Danial Nader', 'lubowitz.ilene@gmail.com', 'f3282f6a5d2c489d18aa88aab54e68bbbd309797'),
(2, 'Dr. Rodolfo Rath Jr.', 'hartmann.deion@batz.biz', 'c24617c492d65ed0a97a72ea54142ad58c67e8ae'),
(3, 'Manuel Tremblay', 'rwolff@carter.net', 'a73256f3335223a2dafe4313c222643e743d968b'),
(4, 'Dr. Jamie Kautzer III', 'pouros.beatrice@hotmail.com', 'c70e972de33aefaf864112ec672fe39e46541719'),
(5, 'Marco Weber Jr.', 'leanne36@jenkins.net', '6e4b06061b71b840a36e418a9fee96783bd4acc6'),
(6, 'Woodrow Treutel', 'jakubowski.emmalee@moen.com', '290f75860fd1e3112b6c0c93349c94aa748535b8'),
(7, 'Shaylee Bode', 'baylee08@hotmail.com', 'd66e800003d66958872c83bebb5c13b7e61c260c'),
(8, 'Khalid Davis', 'kristina.graham@purdyberge.com', '69604d2d5771fcf1fbfaac8c35c955d472447362'),
(9, 'Branson Leuschke', 'roob.marcellus@yahoo.com', '7525f4b1392c1274cec91963d44b7a23a2e2c0e5'),
(10, 'Una Fritsch', 'osinski.monroe@yahoo.com', '70dc29aeb8bd8d61b448b9f7724820aedc8b7585');

#
# TABLE STRUCTURE FOR: CitizenContacts
#

-- DROP TABLE IF EXISTS `CitizenContacts`;

CREATE TABLE `CitizenContacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `address` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `CitizenContacts_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `Users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `CitizenContacts` (`id`, `userId`, `name`, `address`, `phone`) 
VALUES 
(1, 6, 'corrupti', '9896 Lina Squares Suite 138\nPort Bobbyborough, OH 54650-4639', '(851)663-8958'),
(2, 2, 'est', '4549 Wuckert Unions Apt. 056\nEast Destini, MD 09824-7661', '840-352-4768'),
(3, 3, 'non', '31959 Tromp Avenue\nLehnerfurt, VT 43531', '304.520.5165x65642'),
(4, 6, 'unde', '092 Drew Roads Suite 095\nKertzmannview, VA 21795-0903', '(126)443-9489x351'),
(5, 8, 'aliquam', '063 Waters Stravenue\nNew Fredrick, NY 60698', '533.249.1123x651'),
(6, 1, 'quasi', '1492 Willow Passage Suite 531\nSouth Enid, PA 09248-3800', '1-690-144-7959x86280'),
(7, 6, 'et', '6688 Ilene Rue\nPort Maggieshire, SC 07100', '1-209-297-5533x567'),
(8, 1, 'minima', '146 Bosco Heights Suite 674\nKingtown, CA 13808', '00144353399'),
(9, 2, 'non', '011 King Road Suite 717\nPort Leannamouth, OH 90654-1975', '1-037-189-4737x53839'),
(10, 4, 'vitae', '84812 Brennan Hill\nLake Demetrisborough, MT 45547-7442', '966.193.7368x70704');

#
# TABLE STRUCTURE FOR: GovernmentServices
#

-- DROP TABLE IF EXISTS `GovernmentServices`;

CREATE TABLE `GovernmentServices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(200) NOT NULL,
  `cost` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `GovernmentServices` (`id`, `name`, `description`, `cost`) 
VALUES
(1, 'nemo', 'Necessitatibus et quos ratione beatae.', '234.00'),
(2, 'minima', 'Rerum a voluptatem ipsa atque dolorem vel.', '12012406.30'),
(3, 'optio', 'Similique unde rerum quis voluptas repellat ut velit voluptates.', '24724630.62'),
(4, 'aperiam', 'Ab laudantium nihil nesciunt accusantium.', '0.00'),
(5, 'dolores', 'Ullam qui inventore eum ratione.', '1.33'),
(6, 'ut', 'Illo accusamus non ipsam accusantium.', '4500687.13'),
(7, 'quam', 'In quae temporibus dolor expedita cupiditate consequatur voluptatum.', '87.21'),
(8, 'explicabo', 'Nobis optio ipsum eum cumque voluptatem ut cupiditate.', '147835.64'),
(9, 'eum', 'Corrupti ut consequatur optio qui atque et.', '6663.00'),
(10, 'voluptas', 'Voluptates laborum qui quo sequi quis placeat amet.', '8.83');

#
# TABLE STRUCTURE FOR: ApplicationStatuses
#

-- DROP TABLE IF EXISTS `ApplicationStatuses`;

CREATE TABLE `ApplicationStatuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `ApplicationStatuses` (`id`, `name`, `description`) 
VALUES 
(1, 'adipisci', 'Alias provident harum aut.'),
(2, 'et', 'Est nostrum recusandae sint.'),
(3, 'ut', 'Accusantium omnis dolor ut qui ipsam.'),
(4, 'modi', 'Temporibus voluptatem dolorem explicabo.'),
(5, 'cumque', 'Eum omnis eos beatae dicta.'),
(6, 'deserunt', 'Magnam aut ipsum praesentium eius mollitia quisquam et.'),
(7, 'voluptatem', 'Debitis suscipit corporis nemo sunt magnam enim a.'),
(8, 'illo', 'Eveniet illo porro minus veniam tenetur necessitatibus sit.'),
(9, 'voluptatem', 'Eius illo odio aliquam minima aspernatur ut veniam.'),
(10, 'iure', 'Cumque cupiditate perferendis dolorum illo.');


#
# TABLE STRUCTURE FOR: Applications
#

-- DROP TABLE IF EXISTS `Applications`;

CREATE TABLE `Applications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenId` int(11) NOT NULL,
  `governmentServiceId` int(11) NOT NULL,
  `applicationDate` datetime NOT NULL,
  `statusId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenId` (`citizenId`),
  KEY `governmentServiceId` (`governmentServiceId`),
  KEY `statusId` (`statusId`),
  CONSTRAINT `Applications_ibfk_1` FOREIGN KEY (`citizenId`) REFERENCES `CitizenContacts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `Applications_ibfk_2` FOREIGN KEY (`governmentServiceId`) REFERENCES `GovernmentServices` (`id`) ON DELETE CASCADE,
  CONSTRAINT `Applications_ibfk_3` FOREIGN KEY (`statusId`) REFERENCES `ApplicationStatuses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `Applications` (`id`, `citizenId`, `governmentServiceId`, `applicationDate`, `statusId`) 
VALUES 
(1, 3, 5, '2014-12-08 03:36:26', 7),
(2, 3, 6, '1997-01-30 15:26:04', 3),
(3, 2, 2, '1971-11-05 18:31:31', 4),
(4, 6, 4, '1980-08-03 06:48:02', 9),
(5, 8, 4, '1994-04-23 16:39:40', 4),
(6, 4, 1, '1978-03-09 22:58:32', 7),
(7, 4, 1, '1994-06-22 10:18:31', 1),
(8, 4, 8, '2011-11-07 21:41:04', 1),
(9, 2, 4, '1982-09-15 17:06:08', 5),
(10, 5, 1, '1987-10-30 03:52:14', 8);

#
# TABLE STRUCTURE FOR: RequestStatuses
#

-- DROP TABLE IF EXISTS `RequestStatuses`;

CREATE TABLE `RequestStatuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `RequestStatuses` (`id`, `name`, `description`) 
VALUES
(1, 'officia', 'Itaque et odit ut temporibus quas qui nisi.'),
(2, 'possimus', 'Sed reiciendis amet error.'),
(3, 'corporis', 'Repellat nemo nostrum dolorum pariatur velit.'),
(4, 'corrupti', 'Distinctio eos impedit numquam molestiae quidem.'),
(5, 'et', 'Eaque omnis minima error.'),
(6, 'ipsum', 'Accusamus qui officia aspernatur nobis facilis enim deleniti fugiat.'),
(7, 'eum', 'Optio placeat repellat ratione quia ipsum.'),
(8, 'iste', 'Fugit et perferendis temporibus qui qui.'),
(9, 'sunt', 'Ipsam iusto est perspiciatis eos numquam.'),
(10, 'quo', 'Nisi enim odit dolor nesciunt omnis deleniti saepe.');


#
# TABLE STRUCTURE FOR: Requests
#

-- DROP TABLE IF EXISTS `Requests`;

CREATE TABLE `Requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenId` int(11) NOT NULL,
  `governmentServiceId` int(11) NOT NULL,
  `requestDate` datetime NOT NULL,
  `statusId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenId` (`citizenId`),
  KEY `governmentServiceId` (`governmentServiceId`),
  KEY `statusId` (`statusId`),
  CONSTRAINT `Requests_ibfk_1` FOREIGN KEY (`citizenId`) REFERENCES `CitizenContacts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `Requests_ibfk_2` FOREIGN KEY (`governmentServiceId`) REFERENCES `GovernmentServices` (`id`) ON DELETE CASCADE,
  CONSTRAINT `Requests_ibfk_3` FOREIGN KEY (`statusId`) REFERENCES `RequestStatuses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `Requests` (`id`, `citizenId`, `governmentServiceId`, `requestDate`, `statusId`) 
VALUES
(1, 6, 3, '1992-12-11 01:18:24', 7),
(2, 2, 3, '1987-07-25 07:53:25', 5),
(3, 9, 2, '1979-03-11 13:56:05', 1),
(4, 6, 3, '1986-02-28 03:15:49', 8),
(5, 7, 1, '1982-06-30 20:13:00', 8),
(6, 8, 3, '2007-07-23 08:03:31', 8),
(7, 4, 9, '1981-10-02 22:35:46', 2),
(8, 4, 2, '1988-06-01 19:00:32', 8),
(9, 2, 9, '1985-04-02 13:13:34', 8),
(10, 4, 9, '1975-08-23 01:58:14', 7);

#
# TABLE STRUCTURE FOR: Payments
#

-- DROP TABLE IF EXISTS `Payments`;

CREATE TABLE `Payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `applicationId` int(11) NOT NULL,
  `paymentDate` datetime NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `applicationId` (`applicationId`),
  CONSTRAINT `Payments_ibfk_1` FOREIGN KEY (`applicationId`) REFERENCES `Applications` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `Payments` (`id`, `applicationId`, `paymentDate`, `amount`)
VALUES 
(1, 6, '2006-10-18 13:37:18', '4082500.87'),
(2, 6, '1994-08-12 21:46:19', '10922.60'),
(3, 5, '1980-10-13 11:50:50', '0.00'),
(4, 6, '1974-05-29 22:20:22', '158722.00'),
(5, 4, '1975-01-19 17:40:58', '0.49'),
(6, 4, '2000-03-16 14:24:29', '1378297.68'),
(7, 5, '2015-05-17 06:16:05', '404.97'),
(8, 9, '1997-11-29 17:50:41', '769.00'),
(9, 5, '2005-10-01 18:32:59', '99999999.99'),
(10, 8, '2008-10-28 19:17:24', '190323.18');

#
# TABLE STRUCTURE FOR: Responses
#

-- DROP TABLE IF EXISTS `Responses`;

CREATE TABLE `Responses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenId` int(11) NOT NULL,
  `governmentServiceId` int(11) NOT NULL,
  `requestId` int(11) NOT NULL,
  `responseDate` datetime NOT NULL,
  `text` varchar(200) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenId` (`citizenId`),
  KEY `governmentServiceId` (`governmentServiceId`),
  KEY `requestId` (`requestId`),
  CONSTRAINT `Responses_ibfk_1` FOREIGN KEY (`citizenId`) REFERENCES `CitizenContacts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `Responses_ibfk_2` FOREIGN KEY (`governmentServiceId`) REFERENCES `GovernmentServices` (`id`) ON DELETE CASCADE,
  CONSTRAINT `Responses_ibfk_3` FOREIGN KEY (`requestId`) REFERENCES `Requests` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `Responses` (`id`, `citizenId`, `governmentServiceId`, `requestId`, `responseDate`, `text`) 
VALUES
(1, 4, 1, 2, '2015-04-12 13:48:12', 'Magnam expedita beatae autem modi. Aspernatur quia aliquam asperiores similique facilis. Asperiores magni impedit nam et iusto magnam et.'),
(2, 7, 7, 9, '1974-09-25 23:18:32', 'Aut sed est similique delectus quia. Qui illum eaque sit est. Minus beatae minus vero quia.'),
(3, 6, 2, 4, '1981-12-27 00:22:10', 'Pariatur consequuntur facere eum eaque. Et cupiditate laborum sunt. In laudantium quisquam accusamus et. Fuga ducimus qui nostrum maxime quia ab magni doloremque.'),
(4, 8, 3, 5, '1981-01-29 23:15:48', 'Molestias fugit cum laudantium magni. Quis voluptatum natus dolores non in dolorum velit commodi. Explicabo animi neque voluptatem quisquam modi est illum qui.'),
(5, 9, 2, 4, '1981-11-02 11:57:01', 'Debitis qui dolorem labore ab omnis quia. Rem qui voluptates aperiam quam eligendi. Est aliquam deleniti nemo quia et rem itaque ut.'),
(6, 7, 3, 3, '1999-12-28 14:25:15', 'Quia ut enim saepe ducimus. Sit et nam consequatur inventore non animi. Fugit cupiditate nesciunt voluptas atque maxime.'),
(7, 7, 4, 4, '1976-11-08 13:42:59', 'Enim dignissimos nisi nemo rerum vel nobis non. Ex vero sed alias vel omnis ex. Sit natus repellendus ut et laudantium.'),
(8, 3, 4, 8, '1982-01-02 00:06:08', 'Consectetur optio quis porro officiis molestias asperiores et. Voluptas ex nobis quia dolorum. Iure ratione tenetur nobis atque est.'),
(9, 6, 8, 9, '1970-11-07 12:46:35', 'Amet rerum consequatur et rem. Est molestiae vitae quae totam at eaque rem. Ex ea quis adipisci autem natus. Deserunt mollitia ut sed nostrum qui.'),
(10, 9, 7, 1, '1977-01-03 01:34:03', 'Cupiditate iste nihil veritatis. Molestias nesciunt quia incidunt. Rerum magnam laboriosam harum occaecati mollitia.\nDebitis at non magnam labore recusandae magni vel. Animi dolor nemo et provident.');


#
# TABLE STRUCTURE FOR: StatusChanges
#

-- DROP TABLE IF EXISTS `StatusChanges`;

CREATE TABLE `StatusChanges` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `applicationId` int(11) DEFAULT NULL,
  `requestId` int(11) DEFAULT NULL,
  `statusId` int(11) NOT NULL,
  `changeDate` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `applicationId` (`applicationId`),
  KEY `requestId` (`requestId`),
  KEY `statusId` (`statusId`),
  CONSTRAINT `StatusChanges_ibfk_1` FOREIGN KEY (`applicationId`) REFERENCES `Applications` (`id`) ON DELETE CASCADE,
  CONSTRAINT `StatusChanges_ibfk_2` FOREIGN KEY (`requestId`) REFERENCES `Requests` (`id`) ON DELETE CASCADE,
  CONSTRAINT `StatusChanges_ibfk_3` FOREIGN KEY (`statusId`) REFERENCES `ApplicationStatuses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `StatusChanges` (`id`, `applicationId`, `requestId`, `statusId`, `changeDate`) 
VALUES 
(1, 8, 7, 4, '1987-10-20 01:10:08'),
(2, 6, 8, 1, '1994-06-25 09:20:03'),
(3, 6, 6, 4, '1984-04-15 17:02:58'),
(4, 3, 7, 4, '1973-09-17 03:40:43'),
(5, 5, 3, 2, '2006-11-21 04:55:47'),
(6, 3, 3, 5, '1992-01-07 03:09:20'),
(7, 3, 2, 7, '1970-05-21 22:26:22'),
(8, 9, 7, 3, '1975-03-14 10:51:25'),
(9, 5, 2, 6, '1978-11-01 12:46:43'),
(10, 9, 7, 2, '1986-12-12 20:45:56');


#
# TABLE STRUCTURE FOR: GovernmentWorkers
#

-- DROP TABLE IF EXISTS `GovernmentWorkers`;

CREATE TABLE `GovernmentWorkers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `statusId` int(11) NOT NULL,
  `position` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `statusId` (`statusId`),
  CONSTRAINT `GovernmentWorkers_ibfk_1` FOREIGN KEY (`statusId`) REFERENCES `StatusChanges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `GovernmentWorkers` (`id`, `name`, `statusId`, `position`) 
VALUES 
(1, 'dolorem', 7, 'quia'),
(2, 'laboriosam', 2, 'et'),
(3, 'qui', 6, 'facere'),
(4, 'voluptates', 1, 'quis'),
(5, 'facilis', 3, 'reiciendis'),
(6, 'maiores', 5, 'quia'),
(7, 'ut', 1, 'iure'),
(8, 'rerum', 5, 'voluptate'),
(9, 'aliquid', 7, 'aut'),
(10, 'impedit', 9, 'aut');


-- 6.скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы);

-- Выборка всех заявок, для которых оплачен платеж:
SELECT Applications.id, CitizenContacts.name, GovernmentServices.name, Applications.applicationDate, ApplicationStatuses.name AS 'status'
FROM Applications
JOIN CitizenContacts ON Applications.citizenId = CitizenContacts.id
JOIN GovernmentServices ON Applications.governmentServiceId = GovernmentServices.id
JOIN ApplicationStatuses ON Applications.statusId = ApplicationStatuses.id
JOIN Payments ON Applications.id = Payments.applicationId;

-- Выборка всех запросов, на которые нет ответов:
SELECT Requests.id, CitizenContacts.name, GovernmentServices.name, Requests.requestDate, RequestStatuses.name AS 'status'
FROM Requests
JOIN CitizenContacts ON Requests.citizenId = CitizenContacts.id
JOIN GovernmentServices ON Requests.governmentServiceId = GovernmentServices.id
JOIN RequestStatuses ON Requests.statusId = RequestStatuses.id
LEFT JOIN Responses ON Requests.id = Responses.requestId
WHERE Responses.id IS NULL;

-- Выборка всех заявок, которые были поданы в определенный период:
SELECT *
FROM Applications
WHERE applicationDate BETWEEN '2022-01-01' AND '2022-12-31';

-- 7.представления (минимум 2); 

-- Представление для вывода списка заявок на оформление загранпаспорта:
CREATE VIEW PassportApplications AS
SELECT Applications.id, CitizenContacts.name, Applications.applicationDate, ApplicationStatuses.name AS 'status'
FROM Applications
JOIN CitizenContacts ON Applications.citizenId = CitizenContacts.id
JOIN GovernmentServices ON Applications.governmentServiceId = GovernmentServices.id
JOIN ApplicationStatuses ON Applications.statusId = ApplicationStatuses.id
WHERE GovernmentServices.name = 'Выдача загранпаспортов';


-- Представление для вывода списка платежей за заявки и запросы:
CREATE VIEW PaymentsList AS
SELECT Applications.id, CitizenContacts.name, GovernmentServices.description, Payments.amount, Payments.paymentDate
FROM Applications
JOIN CitizenContacts ON Applications.citizenId = CitizenContacts.id
JOIN GovernmentServices ON Applications.governmentServiceId = GovernmentServices.id
JOIN Payments ON Applications.id = Payments.applicationId
UNION
SELECT Requests.id, CitizenContacts.name, GovernmentServices.description, 0, NULL
FROM Requests
JOIN CitizenContacts ON Requests.citizenId = CitizenContacts.id
JOIN GovernmentServices ON Requests.governmentServiceId = GovernmentServices.id
LEFT JOIN Responses ON Requests.id = Responses.requestId
WHERE Responses.id IS NULL;


-- 8.хранимые процедуры / триггеры; 
-- Например, вот триггер, который будет записывать в лог изменения в таблице `users`:

-- DROP TABLE user_log;
CREATE TABLE user_log (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` INT NOT NULL,
  `action` varchar(50) NOT NULL,
  `timestamp` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));


-- Этот триггер будет запускаться после каждого обновления записи в таблице `users`. 
-- Он вставляет запись в отдельную таблицу `user_log`, содержащую `id` пользователя, 
-- действие (в данном случае - обновление) и метку времени.
 
-- DROP TRIGGER user_log;
DELIMITER //
CREATE TRIGGER user_log AFTER UPDATE ON users
FOR EACH ROW
BEGIN
   INSERT INTO user_log (user_id, action, timestamp)
   VALUES (NEW.id, NEW.id, 'update', NOW());
END//

-- хранимые процедуры
DELIMITER //
CREATE PROCEDURE my_version ()
BEGIN
	SELECT VERSION();
END//

CALL my_version();

