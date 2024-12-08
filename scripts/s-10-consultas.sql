--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script con consultas para la base de datos


/*
 * Consulta para conocer el tiempo promedio que le toma a un pedido llegar a su
 * destino.
 * Sólo se estan tomando en cuenta aquellos pedidos que sí son entregados :p
 */

select * from pedido p where status_pedido_id = (
  select status_pedido_id from status_pedido where clave = 'ENTREGADO'
);

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
  hps.fecha_status = q1.fecha_status
order by pedido_id;
  