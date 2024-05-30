DROP DATABASE IF EXISTS DB_Bijuteria_Dona_Elvira;

CREATE DATABASE DB_Bijuteria_Dona_Elvira;

USE DB_Bijuteria_Dona_Elvira;

CREATE TABLE TAB_pessoa (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome NVARCHAR(255) NOT NULL,
    sobrenome NVARCHAR (255) NOT NULL,
    NIF VARCHAR (25) NOT NULL,
    data_nascimento DATE NOT NULL DEFAULT (DATE_SUB(CURRENT_DATE(), INTERVAL 18 YEAR))
);

CREATE TABLE TAB_morada (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_pessoa INT NOT NULL,
    morada NVARCHAR(255) NOT NULL,
    data_hora_adicionado DATETIME NOT NULL DEFAULT (NOW()),
    data_hora_removido DATETIME,
    FOREIGN KEY (ID_pessoa) REFERENCES TAB_pessoa(ID)
);

CREATE TABLE TAB_morada_preferencial (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_morada INT NOT NULL,
	desde DATETIME NOT NULL DEFAULT (NOW()),
    FOREIGN KEY (ID_morada) REFERENCES TAB_morada(ID)
);

CREATE TABLE TAB_email (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_pessoa INT NOT NULL,
    email VARCHAR(150) NOT NULL,
    data_hora_associacao DATETIME NOT NULL DEFAULT (NOW()),
    data_hora_desassociacao DATETIME,
    FOREIGN KEY (ID_pessoa) REFERENCES TAB_pessoa(ID)
);

CREATE TABLE TAB_email_preferencial (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_email INT NOT NULL,
	desde DATETIME NOT NULL DEFAULT (NOW()),
    FOREIGN KEY (ID_email) REFERENCES TAB_email(ID)
);

CREATE TABLE TAB_telemovel (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_pessoa INT NOT NULL,
    telemovel VARCHAR(25) NOT NULL,
    data_hora_associacao DATETIME NOT NULL DEFAULT (NOW()),
    data_hora_desassociacao DATETIME,
    FOREIGN KEY (ID_pessoa) REFERENCES TAB_pessoa(ID)
);

CREATE TABLE TAB_telemovel_preferencial (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_telemovel INT NOT NULL,
	desde DATETIME NOT NULL DEFAULT (NOW()),
    FOREIGN KEY (ID_telemovel) REFERENCES TAB_telemovel(ID)
);

CREATE TABLE TAB_password (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_pessoa INT NOT NULL,
    password NVARCHAR(255) NOT NULL,
    desde_data_hora DATETIME NOT NULL DEFAULT (NOW()),
    FOREIGN KEY (ID_pessoa) REFERENCES TAB_pessoa(ID)
);

CREATE TABLE TAB_reset_password (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_pessoa INT NOT NULL,
    codigo VARCHAR(12) NOT NULL,
    usado BOOL NOT NULL DEFAULT (0),
    data_hora_requesitado DATE NOT NULL DEFAULT (NOW()),
    data_hora_usado DATE,
    FOREIGN KEY (ID_pessoa) REFERENCES TAB_pessoa(ID)
);

CREATE TABLE TAB_informacoes_cidadao (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_pessoa INT NOT NULL,
    CC VARCHAR(30) NOT NULL,
    FOREIGN KEY (ID_pessoa) REFERENCES TAB_pessoa(ID)
);

CREATE TABLE TAB_passaporte (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_pessoa INT NOT NULL,
    ID_passaporte VARCHAR(100),
    FOREIGN KEY (ID_pessoa) REFERENCES TAB_pessoa(ID)
);

CREATE TABLE TAB_cliente (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_pessoa INT NOT NULL,
    data_hora_registo DATETIME NOT NULL DEFAULT (NOW()),
    FOREIGN KEY (ID_pessoa) REFERENCES TAB_pessoa(ID)
);

CREATE TABLE TAB_profissao (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    designacao NVARCHAR(200),
    salario_base DECIMAL(10,2) NOT NULL DEFAULT (740.83)
);

