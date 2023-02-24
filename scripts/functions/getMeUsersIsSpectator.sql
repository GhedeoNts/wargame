CREATE OR REPLACE FUNCTION GET_USER_IF_SPECTATOR() 
RETURNS SETOF UTILISATEUR AS 
	$FUNCTION$ DECLARE
	-- result of the query 
	rq utilisateur;
	BEGIN FOR rq IN
	SELECT
	    users.utilisateur_id AS userid,
	    users.surnom,
	    -- users.email,
	    CASE
	        WHEN users.utilisateur_id = spectateur.utilisateur_id THEN TRUE
	        ELSE FALSE
	    END AS is_spectator
	FROM utilisateur AS users
	    LEFT OUTER JOIN spectateur ON users.utilisateur_id = spectateur.utilisateur_id
	ORDER BY userid
	LOOP
	RETURN NEXT rq;
	END LOOP;
	RETURN;
	END 
$ 

FUNCTION$ LANGUAGE PLPGSQL;

SELECT get_user_if_spectator();