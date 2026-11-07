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
