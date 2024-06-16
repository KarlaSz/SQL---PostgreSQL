CREATE OR REPLACE FUNCTION get_mean_price() RETURNS NUMERIC
AS
$$
--poczatek i koniec kodu, to nie to samo begin i end co w transakcjach
	BEGIN
		RETURN AVG(price) FROM product;
	END
$$ LANGUAGE PLPGSQL;


--wywowalnie funkcji
SELECT get_mean_price()

DROP FUNCTION get_mean_price()

--

CREATE OR REPLACE PROCEDURE get_mean_price(OUT p_mean NUMERIC)
AS
$$
	BEGIN
		SELECT AVG(price) INTO p_mean FROM product;
	END
$$ LANGUAGE PLPGSQL;


--wywowalnie procedury
CALL get_mean_price(NULL);

DROP PROCEDURE get_mean_price();

--uniwersalne polecenie ktora usuwa funkcje i procedury
DROP ROUTINE IF EXISTS get_mean_price();


CREATE OR REPLACE FUNCTION get_mean_price() RETURNS NUMERIC
AS
$$
	BEGIN
		--dodatkowe komunikaty dla usera , widoczne jest w messages. w miejsce % ma sie pojawic
		--wartosc okreslona po przecinku czyli current_time
		RAISE NOTICE 'Before query execution %', CURRENT_TIME;
		RETURN AVG(price) FROM product;
		RAISE NOTICE 'Before query execution %', CURRENT_TIME;
	END
$$ LANGUAGE PLPGSQL;

SELECT get_mean_price();
