/*******************************************************************************
   Listar las pistas (tabla Track) con precio mayor o igual a 1€*
********************************************************************************/

SELECT * 
FROM Track
WHERE UnitPrice >= 1;

/*******************************************************************************
   Listar las pistas de más de 4 minutos de duración
********************************************************************************/

SELECT * 
FROM Track
WHERE Milliseconds > 240000;

/*******************************************************************************
   Listar las pistas que tengan entre 2 y 3 minutos de duración
********************************************************************************/

SELECT * 
FROM Track
WHERE Milliseconds BETWEEN 120000 AND 180000;

/*******************************************************************************
   Listar las pistas que uno de sus compositores (columna Composer) sea Mercury
********************************************************************************/

SELECT * 
FROM Track
WHERE Composer LIKE '%Mercury%';

/*******************************************************************************
   Calcular la media de duración de las pistas (Track) de la plataforma
********************************************************************************/

SELECT AVG(Milliseconds)
FROM Track;

/*******************************************************************************
   Listar los clientes (tabla Customer) de USA, Canada y Brazil
********************************************************************************/

SELECT *
FROM Customer
WHERE Country IN ('USA','Canada','Brazil');

/*******************************************************************************
  Listar todas las pistas del artista 'Queen' (Artist.Name = 'Queen')
********************************************************************************/

SELECT *
FROM Track T
INNER JOIN (
    SELECT A.AlbumId
    FROM Album A
    INNER JOIN (
        SELECT ArtistId
        FROM Artist A
        WHERE A.Name = 'Queen'
    ) AS AR
    ON A.ArtistId = AR.ArtistId
) AS AA 
ON T.AlbumId = AA.Albumid;

/*******************************************************************************
  Listar las pistas del artista 'Queen' en las que haya participado como compositor David Bowie
********************************************************************************/

SELECT *
FROM Track T
INNER JOIN (
    SELECT A.AlbumId
    FROM Album A
    INNER JOIN (
        SELECT ArtistId
        FROM Artist A
        WHERE A.Name = 'Queen'
    ) AS AR
    ON A.ArtistId = AR.ArtistId
) AS AA 
ON T.AlbumId = AA.Albumid
WHERE Composer LIKE '%Bowie%';

/*******************************************************************************
  Listar las pistas de la playlist 'Heavy Metal Classic'
********************************************************************************/

SELECT *
FROM Track T
INNER JOIN (
    SELECT PLT.TrackId
    FROM PlaylistTrack PLT
    INNER JOIN (
        SELECT PL.PlaylistId
        FROM Playlist PL
        WHERE PL.Name = 'Heavy Metal Classic'
    ) AS PLAY
    ON PLAY.PlaylistId = PLT.PlaylistId
) AS TID 
ON TID.TrackId = T.TrackId;

/*******************************************************************************
  Listar las playlist junto con el número de pistas que contienen
********************************************************************************/

SELECT DISTINCT P.Name, PR.Recuento
FROM Playlist P
INNER JOIN (
    SELECT PL.PlaylistId , COUNT(*) as Recuento
    FROM PlaylistTrack PL
    INNER JOIN  Track T
    ON T.TrackId = PL.TrackId
    GROUP BY PL.PlaylistId
) as PR
ON P.PlaylistId = PR.PlaylistId

/*******************************************************************************
  Listar las playlist (sin repetir ninguna) que tienen alguna canción de AC/DC
********************************************************************************/

SELECT DISTINCT P.Name
FROM Playlist P
INNER JOIN(
    SELECT DISTINCT PLT.PlaylistId
    FROM PlaylistTrack PLT
    INNER JOIN (  
        SELECT T.TrackId
        FROM Track T
        INNER JOIN (
            SELECT AL.AlbumId
            FROM Album AL
            INNER JOIN (
                SELECT A.ArtistId
                FROM Artist A
                WHERE A.Name = 'AC/DC'
            )AS AI
            ON AI.ArtistId = AL.ArtistId
        ) AS AAI
        ON AAI.AlbumId = T.AlbumId
    )AS TAAI
    ON PLT.TrackId = TAAI.TrackId
)AS  PLTTAAI
ON P.PlaylistId = PLTTAAI.PlaylistId


/*******************************************************************************
  Listar las playlist que tienen alguna canción del artista Queen, junto con la cantidad que tienen
********************************************************************************/

SELECT DISTINCT P.Name,Cantidad
FROM Playlist P
INNER JOIN(
    SELECT PLT.PlaylistId, COUNT(*) as Cantidad
    FROM PlaylistTrack PLT
    INNER JOIN (
        SELECT T.TrackId
        FROM Track T
        INNER JOIN (
            SELECT AL.AlbumId
            FROM Album AL
            INNER JOIN (
                SELECT A.ArtistId
                FROM Artist A
                WHERE A.Name = 'Queen'
            )AS AI
            ON AI.ArtistId = AL.ArtistId
        ) AS AAI
        ON AAI.AlbumId = T.AlbumId
    )AS TAAI
    ON PLT.TrackId = TAAI.TrackId
    GROUP BY PLT.PlaylistId
)AS  PLTTAAI
ON P.PlaylistId = PLTTAAI.PlaylistId

/*******************************************************************************
  Listar las pistas que no están en ninguna playlist
********************************************************************************/

SELECT T.Name
    FROM Track T
    LEFT JOIN PlaylistTrack PL
    ON T.TrackId = PL.TrackId
    WHERE PL.TrackId IS NULL

/*******************************************************************************
  Listar los artistas que no tienen album
********************************************************************************/

SELECT A.Name
    FROM Artist A
    LEFT JOIN Album AL
    ON A.ArtistId = AL.ArtistId
    WHERE AL.ArtistId IS NULL

/*******************************************************************************
  Listar los artistas con el número de albums que tienen
********************************************************************************/

SELECT DISTINCT A.Name,Cantidad
FROM Artist A
INNER JOIN(
    SELECT DISTINCT AL.ArtistId, COUNT(*) as Cantidad
    FROM Album AL
    GROUP BY Al.ArtistId
    ) AS AAL
    ON A.ArtistId = AAL.ArtistId