CREATE TABLE TAB_funcionario (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_pessoa INT NOT NULL,
    ID_profissao INT NOT NULL,
    FOREIGN KEY (ID_pessoa) REFERENCES TAB_pessoa(ID),
    FOREIGN KEY (ID_profissao) REFERENCES TAB_profissao(ID)
);

CREATE TABLE TAB_experiencia (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	ID_funcionario INT NOT NULL,
    n_anos INT NOT NULL DEFAULT (1),
    salario_extra_experiencia DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (ID_funcionario) REFERENCES TAB_funcionario(ID)
);

CREATE TABLE TAB_unidades_tempo (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    no_singular NVARCHAR(10) NOT NULL,
    no_plural NVARCHAR(15) NOT NULL
);

CREATE TABLE TAB_relacoes_entre_unidades_tempo (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_unidade_tempo INT NOT NULL,
    n_unidades_tempo_para_proxima FLOAT NOT NULL,
    ID_proxima_unidade_tempo INT NOT NULL,
    FOREIGN KEY (ID_unidade_tempo) REFERENCES TAB_unidades_tempo(ID),
    FOREIGN KEY (ID_proxima_unidade_tempo) REFERENCES TAB_unidades_tempo(ID)
);

CREATE TABLE TAB_contrato (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_funcionario INT NOT NULL,
    data_hora_contratado DATE,
    prazo_contrato INT,
    ID_unidade_tempo_prazo_contrato INT,
    data_hora_cancelado DATETIME NOT NULL DEFAULT (NOW()),
    ID_funcionario_cancelou INT NOT NULL,
    FOREIGN KEY (ID_funcionario) REFERENCES TAB_funcionario(ID),
    FOREIGN KEY (ID_funcionario_cancelou) REFERENCES TAB_funcionario(ID),
    FOREIGN KEY (ID_unidade_tempo_prazo_contrato) REFERENCES TAB_unidades_tempo(ID)
); 

CREATE TABLE TAB_cargos (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    designacao NVARCHAR(255) NOT NULL,
    funcoes TEXT NOT NULL,
    salario_extra_cargo DECIMAL(10,2)
);

CREATE TABLE TAB_hierarquia (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_cargo_atribuindo INT NOT NULL,
    ID_cargo_superior INT, -- Se vazio quer dizer que não tem superior, ou seja esse cargo é o mais alto de todos
    FOREIGN KEY (ID_cargo_superior) REFERENCES TAB_cargos(ID),
    FOREIGN KEY (ID_cargo_atribuindo) REFERENCES TAB_cargos(ID)
);

CREATE TABLE TAB_promocoes_cargos (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_funcionario_promovido INT NOT NULL,
    ID_funcionario_promovedor INT,
    ID_cargo INT NOT NULL,
    data_promovido DATE NOT NULL DEFAULT (CURRENT_DATE())
);

CREATE TABLE TAB_tipo_instalacoes (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    designacao NVARCHAR(255) NOT NULL,
    descricao TEXT NOT NULL
);

CREATE TABLE TAB_instalacoes (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    designacao NVARCHAR (255) NOT NULL,
    ID_tipo_instalacoes INT NOT NULL,
    morada NVARCHAR(255) NOT NULL,
    localizacao_gps POINT NOT NULL,
    data_hora_primeira_abertura DATETIME NOT NULL DEFAULT (NOW()),
    data_hora_ultimo_encerramento DATETIME,
    FOREIGN KEY (ID_tipo_instalacoes) REFERENCES TAB_tipo_instalacoes(ID)
);

CREATE TABLE TAB_tipos_manutencao (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    designacao NVARCHAR(255) NOT NULL,
    descricao TEXT NOT NULL,
    normalmente_afeta_normal_func BOOL NOT NULL DEFAULT (1)
);

