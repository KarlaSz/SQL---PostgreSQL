--functions--

CREATE OR REPLACE FUNCTION update_vendors() RETURNS void AS
$$
	UPDATE vendor SET name=UPPER(name);
$$ LANGUAGE SQL

SELECT name FROM vendor;
SELECT update_vendors();
SELECT name FROM vendor;

--zwrocenie wartosci za pomoca funkjci, nie tworzylam tego widoku good_product, ale kod jest ok

CREATE OR REPLACE FUNCTION get_good_products_count() RETURNS INT AS
$$
	SELECT COUNT(*) FROM good_product
$$ LANGUAGE SQL

SELECT get_good_products_count()

--
--zamiennik zamiast $$, wazne zeby zaczynac i konczyc tymi samymi znakami
CREATE OR REPLACE FUNCTION update_vendors() RETURNS void AS
$func$
	UPDATE vendor SET name=UPPER(name);
$func$ LANGUAGE SQL

--
--funckja akceptujaca parametry, warto dodac prefix do parametru i nadac mu unikatowa nazwe
CREATE OR REPLACE FUNCTION get_vendor_product_count(p_vendor_name TEXT) RETURNS INT AS
$$
	SELECT COUNT(*)
	FROM product p
	JOIN vendor v ON p.vendor_id = v.vendor_id
	WHERE v.name = p_vendor_name
$$ LANGUAGE SQL

SELECT get_vendor_product_count('SAMSUNG');
--gdy w zapytanie jest wspomniane $1 tzn ze jest to odwolanie do parametru 1

--funkcje nie maja zmiennych, petli i obslugi bledow sa wiec ograniczone, w ramach jednej funkcji mozna wykorzystac dowolna ilosc zapytan. funkcje nie musza przyjmowac parametrow i zwracac wartosci, ale moga tez
