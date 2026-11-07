# SQL Learning Journal #2
Reflecting on what I learned using SQL for the Chinook database.

## Section 1: What I Learned
I learned about `SELECT` with `WHERE`, and `ORDER BY` for filtering the data. For aggregation, I learned about `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`, `GROUP BY` and `HAVING`, while for joins across two and three tables I learned about `INNER JOIN` and `LEFT JOIN`. And for subqueries and CTEs I learned about using `WITH` and using parenthesis to create a query inside a query. Lastly, for `CREATE`, `INSERT`, `UPDATE`, and `DELETE` are use to add, modify, or delete a column, data, or a table.
The difference between `WHERE` and `HAVING` is that `WHERE` filters rows before grouping and `HAVING` are use to filter the groups (after `GROUP BY`).

## Section 2: A Query I Am Proud Of
From one of our example exercises where we want to know which tracks are longer than their own album’s average?
```sql
SELECT
    t.Name AS TrackName,
    a.Title AS AlbumName,
    t.Milliseconds
FROM tracks t
JOIN albums a
    ON a.AlbumId = t.AlbumId
WHERE t.Milliseconds > (
    SELECT AVG(t2.Milliseconds)
    FROM tracks t2
    WHERE t2.AlbumId = t.AlbumId
);
```

This is what this query does:
1. `FROM` tracks t `JOIN` albums a connects each track to its album through AlbumId, so I can show the album title instead of just an ID.
2. `WHERE` checks every track one at a time. For each one, the subquery runs and calculates the average length of only the tracks on that same album.
3. The line `WHERE` t2.AlbumId = t.AlbumId is what makes it correlated. The t refers to the current track in the outer query, so each album gets its own average. At first I wrote a comment saying this came “from the `GROUP BY` above,” but it actually comes from the outer row.
4. `SELECT` returns the track name, album name, and length for tracks that passed the test.

The business question is: “On each album, which tracks run longer than usual for that album?” For a manager, the result shows each album’s standout long tracks, which could be used for “extended version” playlists or to flag tracks that need a radio edit.

## Section 3: A Mistake or Struggle
In our CTE exercise, I wanted the 5 genres that generate the most revenue. I built three CTEs (TrackTable, GenreTable, InvoiceTable) and joined them:
```sql
SELECT gt.Genre, SUM(it.Revenue) AS TotalRevenue
FROM GenreTable gt
JOIN TrackTable tt ON gt.GenreId = tt.GenreId
JOIN InvoiceTable it ON it.TrackId = it.TrackId
GROUP BY gt.Genre
ORDER BY TotalRevenue DESC
LIMIT 5;
```
There was no error, but the numbers were impossible. Rock genre showed about $3,020,194 in revenue, while the whole store’s invoices only add up to $2,328.60.
The cause was my join condition: it.TrackId = it.TrackId compares a column to itself, so it is always true. Instead of matching each track to its own sales, every track was matched to every row of InvoiceTable, and the sums exploded. It even changed the ranking: Jazz appeared in the top 5 when it should not.
The fix was one letter:
```sql
JOIN InvoiceTable it ON it.TrackId = tt.TrackId
```
Now Rock shows $826.65, and the fifth genre is TV Shows ($93.53), not Jazz.
I caught it because the whole store only made $2,328.60, so I reread my `ON` clauses and found it on both sides. Next time, I will make sure every `ON` clause compares two different aliases and check big totals against a simple query.

## Section 4: Connecting to the Real World
A food delivery app like Foodpanda or GrabFood could answer many questions with SQL. 
One is which restaurants earned the most last month in each city, which needs the orders, restaurants, and cities tables joined together, a `WHERE` on the order date, `GROUP BY` restaurant, a `SUM` of order totals, and RANK() partitioned by city.
I think SQL is still widely used because almost every company keeps its data in a database.

## Section 5: Self-Assessment

| Topic | 1 | 2 | 3 | 4 | 5 |
| --- | :---: | :---: | :---: | :---: | :---: |
| Basic SELECT, WHERE, ORDER BY | | | | | X |
| Aggregation (COUNT, SUM, AVG, GROUP BY, HAVING) | | | | X | |
| Joins (2 tables) | | | | | X |
| Joins (3 or more tables) | | | | X | |
| Subqueries | | | | X | |
| CTEs (WITH) and window functions | | | X | | |
| CREATE, INSERT, UPDATE, DELETE | | | X | | |
