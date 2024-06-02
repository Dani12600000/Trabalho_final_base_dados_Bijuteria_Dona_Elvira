USE DB_Bijuteria_Dona_Elvira;

INSERT INTO TAB_profissao (designacao, salario_base)
VALUES
    ('Vendedor', 800.00),
    ('Designer de Joias', 2000.00),
    ('Ourives', 1800.00),
    ('Consultor de Vendas', 900.00),
    ('Assistente Administrativo', 750.00),
    ('Supervisor de Produção', 1300.00),
    ('Técnico em Gemologia', 2200.00),
    ('Programador', 1800.00),
    ('Analista de Sistemas', 2000.00),
    ('Administrador de Redes', 2200.00);

    
INSERT INTO TAB_tipo_instalacoes (designacao, descricao)
VALUES
    ('Loja', 'Espaço destinado à exposição e venda de bijuterias e acessórios.'),
    ('Escritório', 'Local para atividades administrativas, gestão e atendimento aos clientes.'),
    ('Armazém', 'Espaço para armazenamento de artigos.'),
    ('Showroom', 'Ambiente para exibição de peças exclusivas e coleções especiais de bijuterias.');
    
INSERT INTO TAB_tipos_manutencao (designacao, descricao, normalmente_afeta_normal_func)
VALUES
    ('Limpeza', 'Remoção de sujeira e acúmulo de resíduos das instalações e equipamentos.', FALSE),
    ('Reparação', 'Correção de danos e defeitos em máquinas, equipamentos ou estruturas.', TRUE),
    ('Manutenção Preventiva', 'Inspeção e reparo periódicos para evitar falhas e prolongar a vida útil.', FALSE),
    ('Substituição de Peças', 'Troca de componentes desgastados ou danificados por novos.', TRUE),
    ('Calibração', 'Ajuste e verificação de equipamentos para garantir precisão e desempenho adequado.', FALSE);

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
    ('pulseira dos amigos', 'Ao comprar qualquer pulseira ganhe uma 100% gratis', 0, 1);
    
INSERT INTO TAB_tipos_artigos (designacao)
VALUES
    ('Aneis'),
    ('Pulseiras'),
    ('Brincos'),
    ('Colares'),
    ('Tornozeleiras'),
    ('Broches'),
    ('Pingentes'),
    ('Chokers'),
    ('Alfinetes de Gravata');
    
INSERT INTO TAB_promocao_tipo_artigo (ID_promocao, ID_tipo_artigo, acao, quantidade, desconto)
VALUES
	(2, 2, 'compra', 1, NULL),
    (2, 2, 'desconto', 1, 100);
    
INSERT INTO TAB_metodo_pagamento (designacao, comissao_percentagem, comissao_valor)
VALUES
    ('Cartão de Crédito', 1.5, NULL),
    ('Cartão de Débito', 1.0, NULL),
    ('MB Way', 1.2, NULL),
    ('Transferência Bancária', NULL, 0),
    ('Paypal', 2.9, NULL),
    ('Multibanco', 0.8, NULL),
    ('Dinheiro', NULL, 0);
    

