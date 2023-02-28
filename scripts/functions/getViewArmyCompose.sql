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