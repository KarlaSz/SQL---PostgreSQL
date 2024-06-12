--zagniezdzone dwie tabele w 1 - zle
CREATE TABLE trip
(name VARCHAR(100),
 attraction TEXT);
 
 INSERT INTO trip (name, attraction)
 VALUES ('Italy', 'Venice, Rome, Napoli')
 
 SELECt * FROM trip;
 
 DROP TABLE trip;

--1st normalization
CREATE TABLE trip
(name VARCHAR(100),
 attraction_id INT);
 
 CREATE TABLE attraction
(attraction_id INT,
name TEXT);
 
 INSERT INTO trip 
 VALUES ('Italy', 1), ('Italy', 2), ('Italy', 3)
 
  
 INSERT INTO attraction 
 VALUES (1, 'Rome'), (2, 'Rome'), (3, 'Rome')
 
SELECt * FROM trip;
SELECt * FROM attraction;

SELECT * FROM trip AS t
join attraction AS a ON t.attraction_id = a.attraction_id
 
 DROP TABLE trip;
 
 
 