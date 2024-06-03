USE DB_Bijuteria_Dona_Elvira;

DELIMITER //

-- DROP FUNCTION IF EXISTS obter_nome_aleatorio;

CREATE FUNCTION obter_nome_aleatorio()
RETURNS VARCHAR(255) READS SQL DATA
BEGIN
    DECLARE primeiro_nome_aleatorio NVARCHAR(50);
    DECLARE segundo_nome_aleatorio NVARCHAR(50);
    DECLARE nome NVARCHAR(110);

    SELECT primeiro_nome INTO primeiro_nome_aleatorio
    FROM TAB_AUX_pessoa
    ORDER BY RAND()
    LIMIT 1;
    
    SELECT segundo_nome INTO segundo_nome_aleatorio
    FROM TAB_AUX_pessoa
    ORDER BY RAND()
    LIMIT 1;
    
    IF segundo_nome_aleatorio IS NULL THEN
		SET nome = primeiro_nome_aleatorio;
	ELSE
		SET nome = CONCAT(primeiro_nome_aleatorio, ' ', segundo_nome_aleatorio);
	END IF;

    RETURN nome;
END;
//

DELIMITER ;

DELIMITER //

-- DROP FUNCTION IF EXISTS obter_sobrenome_aleatorio;

CREATE FUNCTION obter_sobrenome_aleatorio()
RETURNS VARCHAR(255) READS SQL DATA
BEGIN
    DECLARE terceiro_nome_aleatorio NVARCHAR(50);
    DECLARE quarto_nome_aleatorio NVARCHAR(50);
    DECLARE sobrenome NVARCHAR(110);
    
    SELECT terceiro_nome INTO terceiro_nome_aleatorio
    FROM TAB_AUX_pessoa
    ORDER BY RAND()
    LIMIT 1;
    
    SELECT quarto_nome INTO quarto_nome_aleatorio
    FROM TAB_AUX_pessoa
    ORDER BY RAND()
    LIMIT 1;
    
    IF terceiro_nome_aleatorio IS NULL THEN
		SET sobrenome = quarto_nome_aleatorio;
	ELSE
		SET sobrenome = CONCAT(terceiro_nome_aleatorio, ' ', quarto_nome_aleatorio);
	END IF;

    RETURN sobrenome;
END;
//

DELIMITER ;

DELIMITER //

-- DROP FUNCTION IF EXISTS gerar_nif;

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

-- DROP FUNCTION IF EXISTS gerar_cc;

CREATE FUNCTION gerar_cc()
RETURNS CHAR(12)
DETERMINISTIC
BEGIN
    DECLARE letras CHAR(2);
    DECLARE numeros CHAR(9);
    DECLARE cc CHAR(12);

    -- Gerar duas letras aleatórias (A-Z)
    SET letras = CHAR(FLOOR(65 + RAND() * 26));
    SET letras = CONCAT(letras, CHAR(FLOOR(65 + RAND() * 26)));

    -- Gerar nove números aleatórios (0-9)
    SET numeros = LPAD(FLOOR(RAND() * 1000000000), 9, '0');

    -- Concatenar letras e números para formar o ID do CC
    SET cc = CONCAT(letras, numeros);

    RETURN cc;
END //

DELIMITER ;

DELIMITER //

-- DROP FUNCTION IF EXISTS gerar_passaporte;

CREATE FUNCTION gerar_passaporte()
RETURNS CHAR(9)
DETERMINISTIC
BEGIN
    DECLARE letras CHAR(3);
    DECLARE numeros CHAR(6);
    DECLARE passaporte CHAR(9);

    -- Gerar três letras aleatórias (A-Z)
    SET letras = CHAR(FLOOR(65 + RAND() * 26));
    SET letras = CONCAT(letras, CHAR(FLOOR(65 + RAND() * 26)));
    SET letras = CONCAT(letras, CHAR(FLOOR(65 + RAND() * 26)));

    -- Gerar seis números aleatórios (0-9)
    SET numeros = LPAD(FLOOR(RAND() * 1000000), 6, '0');

    -- Concatenar letras e números para formar o ID do passaporte
    SET passaporte = CONCAT(letras, numeros);

    RETURN passaporte;
END //

DELIMITER ;


DELIMITER //

-- DROP PROCEDURE IF EXISTS ExecutarInsercaoRegistosMultiplosPessoas;

CREATE PROCEDURE ExecutarInsercaoRegistosMultiplosPessoas(IN vezes INT)
BEGIN
    DECLARE contador INT;

    SET contador = 1;

    WHILE contador <= vezes DO
        INSERT INTO TAB_pessoa (nome, sobrenome, NIF, data_nascimento) 
        VALUES (
			obter_nome_aleatorio(), 
            obter_sobrenome_aleatorio(),
            gerar_nif(),
            DATE_SUB(CURRENT_DATE(), INTERVAL FLOOR(RAND() * (365 * (90 - 18) + 1) + (365 * 18)) DAY)
		);
        SET contador = contador + 1;
    END WHILE;
