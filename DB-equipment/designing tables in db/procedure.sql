--nie ma tutaj klauzli returns bo nic nie zwraca
--czesto dotyczy to modyfikacji
CREATE OR REPLACE PROCEDURE correct_quantity(p_new_quantity INT DEFAULT 1)
AS
$$
	UPDATE product SET
		quantity = p_new_quantity
	WHERE quantity IS NULL OR quantity <=0
$$ LANGUAGE SQL

SELECT * FROM product WHERE quantity IS NULL OR quantity <=0;

--wywolanie procedury
CALL correct_quantity();

SELECT * FROM product WHERE quantity IS NULL OR quantity <=0;