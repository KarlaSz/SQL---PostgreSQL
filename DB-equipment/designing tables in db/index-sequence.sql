CREATE INDEX idx_product_name ON product (name)
---
CREATE SEQUENCE next_please;

SELECT nextval('next_please')

SELECT currval('next_please');

SELECT lastval('next_please')

DROP SEQUENCE IF EXISTS next_please
---

CREATE SEQUENCE IF NOT EXISTS next_please2
INCREMENT 10
MINVALUE 100
MAXVALUE 200
START WITH 100;

SELECT nextval('next_please2')
--
