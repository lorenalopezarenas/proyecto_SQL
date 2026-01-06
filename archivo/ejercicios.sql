-- DATA PROYECT: SQL

/** Ejercicio 1
 Crear esquema ER **/

-- Ejercicio 2: títulos películas clasificación "R"
select f.title as peliculas_R
from film f  
where rating = 'R';

-- Ejercicio 3: actores con ActorID entre 30 y 40 
select 
	a.actor_id,
	CONCAT (a.first_name, ' ', a. last_name) as nombre_actor
from actor a 
where a.actor_id between 30 and 40
order by a.actor_id ;

-- Ejercicio 4: películas cuyo idioma coincide con el original
select f.title, f.language_id, f.original_language_id 
from film f 
left join language l 
	on f.language_id = l.language_id
where f.language_id = f.original_language_id ;
	/** No hay ninguna película cuyo idima coincida con el original.
	No es una información del todo cierta ya que no disponemos de datos del idioma original.
	 **/

-- Ejercicio 5: películas ordenadas por duración ascendente 
select 
	f.title as peliculas, 
	f.length as min_duracion
from film f 
order by min_duracion ;

-- Ejercicio 6: nombre completo actores con apellido "Allen"
select CONCAT (a."first_name", ' ', a. "last_name") as "nombre_actor"
from actor a 
where a.last_name in ('ALLEN') ;

-- Ejercicio 7: recuento de películas por clasificación 
select 
	c.name as clasificacion ,
	count (distinct fc.film_id) as recuento --DISTINCT para asegurar que una película no se cuente más de una vez
from film_category fc
inner join category c 
	on fc.category_id = c.category_id 
group by clasificacion ;

-- Ejercicio 8: películas con clasificación "PG-13" o duración mayor a 3 horas 
select f.title as peliculas 
from film f 
where rating = 'PG-13' or f.length > 180 ;

-- Ejercicio 9: variabilidad del coste de reemplazamiento de las películas
select round(variance(f.replacement_cost), 2) as variabilidad_reemplazamiento
from film f ;

-- Ejercicio 10: mayor y menor duración de una película
select 
	MAX(f.length) || ' min' as mayor_duracion,
	MIN(f.length) || ' min' as menor_duracion
from film f ;
	/** La mayor duración de una película en la BBDD es de 185 minutos.
	 La menor duración de una película en la BBDD es de 46 minutos.
	 **/

-- Ejercicio 11: coste del antepenúltimo alquiler
select 
	p.amount || ' €' as precio_antepenultimo_alquiler
from rental r 
inner join payment p 
	on r.rental_id = p.rental_id  
group by p.rental_id, p.amount, r.rental_date  
order by r.rental_date desc -- Ordenamos por orden descendente para ver el último alquiler en la primera fila
offset 2 -- Quitamos las dos primeras filas que corresponden con el último y a el penúltimo alquiler
limit 1 ; -- Limitamos a una para ver solo el antepenúltimo alquiler

-- Ejercicio 12: películas que no están clasificadas como "NC-17" ni "G"
select f.title as peliculas 
from film f 
where f.rating not in ('NC-17', 'G') ;

-- Ejercicio 13: promedio de duración por clasificación
select 
	c.name as clasificacion, 
	ROUND(AVG(f.length),2) as promedio_duracion
from film f 
inner join film_category fc
	on f.film_id = fc.film_id 
inner join category c 
	on fc.category_id = c.category_id 
group by c.name ;

-- Ejercicio 14: películas con una duración mayor a 180 minutos
select f.title as peliculas 
from film f 
where f.length > 180 ;

-- Ejercicio 15: dinero total generado por la empresa
select SUM(p.amount) || ' €' as total_ingresos
from payment p ;

-- Ejercicio 16: 10 clientes con mayor valor de ID
select 
	c.customer_id,
	concat(c.first_name,' ', c.last_name) as nombre_cliente
from customer c 
order by c.customer_id desc
limit 10 ;

-- Ejercicio 17: nombre completo de actores que aparecen en la película "Egg Igby" 
select concat(a.first_name, ' ', a. last_name) as nombre_actor
from actor a
inner join film_actor fa 
	on a.actor_id = fa.actor_id
inner join film f 
	on fa.film_id = f.film_id
where f.title = 'EGG IGBY' ;

