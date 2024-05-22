USE DB_Bijuteria_Dona_Elvira;

SELECT *
	FROM tab_relacoes_entre_unidades_tempo;
    
SELECT *
	FROM TAB_promocao;
    
SELECT obter_nome_aleatorio(), obter_sobrenome_aleatorio();

SELECT *
	FROM TAB_pessoa;
    
SELECT *
	FROM TAB_cliente
    WHERE ID_pessoa = 914;
    
    
    
-- Aniversariantes hoje    
SELECT p.*
	FROM TAB_pessoa p INNER JOIN TAB_cliente c ON p.ID = c.ID_pessoa
    WHERE proxima_data(data_nascimento) = CURDATE();

-- Aniversariantes amanhã
SELECT p.*
	FROM TAB_pessoa p INNER JOIN TAB_cliente c ON p.ID = c.ID_pessoa
    WHERE proxima_data(data_nascimento) = DATE_ADD(CURDATE(), INTERVAL 1 DAY); 

-- Aniversariantes proximos 7 dias
SELECT p.*
	FROM TAB_pessoa p INNER JOIN TAB_cliente c ON p.ID = c.ID_pessoa
    WHERE proxima_data(data_nascimento) >= CURDATE() AND proxima_data(data_nascimento) <= DATE_ADD(CURDATE(), INTERVAL 7 DAY)
    ORDER BY proxima_data(data_nascimento) ASC;


SELECT ID_pessoa, COUNT(*)
	FROM TAB_cliente
    GROUP BY ID_pessoa
    HAVING COUNT(*) > 1
    ORDER BY COUNT(*) DESC;
    
SELECT obter_nome_aleatorio(), obter_sobrenome_aleatorio();
    
SELECT *
	FROM logs_aniversariantes;
    
SELECT *
	FROM VIEW_informacoes_cliente;
    
SELECT *
	FROM logs_clientes
    ORDER BY data_hora DESC;
    
UPDATE TAB_cliente SET ID_pessoa = 914 WHERE ID_pessoa = 913 