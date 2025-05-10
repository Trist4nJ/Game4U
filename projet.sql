-- CREATION BDD

CREATE database projetBDA;

use projetBDA;

CREATE TABLE Utilisateur (
  id_utilisateur INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  mot_de_passe VARCHAR(255) NOT NULL,
  role ENUM('user', 'admin') NOT NULL
);

CREATE TABLE Jeu (
  id_jeu INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(255) NOT NULL,
  description_jeu VARCHAR(255),
  annee_publication INT,
  duree_typique INT,
  duree_min INT,
  duree_max INT,
  nb_joueurs_min INT,
  nb_joueurs_max INT,
  age_min INT,
  stock INT DEFAULT 0,
  url VARCHAR(255),
  thumbnail_url VARCHAR(255)
);

CREATE TABLE Location (
  id_location INT AUTO_INCREMENT PRIMARY KEY,
  id_utilisateur INT NOT NULL,
  id_jeu INT NOT NULL,
  date_location DATE NOT NULL,
  date_retour DATE,
  statut ENUM('en cours', 'retournée') NOT NULL DEFAULT 'en cours',
  FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id_utilisateur),
  FOREIGN KEY (id_jeu) REFERENCES Jeu(id_jeu)
);

CREATE TABLE Categorie (
  id_categorie INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Jeu_Categorie (
  id_jeu INT,
  id_categorie INT,
  PRIMARY KEY (id_jeu, id_categorie),
  FOREIGN KEY (id_jeu) REFERENCES Jeu(id_jeu),
  FOREIGN KEY (id_categorie) REFERENCES Categorie(id_categorie)
);

CREATE TABLE Mecanique (
  id_mecanique INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Jeu_Mecanique (
  id_jeu INT,
  id_mecanique INT,
  PRIMARY KEY (id_jeu, id_mecanique),
  FOREIGN KEY (id_jeu) REFERENCES Jeu(id_jeu),
  FOREIGN KEY (id_mecanique) REFERENCES Mecanique(id_mecanique)
);

CREATE TABLE Contributeur (
  id_contributeur INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(100) NOT NULL,
  type ENUM('designer', 'artiste', 'editeur') NOT NULL
);

CREATE TABLE Jeu_Contributeur (
  id_jeu INT,
  id_contributeur INT,
  PRIMARY KEY (id_jeu, id_contributeur),
  FOREIGN KEY (id_jeu) REFERENCES Jeu(id_jeu),
  FOREIGN KEY (id_contributeur) REFERENCES Contributeur(id_contributeur)
);

CREATE TABLE Avis (
  id_avis INT AUTO_INCREMENT PRIMARY KEY,
  id_jeu INT UNIQUE,
  note_moyenne FLOAT,
  note_bayesienne FLOAT,
  nombre_evaluations INT,
  rang INT,
  FOREIGN KEY (id_jeu) REFERENCES Jeu(id_jeu)
);

-- INSERTION BDD

INSERT INTO Utilisateur (id_utilisateur, nom, email, mot_de_passe, role) VALUES
(1, 'Richard Thompson', 'gina01@hunter.com', 'C6RYIuIF$*DZ', 'admin'),
(2, 'Juan Houston', 'spencermichelle@jones-callahan.com', 'dKxs2&FeVnd@', 'admin'),
(3, 'Kristen Mckenzie', 'darren68@pearson-huff.net', 'UHCf0mem%6Y3', 'admin'),
(4, 'Joseph Wells', 'kristasimpson@gmail.com', '@13maeTwYx1D', 'admin'),
(5, 'Ms. Carol Brady', 'josephjackson@hotmail.com', '1#4YoCevc6wl', 'user'),
(6, 'Jeremy Hood', 'kpham@campbell-sanders.net', '+6EwzR1dIWzI', 'admin'),
(7, 'John Martinez', 'ztownsend@yahoo.com', 'hbJeFf9B&i1s', 'user'),
(8, 'Ronald Cantu', 'nesparza@shea.org', '$WY5URHd!1U$', 'admin'),
(9, 'Terrance Rogers Jr.', 'ryanstewart@morse-herrera.net', 'c&pJMPGtod)1', 'user'),
(10, 'Shane Wilson', 'ghall@gmail.com', '@ZyW7JxOw!8t', 'admin'),
(11, 'Mark Garcia', 'xbarry@hotmail.com', '^kwB0mFvc0zI', 'user'),
(12, 'Shannon Joseph', 'doylebeth@wright.com', 'g#OO)AgR*cv5', 'admin'),
(13, 'Robert Rogers', 'martinezpaula@gmail.com', 'Ze1Q0W3c7&LY', 'admin'),
(14, 'Ryan Sandoval', 'rosesamantha@brooks.com', 'k+@50Vvd(63p', 'admin'),
(15, 'Katherine Roberson', 'kevin79@gmail.com', '$LmCZ*CfD3Wp', 'admin'),
(16, 'Blake Dyer', 'pbrown@mcbride.com', '4f0vWxCv!YSC', 'user'),
(17, 'Anna Miles', 'jessicafields@king-bishop.com', '@5sX99(laFMN', 'user'),
(18, 'Grant Lane', 'mosleyrodney@ramos.org', 'Y#s8cOFfIUPy', 'user'),
(19, 'Jeremy Booker', 'williamwilliams@gmail.com', 'MiJy@o6a#66x', 'user'),
(20, 'Johnathan Mccarthy', 'smithsharon@yahoo.com', '!5Z$SC2XZ4Ah', 'user'),
(21, 'Jordan Rose', 'cheyenne18@taylor.org', 'K6_f5WjHa@@a', 'admin'),
(22, 'Catherine Hudson', 'ywilliams@gmail.com', '_#5lka++TZNH', 'admin'),
(23, 'Michael Long', 'stephanie39@sandoval.com', 'Az_KCAKpI@51', 'user'),
(24, 'Cory Lopez', 'briannawinters@miller-morgan.com', '*55vVc0BU3WO', 'user'),
(25, 'Lindsay Lopez', 'shafferstephanie@gonzales.com', 'D)3h@wxo@@!Q', 'user'),
(26, 'Andrew Hogan', 'mhudson@yahoo.com', '!hLvu#CxAoN9', 'admin'),
(27, 'Tim House', 'meaganromero@gmail.com', '@W5gm$#W1!MG', 'admin'),
(28, 'Charles Carter', 'joyce90@perez.com', 'r(3^UPTyi&dY', 'user'),
(29, 'Andrew Gordon', 'annaross@young.com', '(7JDvaTN^*QZ', 'user'),
(30, 'Lisa Berger', 'walterashley@ford.net', 'SKn8M_0b)6_v', 'user');

INSERT INTO Jeu (nom, description_jeu, annee_publication, duree_typique, duree_min, duree_max, nb_joueurs_min, nb_joueurs_max, age_min, stock, url, thumbnail_url) VALUES
('Uno', 'Jeu de cartes simple et rapide où le but est de se débarrasser de toutes ses cartes en associant couleurs et chiffres.', 1971, 20, 15, 30, 2, 10, 7, 10, 'https://example.com/uno', 'https://img.example.com/uno.jpg'),
('Loup-Garou de Thiercelieux', 'Jeu d’ambiance où les joueurs incarnent des villageois ou des loups-garous. Chaque nuit, les loups tuent un villageois, et le jour, les survivants débattent pour les éliminer.', 2001, 30, 20, 45, 8, 18, 10, 10, 'https://example.com/loup-garou', 'https://img.example.com/loup-garou.jpg'),
('Time’s Up!', 'Jeu de devinettes en 3 manches : faire deviner des personnalités en parlant, avec un mot, puis par mime.', 2008, 40, 30, 60, 4, 12, 12, 8, 'https://example.com/times-up', 'https://img.example.com/times-up.jpg'),
('Monopoly', 'Jeu de plateau classique où les joueurs achètent, échangent et construisent des propriétés pour ruiner leurs adversaires.', 1935, 90, 60, 180, 2, 6, 8, 5, 'https://example.com/monopoly', 'https://img.example.com/monopoly.jpg'),
('Dobble', 'Jeu de rapidité et d’observation. Chaque carte possède 8 symboles, et il faut retrouver celui en commun avec la carte centrale.', 2009, 15, 10, 20, 2, 8, 6, 10, 'https://example.com/dobble', 'https://img.example.com/dobble.jpg'),
('Jungle Speed', 'Jeu de réflexes où il faut attraper un totem lorsque deux cartes identiques sont révélées.', 1997, 15, 10, 20, 2, 10, 7, 7, 'https://example.com/jungle-speed', 'https://img.example.com/jungle-speed.jpg'),
('Cluedo', 'Jeu d’enquête où les joueurs doivent trouver l’assassin, l’arme du crime et le lieu.', 1949, 45, 30, 60, 2, 6, 10, 6, 'https://example.com/cluedo', 'https://img.example.com/cluedo.jpg'),
('Puissance 4', 'Jeu de stratégie à deux joueurs où le but est d’aligner 4 jetons de sa couleur.', 1974, 10, 5, 15, 2, 2, 6, 8, 'https://example.com/puissance4', 'https://img.example.com/puissance4.jpg'),
('La Bonne Paye', 'Jeu de gestion où les joueurs doivent gérer leurs dépenses, revenus et événements jusqu’à la fin du mois.', 1975, 60, 45, 75, 2, 6, 8, 5, 'https://example.com/bonne-paye', 'https://img.example.com/bonne-paye.jpg'),
('Mille Bornes', 'Jeu de cartes français où le but est d’atteindre 1000 kilomètres tout en empêchant ses adversaires d’avancer.', 1954, 30, 20, 45, 2, 6, 6, 7, 'https://example.com/mille-bornes', 'https://img.example.com/mille-bornes.jpg'),
('Risk', 'Jeu de stratégie militaire où les joueurs s’affrontent pour la conquête du monde par le biais de combats et de tactiques.', 1959, 120, 90, 180, 2, 6, 10, 6, 'https://example.com/risk', 'https://img.example.com/risk.jpg'),
('Les Aventuriers du Rail', 'Jeu de stratégie et de placement où les joueurs construisent des routes ferroviaires à travers l’Amérique du Nord.', 2004, 60, 45, 75, 2, 5, 8, 9, 'https://example.com/aventuriers-du-rail', 'https://img.example.com/aventuriers-du-rail.jpg'),
('Blanc Manger Coco', 'Jeu d’ambiance pour adultes basé sur l’humour noir et les associations de phrases absurdes.', 2014, 30, 20, 45, 3, 10, 16, 6, 'https://example.com/blanc-manger-coco', 'https://img.example.com/blanc-manger-coco.jpg'),
('Devine Tête', 'Jeu où chaque joueur porte une carte sur le front et doit deviner ce qu’il est en posant des questions.', 2001, 20, 15, 30, 2, 6, 7, 8, 'https://example.com/devine-tete', 'https://img.example.com/devine-tete.jpg'),
('Pictionary', 'Jeu de dessin et de devinettes en équipe où il faut faire deviner des mots ou expressions.', 1985, 60, 45, 75, 3, 6, 8, 7, 'https://example.com/pictionary', 'https://img.example.com/pictionary.jpg'),
('Trivial Pursuit', 'Jeu de culture générale où il faut répondre à des questions pour gagner des camemberts de couleur.', 1981, 75, 60, 90, 2, 6, 12, 5, 'https://example.com/trivial-pursuit', 'https://img.example.com/trivial-pursuit.jpg'),
('Qui Est-ce ?', 'Jeu à deux joueurs où chacun doit deviner le personnage de l’autre en posant des questions fermées.', 1979, 15, 10, 20, 2, 2, 6, 6, 'https://example.com/qui-est-ce', 'https://img.example.com/qui-est-ce.jpg'),
('Scrabble', 'Jeu de lettres où les joueurs forment des mots sur une grille pour marquer un maximum de points.', 1948, 60, 45, 75, 2, 4, 10, 4, 'https://example.com/scrabble', 'https://img.example.com/scrabble.jpg'),
('Docteur Maboul', 'Jeu d’adresse où il faut retirer des éléments du corps d’un patient sans toucher les bords.', 1965, 20, 15, 30, 1, 4, 6, 5, 'https://example.com/docteur-maboul', 'https://img.example.com/docteur-maboul.jpg'),
('Jenga', 'Jeu d’adresse où les joueurs retirent des blocs d’une tour sans la faire tomber.', 1983, 15, 10, 20, 2, 6, 6, 8, 'https://example.com/jenga', 'https://img.example.com/jenga.jpg'),
('Perudo', 'Jeu de bluff avec des dés, où les joueurs doivent estimer le nombre de dés de même valeur sur la table.', 1980, 30, 20, 40, 2, 6, 8, 5, 'https://example.com/perudo', 'https://img.example.com/perudo.jpg'),
('Concept', 'Jeu de devinettes basé sur des icônes. Il faut faire deviner un mot sans parler, uniquement à l’aide de symboles.', 2013, 40, 30, 50, 4, 12, 10, 4, 'https://example.com/concept', 'https://img.example.com/concept.jpg'),
('Clac Clac', 'Jeu d’observation et de rapidité avec des aimants colorés qu’il faut attraper selon des critères précis.', 2012, 15, 10, 20, 2, 6, 4, 6, 'https://example.com/clac-clac', 'https://img.example.com/clac-clac.jpg'),
('Burger Quiz', 'Jeu inspiré de l’émission TV avec des épreuves humoristiques basées sur la culture pop et la logique.', 2018, 45, 30, 60, 2, 6, 12, 5, 'https://example.com/burger-quiz', 'https://img.example.com/burger-quiz.jpg'),
('Labyrinthe', 'Jeu de stratégie et de mémoire dans un labyrinthe mouvant où il faut collecter des trésors.', 1986, 30, 20, 40, 2, 4, 8, 7, 'https://example.com/labyrinthe', 'https://img.example.com/labyrinthe.jpg'),
('Takenoko', 'Jeu de plateau où les joueurs doivent cultiver un jardin et nourrir un panda selon des objectifs précis.', 2011, 45, 30, 60, 2, 4, 8, 4, 'https://example.com/takenoko', 'https://img.example.com/takenoko.jpg'),
('Kingdomino', 'Jeu de placement de dominos où il faut construire un royaume équilibré et cohérent.', 2016, 20, 15, 30, 2, 4, 8, 6, 'https://example.com/kingdomino', 'https://img.example.com/kingdomino.jpg'),
('Sherlock Holmes Détective Conseil', 'Jeu coopératif d’enquête où les joueurs incarnent des détectives pour résoudre des affaires à Londres.', 1981, 90, 60, 120, 1, 4, 12, 3, 'https://example.com/sherlock-holmes', 'https://img.example.com/sherlock-holmes.jpg'),
('Unlock!', 'Jeu de cartes coopératif qui simule une escape room, avec des énigmes à résoudre en 60 minutes.', 2017, 60, 60, 60, 2, 6, 10, 4, 'https://example.com/unlock', 'https://img.example.com/unlock.jpg'),
('Exploding Kittens', 'Jeu de cartes rapide et chaotique où il faut éviter de piocher un chaton explosif grâce à des cartes d’action.', 2015, 15, 10, 20, 2, 5, 7, 6, 'https://example.com/exploding-kittens', 'https://img.example.com/exploding-kittens.jpg');

INSERT INTO Categorie (nom) VALUES
('Stratégie'),
('Ambiance'),
('Rapidité'),
('Mémoire'),
('Coopératif'),
('Compétitif'),
('Famille'),
('Enquête'),
('Bluff'),
('Cartes'),
('Culture générale'),
('Déduction'),
('Aventure'),
('Fantasy'),
('Science-fiction'),
('Jeu de mots'),
('Observation'),
('Adresse'),
('Gestion'),
('Placement'),
('Programmation'),
('Construction'),
('Narratif'),
('Solo'),
('Party Game'),
('Jeu classique'),
('Gestion de ressources'),
('Quiz'),
('Hasard'),
('Tactique');

INSERT INTO Contributeur (nom, type) VALUES
('Reiner Knizia', 'designer'),
('Antoine Bauza', 'designer'),
('Bruno Cathala', 'designer'),
('Richard Garfield', 'designer'),
('Klaus Teuber', 'designer'),
('Phil Walker-Harding', 'designer'),
('Donald X. Vaccarino', 'designer'),
('Uwe Rosenberg', 'designer'),
('Marc André', 'designer'),
('Serge Laget', 'designer'),
('Marie Cardouat', 'artiste'),
('Miguel Coimbra', 'artiste'),
('Naïade', 'artiste'),
('Vincent Dutrait', 'artiste'),
('Beth Sobel', 'artiste'),
('Cyril Bouquet', 'artiste'),
('Libellud', 'editeur'),
('Asmodee', 'editeur'),
('Days of Wonder', 'editeur'),
('Repos Production', 'editeur'),
('IELLO', 'editeur'),
('Gigamic', 'editeur'),
('Matagot', 'editeur'),
('Haba', 'editeur'),
('Space Cowboys', 'editeur'),
('Blue Orange', 'editeur'),
('Aurélie Demange', 'artiste'),
('Jean-Pierre Dupont', 'designer'),
('Studio H', 'editeur'),
('Ludonaute', 'editeur');

INSERT INTO Mecanique (nom) VALUES
('Gestion de main'),
('Déduction'),
('Vote'),
('Bluff'),
('Jeu par équipes'),
('Coopération'),
('Cartes à effets'),
('Lancer de dés'),
('Draft'),
('Placement de tuiles'),
('Connexion de routes'),
('Collection'),
('Jeu de rôle'),
('Mise en mémoire'),
('Observation'),
('Actions simultanées'),
('Stop ou encore'),
('Enchères'),
('Construction de réseau'),
('Optimisation'),
('Choix simultanés'),
('Jeu à objectifs secrets'),
('Construction de mots'),
('Exploration'),
('Déplacement sur plateau'),
('Tactique en temps réel'),
('Reconstitution de motifs'),
('Élimination progressive'),
('Programmation d’actions'),
('Combinaison de symboles');


INSERT INTO Jeu_Categorie (id_jeu, id_categorie) VALUES
(1, 18), (1, 23),
(2, 9), (2, 29),
(3, 5), (3, 16),
(4, 24),
(5, 3), (5, 17),
(6, 8),
(7, 7),
(8, 10), (8, 13), (8, 14),
(9, 11), (9, 19),
(10, 18), (10, 11),
(11, 28),
(12, 17), (12, 21),
(13, 12), (13, 24), (13, 13),
(14, 24), (14, 27), (14, 30),
(15, 23), (15, 26), (15, 21),
(16, 4),
(17, 4),
(18, 16), (18, 12),
(19, 9), (19, 30), (19, 2),
(20, 9), (20, 25), (20, 27),
(21, 11),
(22, 28),
(23, 9), (23, 13),
(24, 1),
(25, 19),
(26, 6), (26, 24),
(27, 9),
(28, 1), (28, 17),
(29, 2),
(30, 28), (30, 25), (30, 27);

INSERT INTO Jeu_Mecanique (id_jeu, id_mecanique) VALUES
(1, 24), (1, 9), (1, 12),
(2, 10), (2, 30),
(3, 8), (3, 4), (3, 2),
(4, 7),
(5, 4), (5, 28),
(6, 25), (6, 9), (6, 24),
(7, 11),
(8, 13),
(9, 19), (9, 28), (9, 21),
(10, 27),
(11, 9),
(12, 4), (12, 20), (12, 29),
(13, 29), (13, 10), (13, 17),
(14, 26),
(15, 3), (15, 5),
(16, 18), (16, 28), (16, 13),
(17, 6), (17, 26), (17, 19),
(18, 2), (18, 7), (18, 10),
(19, 27),
(20, 30), (20, 21), (20, 16),
(21, 11), (21, 14),
(22, 21), (22, 27),
(23, 24), (23, 6),
(24, 18),
(25, 22), (25, 3),
(26, 27), (26, 15),
(27, 3),
(28, 20),
(29, 22), (29, 18), (29, 24),
(30, 27);

INSERT INTO Jeu_Contributeur (id_jeu, id_contributeur) VALUES
(1, 14),
(2, 5),
(3, 28), (3, 1), (3, 22),
(4, 23), (4, 18), (4, 12),
(5, 4), (5, 19),
(6, 6), (6, 24), (6, 28),
(7, 9),
(8, 10), (8, 29),
(9, 23), (9, 12),
(10, 19), (10, 3),
(11, 28), (11, 7), (11, 14),
(12, 18),
(13, 18), (13, 24), (13, 29),
(14, 9), (14, 2), (14, 27),
(15, 15), (15, 11),
(16, 21), (16, 29),
(17, 6),
(18, 27), (18, 30), (18, 4),
(19, 4), (19, 25),
(20, 2),
(21, 14),
(22, 29),
(23, 30),
(24, 18),
(25, 27), (25, 10), (25, 23),
(26, 12),
(27, 6),
(28, 25), (28, 17),
(29, 28), (29, 8), (29, 30),
(30, 5), (30, 7);

INSERT INTO Avis (id_jeu, note_moyenne, note_bayesienne, nombre_evaluations, rang) VALUES
(1, 5.74, 5.62, 1923, 28),
(2, 6.77, 6.52, 842, 827),
(3, 8.95, 8.59, 2681, 861),
(4, 8.2, 7.91, 2371, 678),
(5, 5.23, 4.75, 4060, 68),
(6, 7.8, 7.63, 296, 52),
(7, 7.68, 7.57, 3936, 843),
(8, 8.22, 7.94, 3231, 408),
(9, 8.53, 8.19, 4862, 40),
(10, 5.1, 4.77, 3635, 323),
(11, 8.8, 8.58, 959, 216),
(12, 7.51, 7.3, 2628, 370),
(13, 5.34, 4.96, 2095, 673),
(14, 6.74, 6.43, 3101, 249),
(15, 8.06, 7.93, 355, 453),
(16, 9.35, 8.95, 906, 370),
(17, 8.1, 7.64, 3363, 779),
(18, 8.35, 7.95, 3976, 406),
(19, 9.39, 9.17, 3313, 864),
(20, 7.04, 6.84, 4014, 630),
(21, 7.63, 7.47, 4682, 807),
(22, 8.76, 8.52, 2900, 825),
(23, 6.29, 6.19, 2188, 111),
(24, 8.12, 7.91, 3403, 311),
(25, 7.28, 6.85, 2173, 881),
(26, 7.3, 6.86, 4590, 690),
(27, 8.71, 8.54, 2427, 639),
(28, 6.55, 6.3, 1533, 186),
(29, 8.33, 8.18, 2114, 881),
(30, 6.04, 5.63, 2230, 904);

INSERT INTO Location (id_utilisateur, id_jeu, date_location, date_retour, statut) VALUES
(18, 15, '2024-11-19', NULL, 'en cours'),
(3, 16, '2025-02-09', NULL, 'en cours'),
(6, 6, '2025-02-19', '2025-02-28', 'retournée'),
(15, 27, '2025-01-19', NULL, 'en cours'),
(9, 23, '2025-02-26', NULL, 'en cours'),
(2, 3, '2025-01-31', NULL, 'en cours'),
(16, 22, '2025-03-22', '2025-03-28', 'retournée'),
(4, 27, '2025-03-25', '2025-04-14', 'retournée'),
(20, 19, '2025-01-21', NULL, 'en cours'),
(27, 29, '2025-02-17', '2025-03-08', 'retournée'),
(22, 3, '2025-03-29', '2025-04-07', 'retournée'),
(23, 23, '2025-04-28', '2025-05-06', 'retournée'),
(13, 23, '2025-04-09', NULL, 'en cours'),
(19, 8, '2024-11-19', NULL, 'en cours'),
(16, 14, '2025-04-25', NULL, 'en cours'),
(9, 17, '2025-02-28', NULL, 'en cours'),
(10, 5, '2024-11-29', '2024-12-03', 'retournée'),
(28, 4, '2025-02-27', NULL, 'en cours'),
(19, 19, '2025-01-26', '2025-02-15', 'retournée'),
(1, 16, '2024-11-16', NULL, 'en cours'),
(27, 19, '2025-03-18', '2025-03-20', 'retournée'),
(16, 1, '2025-02-13', '2025-03-04', 'retournée'),
(10, 24, '2025-04-04', NULL, 'en cours'),
(19, 26, '2025-04-28', '2025-05-16', 'retournée'),
(13, 23, '2025-02-10', '2025-03-01', 'retournée'),
(4, 15, '2024-11-19', NULL, 'en cours'),
(17, 16, '2024-12-18', '2024-12-26', 'retournée'),
(17, 20, '2025-04-27', NULL, 'en cours'),
(13, 18, '2025-04-15', NULL, 'en cours'),
(2, 10, '2024-12-25', '2025-01-03', 'retournée');


-- VUES

CREATE VIEW jeux_disponibles AS
SELECT id_jeu, nom, stock
FROM Jeu
WHERE stock > 0;

CREATE VIEW top_jeux_notes AS
SELECT j.nom, a.note_moyenne, a.rang, j.nb_joueurs_min, j.nb_joueurs_max, j.age_min
FROM Jeu j
JOIN Avis a ON j.id_jeu = a.id_jeu
WHERE a.note_moyenne >= 8
ORDER BY a.note_moyenne DESC, a.rang ASC;

CREATE VIEW locations_en_cours AS
SELECT u.nom AS utilisateur, j.nom AS jeu, l.date_location
FROM Location l
JOIN Utilisateur u ON l.id_utilisateur = u.id_utilisateur
JOIN Jeu j ON l.id_jeu = j.id_jeu
WHERE l.statut = 'en cours';

CREATE VIEW jeux_par_categorie AS
SELECT j.nom AS jeu, c.nom AS categorie
FROM Jeu j
JOIN Jeu_Categorie jc ON j.id_jeu = jc.id_jeu
JOIN Categorie c ON jc.id_categorie = c.id_categorie
ORDER BY c.nom, j.nom;

CREATE VIEW jeux_les_plus_loues AS
SELECT j.nom AS jeu, COUNT(l.id_jeu) AS nb_locations
FROM Location l
JOIN Jeu j ON l.id_jeu = j.id_jeu
GROUP BY j.id_jeu
ORDER BY nb_locations DESC;

CREATE VIEW historique_par_client AS
SELECT u.nom AS utilisateur, j.nom AS jeu, l.date_location, l.date_retour, l.statut
FROM Location l
JOIN Utilisateur u ON l.id_utilisateur = u.id_utilisateur
JOIN Jeu j ON l.id_jeu = j.id_jeu
ORDER BY u.nom, l.date_location DESC;


-- Index

CREATE INDEX idx_location_id_jeu ON Location(id_jeu);
CREATE INDEX idx_location_id_utilisateur ON Location(id_utilisateur);
CREATE INDEX idx_jeu_stock ON Jeu(stock);
CREATE INDEX idx_avis_note ON Avis(note_moyenne);
CREATE INDEX idx_location_statut ON Location(statut);


-- Triggers

DELIMITER //

CREATE TRIGGER trg_diminuer_stock_apres_location
AFTER INSERT ON Location
FOR EACH ROW
BEGIN
    IF NEW.statut = 'en cours' THEN
        UPDATE Jeu
        SET stock = stock - 1
        WHERE id_jeu = NEW.id_jeu;
    END IF;
END;
//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_augmenter_stock_apres_retour
AFTER UPDATE ON Location
FOR EACH ROW
BEGIN
    IF OLD.statut = 'en cours' AND NEW.statut = 'retournée' THEN
        UPDATE Jeu
        SET stock = stock + 1
        WHERE id_jeu = NEW.id_jeu;
    END IF;
END;
//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_interdire_location_si_stock_nul
BEFORE INSERT ON Location
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;

    SELECT stock INTO current_stock
    FROM Jeu
    WHERE id_jeu = NEW.id_jeu;

    IF current_stock <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Impossible de louer ce jeu : stock insuffisant.';
    END IF;
END;
//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_calculer_rang_avis
BEFORE INSERT ON Avis
FOR EACH ROW
BEGIN
    DECLARE position INT;

    SELECT COUNT(*) + 1 INTO position
    FROM Avis
    WHERE note_moyenne > NEW.note_moyenne;

    SET NEW.rang = position;
END;
//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_interdire_suppression_jeu_emprunte
BEFORE DELETE ON Jeu
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM Location
        WHERE id_jeu = OLD.id_jeu AND statut = 'en cours'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Suppression impossible : le jeu est encore loué.';
    END IF;
END;
//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_auto_date_retour
BEFORE UPDATE ON Location
FOR EACH ROW
BEGIN
    IF NEW.statut = 'retournée' AND NEW.date_retour IS NULL THEN
        SET NEW.date_retour = CURDATE();
    END IF;
END;
//

DELIMITER ;


-- Procédures

DELIMITER //
CREATE PROCEDURE louer_jeu(IN p_id_utilisateur INT, IN p_id_jeu INT)
BEGIN
    DECLARE stock_dispo INT;

    SELECT stock INTO stock_dispo FROM Jeu WHERE id_jeu = p_id_jeu;

    IF stock_dispo <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuffisant.';
    ELSE
        INSERT INTO Location (id_utilisateur, id_jeu, date_location, statut)
        VALUES (p_id_utilisateur, p_id_jeu, CURDATE(), 'en cours');
    END IF;
END;
//
DELIMITER ;

CALL louer_jeu(5, 12);  -- L'utilisateur 5 loue le jeu 12



DELIMITER //
CREATE PROCEDURE retourner_jeu(IN p_id_location INT)
BEGIN
    DECLARE statut_actuel VARCHAR(20);

    SELECT statut INTO statut_actuel FROM Location WHERE id_location = p_id_location;

    IF statut_actuel = 'retournée' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Déjà retourné.';
    ELSE
        UPDATE Location SET statut = 'retournée' WHERE id_location = p_id_location;
    END IF;
END;
//
DELIMITER ;

CALL retourner_jeu(27);  -- Retour de la location n°27



DELIMITER //
CREATE PROCEDURE ajouter_avis(
    IN p_id_jeu INT,
    IN p_note_moyenne FLOAT,
    IN p_note_bayesienne FLOAT,
    IN p_nb_eval INT
)
BEGIN
    INSERT INTO Avis (id_jeu, note_moyenne, note_bayesienne, nombre_evaluations, rang)
    VALUES (p_id_jeu, p_note_moyenne, p_note_bayesienne, p_nb_eval, NULL);
END;
//
DELIMITER ;

CALL ajouter_avis(8, 8.4, 8.1, 1150);  -- Avis sur le jeu 8 avec 1150 évaluations



DELIMITER //

CREATE PROCEDURE lister_jeux_disponibles()
BEGIN
    SELECT id_jeu, nom, stock
    FROM Jeu
    WHERE stock > 0;
END;
//

CALL lister_jeux_disponibles();  -- Affiche tous les jeux en stock


DELIMITER ;

CALL louer_jeu(5, 12);


-- Fonctions stockées : 

DELIMITER //
CREATE FUNCTION verifier_disponibilite(p_id_jeu INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE dispo BOOLEAN;
    SELECT stock > 0 INTO dispo FROM Jeu WHERE id_jeu = p_id_jeu;
    RETURN dispo;
END;
//
DELIMITER ;

SELECT verifier_disponibilite(12);  -- Renvoie 1 si le jeu 12 est disponible, sinon 0


DELIMITER //
CREATE FUNCTION get_note_moyenne(p_id_jeu INT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE note FLOAT;
    SELECT note_moyenne INTO note FROM Avis WHERE id_jeu = p_id_jeu;
    RETURN note;
END;
//
DELIMITER ;

SELECT get_note_moyenne(8);  -- Affiche la note moyenne du jeu 8



DELIMITER //
CREATE FUNCTION nb_locations_utilisateur(p_id_utilisateur INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE nb INT;
    SELECT COUNT(*) INTO nb FROM Location WHERE id_utilisateur = p_id_utilisateur;
    RETURN nb;
END;
//
DELIMITER ;

SELECT nb_locations_utilisateur(5);  -- Nombre de jeux empruntés par l’utilisateur 5


DELIMITER //
CREATE PROCEDURE creer_utilisateur(IN p_nom VARCHAR(100), IN p_mdp VARCHAR(255), IN p_email VARCHAR(100))
BEGIN
    INSERT INTO Utilisateur(nom, mot_de_passe, email, role)
    VALUES (p_nom, p_mdp, p_email, 'user');
END;
//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE ajouter_jeu(
    IN p_nom VARCHAR(255),
    IN p_description VARCHAR(255),
    IN p_annee INT,
    IN p_jmin INT,
    IN p_jmax INT,
    IN p_age INT,
    IN p_stock INT
)
BEGIN
    INSERT INTO Jeu(nom, description_jeu, annee_publication, nb_joueurs_min, nb_joueurs_max, age_min, stock)
    VALUES (p_nom, p_description, p_annee, p_jmin, p_jmax, p_age, p_stock);
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE modifier_jeu(
    IN p_id INT,
    IN p_nom VARCHAR(255),
    IN p_description VARCHAR(255),
    IN p_annee INT,
    IN p_jmin INT,
    IN p_jmax INT,
    IN p_age INT,
    IN p_stock INT
)
BEGIN
    UPDATE Jeu
    SET nom = p_nom,
        description_jeu = p_description,
        annee_publication = p_annee,
        nb_joueurs_min = p_jmin,
        nb_joueurs_max = p_jmax,
        age_min = p_age,
        stock = p_stock
    WHERE id_jeu = p_id;
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE supprimer_jeu(IN p_id INT)
BEGIN
    DELETE FROM Jeu
    WHERE id_jeu = p_id;
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE modifier_stock(IN p_id INT, IN p_nouveau_stock INT)
BEGIN
    UPDATE Jeu
    SET stock = p_nouveau_stock
    WHERE id_jeu = p_id;
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE voir_locations_admin()
BEGIN
    SELECT l.id_location, u.nom AS utilisateur, j.nom AS jeu, l.date_location, l.date_retour, l.statut
    FROM Location l
    JOIN Utilisateur u ON l.id_utilisateur = u.id_utilisateur
    JOIN Jeu j ON l.id_jeu = j.id_jeu
    ORDER BY l.date_location DESC;
END;
//
DELIMITER ;









