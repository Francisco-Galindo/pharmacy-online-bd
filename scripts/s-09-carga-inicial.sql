--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script con la carga inicial de registros en la base de datos


prompt Creando directorio carga_datos_dir
connect sys/&p_sys_password@&p_pdb as sysdba

create or replace directory carga_datos_dir as '/unam/bd/pharmacy-online-bd/scripts/carga-de-datos';

grant read, write on directory carga_datos_dir to gs_proy_admin;

!chmod 777 -R &p_root_dir/scripts/carga-de-datos


prompt Conectando como usuario gs_proy_admin
connect gs_proy_admin/gs_proy_admin@&p_pdb

prompt Insertando datos que se crearon directamente
@&p_root_dir/scripts/carga-de-datos/medicamento_y_relacionados.sql

prompt Creando tablas externas

create table centro_operaciones_ext (
  clave                   char(6),
  direccion               varchar2(128),
  latitud                 number(8,6),
  longitud                number(9,6),
  telefono                number(10),
  es_oficina              boolean,
  es_almacen              boolean,
  es_farmacia             boolean
)
organization external (
  type oracle_loader
  default directory carga_datos_dir
  access parameters (
    records delimited by newline
    badfile carga_datos_dir:'centro_operaciones_ext_bad.log'
    logfile carga_datos_dir:'centro_operaciones_ext.log'
    fields terminated by ','
    optionally enclosed by '"'
    lrtrim
    missing field values are null
    (
      clave,
      direccion,
      latitud,
      longitud,
      telefono,
      es_oficina,
      es_almacen,
      es_farmacia
    )
  )
  location ('centro_operaciones.csv')
)
reject limit unlimited;


create table empleado_ext (
  nombre                  varchar2(128),
  ap_paterno              varchar2(128),
  ap_materno              varchar2(128),
  rfc                     varchar2(13),
  fecha_ing               date,
  sueldo_mensual          number(8,2),
  centro_operaciones_id   number(10,0)
)
organization external (
  type oracle_loader
  default directory carga_datos_dir
  access parameters (
    records delimited by newline
    badfile carga_datos_dir:'empleado_ext_bad.log'
    logfile carga_datos_dir:'empleado_ext.log'
    fields terminated by ','
    optionally enclosed by '"'
    lrtrim
    missing field values are null
    (
      nombre,
      ap_paterno,
      ap_materno,
      rfc,
      fecha_ing date mask "yyyy-mm-dd hh24:mi:ss",
      sueldo_mensual,
      centro_operaciones_id
    )
  )
  location ('empleado.csv')
)
reject limit unlimited;


create table oficina_ext (
  centro_operaciones_id   number(10,0),
  telefono_cc             number(10,0),
  nombre                  varchar2(128),
  clave_presupuestal      varchar2(256)
)
organization external (
  type oracle_loader
  default directory carga_datos_dir
  access parameters (
    records delimited by newline
    badfile carga_datos_dir:'oficina_ext_bad.log'
    logfile carga_datos_dir:'oficina_ext.log'
    fields terminated by ','
    optionally enclosed by '"'
    lrtrim
    missing field values are null
    (
      centro_operaciones_id,
      telefono_cc,
      nombre,
      clave_presupuestal
    )
  )
  location ('oficina.csv')
)
reject limit unlimited;


create table almacen_ext (
  centro_operaciones_id   number(10,0),
  tipo_almacen            char(1),
  almacen_contingencia_id number(10,0)
)
organization external (
  type oracle_loader
  default directory carga_datos_dir
  access parameters (
    records delimited by newline
    badfile carga_datos_dir:'almacen_ext_bad.log'
    logfile carga_datos_dir:'almacen_ext.log'
    fields terminated by ','
    optionally enclosed by '"'
    lrtrim
    missing field values are null
    (
      centro_operaciones_id,
      tipo_almacen,
      almacen_contingencia_id
    )
  )
  location ('almacen.csv')
)
reject limit unlimited;

create table farmacia_ext (
  centro_operaciones_id   number(10,0),
  rfc_fiscal              varchar2(13),
  url_web                 varchar2(128),
  gerente_id              number(10,0)
)
organization external (
  type oracle_loader
  default directory carga_datos_dir
  access parameters (
    records delimited by newline
    badfile carga_datos_dir:'farmacia_ext_bad.log'
    logfile carga_datos_dir:'farmacia_ext.log'
    fields terminated by ','
    optionally enclosed by '"'
    lrtrim
    missing field values are null
    (
      centro_operaciones_id,
      rfc_fiscal,
      url_web,
      gerente_id
    )
  )
  location ('farmacia.csv')
);

