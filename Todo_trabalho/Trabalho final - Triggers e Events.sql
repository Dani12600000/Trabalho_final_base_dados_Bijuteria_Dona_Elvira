USE DB_Bijuteria_Dona_Elvira;

DELIMITER //

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


CREATE TABLE IF NOT EXISTS logs_clientes (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	ID_cliente INT NOT NULL,
	data_hora DATETIME NOT NULL DEFAULT (NOW()),
	acao VARCHAR(30) NOT NULL CHECK (acao IN ('INSERT', 'DELETE', 'UPDATE')),
	detalhes TEXT NOT NULL
);


DELIMITER //

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

CREATE TRIGGER update_cliente AFTER UPDATE ON TAB_cliente
FOR EACH ROW 
BEGIN
	DECLARE nome_pessoa NVARCHAR(255);
		
	INSERT INTO logs_clientes (ID_cliente, acao, detalhes)
	VALUES (OLD.ID, 'UPDATE', CONCAT('Foi atualizado um cliente que tinha o ID pessoa ', OLD.ID_pessoa, ' para ', NEW.ID_pessoa));
END;
//

DELIMITER ;

CREATE TABLE IF NOT EXISTS logs_pessoas (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	ID_cliente INT NOT NULL,
	data_hora DATETIME NOT NULL DEFAULT (NOW()),
	acao VARCHAR(30) NOT NULL CHECK (acao IN ('INSERT', 'DELETE', 'UPDATE')),
	detalhes TEXT NOT NULL
);


DELIMITER //

CREATE TRIGGER adicao_pessoa AFTER INSERT ON TAB_pessoa
FOR EACH ROW 
BEGIN
    INSERT INTO logs_pessoas (ID_cliente, acao, detalhes)
    VALUES (NEW.ID, 'INSERT', CONCAT('Foi inserido uma nova pessoa com o nome ', NEW.nome, ' ', NEW.sobrenome, ' e data de nascimento na data ', NEW.data_nascimento));
END;
//

CREATE TRIGGER remocao_pessoa AFTER DELETE ON TAB_pessoa
FOR EACH ROW 
BEGIN
    INSERT INTO logs_pessoas (ID_cliente, acao, detalhes)
    VALUES (OLD.ID, 'DELETE', CONCAT('Foi removida uma pessoa com o nome ', OLD.nome, ' ', OLD.sobrenome));
END;
//

CREATE TRIGGER update_pessoa AFTER UPDATE ON TAB_pessoa
FOR EACH ROW 
BEGIN

	DECLARE text_ocuration_description VARCHAR(255);
	
    IF NEW.nome <> OLD.nome AND NEW.sobrenome <> OLD.sobrenome AND NEW.data_nascimento <> OLD.data_nascimento THEN
		SET text_ocuration_description = CONCAT('Foi atualizado todos os dadaos de uma pessoa com o nome ', OLD.nome, ' ', OLD.sobrenome, ' e data de nascimento no dia ', OLD.data_nascimento,' para ', NEW.nome, ' ', NEW.sobrenome, ' e data de nascimento ', NEW.data_nascimento);
	
    ELSE
		IF (NEW.nome <> OLD.nome AND NEW.sobrenome <> OLD.sobrenome) AND NEW.data_nascimento = OLD.data_nascimento THEN
			SET text_ocuration_description = CONCAT('Foi atualizado o nome completo de uma pessoa com o nome ', OLD.nome, ' ', OLD.sobrenome, ' para ', NEW.nome, ' ', NEW.sobrenome);
		ELSEIF (NEW.nome <> OLD.nome OR NEW.sobrenome <> OLD.sobrenome) AND NEW.data_nascimento = OLD.data_nascimento  THEN
			IF NEW.nome <> OLD.nome THEN
				SET text_ocuration_description = CONCAT('Foi atualizado o nome de uma pessoa com o nome', OLD.nome, ' para ', NEW.nome);
			END IF;
			
			IF NEW.sobrenome <> OLD.sobrenome THEN
				SET text_ocuration_description = CONCAT('Foi atualizado o nome de uma pessoa com o sobrenome', OLD.sobrenome, ' para ', NEW.sobrenome);
			END IF;
		ELSEIF (NEW.nome <> OLD.nome OR NEW.sobrenome <> OLD.sobrenome) AND NEW.data_nascimento = OLD.data_nascimento  THEN
			IF NEW.nome <> OLD.nome THEN
				SET text_ocuration_description = CONCAT('Foi atualizado o nome e data de nascimento de uma pessoa com o nome', OLD.nome, ' e data de nascimento ', OLD.data_nascimento, ' para ', NEW.nome, ' e data nascimento ', NEW.data_nascimento);
			END IF;
			
			IF NEW.sobrenome <> OLD.sobrenome THEN
				SET text_ocuration_description = CONCAT('Foi atualizado o nome e data de nascimento de uma pessoa com o sobrenome', OLD.sobrenome, ' e data de nascimento ', OLD.data_nascimento, ' para ', NEW.sobrenome, ' e data nascimento ', NEW.data_nascimento);
			END IF;
		END IF;
		
        
		IF NEW.data_nascimento <> OLD.data_nascimento THEN
			SET text_ocuration_description = CONCAT('Foi atualizado a data de nascimento de uma pessoa que tinha para dia', OLD.data_nascimento, ' para ', NEW.data_nascimento);
		END IF;
	END IF;
    
    
    INSERT INTO logs_pessoas (ID_cliente, acao, detalhes)
	VALUES (OLD.ID, 'UPDATE', text_ocuration_description);
