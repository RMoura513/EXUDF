/*
1) Funcionário (Código, Nome, Salário)
2) Dependendente (Código_Funcionário, Nome_Dependente, Salário_Dependente)
*/

CREATE DATABASE exUDF
GO
USE exUDF
GO
CREATE TABLE funcionario(
codigo			INT				NOT NULL,
nome			VARCHAR(100)	NOT NULL,
salario			DECIMAL(7,2)	NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE dependente(
codigo_dependente		INT				NOT NULL,
codigo_funcionario		INT				NOT NULL,
nome_dependente			VARCHAR(100)	NOT NULL,
salario_dependente		DECIMAL(7,2)	NOT NULL
PRIMARY KEY (codigo_dependente)
FOREIGN KEY (codigo_funcionario) REFERENCES funcionario(codigo)
)



DECLARE @codigo		INT,
		@nome		VARCHAR(100),
		@salario	DECIMAL(7,2)
SET @codigo = 1
WHILE (@codigo <= 10)
BEGIN
	SET @nome = 'Funcionário ' + CAST(@codigo AS VARCHAR(2))
	SET @salario = 0.0
	SET @salario = RAND() * 1000 + 2000

	INSERT INTO funcionario VALUES (@codigo, @nome, @salario)
	SET @codigo = @codigo + 1
END

DECLARE @codigo_dependente		INT,
		@codigo_funcionario		INT,
		@nome_dependente		VARCHAR(100),
		@salario_dependente		DECIMAL(7,2)
SET @codigo_dependente = 1
SET @codigo_funcionario = 1
WHILE (@codigo_dependente <= 10)
BEGIN
	SET @nome_dependente = 'Dependente ' + CAST(@codigo_dependente AS VARCHAR(2))
	SET @salario_dependente = 0.0
	SET @salario_dependente = RAND() * 1000 + 1000

	INSERT INTO dependente VALUES (@codigo_dependente, @codigo_funcionario, @nome_dependente, @salario_dependente)
	SET @codigo_dependente = @codigo_dependente + 1
	SET @codigo_funcionario = @codigo_funcionario + 1
END


SELECT * FROM funcionario
SELECT * FROM dependente

/*
a) Multi Statement Table Function que Retorne uma tabela: (Nome_Funcionário, Nome_Dependente, Salário_Funcionário, Salário_Dependente)
 */

 CREATE FUNCTION fn_funcionario_dependente()
 RETURNS @tabela TABLE(
 nome_funcionario		VARCHAR(100),
 nome_dependente		VARCHAR(100),
 salario_funcionario	DECIMAL(7,2),
 salario_dependente		DECIMAL(7,2)
 )
 AS
 BEGIN
	INSERT INTO @tabela(nome_funcionario, nome_dependente, salario_funcionario, salario_dependente)
	SELECT f.nome, d.nome_dependente, f.salario, d.salario_dependente FROM funcionario f, dependente d WHERE f.codigo = d.codigo_funcionario

	RETURN
 END

--DROP FUNCTION fn_funcionario_dependente
 SELECT * FROM fn_funcionario_dependente()


 /*
b) Scalar Function que Retorne a soma dos Salários dos dependentes, mais a do funcionário.
*/

CREATE FUNCTION fn_soma_salario(@codigo INT)
RETURNS DECIMAL(7,2)
AS
BEGIN
	DECLARE @salario_funcionario	DECIMAL(7,2),
			@salario_dependente		DECIMAL(7,2),
			@soma					DECIMAL(7,2)

			SELECT @salario_funcionario = f.salario, @salario_dependente = d.salario_dependente FROM funcionario f, dependente d 
			WHERE f.codigo = @codigo
					AND f.codigo = d.codigo_funcionario
			
			SET @soma = @salario_funcionario + @salario_dependente

RETURN @soma
END

--DROP FUNCTION fn_soma_salario

SELECT dbo.fn_soma_salario(3) AS soma_salario






