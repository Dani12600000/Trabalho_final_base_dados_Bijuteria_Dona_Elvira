USE DB_Bijuteria_Dona_Elvira;

CREATE TABLE TAB_AUX_pessoa (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    primeiro_nome NVARCHAR(50) NOT NULL,
    segundo_nome NVARCHAR(50),
    terceiro_nome NVARCHAR(50),
    quarto_nome NVARCHAR(50) NOT NULL
);