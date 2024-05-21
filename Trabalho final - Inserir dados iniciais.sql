USE DB_Bijuteria_Dona_Elvira;

INSERT INTO TAB_unidades_tempo (no_singular, no_plural)
VALUES
	('segundo', 'segundos'),
    ('minuto', 'minutos'),
    ('hora', 'horas'),
    ('dia', 'dias'),
    ('semana', 'semanas'),
    ('mês', 'mêses'),
    ('ano', 'anos');
    
INSERT INTO TAB_relacoes_entre_unidades_tempo (ID_unidade_tempo, n_unidades_tempo_para_proxima, ID_proxima_unidade_tempo)
VALUES
	(1, 60, 2),
    (2, 60, 3),
    (3, 24, 4),
    (4, 7, 5),
    (5, 4.34812141, 6),
    (6, 12, 7);
    
INSERT INTO TAB_promocao (nome, descricao, pode_ser_obtido_todos_meses, quantas_vezes_pode_ser_obtido)
VALUES
	('aniversario', 'quando for seu aniversario terá um desconto de 10% em todos os artigos na nossa bijuteria', 1, NULL),
    ('braceletes dos amigos', 'Ao comprar qualquer bracelete ganhe uma 100% gratis', 0, 1);
    


