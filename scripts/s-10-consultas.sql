--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script con consultas para la base de datos
/*
 * Consulta para conocer el tiempo promedio que le toma a un pedido llegar a su
 * destino.
 * Sólo se estan tomando en cuenta aquellos pedidos que sí son entregados :p
 */
select
  round(avg(q1.fecha_status - q2.fecha_status) * 24, 0) as horas_promedio
from
  (
    select
      pedido_id,
      fecha_status
    from
      pedido p
    where
      status_pedido_id = (
        select
          status_pedido_id
        from
          status_pedido
        where
          clave = 'ENTREGADO'
      )
  ) q1
  join (
    select
      pedido_id,
      fecha_status
    from
      historial_pedido_status
    where
      status_pedido_id = (
        select
          status_pedido_id
        from
          status_pedido sp
        where
          clave = 'CAPTURADO'
      )
  ) q2 on q1.pedido_id = q2.pedido_id;

/*
 * Porcentaje de pedidos que han sido cancelados
 */
select
  round(100 * num_cancelados / num_pedidos)
from
  (
    select
      count(*) as num_pedidos
    from
      pedido ped
  )
  cross join (
    select
      count(*) as num_cancelados
    from
      pedido p
      join status_pedido sp on p.status_pedido_id = sp.status_pedido_id
    where
      sp.clave = 'CANCELADO'
  );

/*
 * Cuáles son los empleados responables de una mayor proporción de pedidos
 * cancelados
 */
select
  q1.empleado_id,
  (num_cancelados / num_pedidos) as proporcion_cancelados
from
  (
    select
      empleado_id,
      count(*) as num_pedidos
    from
      empleado e1
      join pedido p1 on e1.empleado_id = p1.responsable_id
    having
      num_pedidos >= 5
    group by
      empleado_id
  ) q1
  join (
    select
      empleado_id,
      count(*) as num_cancelados from empleado e2
      join pedido p2 on e2.empleado_id = p2.responsable_id
      join status_pedido sp on sp.status_pedido_id = p2.status_pedido_id
    where
      sp.clave = 'CANCELADO'
    group by
      empleado_id
  ) q2 on q1.empleado_id = q2.empleado_id
order by
  proporcion_cancelados desc
fetch first
  10 rows only;

/*
 * Cuáles son los tres medicamentos con la mayor proporción de devoluciones.
 * Mostrar el id, descripcion y nombres de los tres medicamentos con la mayor
 * proporción.
 */
select
  sub1.medicamento_id,
  nombre,
  descripcion,
  proporcion_cancelados
from
  (
    select
      medicamento_id,
      nombre
    from
      medicamento_nombre
  ) sub1
  join (
    select
      m3.medicamento_id,
      m3.descripcion,
      (num_cancelados / num_pedidos) as proporcion_cancelados
    from
      (
        select
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
      ) q1
      join (
        select
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
      ) q2 on q1.medicamento_id = q2.medicamento_id
      join medicamento m3 on m3.medicamento_id = q1.medicamento_id
      --join medicamento_nombre mn on m3.medicamento_id = mn.medicamento_id
    order by
      proporcion_cancelados desc
    fetch first
      3 rows only
  ) sub2 on sub1.medicamento_id = sub2.medicamento_id;


/*
 * Seleccionas los 100 clientes cuyos gastos totales en pedidos sea mayor.
 * Se va a a utilizar natural join.
 * No tener en cuenta aquellas personas que tengan una tarjeta vencida
 */
select
  c.nombre,
  c.ap_paterno,
  c.curp,
  sum(precio) as gasto_total
from
  (
    select
      cliente_id
    from
      cliente minus
    select
      cliente_id
    from
      tarjeta_credito
    where
      ano_exp || mes_exp > to_char(sysdate, 'yymm')
  ) q1
  natural join cliente c
  natural join pedido p
  join medicamento_pedido mp using (pedido_id)
  natural join presentacion pr
where
  mp.es_valido = true
group by
  c.nombre,
  c.ap_paterno,
  c.curp
order by
  gasto_total desc
fetch first
  100 rows only;

/*
 * Los lotes del medicamento 'Acetaflex', que llegó entre febrero y marzo de
 * 2024 llegó mal. Queremos rastrear a los involucrados en las operaciones que
 * incluyeran a ese medicamento
 */
select distinct
  e.nombre,
  e.ap_paterno,
  e.rfc,
  co.clave,
  co.direccion
from
  medicamento_nombre mn
  join medicamento m on mn.medicamento_id = m.medicamento_id
  join presentacion p on p.medicamento_id = m.medicamento_id
  join medicamento_operacion mo on mo.presentacion_id = p.presentacion_id
  join operacion o on o.operacion_id = mo.operacion_id
  join empleado e on e.empleado_id = o.responsable_id
  join centro_operaciones co on e.centro_operaciones_id = co.centro_operaciones_id
where
  mn.NOMBRE = 'Acetaflex'
  and o.fecha_operacion > to_date(
    '2024-02-01 00:00:00',
    'yyyy-mm-dd
    hh24:mi:ss'
  )
  and o.fecha_operacion < to_date('2024-04-30 23:59:59', 'yyyy-mm-dd hh24:mi:ss');

/*
 * Los últimos pedidos hechos por 'Matias Santiago Ruiz' y 'Emmanuel Romero
 * Flores' fueron intercambiados.
 *
 * Los últimos dos pedidos que se han realizado fueron intercambiados, es
 * decir, uno se le está entregando al cliente correspondiente al otro.
 * Identifica los nombre los encargados de cada pedido para que puedan corregir
 * el error.
 */
select
  nombre,
  ap_paterno,
  ap_materno
from
  cliente;

select
  e.nombre,
  e.ap_paterno,
  e.ap_materno,
  e.rfc
from
  (
    select
      fecha_status,
      pedido_id
    from
      historial_pedido_status hps
    where
      status_pedido_id = (
        select
          status_pedido_id
        from
          status_pedido
        where
          clave = 'CAPTURADO'
      )
    order by
      fecha_status desc
    fetch first
      2 rows only
  ) q1
  join pedido p on p.pedido_id = q1.pedido_id
  join empleado e on e.empleado_id = p.responsable_id;

/* Para tablas temporales, una query que devuelva la cantidad de medicamentos
* que no se pueden comprar porque no hay suficientes
*/
