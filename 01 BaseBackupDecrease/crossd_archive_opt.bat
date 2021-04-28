ECHO OFF
setlocal
SET dbname=lanmon_restored
SET hostname=192.168.106.53

SET BACKUP_DIR=E:\LM\BaseBackups\
SET dt=%DATE%
SET yyyy=%dt:~6,4%
SET mm=%dt:~3,2%
SET dd=%dt:~0,2%

SET filename=F:\LM\crossd_nonarch_tables.tmp
SET psqlfullpath="C:\Program files\Postgresql\11\bin\psql" 
SET sqlcmd="SELECT REPLACE(tbl_filepath, '/', '\' ) FROM crossd_arch_tables WHERE tbl_filepath=pg_relation_filepath(tbl_name) AND tbl_size=pg_relation_size(tbl_name)"
%psqlfullpath% --username=postgres --dbname=%dbname% --host=%hostname% --port=5432 --output=%filename% -t --command=%sqlcmd%



SET BACKUP_NAME=%BACKUP_DIR%%yy%_%mm%_%dd%

FOR /F %%A IN (%filename%) DO (
ECHO %%A
ECHO move %BACKUP_NAME%\%%A* %BACKUP_DIR%arch_tables\%yyyy%_%mm%_%dd%\
)
