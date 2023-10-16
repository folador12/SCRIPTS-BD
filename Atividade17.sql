CREATE TABLE Produtos (
    ProdutoID INT PRIMARY KEY,
    Nome VARCHAR(60),
    CategoriaID INT,
    Preco DECIMAL(10,2),
    Estoque INT
);

CREATE TABLE Categorias (
    CategoriaID INT PRIMARY KEY,
    Nome VARCHAR(60),
    Descricao VARCHAR(200);
);

CREATE TABLE ItensPedidos (
    ItensPedidosID INT PRIMARY KEY,
    PedidoID INT,
    ProdutoID INT,
    Preco DECIMAL(10,2),
    Quantidade INT
);

CREATE TABLE Pedidos (
    PedidoID INT PRIMARY KEY,
    ClienteID INT,
    Data DATE,
    Frete VARCHAR(60),
);

CREATE TABLE Cliente (
    ClienteID INT PRIMARY KEY,
    Nome VARCHAR(60),
    Endereco VARCHAR(200),
    Cidade VARCHAR(60),
    CEP VARCHAR(60),
    Pais VARCHAR(60),
    Email VARCHAR(60)
);

ALTER TABLE Produtos 
ADD FOREIGN KEY (CategoriaID) 
REFERENCES Categorias;

ALTER TABLE ItensPedidos
ADD FOREIGN KEY (PedidoID)
REFERENCES Pedidos;

ALTER TABLE ItensPedidos
ADD FOREIGN KEY (ProdutoID)
REFERENCES Produtos;

ALTER TABLE Pedidos
ADD FOREIGN KEY (ClienteID)
REFERENCES Cliente;


--1
CREATE OR REPLACE FUNCTION excluir_cliente(p_clienteid INT) 
RETURNS INT AS 
$Body$
BEGIN
    DELETE FROM ItensPedidos 
    WHERE PedidoID IN (SELECT PedidoID FROM Pedidos WHERE ClienteID = p_clienteid);
    DELETE FROM Pedidos WHERE ClienteID = p_clienteid;
    DELETE FROM Cliente WHERE ClienteID = p_clienteid;
    RETURN p_clienteid;
END;
$Body$
LANGUAGE plpgsql;

ALTER TABLE Produtos
ADD DataValidade DATE;

--2
CREATE OR REPLACE FUNCTION inserir_produto_perecivel(p_nome VARCHAR(60), p_datavalidade DATE) 
RETURNS TABLE(ProdutoID INT, Nome VARCHAR(60), CategoriaID INT, Preco DECIMAL(10,2), Estoque INT, DataValidade DATE) AS 
$Body$
BEGIN
    INSERT INTO Produtos (ProdutoID,Nome, CategoriaID, Preco, Estoque, DataValidade) 
    VALUES (4,p_nome, NULL, NULL, 0, p_datavalidade)
    RETURNING ProdutoID, Nome, CategoriaID, Preco, Estoque, DataValidade
    INTO ProdutoID, Nome, CategoriaID, Preco, Estoque, DataValidade;

    RETURN NEXT;
END;
$Body$ 
LANGUAGE plpgsql;

--3
CREATE OR REPLACE FUNCTION excluir_produtos_nao_vendidos() 
RETURNS VOID AS 
$Body$
BEGIN
    DELETE FROM Produtos
    WHERE ProdutoID NOT IN (SELECT DISTINCT ProdutoID FROM ItensPedidos);
END;
$Body$ 
LANGUAGE plpgsql;

--4
Select excluir_cliente(2);
SELECT * FROM inserir_produto_perecivel('Queijo Fresco', '2024-01-01');
SELECT excluir_produtos_nao_vendidos();
