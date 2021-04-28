@REM команды, которые начинаются с @ не выводятся сами, только результаты их исполнения
@echo off

SET dbname=lanmon_restored

@REM setlocal enabledelayedexpansion и !time! а не %time% нужно, чтобы time рассчитывался во время исполнения а не как результат прекомпиляции
setlocal enabledelayedexpansion
echo dump begining time - !time!

@REM %~dp0 - отдает путь размещения bat-файла
IF NOT EXIST %~dp0\backups\ mkdir %~dp0\backups\
FOR %%Y IN (2019 2020) DO (
FOR %%M IN (01 02 03 04 05 06 07 08 09 10 11 12) DO (
@REM вариант вывода вместо echo чтобы не было перехода на следующую строку
<nul set /p strTemp=dump public.logs_%%Y_%%M --
@REM echo dump public.logs_%%Y_%%M
pg_dump.exe --file %~dp0\backups\logs_%%Y_%%M.backup --host localhost --port 5432 --username postgres --no-password --format=c --blobs --compress "1" --table "public.logs_%%Y_%%M" %dbname%
echo !time!
)
)
echo on

 