END;
//

DELIMITER ;

DELIMITER //

-- DROP PROCEDURE IF EXISTS ExecutarInsercaoRegistosMultiplosClientes;

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

-- DROP PROCEDURE IF EXISTS ExecutarInsercaoRegistosMultiplosFuncionarios;

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

-- DROP FUNCTION IF EXISTS existem_pessoas_com_mais_1_conta_cliente;

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

-- DROP PROCEDURE IF EXISTS ApagarRegistosRepetidosClientes;

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

-- DROP FUNCTION IF EXISTS proxima_data;

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

-- DROP FUNCTION IF EXISTS dia_feriado_muda_cada_ano;

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

DELIMITER //

-- DROP PROCEDURE IF EXISTS ExecutarInsercaoRegistosMultiplosCidadoes;

CREATE PROCEDURE ExecutarInsercaoRegistosMultiplosCidadoes(IN vezes INT)
BEGIN
    DECLARE contador INT;
	DECLARE ID_pessoa_aleatoria INT;
    
    SET contador = 1;

    WHILE contador <= vezes DO
		SELECT ID INTO ID_pessoa_aleatoria
			FROM TAB_pessoa 
            WHERE ID NOT IN (SELECT ID_pessoa FROM TAB_passaporte)
            ORDER BY RAND()
			LIMIT 1;
    
    
        INSERT INTO TAB_informacoes_cidadao (ID_pessoa, CC) 
        VALUES (
			ID_pessoa_aleatoria,
            gerar_cc()
		);
        SET contador = contador + 1;
    END WHILE;
END;
//

DELIMITER ;

DELIMITER //

-- DROP PROCEDURE IF EXISTS ExecutarInsercaoRegistosMultiplosEstrangeiros;

CREATE PROCEDURE ExecutarInsercaoRegistosMultiplosEstrangeiros(IN vezes INT)
BEGIN
    DECLARE contador INT;
	DECLARE ID_pessoa_aleatoria INT;
    
    SET contador = 1;

    WHILE contador <= vezes DO
		SELECT ID INTO ID_pessoa_aleatoria
			FROM TAB_pessoa 
            WHERE ID NOT IN (SELECT ID_pessoa FROM TAB_informacoes_cidadao)
            ORDER BY RAND()
			LIMIT 1;
    
    
        INSERT INTO TAB_passaporte (ID_pessoa, ID_passaporte) 
        VALUES (
			ID_pessoa_aleatoria,
            gerar_passaporte()
		);
        SET contador = contador + 1;
    END WHILE;
END;
//

DELIMITER ;

DELIMITER //

-- DROP PROCEDURE IF EXISTS ExecutarInsercaoRegistosMultiplosContratosAtuaisFuncionarios;

CREATE PROCEDURE ExecutarInsercaoRegistosMultiplosContratosAtuaisFuncionarios()
BEGIN
    DECLARE contador INT;
    DECLARE id_funcionario_selecionado INT;
    DECLARE random_date DATETIME;
    
    SET contador = 1;

    WHILE contador <= (SELECT MAX(ID) FROM TAB_funcionario) DO
        SELECT ID INTO id_funcionario_selecionado FROM TAB_funcionario WHERE ID = contador;
        
        IF id_funcionario_selecionado IS NOT NULL THEN
			
            SET random_date = DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * (90 * 60 * 60) + 1) MINUTE);
        
            INSERT INTO TAB_contrato (ID_funcionario, data_hora_contratado, prazo_contrato, ID_unidade_tempo_prazo_contrato) 
            VALUES (
                id_funcionario_selecionado,
                random_date,
                1,
                7 -- Anos, ou seja 1 ano
            );
        END IF;

        SET contador = contador + 1;
    END WHILE;
END;
//

DELIMITER ;

DELIMITER //

-- DROP FUNCTION IF EXISTS obter_contrato_mais_recente;

CREATE FUNCTION obter_contrato_mais_recente(ID_funcionario_proc INT)
RETURNS INT READS SQL DATA
BEGIN
    RETURN (SELECT c.ID
		FROM TAB_contrato c
				INNER JOIN TAB_unidades_tempo ut ON c.ID_unidade_tempo_prazo_contrato = ut.ID
		WHERE c.ID_funcionario = ID_funcionario_proc AND (data_hora_cancelado IS NULL AND ID_funcionario_cancelou IS NULL) AND data_hora_contratado <= NOW()
		ORDER BY data_hora_contratado DESC
        LIMIT 1);
END;
//