INSERT INTO TAB_feriado (designacao, detalhes)
VALUES
	('Ano novo','Dia que comemora a passagem de ano'),
    ('Sexta-feira santa','É a maior data religiosa cristã que relembra a crucificação de Jesus Cristo e sua morte no Calvário'),
    ('Páscoa','Dia em que é comemorado uma festividade religiosa e um feriado que celebra a ressurreição de Jesus ocorrida no terceiro dia após sua crucificação no Calvário, conforme o relato do Novo Testamento.'),
    ('Dia da liberdade','O Dia da Liberdade é comemorado em Portugal a 25 de abril. Este é um dos 13 feriados nacionais obrigatórios. A data celebra a revolta dos militares portugueses.'),
	('Dia do trabalhador', 'Dia dedicada aos trabalhadores'),
    ('Corpo de Deus','A Solenidade do Santíssimo Sacramento do Corpo e do Sangue de Cristo ou Corpus Christi ou Corpus Domini, e generalizada em Portugal como Corpo de Deus, é uma comemoração litúrgica das igrejas Católica'),
    ('Dia de Portugal','O Dia de Portugal, de Camões e das Comunidades Portuguesas celebra a data de 10 de Junho de 1580, data da morte de Camões, sendo também este o dia dedicado ao Anjo Custódio de Portugal. Este é também o dia da Língua Portuguesa, dos cidadãos e das Forças Armadas.'),
    ('Dia de Santo António','Santo António nasceu a 15 de agosto de 1195, em Lisboa, e faleceu a 13 de junho de 1231, em Pádua. Foi assim escolhido o dia 13 para a sua celebração.'),
    ('Dia de São João','Em Portugal, o Dia de São João é celebrado no dia 24 de junho. São João é, tal como Santo António e São Pedro, um santo popular muito festejado em Portugal.'),
    ('Dia da Assunção de Nossa Senhora','A Solenidade da Assunção da Bem-aventurada Virgem Maria é celebrada no dia 15 de agosto, desde o século V, com o significado de "Nascimento para o Céu" ou, segundo a tradição bizantina, de "Dormição".'),
    ('Dia da Implantação da Republica','A República Portuguesa foi proclamada em Lisboa a 5 de outubro de 1910. Nesse dia foi organizado um governo provisório, que tomou o controlo da administração do país, chefiado por Teófilo Braga, um dos teorizadores do movimento republicano nacional.'),
    ('Dia de todos os Santos','Dia de Todos os Santos é uma festa celebrada em honra de todos os santos e mártires, conhecidos ou não. Esta festa é celebrada pelos crentes de muitas das igrejas da religião cristã, por ser herdada a partir da tradição apostólica.'),
    ('Dia da Restauração da Independência','A Restauração da Independência ou Restauração de Portugal, é o nome que se dá ao golpe de Estado revolucionário ocorrido a 1 de Dezembro de 1640'),
    ('Dia de Imaculada Conceição','O dia da Imaculada Conceição, celebrado no dia 8 de dezembro, é feriado nacional. Este dia invoca a vida e a virtude de Virgem Maria, mãe de Jesus'),
    ('Natal','A data é o centro das festas de fim de ano e da temporada de férias, sendo, no cristianismo, o marco inicial do Ciclo do Natal, que dura doze dias.');

INSERT INTO TAB_dia_feriado (ID_feriado, data, n_dias)
VALUES
	(1, '2024-01-01', 1),
    (1, '2025-01-01', 1),
    (1, '2026-01-01', 1),
    (2, '2024-03-29', 1),
    (2, '2025-04-18', 1),
    (2, '2026-04-03', 1),
    (3, '2024-03-31', 1),
    (3, '2025-04-20', 1),
    (3, '2026-04-05', 1),
    (4, '2024-04-25', 1),
    (4, '2024-04-25', 1),
    (4, '2024-04-25', 1),
    (5, '2024-05-01', 1),
    (5, '2025-05-01', 1),
    (5, '2026-05-01', 1),
    (6, '2024-05-30', 1),
    (6, '2025-06-19', 1),
    (6, '2026-06-04', 1),
    (7, '2024-06-10', 1),
    (7, '2025-06-10', 1),
    (7, '2026-06-10', 1),
    (8, '2024-06-13', 1),
    (8, '2025-06-13', 1),
    (8, '2026-06-13', 1),
    (9, '2024-06-24', 1),
    (9, '2025-05-24', 1),
    (9, '2026-05-24', 1),
    (10, '2024-08-15', 1),
    (10, '2025-08-15', 1),
    (10, '2026-08-15', 1),
    (11, '2024-10-05', 1),
    (11, '2025-10-05', 1),
    (11, '2026-10-05', 1),
    (12, '2024-11-01', 1),
    (12, '2025-11-01', 1),
    (12, '2026-11-01', 1),
    (13, '2024-12-01', 1),
    (13, '2025-12-01', 1),
    (13, '2026-12-01', 1),
    (14, '2024-12-08', 1),
    (14, '2025-12-08', 1),
    (14, '2026-12-08', 1),
    (15, '2024-12-25', 3),
    (15, '2025-12-25', 3),
    (15, '2026-12-25', 3);

