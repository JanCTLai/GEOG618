-- !preview conn=DBI::dbConnect(RSQLite::SQLite())
--exercise2.1.1

CREATE TABLE ex_2_1_1 

AS
WITH results AS (
SELECT seq, edge AS gid, cost FROM pgr_dijkstra(
  '
   SELECT gid AS id,
        source,
        target,
        length AS cost
      FROM ways
    ',
 13343,
 3218,
    directed := false)
  )
SELECT
  results.*,
  the_geom AS route_2_1_1
FROM results
LEFT JOIN ways
  USING (gid)
ORDER BY seq;



--Exercise 2.1.2
CREATE TABLE ex_2_1_2 

AS
WITH results AS (
SELECT seq, edge AS gid, cost As length_m FROM pgr_dijkstra(
  '
   SELECT gid AS id,
        source,
        target,
        length_m AS cost
      FROM ways
    ',
ARRAY[3218,25723],
8308,
directed := false)
  )
SELECT
  results.*,
  the_geom AS route_2_1_2
FROM results
LEFT JOIN ways
  USING (gid)
ORDER BY seq;

--Exercise 2.1.3
CREATE TABLE ex_2_1_3

AS
WITH results AS (
SELECT seq, edge AS gid, cost As length_m FROM pgr_dijkstra(
  '
   SELECT gid AS id,
        source,
        target,
        length_m / 1.3 AS cost
      FROM ways
    ',
3218,
ARRAY[25723,8308],
directed := false)
  )
SELECT
  results.*,
  the_geom AS route_2_1_3
FROM results
LEFT JOIN ways
  USING (gid)
ORDER BY seq;

--Exercise 3.1.1



CREATE TABLE ex_3_1_1 

AS
WITH results AS (
SELECT seq, edge AS gid, cost FROM pgr_dijkstra(
  '
   SELECT gid AS id,
    source,
    target,
    cost,
    reverse_cost
  FROM ways
  ',
13343,
8308,
directed := true)
  )
SELECT
  results.*,
  the_geom AS route_3_1_1
FROM results
LEFT JOIN ways
  USING (gid)
ORDER BY seq;

--Exercise_3_1_2

CREATE TABLE ex_3_1_2 
AS
WITH results AS (
SELECT seq, edge AS gid, cost FROM pgr_dijkstra(
  '
   SELECT gid AS id,
    source,
    target,
    cost,
    reverse_cost
  FROM ways
  ',
8308,
13343,
directed := true)
  )
SELECT
  results.*,
  the_geom AS route_3_1_2
FROM results
LEFT JOIN ways
  USING (gid)
ORDER BY seq;

--exercise 3.1.3
CREATE TABLE ex_3_1_3 
AS
WITH results AS (
SELECT seq, edge AS gid, cost FROM pgr_dijkstra(
  '
SELECT gid AS id,
      source,
      target,
      cost_s / 3600 * 100 AS cost,
      reverse_cost_s / 3600 * 100 AS reverse_cost
    FROM ways
  ',
8308,
13343)
  )
SELECT
  results.*,
  the_geom AS route_3_1_3
FROM results
LEFT JOIN ways
  USING (gid)
ORDER BY seq;

--QUESTION 4 
--Write a simple sql query to find the closest node id to a point from a lat and lng value
--TheCambridge Armoury ('-80.3133476','43.3579909') is chosen as our POI

ALTER TABLE ways_vertices_pgr ADD COLUMN geom geometry(Point, 4326);
UPDATE ways_vertices_pgr SET geom = ST_SetSRID(ST_MakePoint(ways_vertices_pgr.lon, ways_vertices_pgr.lat), 4326);

SELECT 
     id, osm_id, geom, lon, lat
FROM 
     ways_vertices_pgr
ORDER BY ways_vertices_pgr.geom <-> ST_SetSRID(ST_MakePoint('-80.3133476','43.3579909')::geometry, 4326)
LIMIT 1

