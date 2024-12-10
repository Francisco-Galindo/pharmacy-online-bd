--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script para la creación de tablas externas

/*
Este caso se basa en la lectura de un archivo de texto que contiene una lista
de medicamentos que son recibidos en un almacén.

Por así decirlo, es una hoja que se le otorga a un empleado del almacén al
momento de recibir un cargamento de medicamentos para almacenarse

Se desea que, desde algún equipo de cómputo el almacén, puedan consultarse
estos datos utilizando la miama interfaz que ya utilizan para interactuar con
la base de datos que estamos desarrollando.

La existencia de esta tabla externa es útil porque le permite a los empleados
consultar fácilmente los datos del cargamento recibido sin tener todavía que
guardarlo en la base.
 */

prompt Creando directorio cargamento_dir
connect sys/&p_sys_password@&p_pdb as sysdba
create or replace directory cargamento_dir as '/unam/bd/pharmacy-online-bd/externas';

!chmod 777 -R &p_root_dir/externas

grant read, write on directory cargamento_dir to gs_proy_admin;


prompt Conectando como usuario gs_proy_admin para crear la tabla externa
connect gs_proy_admin/gs_proy_admin@&p_pdb

prompt Creando tabla externa
create table cargamento_ext (
  unidades              number(10,0),
  cantidad_presentacion number(10,0),
  unidad_presentacion   varchar2(16),
  precio                number(8,2),
  medicamento_desc      varchar2(128),
  medicamento_nombre    varchar2(128),
  sustancia_activa      varchar2(128)
)
organization external (
  type oracle_loader
  default directory cargamento_dir
  access parameters (
    records delimited by newline
    badfile cargamento_dir:'cargamento_ext_bad.log'
    logfile cargamento_dir:'cargamento_ext.log'
    fields terminated by ','
    optionally enclosed by '"'
    lrtrim
    missing field values are null
    (
      unidades,
      cantidad_presentacion,
      unidad_presentacion,
      precio,
      medicamento_nombre,
      medicamento_desc,
      sustancia_activa
    )
  )
  location ('cargamento_ext.csv')
)
reject limit unlimited;
