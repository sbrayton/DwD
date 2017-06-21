/*
    MySQL Workbench Synchronization
    Generated: 2017-06-18 16:33
    Project: DwD Assignment 04 Post Module Part 2: SQL Queries
    Author: Shameka Brayton
*/

/* 1.	Find how many actors are stored in the actors table. 	*/
SELECT count((id)) FROM imdb.actors;

/*2.	Find all information for actor with id 376249.	*/
SELECT * FROM imdb.actors where id = 376249;

/*3.	Find all the actors that played in the movie Ocean's Twelve.	*/

SELECT  
	 `actors`.`first_name`
    ,`actors`.`last_name`
    ,`actors`.`gender`
    , `movies`.`name`
    ,`movies`.`year`
    ,roles.`role`
FROM `imdb`.`roles`
inner join `imdb`.`actors` as actors on roles.`actor_id` = actors.`id`
inner join `imdb`.`movies` as movies on roles.`movie_id` = movies.`id`
and movies.`id` in (SELECT `movies`.`id` FROM `imdb`.`movies` where `movies`.`name` like 'Ocean%Twelve%')
;

/*4.	Find all the movies that have the word "Vietnam" in their title.	*/
SELECT `movies`.`id`,
    `movies`.`name`,
    `movies`.`year`,
    `movies`.`rank`
FROM `imdb`.`movies`
where lower(`name`) like '%vietnam%';

/*5.	Find the number of movies that each actor has played. Show just the actor id and the number of movies.	*/
SELECT  
	 `roles`.`actor_id`
     ,count(movie_id) as 'count of Movies / Actor'
FROM `imdb`.`roles`
group by `roles`.`actor_id`;

/*6.	Find the number of actors for each movie. Show just the movie id and the number of actors in the movie.	*/
SELECT  
	 `roles`.`movie_id`
     ,count(`actor_id`) as 'count of Actors / Movie'
FROM `imdb`.`roles`
group by `roles`.`movie_id`;

/*7.	Find the time period in which each actor was active,
 by listing the earliest and the latest year in which the actor starred in a film.
	*/


select a.`actor_id`
    ,min(a.`year`) as 'Earliest role'
    ,max(a.`year`) as 'Most recent role'
    ,max(a.`year`) - min(a.`year`) as 'Years Active'
from(
	select `actor_id`, `movie_id`, `year`
	from `imdb`.`roles` 
	inner join `imdb`.`movies` as movies on roles.`movie_id` = movies.`id`
	order by `year`
) as a
group by `a`.`actor_id`;
;

/*8.	Repeat the query above, but only list actors that have starred in at least 10 movies.	*/

select a.`actor_id`
    ,min(a.`year`) as 'Earliest role'
    ,max(a.`year`) as 'Most recent role'
    ,max(a.`year`) - min(a.`year`) as 'Years Active'
    ,count(`movie_id`) as 'count of Movies / Actor'
from(
	select `actor_id`, `movie_id`, `year`
	from `imdb`.`roles` 
	inner join `imdb`.`movies` as movies on roles.`movie_id` = movies.`id`
	order by `year`
) as a
group by `a`.`actor_id`
having `count of Movies / Actor`>=10;


/*9.	Find the director that has directed the largest number of movies.	*/

        SELECT director_id into @myvar

        FROM imdb.movies_directors
        group by director_id
        order by count(movie_id)  DESC
        limit 1;
         
        SELECT * from `imdb`.`directors` md
        where  md.`id` =@myvar;

/*	List the director that worked with the largest number of actors 	*/

SELECT  
`roles`.`movie_id` into @myvar
FROM `imdb`.`roles`
group by `roles`.`movie_id`
order by count(`actor_id`) desc
limit 1
;

SELECT * from `imdb`.`movies_directors` md
inner join `imdb`.`directors` d on d.`id` = md.`director_id`
where md.`movie_id`=@myvar;


