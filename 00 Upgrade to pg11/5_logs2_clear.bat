
@ECHO OFF
SET dbname=lanmon_restored

FOR %%Y IN (2019, 2020) DO (
FOR %%M IN (01 02 03 04 05 06 07 08 09 10 11 12) DO (

psql --username=postgres --dbname=%dbname% --port=5432 -c "TRUNCATE lanmon2.logs2_%%Y_%%M" -q

echo logs2_%%Y_%%M clear
)
)
ECHO ON