--transakcje
--pomagaja unikac bledow bo nieraz za pomoca 1 zapytania chcemy zrobic kilka operacji na db, i nieraz 1 zapytanie powoduje blad lub daja niekompletne dane to db powinna otworzyc stan przed tym zapytaniem.
--transkacje - tam gdzie wszystkie dane przechodza za 1 razem, sa w praktyce proste bo wykonujemy za jednym razem kilka operacji

BEGIN;
INSERT INTO cars( brand, model) VALUES ('Ford', 'Ka');

SELECT * FROM cars

COMMIT;