-- Ejercicio 18: nombres de películas únicos
select distinct (f.title) as peliculas_unicas
from film f ;

-- Ejercicio 19: películas que son comedias y tienen una duración mayor a 180 minutos
select f.title as peliculas 
from film f 
inner join film_category fc 
	on f.film_id = fc.film_id 
inner join category c 
	on fc.category_id = c.category_id 
where c.name = 'Comedy' and f.length > 180 ;

-- Ejercicio 20: categorías de películas con un promedio de duración superior a 110 minutos
select 
	c.name as categoria, 
	ROUND(AVG(f.length),2) as promedio_duracion
from film f 
inner join film_category fc
	on f.film_id = fc.film_id 
inner join category c 
	on fc.category_id = c.category_id 
group by c.name
having AVG(f.length) > 110 ;

-- Ejercicio 21: media de duración de alquiler de las películas
select AVG(f.rental_duration) as duracion_media_alquiler
from film f ;

-- Ejercicio 22: columna nombre completo actores y actrices
select CONCAT (a.first_name, ' ', a. last_name) as nombre_actor_completo
from actor a ;

-- Ejercicio 23: números de alquiler por día
select 
	to_char(date_trunc('day', rental_date), 'YYYY-MM-DD') AS fecha_alquiler,
  	COUNT(*) as total_alquileres
from rental r 
group by fecha_alquiler 
order by total_alquileres desc ; -- Ordenamos por cantidad de alquiler de forma descendente

-- Ejercicio 24: películas con duración superior al promedio 
with duracion_media as ( --Creación de la CTE
	select avg (f.length) as promedio --Cálculo de la media de duración de las películas
	from film f 
)
select f.title as peliculas --Selección de la colunma en la que queremos que busque los datos
from film f, duracion_media
where f.length > promedio ; --Condición 

-- Ejercicio 25: número de alquileres registrados por mes 
select 
	to_char(date_trunc ('MONTH', rental_date), 'MM-YY') AS mes_ano,
  	COUNT(*) AS total_alquileres
from rental r 
group by mes_ano  
order by mes_ano desc ;

-- Ejercicio 26: promedio, desviación estándar y varianza del total pagado
select 
	ROUND(AVG(p.amount), 2) as promedio,
	ROUND(STDDEV(p.amount), 2) as desviacion_estandar,
	ROUND(VARIANCE(p.amount), 2) as varianza
from payment p ;

-- Ejercicio 27: ¿qué películas se alquilan por encima del precio medio?
with promedio as (
	select AVG(f.rental_rate) as precio_medio
	from film f 
)
select 
	f.title as peliculas, 
	f.rental_rate as precio_alquiler
from film f  
join promedio 
	on f.rental_rate > precio_medio
order by f.rental_rate ;

-- Ejercicio 28: ID de los actores que han participado en más de 40 películas
select fa.actor_id 
from film_actor fa 
group by fa.actor_id 
having count(*) > 40 ;

-- Ejercicio 29: todas las películas y cantidad disponible en el inventario  
select
	f.title as peliculas,
	count(i.inventory_id) as cantidad_disponible
from film f 
left join inventory i -- Left join para que aparezcan también las películas que no están disponibles en el inventario
	on f.film_id = i.film_id 
group by peliculas  
order by cantidad_disponible ;

-- Ejercicio 30: actores y número de películas en las que han actuado 
select 
	concat (a.first_name, ' ', a.last_name) as nombre_actor, 
	count (fa.film_id) as numero_peliculas
from film_actor fa 
inner join actor a 
	on fa.actor_id = a.actor_id 
group by a.actor_id  
order by numero_peliculas ;

-- Ejercicio 31: todas las películas y actores que han actuado en ellas
select 
	f.title as nombre_pelicula,
	concat(a.first_name, ' ', a.last_name) as nombre_actor
from film f 
left join film_actor fa 
	on f.film_id = fa.film_id 
left join actor a 
	on fa.actor_id = a.actor_id
order by nombre_actor ;
  -- Hay 3 películas que no tienen actores asociados

-- Ejercicio 32: todos los actores y mostrar las películas en las que han actuado
  -- Hacemos lo mismo que en el ejercicio anterior, pero usando el right join, ya que nos piden el contrario
select 
	f.title as nombre_pelicula,
	concat(a.first_name, ' ', a.last_name) as nombre_actor
