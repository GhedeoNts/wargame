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