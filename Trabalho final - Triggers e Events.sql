USE DB_Bijuteria_Dona_Elvira;

DELIMITER //

DROP EVENT IF EXISTS verifica_aniversariantes;

CREATE EVENT verifica_aniversariantes
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_DATE() + INTERVAL 1 DAY
DO
BEGIN
	CREATE TABLE IF NOT EXISTS logs_aniversariantes (
		ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		ID_cliente INT NOT NULL,
		data_aniversario DATE NOT NULL,
		FOREIGN KEY (ID_cliente) REFERENCES TAB_cliente(ID)
	);

	
    INSERT INTO logs_aniversariantes (ID_cliente, data_aniversario)
    SELECT c.ID, CURDATE()
    FROM TAB_pessoa p INNER JOIN TAB_cliente c ON p.ID = c.ID_pessoa
    WHERE proxima_data(data_nascimento) = CURDATE();
END;
//

DELIMITER ;




-- ACABAR

DELIMITER //

DROP TRIGGER IF EXISTS adicao_cliente;

CREATE TRIGGER adicao_cliente AFTER INSERT ON TAB_Cliente
FOR EACH ROW 
BEGIN
    
END;
//

DELIMITER ;






SELECT * FROM information_schema.EVENTS;