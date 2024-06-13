CREATE TABLE owner
(
	owner_id SERIAL PRIMARY KEY,
	lasT_name TEXT NOT NULL,
	firsT_name TEXT NOT NULL
)

CREATE TABLE owner_product
(
	owner_product_id SERIAL PRIMARY KEY,
	owner_id INT REFERENCES owner,
	product_id INT REFERENCES product
)

DROP TABLE owner
DROP TABLE owner_product

INSERT INTO owner(last_name, firsT_name) VALUES('Herzt','Kings'),('Piccolo','Jan') RETURNING *;

SELECT * FROM product

INSERT INTO owner_product(owner_id, product_id )
VALUES
(1,1),(2,3),(1,2),(2,2)


SELECT o.last_name, o.first_name, p.name
FROM owner o
JOIN owner_product op ON o.owner_id = op.owner_id
JOIN product p ON p.product_id = op.product_id

