-- dane wygenerowane przy tworzeniu
CREATE TABLE public.vendor
(
    vendor_id serial NOT NULL,
    name character varying(100) NOT NULL,
    country character varying(100) DEFAULT "China",
    CONSTRAINT vendor_pk PRIMARY KEY (vendor_id)
);

ALTER TABLE IF EXISTS public.vendor
    OWNER to postgres;

-- Table: public.vendor

-- DROP TABLE IF EXISTS public.vendor;
-- dane przetworzone przez Pgsql

CREATE TABLE IF NOT EXISTS public.vendor
(
    vendor_id integer NOT NULL DEFAULT nextval('vendor_vendor_id_seq'::regclass),
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    country character varying COLLATE pg_catalog."default" DEFAULT 'China'::character varying,
    CONSTRAINT vendor_pk PRIMARY KEY (vendor_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.vendor
    OWNER to postgres;



----------------------------------
--$ wstawianie rekordow do tabeli vendor
----------------------------------
INSERT INTO public.vendor(name, country) VALUES('Samsung', 'Korea');
INSERT INTO public.vendor(name, country) VALUES('Xiaomi', DEFAULT);
INSERT INTO public.vendor(name) VALUES('Vivo');

----------------------------------
--create product table and insert values 
----------------------------------

CREATE TABLE public.product(
	product_id SERIAL,
	name VARCHAR(100) NOT NULL,
	vendor_id INT ,
	buy_date DATE NOT NULL DEFAULT CURRENT_DATE,
	description TEXT
)

INSERT INTO public.product(name, vendor_id,buy_date,description) 
VALUES('Galaxy Z Flip 4', 1, '2024-11-11', NULL);

INSERT INTO public.product(name, vendor_id) 
VALUES('Xpress printer', 1); --data bedzie z zegarka systemowego kompa bo nie jest okreslona i byla ustawiona ze ma byc default jesli user nie wpisze

INSERT INTO public.product(name, vendor_id, buy_date, description) 
VALUES('POCO F4', 2, '2024-11-11', 'purchase on credit');
	   
select * from public.product

----------------------------------
--create card table
----------------------------------

CREATE TABLE card(
	card_id SERIAL NOT NULL PRIMARY KEY,
	product_id INT NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	scope VARCHAR(100)
)

INSERT INTO card(product_id, start_date, end_date, scope) 
VALUES(1, '2024-11-11', '2027-11-11', 'door to door - d2d');

INSERT INTO card(product_id, start_date, end_date, scope) 
VALUES(1, '2027-11-11', '2029-11-11', 'next buisness day - nbd');

INSERT INTO card(product_id, start_date, end_date, scope) 
VALUES(2, '2022-08-11', '2029-11-17', '');

INSERT INTO card(product_id, start_date, end_date, scope) 
VALUES(3, '2024-11-11', '2026-11-11', 'bank');

----------------------------------
--join all tables 
----------------------------------

SELECT
	v.name, p.name, max(c.end_date) "Varranty End"
FROM vendor v
JOIN product p ON p.vendor_id = v.vendor_id
JOIN card c ON c.product_id = p.product_id
GROUP BY v.name, p.name
