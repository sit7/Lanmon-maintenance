-- при общении с разработчиками выяснилось, что систему можно оставить в рабочем состоянии
-- даже удалив все данные из таблицы data, при условии замены одной функции системы

--Старый вариант:

CREATE OR REPLACE FUNCTION public.get_time_of_last_record(
    integer,
    character varying)
  RETURNS SETOF timestamp without time zone AS
'SELECT dt FROM data WHERE rectypeid=$1 and devid=$2 ORDER BY dt DESC LIMIT 1'
  LANGUAGE sql STABLE STRICT
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_time_of_last_record(integer, character varying) OWNER TO postgres;

--Новый вариант:


CREATE OR REPLACE FUNCTION public.get_time_of_last_record(
    integer,
    character varying)
  RETURNS SETOF timestamp without time zone AS
'SELECT dt FROM archrecs WHERE rectypeid=$1 and devid=$2 ORDER BY dt DESC LIMIT 1'
  LANGUAGE sql STABLE STRICT
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_time_of_last_record(integer, character varying) OWNER TO postgres;

-- после замены функции можно сделать TRUNCATE таблицы data
 