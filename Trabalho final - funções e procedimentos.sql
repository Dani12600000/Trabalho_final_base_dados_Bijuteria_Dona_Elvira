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

CREATE FUNCTION gerar_nif()
RETURNS CHAR(9)
DETERMINISTIC
BEGIN
    DECLARE nif_base CHAR(8);
    DECLARE nif CHAR(9);
    DECLARE sum INT;
    DECLARE check_digit INT;

    SET nif_base = LPAD(FLOOR(RAND() * 100000000), 8, '0');

    SET sum = 0;
    SET sum = sum + SUBSTRING(nif_base, 1, 1) * 9;
    SET sum = sum + SUBSTRING(nif_base, 2, 1) * 8;
    SET sum = sum + SUBSTRING(nif_base, 3, 1) * 7;
    SET sum = sum + SUBSTRING(nif_base, 4, 1) * 6;
    SET sum = sum + SUBSTRING(nif_base, 5, 1) * 5;
    SET sum = sum + SUBSTRING(nif_base, 6, 1) * 4;
    SET sum = sum + SUBSTRING(nif_base, 7, 1) * 3;
    SET sum = sum + SUBSTRING(nif_base, 8, 1) * 2;
    
    SET check_digit = 11 - (sum % 11);
    
    IF check_digit >= 10 THEN
        SET check_digit = 0;
    END IF;

    SET nif = CONCAT(nif_base, check_digit);

    RETURN nif;
END //

DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS ExecutarInsercaoRegistosMultiplosPessoas;

CREATE PROCEDURE ExecutarInsercaoRegistosMultiplosPessoas(IN vezes INT)
BEGIN
    DECLARE contador INT;

    SET contador = 1;

    WHILE contador <= vezes DO
        INSERT INTO TAB_pessoa (nome, sobrenome, NIF, data_nascimento) 
        VALUES (
			obter_nome_aleatorio(), 
            obter_sobrenome_aleatorio(),
            ,
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
            WHERE ID NOT IN (SELECT ID_pessoa FROM TAB_cliente)
            ORDER BY RAND()
			LIMIT 1;
    
        INSERT INTO TAB_cliente (ID_pessoa, data_hora_registo) 
        VALUES (
			ID_cliente_aleatorio, 
            DATE_SUB(CURRENT_DATE(), INTERVAL FLOOR(RAND() * 79200) MINUTE)
		);
        SET contador = contador + 1;
    END WHILE;
END;
//

DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS ExecutarInsercaoRegistosMultiplosFuncionarios;

CREATE PROCEDURE ExecutarInsercaoRegistosMultiplosFuncionarios(IN vezes INT)
BEGIN
    DECLARE contador INT;
    DECLARE ID_funcionario_aleatorio INT;
    DECLARE ID_profissao_aleatorio INT;

    SET contador = 1;

    WHILE contador <= vezes DO
		SELECT ID INTO ID_funcionario_aleatorio 
			FROM TAB_pessoa 
            WHERE ID NOT IN (SELECT ID_pessoa FROM TAB_funcionario)
            ORDER BY RAND()
			LIMIT 1;
		
        SELECT ID INTO ID_profissao_aleatorio
			FROM TAB_profissao
            ORDER BY RAND()
            LIMIT 1;
    
        INSERT INTO TAB_funcionario (ID_pessoa, ID_profissao) 
        VALUES (
			ID_funcionario_aleatorio,
            ID_profissao_aleatorio
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

DELIMITER //

DROP FUNCTION IF EXISTS dia_feriado_muda_cada_ano;

CREATE FUNCTION dia_feriado_muda_cada_ano(ID_feriado_into INT)
RETURNS BOOL READS SQL DATA
BEGIN
	DECLARE n_datas_distintas INT;
	DECLARE repete BOOL;
    
    SELECT COUNT(DISTINCT DATE_FORMAT(df.data, '%m-%d')) INTO n_datas_distintas
		FROM TAB_dia_feriado df INNER JOIN TAB_feriado f ON df.ID_feriado = f.ID
		WHERE f.ID = ID_feriado_into
		GROUP BY f.ID, f.designacao;
        
	IF n_datas_distintas > 1 THEN 
		SET repete = TRUE;
    ELSE 
		SET repete = FALSE;
    END IF;

    RETURN repete;
END;
//

DELIMITER ;