INSERT INTO TAB_instalacoes (designacao, ID_tipo_instalacoes, morada, localizacao_gps, data_hora_primeira_abertura, data_hora_ultimo_encerramento)
VALUES
    ('Loja Central', 1, 'Rua Principal, 123', ST_GeomFromText('POINT(38.7223 -9.1393)'), '2022-01-01 09:00:00', NULL),
    ('Loja Filial', 1, 'Avenida Secundária, 456', ST_GeomFromText('POINT(38.7111 -9.1432)'), '2022-02-15 10:00:00', NULL),
    ('Escritório Administrativo', 2, 'Avenida das Empresas, 789', ST_GeomFromText('POINT(38.7199 -9.1411)'), '2022-01-20 09:30:00', NULL),
    ('Armazém Central', 3, 'Rua dos Armazéns, 1011', ST_GeomFromText('POINT(38.7200 -9.1399)'), '2022-01-01 08:00:00', NULL),
    ('Showroom', 4, 'Praça das Exibições, 1213', ST_GeomFromText('POINT(38.7250 -9.1400)'), '2022-04-05 11:00:00', NULL);
    
INSERT INTO TAB_horas (hora_aberto, hora_fechado)
VALUES
	('09:00:00', '13:00:00'),
    ('09:00:00', '12:00:00'),
    ('10:00:00', '13:00:00'),
    ('14:00:00', '18:00:00'),
    ('14:00:00', '17:00:00'),
    ('14:00:00', '17:30:00'),
	('15:00:00', '18:00:00');

INSERT INTO TAB_horario (data_entrada_vigor, ID_feriado, ID_instalacoes)
VALUES
	(DATE_ADD(CURDATE(), INTERVAL 7 DAY), NULL, 1);
    
    
INSERT INTO TAB_pessoa (nome, sobrenome, nif, data_nascimento)
VALUE ('Elvira Maria', 'Silva Santos', '208581430', '1960-03-15');

INSERT INTO TAB_funcionario (ID_pessoa, ID_profissao)
VALUE ((SELECT MAX(ID) FROM TAB_pessoa), 1);

INSERT INTO TAB_cargos (designacao, funcoes, salario_extra_cargo)
VALUES
    ('CEO', 'Responsável pela gestão geral da empresa e decisões estratégicas', 4000.00),
    ('Diretor Financeiro', 'Responsável pela gestão financeira da empresa', 3000.00),
    ('Diretor de Marketing', 'Responsável pelas estratégias de marketing e promoção', 2500.00),
    ('Gerente de Recursos Humanos', 'Responsável pela gestão do departamento de RH', 1500.00),
    ('Gerente de TI', 'Responsável pela gestão da infraestrutura de TI', 2000.00),
    ('Gerente de Operações', 'Responsável pela supervisão das operações diárias', 2200.00),
    ('Gerente de Loja', 'Responsável pela gestão e operação de uma loja específica', 500.00),
    ('Chefe de Armazém', 'Responsável pela supervisão do armazém e controle de estoque', 1000.00),
    ('Supervisor de Vendas', 'Responsável pela supervisão da equipe de vendas', 800.00),
    ('Assistente Executivo', 'Apoio administrativo aos executivos da empresa', 200.00),
    ('Coordenador de Logística', 'Responsável pela coordenação das atividades logísticas', 1100.00),
    ('Analista de Marketing', 'Análise e execução de campanhas de marketing', 500.00),
    ('Especialista em SEO', 'Otimização do site e conteúdo para motores de busca', 700.00),
    ('Coordenador de Vendas', 'Coordenar atividades e estratégias de vendas', 1000.00),
    ('Chefe de Produção', 'Supervisionar e coordenar a produção de bijuterias', 1300.00),
    ('Gerente de Projetos', 'Gerenciar e coordenar projetos específicos', 1500.00),
    ('Consultor de TI', 'Fornecer consultoria técnica e suporte de TI', 1200.00),
    ('Líder de Equipe de Design', 'Liderar a equipe de designers de joias', 1400.00),
    ('Coordenador de Segurança da Informação', 'Responsável pela segurança dos dados e informações', 1600.00),
    ('Chefe de Atendimento ao Cliente', 'Supervisionar e coordenar a equipe de atendimento ao cliente', 900.00),
    ('Ourives', 'Fabricação e design de joias', 0.00),  -- Cargo base que correspondente à profissão de Ourives
    ('Designer de Joias', 'Design e criação de joias', 0.00),  -- Cargo base que correspondente à profissão de Designer de Joias
    ('Vendedor', 'Venda e assistência ao cliente', 0.00),  -- Cargo base que correspondente à profissão de Vendedor
    ('Técnico de Gemologia', 'Análise e avaliação de gemas', 0.00),  -- Cargo base que correspondente à profissão de Técnico de Gemologia
    ('Programador Júnior', 'Desenvolvimento de software e aplicativos - Nível Júnior', 0.00),  -- Cargo base que correspondente à profissão de Programador
    ('Programador', 'Desenvolvimento de software e aplicativos - Nível Pleno', 1200.00),  -- Cargo base que correspondente à profissão de Programador
    ('Programador Sênior', 'Desenvolvimento de software e aplicativos - Nível Sênior', 1800.00),  -- Cargo base que correspondente à profissão de Programador
    ('Administrador de Redes', 'Gerenciamento e manutenção de redes', 0.00);  -- Cargo base que correspondente à profissão de Administrador de Redes
    
