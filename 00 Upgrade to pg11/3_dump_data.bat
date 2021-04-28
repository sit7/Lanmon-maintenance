@REM команды, которые начинаются с @ не выводятся сами, только результаты их исполнения
@echo off

SET dbname=archives_restored

@REM setlocal enabledelayedexpansion и !time! а не %time% нужно, чтобы time рассчитывался во время исполнения а не как результат прекомпиляции
setlocal enabledelayedexpansion
echo dump begining time - !time!
echo.
@REM %~dp0 - отдает путь размещения bat-файла
IF NOT EXIST %~dp0\backups\ mkdir %~dp0\backups\
setlocal
FOR /L %%A IN (2009,1,2020) DO (

SET /a "B=%%A+1"

<nul set /p strTemp=run psql --file %~dp0\data%%A.sql -- 
REM надо разобраться с переносами в bat-никах
psql --username=postgres --dbname=%dbname% --port=5432 -c "CREATE TABLE data_%%A (dt timestamp without time zone NOT NULL , rectypeid smallint NOT NULL , devid character varying(50) NOT NULL , paramid smallint NOT NULL , val double precision, ts timestamp without time zone DEFAULT ('now'::text)::timestamp without time zone);" -q
call psql --username=postgres --dbname=%dbname% --port=5432 -c "INSERT into data_%%A select * from public.data WHERE dt>='%%A/01/01' AND dt<'%%B%%/01/01' on conflict do nothing;" -q
pg_dump.exe --file %~dp0\backups\data_%%A.backup --host localhost --port 5432 --username postgres --no-password --format=c --blobs --compress 1 --table public.data_%%A %dbname%
psql --username=postgres --dbname=%dbname% --port=5432 -c "DROP TABLE data_%%A" -q
echo !time!
echo.
)
