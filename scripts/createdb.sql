CREATE TABLE
    Utilisateur(
        utilisateur_id SERIAL,
        surnom VARCHAR(50) NOT NULL,
        email VARCHAR(50) NOT NULL,
        mot_de_passe VARCHAR(50) NOT NULL,
        PRIMARY KEY(utilisateur_id)
    );

CREATE TABLE
    Joueur(
        utilisateur_id INTEGER,
        victoires SMALLINT,
        nombre_matchs SMALLINT NOT NULL,
        PRIMARY KEY(utilisateur_id),
        FOREIGN KEY(utilisateur_id) REFERENCES Utilisateur(utilisateur_id) ON DELETE CASCADE
    );

CREATE TABLE
    Spectateur(
        utilisateur_id INTEGER,
        PRIMARY KEY(utilisateur_id),
        FOREIGN KEY(utilisateur_id) REFERENCES Utilisateur(utilisateur_id) ON DELETE CASCADE
    );

CREATE TABLE
    Token(
        code VARCHAR(50),
        utilisateur_id INTEGER NOT NULL,
        PRIMARY KEY(code),
        FOREIGN KEY(utilisateur_id) REFERENCES Utilisateur(utilisateur_id) ON DELETE CASCADE
    );

CREATE TABLE
    Epoque(
        epoque_id SERIAL,
        nom VARCHAR(50),
        PRIMARY KEY(epoque_id)
    );

CREATE TABLE
    Type_unite(
        type_unite_id SERIAL,
        nom_type VARCHAR(50) NOT NULL,
        PRIMARY KEY(type_unite_id)
    );

CREATE TABLE
    Nation(
        nation_id SERIAL,
        libelle VARCHAR(50),
        description VARCHAR(50),
        epoque_id INTEGER NOT NULL,
        PRIMARY KEY(nation_id),
        FOREIGN KEY(epoque_id) REFERENCES Epoque(epoque_id)
    );

CREATE TABLE
    armee(
        armee_id SERIAL,
        nation_id INTEGER NOT NULL,
        utilisateur_id INTEGER NOT NULL,
        PRIMARY KEY(armee_id),
        FOREIGN KEY(nation_id) REFERENCES Nation(nation_id),
        FOREIGN KEY(utilisateur_id) REFERENCES Joueur(utilisateur_id) ON DELETE CASCADE
    );

CREATE TABLE
    comprendre(
        armee_id INTEGER,
        type_unite_id INTEGER,
        PRIMARY KEY(armee_id, type_unite_id),
        FOREIGN KEY(armee_id) REFERENCES armee(armee_id) on delete cascade,
        FOREIGN KEY(type_unite_id) REFERENCES Type_unite(type_unite_id)
    );

CREATE TABLE
    suivre(
        utilisateur_id INTEGER,
        utilisateur_id_1 INTEGER,
        PRIMARY KEY(
            utilisateur_id,
            utilisateur_id_1
        ),
        FOREIGN KEY(utilisateur_id) REFERENCES Joueur(utilisateur_id) ON DELETE CASCADE,
        FOREIGN KEY(utilisateur_id_1) REFERENCES Spectateur(utilisateur_id) ON DELETE CASCADE
    );

-- Insertion des données de test

CREATE TABLE
    hall_of_fame (
        id SERIAL NOT NULL,
        surnom VARCHAR(50) NOt NULL,
        date_depart DATE NOT NULL,
        nombre_victoires SMALLINT NOT NULL,
        PRIMARY KEY(id)
    );

-- Utilisateurs

INSERT INTO
    Utilisateur (surnom, email, mot_de_passe)
VALUES (
        'JohnDoe',
        'johndoe@gmail.com',
        'password123'
    ), (
        'JaneDoe',
        'janedoe@yahoo.com',
        'pass1234'
    ), (
        'AliceWonderland',
        'alice.wonderland@hotmail.com',
        'alicepassword'
    ), (
        'BobSmith',
        'bob.smith@outlook.com',
        'bob123'
    ), (
        'EveJackson',
        'eve.jackson@gmail.com',
        'evepassword'
    );

-- Joueurs

INSERT INTO
    Joueur (
        utilisateur_id,
        victoires,
        nombre_matchs
    )
VALUES (1, 12, 25), (2, 8, 18), (5, 2, 5);

-- Spectateurs

INSERT INTO Spectateur (utilisateur_id) VALUES (3), (4);

-- Tokens

INSERT INTO
    Token (code, utilisateur_id)
VALUES ('abcd1234', 1), ('efgh5678', 2), ('ijkl9012', 3), ('mnop3456', 4), ('qrst7890', 5);

-- Époques

INSERT INTO Epoque (nom)
VALUES ('Antiquité'), ('Moyen-Âge'), ('Renaissance');

-- Types d'unités

INSERT INTO
    Type_unite (nom_type)
VALUES ('Infanterie'), ('Cavalerie'), ('Artillerie');

-- Nations

INSERT INTO
    Nation (
        libelle,
        description,
        epoque_id
    )
VALUES (
        'Rome',
        'Puissante civilisation méditerranéenne',
        1
    ), (
        'France',
        'Royaume européen du Moyen-Âge',
        2
    ), (
        'Espagne',
        'Empire colonial ibérique',
        3
    );

-- Armées

INSERT INTO
    armee (nation_id, utilisateur_id)
VALUES (1, 1), (2, 2), (3, 5);

-- Comprendre

INSERT INTO
    comprendre (armee_id, type_unite_id)
VALUES (1, 1), (1, 2), (2, 1), (2, 3), (3, 2), (3, 3);

-- Suivre

INSERT INTO
    suivre (
        utilisateur_id,
        utilisateur_id_1
    )
VALUES (1, 3), (2, 4);