--trigger
--trigger

ALTER TABLE product RENAME COLUMN modified_by TEXT;
ALTER TABLE product ADD COLUMN modified_time TIMESTAMP;

CREATE OR REPLACE FUNCTION product_metadata() RETURNS trigger
AS
$$
BEGIN
	NEW.modified_by := CURRENT_USER;
	NEW.modified_time := CURRENT_TIMESTAMP;
	RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

--wywolywanie triggera, moze sie uruchamiac przed zapisaniem rekordu na dysku - wtedy before, albo
--po zapisaniu danych czyli AFTER. BEFORE pozwala tez na modyfikacje rekordu przed zapisem,wiec jest
--lepszy tutaj bo chcemy zmodyfikowac dane. TRIGGER AFTER widzi juz caly rekord jak juz zostal zapisany
--ale nie mozna w nim dokonac zmian, wiec wtedy gdy nie chcemy modyfikowac rekordu
--do 1 tabeli mozna zdefiniowac wiele triggerow
CREATE OR REPLACE TRIGGER product_metadata BEFORE INSERT OR UPDATE ON product
FOR EACH ROW EXECUTE FUNCTION product_metadata();

SELECT * FROM product

UPDATE product
	SET quantity = 1
WHERE product_id = 1

SELECT * FROM product

--usuwanie
DROP TRIGGER IF EXISTS product_metadata ON product

---
--trigger for each

CREATE OR REPLACE FUNCTION clean_vendors() RETURNS trigger
AS
$$
BEGIN
	RAISE NOTICE 'Trigger clean_vendors is starting';
	DELETE FROM vendor WHERE vendor_id IN
		(SELECT d.vendor_id
		FROM deleted AS d
		LEFT JOIN product AS p ON p.vendor_id = d.vendor_id
		WHERE p.product_id IS NULL);
	RETURN NULL;
END;
$$ LANGUAGE PLPGSQL;

--trigger ktory usuwa zapisane rekordy, dziala per statemetn,a nie per rekord.
CREATE OR REPLACE TRIGGER clean_vendors AFTER DELETE ON product
REFERENCING OLD TABLE AS deleted
FOR EACH STATEMENT EXECUTE FUNCTION clean_vendors();


SELECT * FROM vendor v
LEFT JOIN product p ON v.vendor_id = p.vendor_id
WHERE p.product_id IS NULL

INSERT INTO Product (name, vendor_id, buy_date, price, quantity)
VALUES ('Smartphone VIVO', 3, '2023-03-01', 2000, 1);
INSERT INTO Product (name, vendor_id, buy_date, price, quantity)
VALUES ('Fridge Samsung', 2, '2023-03-01', 2000, 1);

---
--trigger mini audit

CREATE SCHEMA audits;

SELECT * FROM product

--za jednym razem wykonuje zapytanie i tworzy tabele o strukturze z godnej ze zwracanymi dnaymi
--a jesli nie chcemy kopiowac wierszy i tylko tworzyc nowa tabele to dodac warunek 1=0
SELECT * INTO audits.product FROM product WHERE 1=0;

SELECT * FROM audits.product;

--wyjatek dla wyrazen jednoznakowych cyli jednoznakowy napis bo znam dlugosc tej kolumny
ALTER TABLE audits.product ADD COLUMN modified_action CHAR(1);

SELECT * FROM audits.product;


CREATE OR REPLACE FUNCTION audit_product_all() RETURNS trigger
AS
$$
BEGIN
	IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
		INSERT INTO audits.product(product_id, name, vendor_id, buy_date, description, price, quantity,
								  modified_by, modified_time, modified_action)
		SELECT product_id, name, vendor_id, buy_date, description, price, quantity,
			modified_by, modified_time, LEFT(TG_OP,1) FROM inserted;
		ELSE 
			INSERT INTO audits.product(product_id, name, vendor_id, buy_date, description, price, quantity,
								  modified_by, modified_time, modified_action)
			SELECT product_id, name, vendor_id, buy_date, description, price, quantity,
				CURRENT_USER, CURRENT_TIMESTAMP, LEFT(TG_OP,1) FROM deleted;
			END IF;
	RETURN NULL;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER audit_product_all AFTER INSERT OR UPDATE OR DELETE
ON product
REFERENCING NEW TABLE AS inserted OLD TABLE AS deleted
FOR EACH STATEMENT EXECUTE FUNCTION audit_product_all();

CREATE OR REPLACE TRIGGER audit_product_ins AFTER INSERT
ON product
REFERENCING NEW TABLE AS inserted 
FOR EACH STATEMENT EXECUTE FUNCTION audit_product_all();

CREATE OR REPLACE TRIGGER audit_product_upd AFTER UPDATE
ON product
REFERENCING NEW TABLE AS inserted OLD TABLE AS deleted
FOR EACH STATEMENT EXECUTE FUNCTION audit_product_all();

CREATE OR REPLACE TRIGGER audit_product_del AFTER DELETE
ON product
REFERENCING OLD TABLE AS deleted
FOR EACH STATEMENT EXECUTE FUNCTION audit_product_all();

SELECT * FROM product;
UPDATE product SET quantity = 1 WHERE product_id = 3

SELECT * FROM product
SELECT * FROM audits.product

INSERT INTO product(name, vendor_id, buy_date, description, price, quantity, modified_by, modified_time)
VALUES 
('Monitor Samsung', 1,'2023-04-01', null, 1299,1, null, null),
('Coffe Machine', null,'2023-05-01', null, 2299, 1, null,null);