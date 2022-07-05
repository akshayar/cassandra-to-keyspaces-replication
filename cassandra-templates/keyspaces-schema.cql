CREATE TABLE {{ target_keyspace }}.products(
  id bigint PRIMARY KEY,
  name text,
  description text,
  weight float
) WITH cdc=true;

CREATE TABLE {{ target_keyspace }}..products_on_hand (
  product_id bigint PRIMARY KEY,
  quantity bigint,
) WITH cdc=true;

CREATE TABLE {{ target_keyspace }}..customers (
  id bigint PRIMARY KEY,
  first_name varchar,
  last_name varchar,
  email varchar,
  insertdate text,
) WITH cdc=true;