CREATE TABLE TAB_manutencao (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_instalacoes INT NOT NULL,
    ID_tipo_manutencao INT NOT NULL,
    data_hora_comeco DATETIME NOT NULL DEFAULT (NOW()),
    data_hora_termino DATETIME,
    afeta_funcionamento_normal BOOL NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    detalhes TEXT NOT NULL,
    FOREIGN KEY (ID_instalacoes) REFERENCES TAB_instalacoes(ID),
    FOREIGN KEY (ID_tipo_manutencao) REFERENCES TAB_tipos_manutencao(ID)
);

CREATE TABLE TAB_feriado (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    designacao NVARCHAR(255) NOT NULL,
    detalhes TEXT NOT NULL,
    repete_mesma_data_todos_anos BOOL NOT NULL DEFAULT (0)
);

CREATE TABLE TAB_dia_feriado (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_feriado INT NOT NULL,
    data DATE NOT NULL,
    n_dias INT NOT NULL DEFAULT (1),
    FOREIGN KEY (ID_feriado) REFERENCES TAB_feriado(ID)
);

CREATE TABLE TAB_horario (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    data_entrada_vigor DATE NOT NULL DEFAULT (DATE_ADD(CURRENT_DATE(), INTERVAL 1 WEEK)),
    ID_feriado INT,
    ID_instalacoes INT NOT NULL,
    FOREIGN KEY (ID_feriado) REFERENCES TAB_feriado(ID),
    FOREIGN KEY (ID_instalacoes) REFERENCES TAB_instalacoes(ID)
);

CREATE TABLE TAB_horas (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    hora_aberto TIME NOT NULL,
    hora_fechado TIME NOT NULL
);

CREATE TABLE TAB_dia_semana (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    designacao NVARCHAR(255) NOT NULL,
    n_horas_trabalho_esperado INT NOT NULL DEFAULT (7)
);

CREATE TABLE TAB_horas_semana (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_dia_semana INT NOT NULL,
    ID_horas INT NOT NULL,
    ID_horario INT NOT NULL,
    FOREIGN KEY (ID_dia_semana) REFERENCES TAB_dia_semana(ID),
    FOREIGN KEY (ID_horas) REFERENCES TAB_horas(ID),
    FOREIGN KEY (ID_horario) REFERENCES TAB_horario(ID)
);

CREATE TABLE TAB_promocao (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome NVARCHAR(255) NOT NULL,
    descricao TEXT NOT NULL,
    pode_ser_obtido_todos_meses BOOL NOT NULL DEFAULT (1),
    quantas_vezes_pode_ser_obtido INT,
    data_criacao DATE NOT NULL DEFAULT (CURRENT_DATE())
);

CREATE TABLE TAB_validade_promocao (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_promocao INT NOT NULL,
    n_dias_valido_depois_reenvidicado INT,
    data_termino_promocao DATE,
    FOREIGN KEY (ID_promocao) REFERENCES TAB_promocao(ID)
);


CREATE TABLE TAB_promocao_idade_necessaria (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_promocao INT NOT NULL,
    idade_min TINYINT,
    idade_max TINYINT,
    FOREIGN KEY (ID_promocao) REFERENCES TAB_promocao(ID),
    CONSTRAINT chk_idade_min_max_nao_sao_null CHECK (idade_min IS NOT NULL OR idade_max IS NOT NULL)
);

CREATE TABLE TAB_promocao_desconto_monetario_geral (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_promocao INT NOT NULL,
    valor DECIMAL(10,2),
    percentagem DECIMAL(3,2),
    FOREIGN KEY (ID_promocao) REFERENCES TAB_promocao(ID),
    CONSTRAINT chk_valor_percentagem_sao_null CHECK (valor IS NOT NULL OR percentagem IS NOT NULL)
);

CREATE TABLE TAB_metodo_pagamento (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    designacao NVARCHAR(255) NOT NULL,
    comissao_percentagem DECIMAL(3,2),
    comissao_valor DECIMAL(10,2),
    CONSTRAINT chk_comissao_percentagem_valor_sao_null CHECK (comissao_percentagem IS NOT NULL OR comissao_valor IS NOT NULL)
);

