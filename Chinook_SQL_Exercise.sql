
-- Item 1: Name and Composer from tracks, first 5 rows
SELECT t.Name, t.Composer
FROM tracks t
LIMIT 5;

-- Item 2: Customers from Germany
SELECT c.FirstName, c.LastName, c.City
FROM customers c
WHERE c.Country = 'Germany';

-- Item 3: Album titles, Z to A, top 5
SELECT a.Title
FROM albums a
ORDER BY a.Title DESC
LIMIT 5;

-- Item 4: Number of customers per support rep
SELECT c.SupportRepId, COUNT(*) AS NumCustomers
FROM customers c
GROUP BY c.SupportRepId
ORDER BY NumCustomers DESC;

-- Item 5: Average track price per genre, top 5
SELECT t.GenreId, AVG(t.UnitPrice) AS AvgPrice
FROM tracks t
GROUP BY t.GenreId
ORDER BY AvgPrice DESC
LIMIT 5;


-- Item 6: Number of tracks per genre, top 5
SELECT g.Name, COUNT(t.TrackId) AS NumTracks
FROM genres g
JOIN tracks t
    ON g.GenreId = t.GenreId
GROUP BY g.GenreId
ORDER BY NumTracks DESC
LIMIT 5;

-- Item 7: Track, album and artist names, first 10 rows
SELECT
    t.Name AS TrackName,
    a.Title AS AlbumTitle,
    ar.Name AS ArtistName
FROM tracks t
JOIN albums a
    ON t.AlbumId = a.AlbumId
JOIN artists ar
    ON a.ArtistId = ar.ArtistId
LIMIT 10;

-- Item 8: Every invoice line billed to CustomerId 5
SELECT
    c.FirstName,
    c.LastName,
    t.Name AS TrackName,
    ii.Quantity,
    ii.UnitPrice
FROM customers c
JOIN invoices i
    ON c.CustomerId = i.CustomerId
JOIN invoice_items ii
    ON i.InvoiceId = ii.InvoiceId
JOIN tracks t
    ON ii.TrackId = t.TrackId
WHERE c.CustomerId = 5
ORDER BY ii.InvoiceLineId ASC;

-- Item 9: Number of tracks in each playlist
-- LEFT JOIN keeps playlists with 0 tracks
SELECT p.Name, COUNT(pt.TrackId) AS NumTracks
FROM playlists p
LEFT JOIN playlist_track pt
    ON p.PlaylistId = pt.PlaylistId
GROUP BY p.PlaylistId
ORDER BY NumTracks DESC;

-- Item 10: Revenue per country from invoice line items, top 5
SELECT
    c.Country,
    SUM(ii.UnitPrice * ii.Quantity) AS Revenue
FROM customers c
JOIN invoices i
    ON c.CustomerId = i.CustomerId
JOIN invoice_items ii
    ON i.InvoiceId = ii.InvoiceId
GROUP BY c.Country
ORDER BY Revenue DESC
LIMIT 5;


-- Item 11: Total spent per customer, using a subquery in SELECT
SELECT
    c.FirstName,
    c.LastName,
    (
        SELECT SUM(i.Total)
        FROM invoices i
        WHERE i.CustomerId = c.CustomerId
    ) AS TotalSpent
FROM customers c
ORDER BY TotalSpent DESC
LIMIT 5;

-- Item 12: Tracks priced above the average, using a subquery in WHERE
SELECT t.Name, t.UnitPrice
FROM tracks t
WHERE t.UnitPrice > (
    SELECT AVG(t2.UnitPrice)
    FROM tracks t2
);

-- Item 13: Top 3 genres by revenue, using a CTE
WITH GenreRevenue AS (
    SELECT
        g.Name AS GenreName,
        SUM(ii.UnitPrice * ii.Quantity) AS Revenue
    FROM invoice_items ii
    JOIN tracks t
        ON ii.TrackId = t.TrackId
    JOIN genres g
        ON t.GenreId = g.GenreId
    GROUP BY g.GenreId
)
SELECT GenreName, Revenue
FROM GenreRevenue
ORDER BY Revenue DESC
LIMIT 3;

-- Item 14: Artists with no albums, using NOT IN
SELECT ar.ArtistId, ar.Name
FROM artists ar
WHERE ar.ArtistId NOT IN (
    SELECT al.ArtistId
    FROM albums al
);

-- Item 15: Customers whose revenue is above the average customer
WITH CustomerRevenue AS (
    SELECT
        c.CustomerId,
        c.FirstName,
        c.LastName,
        SUM(ii.UnitPrice * ii.Quantity) AS Revenue
    FROM customers c
    JOIN invoices i
        ON c.CustomerId = i.CustomerId
    JOIN invoice_items ii
        ON i.InvoiceId = ii.InvoiceId
    GROUP BY c.CustomerId
)
SELECT FirstName, LastName, Revenue
FROM CustomerRevenue
WHERE Revenue > (SELECT AVG(Revenue) FROM CustomerRevenue)
ORDER BY Revenue DESC;
