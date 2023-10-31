-- 3
CREATE OR REPLACE FUNCTION BuscarProduto(cod INT) 
RETURNS TABLE (codproduto INT, descricao VARCHAR(100), quantidade INT) 
AS $BODY$ 
BEGIN 
RETURN QUERY SELECT * FROM PRODUTO WHERE PRODUTO.codproduto = cod;
END;
$BODY$ 
LANGUAGE plpgsql;


--4
CREATE OR REPLACE FUNCTION RemovePedido(p_codproduto INT)
RETURNS VOID 
AS $BODY$
BEGIN
    DELETE FROM ITEMPEDIDO
    	WHERE ITEMPEDIDO.codproduto = p_codproduto;
    DELETE FROM PEDIDO
    	WHERE PEDIDO.codpedido NOT IN (SELECT codpedido FROM ITEMPEDIDO);
END;
$BODY$ 
LANGUAGE plpgsql;

--5
CREATE OR REPLACE FUNCTION BuscarFornecedor(p_codpedido INT)
RETURNS TABLE(nf VARCHAR(12)) AS
$BODY$
BEGIN
    RETURN QUERY SELECT PEDIDO.nf FROM PEDIDO WHERE codpedido = p_codpedido;
END;
$BODY$
LANGUAGE plpgsql;


--6
CREATE OR REPLACE FUNCTION BucarCliente(p_cpf VARCHAR(11))
RETURNS TABLE(nome VARCHAR(60)) 
AS $BODY$
BEGIN
    RETURN QUERY SELECT CLIENTE.nome FROM CLIENTE WHERE cpf = p_cpf;
END;
$BODY$ 
LANGUAGE plpgsql;

--7
SELECT MAX(p.descricao) AS MaiorProduto, MAX(ip.valorunitario) AS MaiorPreco, MIN(p.descricao) AS MenorProduto, MIN(ip.valorunitario) AS MenorPreco 
FROM produto p 
JOIN itempedido ip ON p.codproduto = ip.codproduto;



--8
SELECT c.codcliente, c.nome, COUNT(p.codpedido) AS Qauntidade_Compras
FROM CLIENTE c
LEFT JOIN PEDIDO p ON c.codcliente = p.codcliente
GROUP BY c.codcliente, c.nome
ORDER BY c.codcliente;

--9

CREATE OR REPLACE FUNCTION AtualizarItemPedido(
    p_codpedido INT, 
    p_numeroitem INT,
    p_codproduto INT
) RETURNS VOID 
AS $BODY$
BEGIN
    UPDATE ITEMPEDIDO 
    SET quantidade = quantidade + 
        CASE 
            WHEN quantidade < 10 THEN 25
            WHEN quantidade >= 10 AND quantidade < 40 THEN 15
            ELSE 5
        END
    WHERE codpedido = p_codpedido AND 
          numeroitem = p_numeroitem AND 
          codproduto = p_codproduto;
END;
$BODY$
LANGUAGE plpgsql;


--10
SELECT C.nome, SUM(P.valortotal) AS Valor_Compras
FROM CLIENTE C 
INNER JOIN PEDIDO P ON C.codcliente = P.codcliente
WHERE P.datapedido BETWEEN (CURRENT_DATE - INTERVAL '30 DAYS') AND CURRENT_DATE
GROUP BY C.nome
ORDER BY Valor_Compras DESC;