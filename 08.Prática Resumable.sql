

-- Verificar parâmetro RESUMABLE_TIMEOUT:

ALTER SESSION SET CONTAINER=ORCLPDB;
SHOW PARAMETER RESUMABLE


-- Criação de tablespace teste:

CREATE TABLESPACE dbaocm DATAFILE SIZE 1M;


-- Criação de usuário teste:

CREATE USER dbaocm IDENTIFIED BY senha DEFAULT TABLESPACE dbaocm;

-- Associando roles para o usuário:

GRANT CONNECT, RESOURCE, DBA TO DBAOCM;

-- Dando quota ilimitada para o usuário na tablespace:

ALTER USER DBAOCM QUOTA UNLIMITED ON DBAOCM;


-- Criação de tabela teste:

CONN dbaocm/senha@orclpdb

CREATE TABLE TESTE AS SELECT * FROM DBA_OBJECTS;

INSERT INTO TESTE SELECT * FROM DBA_OBJECTS;


-- Alterar o parâmetro, em outra aba do Moba:

CONN sys/senha@orclpdb as sysdba

ALTER SYSTEM SET RESUMABLE_TIMEOUT=3600;

-- Ativar o resumable space allocation:

ALTER SYSTEM ENABLE RESUMABLE;


-- Verificando informações sobre a suspensão:

SET LINES 300
SELECT SID, EVENT, SECONDS_IN_WAIT, STATE FROM V$SESSION_WAIT WHERE EVENT LIKE '%statement suspended%';

COL SQL_TEXT FOR A50
COL NAME FOR A50
COL ERROR_MSG FOR A80
SELECT SESSION_ID, STATUS, NAME, SQL_TEXT, ERROR_MSG FROM DBA_RESUMABLE WHERE SESSION_ID=[SID];


-- Acompanhar o alert log, em uma nova aba:

tail -f $ORACLE_BASE/diag/rdbms/orcl/orcl/trace/alert_orcl.log


-- Resolvendo o problema do comando, adicionando data file na tablespace:

ALTER TABLESPACE DBAOCM ADD DATAFILE SIZE 20M;


-- Resolvendo o problema do comando, redimensionando o tamanho do datafile:

SELECT FILE_NAME FROM DBA_DATA_FILES WHERE TABLESPACE_NAME='DBAOCM';

ALTER DATABASE DATAFILE '[CAMINHO_DO_DATA_FILE]' RESIZE 20M;

