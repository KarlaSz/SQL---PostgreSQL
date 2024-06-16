CREATE OR REPLACE FUNCTION get_product_info
	(p_product_id INT, OUT p_product_name TEXT, OUT p_quantity TEXT) AS
	$$
	BEGIN
	--jesli chcemy zeby jakis parametr cos zwrocil to musimy cos do tego parametru przypisac
	--do przypisywania wartosci do zmiennej np. tutaj do parametru wyjsciowego mozna uzywac = lub :
		
		--I sposob
		--p_product_name := (SELECT name FROM product WHERE product_id=p_product_id);
		--p_quantity := (SELECT quantity FROM product WHERE product_id=p_product_id);
		
		--II sposob
		--SELECT name INTO p_product_name FROM product WHERE product_id=p_product_id;
		--SELECT quantity INTO p_quantity FROM product WHERE product_id=p_product_id;
		
		--III sposob
		SELECT name,quantity INTO p_product_name, p_quantity
		FROM product WHERE product_id=p_product_id;
		RETURN;
	END;
	$$ LANGUAGE PLPGSQL
	
SELECT * FROM get_product_info(1);



--funkcja dla wyswietlania wszystkich produktow, wiec nie ma argumentow okreslonych do zawezania
CREATE OR REPLACE FUNCTION get_product_info2()
	RETURNS TABLE(p_product_name char varying(100), p_quantity SMALLINT) AS
	$$
	BEGIN
	--zwracanie wszystko to co zwraca zapytanie
		RETURN QUERY SELECT name, quantity FROM product;
	END;
	$$ LANGUAGE PLPGSQL;
	
SELECT * FROM get_product_info2();

SELECT * FROM product;

DROP ROUTINE IF EXISTS get_product_info2


--quantity na int, nie okreslac typow w jawny sposob i dac namiar na kolumne ktora jest w tym smym
--typie %TYPE
CREATE OR REPLACE FUNCTION get_product_info2()
	RETURNS TABLE(p_product_name product.name%TYPE, p_quantity product.quantity%TYPE) AS
	$$
	BEGIN
	--zwracanie wszystko to co zwraca zapytanie
		RETURN QUERY SELECT name, quantity FROM product;
	END;
	$$ LANGUAGE PLPGSQL;
	
SELECT * FROM get_product_info2();

--zwracanie funkcji inny sposob
CREATE OR REPLACE FUNCTION get_product_cheaper_then(p_price product.price%TYPE)
--wynikiem tej funkcji ma byc zbior rekordow pasujacych do tabeli product
RETURNS SETOF product AS
	$$
	BEGIN
		RETURN QUERY SELECT * FROM product WHERE price < p_price;
	END;
	$$ LANGUAGE PLPGSQL;
	
SELECT * FROM get_product_cheaper_then(600)