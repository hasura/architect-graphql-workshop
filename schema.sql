BEGIN;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE public.users (
  id serial PRIMARY KEY,
  name text,
  email text,
  address text
);

CREATE TABLE public.restaurants (
  id integer PRIMARY KEY,
  name text NOT NULL,
  address text,
  rating float
);

CREATE TABLE public.menu_items (
  restaurant_id integer,
  item_id integer NOT NULL,
  name text NOT NULL,
  PRIMARY KEY(restaurant_id, item_id)
);

ALTER TABLE ONLY public.menu_items
  ADD CONSTRAINT menu_items_restaurant_id_fkey FOREIGN KEY (restaurant_id) REFERENCES public.restaurants(id);


CREATE TABLE public.orders (
  order_id text PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id integer NOT NULL,
  restaurant_id integer NOT NULL,
  payment_rcvd boolean DEFAULT false,
  driver_assigned boolean DEFAULT false NOT NULL,
  food_picked boolean DEFAULT false NOT NULL,
  delivered boolean DEFAULT false NOT NULL,
  cancelled boolean DEFAULT false,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

ALTER TABLE ONLY public.orders
  ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);

ALTER TABLE ONLY public.orders
  ADD CONSTRAINT orders_restaurant_id_fkey FOREIGN KEY (restaurant_id) REFERENCES public.restaurants(id);

CREATE TABLE public.order_items (
  order_id text NOT NULL,
  item_id serial NOT NULL,
  quantity int NOT NULL
);

ALTER TABLE ONLY public.order_items
  ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);

CREATE TABLE public.assignment (
  order_id text NOT NULL,
  driver_id integer NOT NULL
);

ALTER TABLE ONLY public.assignment
  ADD CONSTRAINT assignment_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);

CREATE TABLE public.payments (
  id serial PRIMARY KEY,
  order_id text NOT NULL,
  payment_type text,
  payment_reference text,
  amount integer NOT NULL
);

ALTER TABLE ONLY public.payments
  ADD CONSTRAINT payments_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);

CREATE VIEW public.number_order_driver_assigned AS
  SELECT count(*) AS count
    FROM public.orders
   WHERE (orders.driver_assigned = true);

CREATE VIEW public.number_orders AS
  SELECT count(*) AS count
    FROM public.orders;


COMMIT;


