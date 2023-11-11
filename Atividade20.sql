--1
CREATE OR REPLACE TRIGGER tr_baixar_estoque
AFTER INSERT ON ITEMPEDIDO
FOR EACH ROW
BEGIN
  UPDATE PRODUTO
  SET quantidade = quantidade - :NEW.quantidade
  WHERE codproduto = :NEW.codproduto;
END;

--2
CREATE OR REPLACE TRIGGER tr_log_cliente
AFTER INSERT OR UPDATE OR DELETE ON CLIENTE
FOR EACH ROW
BEGIN
  INSERT INTO LOG (data, descricao)
  VALUES (SYSDATE, 'Cliente modificado - CODCLIENTE: ' || :OLD.codcliente);
END;

--3
CREATE OR REPLACE TRIGGER tr_log_produto
AFTER INSERT OR UPDATE OR DELETE ON PRODUTO
FOR EACH ROW
BEGIN
  INSERT INTO LOG (data, descricao)
  VALUES (SYSDATE, 'Produto modificado - CODPRODUTO: ' || :OLD.codproduto);
END;

--4
CREATE OR REPLACE TRIGGER tr_log_sem_estoque
BEFORE INSERT ON ITEMPEDIDO
FOR EACH ROW
DECLARE
  v_qtd_disponivel NUMBER;
BEGIN
  SELECT quantidade INTO v_qtd_disponivel
  FROM PRODUTO
  WHERE codproduto = :NEW.codproduto;

  IF v_qtd_disponivel < :NEW.quantidade THEN
    INSERT INTO LOG (data, descricao)
    VALUES (SYSDATE, 'Sem estoque disponível para o item do pedido.');
    RAISE_APPLICATION_ERROR(-20001, 'Sem estoque disponível para o item do pedido.');
  END IF;
END;

--5
CREATE OR REPLACE TRIGGER tr_req_compra_estoque
AFTER INSERT ON ITEMPEDIDO
FOR EACH ROW
DECLARE
  v_vendas_mensais NUMBER;
BEGIN
  -- Lógica para calcular as vendas mensais (por exemplo, considerando um mês)
  SELECT SUM(quantidade)
  INTO v_vendas_mensais
  FROM ITEMPEDIDO
  WHERE EXTRACT(MONTH FROM datapedido) = EXTRACT(MONTH FROM SYSDATE);

  -- Lógica para calcular a quantidade disponível no estoque
  DECLARE
    v_qtd_disponivel NUMBER;
  BEGIN
    SELECT quantidade INTO v_qtd_disponivel
    FROM PRODUTO
    WHERE codproduto = :NEW.codproduto;

    -- Lógica para criar uma requisição de compra quando o estoque atingir 50% das vendas mensais
    IF v_qtd_disponivel < 0.5 * v_vendas_mensais THEN
      INSERT INTO REQUISICAO_COMPRA (codproduto, data, quantidade)
      VALUES (:NEW.codproduto, SYSDATE, ROUND(0.5 * v_vendas_mensais) - v_qtd_disponivel);
    END IF;
  END;
END;
--6
CREATE OR REPLACE TRIGGER tr_log_itempedido
BEFORE DELETE ON ITEMPEDIDO
FOR EACH ROW
BEGIN
  INSERT INTO LOG (data, descricao)
  VALUES (SYSDATE, 'Item do pedido removido - CODPEDIDO: ' || :OLD.codpedido || ', NUMEROITEM: ' || :OLD.numeroitem);
END;

--7
CREATE OR REPLACE TRIGGER tr_valor_minimo_itempedido
BEFORE INSERT ON ITEMPEDIDO
FOR EACH ROW
BEGIN
  IF :NEW.valorunitario < 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'O valor unitário não pode ser negativo.');
  END IF;
END;

--8
CREATE OR REPLACE TRIGGER tr_data_nascimento
BEFORE INSERT OR UPDATE ON CLIENTE
FOR EACH ROW
BEGIN
  IF :NEW.datanascimento > SYSDATE THEN
    RAISE_APPLICATION_ERROR(-20003, 'Data de nascimento não pode ser no futuro.');
  END IF;
END;

--9
CREATE OR REPLACE TRIGGER tr_quantidade_itempedido
BEFORE INSERT ON ITEMPEDIDO
FOR EACH ROW
BEGIN
  IF :NEW.quantidade < 0 THEN
    RAISE_APPLICATION_ERROR(-20004, 'A quantidade não pode ser negativa.');
  END IF;
END;

--10
CREATE OR REPLACE TRIGGER tr_acrescentar_sra
BEFORE INSERT OR UPDATE ON CLIENTE
FOR EACH ROW
BEGIN
  IF MONTHS_BETWEEN(SYSDATE, :NEW.datanascimento) / 12 > 30 THEN
    :NEW.nome := 'Sr(a) ' || :NEW.nome;
  END IF;
END;

--11
CREATE OR REPLACE TRIGGER tr_retornar_estoque
AFTER DELETE ON ITEMPEDIDO
FOR EACH ROW
BEGIN
  UPDATE PRODUTO
  SET quantidade = quantidade + :OLD.quantidade
  WHERE codproduto = :OLD.codproduto;
END;

--12
CREATE OR REPLACE TRIGGER tr_remover_reqcompra
BEFORE DELETE ON PRODUTO
FOR EACH ROW
BEGIN
  DELETE FROM REQUISICAO_COMPRA WHERE codproduto = :OLD.codproduto;
END;

--13
CREATE OR REPLACE TRIGGER tr_evitar_itens_repetidos
BEFORE INSERT ON ITEMPEDIDO
FOR EACH ROW
DECLARE
  v_qtd_existente NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO v_qtd_existente
  FROM ITEMPEDIDO
  WHERE codpedido = :NEW.codpedido AND codproduto = :NEW.codproduto;

  IF v_qtd_existente > 0 THEN
    RAISE_APPLICATION_ERROR(-20005, 'Não é permitido inserir o mesmo item no pedido mais de uma vez.');
  END IF;
END;