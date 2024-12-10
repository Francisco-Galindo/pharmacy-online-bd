--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script con consultas para la base de datos

/*
 * Consulta para conocer el tiempo promedio que le toma a un pedido llegar a su
 * destino.
 * Sólo se estan tomando en cuenta aquellos pedidos que sí son entregados :p
 */
select
  round(avg(fpe.fecha_status - fcp.fecha_status) * 24, 0) as horas_promedio
from
  v_fechas_pedido_entregado fpe
  join v_fechas_captura_pedido fcp
  on fpe.pedido_id = fcp.pedido_id;

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
      join stat_ped sp on p.status_pedido_id = sp.status_pedido_id
    where
      sp.clave = 'CANCELADO'
  );

/*
 * Cuáles son los empleados responables de una mayor proporción de pedidos
 * cancelados
 */
select
  vep.empleado_id,
  (num_cancelados / num_pedidos) as proporcion_cancelados
    from 
      v_empleados_con_min_5_pedidos vep
    join 
      ped_cancel_p_emp pce 
        on vep.empleado_id = pce.empleado_id
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
      v_pedidos_por_medicamento vpm
      join
        v_num_devoluciones_medicamento vdm 
          on vpm.medicamento_id = vdm.medicamento_id
      join medicamento m3 on m3.medicamento_id = vpm.medicamento_id
      --join medicamento_nombre mn on m3.medicamento_id = mn.medicamento_id
    order by
      proporcion_cancelados desc
    fetch first
      3 rows only
  ) sub2 on sub1.medicamento_id = sub2.medicamento_id;


/*
 * Seleccionas los 100 clientes cuyos gastos totales en pedidos sea mayor a $1000.
 * Se va a a utilizar natural join.
 * No tener en cuenta aquellas personas que tengan una tarjeta vencida
 */
select
  c.nombre,
  c.ap_paterno,
  c.curp,
  sum(precio) as gasto_total
from
  v_clientes_con_tarjeta_expirada
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
  having
    gasto_total > 1000
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
  and o.fecha_operacion >= to_date(
    '2024-02-01 00:00:00',
    'yyyy-mm-dd
    hh24:mi:ss'
  )
  and o.fecha_operacion <= to_date('2024-04-30 23:59:59', 'yyyy-mm-dd hh24:mi:ss');

/*
 * Los últimos dos pedidos que se han realizado fueron intercambiados, es
 * decir, uno se le está entregando al cliente correspondiente al otro.
 * Identifica los nombre los encargados de cada pedido para que puedan corregir
 * el error.
 */

select
  e.nombre,
  e.ap_paterno,
  e.ap_materno,
  e.rfc
from (
  select *
    from 
      v_fechas_captura_pedido v
    order by
      v.fecha_status desc
    fetch first
      2 rows only
  ) q1
  join pedido p on p.pedido_id = q1.pedido_id
  join empleado e on e.empleado_id = p.responsable_id;

/*
 * Se muestran a todos los almacenes con su almacén de contingencia
 * en caso de tenerlo
 */

 select
  a.centro_operaciones_id,
  ac.almacen_contingencia_id
  from 
    almacen a
      left outer join 
        almacen ac 
  on a.centro_operaciones_id = ac.centro_operaciones_id
 ;

/*
 * Se recupera el id, nombre y apellido paterno de todos los empleados
 * de nombre Juan que estén involucrados en el pedido con id 60
 */

select
  *
from
  empleado e
  join MEDICAMENTO_PEDIDO mp on e.EMPLEADO_ID = mp.RESPONSABLE_ID
  join PEDIDO p on p.PEDIDO_ID = mp.PEDIDO_ID where p.PEDIDO_ID = 60 and e.NOMBRE  = 'Regina';


select * from (
select
  e.nombre, e.ap_paterno, e.rfc
from
  empleado e
  join medicamento_pedido mp on e.empleado_id = mp.responsable_id
  join pedido p on p.pedido_id = mp.pedido_id
where
  p.pedido_id = 60
) intersect (
select
  e.nombre, e.ap_paterno, e.rfc
from
  empleado e
  join medicamento_pedido mp on e.empleado_id = mp.responsable_id
  join pedido p on p.pedido_id = mp.pedido_id
where e.nombre = 'Regina'
) union (
select
  e.nombre, e.ap_paterno, e.rfc
from
  empleado e
  join pedido p on p.responsable_id = e.empleado_id
where e.nombre = 'Regina' and p.pedido_id = 60
);



/*
 * Obtener todos los nombres de los medicamentos en la tabla
 * externa que no están en la base de datos
 */
select
  medicamento_nombre
from
  cargamento_ext minus
select
  medicamento_nombre
from
  cargamento_ext ce
  join MEDICAMENTO_NOMBRE mn on mn.NOMBRE = ce.medicamento_nombre;


/*
 * Todos los id's de los centros de operaciones que son tanto]
 * almacenes como farmacias.
 */
select
  centro_operaciones_id
from
  centro_operaciones_desnomormalizado
where
  es_almacen = true
  and es_farmacia = true;


/*
 * Consultas faltantes:
 *   - consulta con tabla temporal (supertipo desnormalizada)
 *   - consulta que involucre una tabla externa
 */
