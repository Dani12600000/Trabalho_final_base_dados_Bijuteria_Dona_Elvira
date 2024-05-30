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
            
            
CREATE VIEW VIEW_hierarquia_ordenada_cargos AS
WITH RECURSIVE HierarquiaCompleta AS (
    SELECT h.ID, h.ID_cargo_atribuindo, h.ID_cargo_superior, 0 AS distancia
    FROM TAB_hierarquia h
    WHERE h.ID_cargo_superior IS NULL
    
    UNION ALL
    
    SELECT h.ID, h.ID_cargo_atribuindo, h.ID_cargo_superior, distancia + 1
    FROM TAB_hierarquia h
    INNER JOIN HierarquiaCompleta hc ON h.ID_cargo_superior = hc.ID_cargo_atribuindo
)

SELECT hc.ID, hc.ID_cargo_atribuindo, ca.designacao AS des_cargo, hc.ID_cargo_superior, cs.designacao AS des_superior, hc.distancia
FROM HierarquiaCompleta hc
INNER JOIN TAB_cargos ca ON hc.ID_cargo_atribuindo = ca.ID
LEFT JOIN TAB_cargos cs ON hc.ID_cargo_superior = cs.ID
ORDER BY hc.distancia ASC;            

            
-- DROP VIEW IF EXISTS VIEW_informacoes_funcionario;

CREATE VIEW VIEW_informacoes_funcionario AS
SELECT f.ID AS ID_funcionario, 
		pe.ID AS ID_pessoa, 
        pe.nome AS nome,
        pe.sobrenome AS sobrenome,
        pe.data_nascimento AS data_nascimento,
        pe.NIF AS NIF,
        pr.designacao AS profissao
	FROM TAB_funcionario f
			INNER JOIN TAB_pessoa pe ON f.ID_pessoa = pe.ID
            INNER JOIN TAB_profissao pr ON f.ID_profissao = pr.ID
            INNER JOIN TAB_contrato c ON f.ID = c.ID_funcionario
            INNER JOIN TAB_unidades_tempo ut ON c.ID_unidades_tempo_prazo_contrato = ut.ID
            INNER JOIN TAB_experiencia exp ON f.ID = exp.ID
            INNER JOIN TAB_promocoes_cargos pc_promovido ON f.ID = pc_promovido.ID_funcionario_promovido
            

;


-- ACABAR 

SELECT *
	FROM TAB_