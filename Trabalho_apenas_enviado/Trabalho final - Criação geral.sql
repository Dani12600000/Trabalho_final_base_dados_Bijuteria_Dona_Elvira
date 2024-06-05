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
    data_hora DATETIME NOT NULL DEFAULT (NOW()),
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
    data_hora_contratado DATETIME,
    prazo_contrato INT,
    ID_unidade_tempo_prazo_contrato INT,
    data_hora_cancelado DATETIME,
    ID_funcionario_cancelou INT,
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
    data_hora DATETIME NOT NULL DEFAULT (NOW()),
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
    percentagem DECIMAL(5,2),
    FOREIGN KEY (ID_promocao) REFERENCES TAB_promocao(ID),
    CONSTRAINT chk_valor_percentagem_sao_null CHECK (valor IS NOT NULL OR percentagem IS NOT NULL)
);

CREATE TABLE TAB_metodo_pagamento (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    designacao NVARCHAR(255) NOT NULL,
    comissao_percentagem DECIMAL(5,2),
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
    desconto DECIMAL(5,2),
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
    ID_metodo_pagamento INT,
    valor_total DECIMAL(10,2), -- Valor total da compra para stock do cujo
    FOREIGN KEY (ID_artigo) REFERENCES TAB_artigos(ID),
    FOREIGN KEY (ID_instalacoes_destino) REFERENCES TAB_instalacoes(ID),
    FOREIGN KEY (ID_metodo_pagamento) REFERENCES TAB_metodo_pagamento(ID)
);

