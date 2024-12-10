--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script para la creación de tablas temporales

prompt Creando directorio carga_datos_tabla_temporal_dir
connect sys/&p_sys_password@&p_pdb as sysdba

create or replace directory carga_datos_tabla_temporal_dir as '/unam/bd/pharmacy-online-bd/scripts/carga-de-datos';

grant read, write on directory carga_datos_tabla_temporal_dir to gs_proy_admin;

!chmod 777 -R &p_root_dir/scripts/carga-de-datos

prompt Conectando como usuario gs_proy_admin
connect gs_proy_admin/gs_proy_admin@&p_pdb

prompt Creando tabla temporal

create global temporary table centro_operaciones_desnormalizado(
  centro_operaciones_id   number(10,0),
  clave                   varchar2(6),
  direccion               varchar2(128),
  latitud                 number(8,6),
  longitud                number(9,6),
  telefono                number(10),
  es_oficina              boolean,
  es_almacen              boolean,
  es_farmacia             boolean,
  telefono_cc             number(10,0),
  nombre_oficina          varchar2(128),
  clave_presupuestal      varchar2(256),
  tipo_almacen            char(1),
  documento               blob,
  almacen_contingencia_id number(10,0),
  rfc_fiscal              varchar2(13),
  url_web                 varchar2(128),
  gerente_id              number(10,0)
) on commit preserve rows;

/*
 * Creando tabla externa como auxiliar para cargar los datos
 */

 prompt Creando tabla externa auxiliar

 create table centro_operaciones_desnormalizado_ext (
  centro_operaciones_id   number(10,0),
  clave                   varchar2(6),
  direccion               varchar2(128),
  latitud                 number(8,6),
  longitud                number(9,6),
  telefono                number(10),
  es_oficina              boolean,
  es_almacen              boolean,
  es_farmacia             boolean,
  telefono_cc             number(10,0),
  nombre_oficina          varchar2(128),
  clave_presupuestal      varchar2(256),
  tipo_almacen            char(1),
  documento               blob,
  almacen_contingencia_id number(10,0),
  rfc_fiscal              varchar2(13),
  url_web                 varchar2(128),
  gerente_id              number(10,0)
 )
 organization external (
  type oracle_loader
  default directory carga_datos_tabla_temporal_dir
  access parameters (
    records delimited by newline
    badfile carga_datos_dir:'centro_operacion_desnormalizado_ext_bad.log'
    logfile carga_datos_dir:'centro_operacion_desnormalizado_ext.log'
    fields terminated by ','
    optionally enclosed by '"'
    lrtrim
    missing field values are null
    (
      centro_operaciones_id,
      clave,
      direccion,
      latitud,
      longitud,
      telefono,
      es_oficina,
      es_almacen,
      es_farmacia,
      telefono_cc,
      nombre_oficina,
      clave_presupuestal,
      tipo_almacen,
      documento,
      almacen_contingencia_id,
      rfc_fiscal,
      url_web,
      gerente_id
    )
  )
  location ('jerarquia_desnormalizada.csv')
 ) 
 reject limit unlimited;

/*
 * Hacemos merge de la tabla temporal con la externa
 */

 merge into centro_operaciones_desnormalizado a using centro_operaciones_desnormalizado_ext b on
  (false)
 when not matched then insert
  (a.clave, a.direccion, a.latitud, a.longitud, a.telefono, a.es_oficina,
    a.es_almacen, a.es_farmacia, a.telefono_cc, a.nombre_oficina,
    a.clave_presupuestal, a.tipo_almacen, a.documento, a.almacen_contingencia_id,
    a.rfc_fiscal, a.url_web, a.gerente_id)
  values
  (b.clave, b.direccion, b.latitud, b.longitud, b.telefono, b.es_oficina,
    b.es_almacen, b.es_farmacia, b.telefono_cc, b.nombre_oficina,
    b.clave_presupuestal, b.tipo_almacen, b.documento, b.almacen_contingencia_id,
    b.rfc_fiscal, b.url_web, b.gerente_id);
 drop table centro_operaciones_desnormalizado_ext;

/*
 * Creamos bloques anónimos para insertar los datos de la tabla
 * centro_operaciones_desnormalizado en sus tablas correspondientes
 * según la jerarquía
 */

 set serveroutput on;

 declare 

  mensaje_error varchar2(4000);

 begin 

    insert into centro_operaciones a (a.clave, a.direccion, a.latitud, a.longitud, a.telefono,
     a.es_oficina, a.es_almacen, a.es_farmacia)
      select b.clave, b.direccion, b.latitud, b.longitud, b.telefono, b.es_oficina,
      b.es_almacen, b.es_farmacia
        from centro_operaciones_desnormalizado b;

    commit;

  exception
     
     when others then
        mensaje_error := SQLERRM;

        dbms_output.put_line(
          mensaje_error || '. Error al insertar datos desde la tabla temporal');

  end;
  /   

 declare 

  mensaje_error varchar2(4000);

 begin 

    insert into oficina a (a.centro_operaciones_id, a.telefono_cc, a.nombre, 
      a.clave_presupuestal)
      select  
        b.centro_operaciones_id, b.telefono_cc, b.nombre, b.clave_presupuestal
          from
            centro_operaciones_desnormalizado b
          where 
            b.es_oficina = true
    ;

    commit;

  exception
     
     when others then
        mensaje_error := SQLERRM;

        dbms_output.put_line(
          mensaje_error || '. Error al insertar datos desde la tabla temporal');

  end;
  /   

 declare 

  mensaje_error varchar2(4000);

 begin 

    insert into almacen a (a.centro_operaciones_id, a.tipo_almacen, 
    a.almacen_contingencia_id)
      select  
        b.centro_operaciones_id, b.tipo_almacen, b.almacen_contingencia_id
          from
            centro_operaciones_desnormalizado b
          where 
            b.es_almacen = true
    ;

    commit;

  exception
     
     when others then
        mensaje_error := SQLERRM;

        dbms_output.put_line(
          mensaje_error || '. Error al insertar datos desde la tabla temporal');

  end;
  /   

 declare 

  mensaje_error varchar2(4000);

 begin 

    insert into farmacia a (a.centro_operaciones_id, a.rfc_fiscal, a.url_web, 
    a.gerente_id)
      select  
        b.centro_operaciones_id, b.rfc_fiscal, b.url_web, b.gerente_id
          from
            centro_operaciones_desnormalizado b
          where 
            b.es_farmacia = true
    ;

    commit;

  exception
     
     when others then
        mensaje_error := SQLERRM;

        dbms_output.put_line(
          mensaje_error || '. Error al insertar datos desde la tabla temporal');

  end;
  /     

  
