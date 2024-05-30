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
    ORDER BY data_hora DESC, ID ASC;
    
SELECT acao, COUNT(ID)
	FROM logs_clientes
    GROUP BY acao;
    
SELECT acao, COUNT(ID)
	FROM logs_pessoas
    GROUP BY acao;
    
SELECT TIMEDIFF(MAX(data_hora), MIN(data_hora))
	FROM logs_clientes;
    
SELECT *
	FROM TAB_cliente
    WHERE ID_pessoa = 914;
    
SELECT *
	FROM TAB_cliente
    WHERE ID = (SELECT MAX(ID) FROM TAB_cliente);
    
    
UPDATE TAB_cliente SET ID_pessoa = 914 WHERE ID_pessoa = 913 ;


SELECT *
	FROM TAB_feriado;
    
SELECT df.ID, f.designacao, df.data, df.n_dias
	FROM TAB_dia_feriado df INNER JOIN TAB_feriado f ON df.ID_feriado = f.ID
    ORDER BY df.data ASC;
    
SELECT ID, designacao, IF (dia_feriado_muda_cada_ano(ID), 'Sim','Não') AS muda_cada_ano
	FROM TAB_feriado;

SELECT *
	FROM TAB_funcionario;
    
SELECT *
	FROM TAB_profissao
    ORDER BY salario_base DESC;
    
SELECT *
	FROM TAB_profissao
    WHERE salario_base = (SELECT MAX(salario_base) FROM TAB_profissao);
    
SELECT *
	FROM TAB_profissao
    WHERE ABS(salario_base - (SELECT AVG(salario_base) FROM TAB_profissao)) = (
		SELECT ABS(salario_base - (SELECT AVG(salario_base) FROM TAB_profissao))
			FROM TAB_profissao
			ORDER BY ABS(salario_base - (SELECT AVG(salario_base) FROM TAB_profissao)) ASC
			LIMIT 1)
	;
        
SELECT *
	FROM TAB_profissao
    WHERE salario_base = (SELECT MIN(salario_base) FROM TAB_profissao);
    
SELECT *
	FROM TAB_tipo_instalacoes;
    
SELECT ID, TIME_FORMAT(hora_aberto, '%H:%i') AS hora_aberto, TIME_FORMAT(hora_fechado, '%H:%i') AS hora_fechado, TIME_FORMAT(TIMEDIFF(hora_fechado, hora_aberto), '%H:%i') AS periodo_trabalho
	FROM TAB_horas;
    
SELECT ti.ID, ti.designacao, COUNT(i.ID) AS n_tipo_instalacoes
	FROM TAB_tipo_instalacoes ti INNER JOIN TAB_instalacoes i ON ti.ID = i.ID_tipo_instalacoes
    GROUP BY ti.ID, ti.designacao;
    
SELECT *
	FROM TAB_instalacoes;
    
SELECT pe.ID, CONCAT(pe.nome, ' ', pe.sobrenome) AS nome_completo, pr.designacao, pr.salario_base
	FROM TAB_pessoa pe
			INNER JOIN TAB_funcionario f ON pe.ID = f.ID_pessoa
			INNER JOIN TAB_profissao pr ON f.ID_profissao = pr.ID
    ORDER BY f.ID DESC;
    
SELECT p.ID, p.designacao, COUNT(f.ID) AS n_funcionarios
	FROM TAB_profissao p INNER JOIN TAB_funcionario f ON p.ID = f.ID_profissao
    GROUP BY p.ID, p.designacao
    UNION
SELECT MAX(p.ID) + 1, 'Total de funcionarios', COUNT(*)
	FROM TAB_profissao p INNER JOIN TAB_funcionario f ON p.ID = f.ID_profissao;
    
    
SELECT p.ID, p.designacao, COUNT(f.ID) AS n_funcionarios
	FROM TAB_profissao p INNER JOIN TAB_funcionario f ON p.ID = f.ID_profissao
    GROUP BY p.ID, p.designacao
    HAVING COUNT(f.ID) = (
		SELECT COUNT(f.ID)
			FROM TAB_profissao p INNER JOIN TAB_funcionario f ON p.ID = f.ID_profissao
			GROUP BY p.ID, p.designacao
            ORDER BY 1 DESC
            LIMIT 1
		);
        