from film f 
right join film_actor fa 
	on f.film_id = fa.film_id 
right join actor a 
	on fa.actor_id = a.actor_id
order by nombre_actor ;
  -- No hay ningún actor que no haya actuado en alguna película

-- Ejercicio 33: todas las películas y registros de alquiler
select 
	f.title as nombre_pelicula,
	count (r.rental_id) as registros_alquiler
from film f 
left join inventory i 
	on f.film_id = i.film_id 
left join rental r 
	on i.inventory_id = r.inventory_id
group by nombre_pelicula
order by registros_alquiler desc ;

-- Ejercicio 34: 5 clientes que más dinero se han gastado 
select 
	concat (c.first_name, ' ', c.last_name ) as nombre_cliente,
	sum (p.amount) as dinero_gastado
from customer c 
inner join payment p 
	on c.customer_id = p.customer_id 
group by c.customer_id  
order by dinero_gastado desc
limit 5 ;

-- Ejercicio 35: actores cuyo primer nombre es "Johnny"
select concat(a.first_name, ' ', a.last_name) as nombre_actor
from actor a 
where a.first_name in ('JOHNNY') ;

-- Ejercicio 36: renombre de columnas
	-- Para la tabla "actor"
	-- Creación de una vista 
create view nombre_actor as 
select 
	first_name as Nombre,
	last_name as Apellido
from actor a ;
	-- Resultados
select *
from nombre_actor ;
	-- Para la tabla "customer"
	-- Creación de una vista 
create view nombre_cliente as 
select 
	first_name as Nombre,
	last_name as Apellido
from customer c  ;
	-- Resultados
select *
from nombre_cliente ;

-- Ejercicio 37: ID del actor más bajo y más alto
select 
	MIN(a.actor_id) as ID_min,
	MAX(a.actor_id) as ID_max
from actor a ;
	-- El ID de actor más bajo es 1 y el más alto 200

-- Ejercicio 38: ¿cuántos actores hay en la tabla "actor"?
select count(a.actor_id) as numero_actores
from actor a ;
	-- Hay 200 actores en la tabla actor

-- Ejercicio 39: actores ordenados por apellido de forma ascendente
	-- Utilizamos la vista que hemos creado antes 
select *
from nombre_actor na 
order by "Apellido" ;

-- Ejercicio 40: primeras 5 películas de la tabla "film"
select *
from film f 
limit 5 ;

-- Ejercicio 41: agrupación de los actores por su nombre y recuento de los mismos
select 
	na."Nombre",
	count(na."Nombre") as recuento
from nombre_actor na 
group by na."Nombre" 
order by recuento desc ;
	-- Los nombres más repetidos son Kenneth, Penelope y Julia. De cada nombre hay 4 actores 

-- Ejercicio 42: todos los alquileres y nombres de los clientes que los realizaron
select 
	r.rental_id as alquileres,
	concat (c.first_name, ' ', c.last_name ) as nombre_cliente
from rental r 
inner join customer c 
	on r.customer_id = c.customer_id
order by alquileres ;
	
-- Ejercicio 43: todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
	-- Usamos left join para incluir a todos los clientes, incluso si no tienen alquileres
select 
	concat (c.first_name, ' ', c.last_name ) as nombre_cliente,
	r.rental_id as alquileres
from customer c 
left join rental r 
	on c.customer_id = r.customer_id
order by alquileres ;
	-- No hay ningún cliente sin alquileres

-- Ejercicio 44: CROSS JOIN entre las tablas "film y category"
select *
from film f 
cross join category c ;
	-- ¿Aporta valor esta consulta? ¿Por qué?
	 /** Esta consulta no aporta ninguna información valiosa. 
	  Porque no genera la relación real entre película y categoría, 
	  si no todas las posibles combinaciones (muchas de ellas irrelevantes). **/

-- Ejercicio 45: actores que han participado en películas de la categoría "Action"
with actoresaction as (
	select concat(a.first_name, ' ', a.last_name) as nombre_actor_action
	from actor a 
	join film_actor fa on a.actor_id = fa.actor_id
	join film on fa.film_id = film.film_id
	join film_category fc on film.film_id = fc.film_id
	join category c on fc.category_id = c.category_id
	where c.name = 'Action'
)
select *
from actoresaction ;

