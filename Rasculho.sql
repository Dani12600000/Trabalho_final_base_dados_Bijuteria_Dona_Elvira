CREATE TABLE pontos (
	quantidade INT NOT NULL,
    data_hora DATETIME NOT NULL
);

INSERT INTO pontos
VALUES
	(5, '2024-03-06 21:12:00'),
	(4, '2024-03-06 21:12:01'),
	(1, '2024-03-06 21:12:02'),
	(3, '2024-03-06 21:12:03'),
	(2, '2024-03-06 21:12:04'),
	(9, '2024-03-06 21:12:05'),
	(10, '2024-03-06 21:12:06'),
	(4, '2024-03-06 21:12:07');

SELECT *
FROM pontos
WHERE (SELECT SUM(quantidade) 
       FROM (SELECT * FROM pontos AS p2 ORDER BY data_hora DESC) AS sub
       WHERE sub.data_hora >= pontos.data_hora) <= 23
ORDER BY data_hora DESC;

DROP TABLE pontos;