/*
- Uma empresa vende produtos aliment�cios
- A empresa d� pontos, para seus clientes, que podem ser revertidos em pr�mios
*/
CREATE DATABASE ex_triggers_07
GO
USE ex_triggers_07
GO
CREATE TABLE cliente (
codigo		INT			NOT NULL,
nome		VARCHAR(70)	NOT NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE venda (
codigo_venda	INT				NOT NULL,
codigo_cliente	INT				NOT NULL,
valor_total		DECIMAL(7,2)	NOT NULL
PRIMARY KEY (codigo_venda)
FOREIGN KEY (codigo_cliente) REFERENCES cliente(codigo)
)
GO
CREATE TABLE pontos (
codigo_cliente	INT					NOT NULL,
total_pontos	DECIMAL(4,1)		NOT NULL
PRIMARY KEY (codigo_cliente)
FOREIGN KEY (codigo_cliente) REFERENCES cliente(codigo)
)

-- Para n�o prejudicar a tabela venda, nenhum produto pode ser deletado, mesmo que n�o venha mais a ser vendido
CREATE TRIGGER t_delvenda ON venda
AFTER DELETE
AS
BEGIN
	ROLLBACK TRANSACTION
	RAISERROR('N�o � poss�vel excluir venda', 16, 1)
END

-- Para n�o prejudicar os relat�rios e a contabilidade, a tabela venda n�o pode ser alterada. 
CREATE TRIGGER t_updvenda ON venda
AFTER UPDATE
AS
BEGIN
	ROLLBACK TRANSACTION
	RAISERROR('N�o � poss�vel alterar venda', 16, 1)
END

-- Ao inv�s de alterar a tabela venda deve-se exibir uma tabela com o nome do �ltimo cliente que comprou e o valor da 
--�ltima compra
CREATE TRIGGER t_altvenda ON venda
INSTEAD OF UPDATE, DELETE
AS
BEGIN
	SELECT 
END

-- Ap�s a inser��o de cada linha na tabela venda, 10% do total dever� ser transformado em pontos.
CREATE TRIGGER t_gera_ponto ON venda
AFTER INSERT
AS
BEGIN
	DECLARE @valor_ponto DECIMAL(7,2)

	SET @valor_ponto = (SELECT valor_total FROM venda) * 0.10
	INSERT INTO pontos VALUES ((SELECT codigo_cliente FROM venda), @valor_ponto)
END

-- Se o cliente ainda n�o estiver na tabela de pontos, deve ser inserido automaticamente ap�s sua primeira compra
CREATE TRIGGER t_cli_ins_ponto ON 

-- Se o cliente atingir 1 ponto, deve receber uma mensagem (PRINT SQL Server) dizendo que ganhou
CREATE TRIGGER t_ganhou_ponto ON pontos
AFTER INSERT, UPDATE
AS
BEGIN
	IF ((SELECT total_pontos FROM pontos) = 1)
	BEGIN
		PRINT SQL ('Voc� ganhou um ponto')
	END
END