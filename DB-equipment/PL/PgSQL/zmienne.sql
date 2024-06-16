CREATE OR REPLACE FUNCTION good_varranty (OUT p_name VARCHAR(255), OUT p_length_days INT)
RETURNS SETOF RECORD AS
$$
--jak pracuje ze zmiennymi to pisze DECLARE zamiast BEGIN
DECLARE
	avg_length INT;
--dopiero pozniej uzywam BEGIN do dzialania kodu
BEGIN
	SELECT AVG(end_date - start_date) INTO avg_length FROM varranty;
	RAISE NOTICE 'Average duration %', avg_length;
	RETURN QUERY SELECT p.name, v.end_date - v.start_date
	FROM varranty v
	JOIN product p ON v.product_id = p.product_id
	WHERE 
		(v.end_date - v.start_date) >=avg_length;
END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM good_varranty();

--II sposob
CREATE OR REPLACE FUNCTION good_varranty2 (IN INT, OUT p_name VARCHAR(255), OUT p_length_days INT)
RETURNS SETOF RECORD AS
$$
DECLARE
	--$1 odnosi sie do pierwszego parametru i nie trzego go tam pisac,pozniej w kodzie tylko go wspominam
	min_length ALIAS FOR $1;
	avg_length INT;
BEGIN
	SELECT AVG(end_date - start_date) INTO avg_length FROM varranty;
	RAISE NOTICE 'Average duration %', avg_length;
	RETURN QUERY SELECT p.name, v.end_date - v.start_date
	FROM varranty v
	JOIN product p ON v.product_id = p.product_id
	WHERE 
		(v.end_date - v.start_date) >=avg_length
		AND (v.end_date - v.start_date) >= min_length;
END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM good_varranty2(10)
							 
--III
CREATE OR REPLACE FUNCTION export_owners(IN p_onwer_id INT, OUT line TEXT) AS
$$
DECLARE
--zwartosc calej zmiennej rekordu, zmienna row, a typ zgodny z tabela owner i zawiera 3 kolumny
	row owner%ROWTYPE;						 
BEGIN
    --select 0 zamiast id usera bo jest tajne jak pesel, takie zabezpieczenie
	SELECT 0, UPPER(last_name), first_name INTO row FROM owner WHERE owner_id = p_onwer_id;
	--jesli zwracamy wartosc poprzez parametr OUT to nalezy do tego parametru wprowadzic wynnik
	--tego wyrazenia
	line := row.owner_id || ',' || row.last_name || ',' || row.first_name;
END;
$$ LANGUAGE PLPGSQL;
			
SELECT export_owners(1);
SELECT export_owners(2);