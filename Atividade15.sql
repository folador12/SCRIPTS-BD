CREATE TABLE piloto(
    codigo_piloto integer PRIMARY KEY,
    nome_piloto varchar(30),
    salario decimal(10,2),
    gratificacao decimal(10,2),
    companhia varchar(20),
    pais varchar(20)
);

CREATE TABLE voo(
    codigo_voo integer PRIMARY KEY,
    aeroporto_origem integer,
    aeroporto_destino integer,
    hora timestamp
);

CREATE TABLE escala(
    codigo_voo integer,
    data_voo date,
    codigo_piloto integer,
    aviao integer,
    PRIMARY KEY(codigo_voo, data_voo)
);

CREATE TABLE aeroporto(
    codigo_aeroporto integer PRIMARY KEY,
    nome_aeroporto varchar(20),
    cidade varchar(20),
    pais varchar(20)
);

ALTER TABLE escala
ADD FOREIGN KEY (codigo_voo)
REFERENCES voo(codigo_voo);

ALTER TABLE escala
ADD FOREIGN KEY (codigo_piloto)
REFERENCES piloto(codigo_piloto);

ALTER TABLE voo
ADD FOREIGN KEY (aeroporto_origem)
REFERENCES aeroporto(codigo_aeroporto);

ALTER TABLE voo
ADD FOREIGN KEY (aeroporto_destino)
REFERENCES aeroporto(codigo_aeroporto);


--Os dados de todos os pilotos de companhias brasileiras.
CREATE VIEW PilotosBrasileiros AS
SELECT * FROM piloto
WHERE pais = 'Brasil';

--O nome de todos os pilotos da Varig.
CREATE VIEW PilotosVarig AS
SELECT nome_piloto FROM piloto
WHERE companhia = 'Varig';

--O nome de todos os pilotos escalados.
CREATE VIEW PilotosEscalados AS
SELECT p.nome_piloto FROM piloto p
JOIN escala e ON p.codigo_piloto = e.codigo_piloto;

--Os códigos do vôos que partem do Brasil.
CREATE VIEW VoosBrasil AS
SELECT v.codigo_voo FROM voo v
JOIN aeroporto a ON v.aeroporto_origem = a.codigo_aeroporto
WHERE a.pais = 'Brasil';

--Os pilotos que voam para o seu pais de origem.
CREATE VIEW PilotosVoamOrigem AS
SELECT p.nome_piloto FROM piloto p
JOIN escala e ON p.codigo_piloto = e.codigo_piloto
JOIN voo v ON e.codigo_voo = v.codigo_voo
JOIN aeroporto a ON v.aeroporto_destino = a.codigo_aeroporto
WHERE p.pais = a.pais;

--nome de todos os pilotos, junto com seu salário e gratificação.
CREATE VIEW SalarioGratificacaoPilotos AS
SELECT nome_piloto, salario, gratificacao FROM piloto;

--O código dos vôos com seu respectivo nome dos pilotos e do nome dos seus aeroportos de origem e destino.
CREATE VIEW VoosPilotosAeroportos AS
SELECT v.codigo_voo, p.nome_piloto, ao.nome_aeroporto AS
origem, ad.nome_aeroporto AS destino
FROM voo v
JOIN escala e ON v.codigo_voo = e.codigo_voo
JOIN piloto p ON e.codigo_piloto = p.codigo_piloto
JOIN aeroporto ao ON v.aeroporto_origem = ao.codigo_aeroporto
JOIN aeroporto ad ON v.aeroporto_destino = ad.codigo_aeroporto;

--O código de todos os vôos, nome dos pilotos escalados para os mesmos, e respectivos tipos de avião e companhia.
CREATE VIEW VoosPilotosAviaoCompanhia AS
SELECT v.codigo_voo, p.nome_piloto, e.aviao, p.companhia
FROM voo v
JOIN escala e ON v.codigo_voo = e.codigo_voo
JOIN piloto p ON e.codigo_piloto = p.codigo_piloto;

--A companhia dos pilotos que voam para a Itália.
CREATE VIEW CompanhiaVoosItalia AS
SELECT DISTINCT p.companhia FROM piloto p
JOIN escala e ON p.codigo_piloto = e.codigo_piloto
JOIN voo v ON e.codigo_voo = v.codigo_voo
JOIN aeroporto a ON v.aeroporto_destino = a.codigo_aeroporto
WHERE a.pais = 'Itália';

--O nome de todos os aeroportos onde a varig opera.
CREATE VIEW AeroportosVarig AS
SELECT DISTINCT a.nome_aeroporto FROM aeroporto a
JOIN voo v ON (a.codigo_aeroporto = v.aeroporto_origem OR
a.codigo_aeroporto = v.aeroporto_destino)
JOIN escala e ON v.codigo_voo = e.codigo_voo
JOIN piloto p ON e.codigo_piloto = p.codigo_piloto
WHERE p.companhia = 'Varig';

--O maior , o menor e quantidade de pilotos.
CREATE VIEW EstatisticasPilotos AS
SELECT MAX(salario) as salario_maximo, MIN(salario) as
salario_minimo, COUNT(*) as quantidade FROM piloto;

--O maior , o menor e quantidade de pilotos por companhia.
CREATE VIEW EstatisticasPilotosCompanhia AS
SELECT companhia, MAX(salario) as salario_maximo, MIN(salario)
as salario_minimo, COUNT(*) as quantidade FROM piloto GROUP BY
companhia;

--O maior , o menor e média dos salários dos pilotos de companhias brasileiras.
CREATE VIEW EstatisticasSalariosBrasil AS
SELECT MAX(salario) as salario_maximo, MIN(salario) as
salario_minimo, AVG(salario) as media_salarios FROM piloto WHERE
pais='Brasil';

--O total da folha de pagamento por companhias
CREATE VIEW FolhaPagamentoCompanhias AS
SELECT companhia, SUM(salario + gratificacao) as total_folha
FROM piloto GROUP BY companhia;

--O total de pilotos por pais.
CREATE VIEW TotalPilotosPais AS
SELECT pais, COUNT(*) as total_pilotos FROM piloto GROUP BY
pais;

--O Número de Aeroporto por Cidade Brasileira.
CREATE VIEW AeroportosCidadeBrasil AS
SELECT cidade, COUNT(*) as numero_aeroportos FROM aeroporto
WHERE pais='Brasil' GROUP BY cidade;