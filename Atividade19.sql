
CREATE TABLE PILOTO  (
    Codigo_piloto int PRIMARY KEY,
    Nome_piloto    VARCHAR(100),
    Salario        NUMERIC(9,2),
    Gratificacao   NUMERIC(9,2),
    Companhia      VARCHAR(30),
    Pais           VARCHAR(15),
    Data_Cadastro  DATE,
    Usuario_Update VARCHAR(30)
);

CREATE TABLE Piloto_resumido (
    Codigo_Piloto INT PRIMARY KEY,
    Nome_Piloto VARCHAR(100)
);

--1
CREATE OR REPLACE FUNCTION preencher_data_cadastro()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar se Data_Cadastro está em branco (ou seja, NULL)
    IF NEW.Data_Cadastro IS NULL THEN
        -- Preencher Data_Cadastro com a data do sistema
        NEW.Data_Cadastro = CURRENT_DATE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_preencher_data_cadastro
BEFORE INSERT ON PILOTO
FOR EACH ROW
EXECUTE FUNCTION preencher_data_cadastro();

--2
CREATE OR REPLACE FUNCTION validar_salario()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar se o novo salário é maior que 10.000
    IF NEW.Salario > 10000.00 THEN
        RAISE EXCEPTION 'Salário superior ao limite máximo de 10.000 dólares';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_salario_insert
BEFORE INSERT ON PILOTO
FOR EACH ROW
EXECUTE FUNCTION validar_salario();

CREATE TRIGGER trigger_validar_salario_update
BEFORE UPDATE ON PILOTO
FOR EACH ROW
EXECUTE FUNCTION validar_salario();

--3
CREATE OR REPLACE FUNCTION validar_data_atualizacao()
RETURNS TRIGGER AS $$
BEGIN
    IF EXTRACT('Day' FROM CURRENT_DATE) BETWEEN 10 AND 20 THEN
        RAISE EXCEPTION 'Não é permitido atualizar registros entre os dias 10 e 20 do mês';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_data_atualizacao
BEFORE UPDATE ON PILOTO
FOR EACH ROW
EXECUTE FUNCTION validar_data_atualizacao();


--4
CREATE OR REPLACE FUNCTION inserir_na_tabela_resumida()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Piloto_resumido (Codigo_Piloto, Nome_Piloto)
    VALUES (NEW.Codigo_Piloto, NEW.Nome_Piloto);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_inserir_na_tabela_resumido
AFTER INSERT ON PILOTO
FOR EACH ROW
EXECUTE FUNCTION inserir_na_tabela_resumido();

--5
CREATE OR REPLACE FUNCTION excluir_na_tabela_resumido()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM Piloto_resumido
    WHERE Codigo_Piloto = OLD.Codigo_Piloto;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_excluir_na_tabela_resumido
AFTER DELETE ON PILOTO
FOR EACH ROW
EXECUTE FUNCTION excluir_na_tabela_resumido();

--6
CREATE OR REPLACE FUNCTION registrar_ultima_atualizacao()
RETURNS TRIGGER AS $$
BEGIN
    NEW.Usuario_Update = current_user;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_registrar_ultima_atualizacao
BEFORE UPDATE ON PILOTO
FOR EACH ROW
EXECUTE FUNCTION registrar_ultima_atualizacao();

--7
CREATE OR REPLACE FUNCTION replicar_piloto_resumido()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Piloto_resumido (Codigo_Piloto, Nome_Piloto)
    VALUES (NEW.Codigo_Piloto, NEW.Nome_Piloto);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_replicar_piloto_resumido
AFTER INSERT ON PILOTO
FOR EACH ROW
EXECUTE FUNCTION replicar_piloto_resumido();

--8
CREATE OR REPLACE FUNCTION registrar_ultima_atualizacao()
RETURNS TRIGGER AS $$
BEGIN
    NEW.Usuario_Update = current_user;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_registrar_ultima_atualizacao
BEFORE UPDATE ON PILOTO
FOR EACH ROW
EXECUTE FUNCTION registrar_ultima_atualizacao();