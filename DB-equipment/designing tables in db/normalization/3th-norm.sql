 --stary sposob nie wydajny
 CREATE TABLE sales (
	 id INT PRIMARY KEY,
	 netto NUMERIC(10,2),
	 tax_percent NUMERIC(3,2),
	 brutto NUMERIC(10,2)
 )
 
INSERT INTO sales VALUES (1,100, 0.23, 123), (2,1000, 0.08, 1080);
 

SELECT * FROM sales;
--grozi to tym ze mozna z palca zmieniac wartosc brutto. powinna byc wartosc netto albo brutto

DROP TABLE sales;

 --3th normalization
  CREATE TABLE sales (
	 id INT PRIMARY KEY,
	 netto NUMERIC(10,2),
	 tax_percent NUMERIC(3,2),
	 brutto NUMERIC(10,2) GENERATED ALWAYS AS (netto + netto * tax_percent) STORED --VIRTUAL
 )

INSERT INTO sales VALUES (1,100, 0.23), (2,1000, 0.08);

SELECT * FROM sales;

