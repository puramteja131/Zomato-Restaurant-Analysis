CREATE DATABASE zomato_analysis;
USE zomato_analysis;

-- Query 1: Total number of restaurants
SELECT COUNT(*) AS total_restaurants 
FROM zomato_restaurants;

-- Query 2: Top 10 locations with most restaurants
SELECT location, COUNT(*) AS restaurant_count
FROM zomato_restaurants
GROUP BY location
ORDER BY restaurant_count DESC
LIMIT 10;

-- Query 3: Average rating by location (Top 10)
SELECT location, 
       ROUND(AVG(rate), 2) AS avg_rating,
       COUNT(*) AS total_restaurants
FROM zomato_restaurants
GROUP BY location
HAVING COUNT(*) > 50
ORDER BY avg_rating DESC
LIMIT 10;

-- Query 4: Online order impact on ratings
SELECT online_order, 
       ROUND(AVG(rate), 2) AS avg_rating,
       COUNT(*) AS total_restaurants,
       ROUND(AVG(`approx_cost(for two people)`), 0) AS avg_cost
FROM zomato_restaurants
GROUP BY online_order;

-- Query 5: Top cuisines with highest average rating
SELECT cuisines,
       COUNT(*) AS total,
       ROUND(AVG(rate), 2) AS avg_rating,
       ROUND(AVG(`approx_cost(for two people)`), 0) AS avg_cost
FROM zomato_restaurants
GROUP BY cuisines
HAVING COUNT(*) > 100
ORDER BY avg_rating DESC
LIMIT 10;

-- Query 6: Restaurant type analysis
SELECT rest_type,
       COUNT(*) AS total,
       ROUND(AVG(rate), 2) AS avg_rating,
       ROUND(AVG(`approx_cost(for two people)`), 0) AS avg_cost
FROM zomato_restaurants
GROUP BY rest_type
ORDER BY total DESC
LIMIT 10;

-- Query 7: Premium restaurants (high cost + high rating)
SELECT name, location, rate, 
       `approx_cost(for two people)` AS cost,
       votes
FROM zomato_restaurants
WHERE rate >= 4.5 
AND `approx_cost(for two people)` >= 1000
ORDER BY rate DESC, votes DESC
LIMIT 10;

-- Query 8: Budget gems (low cost + high rating)
SELECT name, location, rate,
       `approx_cost(for two people)` AS cost,
       votes
FROM zomato_restaurants
WHERE rate >= 4.0
AND `approx_cost(for two people)` <= 300
ORDER BY rate DESC, votes DESC
LIMIT 10;

-- Query 9: Book table impact analysis
SELECT book_table,
       ROUND(AVG(rate), 2) AS avg_rating,
       ROUND(AVG(`approx_cost(for two people)`), 0) AS avg_cost,
       COUNT(*) AS total
FROM zomato_restaurants
GROUP BY book_table;

-- Query 10: Most competitive locations
SELECT location,
       COUNT(*) AS total_restaurants,
       ROUND(AVG(rate), 2) AS avg_rating,
       ROUND(AVG(`approx_cost(for two people)`), 0) AS avg_cost,
       MAX(votes) AS highest_votes
FROM zomato_restaurants
GROUP BY location
HAVING COUNT(*) > 100
ORDER BY total_restaurants DESC
LIMIT 10;

-- Query 11: Row number restaurants by rating within each location
SELECT name, location, rate, votes,
       ROW_NUMBER() OVER (PARTITION BY location ORDER BY rate DESC) AS row_num
FROM zomato_restaurants
WHERE votes > 100
ORDER BY location, row_num
LIMIT 20;

-- Query 12: Running total of restaurants by location
SELECT location,
       COUNT(*) AS restaurant_count,
       SUM(COUNT(*)) OVER (ORDER BY COUNT(*) DESC) AS running_total
FROM zomato_restaurants
GROUP BY location
ORDER BY restaurant_count DESC
LIMIT 10;

-- Query 13: Compare each restaurant rating vs location average
SELECT name, location, rate,
       ROUND(AVG(rate) OVER (PARTITION BY location), 2) AS location_avg_rating,
       ROUND(rate - AVG(rate) OVER (PARTITION BY location), 2) AS diff_from_avg
FROM zomato_restaurants
WHERE votes > 50
ORDER BY diff_from_avg DESC
LIMIT 15;
