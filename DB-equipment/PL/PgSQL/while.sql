--petle po tablicy, iterowanie po tablicy 
--funckja liczbyw artosc wybranych produktow
CREATE OR REPLACE FUNCTION get_value_multi(p_ids INT[]) RETURNS NUMERIC AS
$$
DECLARE
	sum_temp NUMERIC=0;
	value_temp NUMERIC;
	id INT;
BEGIN
	FOREACH id IN ARRAY p_ids
	LOOP
		SELECT price*quantity INTO value_temp FROM product WHERE product_id=id;
		sum_temp := sum_temp + value_temp;
	END LOOP;
	RETURN sum_temp;
END
$$ LANGUAGE PLPGSQL

SELECT * FROM product;
UPDATE product SET price = 500 WHERE product_id = 2;
UPDATE product SET price = 800 WHERE product_id = 3;

SELECT get_value_multi(ARRAY[1,3,2])

--generowanie przykladowych rekordow w pewnej tabeli
CREATE OR REPLACE FUNCTION fn_generate_test_records(p_num_rec INT DEFAULT 1) RETURNS INT AS
$$
DECLARE
	counter INT = 1;
BEGIN
	LOOP
		INSERT INTO test(id) VALUES (counter);
		counter := counter +1;
		EXIT WHEN counter > p_num_rec;
	END LOOP;
	RETURN COUNT(*) FROM test;
END
$$ LANGUAGE PLPGSQL;

DROP TABLE IF EXISTS test;
CREATE TABLE IF NOT EXISTS test(id INT);

SELECT fn_generate_test_records(10)
SELECT fn_generate_test_records()

--
CREATE OR REPLACE FUNCTION fn_generate_test_records
	(p_table varchar(100) DEFAULT 'test', p_num_rec INT DEFAULT 1) RETURNS INT AS
$$
DECLARE
	counter INT = 1;
	number_of_records INT = 0;
BEGIN
	EXECUTE format('CREATE TABLE IF NOT EXISTS %I (id INT);', p_table);
	--while spowoduje ze petla bedzie tak dlugo wykonywana jak warunek bedzie prawdziwy, jesli
	--bedzie ponad wartosc p_num_rec to petla sie skonczy
	WHILE counter <= p_num_rec
	LOOP
		EXECUTE format('INSERT INTO %I(id) VALUES (%s);', p_table, counter);
		counter :=counter +1;
	END LOOP;
	EXECUTE format('SELECT COUNT(*) FROM %I;', p_table) INTO number_of_records;
	RETURN number_of_records;
END
$$ LANGUAGE PLPGSQL;

SELECT fn_generate_test_records('my test', 10);
