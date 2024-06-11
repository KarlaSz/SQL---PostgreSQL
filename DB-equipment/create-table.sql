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