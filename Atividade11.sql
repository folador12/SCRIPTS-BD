--1
ALTER imóveis
ALTER COLUMN Imóveis TYPE FLOAT USING vlpreco::double precision
UPDATE imóveis
SET VlPreco = VlPreco * 1.10;

--2
UPDATE imóveis
SET VlPreco = VlPreco -(VlPreco*0.05)
WHERE CDVendedor = 1;

--3
UPDATE oferta
SET VLOferta = VLOferta * 1.05
WHERE CDComprador = 2;

--4
UPDATE Comprador
SET Endereço = 'RANANÁS, 45', Estado = 'RJ'
WHERE CDComprador = 3;

--5
UPDATE oferta
SET VLOferta = 101000
WHERE CDComprador = 2 AND CdImovel = 4;

--6
DELETE FROM oferta
WHERE CDComprador = 3 AND CdImovel = 1;

--7 
DELETE FROM Cidade
WHERE CDCidade = 3 AND SGEstado = 'SP';

--8
SELECT *
FROM Bairro;

--9
SELECT CDComprador, NMComprador , email
FROM Comprador;

--10
SELECT CDVendedor, NMVendedor, email
FROM Vendedor
ORDER BY NMVendedor;

--11
SELECT CDVendedor, NMVendedor, email
FROM Vendedor
ORDER BY NMVendedor DESC;

--12
SELECT NomeBairro
FROM Bairro
WHERE SGEstado = 'SP';

--13
SELECT CDImovel , CDVendedor , VlPreco
FROM Imóveis
WHERE CDVendedor = 2;

--14 
SELECT CDImovel , CDVendedor , VlPreco, SGEstado
FROM Imóveis
WHERE VlPreco < 150000 AND SGEstado = 'RJ';

--15
SELECT CDImovel , CDVendedor , VlPreco, SGEstado
FROM Imóveis
WHERE VlPreco < 150000 AND CDVendedor = 1;

--16
SELECT CDImovel , CDVendedor , VlPreco, SGEstado
FROM Imóveis
WHERE VlPreco < 150000 AND CDVendedor != 2;

--17
SELECT CDComprador , NMComprador , Endereço, Estado
FROM Comprador
WHERE Estado IS NULL;

--18
SELECT CDComprador , NMComprador , Endereço, Estado
FROM Comprador
WHERE Estado IS NOT NULL;

--19
SELECT *
FROM oferta
WHERE VLOferta < 150000 AND VLOferta > 100000;

--20
SELECT *
FROM oferta
WHERE DataOferta >= '2002-02-01' AND DataOferta <= '2002-03-01';

--21
SELECT * 
FROM Vendedor 
WHERE NMVendedor LIKE 'M%';

--22
SELECT * 
FROM Vendedor 
WHERE NMVendedor LIKE '_A%';

--23
SELECT * 
FROM Comprador 
WHERE Endereço LIKE '%U%';

--24
SELECT *
FROM oferta
WHERE CdImovel IN (1,2);

--25
SELECT *
FROM Imóveis
WHERE CdImovel IN (2,3)
ORDER BY NMEndereco;

--26
SELECT * 
FROM Oferta 
WHERE CdImovel IN (2, 3) AND VLOferta > 140000 
ORDER BY DataOferta DESC;

--27
SELECT * 
FROM Imóveis 
WHERE (VlPreco BETWEEN 110000 AND 200000) OR CDVendedor = 1 
ORDER BY Nrareautil;

--28
SELECT CDImovel, VlPreco, VlPreco * 1.10 AS VlPrecoWithIncrease 
FROM Imóveis;

--29
SELECT CDImovel, VlPreco, VlPreco * 1.10 AS VlPrecoWithIncrease, VlPreco * 0.10 AS Difference 
FROM Imóveis;

--30
SELECT UPPER(NMVendedor) AS NMVendedor, LOWER(email) AS email 
FROM Vendedor;

--31
SELECT CONCAT(NMComprador, ' - ', NMCidade) AS CombinedColumn 
FROM Comprador 
JOIN Cidade ON Comprador.Cidade = Cidade.NMCidade;

--32
SELECT * 
FROM Comprador 
WHERE NMComprador LIKE '%A%';

--33
SELECT * 
FROM Comprador 
WHERE NMComprador IS NOT NULL;

--34
SELECT * 
FROM Imóveis 
WHERE SGEstado = 'SP';

--35
SELECT * 
FROM Imóveis 
WHERE VlPreco > 100000;

--36
SELECT NMVendedor, Rua, Cidade.NMCidade
FROM Imóveis
JOIN Vendedor ON Imóveis.CDVendedor = Vendedor.CDVendedor
JOIN Cidade ON Imóveis.CdCidade = Cidade.CDCidade
WHERE Cidade.NMCidade = 'Ribeirão Preto' AND Imóveis.SGEstado = 'SP';

--37
SELECT * 
FROM Imóveis 
WHERE SGEstado IN ('SP', 'MG');

--38
SELECT CDImovel, Vendedor.CDVendedor, NMVendedor, SGEstado
FROM Imóveis
JOIN Vendedor ON Imóveis.CDVendedor = Vendedor.CDVendedor;

