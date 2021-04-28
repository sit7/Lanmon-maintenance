@ECHO OFF

SET dbname = archives_restored

setlocal enabledelayedexpansion
echo !time!
echo CREATE data_new
psql --username=postgres --dbname=%dbname% --port=5432 -c "CREATE TABLE data_new (dt timestamp without time zone NOT NULL , rectypeid smallint NOT NULL , devid character varying(50) NOT NULL , paramid smallint NOT NULL , val double precision, ts timestamp without time zone DEFAULT ('now'::text)::timestamp without time zone);" -q
echo !time!
echo INSERT INTO data_new
psql --username=postgres --dbname=%dbname% --port=5432 -c "INSERT into data_new select * from public.data WHERE dt>='2020/01/01' on conflict do nothing;" -q
echo !time!
echo RENAME data TO data_old
psql --username=postgres --dbname=%dbname% --port=5432 -c "ALTER TABLE data RENAME TO data_old;" -q
echo !time!
echo RENAME PK
psql --username=postgres --dbname=%dbname% --port=5432 -c "ALTER TABLE public.data_old RENAME CONSTRAINT pk_data TO pk_data_old;" -q
echo !time!
echo RENAME data_new TO data
psql --username=postgres --dbname=%dbname% --port=5432 -c "ALTER TABLE data_new RENAME TO data;" -q
echo !time!
echo ADD PK
psql --username=postgres --dbname=%dbname% --port=5432 -c "ALTER TABLE public.data ADD CONSTRAINT pk_data PRIMARY KEY (dt, rectypeid, devid, paramid);" -q
echo !time!


