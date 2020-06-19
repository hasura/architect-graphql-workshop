--
-- PostgreSQL database dump
--

BEGIN;

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET default_tablespace = '';
SET default_with_oids = false;


---
--- drop tables
---


DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS products;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id serial PRIMARY KEY,
    name text,
    address text, 
    phone character varying(24)
);

CREATE TABLE products (
    product_id integer NOT NULL PRIMARY KEY,
    product_name text NOT NULL,
    supplier_id smallint,
    category_id smallint,
    quantity_per_unit character varying(20),
    unit_price real,
    units_in_stock smallint,
    units_on_order smallint,
    reorder_level smallint,
    discontinued integer NOT NULL
);

CREATE TABLE orders (
    order_id serial PRIMARY KEY,
    user_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer default 1, 
    order_date timestamptz default now(),
    shipping_address text,
    shipment_id uuid,
    status text default 'new',
    FOREIGN KEY (user_id) REFERENCES users (id)
);

COMMIT;