--39
SELECT CDCOMPRADOR, NMCOMPRADOR, CDIMOVEL, VLOFERTA
FROM Oferta
JOIN Comprador ON Oferta.CDComprador = Comprador.CDComprador;

--40
SELECT CDImovel, VlPreco, NomeBairro
FROM Imóveis
JOIN Bairro ON Imóveis.CDBairro = Bairro.CDBairro
WHERE CDVendedor = 2;

--41
SELECT DISTINCT Imóveis.* 
FROM Imóveis 
JOIN Oferta ON Imóveis.CDImovel = Oferta.CdImovel;

--42
SELECT * 
FROM Imóveis 
LEFT JOIN Oferta ON Imóveis.CDImovel = Oferta.CdImovel;

--43
SELECT Comprador.*, Oferta.VLOferta 
FROM Comprador 
JOIN Oferta ON Comprador.CDComprador = Oferta.CDComprador;

--44
SELECT Comprador.*, Oferta.VLOferta 
FROM Comprador 
LEFT JOIN Oferta ON Comprador.CDComprador = Oferta.CDComprador;

--45
SELECT Comprador.*, Oferta.VLOferta, Vendedor.NMVendedor, Imóveis.Rua 
FROM Comprador 
LEFT JOIN Oferta ON Comprador.CDComprador = Oferta.CDComprador
JOIN Imóveis ON Oferta.CdImovel = Imóveis.CDImovel
JOIN Vendedor ON Imóveis.CDVendedor = Vendedor.CDVendedor;

--46
SELECT Comprador.*, Oferta.VLOferta, 
       Vendedor1.NMVendedor AS VendedorDoImovel, 
       Imóveis.Rua, 
       Vendedor2.NMVendedor AS VendedorDoImovelIndicado, 
       ImoveisIndicados.Rua AS EnderecoImovelIndicado 
FROM Comprador 
LEFT JOIN Oferta ON Comprador.CDComprador = Oferta.CDComprador
JOIN Imóveis ON Oferta.CdImovel = Imóveis.CDImovel
JOIN Vendedor AS Vendedor1 ON Imóveis.CDVendedor = Vendedor1.CDVendedor
LEFT JOIN Imóveis AS ImoveisIndicados ON Imóveis.imovel_Indicado = ImoveisIndicados.CDImovel
LEFT JOIN Vendedor AS Vendedor2 ON ImoveisIndicados.CDVendedor = Vendedor2.CDVendedor;

--47
SELECT Imóveis.Rua, Bairro.NomeBairro, Imóveis.VlPreco 
FROM Imóveis 
JOIN Bairro ON Imóveis.CDBairro = Bairro.CDBairro;

--48
SELECT MAX(VLOferta) AS MaxValue, MIN(VLOferta) AS MinValue, AVG(VLOferta) AS AverageValue 
FROM Oferta;

--49
SELECT STDDEV(VlPreco) AS StandardDeviation, VARIANCE(VlPreco) AS Variance 
FROM Imóveis;

--50
SELECT ROUND(STDDEV(VlPreco), 2) AS StandardDeviation, ROUND(VARIANCE(VlPreco), 2) AS Variance 
FROM Imóveis;

--51
SELECT MAX(VlPreco) AS MaxValue, MIN(VlPreco) AS MinValue, SUM(VlPreco) AS TotalValue, AVG(VlPreco) AS AverageValue 
FROM Imóveis;

--52
SELECT Bairro.NomeBairro, MAX(Imóveis.VlPreco) AS MaxValue, MIN(Imóveis.VlPreco) AS MinValue, SUM(Imóveis.VlPreco) AS TotalValue, AVG(Imóveis.VlPreco) AS AverageValue 
FROM Imóveis 
JOIN Bairro ON Imóveis.CDBairro = Bairro.CDBairro 
GROUP BY Bairro.NomeBairro;

--53
SELECT CDVendedor, COUNT(*) AS TotalImoveis 
FROM Imóveis 
GROUP BY CDVendedor 
ORDER BY TotalImoveis DESC;

--54
SELECT (MAX(VlPreco) - MIN(VlPreco)) AS PriceDifference 
FROM Imóveis;

--55
SELECT CDVendedor, MIN(VlPreco) AS LowestPrice 
FROM Imóveis 
WHERE VlPreco >= 10000 
GROUP BY CDVendedor;

--56
SELECT Comprador.CDComprador, Comprador.NMComprador, AVG(Oferta.VLOferta) AS AverageOffer, COUNT(Oferta.VLOferta) AS NumberOfOffers 
FROM Comprador 
JOIN Oferta ON Comprador.CDComprador = Oferta.CDComprador 
GROUP BY Comprador.CDComprador, Comprador.NMComprador;

--57
SELECT EXTRACT(YEAR FROM DataOferta) AS Year, COUNT(*) AS TotalOffers 
FROM Oferta 
WHERE EXTRACT(YEAR FROM DataOferta) IN (2000, 2001, 2002) 
GROUP BY EXTRACT(YEAR FROM DataOferta);
