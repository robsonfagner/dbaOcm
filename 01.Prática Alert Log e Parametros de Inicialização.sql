

$ . oraenv
orcl

$ env | grep ORA

$ cd $ORACLE_BASE/diag/rdbms/orcl/orcl/trace

$ tail -f alert_orcl.log

-- em uma nova sessao:

$ sqlplus / as sysdba

$ env

$ . oraenv
orcl

$ env

$ ps aux | grep smon

SQL> startup -- depois do comando, analisar alert log

SQL> SELECT STATUS FROM V$INSTANCE;

SQL> SELECT OPEN_MODE FROM V$DATABASE;

SQL> exit

$ ps aux | grep smon


$ sqlplus / as sysdba

SQL> shutdown immediate

SQL> exit

$ ps aux | grep smon

-- alterando parametros 

SQL> create pfile='/home/oracle/my_pfile.ora' from spfile;

SQL> SELECT ISINSTANCE_MODIFIABLE FROM V$PARAMETER WHERE NAME='processes';

SQL> SHOW PARAMETER processes

SQL> ALTER SYSTEM SET processes=500;

SQL> ALTER SYSTEM SET processes=500 SCOPE=BOTH;

SQL> ALTER SYSTEM SET processes=500 SCOPE=MEMORY;

SQL> ALTER SYSTEM SET processes=500 SCOPE=SPFILE;

SQL> SELECT ISINSTANCE_MODIFIABLE FROM V$PARAMETER WHERE NAME='db_cache_size';

SQL> SHOW PARAMETER db_cache_size

SQL> ALTER SYSTEM SET db_cache_size=100M SCOPE=MEMORY;

SQL> SHOW PARAMETER db_cache_size

SQL> ALTER SYSTEM RESET db_cache_size SCOPE=MEMORY;

SQL> SHOW PARAMETER db_cache_size

-- Inicializar instância pelo pfile:

SQL> SHUTDOWN IMMEDIATE

SQL> STARTUP PFILE='/home/oracle/my_pfile.ora'

SQL> ALTER SYSTEM SET processes=500 SCOPE=SPFILE;

SQL> ALTER SYSTEM SET processes=500 SCOPE=BOTH;

SQL> ALTER SYSTEM SET processes=500 SCOPE=MEMORY;

SQL> SHOW PARAMETER db_cache_size

SQL> ALTER SYSTEM SET db_cache_size=100M SCOPE=MEMORY;

SQL> SHOW PARAMETER db_cache_size

SQL> SHUTDOWN IMMEDIATE

SQL> STARTUP

SQL> SHOW PARAMETER db_cache_size