INSERT INTO TAB_hierarquia (ID_cargo_atribuindo, ID_cargo_superior)
VALUES
    (1, NULL),        -- CEO
    (2, 1),           -- Diretor Financeiro -> CEO
    (3, 1),           -- Diretor de Marketing -> CEO
    (4, 1),           -- Gerente de Recursos Humanos -> CEO
    (5, 1),           -- Gerente de TI -> CEO
    (6, 1),           -- Gerente de Operações -> CEO
    (7, 6),           -- Gerente de Loja -> Gerente de Operações
    (8, 6),           -- Chefe de Armazém -> Gerente de Operações
    (9, 6),           -- Supervisor de Vendas -> Gerente de Operações
    (10, 1),          -- Assistente Executivo -> CEO
    (11, 8),          -- Coordenador de Logística -> Chefe de Armazém
    (12, 3),          -- Analista de Marketing -> Diretor de Marketing
    (13, 3),          -- Especialista em SEO -> Diretor de Marketing
    (14, 9),          -- Coordenador de Vendas -> Supervisor de Vendas
    (15, 6),          -- Chefe de Produção -> Gerente de Operações
    (16, 1),          -- Gerente de Projetos -> CEO
    (17, 5),          -- Consultor de TI -> Gerente de TI
    (18, 3),          -- Líder de Equipe de Design -> Diretor de Marketing
    (19, 5),          -- Coordenador de Segurança da Informação -> Gerente de TI
    (20, 6),          -- Chefe de Atendimento ao Cliente -> Gerente de Operações
    (21, 7),          -- Ourives -> Gerente de Loja
    (22, 7),          -- Designer de Joias -> Gerente de Loja
    (23, 7),          -- Vendedor -> Gerente de Loja
    (24, 8),          -- Técnico em Gemologia -> Chefe de Armazém
    (25, 17),         -- Programador Júnior -> Consultor de TI
    (26, 17),         -- Programador Pleno -> Consultor de TI
    (27, 17),         -- Programador Sênior -> Consultor de TI
    (28, 5),		  -- Administrador de Redes -> Gerente de TI
    (22, 16);         -- Designer de Joias -> Gerente de Projetos
    
INSERT INTO TAB_promocoes_cargos (ID_funcionario_promovido, ID_cargo)
VALUE
	(1, 1);
    
INSERT INTO TAB_experiencia (ID_funcionario, n_anos, salario_extra_experiencia)
VALUE
	(1, 1, 100);
    
