use [Loja];
GO

-- Tabela Usuario
CREATE TABLE [Usuario] (
  idUsuario INT IDENTITY(1,1) PRIMARY KEY,
  Login VARCHAR(20) NULL,
  Senha VARCHAR(20) NULL
);
GO

-- Inserindo dados na tabela Usuario
INSERT INTO [Usuario] (Login, Senha)
VALUES ('op1', 'op1'), ('op2', 'op2');

SELECT * FROM [Usuario];
GO



/*======================================================================================================================*/

-- Tabela Produto
CREATE TABLE [Produto] (
  idProduto INT IDENTITY(1,1) NOT NULL,
  nome VARCHAR(255) NULL,
  quantidade INT NULL,
  precoVenda FLOAT,
  PRIMARY KEY (idProduto)
);

-- Inserindo dados na tabela Produto
INSERT INTO [Produto] (nome, quantidade, precoVenda)
VALUES ('Banana', 100, 5.01),
       ('Laranja', 500, 2.02),
       ('Manga', 800, 4.03);

SELECT * FROM [Produto];
GO

/*======================================================================================================================*/

-- Tabela Pessoa
CREATE TABLE [Pessoa] (
  idPessoa INT IDENTITY(1,1) NOT NULL,
  nome VARCHAR(255) NULL,
  logradouro VARCHAR(255) NULL,
  cidade VARCHAR(255) NULL,
  estado CHAR(2) NULL,
  telefone VARCHAR(11) NULL,
  email VARCHAR(255) NULL,
  PRIMARY KEY (idPessoa)
);

-- Inserindo dados na tabela Pessoa
INSERT INTO [Pessoa] (nome, logradouro, cidade, estado, telefone, email)
VALUES ('Wallace Felipe Tavares', 'Rua Chile', 'Rio de Janeiro', 'RJ', '11991876543', 'wfelipe@gmail.com'),
       ('Felipe Wallace Tavares', 'Rua Chile', 'Rio de Janeiro', 'RJ', '12345678909', 'wfeli@gmail.com'),
       ('Bingo Trêsbolas', 'Rua Ana Augusta', 'Rio de Janeiro', 'RJ', '11991098789', 'wfee@gmail.com'),
       ('Padaria Norte', 'Rua México', 'Rio de Janeiro', 'RJ', '11909878654', 'lipe@gmail.com');


--DROP TABLE [Pessoa];
SELECT * FROM [Pessoa];
GO


/*======================================================================================================================*/

-- Tabela PessoaJuridica
CREATE TABLE [PessoaJuridica] (
  idPessoaJuridica INT IDENTITY(1,1) NOT NULL,
  idPessoa INT NOT NULL,
  tipoDocumento VARCHAR(20) NULL,
  dataExpedicao DATE NULL,
  dataValidade DATE NULL,
  CNPJ VARCHAR(14) NULL,
  PRIMARY KEY (idPessoaJuridica),
  CONSTRAINT FK_PessoaJuridica_Pessoa 
  FOREIGN KEY (idPessoa)
  REFERENCES [Pessoa] (idPessoa)
);

INSERT INTO [PessoaJuridica] (idPessoa, tipoDocumento, dataExpedicao, dataValidade)
VALUES (1, 'CNPJ', '2013/05/23', ''),
       (2, 'CNPJ', '2013/05/23', '');

-- Atualização dos dados na PessoaJuridica com os CNPJ
UPDATE [PessoaJuridica]
SET CNPJ = '18263258000146'
WHERE idPessoaJuridica = 1;

UPDATE [PessoaJuridica]
SET CNPJ = '18263258000146'
WHERE idPessoaJuridica = 2;

--DROP TABLE [PessoaJuridica];
SELECT * FROM [PessoaJuridica];
GO

/*======================================================================================================================*/

-- Tabela PessoaFisica
CREATE TABLE [PessoaFisica] (
  idPessoaFisica INT IDENTITY(1,1) NOT NULL,
  idPessoa INT NOT NULL,
  tipoDocumento VARCHAR(20) NULL,
  dataExpedicao DATE NULL,
  dataValidade DATE NULL,
  CPF VARCHAR(14) NULL,
  PRIMARY KEY(idPessoaFisica),
  CONSTRAINT FK_PessoaFisica_Pessoa 
  FOREIGN KEY (idPessoa)
  REFERENCES [Pessoa] (idPessoa)
);

INSERT INTO [PessoaFisica] (idPessoa, tipoDocumento, dataExpedicao, dataValidade)
VALUES (1, 'CPF', '2003/05/23', ''),
       (2, 'CPF', '2013/05/23', '');

-- Atualização dos dados na tabela PessoaFisica com os CPF
UPDATE [PessoaFisica]
SET CPF = '022094775-40'
WHERE idPessoaFisica = 1;

