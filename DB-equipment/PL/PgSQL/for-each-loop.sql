--przetwazanie danych w petli
CREATE OR REPLACE FUNCTION export_owners(OUT id INT, OUT line TEXT)
RETURNS SETOF RECORD AS $$
DECLARE
	row owner%ROWTYPE;					 
BEGIN
--dla kazdego wiersza zwracanego przez to zapytanie rob cos dalej...
--to jedno duze wyrazenie z loop bo nie ma srednikow
    FOR row IN SELECT owner_id, UPPER(last_name), first_name FROM owner
	LOOP
		id := row.owner_id;
		line := row.last_name || ',' || row.first_name;
		RETURN NEXT;
		--kazde z polecenien w petli loop konczymy srednikiem
	END LOOP;
	RETURN;
	--return informuje funkcje,ze to koniec i wiecej wartosci nie bedzie dodawanych do setof record
END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM export_owners();


--tworzenie usera
CREATE USER backup LOGIN PASSWORD 'ChangeMe';

SET ROLE backup;
SELECT * FROM product;
SELECT CURRENT_USER;
RESET ROLE;

--nadawanie uprawnien userowi
CREATE OR REPLACE FUNCTION grant_all_schemas(IN p_user_name TEXT) RETURNS void AS
$$
DECLARE
	sch TEXT;
BEGIN
	--zapytanie ktore wyciage nazwe ze schematu pg
	FOR sch IN SELECT nspname
		FROM pg_namespace
		WHERE nspname != 'pg_toast' AND nspname != 'pg_temp_1' AND nspname != 'pg_toast_temp_1'
		AND nspname != 'pg_statistic' AND nspname != 'pg_catalog' AND nspname != 'information_schema'
	LOOP
		EXECUTE format('GRANT USAGE ON SCHEMA %I to %I', sch, p_user_name);
		EXECUTE format('GRANT SELECT ON ALL SEQUENCES IN SCHEMA %I to %I', sch, p_user_name);
		EXECUTE format('GRANT SELECT ON ALL TABLES IN SCHEMA %I to %I', sch, p_user_name);
		EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT SELECT ON TABLES TO %I', sch, p_user_name);
		EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT SELECT ON SEQUENCES TO %I', sch, p_user_name);

	END LOOP;
	RETURN;
END;
$$ LANGUAGE PLPGSQL;

SELECT grant_all_schemas('backup');