-------------------------------------------------------------------------------


create table cliente_ext (
  nombre            varchar2(128),
  ap_paterno        varchar2(128),
  ap_materno        varchar2(128),
  email             varchar2(256),
  curp              char(18),
  rfc               char(13),
  hash_pass         char(60),
  telefono          number(10,0),
  direccion_envio   varchar2(256)
)
organization external (
  type oracle_loader
  default directory carga_datos_dir
  access parameters (
    records delimited by newline
    badfile carga_datos_dir:'cliente_ext_bad.log'
    logfile carga_datos_dir:'cliente_ext.log'
    fields terminated by ','
    optionally enclosed by '"'
    lrtrim
    missing field values are null
    (
      nombre,
      ap_paterno,
      ap_materno,
      email,
      curp,
      rfc,
      hash_pass,
      telefono,
      direccion_envio
    )
  )
  location ('cliente.csv')
);


create table tarjeta_credito_ext (
  digitos             number(20,0),
  mes_exp             number(2,0),
  ano_exp             number(2,0),
  cliente_id          number(10,0)
)
organization external (
  type oracle_loader
  default directory carga_datos_dir
  access parameters (
    records delimited by newline
    badfile carga_datos_dir:'tarjeta_credito_ext_bad.log'
    logfile carga_datos_dir:'tarjeta_credito_ext.log'
    fields terminated by ','
    optionally enclosed by '"'
    lrtrim
    missing field values are null
    (
      digitos,
      mes_exp,
      ano_exp,
      cliente_id
    )
  )
  location ('tarjeta_credito.csv')
);


create table status_pedido_ext (
  clave               varchar2(16),
  descripcion         varchar2(128)
)
organization external (
  type oracle_loader
  default directory carga_datos_dir
  access parameters (
    records delimited by newline
    badfile carga_datos_dir:'status_pedido_ext_bad.log'
    logfile carga_datos_dir:'status_pedido_ext.log'
    fields terminated by ','
    optionally enclosed by '"'
    lrtrim
    missing field values are null
    (
      clave, descripcion
    )
  )
  location ('status_pedido.csv')
);


create table historial_pedido_status_ext (
  fecha_status                date,
  status_pedido_id            number(10,0),
  pedido_id                   number(10,0)
)
organization external (
  type oracle_loader
  default directory carga_datos_dir
  access parameters (
    records delimited by newline
    badfile carga_datos_dir:'historial_pedido_status_ext_bad.log'
    logfile carga_datos_dir:'historial_pedido_status_ext.log'
    fields terminated by ','
    optionally enclosed by '"'
    lrtrim
    missing field values are null
    (
      fecha_status date mask "yyyy-mm-dd hh24:mi:ss",
      status_pedido_id,
      pedido_id
    )
  )
  location ('historial_pedido_status.csv')
);


create table pedido_ext (
  folio               char(13),
  fecha               date,
  fecha_status        date,
  importe             number(10,2),
  cliente_id          number(10,0),
  responsable_id      number(10,0),
  status_pedido_id    number(10,0)
)
organization external (
  type oracle_loader
  default directory carga_datos_dir
  access parameters (
    records delimited by newline
    badfile carga_datos_dir:'pedido_ext_bad.log'
    logfile carga_datos_dir:'pedido_ext.log'
    fields terminated by ','
    optionally enclosed by '"'
    lrtrim
    missing field values are null
    (
      folio,
      fecha date mask "yyyy-mm-dd hh24:mi:ss",
      fecha_status date mask "yyyy-mm-dd hh24:mi:ss",
      importe,
      cliente_id,
      responsable_id,
      status_pedido_id
    )
  )
  location ('pedido.csv')
);


create table ubicacion_pedido_ext (
  fecha_ubicacion       date,
  latitud               number(8,6),
  longitud              number(9,6),
  pedido_id             number(10,0)
)
organization external (
  type oracle_loader
  default directory carga_datos_dir
  access parameters (
    records delimited by newline
    badfile carga_datos_dir:'ubicacion_pedido_ext_bad.log'
    logfile carga_datos_dir:'ubicacion_pedido_ext.log'
    fields terminated by ','
    optionally enclosed by '"'
    lrtrim
    missing field values are null
    (
      fecha_ubicacion date mask "yyyy-mm-dd hh24:mi:ss",
      latitud,
      longitud,
      pedido_id
    )
  )
  location ('ubicacion_pedido.csv')
);

