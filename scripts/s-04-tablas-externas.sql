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
guardarlo en la base, adicionalmente.
 */

prompt Creando directorio cargamento_dir
connect sys/system1@fgmbd_s1 as sysdba
create or replace directory cargamento_dir as '/unam/bd/proyecto-final/externas';

grant read, write on directory cargamento_dir to gs_proy_admin;


prompt Conectando como usuario gs_proy_admin para crear la tabla externa
connect gs_proy_admin/gs_proy_admin@fgmbd_s1

prompt Creando tabla externa
create table cargamento_ext (
  num_producto    number(10,0),
  nombre          number(10,0),
  cantidad        number(10,0)
)
organization external (
  type oracle_loader
  default directory tema07_dir
  access parameters (
    records delimited by newline
    badfile cargamento_dir:'cargamento_ext_bad.log'
    logfile cargamento_dir:'cargamento_ext.log'
    fields terminated by ','
    lrtrim
    missing field values are null
    (
      num_producto, nombre, cantidad
    )
  )
  location ('cargamento_ext.csv')
)
reject limit unlimited;