INSERT INTO TAB_tamanho (designacao, ID_tipo_artigo, tamanho_min_cm, tamanho_max_cm)
VALUES
    ('Aneis Pequenos', 1, 1.0, 2.0),
    ('Aneis Médios', 1, 2.1, 2.5),
    ('Aneis Grandes', 1, 2.6, 3.0),
    ('Pulseiras Pequenas', 2, 16.0, 18.0),
    ('Pulseiras Médias', 2, 18.1, 20.0),
    ('Pulseiras Grandes', 2, 20.1, 22.0),
    ('Brincos Pequenos', 3, 0.5, 1.0),
    ('Brincos Médios', 3, 1.1, 2.0),
    ('Brincos Grandes', 3, 2.1, 3.0),
    ('Colares Curtos', 4, 40.0, 45.0),
    ('Colares Médios', 4, 45.1, 50.0),
    ('Colares Longos', 4, 50.1, 60.0),
    ('Tornozeleiras Pequenas', 5, 19.0, 21.0),
    ('Tornozeleiras Médias', 5, 21.1, 23.0),
    ('Tornozeleiras Grandes', 5, 23.1, 25.0),
    ('Broches Pequenos', 6, 1.0, 2.0),
    ('Broches Médios', 6, 2.1, 3.5),
    ('Broches Grandes', 6, 3.6, 5.0),
    ('Pingentes Pequenos', 7, 1.0, 2.0),
    ('Pingentes Médios', 7, 2.1, 3.5),
    ('Pingentes Grandes', 7, 3.6, 5.0),
    ('Chokers Curtos', 8, 30.0, 35.0),
    ('Chokers Médios', 8, 35.1, 40.0),
    ('Chokers Longos', 8, 40.1, 45.0),
    ('Alfinetes de Gravata Pequenos', 9, 1.0, 2.0),
    ('Alfinetes de Gravata Médios', 9, 2.1, 3.5),
    ('Alfinetes de Gravata Grandes', 9, 3.6, 5.0);
    
INSERT INTO TAB_fornecedores (nome_empresa, NIF_empresa)
VALUES
    ('Fornecedor A', '123456789'),
    ('Fornecedor B', '987654321'),
    ('Fornecedor C', '112233445'),
    ('Fornecedor D', '556677889'),
    ('Fornecedor E', '998877665');

INSERT INTO TAB_artigos (ID_fornecedor, ID_tipo_artigo, descricao)
VALUES
    (1, 1, 'Anel de ouro 18k com diamantes'),
    (1, 2, 'Pulseira de prata esterlina'),
    (2, 3, 'Brinco de pérola natural'),
    (2, 4, 'Colar de ouro branco com safira'),
    (3, 5, 'Tornozeleira de couro trançado'),
    (3, 6, 'Broche vintage com pedras preciosas'),
    (4, 7, 'Pingente de jade esculpido'),
    (4, 8, 'Choker de renda preta com cristal'),
    (5, 9, 'Alfinete de gravata com design minimalista'),
    (5, 1, 'Anel de prata com esmeralda'),
    (1, 2, 'Pulseira de ouro rosé com rubis'),
    (2, 3, 'Brinco de prata com topázio azul');
    
INSERT INTO TAB_tamanho_artigo (ID_tamanho, ID_artigo)
VALUES
    (2, 1),  -- Aneis Médios para o Anel de ouro 18k com diamantes
    (5, 2),  -- Pulseiras Médias para a Pulseira de prata esterlina
    (8, 3),  -- Brincos Médios para o Brinco de pérola natural
    (11, 4), -- Colares Médios para o Colar de ouro branco com safira
    (14, 5), -- Tornozeleiras Médias para a Tornozeleira de couro trançado
    (17, 6), -- Broches Médios para o Broche vintage com pedras preciosas
    (20, 7), -- Pingentes Médios para o Pingente de jade esculpido
    (23, 8), -- Chokers Médios para o Choker de renda preta com cristal
    (26, 9), -- Alfinetes de Gravata Médios para o Alfinete de gravata com design minimalista
    (2, 10), -- Aneis Médios para o Anel de prata com esmeralda
    (5, 11), -- Pulseiras Médias para a Pulseira de ouro rosé com rubis
    (8, 12); -- Brincos Médios para o Brinco de prata com topázio azul

INSERT INTO TAB_percentagem_lucro_artigo (ID_artigo, percentagem_lucro)
VALUES
	(1, 20.00),
    (2, 18.50),
    (3, 22.00),
    (4, 25.00),
    (5, 19.75),
    (6, 21.50),
    (7, 23.00),
    (8, 20.50),
    (9, 18.00),
    (10, 19.00),
    (11, 20.00),
    (12, 21.00);