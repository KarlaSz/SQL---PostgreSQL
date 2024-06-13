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

---
--relation table to itself 
--

CREATE TABLE task
(
	task_id INT PRIMARY KEY,
	name TEXT NOT NULL,
	parent_task_id INT REFERENCES task
)

INSERT INTO task
VALUES 
(1, 'Finish course', NULL),
(2, 'Finish course 1', 1),
(3, 'Finish course 2', 1),
(4, 'Finish course 1', 2),
(5, 'Finish course 2', 2),
(6, 'Finish course 11', 3),
(7, 'Finish course 12', 3)

SELECT * FROM task
SELECT * FROM task WHERE parent_task_id=1;
SELECT * FROM task WHERE parent_task_id=2;
SELECT * FROM task WHERE parent_task_id=3;
SELECT * FROM task WHERE parent_task_id IS NULL;