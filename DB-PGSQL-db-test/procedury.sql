--$$ zaczynaja i koncza blok definicji funkcji
--trzeba okreslic jezyk procedury

CREATE OR REPLACE FUNCTION add_numbers(a INTEGER, b INTEGER)
RETURNS INTEGER AS $$
BEGIN
	RETURN a + b;
END;
$$ LANGUAGE plpgsql;

--wywolanie funkcji/procedury
SELECT add_numbers(4,3)

--definiowanie lokalnych zmienych za pomoca DECLARE, zmienna result o typue INT
CREATE OR REPLACE FUNCTION multiply_numbers(a INTEGER = 1, b INTEGER = 2)
RETURNS INTEGER AS $$
DECLARE 
	result INTEGER;
BEGIN
	result := a * b;
	RETURN result;
END;
$$ LANGUAGE plpgsql

SELECT multiply_numbers(); --wezmie wtedy domyslne wartosci
SELECT multiply_numbers(2,5);

--dodawanie rekordow do tabeli za pomoca procedury

--void  dodajemy rekordy,ale i w praktyce nic nie zwracamy. bede pusty row ale dodany do tabeli. void funkcja nie ma typu zwracanego (czyli nie zwraca żadnego wyniku).
--void w PostgreSQL, gdy tworzysz funkcję, która wykonuje pewne operacje, ale nie musi zwracać wyniku do wywołującego. 
-- przypisanie do zmiennych czegos :=
--zmienia typu na zapomoca konwersji ::integer
CREATE OR REPLACE FUNCTION add_car(brand VARCHAR, model VARCHAR)
RETURNS VOID AS $$
DECLARE 
	top_speed INTEGER := (100 + floor(random() * 151))::integer;
BEGIN
	INSERT INTO cars (brand, model,top_speed) VALUES (brand, model, top_speed);
END;
$$ LANGUAGE plpgsql;

ROLLBACK; --zeby anulowac bieżącą transakcję i wyjść z trybu transakcyjnego gdy wali error

SELECT add_car('Toyota', 'Corolla')

--procedurya zwracajaca dane za pomoca OUT czyli parametr wyjsciowy

--IN: Parametr wejściowy, który przekazuje wartość do procedury. Wartość tego parametru może być używana wewnątrz procedury, ale jego zmiana nie jest zwracana na zewnątrz.

--OUT: Parametr wyjściowy, który służy do zwrócenia wartości na zewnątrz z procedury. Parametr OUT nie przekazuje żadnej wartości wejściowej; jest pusty w momencie wywołania procedury, a jego wartość jest nadawana wewnątrz procedury i zwracana do wywołującego.

--Parametry OUT są szczególnie przydatne, gdy chcesz, aby procedura zwracała więcej niż jedną wartość lub chcesz zmodyfikować przekazane parametry i zwrócić zmodyfikowane wartości

--INOUT: Parametr, który działa zarówno jako wejściowy, jak i wyjściowy. Przekazuje wartość do procedury, a zmodyfikowana wartość jest zwracana na zewnątrz.
CREATE OR REPLACE FUNCTION get_speed_stats(OUT min_top_speed NUMERIC, OUT max_top_speed NUMERIC, 
										  OUT avg_top_speed NUMERIC)
AS $$
BEGIN
	SELECT INTO min_top_speed, max_top_speed, avg_top_speed
	MIN(top_speed), MAX(top_speed), AVG(top_speed)
	FROM cars;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_speed_stats();

--procedura zwracania calej tabeli
CREATE OR REPLACE FUNCTION get_speed_stats2()
RETURNS TABLE(min_top_speed NUMERIC, max_top_speed NUMERIC,avg_top_speed NUMERIC) AS $$
BEGIN
	RETURN QUERY
	SELECT
	MIN(top_speed), MAX(top_speed), AVG(top_speed)
	FROM cars;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_speed_stats2();

--procedura zwracajaca laczone dane CONCAT
CREATE OR REPLACE FUNCTION get_car_complete_name()
RETURNS TABLE(car_id INT, car_brand_model TEXT) AS $$
BEGIN
	RETURN QUERY
	SELECT id, CONCAT( brand, ' ', model )
	FROM cars;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_car_complete_name();

--procedura z IF oraz lokalna zmienna
CREATE OR REPLACE FUNCTION add_car_and_driver(car_brand VARCHAR, car_model VARCHAR, driver_name VARCHAR)
RETURNS VOID AS $$
DECLARE 
	driver_id INTEGER;
BEGIN
	SELECT id INTO driver_id FROM drivers WHERE name = driver_name;
	
	IF driver_id IS NULL THEN
		INSERT INTO drivers (name) VALUES (driver_name) RETURNING id INTO driver_id;
		END IF;
	INSERT INTO cars(brand, model, driver_id) VALUEs (car_brand, car_model, driver_id);
END;
$$ LANGUAGE plpgsql;

SELECT * FROM add_car_and_driver('Mazda', 'Mita', 'Tom');

--procedura z JOIN, zwraca wszystkie auta przypisane do wlasciciela drivera
CREATE OR REPLACE FUNCTION get_cars_by_driver(driver_name VARCHAR)
RETURNS TABLE(id INTEGER, brand VARCHAR, model VARCHAR) AS $$
BEGIN
	RETURN QUERY
	SELECT c.id, c.brand, c.model
	FROM cars c
	JOIN drivers d ON c.driver_id = d.id
	WHERE d.name = driver_name;
 END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_cars_by_driver('Kasia')

--procedura z losowym elementem z tabeli
CREATE OR REPLACE FUNCTION get_random_car_driver()
RETURNS TABLE(driver_id INT, driver_name VARCHAR) AS $$
DECLARE
	driver_ids INT[];
	random_driver_id INT;
BEGIN
	SELECT ARRAY( SELECT id FROM drivers) INTO driver_ids;
	
	random_driver_id := floor(random() * array_length(driver_ids, 1) + 1)::int;
	
	RETURN QUERY SELECT id as driver_id, name as driver_name FROm drivers
	WHERE id = driver_ids[random_driver_id];
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_random_car_driver();

--procedura CASE
CREATE OR REPLACE FUNCTION get_car_type()
RETURNS TABLE(car_id INT, car_brand_model TEXT, car_type TEXT) AS $$
BEGIN
	RETURN QUERY SELECT id, CONCAT(brand, ' ', model), 
	CASE
		WHEN model = 'Viper' THEN 'sports car'
		WHEN model = 'Ram' THEN 'truck'
		WHEN model = 'w140' THEN 'family car'
		ELSE 'unknown car'
	END
	FROM cars;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_car_type()

--procedura IF ELSEIF

