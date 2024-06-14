CREATE VIEW product_and_owner
AS
SELECT o.last_name, o.first_name, p.name
FROM owner o
JOIN owner_product op ON o.owner_id = op.owner_id
JOIN product p ON op.product_id = p.product_id

--uzywanie widoku
SELECT * FROM product_and_owner

--
--nalezy trzymac sie tej samej kolejnosci kolumn czy zmianie lub dodawaniu nowych kolumn
CREATE OR REPLACE VIEW product_and_owner
AS
SELECT o.last_name, o.first_name, p.name, p.price * p.quantity
FROM owner o
JOIN owner_product op ON o.owner_id = op.owner_id
JOIN product p ON op.product_id = p.product_id

SELECT * FROM product_and_owner

CREATE OR REPLACE VIEW product_and_owner
AS
SELECT o.last_name, o.first_name, p.name, p.price * p.quantity AS "product_value"
FROM owner o
JOIN owner_product op ON o.owner_id = op.owner_id
JOIN product p ON op.product_id = p.product_id

ALTER VIEW product_and_owner RENAME COLUMN "?column?" TO "product_value"