-- Ejercicio 46: actores que no han participado en películas
select concat(a.first_name, ' ', a.last_name) as nombre_actor_sin
from actor a 
left join film_actor fa 
	on a.actor_id = fa.actor_id
where fa.film_id is null
	-- No hay actores que no hayan participado en películas

-- Ejercicio 47: nombre de los actores y cantidad de películas en las que han participado
with pelis_por_actor as (
	select 
		a.actor_id, 
		concat (a.first_name, ' ', a.last_name) as nombre_actor,
		count (fa.film_id) as num_peliculas
	from actor a 
	left join film_actor fa 
		on a.actor_id = fa.actor_id
	group by a.actor_id 
)
select nombre_actor, num_peliculas 
from pelis_por_actor 
order by num_peliculas ;

-- Ejercicio 48: vista llamada “actor_num_peliculas” que muestre el ejercicio anterior
  -- Creación de la vista
create view actor_num_peliculas as
	-- Misma query del ejercicio anterior
	with pelis_por_actor as (
		select 
			a.actor_id, 
			concat (a.first_name, ' ', a.last_name) as nombre_actor,
			count (fa.film_id) as num_peliculas
		from actor a 
		left join film_actor fa 
			on a.actor_id = fa.actor_id
		group by a.actor_id 
	)
	select nombre_actor, num_peliculas 
	from pelis_por_actor 
	order by num_peliculas ;
  --Resultado
select *
from actor_num_peliculas anp ;

-- Ejercicio 49: número total de alquileres realizados por cada cliente 
select 
	concat (c.first_name, ' ', c.last_name ) as nombre_cliente,
	count (r.rental_id) as num_alquileres
from customer c 
inner join rental r 
	on c.customer_id = r.customer_id
group by nombre_cliente 
order by num_alquileres ;

-- Ejercicio 50: duración total de las películas en la categoría "Action"
select SUM (f.length) as min_pelis_action
from film f 
join film_category fc 
	on f.film_id = fc.film_id 
join category c 
	on fc.category_id = c.category_id
where c.name = 'Action' ;
	-- La duración total de las películas de acción es el 7143 minutos (119 horas y 3 minutos)

-- Ejercicio 51: tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente
  -- Tabla temporal 
create temporary table cliente_rentas_temporal as 
select 
	count (r.rental_id) as alquileres,
	concat (c.first_name, ' ', c.last_name ) as nombre_cliente
from rental r 
inner join customer c 
	on r.customer_id = c.customer_id
group by nombre_cliente ;
  -- Consulta 
select *
from cliente_rentas_temporal ;

-- Ejercicio 52: tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces
  -- Tabla temporal 
create temporary table peliculas_alquiladas as 
select 
	f.title as nombre_peli,
	count (r.rental_id) as num_alquileres
from film f 
inner join inventory i on f.film_id = i.film_id
inner join rental r on i.inventory_id = r.inventory_id
group by f.title 
having count (r.rental_id) >= 10
order by num_alquileres ;
  -- Consulta
select *
from peliculas_alquiladas ;

-- Ejercicio 53: películas que han sido alquiladas por el cliente con el nombre "Tammy Sanders" y que aún no se han devuelto
with alquileres_cliente as ( -- CTE para obtener los alquileres no devueltos del cliente
	select r.inventory_id 
	from rental r 
	join customer c 
		on r.customer_id = c.customer_id 
	where concat(c.first_name, ' ', c.last_name) = 'TAMMY SANDERS' 
	 and r.return_date is null
)
	-- Relacionamos las tablas para sacar los nombres de las películas
select f.title as peliculas_no_devueltas
from alquileres_cliente
join inventory i 
	on alquileres_cliente.inventory_id = i.inventory_id
join film f 
	on i.film_id = f.film_id
order by f.title ;

-- Ejercicio 54: nombres de los actores que han actuado en al menos una película de la categoría "Sci-Fi"
select 
	a.first_name as nombre,
	a.last_name as apellido
from actor a 
where exists (
	select 1 
	from film_actor fa 
	inner join film_category fc 
		on fa.film_id = fc.film_id
	inner join category c
		on fc.category_id = c.category_id 
	where a.actor_id = fa.actor_id 
	 and c.name = 'Sci-Fi'
)
order by apellido ;

