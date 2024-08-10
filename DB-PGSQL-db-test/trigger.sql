--trigger - procedury ktora automatycznie jest wywolywania jesli jest jakies zdarzenie na db np. zapis nowego rekordu lub update

CREATE OR REPLACE FUNCTION check_top_speed()
RETURNS TRIGGER AS $$
BEGIN
	IF NEW.top_speed < 0 THEN
		NEW.top_speed := 5;
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_speed
BEFORE INSERT OR UPDATE ON cars
FOR EACH ROW
EXECUTE PROCEDURE check_top_speed();

UPDATE cars SET top_speed = -50 WHERE id = 10

SELECT * FROM cars

--trigger aktualizacji rekordu
ALTER TABLE cars ADD COLUMN updated TIMESTAMP;

CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
	NEW.updated := NOW();
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_car_timestamp
BEFORE UPDATE ON cars
FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();



UPDATE cars SET top_speed = -40 WHERE id = 10;

SELECT * FROM cars;