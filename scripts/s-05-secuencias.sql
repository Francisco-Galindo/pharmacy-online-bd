--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script para la creación de secuencias

/*
 * Los números de inicio para las secuencias existen para apartar espacios para
 * que las pruebas de PL/SQL funcionen correctamente.
 *
 * Todas las tablas que tienen una PK artificial que además vayan a tener
 * registros creados de manera dinámica (que no siempre sean creados
 * directamente por el administrador) necesitarán una secuencia, para no tener
 * que elegirla al momento de insertar nuevos registros.
 */



create sequence empleado_seq
  start with 1
  increment by 1
  nocycle
  nocache;

/*
 * No se espera que existan demasiados centros de operaciones (menos de 100,
 * por ejemplo), no es necesario un caché
 */
create sequence centro_operaciones_seq
  start with 1
  increment by 1
  nocycle
  nocache;

create sequence sustancia_activa_seq
  start with 1
  increment by 1
  nocycle
  nocache;

create sequence medicamento_seq
  start with 1
  increment by 1
  nocycle
  nocache;

create sequence presentacion_seq
  start with 1
  increment by 1
  nocycle
  nocache;

create sequence medicamento_nombre_seq
  start with 1
  increment by 1
  nocycle
  nocache;

create sequence cliente_seq
  start with 1
  increment by 1
  nocycle
  nocache;

create sequence tarjeta_credito_seq
  start with 1
  increment by 1
  nocycle
  nocache;

create sequence status_pedido_seq
  start with 1
  increment by 1
  nocycle
  nocache;

/*
 * Como se van a estar creando pedidos constantemente, se utiliza un caché. El
 * resto de tablas relacionas con el pedido  también tendrán un caché por la
 * misma razón. Ese caché será más grande porque esas tablas tienen todavía más
 * actividad.
 */

create sequence pedido_seq
  start with 1
  increment by 1
  nocycle
  cache 256;

create sequence historial_pedido_status_seq
  start with 1
  increment by 1
  nocycle
  cache 1024;

create sequence ubicacion_pedido_seq
  start with 1
  increment by 1
  nocycle
  cache 1024;

create sequence medicamento_pedido_seq
  start with 1
  increment by 1
  nocycle
  cache 1024;

/*
 * Con respecto a las operaciones en almacenes y el inventario de las
 * farmacias, también se utilizará un caché, pues los cargamentos que vengan a
 * los almacenes pueden ser grandes y causar la generación de muchos registros.
 */

create sequence operacion_seq
  start with 1
  increment by 1
  nocycle
  cache 256;

create sequence medicamento_operacion_seq
  start with 1
  increment by 1
  nocycle
  cache 512;

create sequence inventario_farmacia_seq
  start with 1
  increment by 1
  nocycle
  cache 512;
