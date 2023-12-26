

-- Criar o diretório para external tables no sistema operacional:

$ mkdir /home/oracle/external

-- Criar o objeto diretório dentro do pdb:

$ sqlplus sys/senha@orclpdb as sysdba

SQL> CREATE OR REPLACE DIRECTORY external as '/home/oracle/external';


-- Dar as permissões no diretório para o usuário hr:

SQL> GRANT READ, WRITE ON DIRECTORY sys.external TO hr;


-- Criar external table como usuário hr:

SQL> conn hr/hr@orclpdb;

CREATE TABLE employees_xt ORGANIZATION EXTERNAL(
TYPE ORACLE_DATAPUMP
DEFAULT DIRECTORY external
LOCATION ('emp_xt.dmp')
) AS SELECT * FROM EMPLOYEES;


-- Consultar tabela:

SQL> SELECT * FROM employees_xt;

-- Tentar executar DML:

DELETE FROM employees_xt;

-- Criando outra external table com base no dumpfile:

CREATE TABLE employees_xt2(
EMPLOYEE_ID NUMBER(6),
FIRST_NAME VARCHAR2(20),
LAST_NAME VARCHAR2(25),
EMAIL VARCHAR2(25),
PHONE_NUMBER VARCHAR2(20),
HIRE_DATE DATE,
JOB_ID VARCHAR2(10),
SALARY NUMBER(8,2),
COMMISSION_PCT NUMBER(2,2),
MANAGER_ID NUMBER(6),
DEPARTMENT_ID NUMBER(4)
) ORGANIZATION EXTERNAL(
TYPE ORACLE_DATAPUMP
DEFAULT DIRECTORY external
ACCESS PARAMETERS (COMPRESSION ENABLED)
LOCATION('emp_xt.dmp')
);

-- Verificando a tabela:

select * from employees_xt2;


-- É possível utilizar um dump file de um data pump para uma external table?

$ expdp system/senha@orclpdb dumpfile=expdp_emp.dmp logfile=expdp_emp.log tables=hr.employees directory=external

-- Criar tabela:

CREATE TABLE employees_xt3(
EMPLOYEE_ID NUMBER(6),
FIRST_NAME VARCHAR2(20),
LAST_NAME VARCHAR2(25),
EMAIL VARCHAR2(25),
PHONE_NUMBER VARCHAR2(20),
HIRE_DATE DATE,
JOB_ID VARCHAR2(10),
SALARY NUMBER(8,2),
COMMISSION_PCT NUMBER(2,2),
MANAGER_ID NUMBER(6),
DEPARTMENT_ID NUMBER(4)
) ORGANIZATION EXTERNAL(
TYPE ORACLE_DATAPUMP
DEFAULT DIRECTORY external
LOCATION('expdp_emp.dmp')
);

-- Verificar tabela:

select * from employees_xt3;

-- Criando external table a partir de arquivo CSV:

-- criar arquivo events.csv

vi /home/oracle/external

Winter Games,10-JAN-2010,10,
Hockey Tournament,18-MAR-2009,3,
Baseball Expo,28-APR-2009,2,
International Football Meeting,2-MAY-2009,14,
Track and Field Finale,12-MAY-2010,3,
Mid-summer Swim Meet,5-JUL-2010,4,
Rugby Kickoff,28-SEP-2009,6,


CREATE TABLE events_xt(
event varchar2(30),
start_date date,
lenght number)
ORGANIZATION EXTERNAL
(TYPE ORACLE_LOADER
DEFAULT DIRECTORY external
ACCESS PARAMETERS (FIELDS date_format date mask "mm/dd/yyyy")
LOCATION('events.csv'));

-- Verificando tabela:

select * from events_xt;
