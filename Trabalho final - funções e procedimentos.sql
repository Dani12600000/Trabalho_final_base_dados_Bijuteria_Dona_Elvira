USE DB_Bijuteria_Dona_Elvira;

DELIMITER //

DROP FUNCTION IF EXISTS obter_nome_aleatorio;

CREATE FUNCTION obter_nome_aleatorio()
RETURNS VARCHAR(255) READS SQL DATA
BEGIN
    DECLARE primeiro_nome_aleatorio NVARCHAR(50);
    DECLARE segundo_nome_aleatorio NVARCHAR(50);
    DECLARE terceiro_nome_aleatorio NVARCHAR(50);
    DECLARE quarto_nome_aleatorio NVARCHAR(50);

    SELECT primeiro_nome INTO primeiro_nome_aleatorio
    FROM TAB_AUX_pessoa
    ORDER BY RAND()
    LIMIT 1;
    
    SELECT segundo_nome INTO segundo_nome_aleatorio
    FROM TAB_AUX_pessoa
    ORDER BY RAND()
    LIMIT 1;
    
    SELECT terceiro_nome INTO terceiro_nome_aleatorio
    FROM TAB_AUX_pessoa
    ORDER BY RAND()
    LIMIT 1;
    
    SELECT quarto_nome INTO quarto_nome_aleatorio
    FROM TAB_AUX_pessoa
    ORDER BY RAND()
    LIMIT 1;

    RETURN CONCAT(primeiro_nome_aleatorio, ' ', segundo_nome_aleatorio);
END;
//

DELIMITER ;

DELIMITER //

DROP FUNCTION IF EXISTS obter_sobrenome_aleatorio;

CREATE FUNCTION obter_sobrenome_aleatorio()
RETURNS VARCHAR(255) READS SQL DATA
BEGIN
    DECLARE terceiro_nome_aleatorio NVARCHAR(50);
    DECLARE quarto_nome_aleatorio NVARCHAR(50);
    
    SELECT terceiro_nome INTO terceiro_nome_aleatorio
    FROM TAB_AUX_pessoa
    ORDER BY RAND()
    LIMIT 1;
    
    SELECT quarto_nome INTO quarto_nome_aleatorio
    FROM TAB_AUX_pessoa
    ORDER BY RAND()
    LIMIT 1;

    RETURN CONCAT(terceiro_nome_aleatorio, ' ', quarto_nome_aleatorio);
END;
//

DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS ExecutarInsercaoRegistosMultiplosPessoas;

CREATE PROCEDURE ExecutarInsercaoRegistosMultiplosPessoas(IN vezes INT)
BEGIN
    DECLARE contador INT;

    SET contador = 1;

    WHILE contador <= vezes DO
        INSERT INTO TAB_pessoa (nome, sobrenome, data_nascimento) 
        VALUES (
			obter_nome_aleatorio(), 
            obter_sobrenome_aleatorio(), 
            DATE_SUB(CURRENT_DATE(), INTERVAL FLOOR(RAND() * (365 * (90 - 18) + 1) + (365 * 18)) DAY)
		);
        SET contador = contador + 1;
    END WHILE;
END;
//

DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS ExecutarInsercaoRegistosMultiplosClientes;

CREATE PROCEDURE ExecutarInsercaoRegistosMultiplosClientes(IN vezes INT)
BEGIN
    DECLARE contador INT;
    DECLARE ID_cliente_aleatorio INT;

    SET contador = 1;

    WHILE contador <= vezes DO
		SELECT ID INTO ID_cliente_aleatorio 
			FROM TAB_pessoa 
            WHERE ID NOT IN (SELECT ID FROM TAB_cliente)
            ORDER BY RAND()
			LIMIT 1;
    
        INSERT INTO TAB_cliente (ID_pessoa, data_hora_registo) 
        VALUES (
			ID_cliente_aleatorio, 
            DATE_SUB(CURRENT_DATE(), INTERVAL FLOOR(RAND() * 22) DAY)
		);
        SET contador = contador + 1;
    END WHILE;
END;
//

DELIMITER ;

DELIMITER //

DROP FUNCTION IF EXISTS existem_pessoas_com_mais_1_conta_cliente;

CREATE FUNCTION existem_pessoas_com_mais_1_conta_cliente(ID_pessoa_avaliar INT)
RETURNS BOOLEAN READS SQL DATA
BEGIN
    DECLARE n_pessoas_registadas_mais_que_1_cliente INT;

    -- Seleciona o número de registros de clientes para a pessoa especificada
    SELECT COUNT(*) INTO n_pessoas_registadas_mais_que_1_cliente
    FROM TAB_cliente
    WHERE ID_pessoa = ID_pessoa_avaliar;

    -- Verifica se a pessoa está registrada mais de uma vez como cliente
    IF n_pessoas_registadas_mais_que_1_cliente > 1 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
//

DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS ApagarRegistosRepetidosClientes;

CREATE PROCEDURE ApagarRegistosRepetidosClientes()
BEGIN
    DECLARE contador INT;
    DECLARE ID_cliente_aleatorio INT;

    -- Encontra o maior ID na tabela TAB_cliente
    SET contador = (SELECT MAX(ID) FROM TAB_cliente);

    -- Loop enquanto o contador for maior que 0
    WHILE contador > 0 DO
        -- Verifica se o cliente tem mais de uma conta
        SET ID_cliente_aleatorio = (SELECT ID_pessoa FROM TAB_cliente WHERE ID = contador);
        
        IF ID_cliente_aleatorio IS NOT NULL THEN
            IF existem_pessoas_com_mais_1_conta_cliente(ID_cliente_aleatorio) THEN
                -- Apaga o registro com o ID atual se for um duplicado
                DELETE FROM TAB_cliente WHERE ID = contador;
            END IF;
        END IF;

        -- Decrementa o contador
        SET contador = contador - 1;
    END WHILE;
END;
//

DELIMITER ;


DELIMITER //

DROP FUNCTION IF EXISTS proxima_data;

CREATE FUNCTION proxima_data(data_verificar date)
RETURNS DATE READS SQL DATA
BEGIN
	DECLARE data_neste_ano DATE;
    DECLARE proxima_data_obtida DATE;
    
    SET data_neste_ano = CONCAT(DATE_FORMAT(CURDATE(),'%Y'), '-' ,DATE_FORMAT(data_verificar, '%m-%d'));
    
    IF data_neste_ano < CURDATE() THEN
		SET proxima_data_obtida = DATE_ADD(data_neste_ano, INTERVAL 1 YEAR);
	ELSE
		SET proxima_data_obtida = data_neste_ano;
	END IF;

    RETURN proxima_data_obtida;
END;
//

DELIMITER ;