CREATE TABLE TAB_percentagem_lucro_artigo (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_artigo INT NOT NULL,
    percentagem_lucro DECIMAL(5,2) NOT NULL DEFAULT (15),
    data_hora_mudado DATETIME NOT NULL DEFAULT (NOW()),
    data_hora_aplicado DATETIME NOT NULL DEFAULT (DATE_ADD(NOW(), INTERVAL 4 DAY))
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
    ID_instalacoes_origem INT NOT NULL,
    quantidade INT NOT NULL,
    data_hora_adicionado DATETIME NOT NULL DEFAULT (NOW()),
    detalhes TEXT,
    FOREIGN KEY (ID_transferencia) REFERENCES TAB_transferencias(ID),
    FOREIGN KEY (ID_artigo) REFERENCES TAB_artigos(ID),
    FOREIGN KEY (ID_instalacoes_origem) REFERENCES TAB_instalacoes(ID)
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

DELIMITER //

CREATE EVENT verifica_aniversariantes
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_DATE() + INTERVAL 1 DAY
DO
BEGIN
	CREATE TABLE IF NOT EXISTS logs_aniversariantes (
		ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		ID_cliente INT NOT NULL,
		data_aniversario DATE NOT NULL,
		FOREIGN KEY (ID_cliente) REFERENCES TAB_cliente(ID)
	);

	
    INSERT INTO logs_aniversariantes (ID_cliente, data_aniversario)
    SELECT c.ID, CURDATE()
    FROM TAB_pessoa p INNER JOIN TAB_cliente c ON p.ID = c.ID_pessoa
    WHERE proxima_data(data_nascimento) = CURDATE();
END;
//

DELIMITER ;


CREATE TABLE IF NOT EXISTS logs_clientes (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	ID_cliente INT NOT NULL,
	data_hora DATETIME NOT NULL DEFAULT (NOW()),
	acao VARCHAR(30) NOT NULL CHECK (acao IN ('INSERT', 'DELETE', 'UPDATE')),
	detalhes TEXT NOT NULL
);


DELIMITER //

CREATE TRIGGER adicao_cliente AFTER INSERT ON TAB_cliente
FOR EACH ROW 
BEGIN
	DECLARE nome_pessoa NVARCHAR(255);
    
    SELECT CONCAT(nome, ' ', sobrenome) INTO nome_pessoa
		FROM TAB_pessoa
        WHERE ID = NEW.ID_pessoa;

    INSERT INTO logs_clientes (ID_cliente, acao, detalhes)
    VALUES (NEW.ID, 'INSERT', CONCAT('Foi inserido um novo cliente com o ID pessoa ', NEW.ID_pessoa, ' e chamada ', nome_pessoa));
END;
//

CREATE TRIGGER remocao_cliente AFTER DELETE ON TAB_cliente
FOR EACH ROW 
BEGIN
	DECLARE nome_pessoa NVARCHAR(255);
    
    SELECT CONCAT(nome, ' ', sobrenome) INTO nome_pessoa
		FROM TAB_pessoa
        WHERE ID = OLD.ID_pessoa;

    INSERT INTO logs_clientes (ID_cliente, acao, detalhes)
    VALUES (OLD.ID, 'DELETE', CONCAT('Foi removido um cliente com o ID pessoa ', OLD.ID_pessoa, ' e chamada ', nome_pessoa));
END;
//

CREATE TRIGGER update_cliente AFTER UPDATE ON TAB_cliente
FOR EACH ROW 
BEGIN
	DECLARE nome_pessoa NVARCHAR(255);
		
	INSERT INTO logs_clientes (ID_cliente, acao, detalhes)
	VALUES (OLD.ID, 'UPDATE', CONCAT('Foi atualizado um cliente que tinha o ID pessoa ', OLD.ID_pessoa, ' para ', NEW.ID_pessoa));
END;
//

DELIMITER ;

CREATE TABLE IF NOT EXISTS logs_pessoas (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	ID_cliente INT NOT NULL,
	data_hora DATETIME NOT NULL DEFAULT (NOW()),
	acao VARCHAR(30) NOT NULL CHECK (acao IN ('INSERT', 'DELETE', 'UPDATE')),
	detalhes TEXT NOT NULL
);


DELIMITER //

CREATE TRIGGER adicao_pessoa AFTER INSERT ON TAB_pessoa
FOR EACH ROW 
BEGIN
    INSERT INTO logs_pessoas (ID_cliente, acao, detalhes)
    VALUES (NEW.ID, 'INSERT', CONCAT('Foi inserido uma nova pessoa com o nome ', NEW.nome, ' ', NEW.sobrenome, ' e data de nascimento na data ', NEW.data_nascimento));
END;
//

CREATE TRIGGER remocao_pessoa AFTER DELETE ON TAB_pessoa
FOR EACH ROW 
BEGIN
    INSERT INTO logs_pessoas (ID_cliente, acao, detalhes)
    VALUES (OLD.ID, 'DELETE', CONCAT('Foi removida uma pessoa com o nome ', OLD.nome, ' ', OLD.sobrenome));
END;
//

CREATE TRIGGER update_pessoa AFTER UPDATE ON TAB_pessoa
FOR EACH ROW 
BEGIN

	DECLARE text_ocuration_description VARCHAR(255);
	
    IF NEW.nome <> OLD.nome AND NEW.sobrenome <> OLD.sobrenome AND NEW.data_nascimento <> OLD.data_nascimento THEN
		SET text_ocuration_description = CONCAT('Foi atualizado todos os dadaos de uma pessoa com o nome ', OLD.nome, ' ', OLD.sobrenome, ' e data de nascimento no dia ', OLD.data_nascimento,' para ', NEW.nome, ' ', NEW.sobrenome, ' e data de nascimento ', NEW.data_nascimento);
	
    ELSE
		IF (NEW.nome <> OLD.nome AND NEW.sobrenome <> OLD.sobrenome) AND NEW.data_nascimento = OLD.data_nascimento THEN
			SET text_ocuration_description = CONCAT('Foi atualizado o nome completo de uma pessoa com o nome ', OLD.nome, ' ', OLD.sobrenome, ' para ', NEW.nome, ' ', NEW.sobrenome);
		ELSEIF (NEW.nome <> OLD.nome OR NEW.sobrenome <> OLD.sobrenome) AND NEW.data_nascimento = OLD.data_nascimento  THEN
			IF NEW.nome <> OLD.nome THEN
				SET text_ocuration_description = CONCAT('Foi atualizado o nome de uma pessoa com o nome', OLD.nome, ' para ', NEW.nome);
			END IF;
			
			IF NEW.sobrenome <> OLD.sobrenome THEN
				SET text_ocuration_description = CONCAT('Foi atualizado o nome de uma pessoa com o sobrenome', OLD.sobrenome, ' para ', NEW.sobrenome);
			END IF;
		ELSEIF (NEW.nome <> OLD.nome OR NEW.sobrenome <> OLD.sobrenome) AND NEW.data_nascimento = OLD.data_nascimento  THEN
			IF NEW.nome <> OLD.nome THEN
				SET text_ocuration_description = CONCAT('Foi atualizado o nome e data de nascimento de uma pessoa com o nome', OLD.nome, ' e data de nascimento ', OLD.data_nascimento, ' para ', NEW.nome, ' e data nascimento ', NEW.data_nascimento);
			END IF;
			
			IF NEW.sobrenome <> OLD.sobrenome THEN
				SET text_ocuration_description = CONCAT('Foi atualizado o nome e data de nascimento de uma pessoa com o sobrenome', OLD.sobrenome, ' e data de nascimento ', OLD.data_nascimento, ' para ', NEW.sobrenome, ' e data nascimento ', NEW.data_nascimento);
			END IF;
		END IF;
		
        
		IF NEW.data_nascimento <> OLD.data_nascimento THEN
			SET text_ocuration_description = CONCAT('Foi atualizado a data de nascimento de uma pessoa que tinha para dia', OLD.data_nascimento, ' para ', NEW.data_nascimento);
		END IF;
	END IF;
    
    
    INSERT INTO logs_pessoas (ID_cliente, acao, detalhes)
	VALUES (OLD.ID, 'UPDATE', text_ocuration_description);
END;

//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_stock_artigo_before_insert
BEFORE INSERT ON TAB_stock_artigo
FOR EACH ROW
BEGIN
    -- Se data_hora_chegada não for NULL, data_hora_envio também não pode ser NULL
    IF NEW.data_hora_chegada IS NOT NULL AND NEW.data_hora_envio IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'data_hora_envio não pode ser NULL quando data_hora_chegada não é NULL';
    END IF;

    -- Se data_hora_envio for NULL, ID_metodo_pagamento deve ser NULL e valor_total pode ser NULL
    IF NEW.data_hora_envio IS NOT NULL AND (NEW.ID_metodo_pagamento IS NULL OR NEW.valor_total IS NULL) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ID_metodo_pagamento e/ou valor_total deve ter valores quando data_hora_envio não é NULL';
    END IF;

    -- Se metodo_pagamento não for NULL e valor_total é null ou vice versa
    IF (NEW.ID_metodo_pagamento IS NOT NULL AND NEW.valor_total IS NULL) OR (NEW.ID_metodo_pagamento IS NULL AND NEW.valor_total IS NOT NULL) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'valor_total ou metodo_pagamento não pode ser NULL quando o valor_total ou metodo_pagamento não é NULL';
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_stock_artigo_before_update
BEFORE UPDATE ON TAB_stock_artigo
FOR EACH ROW
BEGIN
    -- Se data_hora_chegada não for NULL, data_hora_envio também não pode ser NULL
    IF NEW.data_hora_chegada IS NOT NULL AND NEW.data_hora_envio IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'data_hora_envio não pode ser NULL quando data_hora_chegada não é NULL';
    END IF;

    -- Se data_hora_envio for NULL, ID_metodo_pagamento deve ser NULL e valor_total pode ser NULL
    IF NEW.data_hora_envio IS NOT NULL AND (NEW.ID_metodo_pagamento IS NULL OR NEW.valor_total IS NULL) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ID_metodo_pagamento e/ou valor_total deve ter valores quando data_hora_envio não é NULL';
    END IF;

    -- Se metodo_pagamento não for NULL e valor_total é null ou vice versa
    IF (NEW.ID_metodo_pagamento IS NOT NULL AND NEW.valor_total IS NULL) OR (NEW.ID_metodo_pagamento IS NULL AND NEW.valor_total IS NOT NULL) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'valor_total ou metodo_pagamento não pode ser NULL quando o valor_total ou metodo_pagamento não é NULL';
    END IF;
END //

DELIMITER ;

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
    
INSERT INTO TAB_dia_semana (designacao, n_horas_trabalho_esperado)
VALUES
	('Domingo', 4),
    ('Segunda-Feira', 9),
    ('Terça-Feira', 9),
    ('Quarta-Feira', 9),
    ('Quinta-Feira', 9),
    ('Sexta-Feira', 8),
    ('Sábado', 0);

INSERT INTO TAB_horario (data_entrada_vigor, ID_feriado, ID_instalacoes)
VALUES
	(DATE_ADD(CURDATE(), INTERVAL 7 DAY), NULL, 1);
    
INSERT INTO TAB_horas_semana (ID_dia_semana, ID_horas, ID_horario)
VALUES
	(1, 7, 1),
    (2, 1, 1),
    (2, 4, 1),
    (3, 1, 1),
    (3, 4, 1),
    (4, 1, 1),
    (4, 4, 1),
    (5, 1, 1),
    (5, 4, 1),
    (6, 1, 1),
    (6, 5, 1);
    
    
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
    
INSERT INTO TAB_stock_artigo (ID_artigo, quantidade, ID_instalacoes_destino, data_hora_envio, ID_metodo_pagamento, valor_total, data_hora_chegada)
VALUE
	(1, 10, 4, '2024-06-02 20:40', 3, 100.00, '2024-06-03 10:00:00'),
    (1, 5, 4, '2024-06-02 21:40', 3, 100.00, '2024-06-03 12:00:00');
    
INSERT INTO TAB_venda (ID_artigo, ID_metodo_pagamento, ID_cliente, ID_funcionario, compra_online, ID_instalacoes_compra_recolha)
VALUE
	(
		1,
		(SELECT ID FROM TAB_metodo_pagamento ORDER BY RAND() LIMIT 1),
        (SELECT ID FROM TAB_cliente ORDER BY RAND() LIMIT 1),
        (SELECT ID FROM TAB_funcionario ORDER BY RAND() LIMIT 1),
        FALSE,
        (SELECT ID FROM TAB_instalacoes WHERE designacao LIKE "%loja%" ORDER BY RAND() LIMIT 1)
	);
    
INSERT INTO TAB_transferencias (ID_funcionario_responsavel_transferencia, ID_instalacoes_destino, data_hora_termino_transferencia)
VALUES
	((SELECT ID FROM TAB_funcionario ORDER BY RAND() LIMIT 1), 1, '2024-06-03 19:35:00'),
    ((SELECT ID FROM TAB_funcionario ORDER BY RAND() LIMIT 1), 2, '2024-06-03 19:40:00'),
    ((SELECT ID FROM TAB_funcionario ORDER BY RAND() LIMIT 1), 1, '2024-06-10 20:00:00'),
    ((SELECT ID FROM TAB_funcionario ORDER BY RAND() LIMIT 1), 2, '2024-06-10 20:00:00');
    
INSERT INTO TAB_artigo_para_transferencia (ID_transferencia, ID_artigo, ID_instalacoes_origem, quantidade, data_hora_adicionado, detalhes)
VALUES
	(1, 1, 4, 3, '2024-06-03 19:25:00', ''),
    (2, 1, 4, 3, '2024-06-03 19:30:00', 'Houve um pequeno atraso'),
    (3, 1, 4, 2, '2024-06-03 20:00:00', 'Ta a haver uma pequena greve'),
    (4, 1, 4, 2, '2024-06-05 19:30:00', 'Ta a haver uma pequena greve');

CREATE TABLE TAB_AUX_pessoa (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    primeiro_nome NVARCHAR(50) NOT NULL,
    segundo_nome NVARCHAR(50),
    terceiro_nome NVARCHAR(50),
    quarto_nome NVARCHAR(50) NOT NULL
);

CREATE TABLE TAB_AUX_cargos_profissoes (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_cargo INT NOT NULL,
    ID_profissao INT NOT NULL,
    FOREIGN KEY (ID_cargo) REFERENCES TAB_cargos(ID),
    FOREIGN KEY (ID_profissao) REFERENCES TAB_profissao(ID)
);

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

DELIMITER //

CREATE FUNCTION obter_nome_aleatorio()
RETURNS VARCHAR(255) READS SQL DATA
BEGIN
    DECLARE primeiro_nome_aleatorio NVARCHAR(50);
    DECLARE segundo_nome_aleatorio NVARCHAR(50);
    DECLARE nome NVARCHAR(110);

    SELECT primeiro_nome INTO primeiro_nome_aleatorio
    FROM TAB_AUX_pessoa
    ORDER BY RAND()
    LIMIT 1;
    
    SELECT segundo_nome INTO segundo_nome_aleatorio
    FROM TAB_AUX_pessoa
    ORDER BY RAND()
    LIMIT 1;
    
    IF segundo_nome_aleatorio IS NULL THEN
		SET nome = primeiro_nome_aleatorio;
	ELSE
		SET nome = CONCAT(primeiro_nome_aleatorio, ' ', segundo_nome_aleatorio);
	END IF;

    RETURN nome;
END;
//

DELIMITER ;

DELIMITER //

CREATE FUNCTION obter_sobrenome_aleatorio()
RETURNS VARCHAR(255) READS SQL DATA
BEGIN
    DECLARE terceiro_nome_aleatorio NVARCHAR(50);
    DECLARE quarto_nome_aleatorio NVARCHAR(50);
    DECLARE sobrenome NVARCHAR(110);
    
    SELECT terceiro_nome INTO terceiro_nome_aleatorio
    FROM TAB_AUX_pessoa
    ORDER BY RAND()
    LIMIT 1;
    
    SELECT quarto_nome INTO quarto_nome_aleatorio
    FROM TAB_AUX_pessoa
    ORDER BY RAND()
    LIMIT 1;
    
    IF terceiro_nome_aleatorio IS NULL THEN
		SET sobrenome = quarto_nome_aleatorio;
	ELSE
		SET sobrenome = CONCAT(terceiro_nome_aleatorio, ' ', quarto_nome_aleatorio);
	END IF;

    RETURN sobrenome;
END;
//

DELIMITER ;

DELIMITER //

CREATE FUNCTION gerar_nif()
RETURNS CHAR(9)
DETERMINISTIC
BEGIN
    DECLARE nif_base CHAR(8);
    DECLARE nif CHAR(9);
    DECLARE sum INT;
    DECLARE check_digit INT;

    SET nif_base = LPAD(FLOOR(RAND() * 100000000), 8, '0');

    SET sum = 0;
    SET sum = sum + SUBSTRING(nif_base, 1, 1) * 9;
    SET sum = sum + SUBSTRING(nif_base, 2, 1) * 8;
    SET sum = sum + SUBSTRING(nif_base, 3, 1) * 7;
    SET sum = sum + SUBSTRING(nif_base, 4, 1) * 6;
    SET sum = sum + SUBSTRING(nif_base, 5, 1) * 5;
    SET sum = sum + SUBSTRING(nif_base, 6, 1) * 4;
    SET sum = sum + SUBSTRING(nif_base, 7, 1) * 3;
    SET sum = sum + SUBSTRING(nif_base, 8, 1) * 2;
    
    SET check_digit = 11 - (sum % 11);
    
    IF check_digit >= 10 THEN
        SET check_digit = 0;
    END IF;

    SET nif = CONCAT(nif_base, check_digit);

    RETURN nif;
END; 
//

DELIMITER ;

DELIMITER //

CREATE FUNCTION gerar_cc()
RETURNS CHAR(12)
DETERMINISTIC
BEGIN
    DECLARE letras CHAR(2);
    DECLARE numeros CHAR(9);
    DECLARE cc CHAR(12);

    -- Gerar duas letras aleatórias (A-Z)
    SET letras = CHAR(FLOOR(65 + RAND() * 26));
    SET letras = CONCAT(letras, CHAR(FLOOR(65 + RAND() * 26)));

    -- Gerar nove números aleatórios (0-9)
    SET numeros = LPAD(FLOOR(RAND() * 1000000000), 9, '0');

    -- Concatenar letras e números para formar o ID do CC
    SET cc = CONCAT(letras, numeros);

    RETURN cc;
END; 
//

DELIMITER ;

DELIMITER //

CREATE FUNCTION gerar_passaporte()
RETURNS CHAR(9)
DETERMINISTIC
BEGIN
    DECLARE letras CHAR(3);
    DECLARE numeros CHAR(6);
    DECLARE passaporte CHAR(9);

    -- Gerar três letras aleatórias (A-Z)
    SET letras = CHAR(FLOOR(65 + RAND() * 26));
    SET letras = CONCAT(letras, CHAR(FLOOR(65 + RAND() * 26)));
    SET letras = CONCAT(letras, CHAR(FLOOR(65 + RAND() * 26)));

    -- Gerar seis números aleatórios (0-9)
    SET numeros = LPAD(FLOOR(RAND() * 1000000), 6, '0');

    -- Concatenar letras e números para formar o ID do passaporte
    SET passaporte = CONCAT(letras, numeros);

    RETURN passaporte;
END; 
//

DELIMITER ;


DELIMITER //

CREATE PROCEDURE ExecutarInsercaoRegistosMultiplosPessoas(IN vezes INT)
BEGIN
    DECLARE contador INT;

    SET contador = 1;

    WHILE contador <= vezes DO
        INSERT INTO TAB_pessoa (nome, sobrenome, NIF, data_nascimento) 
        VALUES (
			obter_nome_aleatorio(), 
            obter_sobrenome_aleatorio(),
            gerar_nif(),
            DATE_SUB(CURRENT_DATE(), INTERVAL FLOOR(RAND() * (365 * (90 - 18) + 1) + (365 * 18)) DAY)
		);
        SET contador = contador + 1;
    END WHILE;
END;
//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE ExecutarInsercaoRegistosMultiplosClientes(IN vezes INT)
BEGIN
    DECLARE contador INT;
    DECLARE ID_cliente_aleatorio INT;

    SET contador = 1;

    WHILE contador <= vezes DO
		SELECT ID INTO ID_cliente_aleatorio 
			FROM TAB_pessoa 
            WHERE ID NOT IN (SELECT ID_pessoa FROM TAB_cliente)
            ORDER BY RAND()
			LIMIT 1;
    
        INSERT INTO TAB_cliente (ID_pessoa, data_hora_registo) 
        VALUES (
			ID_cliente_aleatorio, 
            DATE_SUB(CURRENT_DATE(), INTERVAL FLOOR(RAND() * 79200) MINUTE)
		);
        SET contador = contador + 1;
    END WHILE;
END;
//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE ExecutarInsercaoRegistosMultiplosFuncionarios(IN vezes INT)
BEGIN
    DECLARE contador INT;
    DECLARE ID_funcionario_aleatorio INT;
    DECLARE ID_profissao_aleatorio INT;

    SET contador = 1;

    WHILE contador <= vezes DO
		SELECT ID INTO ID_funcionario_aleatorio 
			FROM TAB_pessoa 
            WHERE ID NOT IN (SELECT ID_pessoa FROM TAB_funcionario)
            ORDER BY RAND()
			LIMIT 1;
		
        SELECT ID INTO ID_profissao_aleatorio
			FROM TAB_profissao
            ORDER BY RAND()
            LIMIT 1;
    
        INSERT INTO TAB_funcionario (ID_pessoa, ID_profissao) 
        VALUES (
			ID_funcionario_aleatorio,
            ID_profissao_aleatorio
		);
        SET contador = contador + 1;
    END WHILE;
END;
//

DELIMITER ;

DELIMITER //

CREATE FUNCTION existem_pessoas_com_mais_1_conta_cliente(ID_pessoa_avaliar INT)
RETURNS BOOLEAN READS SQL DATA
BEGIN
    DECLARE n_pessoas_registadas_mais_que_1_cliente INT;

    -- Seleciona o número de registros de clientes para a pessoa especificada
    SELECT COUNT(*) INTO n_pessoas_registadas_mais_que_1_cliente
    FROM TAB_cliente
    WHERE ID_pessoa = ID_pessoa_avaliar;

    -- Verifica se a pessoa está registrada mais de uma vez como cliente
    IF n_pessoas_registadas_mais_que_1_cliente > 1 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE ApagarRegistosRepetidosClientes()
BEGIN
    DECLARE contador INT;
    DECLARE ID_cliente_aleatorio INT;

    -- Encontra o maior ID na tabela TAB_cliente
    SET contador = (SELECT MAX(ID) FROM TAB_cliente);

    -- Loop enquanto o contador for maior que 0
    WHILE contador > 0 DO
        -- Verifica se o cliente tem mais de uma conta
        SET ID_cliente_aleatorio = (SELECT ID_pessoa FROM TAB_cliente WHERE ID = contador);
        
        IF ID_cliente_aleatorio IS NOT NULL THEN
            IF existem_pessoas_com_mais_1_conta_cliente(ID_cliente_aleatorio) THEN
                -- Apaga o registro com o ID atual se for um duplicado
                DELETE FROM TAB_cliente WHERE ID = contador;
            END IF;
        END IF;

        -- Decrementa o contador
        SET contador = contador - 1;
    END WHILE;
END;
//

DELIMITER ;


DELIMITER //

CREATE FUNCTION proxima_data(data_verificar date)
RETURNS DATE READS SQL DATA
BEGIN
	DECLARE data_neste_ano DATE;
    DECLARE proxima_data_obtida DATE;
    
    SET data_neste_ano = CONCAT(DATE_FORMAT(CURDATE(),'%Y'), '-' ,DATE_FORMAT(data_verificar, '%m-%d'));
    
    IF data_neste_ano < CURDATE() THEN
		SET proxima_data_obtida = DATE_ADD(data_neste_ano, INTERVAL 1 YEAR);
	ELSE
		SET proxima_data_obtida = data_neste_ano;
	END IF;

    RETURN proxima_data_obtida;
END;
//

DELIMITER ;

DELIMITER //

CREATE FUNCTION dia_feriado_muda_cada_ano(ID_feriado_into INT)
RETURNS BOOL READS SQL DATA
BEGIN
	DECLARE n_datas_distintas INT;
	DECLARE repete BOOL;
    
    SELECT COUNT(DISTINCT DATE_FORMAT(df.data, '%m-%d')) INTO n_datas_distintas
		FROM TAB_dia_feriado df INNER JOIN TAB_feriado f ON df.ID_feriado = f.ID
		WHERE f.ID = ID_feriado_into
		GROUP BY f.ID, f.designacao;
        
	IF n_datas_distintas > 1 THEN 
		SET repete = TRUE;
    ELSE 
		SET repete = FALSE;
    END IF;

    RETURN repete;
END;
//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE ExecutarInsercaoRegistosMultiplosCidadoes(IN vezes INT)
BEGIN
    DECLARE contador INT;
	DECLARE ID_pessoa_aleatoria INT;
    
    SET contador = 1;

    WHILE contador <= vezes DO
		SELECT ID INTO ID_pessoa_aleatoria
			FROM TAB_pessoa 
            WHERE ID NOT IN (SELECT ID_pessoa FROM TAB_passaporte)
            ORDER BY RAND()
			LIMIT 1;
    
    
        INSERT INTO TAB_informacoes_cidadao (ID_pessoa, CC) 
        VALUES (
			ID_pessoa_aleatoria,
            gerar_cc()
		);
        SET contador = contador + 1;
    END WHILE;
END;
//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE ExecutarInsercaoRegistosMultiplosEstrangeiros(IN vezes INT)
BEGIN
    DECLARE contador INT;
	DECLARE ID_pessoa_aleatoria INT;
    
    SET contador = 1;

    WHILE contador <= vezes DO
		SELECT ID INTO ID_pessoa_aleatoria
			FROM TAB_pessoa 
            WHERE ID NOT IN (SELECT ID_pessoa FROM TAB_informacoes_cidadao)
            ORDER BY RAND()
			LIMIT 1;
    
    
        INSERT INTO TAB_passaporte (ID_pessoa, ID_passaporte) 
        VALUES (
			ID_pessoa_aleatoria,
            gerar_passaporte()
		);
        SET contador = contador + 1;
    END WHILE;
END;
//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE ExecutarInsercaoRegistosMultiplosContratosAtuaisFuncionarios()
BEGIN
    DECLARE contador INT;
    DECLARE id_funcionario_selecionado INT;
    DECLARE random_date DATETIME;
    
    SET contador = 1;

    WHILE contador <= (SELECT MAX(ID) FROM TAB_funcionario) DO
        SELECT ID INTO id_funcionario_selecionado FROM TAB_funcionario WHERE ID = contador;
        
        IF id_funcionario_selecionado IS NOT NULL THEN
			
            SET random_date = DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * (90 * 60 * 60) + 1) MINUTE);
        
            INSERT INTO TAB_contrato (ID_funcionario, data_hora_contratado, prazo_contrato, ID_unidade_tempo_prazo_contrato) 
            VALUES (
                id_funcionario_selecionado,
                random_date,
                1,
                7 -- Anos, ou seja 1 ano
            );
        END IF;

        SET contador = contador + 1;
    END WHILE;
