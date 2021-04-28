Идея: уменьшить размер полного бэкапа сервера  за счет "неизменяемых" архивных таблиц


данные архивных таблиц:

CREATE TABLE public.crossd_arch_tables (
	tbl_name varchar(50) NOT NULL,
	tbl_filepath varchar(150) NULL,
	tbl_size int4 NULL,
	CONSTRAINT crossd_arch_tables_pkey PRIMARY KEY (tbl_name)
);

Первоначальное наполнение таблицы:
	
	insert into crossd_arch_tables(tbl_name, tbl_filepath, tbl_size)
	SELECT table_name,  pg_relation_filepath(table_name), pg_relation_size(table_name) FROM information_schema.tables 
	WHERE table_name like 'logs2_2020%' OR table_name like 'logs_2020%'

обновление таблицы

	UPDATE crossd_arch_tables SET tbl_filepath = pg_relation_filepath(tbl_name), tbl_size = pg_relation_size(tbl_name)

список таблиц, по которым были изменения:

	SELECT tbl_name, tbl_filepath as old_path, tbl_size as old_size, pg_relation_filepath(tbl_name) as new_path, pg_relation_size(tbl_name) as new_size
	FROM crossd_arch_tables
	WHERE tbl_filepath<>pg_relation_filepath(tbl_name) OR tbl_size<>pg_relation_size(tbl_name)

результат - таблицы, по которым не было изменений могут быть убраны из резервной копии (при условии, что хранится копия, где они есть, либо
организовано отдельное хранение подобных таблиц



