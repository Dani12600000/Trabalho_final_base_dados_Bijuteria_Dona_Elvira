USE DB_Bijuteria_Dona_Elvira;

DROP TABLE IF EXISTS TAB_AUX_pessoa;

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