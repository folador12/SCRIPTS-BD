-- 1 Escreva uma consulta para exibir as ofertas e os compradores que estão acima da média de preços.
SELECT *
FROM oferta
INNER JOIN comprador 
ON comprador.cdComprador = oferta.cdComprador
WHERE vloferta > (SELECT AVG(vloferta) FROM oferta);

-- 2 Escreva uma consulta para exibir o nome do comprador e a oferta de compra das 3 maiores ofertas de compra em ordem decrescente.
SELECT comprador.nmcomprador, oferta.vloferta
FROM oferta
INNER JOIN comprador ON comprador.cdComprador = oferta.cdComprador
ORDER BY oferta.vloferta DESC
LIMIT 3;

--3 Escreva uma consulta com todos os compradores e os seus respectivos lances e os endereços dos imóveis.
SELECT comprador.nmcomprador, oferta.vloferta, imóveis.nmendereco
FROM oferta
INNER JOIN comprador ON comprador.cdComprador = oferta.cdComprador
INNER JOIN imóveis ON imóveis.cdImovel = oferta.cdImovel;

--4 Escreva uma consulta com o nome dos compradores, os endereços dos imóveis e somente os lances maiores que a média de lances.
SELECT comprador.NMComprador, imóveis.NMEndereco, oferta.VLOferta 
FROM oferta 
INNER JOIN comprador ON oferta.CDComprador = comprador.CDComprador 
INNER JOIN imóveis ON oferta.CDImovel = imóveis.CDImovel 
WHERE oferta.VLOferta > (SELECT AVG(VLOferta) FROM oferta);

--5 Escreva uma consulta que exiba os nomes dos vendedores com os imóveis.
SELECT vendedor.NMVendedor
FROM vendedor
INNER JOIN imóveis ON imóveis.CDVendedor = vendedor.CDVendedor
GROUP BY vendedor.NMVendedor;

--6 Escreva uma consulta que exiba os nomes dos vendedores com o código do imóvel, os lances e os nomes dos compradores.
SELECT vendedor.NMVendedor, imóveis.CDImovel, oferta.VLOferta, comprador.NMComprador
FROM vendedor
INNER JOIN imóveis ON imóveis.CDVendedor = vendedor.CDVendedor
INNER JOIN oferta ON oferta.CDImovel = imóveis.CDImovel
INNER JOIN comprador ON oferta.CDComprador = comprador.CDComprador;

--7 Faça uma consulta para encontrar algum imóvel com endereço que tenha o nome “pedro”.
SELECT *
FROM imóveis
WHERE nmendereco LIKE '%pedro%';

--8 Faça uma consulta para imprimir todos os compradores que tenham a letra “M” no começo do nome.
SELECT *
FROM comprador
WHERE nmcomprador LIKE 'M%';

--9 Faça uma consulta que exiba o código do imóvel, o código do comprador, o nome do comprador, o valor da oferta e a data da oferta em formato do Brasil, ordenado pelo nome do comprador decrescente.
SELECT imóveis.cdImovel, comprador.cdComprador, comprador.nmcomprador, oferta.vloferta, oferta.dtOferta
FROM oferta
INNER JOIN comprador ON oferta.cdComprador = comprador.cdComprador
INNER JOIN imóveis ON oferta.cdImovel = imóveis.cdImovel
ORDER BY comprador.nmcomprador DESC;

--10 Faça uma consulta que retorne a soma, a media de todos os valores ofertados, o valor máximo e o valor mínimo ofertado para compra dos imóveis.
SELECT SUM(vloferta), AVG(vloferta), MAX(vloferta), MIN(vloferta)
FROM oferta;

--11 Faça uma lista de imóveis do mesmo bairro do imóvel 2. Exclua o imóvel 2 da sua busca.
SELECT *
FROM imóveis
WHERE cdbairro = (SELECT cdbairro FROM imóveis WHERE cdimovel = 2) AND cdimovel != 2;

