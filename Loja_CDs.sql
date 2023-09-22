CREATE TABLE Gravadora (
	Codigo_gravadora INTEGER NOT NULL,
	Nome_gravadora VARCHAR(60),
	Rua VARCHAR(30),
																								Bairro VARCHAR(50),
																								Cidade VARCHAR(30),
																								Estado VARCHAR(2),
																								Num VARCHAR(10),
																								Contato VARCHAR(20),
																								URL VARCHAR(80),
																								PRIMARY KEY (Codigo_gravadora));


CREATE TABLE Telefone(Telefone VARCHAR(14) UNIQUE NOT NULL,
																						Codigo_gravadora INTEGER, PRIMARY KEY(Telefone, Codigo_gravadora));


CREATE TABLE CD (Codigo_cd INTEGER NOT NULL,
																	Codigo_gravadora INTEGER, nome_cd VARCHAR(60),
																	preco_vendas DECIMAL (14,2),
																	Data_lancamento DATE, possui_codigo_cd INTEGER, cd_indicado INTEGER NULL,
																	PRIMARY KEY (Codigo_cd));


CREATE TABLE Faixa (Codigo_musica INTEGER, Codigo_cd INTEGER, Numero_faixa INTEGER);


CREATE TABLE Musica (Codigo_musica INTEGER PRIMARY KEY,
																					nome_musica VARCHAR(60),
																					Duracao DECIMAL(6,2));


CREATE TABLE Musica_Autor(Codigo_autor INTEGER, Codigo_musica INTEGER);


CREATE TABLE Autor(nome_autor VARCHAR(60),
																			Codigo_autor INTEGER PRIMARY KEY);


CREATE TABLE Categoria(Codigo_categoria INTEGER PRIMARY KEY,
																							Menor_preco DECIMAL(10,2),
																							Maior_preco DECIMAL(10,2));


ALTER TABLE Telefone ADD
FOREIGN KEY(Codigo_gravadora) REFERENCES Gravadora;


ALTER TABLE CD ADD
FOREIGN KEY (Codigo_gravadora) REFERENCES Gravadora;


ALTER TABLE CD 
ADD FOREIGN KEY (cd_indicado) 
REFERENCES CD;


ALTER TABLE Faixa ADD
FOREIGN KEY (Codigo_musica) REFERENCES Musica;


ALTER TABLE Faixa ADD
FOREIGN KEY (Codigo_cd) REFERENCES CD;


ALTER TABLE Musica_Autor ADD
FOREIGN KEY (Codigo_musica) REFERENCES Musica;


ALTER TABLE Musica_Autor ADD
FOREIGN KEY (Codigo_autor) REFERENCES Autor;