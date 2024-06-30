--ORDER BY - srotowanie wartosci wg kolumny np. id
SELECT * FROM cars WHERE id >= 2 ORDER BY id ASC;

--DISTINCS - usuwanie duplikatow
SELECT DISTINCT brand FROM cars 

--AND  - wiele warunkow ktore musza byc spelnione zeby dostac wyniki
SELECT * FROM cars  WHERE id >=1 AND top_speed >=100 AND num_gears > 4;

SELECT * FROM cars  WHERE brand = 'Dodge' AND top_speed <= 100;


--OR - zwraca rekord jesli chociaz 1 warunek jest spelniony
SELECT * FROM cars  WHERE brand = 'Dodge' OR brand = 'Ford'

--IN - podobny do OR, wiec zwraca jakas wartosc zgadza sie z podana lista, jesli 1 zostanie spelniony warunek z wymienionej listy to wynik zostanie wyswietlony
SELECT * FROM cars  WHERE brand IN ('Dodge', 'Ford')

--LIKE - przeszukanie wartosci w tabeli jesli nie znamy dokladnie szukanej wartosc np. do liter lub czy dane slowo zawiera jakies literki
SELECT * FROM cars  WHERE brand LIKE 'Do%'; /* % dowolna ilosc znakow, po slowie do */
SELECT * FROM cars  WHERE brand LIKE '%ge';  /* % dowolna ilosc znakow, przed slowem i konczy sie na ge */
SELECT * FROM cars  WHERE brand LIKE '%o%'; /* % dowolna ilosc znakow , a w srodku o */
SELECT * FROM cars  WHERE brand LIKE 'F___' /* _ to znak pojedynczy dowolny,  i dajemy ich tyle ile znakow ma slowo */
SELECT * FROM cars  WHERE brand LIKE '_o__' ;
SELECT * FROM cars  WHERE brand LIKE '_o%' ;


--BETWEEN AND - przedzialy
SELECT * FROM cars  WHERE top_speed BETWEEN 190 AND 250;

--NOT -zaprzecza warunek
SELECT * FROM cars  WHERE top_speed NOT BETWEEN 190 AND 250;

--LIMIT - ograniczanie wyswietlania wynikow
SELECT * FROM cars LIMIT 3;
SELECT * FROM cars ORDER BY id DESC  LIMIT 3;

--LIMIT i OFFSET - paginacja wynikow, ze od tej pozycji wyswietl limitem tylko 2 pozycje
SELECT * FROM cars ORDER BY id LIMIT 2 OFFSET 2;
SELECT * FROM cars ORDER BY id LIMIT 2 OFFSET 4
SELECT * FROM cars ORDER BY id LIMIT 2 OFFSET 6;
SELECT * FROM cars ORDER BY id LIMIT 4 OFFSET 0;


--FETCH i OFFSET , fetch podobny do limit, a jak chcemy paginacje to dodajemy offset czyli ,ze od tej pozycji chcemy zaczac wyswietlanie wynikow
SELECT * FROM cars ORDER BY id FETCH FIRST ROW ONLY;
SELECT * FROM cars ORDER BY id FETCH FIRST 3 ROW ONLY;
SELECT * FROM cars ORDER BY id OFFSET 0 FETCH FIRST 3 ROW ONLY;
SELECT * FROM cars ORDER BY id OFFSET 6 FETCH FIRST 3 ROW ONLY

--NULL to brak wartosci, atrybut nieokreslony 
SELECT * FROM cars WHERE num_gears IS NULL;
SELECT * FROM cars WHERE num_gears IS NOT NULL

--AS - alinsy i po aliasach sie odwolujemy pozniej w kodzie
SELECT id AS identyfikator, brand AS marka, model AS model_auta, top_speed AS "prędkość maksymalna" FROM cars 

--ALTER TABLE - modyfikacja tabeli
ALTER TABLE cars ADD color VARCHAR(12) DEFAULT 'red'
ALTER TABLE cars ADD price NUMERIC(10,2) DEFAULT 50000
ALTER TABLE cars DROP COLUMN color --usuniecie

--UPDATE, pojedynczego rekordu i wszystkich
UPDATE cars SET price = 75000 WHERE id = 1
UPDATE cars SET price = 55000 

--ALTER COLUMN
ALTER TABLE cars ALTER COLUMN price TYPE NUMERIC(12,2)

--DELETE - kasowanie rekordu
DELETE FROM cars WHERE id = 9

--DROP TABLE i truncate - usuwanie danych lub calej tabeli
TRUNCATE products; -- tylko usuwanie danych z tabeli
DROP TABLE products; -- usuwanie calej tabeli

--COUNT -- liczy ilosc pozycji/wierszy w danej kolumnie. funkcja agregujaca
SELECT COUNT(id) FROM cars
SELECT COUNT(id) AS num_cars FROM cars

--MAX, SUM, MIN, AVG
SELECT MIN(top_speed) FROM cars --min. predkosc
SELECT MAX(top_speed) FROM cars
SELECT AVG(price) FROM cars
SELECT SUM(price) FROM cars

--GROUP BY - grupowanie wynikow, pobrac ilosc nazw prouktu po danej kategori gdy np. sie powtarzaja to zeby zliczyc ile ich jest pojedynczo 
SELECT COUNT(id), brand FROM cars GROUP BY brand

--GROUP BY HAVING - stosujemy przy GROUP BY i przy funkcjach agregujacych zamiast WHERE, HAVING ogranicza wyniki tak jak WHERE ale przu GROUP BY
SELECT COUNT(id), brand FROM cars GROUP BY brand HAVING COUNT(id) >=2

--UNION ALL - dwa zapytani select do tej samej tabeli lub dwoch roznych ,ale typy musza sie zgadzac
SELECT * FROM cars 
UNION 
SELECT * FROM cars 
--podwojne zapytanie
SELECT * FROM cars 
UNION ALL
SELECT * FROM cars 

--podzapytanie subquries
SELECT * FROM cars WHERE top_speed < ( SELECT AVG(top_speed) FROM cars ) 

--RETURNING - uzyskanie id nowo dodanego rekordu do bazy np. potrzebne przy bibliotekach, dodajemy rekord i zwraca nam jego id
INSERT INTO public.cars(
	brand, model)
	VALUES ('Citroen', 'C3') RETURNING id;

--ENUM - predefiniowanie wartosci, okreslone
CREATE TYPE car_color AS ENUM('red', 'blue', 'white', 'yellow', 'black', 'green')