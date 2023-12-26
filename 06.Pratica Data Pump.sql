

-- Criação do diretório no SO:

$ mkdir /home/oracle/dpump


-- Criar diretório no database:

$ sqlplus system/senha@orclpdb

SQL> create directory dump_dir as '/home/oracle/dpump';


-- Comando exportação:

$ expdp system/senha@orclpdb dumpfile=expdp_schema_hr.dmp logfile=expdp_schema_hr.log schemas=hr exclude=statistics directory=dump_dir

-- Simulação da perca do schema:

$ sqlplus system/senha@orclpdb

SQL> DROP USER HR CASCADE;

DESC HR.EMPLOYEES

-- Recuperação do schema:

$ impdp system/senha@orclpdb dumpfile=expdp_schema_hr.dmp logfile=impdp_schema_hr.log directory=dump_dir


$ sqlplus system/senha@orclpdb

DESC HR.EMPLOYEES