DELIMITER ;

DELIMITER //

-- DROP FUNCTION IF EXISTS obter_definicao_hierarquica_mais_recente;

CREATE FUNCTION obter_definicao_hierarquica_mais_recente(ID_cargo_proc INT)
RETURNS INT READS SQL DATA
BEGIN
    RETURN (SELECT ID
		FROM TAB_hierarquia
		WHERE ID_cargo_atribuindo = ID_cargo_proc AND data_hora <= NOW()
		ORDER BY data_hora DESC
        LIMIT 1);
END;
//

DELIMITER ;

DELIMITER //

-- DROP FUNCTION IF EXISTS obter_promocao_mais_recente;

CREATE FUNCTION obter_promocao_mais_recente(ID_funcionario_proc INT)
RETURNS INT READS SQL DATA
BEGIN
    RETURN (SELECT ID
	FROM TAB_promocoes_cargos
    WHERE ID_funcionario_promovido = ID_funcionario_proc AND data_promovido <= CURRENT_DATE()
    ORDER BY data_promovido DESC
    LIMIT 1);
END;
//

DELIMITER ;

DELIMITER //

-- DROP FUNCTION IF EXISTS obter_data_termino_contrato;

CREATE FUNCTION obter_data_termino_contrato(des_no_singular VARCHAR(30), data_hora_contratado_avaliando DATETIME, prazo_contrato_obt INT)
RETURNS DATE READS SQL DATA
BEGIN
    RETURN (CASE 
				WHEN des_no_singular = 'ano' THEN DATE_ADD(data_hora_contratado_avaliando, INTERVAL prazo_contrato_obt YEAR)
				WHEN des_no_singular = 'mês' THEN DATE_ADD(data_hora_contratado_avaliando, INTERVAL prazo_contrato_obt MONTH)
				WHEN des_no_singular = 'semana' THEN DATE_ADD(data_hora_contratado_avaliando, INTERVAL prazo_contrato_obt WEEK)
				WHEN des_no_singular = 'dia' THEN DATE_ADD(data_hora_contratado_avaliando, INTERVAL prazo_contrato_obt DAY)
			END);
END;
//

DELIMITER ;


DELIMITER //

-- DROP PROCEDURE IF EXISTS ExecutarInsercaoRegistosMultiplasPromocoes;

CREATE PROCEDURE ExecutarInsercaoRegistosMultiplasPromocoes()
BEGIN
	DECLARE contador INT DEFAULT 1;
	DECLARE ID_funcionario_atribuindo_cargo INT;
    DECLARE ID_cargo_selecionado INT;
    
    WHILE contador <= (SELECT MAX(ID) FROM TAB_funcionario) DO
		SELECT ID INTO ID_funcionario_atribuindo_cargo FROM TAB_funcionario WHERE ID = contador AND ID_pessoa != 1;
        
        IF ID_funcionario_atribuindo_cargo IS NOT NULL THEN
			SELECT acp.ID_cargo INTO ID_cargo_selecionado
				FROM TAB_AUX_cargos_profissoes acp
						INNER JOIN TAB_funcionario f ON acp.ID_profissao = f.ID_profissao
				WHERE f.ID = ID_funcionario_atribuindo_cargo
				ORDER BY RAND()
				LIMIT 1;
			
			INSERT INTO TAB_promocoes_cargos (ID_funcionario_promovido, ID_funcionario_promovedor, ID_cargo)
			VALUE (
				ID_funcionario_atribuindo_cargo, 
				1, 
                ID_cargo_selecionado
			);
		END IF;
        
        SET contador = contador + 1;
	END WHILE;
END;
//

DELIMITER ;



DELIMITER //

-- DROP FUNCTION IF EXISTS obter_experiencia_mais_recente;

CREATE FUNCTION obter_experiencia_mais_recente(ID_funcionario_proc INT)
RETURNS INT READS SQL DATA
BEGIN
    RETURN (SELECT ID
	FROM TAB_experiencia
    WHERE ID_funcionario = ID_funcionario_proc AND data_hora <= NOW()
    ORDER BY data_hora DESC
    LIMIT 1);
END;
//

DELIMITER ;


DELIMITER //

-- DROP PROCEDURE IF EXISTS ExecutarInsercaoRegistosMultiplasAbastecimentosStock;

