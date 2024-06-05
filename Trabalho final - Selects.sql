USE DB_Bijuteria_Dona_Elvira;

-- Nomes aleatorios
SELECT obter_nome_aleatorio(), obter_sobrenome_aleatorio();

-- Aniversariantes
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
    
-- Pessoas que fizeram anos e fazem anos
SELECT *
	FROM logs_aniversariantes;
    
-- Acontecimentos na tabela TAB_cliente
SELECT *
	FROM logs_clientes
    ORDER BY data_hora DESC, ID ASC;
    
-- Contagem de acontecimentos na tabela TAB_cliente
SELECT acao, COUNT(ID)
	FROM logs_clientes
    GROUP BY acao;
    
-- ACABAR !!!!