-- Ejercicio 55: nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película "Spartacus Cheaper" se alquilara por primera vez
 -- 1º buscamos cuando se alquiló la película "Spartacus Cheaper" por primera vez con un CTE 
with primera_fecha_spartacus as (
    select min (r.rental_date) as fecha
    from film f
    join inventory i
    	on f.film_id = i.film_id
    join  rental r
    	on i.inventory_id = r.inventory_id
    where f.title = 'SPARTACUS CHEAPER'
)
  -- Buscamos el nombre de los actores que han actuado en películas alquiladas después de la fecha encontrada en el CTE 
select distinct
    a.first_name AS nombre_actor,
    a.last_name AS apellido_actor
from primera_fecha_spartacus p
join rental r 
	on r.rental_date > p.fecha
join inventory i	
	on r.inventory_id = i.inventory_id
join film_actor fa
	on i.film_id = fa.film_id
join actor a
	on fa.actor_id = a.actor_id
order by apellido_actor ; -- Ordenamos por apellido


-- Ejercicio 56: nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Music"
with actores_no_music as (
	select concat(a.first_name, ' ', a.last_name) as nombre_actor
	from actor a 
	where not exists (
		select 1
		from film_actor fa 
		join film_category fc on fa.film_id = fc.film_id
		join category c on fc.category_id = c.category_id
		where fa.actor_id = a.actor_id 
		 and c.name = 'Music'
	)
)
select *
from actores_no_music 
group by nombre_actor ;

-- Ejercicio 57: todas las películas que fueron alquiladas por más de 8 días
select distinct f.title as peliculas
from film f 
inner join inventory i 
	on f.film_id = i.film_id 
inner join rental r 
	on i.inventory_id = r.inventory_id
where extract(day from(r.return_date - r.rental_date)) > 8 ;

-- Ejercicio 58: título de las películas de la categoría "Animation"
select f.title peliculas_animacion 
from film f 
inner join film_category fc 
	on f.film_id = fc.film_id
inner join category c 
	on fc.category_id = c.category_id
where c.name = 'Animation'
order by f.title ;

-- Ejercicio 59: nombres de las películas que tienen la misma duración que la película con el título "Dancing Fever"
select distinct f.title as peliculas
from film f 
where f.length = (
	select f2.length 
	from film f2  
	where title = 'DANCING FEVER'
) ;

-- Ejercicio 60: clientes que han alquilado al menos 7 películas distintas
select 
	c.first_name as nombre_cliente,
	c.last_name as apellido_cliente
from customer c
inner join rental r 
	on c.customer_id = r.customer_id
inner join inventory i 
	on r.inventory_id = i.inventory_id 
group by c.customer_id 
having count(distinct i.film_id) >= 7 -- Usamos el film_id para contar el número de películas distintas y filtramos
order by apellido_cliente ; -- Ordenamos por apellido

-- Ejercicio 61: cantidad total de películas alquiladas por categoría
select 
	c.name as categoria,
	count (r.rental_id) as cantidad_alquileres
from category c 
inner join film_category fc 
	on c.category_id = fc.category_id
inner join inventory i 
	on fc.film_id = i.film_id
inner join rental r 
	on i.inventory_id = r.inventory_id
group by categoria
order by cantidad_alquileres ;

-- Ejercicio 62: número de películas por categoría estrenadas en 2006
select 
	c.name as categoria,
	count (f.film_id) as num_pelis_estrenadas
from film f 
inner join film_category fc 
	on f.film_id = fc.film_id
inner join category c 
	on fc.category_id = c.category_id
where f.release_year = '2006'
group by categoria ;

-- Ejercicio 63: todas las combinaciones posibles de trabajadores con las tiendas
	-- Hacemos un cross join 
select 
	concat (s.first_name, ' ', s.last_name) as nombre_trabajador,
	s2.store_id as tienda_id
from staff s 
cross join store s2 ;

-- Ejercicio 64: cantidad total de películas alquiladas por cada cliente
select 
	c.customer_id as id_cliente,
	c.first_name as nombre_cliente,
	c.last_name as apellido_cliente,
	count (r.rental_id) as num_pelis_alquiladas
from customer c 
inner join rental r 
	on c.customer_id = r.customer_id
group by c.customer_id, c.first_name, c.last_name 
order by num_pelis_alquiladas ;