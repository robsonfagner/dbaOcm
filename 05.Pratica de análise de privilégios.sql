
sqlplus / as sysdba

ALTER SESSION SET CONTAINER=orclpdb;

CREATE ROLE role_a;
CREATE ROLE role_b;

GRANT CREATE TABLE TO role_a;
GRANT CREATE SESSION TO role_b;
GRANT CREATE SEQUENCE TO role_b;
GRANT role_b TO role_a;

CREATE USER role_tester IDENTIFIED BY senha QUOTA 5M ON USERS;
GRANT role_a TO role_tester;

BEGIN
 DBMS_PRIVILEGE_CAPTURE.CREATE_CAPTURE(
  name          => 'role_capture1',
  type          => DBMS_PRIVILEGE_CAPTURE.G_ROLE,
  roles         => role_name_list('role_a', 'role_b'));
END;
/

EXEC DBMS_PRIVILEGE_CAPTURE.ENABLE_CAPTURE ('role_capture1');

conn role_tester/senha@orclpdb

CREATE TABLE role_table(
    id NUMBER
);

conn sys/senha@orclpdb as sysdba

EXEC DBMS_PRIVILEGE_CAPTURE.DISABLE_CAPTURE ('role_capture1');

EXEC DBMS_PRIVILEGE_CAPTURE.GENERATE_RESULT ('role_capture1');

-- SALVA NAS VIEWS DBA_USED_* 

SET LINES 400
COL USERNAME FOR A12
COL USED_ROLE FOR A10
COL SYS_PRIV FOR A20
COL PATH FOR A50
SELECT USERNAME, USED_ROLE, SYS_PRIV FROM DBA_USED_SYSPRIVS;

COL ROLENAME FOR A10
COL SYS_PRIV FOR A20
SELECT ROLENAME, SYS_PRIV FROM DBA_UNUSED_SYSPRIVS;

SET LINES 400
COL USERNAME FOR A12
COL USED_ROLE FOR A10
COL SYS_PRIV FOR A20
COL PATH FOR A50
SELECT USERNAME, USED_ROLE, SYS_PRIV, PATH FROM DBA_USED_SYSPRIVS_PATH;