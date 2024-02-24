ЗАДАНИЕ 1
-- Добавим жанры
INSERT INTO genre (name) VALUES
	('classic rock'), 
	('alternative rock'), 
	('pop'), 
	('edm'), 
	('drum and bass');

-- Добавим исполнителей.
INSERT INTO artist (name) VALUES 
	('Queen'), 
	('Papa Roach'), 
	('Scooter'), 
	('Pendulum'), 
	('Knife party'), 
	('Modern Talking');

-- Добавим альбомы
INSERT INTO album (name, year) VALUES
	('No time to chill', 1997), 
	('The age of love', 1996), 
	('The Connection', 2012), 
	('Getting Away with Murder', 2004), 
	('Back for good', 1998), 
	('Immersion', 2011), 
	('Alandon ship', 2014),
	('News of the world', 1977);

-- проверим таблицу альбомов, чтобы узнать их id для вненсения данных в таблицу треки
SELECT id, name, year from album;

-- Добавим треки
INSERT INTO track (album_id, name, duration) VALUES
	(1, 'How much is the fish', '00:03:00'), 
	(2, 'Fire', '00:02:45'), 
	(3, 'Walking Dead', '00:03:18'), 
	(4, 'Getting Away with Murder', '00:03:12'), 
	(5, 'You are my heart', '00:02:35'), 
	(6, 'Crush', '00:03:10'), 
	(7, 'Superstar', '00:04:10'),
	(8, 'We will rock you', '00:03:10');


-- Добавим сборники
INSERT INTO collection (name, year) VALUES 
	('Drum and bass collection', 2015), 
	('EDM HITS', 2020), 
	('ROCK HITS', 2015),
	('POP HITS', 2010);


-- Связь исполнителей и альбомов
-- 1-й способ - добавим связь, используя выборку по названию из таблиц альбомов и исполнителей
INSERT INTO albumartist (album_id, artist_id)
SELECT album.id, artist.id
FROM album, artist
WHERE album.name LIKE 'No%' AND artist.name LIKE 'Sco%';

-- Сделаем выборку, выполнив объединение таблиц исполнителей и альбомов
SELECT album.id, album.name, artist.name, artist.id 
FROM album FULL JOIN artist ON album.id = artist.id;

-- 2-й способ - добавим связь, используя id альбомов и исполнителей
INSERT INTO albumartist (album_id, artist_id) VALUES
	(2, 3), 
	(3, 2),
	(4, 2),
	(5, 6),
	(6, 4),
	(7, 5),
	(8, 1);

-- Cвязь жанров и исполнителей
-- Сделаем выборку, выполнив объединение таблиц анров и исполнителей
SELECT genre.id, genre.name, artist.name, artist.id 
FROM genre FULL JOIN artist ON genre.id = artist.id 

INSERT INTO genreartist (genre_id, artist_id) VALUES
	(1, 1), 
	(2, 2),
	(4, 3),
	(5, 4),
	(4, 5),
	(3, 6);

-- Cвязь треков и сборников
-- Сделаем выборку, выполнив объединение треков и сборников
SELECT track.id, track.name, collection.name, collection.id
FROM track FULL JOIN collection ON collection.id = track.id

INSERT INTO trackcollection (track_id, collection_id) VALUES
	(1, 2), 
	(2, 2),
	(3, 3),
	(4, 3),
	(5, 4),
	(6, 1),
	(7, 2),
	(8, 3);


-- ЗАДАНИЕ 2.
-- Название и продолжительность самого длительного трека.
SELECT name, duration from track
WHERE duration = (SELECT MAX(duration) FROM  track);

-- Название треков, продолжительность которых не менее 3,5 минут.
SELECT name, duration from track
WHERE duration < '00:03:30';

-- Название сборников, вышедших с 2018 по 2020 год включительно
SELECT name FROM collection c 
WHERE year BETWEEN 2018 AND 2020; 

-- Исполнители, чье имя состоит из одного слова
SELECT name FROM artist
WHERE CARDINALITY(STRING_TO_ARRAY(name, ' ')) = 1;

-- Название треков, которые содержат слово 'мой' или 'my'
SELECT LOWER(name) FROM track t
WHERE name LIKE '%my%' or name LIKE '%мой%';


-- ЗАДАНИЕ 3
-- Количество исполнителей в каждом жанре
SELECT genre.name, COUNT(artist_id) artist_q FROM genre
LEFT JOIN genreartist ON genre.id = genreartist.genre_id
GROUP BY genre.name
ORDER BY artist_q

-- Количество треков, вошедших в альбомы 2019-2020 годов
UPDATE album
SET year = 2020
WHERE id = 7;

UPDATE album
SET year = 2019
WHERE id = 6;

UPDATE collection
SET year = 2020
WHERE LOWER(name) LIKE 'rock%';

UPDATE collection
SET year = 2020
WHERE LOWER(name) LIKE 'drum%';

--SELECT id, name, year FROM collection ORDER BY id;
SELECT COUNT(track.id) track_q FROM track
LEFT JOIN album ON album.id = track.album_id
WHERE year BETWEEN 2019 AND 2020;

-- Средняя продолжительность треков по каждому альбому
SELECT album.name album_name, track.name track_name, AVG(duration) FROM track
LEFT JOIN album ON track.album_id = album.id
GROUP BY album.name, track.name
ORDER BY AVG(duration);

-- Все исполнители которые не выпустили альбомы в 2020 году
SELECT artist.name artist_name FROM artist
LEFT JOIN albumartist ON albumartist.artist_id = artist.id
left JOIN album ON album.id = albumartist.album_id
WHERE album.year < 2020
GROUP BY artist.name;

-- Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами)
SELECT collection.name FROM collection
JOIN trackcollection ON trackcollection.collection_id = collection.id
JOIN track ON track.id = trackcollection.track_id
JOIN album ON album.id = track.album_id
JOIN albumartist ON albumartist.album_id = album.id
JOIN artist ON artist.id = albumartist.artist_id
WHERE artist.name = 'Pendulum';