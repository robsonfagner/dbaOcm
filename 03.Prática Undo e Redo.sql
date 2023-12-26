
-- verificando parametros de undo

SHOW PARAMETER UNDO


-- verificando retenção ótima de undo

select to_char(begin_time, 'DD-MON-RR HH24:MI') begin_time,
to_char(end_time, 'DD-MON-RR HH24:MI') end_time, tuned_undoretention
from v$undostat order by end_time;

-- alterando retenção

ALTER SYSTEM SET UNDO_RETENTION = 2400;

-- verificando retenção garantida

SELECT TABLESPACE_NAME, RETENTION FROM DBA_TABLESPACES WHERE CONTENTS='UNDO';

-- configurando retenção garantida

ALTER TABLESPACE UNDOTBS1 RETENTION GUARANTEE;

-- criando nova tablespace de undo com retenção garantida

CREATE UNDO TABLESPACE UNDOTBS2 RETENTION GUARANTEE;

-- definindo a nova tbs como padrão:

ALTER SYSTEM SET UNDO_TABLESPACE = 'UNDOTBS2';

show parameter undo



-- REDO

-- alterando para o modo archive log

-- verificando modo atual

SELECT LOG_MODE FROM V$DATABASE;

ARCHIVE LOG LIST;

-- alterando padrão do nome de archive

SELECT ISINSTANCE_MODIFIABLE FROM V$PARAMETER WHERE NAME='log_archive_format';

ALTER SYSTEM SET log_archive_format='ARCH_%t_%S_%r.arc' SCOPE=SPFILE;

-- BAIXAR O BANCO

SHUTDOWN IMMEDIATE

-- subir em estado mount 

STARTUP MOUNT

-- ativar archivelog mode

ALTER DATABASE ARCHIVELOG;

-- abrir a base

ALTER DATABASE OPEN;

-- validando

ARCHIVE LOG LIST;

SELECT log_mode FROM v$database;

-- alterando local de arquivamento

!mkdir /u02/myarchive

ALTER SYSTEM SET LOG_ARCHIVE_DEST_1 = 'LOCATION=USE_DB_RECOVERY_FILE_DEST';
ALTER SYSTEM SET LOG_ARCHIVE_DEST_2 = 'LOCATION=/u02/myarchive'; 

-- validando

ARCHIVE LOG LIST;

SHOW PARAMETER LOG_ARCHIVE_DEST_

ALTER SYSTEM SWITCH LOGFILE;

set lines 200 pages 10000
select thread#, group#, sequence#, archived, status from v$log;

!ls /u02/myarchive

ALTER SYSTEM SWITCH LOGFILE;

-- verificando os grupos existentes

set lines 200 pages 10000
select thread#, group#, sequence#, archived, status, bytes/1024/1024 "Tamanho MB" from v$log;

-- verificando membros de redo

set lines window pages 10000
col member format a75
SELECT GROUP#, MEMBER FROM V$LOGFILE;

-- verificar omf

SHOW PARAMETER db_create_online_log_dest_

-- adicionamos novos grupos

ALTER DATABASE ADD LOGFILE GROUP 4 SIZE 300M;
ALTER DATABASE ADD LOGFILE GROUP 5 SIZE 300M;
ALTER DATABASE ADD LOGFILE GROUP 6 SIZE 300M;
ALTER DATABASE ADD LOGFILE GROUP 7 SIZE 300M;

-- verificando os grupos existentes

set lines 200 pages 10000
select thread#, group#, sequence#, archived, status, bytes/1024/1024 "Tamanho MB" from v$log;

-- verificando membros de redo

set lines window pages 10000
col member format a75
SELECT GROUP#, MEMBER FROM V$LOGFILE;

-- trocamos os redos até que um novo grupo esteja como current

ALTER SYSTEM SWITCH LOGFILE;

-- dropamos os grupos antigos

ALTER DATABASE DROP LOGFILE GROUP 1;
ALTER DATABASE DROP LOGFILE GROUP 2;
ALTER DATABASE DROP LOGFILE GROUP 3;

-- verificando os grupos existentes

set lines 200 pages 10000
select thread#, group#, sequence#, archived, status, bytes/1024/1024 "Tamanho MB" from v$log;

-- verificando membros de redo

set lines window pages 10000
col member format a75
SELECT GROUP#, MEMBER FROM V$LOGFILE;