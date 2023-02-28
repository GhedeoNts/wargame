# Store the wargame
<br/>

![img](img/belgium-wargame.png)

<br/>

### Créer functions et procédures pour prendre en compte les évolutions demandées.

## Ressource(s)
<br/>
<a href='https://docs.postgresql.fr/12/sql-createprocedure.html'>
<img src='img/hdr_left.png'/>
</a>
<br/>

## Contexte du projet
<p>
Une association de fans de wargame vétérans (jeu de figurine) vous demande de modifier leur application qui permet de détenir une trace des différentes armées des joueurs. Elle permet également de voir quels joueurs ont accumulé le plus de victoires.

L'application est un peu datée, il s'agit d'un front desktop en java Swing qui a connu des jours meilleurs et doit dater de la toute  fin des années 90 lorsque l'association a été créée. L'application consomme directement une base de données installée sur un serveur dans le local à café. Vous avez accès à cette base de données apparemment plus récente, installée par un proche d'un membre de l'association.

L'application desktop sera modifiée par le neveu d'un membre. Le public n'étant pas tout jeune, il s'oppose à une refonte ou une modernisation de l'application.

Le neveu demande trois nouvelles fonctionnalités.
</p>
<ul>
<li>
créer une fonction qui donne directement les utilisateurs en ajoutant un boolean s'ils sont spectateurs

<br>

```SQL
## Solution I
-- I/. créer une fonction qui donne directement les utilisateurs en ajoutant un boolean s 'ils sont spectateurs

-- FUNCTION QUI AFFICHE M'ENSEMBLE DES UTILISATEURS ET AJOUT UN BOOLEAN SI UN UTILISATEUR EST SPECTATEUR
-- FAIRE ATTENTION AVEC LE SYMBOLE DOLLARD OU LES COMMENTAIRES DANS LE SCRIPT EVANTUEL ERROR LORS DE L'IMPLÉMENTATION DU SCRIPT DANS PGADMIN
CREATE OR REPLACE VIEW GETUSERS AS 
	SELECT
	    users.utilisateur_id AS userid,
	    users.surnom,
	    users.email,
	    CASE
	        WHEN users.utilisateur_id = spectateur.utilisateur_id THEN TRUE
	        ELSE FALSE
	    END AS is_spectator
	FROM utilisateur AS users
	    LEFT JOIN spectateur ON users.utilisateur_id = spectateur.utilisateur_id
	ORDER BY
USERID; 

CREATE OR REPLACE FUNCTION GETUSERSPECTATOR() RETURNS 
SETOF GETUSERS AS 
$$ 
BEGIN RETURN QUERY SELECT * FROM GetUsers;

END 
$$ LANGUAGE PLPGSQL;

SELECT * FROM GETUSERSPECTATOR();
```
</li>
<li>
permettre d'afficher directement une armée et les types d'unité qui la compose, avec la possibilité de faire des tris dessus (etc...)
<br>

```SQL
## Solution II
-- II/. permettre d 'afficher directement une armée et les types d' unité qui la compose, avec la possibilité de faire des tris dessus (etc...)

-- CRÉATION D'UNE PROCEDURE QUI PERMET D'AFFICHER UNE ARMÉE ET LES TYPES D'UNITÉS QUI LA COMPOSE AVEC POSSIBILITÉ DE FAIRE DES TRIES DESSUS

-- CRÉATION D'UNE VIEW

-- CRÉATION D'UNE VIEW QUI A POUR RÔLE D'EFFECTUE UNE JOINTURE ENTRE LES TABLES ARMEE ET TYPE_UNITE

CREATE OR REPLACE VIEW GETARMYANDGUYS AS 
	SELECT
	    army.armee_id AS army_id,
	    nation.libelle AS libelle_nationality,
	    nation.description AS description_nationality,
	    type_unite.nom_type AS type_unite_name,
	    epoque.nom AS epoque_name
	FROM armee AS army
	    INNER JOIN nation ON army.armee_id = nation.nation_id
	    INNER JOIN type_unite ON army.armee_id = type_unite.type_unite_id
	    INNER JOIN epoque ON army.armee_id = epoque.epoque_id
	ORDER BY
ARMY_ID; 

-- CRÉATION D'UNE FONCTION QUI EXÉCUTE UNE REQUÊTE DE TYPE SELECT POUR IMPLÉMENTER LA VIEW CRÉE PRÉCÉDEMMENT

CREATE OR REPLACE FUNCTION GETVIEWARMYCOMPOSE() RETURNS 
SETOF GETARMYANDGUYS LANGUAGE PLPGSQL AS 
	$$ BEGIN RETURN QUERY SELECT * FROM GetArmyAndGuys;
	END 
$$;

SELECT * FROM GETVIEWARMYCOMPOSE();

```
</li>
<li>
lorsqu'un utilisateur quitte l'association, supprimer ses données mais insérer son surnom et son nombre de victoires dans la table des victoires.

