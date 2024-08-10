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