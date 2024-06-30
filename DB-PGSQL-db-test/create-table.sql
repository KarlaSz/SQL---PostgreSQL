CREATE TABLE IF NOT EXISTS cars (
	id SERIAL PRIMARY KEY, /* bedzie sie zapysywanie automatycznie, autonumeracja*/
	brand VARCHAR(24) NOT NULL,
	model VARCHAR(24) NOT NULL,
	num_gears smallint DEFAULT 4,
	top_speed NUMERIC(7,3), /* 343.222*/
	production_date DATE DEFAULT CURRENT_DATE, /* bedzie sie zapysywanie automatycznie bo jest default ustawiony*/
	created timestamp DEFAULT CURRENT_TIMESTAMP
)