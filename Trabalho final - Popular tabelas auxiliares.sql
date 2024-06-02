USE DB_Bijuteria_Dona_Elvira;

INSERT INTO TAB_AUX_pessoa (primeiro_nome, segundo_nome, terceiro_nome, quarto_nome)
VALUES
    ('João', 'Pedro', 'Silva', 'Santos'),
    ('Maria', 'Clara', 'Oliveira', 'Pereira'),
    ('Carlos', 'Eduardo', 'Mendes', 'Gomes'),
    ('Ana', 'Luísa', 'Almeida', 'Fernandes'),
    ('Paulo', 'Roberto', 'Barbosa', 'Lima'),
    ('Fernanda', 'Cristina', 'Ribeiro', 'Martins'),
    ('José', 'Antonio', 'Costa', 'Sousa'),
    ('Mariana', 'Beatriz', 'Dias', 'Rocha'),
    ('Ricardo', 'Alexandre', 'Nogueira', 'Carvalho'),
    ('Luciana', 'Fernandes', 'Teixeira', 'Vieira'),
    ('Pedro', 'Henrique', 'Ferreira', 'Azevedo'),
    ('Juliana', 'Santos', 'Moreira', 'Correia'),
    ('Rafael', 'Rodrigues', 'Gonçalves', 'Melo'),
    ('Isabela', 'Freitas', 'Lopes', 'Moura'),
    ('Tiago', 'Felipe', 'Moraes', 'Silveira'),
    ('Camila', 'Fernanda', 'Pires', 'Ramos'),
    ('Gabriel', 'Duarte', 'Vieira', 'Santos'),
    ('Lorena', 'Sophia', 'Nunes', 'Silva'),
    ('Gustavo', 'Lucas', 'Carvalho', 'Martins'),
    ('Aline', 'Carolina', 'Lima', 'Alves'),
    ('Daniel', 'Oliveira', NULL, 'Pereira'),
    ('Beatriz', 'Macedo', NULL, 'Teixeira'),
    ('Liliana', 'de', 'Oliveira', 'Pratas'),
    ('Francisco', 'Rafael', 'Santos', 'Casado');
    
INSERT INTO TAB_AUX_cargos_profissoes (ID_cargo, ID_profissao)
VALUES
	(2, 4), -- Diretor Financeiro
    (3, 1), -- Diretor de Marketing
    (4, 6), -- Gerente de Recursos Humanos
    (5, 9), -- Gerente de TI
    (6, 5), -- Gerente de Operações
    (7, 1), -- Gerente de Loja
    (8, 5), -- Chefe de Armazém
    (9, 1), -- Supervisor de Vendas
    (10, 5), -- Assistente Executivo
    (11, 5), -- Coordenador de Logística
    (12, 4), -- Analista de Marketing
    (13, 9), -- Especialista em SEO
    (14, 4), -- Coordenador de Vendas
    (15, 6), -- Chefe de Produção
    (16, 6), -- Gerente de Projetos
    (17, 9), -- Consultor de TI
    (18, 2), -- Líder de Equipe de Design
    (19, 9), -- Coordenador de Segurança da Informação
    (20, 1), -- Chefe de Atendimento ao Cliente
    (21, 3), -- Ourives
    (22, 2), -- Designer de Joias
    (23, 1), -- Vendedor
    (24, 7), -- Técnico de Gemologia
    (25, 8), -- Programador Júnior
    (26, 8), -- Programador
    (27, 8), -- Programador Sênior
    (28, 10); -- Administrador de Redes