END;

//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_stock_artigo_before_insert
BEFORE INSERT ON TAB_stock_artigo
FOR EACH ROW
BEGIN
    -- Se data_hora_chegada não for NULL, data_hora_envio também não pode ser NULL
    IF NEW.data_hora_chegada IS NOT NULL AND NEW.data_hora_envio IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'data_hora_envio não pode ser NULL quando data_hora_chegada não é NULL';
    END IF;

    -- Se data_hora_envio for NULL, ID_metodo_pagamento deve ser NULL e valor_total pode ser NULL
    IF NEW.data_hora_envio IS NOT NULL AND (NEW.ID_metodo_pagamento IS NULL OR NEW.valor_total IS NULL) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ID_metodo_pagamento e/ou valor_total deve ter valores quando data_hora_envio não é NULL';
    END IF;

    -- Se metodo_pagamento não for NULL e valor_total é null ou vice versa
    IF (NEW.ID_metodo_pagamento IS NOT NULL AND NEW.valor_total IS NULL) OR (NEW.ID_metodo_pagamento IS NULL AND NEW.valor_total IS NOT NULL) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'valor_total ou metodo_pagamento não pode ser NULL quando o valor_total ou metodo_pagamento não é NULL';
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_stock_artigo_before_update
BEFORE UPDATE ON TAB_stock_artigo
FOR EACH ROW
BEGIN
    -- Se data_hora_chegada não for NULL, data_hora_envio também não pode ser NULL
    IF NEW.data_hora_chegada IS NOT NULL AND NEW.data_hora_envio IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'data_hora_envio não pode ser NULL quando data_hora_chegada não é NULL';
    END IF;

    -- Se data_hora_envio for NULL, ID_metodo_pagamento deve ser NULL e valor_total pode ser NULL
    IF NEW.data_hora_envio IS NOT NULL AND (NEW.ID_metodo_pagamento IS NULL OR NEW.valor_total IS NULL) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ID_metodo_pagamento e/ou valor_total deve ter valores quando data_hora_envio não é NULL';
    END IF;

    -- Se metodo_pagamento não for NULL e valor_total é null ou vice versa
    IF (NEW.ID_metodo_pagamento IS NOT NULL AND NEW.valor_total IS NULL) OR (NEW.ID_metodo_pagamento IS NULL AND NEW.valor_total IS NOT NULL) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'valor_total ou metodo_pagamento não pode ser NULL quando o valor_total ou metodo_pagamento não é NULL';
    END IF;
END //

DELIMITER ;



/*
-- Eventos
SELECT * FROM information_schema.EVENTS WHERE EVENT_SCHEMA = 'DB_Bijuteria_Dona_Elvira';
-- Triggers
SELECT * FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA = 'DB_Bijuteria_Dona_Elvira';
*/