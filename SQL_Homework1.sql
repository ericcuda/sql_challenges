-- Eric Staveley  MWSa  SQL HW Assignment #1  (MySQL)   Due: 27Mar2019

USE sakila;

-- 1a
SELECT first_name,
       last_name
FROM   actor; 

-- 1b
SELECT Concat(Upper(first_name), "", Upper(last_name)) AS 'ACTOR NAME'
FROM   actor; 

-- 2a
SELECT actor_id, 
       first_name, 
       last_name 
FROM actor 
WHERE UPPER(first_name) = 'JOE';

-- 2b
SELECT first_name, 
       last_name 
FROM actor 
WHERE UPPER(last_name) LIKE '%GEN%';

-- 2c
SELECT last_name, 
       first_name 
FROM actor 
WHERE UPPER(last_name) LIKE '%LI%' 
ORDER BY last_name, 
         first_name;

-- 2d
SELECT country_id, 
       country 
FROM   country 
WHERE  country IN ('Afghanistan', 'Bangladesh', 'China');

-- enabling this anyway, in case we do multiple updates later
SET SQL_SAFE_UPDATES = 0;

-- 3a
ALTER TABLE actor
  ADD description BLOB after last_name; 

UPDATE actor 
SET description = 'this is a description for PENELOPE GUINESS, and is taking too long' 
WHERE first_name = "PENELOPE" 
      AND last_name = "GUINESS";

-- 3b
ALTER TABLE actor
  DROP COLUMN description;

-- 4a
SELECT UPPER(last_name) AS 'LAST_NAME',
       COUNT(*)         AS 'LAST_NAME_COUNT' 
FROM actor 
GROUP BY last_name;

-- 4b
SELECT UPPER(last_name) AS 'LAST_NAME',
       COUNT(*) As 'LAST_NAME_COUNT' 
FROM actor 
GROUP BY last_name 
HAVING LAST_NAME_COUNT > 1;

-- 4c
UPDATE actor
SET first_name = 'HARPO' 
WHERE (first_name = 'GROUCHO' 
      AND last_name = 'WILLIAMS');

-- 4d
UPDATE actor
SET	first_name = 'GROUCHO' 
WHERE (first_name = 'HARPO' 
      AND last_name = 'WILLIAMS');

-- 5a
SHOW CREATE TABLE address;

-- 6a
SELECT first_name, 
       last_name, 
       address
FROM staff s
     INNER JOIN address a
            ON s.address_id = a.address_id;

-- 6b
SELECT first_name, 
       last_name, 
       sum(p.amount) As 'Total Amount'
FROM staff s
     INNER JOIN payment p
             ON s.staff_id = p.staff_id
WHERE MONTH(p.payment_date) = 8
GROUP BY s.first_name;

-- 6c
SELECT title, 
       sum(fa.film_id) As 'Num of Actors'
FROM film f
     INNER JOIN film_actor fa
            ON f.film_id = fa.film_id
            GROUP BY f.title;

-- 6d
select title, 
       COUNT(i.film_id) As "Total Count"
FROM film f
     INNER JOIN inventory i
             ON f.film_id = i.film_id
WHERE f.title = "HUNCHBACK IMPOSSIBLE";

-- 6e	
SELECT first_name, 
       last_name, 
       sum(p.amount) As "Total Amount Paid"
FROM customer c
     INNER JOIN payment p
             ON c.customer_id = p.customer_id 
GROUP BY c.customer_id 
ORDER BY last_name ASC;

-- 7a
SELECT title As 'Movie Title' 
FROM film f
WHERE f.language_id = (SELECT language_id 
                       FROM language 
                       WHERE name = 'English')
      AND f.title LIKE 'K%' 
       OR f.title LIKE 'Q%';

-- 7b
SELECT first_name, 
       last_name 
FROM actor 
WHERE actor_id IN (SELECT actor_id 
                   FROM film_actor 
                   WHERE film_id = (SELECT film_id 
                                    FROM film 
                                    WHERE title = 'Alone Trip'));

-- 7c   *****
SELECT first_name, 
       last_name, 
       email 
FROM customer cust
     INNER JOIN address addr 
             ON cust.address_id = addr.address_id 
     INNER JOIN city city 
             ON city.city_id = addr.city_id 
     INNER JOIN country cntry 
             ON cntry.country_id = city.country_id 
WHERE cntry.country = 'Canada';

-- 7d
SELECT title
FROM film film
     INNER JOIN film_category fc 
            ON film.film_id = fc.film_id 
     INNER JOIN category cat
            ON cat.category_id = fc.category_id 
WHERE cat.name = 'Family';

-- 7e
SELECT film.title, 
       COUNT(ren.rental_id) AS Rental_Count 
FROM film film 
     INNER JOIN inventory inv
             ON inv.film_id = film.film_id
     INNER JOIN rental ren 
             ON ren.inventory_id = inv.inventory_id 
GROUP BY film.title 
ORDER BY Rental_Count DESC;

-- 7f
SELECT s.store_id, 
       SUM(amount) 
FROM store s 
     INNER JOIN inventory inv 
             ON s.store_id = inv.store_id 
     INNER JOIN rental ren 
             ON ren.inventory_id = inv.inventory_id
     INNER JOIN payment pay 
             ON pay.rental_id = ren.rental_id
GROUP BY s.store_id 
ORDER BY SUM(amount) DESC;

-- 7g
SELECT sto.store_id, 
       city.city, 
       cntry.country 
FROM store sto 
     INNER JOIN address addr 
             ON addr.address_id = sto.address_id 
     INNER JOIN city city 
             ON city.city_id = addr.city_id 
     INNER JOIN country cntry 
             ON cntry.country_id = city.country_id;

-- 7h
SELECT cat.name,
       Sum(pay.amount) AS Gross_Revenue
FROM   category cat
       INNER JOIN film_category fc
               ON fc.category_id = cat.category_id
       INNER JOIN film film
               ON film.film_id = fc.film_id
       INNER JOIN inventory inv
               ON inv.film_id = fc.film_id
       INNER JOIN rental rent
               ON rent.inventory_id = inv.inventory_id
       INNER JOIN payment pay
               ON pay.rental_id = rent.rental_id
GROUP  BY cat.name
ORDER  BY gross_revenue DESC
LIMIT  5;

-- 8a
CREATE view top_five_genre_v
AS
  SELECT cat.name,
         Sum(pay.amount) AS Gross_Revenue
  FROM   category cat
         INNER JOIN film_category fc
                 ON fc.category_id = cat.category_id
         INNER JOIN film film
                 ON film.film_id = fc.film_id
         INNER JOIN inventory inv
                 ON inv.film_id = fc.film_id
         INNER JOIN rental rent
                 ON rent.inventory_id = inv.inventory_id
         INNER JOIN payment pay
                 ON pay.rental_id = rent.rental_id
  GROUP  BY cat.name
  ORDER  BY gross_revenue DESC
  LIMIT  5; 

-- 8b
SELECT *  
FROM top_five_genre_v;

-- 8c
DROP VIEW top_five_genre_v;