create table medicamento_pedido_ext (
  unidades                number(4,0),
  presentacion_id         number(10,0),
  responsable_id          number(10,0),
  pedido_id               number(10,0),
  farmacia_id             number(10,0)
)
organization external (
  type oracle_loader
  default directory carga_datos_dir
  access parameters (
    records delimited by newline
    badfile carga_datos_dir:'medicamento_pedido_ext_bad.log'
    logfile carga_datos_dir:'medicamento_pedido_ext.log'
    fields terminated by ','
    optionally enclosed by '"'
    lrtrim
    missing field values are null
    (
      unidades,
      presentacion_id,
      responsable_id,
      pedido_id,
      farmacia_id
    )
  )
  location ('medicamento_pedido.csv')
);

create table operacion_ext (
  fecha_operacion date,
  tipo_evento     char(1),
  responsable_id  number(10,0),
  almacen_id      number(10,0)
)
organization external (
  type oracle_loader
  default directory carga_datos_dir
  access parameters (
    records delimited by newline
    badfile carga_datos_dir:'operacion_ext_bad.log'
    logfile carga_datos_dir:'operacion_ext.log'
    fields terminated by ','
    optionally enclosed by '"'
    lrtrim
    missing field values are null
    (
      fecha_operacion date mask "yyyy-mm-dd hh24:mi:ss",
      tipo_evento,
      responsable_id,
      almacen_id
    )
  )
  location ('operacion.csv')
);

create table medicamento_operacion_ext (
  unidades                    number(10,0),
  presentacion_id             number(10,0),
  operacion_id                number(10,0)
)
organization external (
  type oracle_loader
  default directory carga_datos_dir
  access parameters (
    records delimited by newline
    badfile carga_datos_dir:'medicamento_operacion_ext_bad.log'
    logfile carga_datos_dir:'medicamento_operacion_ext.log'
    fields terminated by ','
    optionally enclosed by '"'
    lrtrim
    missing field values are null
    (
      unidades,
      presentacion_id,
      operacion_id
    )
  )
  location ('medicamento_operacion.csv')
);

create table inventario_farmacia_ext (
  num_disponibles           number(4,0),
  farmacia_id               number(10,0),
  presentacion_id           number(10,0)
)
organization external (
  type oracle_loader
  default directory carga_datos_dir
  access parameters (
    records delimited by newline
    badfile carga_datos_dir:'inventario_farmacia_ext_bad.log'
    logfile carga_datos_dir:'inventario_farmacia_ext.log'
    fields terminated by ','
    optionally enclosed by '"'
    lrtrim
    missing field values are null
    (
      num_disponibles,
      farmacia_id,
      presentacion_id
    )
  )
  location ('inventario_farmacia.csv')
);



/*
 * Haciendo merge de las tablas temporales con las tablas de trabajo
 */

merge into centro_operaciones a using centro_operaciones_ext b on
  (false)
when not matched then insert
  (a.clave, a.direccion, a.latitud, a.longitud, a.telefono, a.es_oficina,
    a.es_almacen, a.es_farmacia)
  values
  (b.clave, b.direccion, b.latitud, b.longitud, b.telefono, b.es_oficina,
    b.es_almacen, b.es_farmacia);

drop table centro_operaciones_ext;
merge into empleado a using empleado_ext b on
  (false)
when not matched then insert
  (a.nombre, a.ap_paterno, a.ap_materno, a.rfc, a.fecha_ing, a.sueldo_mensual,
    a.centro_operaciones_id)
  values
  (b.nombre, b.ap_paterno, b.ap_materno, b.rfc, b.fecha_ing, b.sueldo_mensual,
    b.centro_operaciones_id);
drop table empleado_ext;

merge into oficina a using oficina_ext b on
  (false)
when not matched then insert
  (a.centro_operaciones_id, a.telefono_cc, a.nombre, a.clave_presupuestal)
  values
  (b.centro_operaciones_id, b.telefono_cc, b.nombre, b.clave_presupuestal);
drop table oficina_ext;

merge into almacen a using almacen_ext b on
  (false)
when not matched then insert
  (a.centro_operaciones_id, a.tipo_almacen, a.almacen_contingencia_id)
  values
  (b.centro_operaciones_id, b.tipo_almacen, b.almacen_contingencia_id);
drop table almacen_ext;

merge into farmacia a using farmacia_ext b on
  (false)
when not matched then insert
  (a.centro_operaciones_id, a.rfc_fiscal, a.url_web, a.gerente_id)
  values
  (b.centro_operaciones_id, b.rfc_fiscal, b.url_web, b.gerente_id);