CREATE PROCEDURE ExecutarInsercaoRegistosMultiplasAbastecimentosStock(max_iterations INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE random_ID_artigo INT;
	DECLARE random_quantidade INT;
	DECLARE random_ID_instalacoes_destino INT;
	DECLARE random_ID_metodo_pagamento INT;
	DECLARE random_valor_total DECIMAL(10, 2);
	DECLARE random_data_hora_envio DATETIME;
	DECLARE random_data_hora_chegada DATETIME;
    IF max_iterations IS NULL THEN SET max_iterations = 10; END IF;
    
    WHILE i < max_iterations DO
        SET random_ID_artigo = FLOOR(1 + (RAND() * (SELECT MAX(ID) FROM TAB_artigos)));
        SET random_quantidade = FLOOR(1 + (RAND() * 10));
        SET random_ID_instalacoes_destino = FLOOR(1 + (RAND() * (SELECT MAX(ID) FROM TAB_instalacoes)));
        SET random_ID_metodo_pagamento = FLOOR(1 + (RAND() * (SELECT MAX(ID) FROM TAB_metodo_pagamento)));
        SET random_valor_total = ROUND(RAND() * 1000, 2);
        SET random_data_hora_envio = NOW();
        SET random_data_hora_chegada = DATE_ADD(NOW(), INTERVAL FLOOR(1 + (RAND() * 10)) DAY);

        -- Inserir o registro na tabela TAB_stock_artigo
        INSERT INTO TAB_stock_artigo (ID_artigo, quantidade, data_hora_envio, data_hora_chegada, ID_instalacoes_destino, ID_metodo_pagamento, valor_total)
        VALUES (random_ID_artigo, random_quantidade, random_data_hora_envio, random_data_hora_chegada, random_ID_instalacoes_destino, random_ID_metodo_pagamento, random_valor_total);

        -- Incrementar o contador
        SET i = i + 1;
    END WHILE;
END 
//

DELIMITER ;

DELIMITER //

DROP FUNCTION IF EXISTS obter_artigos_em_stock;

CREATE FUNCTION obter_artigos_em_stock(ID_artigo_proc INT, ID_instalacoes_proc INT)
RETURNS INT READS SQL DATA
BEGIN
    DECLARE n_artigos_compra INT;
    DECLARE n_artigos_comprados INT DEFAULT 0;
    DECLARE n_artigos_vendidos INT DEFAULT 0;
    DECLARE n_artigos_transferidos INT DEFAULT 0;
    
    IF ID_instalacoes_proc IS NULL THEN
		SELECT SUM(quantidade) INTO n_artigos_comprados
			FROM TAB_artigos a 
					INNER JOIN TAB_stock_artigo sa ON a.ID = sa.ID_artigo
			WHERE sa.data_hora_chegada <= NOW() AND a.ID = ID_artigo_proc;
            
		SELECT COUNT(*) INTO n_artigos_vendidos
			FROM TAB_artigos a
					INNER JOIN TAB_venda v ON a.ID = v.ID_artigo
			WHERE v.data_hora_pedido <= NOW() AND a.ID = ID_artigo_proc;
        
	ELSE
		SELECT SUM(quantidade) INTO n_artigos_comprados
			FROM TAB_artigos a 
			INNER JOIN TAB_stock_artigo sa ON a.ID = sa.ID_artigo
			WHERE sa.data_hora_chegada <= NOW() AND a.ID = ID_artigo_proc AND sa.ID_instalacoes_destino = ID_instalacoes_proc;
		
        SELECT COUNT(*) INTO n_artigos_vendidos
			FROM TAB_artigos a
					INNER JOIN TAB_venda v ON a.ID = v.ID_artigo
			WHERE v.data_hora_pedido <= NOW() AND a.ID = ID_artigo_proc AND v.ID_instalacoes_compra_recolha = ID_instalacoes_proc;
		
	END IF;
    
    IF n_artigos_comprados IS NULL THEN SET n_artigos_comprados = 0; END IF;
    
	SET n_artigos_compra = n_artigos_comprados - n_artigos_vendidos - n_artigos_transferidos;
    
    RETURN n_artigos_compra;
END;
//

DELIMITER ;


DELIMITER //

-- DROP FUNCTION IF EXISTS obter_valor_artigos_venda_media;

CREATE FUNCTION obter_valor_artigos_venda_media(ID_artigo_proc INT)
RETURNS DECIMAL(10,2) READS SQL DATA
BEGIN
	DECLARE valor_artigo_compra DECIMAL(10,2);
    
	SELECT COUNT(*)
		FROM TAB_stock_artigo sa
				INNER JOIN TAB_metodo_pagamento mp ON sa.ID_metodo_pagamento = mp.ID
		WHERE ID_artigo = ID_artigo_proc AND data_hora_chegada <= NOW()
        ;
    
    SELECT ID
		FROM TAB_stock_artigo sa
				INNER JOIN TAB_metodo_pagamento mp ON sa.ID_metodo_pagamento = mp.ID
		WHERE ID_artigo = ID_artigo_proc AND data_hora_chegada <= NOW()
		ORDER BY data_hora DESC
		LIMIT 1;

    RETURN ;
END;
//

DELIMITER ;