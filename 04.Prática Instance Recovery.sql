


-- abrir 3 sessoes SSH

-- na sessao 1

. oraenv
orcl

cd $ORACLE_BASE/diag/rdbms/orcl/orcl/trace

tail -f alert_orcl.log

-- na sessão 2
-- no sqlplus:

CREATE TABLE clientes (
    cliente_id NUMBER PRIMARY KEY,
    nome VARCHAR2(50),
    email VARCHAR2(50)
);

INSERT INTO clientes (cliente_id, nome, email) VALUES (1, 'Maria Silva', 'maria.silva@example.com');
INSERT INTO clientes (cliente_id, nome, email) VALUES (2, 'Joao Costa', 'joao.costa@example.com');
INSERT INTO clientes (cliente_id, nome, email) VALUES (3, 'Paulo Roberto', 'paulo.roberto@example.com');
INSERT INTO clientes (cliente_id, nome, email) VALUES (4, 'Juliana Santos', 'juliana.santos@example.com');

COL NAME FOR A50
SELECT XID, START_TIME, STATUS, NAME FROM V$TRANSACTION;

-- verficando o SCN atual do banco
SELECT CURRENT_SCN FROM V$DATABASE;

-- forçando um checkpoint: todos os dados do database buffer cache serão escritos nos data files, mesmo que a transação não tenha sido confirmada
ALTER SYSTEM CHECKPOINT;

-- verficando o SCN atual do banco
SELECT CURRENT_SCN FROM V$DATABASE;

COL NAME FOR A50
SELECT XID, START_TIME, STATUS, NAME FROM V$TRANSACTION;

COMMIT;

COL NAME FOR A50
SELECT XID, START_TIME, STATUS, NAME FROM V$TRANSACTION;

INSERT INTO clientes (cliente_id, nome, email) VALUES (5, 'Lucas Oliveira', 'lucas.oliveira@example.com');
INSERT INTO clientes (cliente_id, nome, email) VALUES (6, 'Ana Carolina', 'ana.carolina@example.com');
INSERT INTO clientes (cliente_id, nome, email) VALUES (7, 'Pedro Fernandes', 'pedro.fernandes@example.com');

SET LINES 400
SELECT * FROM CLIENTES;

COL NAME FOR A50
SELECT XID, START_TIME, STATUS, NAME FROM V$TRANSACTION;

-- na sessão 3, no sqlplus:

SET LINES 400
SELECT * FROM CLIENTES;

INSERT INTO clientes (cliente_id, nome, email) VALUES (8, 'Fernanda Souza', 'fernanda.souza@example.com');
COMMIT;

SET LINES 400
SELECT * FROM CLIENTES;

shutdown abort;

-- iniciar o startup mount

startup mount

-- o instance recovery irá iniciar quando tentarmos alterar o status do banco para open:

alter database open;

-- verificar no alert log o processo de recuperação