--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script para la creación de índices útiles en la base de datos

/*
 * La mayoría de las veces se va a buscar a un empleado por su rfc o por su
 * nombre completo (teniendo el apellido paterno mayor importancia). Existen
 * personas en la vida real con exactamente el mismo nombre. El RFC es único.
 */
create or replace unique index empleado_rfc_iuk on empleado(rfc);
create or replace index empleado_nombre_completo_ix
  on empleado(ap_paterno, ap_materno, nombre);

/*
 * La clave es la manera natural de identificar a un centro de operaciones.
 * También se suele buscar un centron de operaciones por su número de teléfono.
 */
create or replace unique index centro_operaciones_clave_iuk
  on centro_operaciones(clave);
create or replace unique index centro_operaciones_telefono_iuk
  on centro_operaciones(telefono);

/*
 * Este índice existe porque la única forma de obtener información sobre el
 * almacén de contingencia es mediante un self-join
 */
create or replace index almacen_almacen_contingencia_id_ix
  on almacen(almacen_contingencia_id);

/*
 * Por la manera en la que está diseñada la base de datos en este momento, la
 * única forma de distinguir gerentes de empleados normales es mediante una
 * query que una la tabla empleado con farmacia.
 *
 * Adicionalmente, es un índice unique porque un empleado sólo puede ser
 * gerente de una farmacia.
 */
create or replace unique index farmacia_gerente_id_iuk on farmacia(gerente_id);

/*
 * Las sustancias activas se buscan por su nombre, no por su id
 */
create or replace unique index sustancia_activa_sustancia_iuk
  sustancia_activa(sustancia);

/*
 * Los medicamentos se utilizan como paso intermedio al momento de hacer
 * queries. Hay que crear índices para su FK para acelerar los JOINS
 */
 create or replace index medicamento_sustancia_activa_id_ix
  on medicamento(sustancia_activa_id);

/*
 * La presentación depende del medicamento, por lo que en las queries, si sale
 * la presentación, probablemente salga el medicamento
 */
create or replace index presentacion_medicamento_id_ix
  on presentacion(medicamento_id);

/*
 * La razón de existir de esta tabla es para buscar por nombre, hay que indexar
 * con base en eso. Nos parece que un nombre se podría repetir, por eso no es
 * unique.
 * Como siempre se va a utilizar esta tabla con JOINS, se hace índice con la FK
 */
create or replace index medicamento_nombre_nombre_ix
  on medicament_nombre(nombre);
create or replace index medicamento_nombre_medicamento_id_ix
  on medicament_nombre(medicamento_id);

/*
 * Los clientes tienen muchas columnas mediante las cuales puede buscarlos uno
 * y que son candidatas a tener un índice.
 */
create or replace unique index cliente_rfc_iuk
  on cliente(rfc);
create or replace unique index cliente_curp_iuk
  on cliente(curp);
create or replace unique index cliente_email_iuk
  on cliente(email);
create or replace unique index cliente_telefono_iuk
  on cliente(telefono);
create or replace index cliente_nombre_completo_ix
  on cliente(ap_paterno, ap_materno, nombre);

/*
 * Como la tarjeta y el cliente están en una relación 1 a 1, probablemente se
 * vean sus datos juntos mediante JOINS. Hay una tarjeta por cliente. Cada
 * tarjeta también puede identificarse única por su número.
 */
create or replace unique index tarjeta_credito_cliente_id_iuk
  on tarjeta_credito(cliente_id);
create or replace unique index tarjteta_credito_numero_uik
  on tarjeta_credito(numero);

/*
 * Los pedidos se van a buscar por su foio. También es una tabla que tiene
 * muchas relaciones con otras, es necesario crear índices para las FKs
 */
create or replace unique index pedido_folio_iuk
  on pedido(folio);
create or replace index pedido_cliente_id_ix
  on pedido(cliente_id);
create or replace index pedido_responsable_id_ix
  on pedido(responsable_id);
create or replace index pedido_status_pedido_id_ix
  on pedido(status_pedido_id);

/*
 * El historial de status de los pedidos va a ser una tabla muy grande, hay que
 * indexar sus FKs para acelerar las queries.
 *
 * Puede resultar hacer el índice basándose en la fechas, así pueden buscarse
 * en el historial aquellos cambios que se han tenido en ciertos rangos de
 * fechas.
 */
create or replace index historial_pedido_status_fecha_status_ix
  on historial_pedido_status(fecha_status);
create or replace index historial_pedido_status_status_pedido_id_ix
  on historial_pedido_status(status_pedido_id);
create or replace index historial_pedido_status_pedido_id_ix
  on historial_pedido_status(pedido_id);

/*
 * Puede resultar hacer el índice basándose en la fechas, así pueden buscarse
 * en el historial aquellos cambios que se han tenido en ciertos rangos de
 * fechas.
 */
create or replace index ubicacion_pedido_fecha_ubicacion_ix
  on ubicacion_pedido(fecha_ubicacion);
create or replace index ubicacion_pedido_pedido_id_ix
  on ubicacion_pedido(pedido_id);

/*
 * Otra tabla grandísima, hay que indexar las FKs para agilizar queries
 */
create or replace index medicamento_pedido_presentacion_id_ix
  on medicamento_pedido(presentacion_id);
create or replace index medicamento_pedido_responsable_id_ix
  on medicamento_pedido(responsable_id);
create or replace index medicamento_pedido_pedido_id_ix
  on medicamento_pedido(pedido_id);
create or replace index medicamento_pedido_farmacia_id_ix
  on medicamento_pedido(farmacia_id);

/*
 * En las operaciones también es útil hacer búsquedas basándose en las fechas,
 * para poder hacer un _pin-point_ de algún hecho en particular.
 */
create or replace index operacion_fecha_operacion_ix
  on operacion(fecha_operacion);
create or replace index operacion_responsable_id_ix
  on operacion(responsable_id);
create or replace index operacion_almacen_id_ix
  on operacion(almacen_id);

/*
 * Tabla grande. Es básicamente una tabla intermedia, se sigue con el
 * procedimiento de indexar FKs
 */
create or replace index medicamento_operacion_presentacion_id_ix
  on medicamento_operacion(presentacion_id);
create or replace index medicamento_operacion_operacion_id_ix
  on medicamento_operacion(operacion_id);

/*
 * Inventario farmacia
 */
create or replace index inventario_farmacia_presentacion_id_ix
  on inventario_farmacia(presentacion_id);
create or replace index inventario_farmacia_farmacia_id_ix
  on inventario_farmacia(farmaci_id);
