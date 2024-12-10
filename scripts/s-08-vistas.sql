--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script para la creación de vistas

prompt Conectando como usuario gs_proy_admin
connect gs_proy_admin/gs_proy_admin@&p_pdb

/*
 * Vista para ocultar el hash de la contraseña del cliente
 */

 create or replace view v_cliente_sin_contrasena(
    cliente_id,rfc,curp,nombre,ap_paterno,ap_materno,email,telefono,direccion_envio
  ) as select cliente_id,rfc,curp,nombre,ap_paterno,ap_materno,email,telefono,direccion_envio
        from cliente 
 ;

/*
 * Vista para ocultar los datos sensibles del cliente
 */

 create or replace view v_cliente_sin_datos_sensibles(
    cliente_id,nombre,ap_paterno,ap_materno,email,telefono
 ) as select cliente_id,nombre,ap_paterno,ap_materno,email,telefono
        from cliente
 ;

/*
 * Vista para ocultar los datos sensibles de la tarjeta de crédito
 */

 create or replace view v_tarjeta_credito_sin_datos_sensibles(
    tarjeta_credito_id,cliente_id
  ) as select tarjeta_credito_id,cliente_id
        from tarjeta_credito
 ;

/*
 * Se le otorgan privilegios al usuario invitado para visualizar
 * el contenido de las vistas que no incluyen datos sensibles
 */

 grant select on v_cliente_sin_datos_sensibles to gs_proy_invitado;
 grant select on v_tarjeta_credito_sin_datos_sensibles to gs_proy_invitado;

/*
 * Vista que muestra el identificador de los clientes con tarjetas expiradas
 */

 create or replace view v_clientes_con_tarjeta_expirada(
    cliente_id
 ) as select cliente_id
        from cliente
      minus
      select cliente_id
        from tarjeta_credito
        where ano_exp || mes_exp > to_char(sysdate, 'yymm')
 ;

/*
 * Vista que muestra el id y la fecha en la que cada pedido fue CAPTURADO 
 */

 create or replace view v_fechas_captura_pedido(
    pedido_id,fecha_status
 ) as select pedido_id,fecha_status
        from historial_pedido_status
        where status_pedido_id = ( 
            select status_pedido_id
                from status_pedido sp
                where clave = 'CAPTURADO'
    )
 ;

/*
 * Vista que muestra el id y la fecha en la que cada pedido fue ENTREGADO  
 */

 create or replace view v_fechas_pedido_entregado(
   pedido_id,fecha_status
 ) as select pedido_id,fecha_status
         from pedido p
         where status_pedido_id = (
            select status_pedido_id
               from status_pedido
               where clave = 'ENTREGADO'
            )
 ;

/*
 * Vista para seleccionar el id de los empleados involucrados en al 
 * menos 5 pedidos
 */

 create or replace view v_empleados_con_min_5_pedidos(
   empleado_id,num_pedidos
 ) as select
      empleado_id,
      count(*) as num_pedidos
    from
      empleado e1
      join pedido p1 on e1.empleado_id = p1.responsable_id
    having
      num_pedidos >= 5
    group by
      empleado_id
 ;

/*
 * Vista para contar el número de pedidos cancelados por empleado
 */

 create or replace view v_num_pedidos_cancelados_de_cada_empleado(
   empleado_id,num_cancelados
 ) as select
      empleado_id,
      count(*) as num_cancelados from empleado e2
      join pedido p2 on e2.empleado_id = p2.responsable_id
      join status_pedido sp on sp.status_pedido_id = p2.status_pedido_id
    where
      sp.clave = 'CANCELADO'
    group by
      empleado_id
 ;

/*
 * Vista para saber cuántos pedidos ha habido de cada medicamento
 */

 create or replace view v_pedidos_por_medicamento(
   medicamento_id,num_pedidos
 ) as select
         m.medicamento_id,
         count(*) as num_pedidos
            from
               medicamento m
            join presentacion p on m.medicamento_id = p.medicamento_id
            join medicamento_pedido mp on p.presentacion_id = mp.presentacion_id
            join pedido p2 on p2.pedido_id = mp.pedido_id
            where
               mp.es_valido = true
        group by
          m.medicamento_id
 ;

/*
 * Vista para saber la cantidad de veces que se ha devuelto un medicamento 
 */

 create or replace view v_num_devoluciones_medicamento(
   medicamento_id,num_cancelados
 ) as select
          m2.medicamento_id,
          count(*) as num_cancelados
        from
          medicamento m2
          join presentacion p3 on m2.medicamento_id = p3.medicamento_id
          join medicamento_pedido mp2 on mp2.presentacion_id = p3.presentacion_id
          join pedido p4 on p4.pedido_id = mp2.pedido_id
        where
          mp2.es_valido = true
          and p4.status_pedido_id = (
            select
              status_pedido_id
            from
              status_pedido
            where
              clave = 'DEVUELTO'
          )
         group by 
            m2.medicamento_id
   ;  

disconnect
