--SELECT * FROM information_schema.tables;
--SELECT * FROM pg_catalog.pg_tables;


DO $$ BEGIN
	IF EXISTS(
		SELECT * FROM information_schema.tables
			 WHERE table_schema = 'public' AND table_name ='product_info' AND table_type='BASE TABLE')
			 THEN 
			 RAISE NOTICE 'Table already exists - no action';
			 ELSE
			 RAISE NOTICE 'Creating table';
			 CREATE TABLE product_info (
				 product_it INT, 
				 description TEXT);
		END IF;
END $$

EXPLAIN ANALYZE 
SELECT * FROM pg_catalog.pg_attribute
--lepszy i wydajniejszy, ale starszy i natywny

EXPLAIN ANALYZE 
SELECT * FROM information_schema.columns;
--standard ANSI, dluzsza odpowiedz, ale bardziej standardowa i dziala na wielu db. stosowac gdy raz na jakis czas cos pobieramy