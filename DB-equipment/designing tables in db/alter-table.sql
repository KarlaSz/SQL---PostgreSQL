----------------------------------
--changes in existed tables
----------------------------------
ALTER TABLE vendor
ADD is_favourite BOOLEAN DEFAULT false;

SELECT * FROM vendor

ALTER TABLE product
ADD price NUMERIC(10,2) NULL,
ADD quantity SMALLINT DEFAULT 1;

SELECT * FROM product


ALTER TABLE card RENAME TO varranty;
ALTER TABLE varranty RENAME card_id TO varranty_id;

ALTER TABLE varranty ALTER COLUMN scope SET DATA TYPE VARCHAR(20);

SELECT * FROM varranty;

ALTER TABLE varranty DROP COLUMN scope;