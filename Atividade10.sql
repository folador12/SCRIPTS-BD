CREATE TABLE Vendedor (
    CDVendedor INTEGER PRIMARY KEY,
    email VARCHAR(10),
    NMVendedor VARCHAR(10),
    NMEstado VARCHAR(10),
    NRCPF VARCHAR(10),
    NMBairro VARCHAR(10),
    NMCidade VARCHAR(10)
);

CREATE TABLE Telefone (
    Telefone_PK INTEGER PRIMARY KEY,
    Telefone VARCHAR(10),
    CDVendedor INTEGER
);

CREATE TABLE Comprador (
    CDComprador INTEGER PRIMARY KEY,
    CPF VARCHAR(10),
    NMComprador VARCHAR(10),
    Endereço VARCHAR(10),
    Cidade VARCHAR(10),
    Bairro VARCHAR(10),
    Estado CHAR(2),
    email VARCHAR(10)
);

CREATE TABLE Imóveis (
    CDImovel INTEGER PRIMARY KEY,
    Rua VARCHAR(60),
    Numero INTEGER,
    Nrareautil DECIMAL(10,2),
    AreaTotal DECIMAL(10,2),
    DescriçãodoImovel text,
    VlPreco VARCHAR(10),
    StatusVendido CHAR(1),
    DtLançamento DATE,
    imovel_Indicado VARCHAR(10),
    CDVendedor INTEGER,
    CDBairro INTEGER,
    SGEstado CHAR(2),
    CdCidade INTEGER
);

CREATE TABLE Oferta (
    CdImovel INTEGER,
    CDComprador INTEGER,
    VLOferta NUMERIC(10,2),
    DataOferta DATE
);

CREATE TABLE Telefone_Cliente (
    Telefone_PK INTEGER PRIMARY KEY,
    Telefone VARCHAR(10),
    CDComprador_FK INTEGER
);

CREATE TABLE Estado (
    SGEstado CHAR(2) PRIMARY KEY,
    NMEstado VARCHAR(10)
);

CREATE TABLE Cidade (
    CDCidade INTEGER,
    SGEstado CHAR(2),
    NMCidade VARCHAR(10),
    SGEstado CHAR(2),

    PRIMARY KEY (CDCidade,SGEstado)
);

CREATE TABLE Bairro (
    CDBairro INTEGER,
    SGEstado CHAR(2),
    CdCidade INTEGER,
    NomeBairro VARCHAR(10),

    PRIMARY KEY(CDBairro, SGEstado, CdCidade)
);


ALTER TABLE Telefone ADD
FOREIGN KEY (CDVendedor) REFERENCES Vendedor;

ALTER TABLE Imóveis ADD
FOREIGN KEY (CDVendedor) REFERENCES Vendedor;

ALTER TABLE Imóveis ADD
FOREIGN KEY (CDBairro,SGEstado,CdCidade) REFERENCES Bairro (CDBairro,SGEstado,CdCidade);

ALTER TABLE Oferta ADD
FOREIGN KEY (CDImovel) REFERENCES Imóveis;

ALTER TABLE Oferta ADD
FOREIGN KEY (CDComprador) REFERENCES Comprador;

ALTER TABLE Telefone_Cliente ADD
FOREIGN KEY (CDComprador_FK) REFERENCES Comprador;

ALTER TABLE Cidade ADD
FOREIGN KEY (SGEstado) REFERENCES Estado;

ALTER TABLE Bairro ADD
FOREIGN KEY (SGEstado,CdCidade) REFERENCES Cidade(SGEstado,CDCidade);


INSERT INTO Estado VALUES ('SP', 'São Paulo');
INSERT INTO Estado VALUES ('RJ', 'RdeJaneiro');

INSERT INTO Cidade VALUES (1,'SP','São Paulo');
INSERT INTO Cidade VALUES (2,'SP','SantoAndré');
INSERT INTO Cidade VALUES (3,'SP','Campinas');
INSERT INTO Cidade VALUES (4,'RJ','RJaneiro');
INSERT INTO Cidade VALUES (5,'RJ','Niterói');

INSERT INTO Bairro VALUES (1,'SP',1,'Jardins');
INSERT INTO Bairro VALUES (2,'SP',1,'Morumbi');
INSERT INTO Bairro VALUES (3,'SP',1,'Aeroporto');
INSERT INTO Bairro VALUES (4,'RJ',4,'Aeroporto');
INSERT INTO Bairro VALUES (5,'RJ',4,'Flamengo');

ALTER TABLE Vendedor 
ADD COLUMN NMEndereco VARCHAR(60);

