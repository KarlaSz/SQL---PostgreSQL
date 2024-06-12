 --stary sposob nie wydajny
 CREATE TABLE client
 (client_ind INT PRIMARY KEY,
 lat_name VARCHAR(100),
 first_name VARCHAR(100),
 address VARCHAR(100),
 trip VARCHAR(100),
 price NUMERIC(10,2));
 
 DROP TABLE CLIENT
  DROP TABLE trip
 
 --2nd normalization
 
 CREATE TABLE client ( 
	client_id INT PRIMARY KEY,
 	lat_name VARCHAR(100),
 	first_name VARCHAR(100),
 	address VARCHAR(100));
 
 CREATE TABLE trip (
	trip_id INT PRIMARY KEY,
 	trip_name VARCHAR(100),
 	price NUMERIC(10,2),
 	client_id INT)
	
INSERT INTO client VALUES (1,'Smith', 'John', 'Warsaw');
INSERT INTO trip VALUES (1,'Italy','300', 1), (2,'Rome','500',1);

SELECT * FROM client;
SELECT * FROM trip;

SELECT * FROM client c
join trip t ON c.client_id = t.client_id