CREATE TABLE TAB_promocao_metodo (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_promocao INT NOT NULL,
    ID_metodo_pagamento INT NOT NULL,
    acao VARCHAR(15) NOT NULL CHECK (acao IN ('necessario', 'aplicar')),
    FOREIGN KEY (ID_promocao) REFERENCES TAB_promocao(ID),
    FOREIGN KEY (ID_metodo_pagamento) REFERENCES TAB_metodo_pagamento(ID)
);

CREATE TABLE TAB_promocao_cliente (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_cliente INT NOT NULL,
    ID_promocao INT NOT NULL,
    data_reenvidicado DATE NOT NULL DEFAULT (CURRENT_DATE()),
    FOREIGN KEY (ID_cliente) REFERENCES TAB_cliente(ID),
    FOREIGN KEY (ID_promocao) REFERENCES TAB_promocao(ID)
);

CREATE TABLE TAB_tipos_artigos (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    designacao NVARCHAR(255) NOT NULL,
    detalhes TEXT
);

CREATE TABLE TAB_fornecedores (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome_empresa NVARCHAR(255) NOT NULL,
    NIF_empresa VARCHAR(30) NOT NULL
);

CREATE TABLE TAB_artigos (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_fornecedor INT NOT NULL,
    ID_tipo_artigo INT NOT NULL,
    descricao TEXT NOT NULL,
    FOREIGN KEY (ID_fornecedor) REFERENCES TAB_fornecedores(ID),
    FOREIGN KEY (ID_tipo_artigo) REFERENCES TAB_tipos_artigos(ID)
);

CREATE TABLE TAB_promocao_tipo_artigo (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_promocao INT NOT NULL,
    ID_tipo_artigo INT NOT NULL,
    acao VARCHAR(20) CHECK (acao IN ('compra', 'desconto')),
    quantidade INT NOT NULL DEFAULT (1),
    desconto DECIMAL(5,2),
    FOREIGN KEY (ID_promocao) REFERENCES TAB_promocao(ID),
    FOREIGN KEY (ID_tipo_artigo) REFERENCES TAB_tipos_artigos(ID),
    CONSTRAINT chk_acao_desconto_artigo CHECK (
		(acao = 'desconto' AND desconto IS NOT NULL AND desconto <= 100) OR 
        (acao = 'compra' AND desconto IS NULL)
	)
);

CREATE TABLE TAB_promocao_artigo (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_promocao INT NOT NULL,
    ID_artigo INT NOT NULL,
    acao VARCHAR(20) CHECK (acao IN ('compra', 'desconto')),
    quantidade INT NOT NULL DEFAULT (1),
    desconto DECIMAL(3,2),
    FOREIGN KEY (ID_promocao) REFERENCES TAB_promocao(ID),
    FOREIGN KEY (ID_artigo) REFERENCES TAB_artigos(ID),
    CONSTRAINT chk_acao_desconto_tipo_artigo CHECK (acao = 'desconto' AND desconto IS NOT NULL OR acao = 'compra' AND desconto IS NULL)
);

CREATE TABLE TAB_tamanho (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    designacao NVARCHAR(255) NOT NULL,
    ID_tipo_artigo INT NOT NULL,
    tamanho_min_cm FLOAT NOT NULL,
    tamanho_max_cm FLOAT NOT NULL,
    FOREIGN KEY (ID_tipo_artigo) REFERENCES TAB_tipos_artigos(ID)
);

CREATE TABLE TAB_tamanho_artigo (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_tamanho INT NOT NULL,
    ID_artigo INT NOT NULL,
    desde DATE NOT NULL DEFAULT (CURRENT_DATE()),
    FOREIGN KEY (ID_tamanho) REFERENCES TAB_tamanho(ID),
    FOREIGN KEY (ID_artigo) REFERENCES TAB_artigos(ID)
);