ALTER TABLE Vendedor
ALTER COLUMN email TYPE VARCHAR(60);

ALTER TABLE Vendedor
ALTER COLUMN NMVendedor TYPE VARCHAR(60);

INSERT INTO Vendedor (CDVendedor, NMVendedor, NMEndereco, email) VALUES (1, 'Maria da Silva','Rua do Grito, 45','msilva@mednet.com.br');
INSERT INTO Vendedor (CDVendedor, NMVendedor, NMEndereco, email) VALUES (2, 'Marcos Andrade','Av. da Sauadade, 325','mandrade@mednet.com.br');
INSERT INTO Vendedor (CDVendedor, NMVendedor, NMEndereco, email) VALUES (3, 'Andrade Cardoso','Av. Brasil, 401','acardoso@mednet.com.br');
INSERT INTO Vendedor (CDVendedor, NMVendedor, NMEndereco, email) VALUES (4, 'Tatiana Souza','Rua do Imperador','tsouza@mednet.com.br');

ALTER TABLE Imóveis 
ADD COLUMN NMEndereco VARCHAR(60);

INSERT INTO Imóveis (CDImovel, CDVendedor, CDBairro, CDCidade, SGEstado, NMEndereco, Nrareautil, AreaTotal, VlPreco, imovel_Indicado) VALUES (1, 1, 1, 1, 'SP', 'Av. Tiete, 3304', 250, 400, '180000', NULL);
INSERT INTO Imóveis (CDImovel, CDVendedor, CDBairro, CDCidade, SGEstado, NMEndereco, Nrareautil, AreaTotal, VlPreco, imovel_Indicado) VALUES (2, 1, 2, 1, 'SP', 'Av. Morumbi, 2230', 150, 250, '135000', '1');
INSERT INTO Imóveis (CDImovel, CDVendedor, CDBairro, CDCidade, SGEstado, NMEndereco, Nrareautil, AreaTotal, VlPreco, imovel_Indicado) VALUES (3, 2, 5, 4, 'RJ', 'Rua Gal Osorio, 445', 250, 400, '185000', '2');
INSERT INTO Imóveis (CDImovel, CDVendedor, CDBairro, CDCidade, SGEstado, NMEndereco, Nrareautil, AreaTotal, VlPreco, imovel_Indicado) VALUES (4, 2, 4, 4, 'RJ', 'Rua Pedro I, 882', 120, 200, '110000', '1');
INSERT INTO Imóveis (CDImovel, CDVendedor, CDBairro, CDCidade, SGEstado, NMEndereco, Nrareautil, AreaTotal, VlPreco, imovel_Indicado) VALUES (5, 3, 3, 1, 'SP', 'Av. Rubem Berta, 2355', 110, 200, '95000', '4');
INSERT INTO Imóveis (CDImovel, CDVendedor, CDBairro, CDCidade, SGEstado, NMEndereco, Nrareautil, AreaTotal, VlPreco, imovel_Indicado) VALUES (6, 4, 5, 4, 'RJ', 'Rua Getulio Vargas, 552', 200, 300, '99000', '5');


ALTER TABLE Comprador
ALTER COLUMN email TYPE VARCHAR(60);

ALTER TABLE Comprador
ALTER COLUMN Endereço TYPE VARCHAR(60);

ALTER TABLE Comprador
ALTER COLUMN NMComprador TYPE VARCHAR(60);

INSERT INTO Comprador (CDComprador, NMComprador, Endereço, email) VALUES (1, 'Emmanuel Antunes','R Saraiva, 452','eantunes@mednet.com.br');
INSERT INTO Comprador (CDComprador, NMComprador, Endereço, email) VALUES (2, 'Joana Pereira','Av. Portugal, 52','jpereira@mednet.com.br');
INSERT INTO Comprador (CDComprador, NMComprador, Endereço, email) VALUES (3, 'Ronaldo Compelo','R Estados Unidos, 790','rcampelo@mednet.com.br');
INSERT INTO Comprador (CDComprador, NMComprador, Endereço, email) VALUES (4, 'Manfred Augusto','Av. Brasil, 351','maugusto@mednet.com.br');

INSERT INTO Oferta VALUES(1,1,170000,'2002-01-10');
INSERT INTO Oferta VALUES(1,3,180000,'2002-01-10');
INSERT INTO Oferta VALUES(2,2,135000,'2002-02-15');
INSERT INTO Oferta VALUES(2,4,100000,'2002-02-15');
INSERT INTO Oferta VALUES(3,1,160000,'2002-01-05');
INSERT INTO Oferta VALUES(3,2,140000,'2002-02-20');