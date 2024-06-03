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
        DATE_FORMAT(pe.data_nascimento, "%d-%m-%Y") AS data_nascimento,
        TIMESTAMPDIFF(year,pe.data_nascimento, CURRENT_DATE()) AS idade,
        pe.NIF AS NIF,
        pr.designacao AS profissao,
        vhoca.des_cargo,
        -- DATE_FORMAT(c.data_hora_contratado, "%d-%m-%Y   %H:%i") AS data_hora_ultimo_contrato,
        DATE_FORMAT(obter_data_termino_contrato(ut.no_singular, co.data_hora_contratado, co.prazo_contrato), "%d-%m-%Y") AS data_termino_contrato,
        IF (obter_data_termino_contrato(ut.no_singular, co.data_hora_contratado, co.prazo_contrato) > CURRENT_DATE() AND (co.data_hora_cancelado IS NULL OR co.data_hora_cancelado > CURRENT_DATE()), DATEDIFF(obter_data_termino_contrato(ut.no_singular, co.data_hora_contratado, co.prazo_contrato), CURRENT_DATE()), "---") AS dias_para_acabar_contrato,
        CASE
			WHEN obter_data_termino_contrato(ut.no_singular, co.data_hora_contratado, co.prazo_contrato) > CURRENT_DATE() AND (co.data_hora_cancelado IS NULL OR co.data_hora_cancelado > CURRENT_DATE()) THEN "Trabalhando"
            WHEN obter_data_termino_contrato(ut.no_singular, co.data_hora_contratado, co.prazo_contrato) <= CURRENT_DATE() AND (co.data_hora_cancelado IS NULL OR co.data_hora_cancelado > CURRENT_DATE()) THEN "Acabou o contrato"
            WHEN (co.data_hora_cancelado IS NOT NULL OR co.data_hora_cancelado <= CURRENT_DATE()) THEN "Despedido"
		END AS estado,
        COALESCE(ca.salario_extra_cargo, 0) + COALESCE(pr.salario_base, 0) + COALESCE(exp.salario_extra_experiencia, 0) AS total_salario
	FROM TAB_funcionario f
			INNER JOIN TAB_pessoa pe ON f.ID_pessoa = pe.ID
            INNER JOIN TAB_profissao pr ON f.ID_profissao = pr.ID
            INNER JOIN TAB_contrato co ON obter_contrato_mais_recente(f.ID) = co.ID
            INNER JOIN TAB_unidades_tempo ut ON co.ID_unidade_tempo_prazo_contrato = ut.ID
            LEFT JOIN TAB_promocoes_cargos pc ON obter_promocao_mais_recente(f.ID) = pc.ID
            LEFT JOIN TAB_cargos ca ON pc.ID_cargo = ca.ID
            LEFT JOIN VIEW_hierarquia_ordenada_cargos_atual vhoca ON pc.ID_cargo = vhoca.ID_cargo_atribuindo
            LEFT JOIN TAB_experiencia exp ON obter_experiencia_mais_recente(f.ID) = exp.ID
	ORDER BY ID_funcionario
;

/*
CREATE VIEW VIEW_detalhes_artigos AS
SELECT *
	FROM TAB_artigos a 
            INNER JOIN TAB_fornecedores f ON a.ID_fornecedor = f.ID
            INNER JOIN TAB_tipos_artigos tia ON a.ID_tipo_artigo = tia.ID
            INNER JOIN TAB_tamanho_artigo taa ON a.ID = taa.ID_artigo
			INNER JOIN TAB_tamanho t ON taa.ID_tamanho = t.ID
			
;



CREATE VIEW VIEW_instalacoes
SELECT *
	FROM TAB_instalacoes


;

*/