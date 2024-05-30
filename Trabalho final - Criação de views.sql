USE DB_Bijuteria_Dona_Elvira;

-- DROP VIEW IF EXISTS VIEW_informacoes_cliente;

CREATE VIEW VIEW_informacoes_cliente AS
SELECT c.ID AS ID_cliente,
		pe.ID AS ID_pessoa,
		pe.nome, 
		pe.sobrenome, 
		pe.data_nascimento, 
        pe.NIF,
        DATE_FORMAT(c.data_hora_registo, "%d-%m-%Y %H:%i:%s") AS data_hora_registado_cliente,
        CASE 
			WHEN ic.ID IS NULL AND pa.ID IS NOT NULL THEN "Estrangeiro"
            WHEN ic.ID IS NOT NULL AND pa.ID IS NULL THEN "Cidadão"
            ELSE "Sem dados"
		END AS estrangeiro_ou_cidadao,
        CASE 
			WHEN ic.ID IS NULL AND pa.ID IS NOT NULL THEN pa.ID_passaporte
            WHEN ic.ID IS NOT NULL AND pa.ID IS NULL THEN ic.CC
            ELSE "---"
		END AS documento_identificacao
	FROM TAB_cliente c 
			INNER JOIN TAB_pessoa pe ON c.ID_pessoa = pe.ID
            LEFT JOIN TAB_informacoes_cidadao ic ON pe.ID = ic.ID_pessoa
            LEFT JOIN TAB_passaporte pa ON pe.ID = pa.ID_pessoa;
       
-- DROP VIEW VIEW_hierarquia_ordenada_cargos_atual;
       
CREATE VIEW VIEW_hierarquia_ordenada_cargos_atual AS
WITH RECURSIVE HierarquiaCompleta AS (
    SELECT h.ID, h.ID_cargo_atribuindo, h.ID_cargo_superior, 0 AS distancia
    FROM TAB_hierarquia h
    WHERE h.ID_cargo_superior IS NULL AND obter_definicao_hierarquica_mais_recente(h.ID_cargo_atribuindo) = h.ID
    
    UNION ALL
    
    SELECT h.ID, h.ID_cargo_atribuindo, h.ID_cargo_superior, distancia + 1
    FROM TAB_hierarquia h
    INNER JOIN HierarquiaCompleta hc ON h.ID_cargo_superior = hc.ID_cargo_atribuindo
    WHERE obter_definicao_hierarquica_mais_recente(h.ID_cargo_atribuindo) = h.ID
)
SELECT hc.ID, hc.ID_cargo_atribuindo, ca.designacao AS des_cargo, hc.ID_cargo_superior, cs.designacao AS des_superior, hc.distancia
FROM HierarquiaCompleta hc
INNER JOIN TAB_cargos ca ON hc.ID_cargo_atribuindo = ca.ID
LEFT JOIN TAB_cargos cs ON hc.ID_cargo_superior = cs.ID
ORDER BY hc.distancia ASC, hc.ID_cargo_superior ASC;            
            
-- DROP VIEW IF EXISTS VIEW_informacoes_funcionario;

CREATE VIEW VIEW_informacoes_funcionario AS
SELECT f.ID AS ID_funcionario, 
		pe.ID AS ID_pessoa, 
        pe.nome AS nome,
        pe.sobrenome AS sobrenome,
        pe.data_nascimento AS data_nascimento,
        pe.NIF AS NIF,
        pr.designacao AS profissao,
        
        DATE_FORMAT(c.data_hora_contratado, "%d-%m-%Y   %H:%i") AS data_hora_ultimo_contrato,
        CASE 
			WHEN ut.no_singular = 'ano' THEN DATE_FORMAT(DATE_ADD(c.data_hora_contratado, INTERVAL c.prazo_contrato YEAR), "%d-%m-%Y")
            WHEN ut.no_singular = 'mês' THEN DATE_FORMAT(DATE_ADD(c.data_hora_contratado, INTERVAL c.prazo_contrato MONTH), "%d-%m-%Y")
            WHEN ut.no_singular = 'semana' THEN DATE_FORMAT(DATE_ADD(c.data_hora_contratado, INTERVAL c.prazo_contrato WEEK), "%d-%m-%Y")
            WHEN ut.no_singular = 'dia' THEN DATE_FORMAT(DATE_ADD(c.data_hora_contratado, INTERVAL c.prazo_contrato DAY), "%d-%m-%Y")
		END AS data_termino_contrato
	FROM TAB_funcionario f
			INNER JOIN TAB_pessoa pe ON f.ID_pessoa = pe.ID
            INNER JOIN TAB_profissao pr ON f.ID_profissao = pr.ID
            -- Falta ligar a tabela promocoes_cargos que sera feita com uma view e com ela poderei ligar no inner join abaixo
            INNER JOIN VIEW_hierarquia_ordenada_cargos_atual vhoca ON .ID = vhoca.ID_cargo_atribuindo
            INNER JOIN TAB_contrato c ON obter_contrato_mais_recente(f.ID) = c.ID
            INNER JOIN TAB_unidades_tempo ut ON c.ID_unidade_tempo_prazo_contrato = ut.ID
            -- INNER JOIN TAB_experiencia exp ON f.ID = exp.ID
	ORDER BY ID_funcionario
;


-- ACABAR 

SELECT *
	FROM TAB_