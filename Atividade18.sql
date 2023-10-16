CREATE TABLE Usuario (
    id SERIAL PRIMARY KEY,

    nm_login character varying,

    ds_senha character varying,

    fg_bloqueado boolean DEFAULT false,

    nu_tentativa_login integer DEFAULT 0
);


INSERT INTO usuario (id, nm_login, ds_senha, fg_bloqueado, nu_tentativa_login) 
VALUES 
(1, 'hallan', 'hallan2011', false, 0),
(2, 'joao', '123456', false, 0),
(3, 'maria', 'abcd1234', false, 2);


CREATE OR REPLACE FUNCTION check_login(p_login character varying, p_password character varying) 
RETURNS integer AS $$
DECLARE
    v_id integer;
    v_real_password character varying;
    v_attempts integer;
BEGIN

    SELECT id, ds_senha, nu_tentativa_login INTO v_id, v_real_password, v_attempts 
    FROM usuario 
    WHERE nm_login = p_login;

    
    IF v_id IS NULL THEN 
        RETURN NULL; 
    END IF;

    IF v_real_password = p_password THEN
        IF v_attempts = 2 THEN
            UPDATE usuario 
            SET nu_tentativa_login = 0 
            WHERE id = v_id;
        END IF;
        RETURN v_id; 
    ELSE
        IF v_attempts = 2 THEN
            UPDATE usuario 
            SET nu_tentativa_login = 3, fg_bloqueado = TRUE
            WHERE id = v_id;
        ELSE
            UPDATE usuario 
            SET nu_tentativa_login = v_attempts + 1 
            WHERE id = v_id;
        END IF;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


--IMÓVELNET 

--1
CREATE OR REPLACE FUNCTION listar_cidades(p_estado VARCHAR(10))
RETURNS TABLE(CidadeNome VARCHAR(10)) AS $$
BEGIN
    RETURN QUERY
    SELECT NMCidade FROM Cidade
    JOIN Estado ON Cidade.SGEstado = Estado.SGEstado
    WHERE Estado.NMEstado = p_estado;
END;
$$ LANGUAGE plpgsql;

--2
CREATE OR REPLACE FUNCTION listar_cidades_limited(p_estado VARCHAR(10), n INTEGER)
RETURNS TABLE(CidadeNome VARCHAR(10)) AS $$
BEGIN
    RETURN QUERY
    SELECT NMCidade FROM Cidade
    JOIN Estado ON Cidade.SGEstado = Estado.SGEstado
    WHERE Estado.NMEstado = p_estado
    LIMIT n;
END;
$$ LANGUAGE plpgsql;

--3
CREATE OR REPLACE FUNCTION listar_cidades_V(VARIADIC estados CHARACTER VARYING[])
RETURNS TABLE(CidadeNome VARCHAR(10)) AS $$
BEGIN
    RETURN QUERY
    SELECT NMCidade FROM Cidade
    JOIN Estado ON Cidade.SGEstado = Estado.SGEstado
    WHERE Estado.NMEstado = ANY(estados);
END;
$$ LANGUAGE plpgsql;