END;
//

DELIMITER ;

DELIMITER //

CREATE FUNCTION obter_contrato_mais_recente(ID_funcionario_proc INT)
RETURNS INT READS SQL DATA
BEGIN
    RETURN (SELECT c.ID
		FROM TAB_contrato c
				INNER JOIN TAB_unidades_tempo ut ON c.ID_unidade_tempo_prazo_contrato = ut.ID
		WHERE c.ID_funcionario = ID_funcionario_proc AND (data_hora_cancelado IS NULL AND ID_funcionario_cancelou IS NULL) AND data_hora_contratado <= NOW()
		ORDER BY data_hora_contratado DESC
        LIMIT 1);
END;
//

DELIMITER ;

DELIMITER //

CREATE FUNCTION obter_definicao_hierarquica_mais_recente(ID_cargo_proc INT)
RETURNS INT READS SQL DATA
BEGIN
    RETURN (SELECT ID
		FROM TAB_hierarquia
		WHERE ID_cargo_atribuindo = ID_cargo_proc AND data_hora <= NOW()
		ORDER BY data_hora DESC
        LIMIT 1);
END;
//

DELIMITER ;

DELIMITER //

CREATE FUNCTION obter_promocao_mais_recente(ID_funcionario_proc INT)
RETURNS INT READS SQL DATA
BEGIN
    RETURN (SELECT ID
	FROM TAB_promocoes_cargos
    WHERE ID_funcionario_promovido = ID_funcionario_proc AND data_promovido <= CURRENT_DATE()
    ORDER BY data_promovido DESC
    LIMIT 1);
