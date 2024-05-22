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


CREATE TABLE IF NOT EXISTS logs_clientes (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	ID_cliente INT NOT NULL,
	data_hora DATETIME NOT NULL DEFAULT (NOW()),
	acao VARCHAR(30) NOT NULL CHECK (acao IN ('INSERT', 'DELETE', 'UPDATE')),
	detalhes TEXT NOT NULL
);


DELIMITER //

-- DROP TRIGGER IF EXISTS adicao_cliente;

CREATE TRIGGER adicao_cliente AFTER INSERT ON TAB_cliente
FOR EACH ROW 
BEGIN
	DECLARE nome_pessoa NVARCHAR(255);
    
    SELECT CONCAT(nome, ' ', sobrenome) INTO nome_pessoa
		FROM TAB_pessoa
        WHERE ID = NEW.ID_pessoa;

    INSERT INTO logs_clientes (ID_cliente, acao, detalhes)
    VALUES (NEW.ID, 'INSERT', CONCAT('Foi inserido um novo cliente com o ID pessoa ', NEW.ID_pessoa, ' e chamada ', nome_pessoa));
END;
//

-- DROP TRIGGER IF EXISTS remocao_cliente;

CREATE TRIGGER remocao_cliente AFTER DELETE ON TAB_cliente
FOR EACH ROW 
BEGIN
	DECLARE nome_pessoa NVARCHAR(255);
    
    SELECT CONCAT(nome, ' ', sobrenome) INTO nome_pessoa
		FROM TAB_pessoa
        WHERE ID = OLD.ID_pessoa;

    INSERT INTO logs_clientes (ID_cliente, acao, detalhes)
    VALUES (OLD.ID, 'DELETE', CONCAT('Foi removido um cliente com o ID pessoa ', OLD.ID_pessoa, ' e chamada ', nome_pessoa));
END;
//

-- DROP TRIGGER IF EXISTS update_cliente;

CREATE TRIGGER update_cliente AFTER UPDATE ON TAB_cliente
FOR EACH ROW 
BEGIN
	DECLARE nome_pessoa NVARCHAR(255);
		
	INSERT INTO logs_clientes (ID_cliente, acao, detalhes)
	VALUES (OLD.ID, 'UPDATE', CONCAT('Foi atualizado um cliente que tinha o ID pessoa ', OLD.ID_pessoa, ' para ', NEW.ID_pessoa));
END;
//

DELIMITER ;


DELIMITER //

-- DROP TRIGGER IF EXISTS adicao_pessoa;

CREATE TRIGGER adicao_pessoa AFTER INSERT ON TAB_pessoa
FOR EACH ROW 
BEGIN
    INSERT INTO logs_clientes (ID_cliente, acao, detalhes)
    VALUES (NEW.ID, 'INSERT', CONCAT('Foi inserido uma nova pessoa com o nome ', NEW.nome, ' ', NEW.sobrenome, ' e data de nascimento na data ', NEW.data_nascimento));
END;
//

-- DROP TRIGGER IF EXISTS remocao_pessoa;

CREATE TRIGGER remocao_pessoa AFTER DELETE ON TAB_pessoa
FOR EACH ROW 
BEGIN
    INSERT INTO logs_clientes (ID_cliente, acao, detalhes)
    VALUES (OLD.ID, 'DELETE', CONCAT('Foi removida uma pessoa com o nome ', OLD.nome, ' ', OLD.sobrenome));
END;

-- DROP TRIGGER IF EXISTS update_pessoa;

CREATE TRIGGER update_pessoa AFTER UPDATE ON TAB_pessoa
FOR EACH ROW 
BEGIN

	DECLARE text_ocuration_description;
	
    IF NEW.nome <> OLD.nome AND NEW.sobrenome <> OLD.sobrenome AND NEW.data_nascimento <> OLD.data_nascimento THEN
		SET text_ocuration_description = CONCAT('Foi atualizado todos os dadaos de uma pessoa com o nome ', OLD.nome, ' ', OLD.sobrenome, ' e data de nascimento no dia ', OLD.data_nascimento,' para ', NEW.nome, ' ', NEW.sobrenome, ' e data de nascimento ', NEW.data_nascimento));
	
    
    IF NEW.nome <> OLD.nome AND NEW.sobrenome <> OLD.sobrenome THEN
		SET text_ocuration_description = CONCAT('Foi atualizado o nome completo de uma pessoa com o nome ', OLD.nome, ' ', OLD.sobrenome, ' para ', NEW.nome, ' ', NEW.sobrenome));
    ELSEIF NEW.nome <> OLD.nome OR NEW.sobrenome <> OLD.sobrenome THEN
		IF NEW.nome <> OLD.nome THEN
			SET text_ocuration_description = CONCAT('Foi atualizado o nome de uma pessoa com o nome', OLD.nome, ' para ', NEW.nome));
		END IF;
		
		IF NEW.sobrenome <> OLD.sobrenome THEN
			SET text_ocuration_description = CONCAT('Foi atualizado o nome de uma pessoa com o sobrenome', OLD.sobrenome, ' para ', NEW.sobrenome));
		END IF;
	
    IF NEW.data_nascimento <> OLD.data_nascimento THEN
		SET text_ocuration_description = CONCAT('Foi atualizado a data de nascimento de uma pessoa que tinha para dia', OLD.data_nascimento, ' para ', NEW.data_nascimento));
	END IF;
    
    
    INSERT INTO logs_clientes (ID_cliente, acao, detalhes)
	VALUES (OLD.ID, 'UPDATE', text_ocuration_description);
END;

//

DELIMITER ;





-- Eventos
SELECT * FROM information_schema.EVENTS WHERE EVENT_SCHEMA = 'DB_Bijuteria_Dona_Elvira';
-- Triggers
SELECT * FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA = 'DB_Bijuteria_Dona_Elvira';