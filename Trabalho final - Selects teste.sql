USE DB_Bijuteria_Dona_Elvira;

SELECT *
	FROM tab_relacoes_entre_unidades_tempo;
    
SELECT *
	FROM TAB_promocao;
    
SELECT obter_nome_aleatorio(), obter_sobrenome_aleatorio();

SELECT *
	FROM TAB_pessoa;
    
    
    
-- Aniversariantes hoje    
SELECT *
	FROM TAB_pessoa
    WHERE DATE_FORMAT(data_nascimento, '%m-%d') = DATE_FORMAT(CURDATE(), '%m-%d');

-- Aniversariantes amanhã
SELECT *
	FROM TAB_pessoa
    WHERE DATE_FORMAT(data_nascimento, '%m-%d') = DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '%m-%d');    


SELECT ID_pessoa, COUNT(*)
	FROM TAB_cliente
    GROUP BY ID_pessoa
    HAVING COUNT(*) > 1
    ORDER BY COUNT(*) DESC;
    
SELECT obter_nome_aleatorio(), obter_sobrenome_aleatorio();
    
SELECT *
	FROM logs_aniversariantes;
    
SELECT *
	FROM VIEW_informacoes_cliente