END;
//

DELIMITER ;

DELIMITER //

CREATE FUNCTION obter_data_termino_contrato(des_no_singular VARCHAR(30), data_hora_contratado_avaliando DATETIME, prazo_contrato_obt INT)
RETURNS DATE READS SQL DATA
BEGIN
    RETURN (CASE 
				WHEN des_no_singular = 'ano' THEN DATE_ADD(data_hora_contratado_avaliando, INTERVAL prazo_contrato_obt YEAR)
				WHEN des_no_singular = 'mês' THEN DATE_ADD(data_hora_contratado_avaliando, INTERVAL prazo_contrato_obt MONTH)
				WHEN des_no_singular = 'semana' THEN DATE_ADD(data_hora_contratado_avaliando, INTERVAL prazo_contrato_obt WEEK)
				WHEN des_no_singular = 'dia' THEN DATE_ADD(data_hora_contratado_avaliando, INTERVAL prazo_contrato_obt DAY)
			END);
END;
//

DELIMITER ;


DELIMITER //

CREATE PROCEDURE ExecutarInsercaoRegistosMultiplasPromocoes()
BEGIN
	DECLARE contador INT DEFAULT 1;
	DECLARE ID_funcionario_atribuindo_cargo INT;
    DECLARE ID_cargo_selecionado INT;
    
    WHILE contador <= (SELECT MAX(ID) FROM TAB_funcionario) DO
		SELECT ID INTO ID_funcionario_atribuindo_cargo FROM TAB_funcionario WHERE ID = contador AND ID_pessoa != 1;
        
        IF ID_funcionario_atribuindo_cargo IS NOT NULL THEN
			SELECT acp.ID_cargo INTO ID_cargo_selecionado
				FROM TAB_AUX_cargos_profissoes acp
						INNER JOIN TAB_funcionario f ON acp.ID_profissao = f.ID_profissao
				WHERE f.ID = ID_funcionario_atribuindo_cargo
				ORDER BY RAND()
				LIMIT 1;
			
			INSERT INTO TAB_promocoes_cargos (ID_funcionario_promovido, ID_funcionario_promovedor, ID_cargo)
			VALUE (
				ID_funcionario_atribuindo_cargo, 
				1, 
                ID_cargo_selecionado
			);
		END IF;
        
        SET contador = contador + 1;
	END WHILE;