drop table farmacia_ext;

merge into cliente a using cliente_ext b on
  (false)
when not matched then insert
  (a.nombre, a.ap_paterno, a.ap_materno, a.email, a.curp, a.rfc, a.hash_pass,
    a.telefono, a.direccion_envio)
  values
  (b.nombre, b.ap_paterno, b.ap_materno, b.email, b.curp, b.rfc, b.hash_pass,
    b.telefono, b.direccion_envio);
drop table cliente_ext;

merge into tarjeta_credito a using tarjeta_credito_ext b on
  (false)
when not matched then insert
  (a.digitos, a.mes_exp, a.ano_exp, a.cliente_id)
  values
  (b.digitos, b.mes_exp, b.ano_exp, b.cliente_id);
drop table tarjeta_credito_ext;

merge into status_pedido a using status_pedido_ext b on
  (false)
when not matched then insert
  (a.clave, a.descripcion)
  values
  (b.clave, b.descripcion);
drop table status_pedido_ext;

merge into pedido a using pedido_ext b on
  (false)
when not matched then insert
  (a.folio, a.fecha, a.fecha_status, a.importe, a.cliente_id, a.responsable_id, a.status_pedido_id)
  values
  (b.folio, b.fecha, b.fecha_status, b.importe, b.cliente_id, b.responsable_id, b.status_pedido_id);
drop table pedido_ext;

merge into historial_pedido_status a using historial_pedido_status_ext b on
  (false)
when not matched then insert
  (a.fecha_status, a.status_pedido_id, a.pedido_id)
  values
  (b.fecha_status, b.status_pedido_id, b.pedido_id);
drop table historial_pedido_status_ext;

merge into ubicacion_pedido a using ubicacion_pedido_ext b on
  (false)
when not matched then insert
  (a.fecha_ubicacion, a.latitud, a.longitud, a.pedido_id)
  values
  (b.fecha_ubicacion, b.latitud, b.longitud, b.pedido_id);
drop table ubicacion_pedido_ext;

merge into medicamento_pedido a using medicamento_pedido_ext b on
  (false)
when not matched then insert
  (a.unidades, a.presentacion_id, a.responsable_id, a.pedido_id, a.farmacia_id)
  values
  (b.unidades, b.presentacion_id, b.responsable_id, b.pedido_id, b.farmacia_id);
drop table medicamento_pedido_ext;

merge into operacion a using operacion_ext b on
  (false)
when not matched then insert
  (a.fecha_operacion, a.tipo_evento, a.responsable_id, a.almacen_id)
  values
  (b.fecha_operacion, b.tipo_evento, b.responsable_id, b.almacen_id);
drop table operacion_ext;

merge into medicamento_operacion a using medicamento_operacion_ext b on
  (false)
when not matched then insert
  (a.unidades, a.presentacion_id, a.operacion_id)
  values
  (b.unidades, b.presentacion_id, b.operacion_id);
drop table medicamento_operacion_ext;

merge into inventario_farmacia a using inventario_farmacia_ext b on
  (false)
when not matched then insert
  (a.num_disponibles, a.farmacia_id, a.presentacion_id)
  values
  (b.num_disponibles, b.farmacia_id, b.presentacion_id);
drop table inventario_farmacia_ext;

commit;


set serveroutput on

-- @/unam/bd/pharmacy-online-bd/scripts/carga-de-datos/poblador-de-historial.sql

declare
  cursor cur_pedidos is select * from pedido;

  cursor cur_ultimos_status is
  select
    hps.pedido_id,
    hps.fecha_status,
    hps.status_pedido_id
  from
    historial_pedido_status hps
  join (
    select
      pedido_id,
      max(fecha_status) as fecha_status
    from
      historial_pedido_status hps
    group by
      pedido_id
  ) q1
  on
    q1.pedido_id = hps.pedido_id
  where
    hps.fecha_status = q1.fecha_status;

begin

  -- Agregando el status inicial al historial, con la fecha correcta
  for r in cur_pedidos loop
    insert into historial_pedido_status
      (fecha_status, status_pedido_id, pedido_id)
      values (r.fecha_status, r.status_pedido_id, r.pedido_id);
  end loop;

  -- El status y fecha_status de los pedidos se pone con el valor más nuevo del
  -- historial
  for r in cur_ultimos_status loop
    update pedido
      set fecha_status = r.fecha_status, status_pedido_id = r.status_pedido_id
      where pedido_id = r.pedido_id;
  end loop;
end;
/

commit;
