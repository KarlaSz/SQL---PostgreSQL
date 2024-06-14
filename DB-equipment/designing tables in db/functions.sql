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
SELECT get_vendor_product_count('XIAOMI');
--gdy w zapytanie jest wspomniane $1 tzn ze jest to odwolanie do parametru 1

--II
--przekazywanie parametrow
CREATE OR REPLACE FUNCTION get_vendor_product_count2(name TEXT DEFAULT 'SAMSUNG') RETURNS INT AS
$$
	SELECT COUNT(*)
	FROM product p
	JOIN vendor v ON p.vendor_id = v.vendor_id
	WHERE v.name = $1
$$ LANGUAGE SQL

SELECT get_vendor_product_count2('SAMSUNG');
SELECT get_vendor_product_count2('XIAOMI');
SELECT * FROM get_vendor_product_count2('XIAOMI');

DROP FUNCTION get_vendor_product_count2

--
--funkcja z argumentem bez nazwy, wiec trzeba sie poslugiwac juz dolarami w odniesieniu do parametrow
CREATE OR REPLACE FUNCTION get_vendor_product_count2(name TEXT DEFAULT 'SAMSUNG') RETURNS INT AS
$$
	SELECT COUNT(*)
	FROM product p
	JOIN vendor v ON p.vendor_id = v.vendor_id
	WHERE v.name = $1
$$ LANGUAGE SQL

SELECT get_vendor_product_count('SAMSUNG');
--
--tabela jako parametr w funkcji, po to ze jesli typ rekordu bedzie 
--taki sam jak struktura z tabeli wymienione parametrze to bedzie 
--taki sam to bedzie go mozna przekazac

--funkcja symulacji podwyzki

CREATE OR REPLACE FUNCTION new_price(product, ratio numeric)
RETURNS double precision AS 
$$
SELECT $1.price * ratio/100;
$$ LANGUAGE SQL

SELECT *, new_price(product.*, 120) FROM product WHERE price >=0

--null to pozycja kolumny z zapytanie wyzej, 100 w zapytaniu to pozycja do kolumny price
SELECT new_price(ROW(NULL,NULL,NULL,NULL,NULL,100,NULL),150 );

--
CREATE OR REPLACE FUNCTION get_max_varranty(
	IN p_start_date DATE, IN p_end_date DATE, OUT max_date DATE)
	AS
	$$
		SELECT CASE
		WHEN  p_end_date > p_start_date + INTERVAL '1 year' THEN p_end_date
		ELSE p_start_date + INTERVAL '1 year'
		END
	$$ LANGUAGE SQL

--zwracanie parametrow przez parametr wyjsciowy
SELECT get_max_varranty('2030-06-4', '2033-06-04');
SELECT get_max_varranty('2030-06-4', NULL);

DROP FUNCTION IF EXISTS get_max_varranty;

--
--nowy parametr ktory wchodzi i wychodzi, ktory jest uniwersalny
CREATE OR REPLACE FUNCTION get_max_varranty(
	IN p_start_date DATE, INOUT p_end_date DATE, OUT max_date DATE)
	AS
	$$
		SELECT p_end_date,
		CASE
		WHEN  p_end_date > p_start_date + INTERVAL '1 year' THEN p_end_date
		ELSE p_start_date + INTERVAL '1 year'
		END
	$$ LANGUAGE SQL
	
SELECT get_max_varranty('2030-06-4', '2033-06-04');
--w wyniku sa dwie wartosci bo sa dwa parametry z out

SELECT get_max_varranty('2030-06-4', NULL);
--pierwsza wartosc jest pusta, a druga nie byla okreslona wiec funkcja zwraca domyslna ustawiona na 1 rok

SELECT * FROM get_max_varranty('2030-06-4', '2033-06-04')
--kolumny nazwane jak parametry wyjsciowe

--
--boczny join czyli LATERAL, wykorzystuje funkcje jak podzypatnie. typ joina
--ktory wykorzystuje funkcja ktora korzysta z wartosci ktore juz sa obecne w danym rekordzie
-- dlatego wartosc zwracana bedzie pasowac do wiersza wiec dajemy na koncu true i nie trzeba 
--okreslac ON bo wartosc wygenerowana zawsze juz pasuje do tego co mamy porane z tabeli 

SELECT p.name, v.start_date, v.end_date, f.*
FROM product p
JOIN varranty v ON p.product_id = v.product_id
JOIN LATERAL get_max_varranty(v.start_date, v.end_date) f ON true;