END;
//

DELIMITER ;



DELIMITER //

CREATE FUNCTION obter_experiencia_mais_recente(ID_funcionario_proc INT)
RETURNS INT READS SQL DATA
BEGIN
    RETURN (SELECT ID
	FROM TAB_experiencia
    WHERE ID_funcionario = ID_funcionario_proc AND data_hora <= NOW()
    ORDER BY data_hora DESC
    LIMIT 1);
END;
//

DELIMITER ;


DELIMITER //

CREATE PROCEDURE ExecutarInsercaoRegistosMultiplasAbastecimentosStock(max_iterations INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE random_ID_artigo INT;
	DECLARE random_quantidade INT;
	DECLARE random_ID_instalacoes_destino INT;
	DECLARE random_ID_metodo_pagamento INT;
	DECLARE random_valor_total DECIMAL(10, 2);
	DECLARE random_data_hora_envio DATETIME;
	DECLARE random_data_hora_chegada DATETIME;
    IF max_iterations IS NULL THEN SET max_iterations = 10; END IF;
    
    WHILE i < max_iterations DO
        SET random_ID_artigo = FLOOR(1 + (RAND() * (SELECT MAX(ID) FROM TAB_artigos)));
        SET random_quantidade = FLOOR(1 + (RAND() * 10));
        SET random_ID_instalacoes_destino = FLOOR(1 + (RAND() * (SELECT MAX(ID) FROM TAB_instalacoes)));
        SET random_ID_metodo_pagamento = FLOOR(1 + (RAND() * (SELECT MAX(ID) FROM TAB_metodo_pagamento)));
        SET random_valor_total = ROUND(RAND() * 1000, 2);
        SET random_data_hora_envio = NOW();
        SET random_data_hora_chegada = DATE_ADD(NOW(), INTERVAL FLOOR(1 + (RAND() * 10)) DAY);

        -- Inserir o registro na tabela TAB_stock_artigo
        INSERT INTO TAB_stock_artigo (ID_artigo, quantidade, data_hora_envio, data_hora_chegada, ID_instalacoes_destino, ID_metodo_pagamento, valor_total)
        VALUES (random_ID_artigo, random_quantidade, random_data_hora_envio, random_data_hora_chegada, random_ID_instalacoes_destino, random_ID_metodo_pagamento, random_valor_total);

        -- Incrementar o contador
        SET i = i + 1;
    END WHILE;
END 
//

DELIMITER ;

DELIMITER //

CREATE FUNCTION obter_artigos_em_stock(ID_artigo_proc INT, ID_instalacoes_proc INT)
RETURNS INT READS SQL DATA
BEGIN
    DECLARE n_artigos_compra INT;
    DECLARE n_artigos_ano_passado INT DEFAULT 0; -- Depos adicionar
    DECLARE n_artigos_comprados INT DEFAULT 0;
    DECLARE n_artigos_vendidos INT DEFAULT 0;
    DECLARE n_artigos_transferidos_s INT DEFAULT 0;
    DECLARE n_artigos_transferidos_e INT DEFAULT 0;
    DECLARE n_artigos_devolvidos INT DEFAULT 0;
    DECLARE n_artigos_dados INT DEFAULT 0;
    
    IF ID_instalacoes_proc IS NULL THEN
		SELECT SUM(quantidade) INTO n_artigos_comprados
			FROM TAB_artigos a 
					INNER JOIN TAB_stock_artigo sa ON a.ID = sa.ID_artigo
			WHERE sa.data_hora_chegada <= NOW() AND a.ID = ID_artigo_proc;
            
		SELECT COUNT(*) INTO n_artigos_vendidos
			FROM TAB_artigos a
					INNER JOIN TAB_venda v ON a.ID = v.ID_artigo
			WHERE v.data_hora_pedido <= NOW() AND a.ID = ID_artigo_proc;
            
		SELECT COUNT(*) INTO n_artigos_devolvidos
			FROM TAB_venda v
                    INNER JOIN TAB_troca tr ON v.ID = tr.ID_venda
			WHERE v.ID_artigo = ID_artigo_proc AND tr.data_hora <= NOW();
            
		SELECT COUNT(*) INTO n_artigos_dados
			FROM TAB_troca tr
			WHERE tr.ID_artigo_dado = ID_artigo_proc AND tr.data_hora <= NOW(); 
        
	ELSE
		SELECT SUM(quantidade) INTO n_artigos_comprados
			FROM TAB_artigos a 
			INNER JOIN TAB_stock_artigo sa ON a.ID = sa.ID_artigo
			WHERE sa.data_hora_chegada <= NOW() AND a.ID = ID_artigo_proc AND sa.ID_instalacoes_destino = ID_instalacoes_proc;
		
        SELECT COUNT(*) INTO n_artigos_vendidos
			FROM TAB_artigos a
					INNER JOIN TAB_venda v ON a.ID = v.ID_artigo
			WHERE v.data_hora_pedido <= NOW() AND a.ID = ID_artigo_proc AND v.ID_instalacoes_compra_recolha = ID_instalacoes_proc;
		
        SELECT SUM(apt.quantidade) INTO n_artigos_transferidos_s
			FROM TAB_artigos a
					INNER JOIN TAB_artigo_para_transferencia apt ON a.ID = apt.ID_artigo
			WHERE a.ID = ID_artigo_proc AND apt.ID_instalacoes_origem = ID_instalacoes_proc AND apt.data_hora_adicionado <= NOW();
		
       SELECT SUM(apt.quantidade) INTO n_artigos_transferidos_e
			FROM TAB_artigos a
					INNER JOIN TAB_artigo_para_transferencia apt ON a.ID = apt.ID_artigo
                    INNER JOIN TAB_transferencias t ON apt.ID_transferencia = t.ID
			WHERE a.ID = ID_artigo_proc AND t.ID_instalacoes_destino = ID_instalacoes_proc AND t.data_hora_termino_transferencia <= NOW();
            
		SELECT COUNT(*) INTO n_artigos_devolvidos
			FROM TAB_venda v
                    INNER JOIN TAB_troca tr ON v.ID = tr.ID_venda
			WHERE v.ID_artigo = ID_artigo_proc AND tr.data_hora <= NOW() AND tr.ID_instalacoes = ID_instalacoes_proc;
            
		SELECT COUNT(*) INTO n_artigos_dados
			FROM TAB_troca tr
			WHERE tr.ID_artigo_dado = ID_artigo_proc AND tr.data_hora <= NOW() AND tr.ID_instalacoes = ID_instalacoes_proc; 
        
	END IF;
    
    IF n_artigos_comprados IS NULL THEN SET n_artigos_comprados = 0; END IF;
    IF n_artigos_transferidos_e IS NULL THEN SET n_artigos_transferidos_e = 0; END IF;
    IF n_artigos_transferidos_s IS NULL THEN SET n_artigos_transferidos_s = 0; END IF;
    IF n_artigos_dados IS NULL THEN SET n_artigos_dados = 0; END IF;
    IF n_artigos_devolvidos IS NULL THEN SET n_artigos_devolvidos = 0; END IF;
    
	SET n_artigos_compra = n_artigos_comprados + n_artigos_transferidos_e + n_artigos_devolvidos - n_artigos_vendidos - n_artigos_transferidos_s - n_artigos_dados;
    
    RETURN n_artigos_compra;
END;
//

DELIMITER ;


DELIMITER //

CREATE FUNCTION obter_valor_artigos_compra_media(ID_artigo_proc INT)
RETURNS DECIMAL(10,2) READS SQL DATA
BEGIN
	DECLARE valor_artigo_compra DECIMAL(10,2);
    DECLARE quantidade_em_stock INT;
    DECLARE total_quantidade INT;
    DECLARE total_valor DECIMAL(10,2);
    
    SET quantidade_em_stock = obter_artigos_em_stock(ID_artigo_proc, NULL);
	
	SELECT 
		SUM(sa.quantidade) AS total_quantidade, 
		SUM(sa.valor_total) AS total_valor
	INTO 
		total_quantidade,
        total_valor
	FROM 
		TAB_stock_artigo sa
	INNER JOIN 
		TAB_metodo_pagamento mp ON sa.ID_metodo_pagamento = mp.ID
	WHERE 
		sa.ID_artigo = ID_artigo_proc AND 
		sa.data_hora_chegada <= NOW() AND
		(SELECT SUM(quantidade) 
		 FROM TAB_stock_artigo AS sa2 
		 WHERE sa2.data_hora_chegada <= sa.data_hora_chegada AND sa2.ID_artigo = ID_artigo_proc) <= quantidade_em_stock
	ORDER BY 
		sa.data_hora_chegada DESC;
        
	IF total_valor IS NULL THEN SET total_valor = 0; END IF;
	
    SET valor_artigo_compra = total_valor / total_quantidade;

    RETURN valor_artigo_compra;
END;
//

DELIMITER ;

DELIMITER //

CREATE FUNCTION obter_percentagem_lucro_artigo_atual(ID_artigo_proc INT)
RETURNS DECIMAL(5,2) READS SQL DATA
BEGIN
    RETURN (SELECT percentagem_lucro
		FROM TAB_percentagem_lucro_artigo
        WHERE ID_artigo = ID_artigo_proc AND data_hora_aplicado <= NOW()
        ORDER BY data_hora_aplicado
        LIMIT 1);
END;
//

DELIMITER ;

DELIMITER //

CREATE FUNCTION obter_data_horario_mais_recente(ID_instalacoes_proc INT, ID_feriado_proc INT)
RETURNS DATE READS SQL DATA
BEGIN
	DECLARE data_mais_recente DATE;

	IF ID_feriado_proc IS NULL THEN
		SELECT data_entrada_vigor INTO data_mais_recente
			FROM TAB_horario
			WHERE ID_instalacoes = ID_instalacoes_proc
			ORDER BY data_entrada_vigor
			LIMIT 1;
	ELSE
		SELECT data_entrada_vigor INTO data_mais_recente
			FROM TAB_horario
			WHERE ID_instalacoes = ID_instalacoes_proc AND ID_feriado = ID_feriado_proc
			ORDER BY data_entrada_vigor
			LIMIT 1;
    END IF;
	
    RETURN data_mais_recente;
END;
//

DELIMITER ;

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


CREATE VIEW VIEW_detalhes_artigos AS
SELECT a.ID, a.descricao AS descricao_artigo, 
		tia.designacao AS des_tipo_artigo, 
        t.designacao AS tamanho, 
        t.tamanho_min_cm, t.tamanho_max_cm, 
        f.nome_empresa AS nome_fornecedor, 
        f.NIF_empresa AS NIF_fornecedor, 
        obter_artigos_em_stock(a.ID, NULL) AS artigos_em_stock, 
        ROUND(obter_valor_artigos_compra_media(a.ID) + obter_valor_artigos_compra_media(a.ID) * obter_percentagem_lucro_artigo_atual(a.ID) / 100, 2) AS preco
	FROM TAB_artigos a 
            INNER JOIN TAB_fornecedores f ON a.ID_fornecedor = f.ID
            INNER JOIN TAB_tipos_artigos tia ON a.ID_tipo_artigo = tia.ID
            INNER JOIN TAB_tamanho_artigo taa ON a.ID = taa.ID_artigo
			INNER JOIN TAB_tamanho t ON taa.ID_tamanho = t.ID
			
	ORDER BY a.ID
;


CREATE VIEW VIEW_horario_atual AS 
SELECT ho.ID_instalacoes, 
		IF(f.ID IS NULL, '---', f.ID) AS ID_feriado, 
        IF(f.ID IS NULL, '---', f.designacao) AS feriado_aplicada, 
        ds.ID AS ID_dia_semana, 
        ds.designacao AS dia_semana, 
        h.hora_aberto, 
        h.hora_fechado, 
        ds.n_horas_trabalho_esperado AS horas_trabalho_esperado,
        ho.data_entrada_vigor
	FROM TAB_horario ho
			INNER JOIN TAB_horas_semana hs ON ho.ID = hs.ID_horario
            INNER JOIN TAB_horas h ON hs.ID_horas = h.ID
            INNER JOIN TAB_dia_semana ds ON hs.ID_dia_semana = ds.ID
            LEFT JOIN TAB_feriado f ON ho.ID_feriado = f.ID
	WHERE obter_data_horario_mais_recente(ho.ID, ho.ID_feriado) = ho.data_entrada_vigor

;

CREATE VIEW VIEW_informacao_instalacoes AS
SELECT i.ID, 
		i.designacao, 
        ti.designacao AS des_tipo_instalacoes, 
        i.morada, 
        i.localizacao_gps, 
        data_hora_primeira_abertura, 
        data_hora_ultimo_encerramento, 
        CASE 
			WHEN data_hora_primeira_abertura IS NULL THEN "Sem planos para abrir"
			WHEN data_hora_primeira_abertura > NOW() THEN "Por abrir"
            WHEN data_hora_primeira_abertura <= NOW() AND data_hora_ultimo_encerramento IS NULL THEN "Em funcionamento"
            WHEN data_hora_primeira_abertura <= NOW() AND data_hora_ultimo_encerramento > NOW() THEN "Irá ser fechado"
            WHEN data_hora_primeira_abertura <= NOW() AND data_hora_ultimo_encerramento <= NOW() THEN "Encerrado"
		END AS estado
	FROM TAB_instalacoes i
			INNER JOIN TAB_tipo_instalacoes ti ON i.ID_tipo_instalacoes = ti.ID
		
;

call ExecutarInsercaoRegistosMultiplosPessoas(1000);
call ExecutarInsercaoRegistosMultiplosClientes(500);
call ExecutarInsercaoRegistosMultiplosFuncionarios(50);
call ExecutarInsercaoRegistosMultiplosCidadoes(10);
call ExecutarInsercaoRegistosMultiplosEstrangeiros(10);
call ExecutarInsercaoRegistosMultiplosContratosAtuaisFuncionarios();
call ExecutarInsercaoRegistosMultiplasPromocoes();
call ExecutarInsercaoRegistosMultiplasAbastecimentosStock(NULL);