--12 Faça uma lista que mostre todos os imóveis que custam mais que a média de preço dos imóveis.
SELECT *
FROM imóveis
WHERE vlpreco::numeric > (SELECT AVG(vlpreco::numeric) FROM imóveis);

--13 Faça uma lista com todos os compradores que tenham ofertas cadastradas com valor superior a 70 mil.
SELECT *
FROM comprador
WHERE cdcomprador IN (
    SELECT cdcomprador 
    FROM oferta 
    WHERE vloferta > 70000
    );

--14 Faça uma lista com todos os imóveis com oferta superior à média do valor das ofertas.
SELECT *
FROM imóveis
WHERE cdimovel IN (
    SELECT cdimovel 
    FROM oferta 
    WHERE vloferta > (SELECT AVG(vloferta) FROM oferta)
    );

--15 Faça uma lista com todos os imóveis com preço superior à media de preço dos imóveis do bairro.
SELECT *
FROM imóveis
WHERE vlpreco::numeric > (
    SELECT AVG(vlpreco::numeric) 
    FROM imóveis 
    WHERE cdbairro = imóveis.cdbairro
    );

--16 Faça uma lista dos imóveis com maior preço agrupado por bairro, cujo maior preço seja superior à media de preços dos imóveis.
SELECT *
FROM imóveis
WHERE vlpreco::numeric > (
    SELECT AVG(vlpreco::numeric) 
    FROM imóveis 
    WHERE cdbairro = imóveis.cdbairro
    );


--17 Faça uma lista com os imóveis que têm preço igual ao menor preço de cada vendedor.
SELECT *
FROM imóveis
WHERE vlpreco::numeric = (
    SELECT MIN(vlpreco::numeric) 
    FROM imóveis 
    WHERE cdbairro = imóveis.cdbairro
    );

--18 Faça uma lista com as ofertas dos imóveis com data de lançamento do imóvel inferior a 30 dias e superior a 180 dias, a contar de hoje e cujo código vendedor seja 2
SELECT *
FROM oferta
WHERE dtOferta BETWEEN (CURRENT_DATE - 30) AND (CURRENT_DATE - 180) AND cdvendedor = 2;

--19 Faça uma lista com as ofertas dos imóveis que têm o preço igual ao menor preço de todos os vendedores, exceto as ofertas do próprio comprador.
SELECT *
FROM oferta
WHERE vloferta = (
        SELECT MIN(vlpreco::numeric) 
        FROM imóveis 
        WHERE cdbairro = imóveis.cdbairro
    ) AND cdcomprador != oferta.cdcomprador;

--20 Faça uma lista com ofertas menores que todas as ofertas do comprador 2, exceto as ofertas do próprio comprador.
SELECT *
FROM oferta
WHERE vloferta < (
        SELECT MIN(vlpreco::numeric) 
        FROM imóveis 
        WHERE cdbairro = imóveis.cdbairro
    ) AND cdcomprador != oferta.cdcomprador;

--21 Faça uma lista do todos os imóveis cujo Estado e cidade sejam os mesmos do vendedor 3, exceto os imóveis do vendedor 3.
SELECT *
FROM imóveis
WHERE sgestado = (
        SELECT sgestado 
        FROM vendedor 
        WHERE cdvendedor = 3
    ) AND cdcidade = (
        SELECT cdcidade 
        FROM vendedor 
        WHERE cdvendedor = 3
    ) AND cdvendedor != 3;

--22 Faça uma lista de todos os imóveis cujo Estado e cidade sejam do mesmo Estado, cidade e bairro do imóvel código 5
SELECT *
FROM imóveis
WHERE sgestado = (
        SELECT sgestado 
        FROM imóveis 
        WHERE cdimovel = 5
    ) 
    AND cdcidade = (
        SELECT cdcidade 
        FROM imóveis 
        WHERE cdimovel = 5
    ) 
    AND cdbairro = (
        SELECT cdbairro 
        FROM imóveis 
        WHERE cdimovel = 5
    );