<br>

```SQL
## Solution III
CREATE OR REPLACE VIEW GET_ONLY_USERS AS 
	SELECT
	    USERS.UTILISATEUR_ID AS USERS_ID,
	    USERS.SURNOM AS NICKNAME,
	    JOUEUR.VICTOIRES AS TOTAL_VICTORY
	FROM UTILISATEUR AS USERS
	    INNER JOIN JOUEUR ON USERS.UTILISATEUR_ID = JOUEUR.UTILISATEUR_ID; 

CREATE OR REPLACE FUNCTION UPDATE_GET_ONLY_USERS() 
RETURNS TRIGGER AS 
	$$ BEGIN IF (TG_OP = 'DELETE') THEN
	DELETE FROM
	    PUBLIC.UTILISATEUR
	WHERE SURNOM = OLD.SURNOM;
	IF NOT FOUND THEN RETURN NULL;
	END IF;
	OLD.DATE_DEPART = NOW();
	OLD.NOMBRE_VICTOIRES = TOTAL_VICTORY;
	OLD.SURNOM = NICKNAME;
	INSERT INTO
	    HALL_OF_FAME
	VALUES (
	        OLD.SURNOM,
	        OLD.DATE_DEPART,
	        OLD.NOMBRE_VICTOIRES
	    );
	RETURN OLD;
	ELSEIF(TG_OP = 'UPDATE') THEN
	UPDATE UTILISATEUR
	SET SURNOM = NEW.SURNOM
	WHERE SURNOM = OLD.SURNOM;
	IF NOT FOUND THEN RETURN NULL;
	END IF;
	NEW.DATE_DEPART = NOW();
	NEW.NOMBRE_VICTOIRES = TOTAL_VICTOIRY;
	NEW.SURNOM = OLD.SURNOM;
	INSERT INTO
	    HALL_OF_FAME
	VALUES (
	        NEW.SURNOM,
	        NEW.DATE_DEPART,
	        NEW.NOMBRE_VICTOIRES
	    );
	RETURN NEW;
	ELSEIF (TG_OP = 'INSERT') THEN
	INSERT INTO
	    UTILISATEUR
	VALUES
	(
	        NEW.UTILISATEUR_ID,
	        NEW.SURNOM,
	        NEW.EMAIL,
	        NEW.MOT_DE_PASSE
	    );
	NEW.DATE_DEPART = NOW();
	INSERT INTO
	    HALL_OF_FAME
	VALUES
	(
	        NEW.SURNOM,
	        NEW.DATE_DEPART,
	        NEW.NOMBRE_VICTOIRES
	    );
	RETURN NEW;
	END IF;
END; 

$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER HALL_OF_FAME 
	INSTEAD OF
	INSERT OR
	UPDATE OR
	DELETE
	    ON GET_ONLY_USERS FOR EACH ROW
	EXECUTE
	    FUNCTION UPDATE_GET_ONLY_USERS();


```
</li>
</ul>

## Modalités pédagogiques
<p>
individuel
</p>

## Critères de performance
<p>
Les inputs sont controlés, des exceptions sont renvoyées en cas d'erreur.
</p>

## Modalités d'évaluation
<p>
Code SQL
</p>

## Livrables
<p>
code sql + résultats
</p>
 