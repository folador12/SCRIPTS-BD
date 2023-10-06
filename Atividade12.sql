CREATE TABLE empregado(
    Ident INTEGER PRIMARY KEY,
    Nome VARCHAR(60),
    Sal DECIMAL(10,2),
    Endereco VARCHAR(60),
    Sexo VARCHAR(1),
    DataNasc DATE,
    DepNum INTEGER,
    SuperIdent INTEGER,
);

CREATE TABLE departamento(
    Num INTEGER PRIMARY KEY,
    Nome VARCHAR(60),
    IdentGer INTEGER,
    DataIni DATE,
);

CREATE TABLE projeto(
    Num INTEGER PRIMARY KEY,
    Nome VARCHAR(60),
    Local VARCHAR(60),
    DepNum INTEGER,
);

CREATE TABLE trabalhando(
    IdentEmp INTEGER PRIMARY KEY,
    ProjNum INTEGER NOT NULL
    Hrs DECIMAL (10,2),

);

CREATE TABLE dependente(
    IdentEmp INTEGER NOT NULL,
    Nome VARCHAR(60),
    Sexo VARCHAR(2),
    DataNasc DATE,
    Parentesco VARCHAR(60),

    PRIMARY KEY (IdentEmp, Nome)
);

CREATE TABLE deploc(
    DepNum INTEGER NOT NULL,
    Local VARCHAR(60),

    PRIMARY KEY (DepNum, Local)
);


ALTER TABLE empregado
ADD FOREIGN KEY DepNum
REFERENCES departamento(Num);

ALTER TABLE empregado
ADD FOREIGN KEY SuperIdent
REFERENCES empregado(Ident);

ALTER TABLE departamento
ADD FOREIGN KEY IdentGer
REFERENCES empregado(Ident);

ALTER TABLE projeto
ADD FOREIGN KEY DepNum
REFERENCES  departamento(num);

ALTER TABLE trabalhando
ADD FOREIGN KEY ProjNum
REFERENCES projeto(Num);

ALTER TABLE trabalhando
ADD FOREIGN KEY IdentEmp
REFERENCES empregado(Ident);

ALTER TABLE dependente
ADD FOREIGN KEY IdentEmp
REFERENCES empregado(Ident);

ALTER TABLE deploc
ADD FOREIGN KEY DepNum
REFERENCES departamento(Num);


-- Listar todos os Números dos projetos e os respectivos Números de Departamento que os controlam.
SELECT Num, DepNum
From projeto;

-- Exibir o nome e grau de parentesco dos dependentes juntamente com a identidade e nome dos empregados dos quais dependem.
SELECT d.Nome, d.Parentesco, i.Ident, i.Nome    
FROM  dependente d
INNER JOIN empregado AS i on d.IdentEmp = i.Ident;

-- Para cada empregado, mostrar seu nome e sexo, e a identidade e nome do seu superior imediato.
SELECT e.Nome, e.Sexo, e.Ident, i.Nome
FROM empregado e
INNER JOIN empregado as i on e.Ident = i.Ident; 

-- Listar os diferentes valores de salários pagos aos empregados da empresa.
SELECT DISTINCT Sal
FROM empregado;

-- Apresentar os nomes de todos os empregados que não têm dependente.
SELECT e.Nome
FROM empregado e
LEFT JOIN  dependente d on e.Ident = d.IdentEmp
WHERE d.IdentEmp IS NULL;

-- Listar todos os empregados que moram em cidades cujo nome contém “Salvador”.
SELECT * 
FROM empregado
WHERE endereco LIKE '%Salvador%';

-- Apresentar o resultado dos salários dos empregados que trabalham no projeto “Reengenharia” caso fosse dado um aumento de 10%.
SELECT e.Sal * 1.1 as NovoSalario
FROM empregado e
INNER JOIN trabalhando t on e.Ident = t.IdentEmp
INNER JOIN projeto p on t.ProjNum = p.Num
Where p.Nome = 'Reengenharia';

--Qual(is) empregado(s) não tem (têm) superior imediato?
SELECT *
FROM empregado 
WHERE SuperIdent IS NULL

-- Listar todos os locais onde se encontram departamentos da empresa ou onde são realizados projetos.
Select Local
FROM Deploc 
UNION 
SELECT LOCAL
FROM Projeto;

-- Quais os nomes dos empregados que trabalham menos de 20 horas por semana em algum projeto?
SELECT e.nome
FROM empregado e
INNER JOIN trabalhando t on e.Ident = t.IdentEmp
WHERE t.Hrs < 20;