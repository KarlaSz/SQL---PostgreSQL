SELECT cars.id, cars.brand, cars.model, drivers.id as driver_id, drivers.name
FROM cars
JOIN drivers ON cars.driver_id = drivers.id

SELECT cars.id, cars.brand, cars.model, drivers.id as driver_id, drivers.name
FROM cars
LEFT JOIN drivers ON cars.driver_id = drivers.id
--wtedy przylacza sie lewa kolumna i pokazane sa tez te wartosci co nie maja swojej pary czyli sa nullami

--right join, przylacza prawa tabele , tez zwroci wszystkich kierowcow od prawej 
SELECT cars.id, cars.brand, cars.model, drivers.id as driver_id, drivers.name
FROM cars
LEFT JOIN drivers ON cars.driver_id = drivers.id 

--full join, zwraca wszystkie rekordy z obu tabel niezaleznie czy jest para czy nie
SELECT cars.id, cars.brand, cars.model, drivers.id as driver_id, drivers.name
FROM cars
FULL JOIN drivers ON cars.driver_id = drivers.id

--cross join, rzadko sie korzysta. wykorzysytwny jest iloczyn kartezjanski. np do tabel przykladowych z duzymi ilosciami danych
SELECT *
FROM cars
CROSS JOIN drivers