UPDATE [PessoaFisica]
SET CPF = '022055785-50'
WHERE idPessoaFisica = 2;

--DROP TABLE [PessoaFisica];
SELECT * FROM [PessoaFisica];
GO

/*======================================================================================================================*/

-- Tabela Movimentacao
CREATE TABLE [Movimentacao] (
  id_movimento INT IDENTITY(1,1) NOT NULL,
  idUsuario INT NULL,
  idPessoa INT NULL,
  idProduto INT NULL,
  quantidade INT NOT NULL,
  tipo CHAR(1) NULL,
  valor_unitario FLOAT NULL,
  CONSTRAINT PK_Movimentacao PRIMARY KEY (id_movimento),
  CONSTRAINT FK_Usuario FOREIGN KEY (idUsuario)
    REFERENCES [Usuario] (idUsuario),
  CONSTRAINT FK_Pessoa FOREIGN KEY (idPessoa)
    REFERENCES [Pessoa] (idPessoa),
  CONSTRAINT FK_Produto FOREIGN KEY (idProduto)
    REFERENCES [Produto] (idProduto)
);

-- Inserindo dados na tabela Movimentacao
INSERT INTO Movimentacao (idUsuario, idPessoa, idProduto, quantidade, tipo, valor_unitario)
VALUES (1, 1, 1, 150, 'E', 8.90),
       (2, 2, 2, 150, 'S', 8.90);

--DROP TABLE [Movimentacao];
SELECT * FROM [Movimentacao];




/*************************  Efetuar as seguintes consultas sobre os dados inseridos  **********************************/

------------------------------------------------------------------------------------------------------------------------


-- a) Dados completos de pessoas físicas.
SELECT * FROM PessoaFisica;

------------------------------------------------------------------------------------------------------------------------


-- b) Dados completos de pessoas jurídicas.
SELECT * FROM PessoaJuridica;

------------------------------------------------------------------------------------------------------------------------

-- c) Movimentações de entrada, com produto, fornecedor, quantidade, preço unitário e valor total.
SELECT p.nome, m.idProduto, m.idPessoa, m.quantidade, m.valor_unitario, (m.quantidade * m.valor_unitario) AS valor_total
FROM Movimentacao AS m
JOIN Pessoa AS p ON m.idPessoa = p.idPessoa
WHERE m.tipo = 'E';

------------------------------------------------------------------------------------------------------------------------

-- d) Movimentações de saída, com produto, cliente, quantidade, preço unitário e valor total.
SELECT p.nome, m.idProduto, m.idPessoa, m.quantidade, m.valor_unitario, (m.quantidade * m.valor_unitario) AS valor_total
FROM Movimentacao AS m
JOIN Pessoa AS p ON m.idPessoa = p.idPessoa
WHERE m.tipo = 'S';

------------------------------------------------------------------------------------------------------------------------

-- e) Valor total das entradas agrupadas por produto.
SELECT idProduto, SUM(quantidade * valor_unitario) AS ValorTotalEntrada
FROM Movimentacao
WHERE tipo = 'E'
GROUP BY idProduto;

------------------------------------------------------------------------------------------------------------------------

-- f) Valor total das saídas agrupadas por produto.
SELECT idProduto, SUM(quantidade * valor_unitario) AS ValorTotalSaida
FROM Movimentacao
WHERE tipo = 'S'
GROUP BY idProduto;

------------------------------------------------------------------------------------------------------------------------

-- g) Operadores que não efetuaram movimentações de entrada (compra).
SELECT *
FROM Usuario
WHERE idUsuario NOT IN (SELECT DISTINCT idUsuario FROM Movimentacao WHERE tipo = 'E');

------------------------------------------------------------------------------------------------------------------------

-- h) Valor total de entrada, agrupado por operador.
SELECT m.idUsuario, u.login, SUM(m.quantidade * m.valor_unitario) AS ValorTotalEntrada
FROM Movimentacao m
JOIN Usuario u ON m.idUsuario = u.idUsuario
WHERE m.tipo = 'E'
GROUP BY m.idUsuario, u.login;

------------------------------------------------------------------------------------------------------------------------


-- i) Valor total de saída, agrupado por operador.
SELECT p.nome AS operador, SUM(m.quantidade * m.valor_unitario) AS valor_total_saida
FROM Movimentacao AS m
JOIN Pessoa AS p ON m.idPessoa = p.idPessoa
WHERE m.tipo = 'S'
GROUP BY p.nome;

------------------------------------------------------------------------------------------------------------------------

---J) Valor médio de venda por produto, utilizando média ponderada.
SELECT idProduto, SUM(quantidade * valor_unitario) / SUM(quantidade) AS ValorMedioVenda
FROM Movimentacao
WHERE tipo = 'S'
GROUP BY idProduto;

------------------------------------------------------------------------------------------------------------------------








 
 

