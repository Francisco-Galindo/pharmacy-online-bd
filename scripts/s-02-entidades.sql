--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script con el código DDL para crear tablas del caso de estudio.

connect gs_proy_admin/gs_proy_admin@&p_pdb

-- Centro de operaciones junto a sus subtipos y empleados

create table centro_operaciones (
  centro_operaciones_id   number(10,0)  default on null centro_operaciones_seq.nextval,
  clave                   char(6)       not null,
  direccion               varchar2(128) not null,
  latitud                 number(8,6)   not null,
  longitud                number(9,6)   not null,
  telefono                number(10)    not null,
  es_oficina              boolean       not null,
  es_almacen              boolean       not null,
  es_farmacia             boolean       not null,
  constraint centro_operaciones_pk  primary key(centro_operaciones_id),
  -- constraint centro_operaciones_clave_uk  unique(clave),
  -- constraint centro_operaciones_telefono_uk  unique(telefono),
  -- Las oficinas no pueden ser otro tipo, los otros dos tipos pueden coexistir
  constraint centro_operaciones_tipo_chk check (
    (es_oficina = true and es_almacen = false and es_farmacia = false) or
    (es_almacen = true or es_farmacia = true)
  )
);

-- El empleado

create table empleado (
  empleado_id             number(10,0)  default on null empleado_seq.nextval,
  rfc                     varchar2(13)  not null,
  nombre                  varchar2(128) not null,
  ap_paterno              varchar2(128) not null,
  ap_materno              varchar2(128) not null,
  fecha_ing               date          default on null sysdate,
  sueldo_mensual          number(8,2)   not null,
  centro_operaciones_id   number(10,0)  not null,
  constraint empleado_pk primary key (empleado_id),
  -- Los valores únicos se checan con índices, en este caso se hará aquí para
  -- cumplir con el punto establecido
  constraint empleado_rfc_uk unique (rfc),
  constraint empleado_sueldo_chk check (
    sueldo_mensual >= 5000 -- Muy bajo :(
  ),
  constraint empleado_centro_operaciones_id_fk
    foreign key (centro_operaciones_id)
    references centro_operaciones(centro_operaciones_id)
);

create table oficina (
  centro_operaciones_id,
  telefono_cc             number(10,0)  not null,
  nombre                  varchar2(128) not null,
  clave_presupuestal      varchar2(256) not null,
  constraint oficina_pk primary key(centro_operaciones_id),
  constraint oficina_centro_operaciones_id_fk
    foreign key (centro_operaciones_id)
    references centro_operaciones(centro_operaciones_id)
);

create table almacen (
  centro_operaciones_id,
  tipo_almacen            char(1)       not null,
  documento               blob          default on null empty_blob(),
  almacen_contingencia_id,
  constraint almacen_pk primary key(centro_operaciones_id),
  constraint almacen_centro_operaciones_id_fk
    foreign key (centro_operaciones_id)
    references centro_operaciones(centro_operaciones_id),
  constraint almacen_almacen_contingencia_id_fk
    foreign key (almacen_contingencia_id)
    references almacen(centro_operaciones_id),
  constraint almacen_tipo_almacen_chk check (
    tipo_almacen in ('M', 'D', 'C')
  )
);

create table farmacia (
  centro_operaciones_id,
  rfc_fiscal              varchar2(13)  not null,
  url_web                 varchar2(128) not null,
  gerente_id,
  constraint farmacia_pk primary key(centro_operaciones_id),
  constraint farmacia_centro_operaciones_id_fk
    foreign key (centro_operaciones_id)
    references centro_operaciones(centro_operaciones_id),
  constraint farmacia_gerente_id_fk
    foreign key (gerente_id)
    references empleado(empleado_id)
  -- constraint farmacia_gerente_id_uk unique(gerente_id)
);

-- Presentacion de medicamento junto con sus dependencias

create table sustancia_activa (
  sustancia_activa_id   number(10,0)  default on null sustancia_activa_seq.nextval,
  sustancia             varchar2(128) not null,
  constraint sustancia_activa_pk primary key(sustancia_activa_id)
  -- constraint sustancia_activa_sustancia_uk unique(sustancia)
);

create table medicamento (
  medicamento_id        number(10,0)  default on null medicamento_seq.nextval,
  sustancia_activa_id                 not null,
  descripcion           varchar2(256) not null,
  constraint medicamento_pk primary key(medicamento_id),
  constraint medicamento_sustancia_activa_id_fk
    foreign key (sustancia_activa_id)
    references sustancia_activa(sustancia_activa_id)
);

create table presentacion (
  presentacion_id   number(10,0)  default on null presentacion_seq.nextval,
  cantidad          number(3,0)   not null,
  unidad            varchar2(10)  default on null 'unidades',
  precio            number(8,2)   not null,
  medicamento_id                  not null,
  constraint presentacion_pk primary key(presentacion_id),
  constraint presentacion_cantidad_chk check (
    cantidad >= 0
  ),
  constraint presentacion_unidad_chk check (
    unidad in ('unidades', 'ml', 'g', 'mg')
  ),
  constraint presentacion_precio_chk check (
    precio > 0
  ),
  constraint presentacion_medicamento_id_fk
    foreign key (medicamento_id)
    references medicamento(medicamento_id)
);

create table medicamento_nombre (
  medicamento_nombre_id   number(10,0)  default on null medicamento_nombre_seq.nextval,
  nombre                  varchar2(128) not null,
  medicamento_id          number(10,0)  not null,
  constraint medicamento_nombre_pk primary key(medicamento_nombre_id),
  constraint medicamento_nombre_medicamento_id_fk
    foreign key (medicamento_id)
    references medicamento(medicamento_id)
);

-- cliente y dependencias

create table cliente (
  cliente_id        number(10,0)  default on null cliente_seq.nextval,
  rfc               char(13)      not null,
  curp              char(18)      not null,
  nombre            varchar2(128) not null,
  ap_paterno        varchar2(128) not null,
  ap_materno        varchar2(128) not null,
  email             varchar2(256) not null,
  telefono          number(10,0)  not null,
  direccion_envio   varchar2(256) not null,
  hash_pass         char(60) not null,
  constraint cliente_pk primary key(cliente_id),
  -- constraint cliente_rfc_uk unique(rfc),
  -- constraint cliente_curp_uk  unique(curp),
  -- constraint cliente_email_uk  unique(email),
  -- constraint cliente_telefono_uk  unique(telefono),
  -- Los primeros 10 chars de RFC vienen de la CURP
  constraint cliente_curp_rfc_chk check (
    substr(curp, 1, 10) = substr(rfc, 1, 10)
  )
);

create table tarjeta_credito (
  cliente_id,
  digitos             number(20,0)  not null,
  mes_exp             number(2,0)   not null,
  ano_exp             number(2,0)   not null,
  constraint tarjeta_credito_pk primary key (cliente_id),
  constraint tarjeta_credito_cliente_id_fk
    foreign key (cliente_id)
    references cliente(cliente_id)
  -- constraint tarjeta_credito_digitos_uk unique(digitos)
);

-- Pedido y relacionados

create table status_pedido (
  status_pedido_id    number(10,0)  default on null status_pedido_seq.nextval,
  clave               varchar2(16)  not null,
  descripcion         varchar2(128) not null,
  constraint status_pedido_pk primary key(status_pedido_id)
  -- constraint status_pedido_clave_uk unique(clave)
);

create table pedido (
  pedido_id           number(10,0)  default on null pedido_seq.nextval,
  folio               char(13)      not null,
  fecha               date          not null,
  fecha_status        date          not null,
  importe             number(10,2)  not null,
  cliente_id                        not null,
  responsable_id                    not null,
  status_pedido_id                  not null,
  constraint pedido_pk primary key (pedido_id),
  -- constraint pedido_folio_uk unique(folio),
  constraint pedido_cliente_id_fk
    foreign key (cliente_id)
    references cliente(cliente_id),
  constraint pedido_responsable_id_fk
    foreign key (responsable_id)
    references empleado(empleado_id),
  constraint pedido_status_pedido_id_fk
    foreign key (status_pedido_id)
    references status_pedido(status_pedido_id)
);

create table historial_pedido_status (
  historial_pedido_status_id  number(10,0)  default on null historial_pedido_status_seq.nextval,
  fecha_status                date          not null,
  status_pedido_id            number(10,0)  not null,
  pedido_id                                 not null,
  constraint historial_pedido_status_pk primary key (historial_pedido_status_id),
  constraint historial_pedido_status_status_pedido_id_fk
    foreign key (status_pedido_id)
    references status_pedido(status_pedido_id),
  constraint historial_pedido_status_pedido_id_fk
    foreign key (pedido_id)
    references pedido(pedido_id)
);

create table ubicacion_pedido (
  ubicacion_pedido_id   number(10,0)          default on null ubicacion_pedido_seq.nextval,
  fecha_ubicacion       date          not null,
  latitud               number(8,6)   not null,
  longitud              number(9,6)   not null,
  pedido_id                           not null,
  constraint ubicacion_pedido_pk primary key (ubicacion_pedido_id),
  constraint ubicacion_pedido_pedido_id_fk
    foreign key (pedido_id)
    references pedido(pedido_id)
);

-- Pedidos de medicamentos

create table medicamento_pedido (
  medicamento_pedido_id   number(10,0)  default on null medicamento_pedido_seq.nextval,
  unidades                number(4,0)   default on null 0,
  es_valido               boolean       default on null true,
  presentacion_id                       not null,
  responsable_id                        not null,
  pedido_id                             not null,
  farmacia_id                           not null,
  constraint medicamento_pedido_pk primary key (medicamento_pedido_id),
  constraint medicamento_pedido_presentacion_id_fk
    foreign key (presentacion_id)
    references presentacion(presentacion_id),
  constraint medicamento_pedido_reponsable_id_fk
    foreign key (responsable_id)
    references empleado(empleado_id),
  constraint medicamento_pedido_pedido_id_fk
    foreign key (pedido_id)
    references pedido(pedido_id),
  -- Algunos pedidos pueden ser surtidos por un almacén!
  constraint medicamento_pedido_farmacia_id_fk
    foreign key (farmacia_id)
    references centro_operaciones(centro_operaciones_id)
);

-- Operaciones

create table operacion (
  operacion_id    number(10,0)  default on null operacion_seq.nextval,
  fecha_operacion date          not null,
  tipo_evento     char(1)       not null,
  responsable_id                not null,
  almacen_id                    not null,
  constraint operacion_pk primary key (operacion_id),
  constraint operacion_tipo_evento_chk check (
    -- 'i' para entrada, 'o' para salida
    tipo_evento in ('i', 'o')
  ),
  constraint operacion_reponsable_id_fk
    foreign key (responsable_id)
    references empleado(empleado_id),
  constraint operacion_almacen_id_fk
    foreign key (almacen_id)
    references almacen(centro_operaciones_id)
);

create table medicamento_operacion (
  medicamento_operacion_id    number(10,0)  default on null medicamento_operacion_seq.nextval,
  unidades                    number(10,0)  not null,
  presentacion_id                           not null,
  operacion_id                              not null,
  constraint medicamento_operacion_pk primary key (medicamento_operacion_id),
  constraint medicamento_operacion_unidades_chk check (
    unidades >= 0
  ),
  constraint medicamento_operacion_presentacion_id_fk
    foreign key (presentacion_id)
    references presentacion(presentacion_id),
  constraint medicamento_operacion_operacion_id_fk
    foreign key (operacion_id)
    references operacion(operacion_id)
);

-- Almacenes

create table inventario_farmacia (
  inventario_farmacia_id    number(10,0)  default on null inventario_farmacia_seq.nextval,
  num_disponibles           number(4,0)   not null,
  farmacia_id                             not null,
  presentacion_id                         not null,
  constraint inventario_farmacia_pk primary key (inventario_farmacia_id),
  constraint inventario_farmacia_num_disponibles_chk check (
    num_disponibles >= 0
  ),
  constraint inventario_farmacia_farmacia_id_fk
    foreign key (farmacia_id)
    references farmacia(centro_operaciones_id),
  constraint inventario_farmacia_presentacion_id_fk
    foreign key (presentacion_id)
    references presentacion(presentacion_id)
);