CREATE TABLE TAB_stock_artigo (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_artigo INT NOT NULL,
    quantidade INT NOT NULL DEFAULT (1),
    data_hora_requesitado DATETIME NOT NULL DEFAULT (NOW()),
    data_hora_envio DATETIME,
    data_hora_chegada DATETIME,
    ID_instalacoes_destino INT NOT NULL,
    ID_metodo_pagamento INT NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL, -- Valor total da compra para stock do cujo
    FOREIGN KEY (ID_artigo) REFERENCES TAB_artigos(ID),
    FOREIGN KEY (ID_instalacoes_destino) REFERENCES TAB_instalacoes(ID),
    FOREIGN KEY (ID_metodo_pagamento) REFERENCES TAB_metodo_pagamento(ID)
);

CREATE TABLE TAB_percentagem_lucro_artigo (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_artigo INT NOT NULL,
    percentagem_lucro DECIMAL(3,2) NOT NULL DEFAULT (15),
    data_hora_mudado DATETIME NOT NULL DEFAULT (NOW()),
    data_hora_aplicado DATETIME NOT NULL DEFAULT (DATE_ADD(NOW(), INTERVAL 4 DAY))
);

CREATE TABLE TAB_requesicao_artigo (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	ID_artigo INT NOT NULL,
    data_hora_requesicao DATETIME NOT NULL DEFAULT (NOW()),
    quantidade INT NOT NULL DEFAULT (1),
    FOREIGN KEY (ID_artigo) REFERENCES TAB_artigos(ID)
);

CREATE TABLE TAB_transferencias (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_funcionario_responsavel_transferencia INT NOT NULL,
    ID_instalacoes_destino INT NOT NULL,
    data_hora_termino_transferencia DATETIME,
    FOREIGN KEY (ID_funcionario_responsavel_transferencia) REFERENCES TAB_funcionario(ID),
    FOREIGN KEY (ID_instalacoes_destino) REFERENCES TAB_instalacoes(ID)
);

CREATE TABLE TAB_artigo_para_transferencia (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_transferencia INT NOT NULL,
    ID_artigo INT NOT NULL,
    quantidade INT NOT NULL,
    data_hora_adicionado DATETIME NOT NULL DEFAULT (NOW()),
    detalhes TEXT,
    FOREIGN KEY (ID_transferencia) REFERENCES TAB_transferencias(ID),
    FOREIGN KEY (ID_artigo) REFERENCES TAB_artigos(ID)
);

CREATE TABLE TAB_venda (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_artigo INT NOT NULL,
    ID_metodo_pagamento INT NOT NULL,
    ID_cliente INT NOT NULL,
    compra_online BOOL NOT NULL,
    ID_instalacoes_compra_recolha INT NOT NULL,
    ID_funcionario INT NOT NULL,
    data_hora_pedido DATETIME NOT NULL DEFAULT (NOW()),
    data_hora_recolha DATETIME,
    FOREIGN KEY (ID_artigo) REFERENCES TAB_artigos(ID),
    FOREIGN KEY (ID_metodo_pagamento) REFERENCES TAB_metodo_pagamento(ID),
    FOREIGN KEY (ID_cliente) REFERENCES TAB_cliente(ID),
    FOREIGN KEY (ID_instalacoes_compra_recolha) REFERENCES TAB_instalacoes(ID),
    FOREIGN KEY (ID_funcionario) REFERENCES TAB_funcionario(ID)
);

CREATE TABLE TAB_troca (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_venda INT NOT NULL, -- Venda em que foi vendido o artigo que está a ser trocado por outro
    motivo TEXT NOT NULL, -- Motivo para tal
    ID_artigo_dado INT NOT NULL, -- Artigo que foi dado na troca do recebido
    ID_funcionario INT NOT NULL, -- Funcionario que fez a troca
    ID_instalacoes INT NOT NULL, -- Instalacoes que foi feita a troca
    data_hora DATETIME NOT NULL DEFAULT (NOW()), -- as horas que aconteceu a troca
    FOREIGN KEY (ID_venda) REFERENCES TAB_venda(ID),
    FOREIGN KEY (ID_artigo_dado) REFERENCES TAB_artigos(ID),
    FOREIGN KEY (ID_funcionario) REFERENCES TAB_funcionario(ID),
    FOREIGN KEY (ID_instalacoes) REFERENCES TAB_instalacoes(ID)
);