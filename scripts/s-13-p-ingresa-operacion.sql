--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script con la definición de un procedimiento que ingresa los
--              detalles de una operación recibida de un cargamento a la base
--              de datos

/*
 * El procedimiento busca que, al iterar sobre cada uno de los productos que
 * haya sido recibido en el cargamento para insertarlos en el los registros de
 * operaciones realizadas.
 *
 * Los IDs tanto del responsable como del almacén deben tener sentido, es
 * decir, deben existir y el trabajador responsable tiene que trabajar en el
 * almacén sobre el que se trabaja.
 *
 * Si uno de los medicamentos recibidos no existe ya en labase, es agregado.
 */

connect gs_proy_admin/gs_proy_admin@&p_pdb

set serveroutput on

create or replace procedure ingresa_cargamento (
  p_almacen_id in operacion.almacen_id%type,
  p_responsable_id in operacion.almacen_id%type
) is

  cursor cur_cargamento is
    select * from cargamento_ext;

  v_sustancia_id      number(10,0);
  v_presentacion_id   number(10,0);
  v_medicamento_id    number(10,0);
  v_num_matches       number(10,0);

begin

  select count(*) into v_num_matches
    from empleado e
    join centro_operaciones c
      on e.centro_operaciones_id = c.centro_operaciones_id
    where
      e.empleado_id = p_responsable_id
      and c.es_almacen = true
      and c.centro_operaciones_id = p_almacen_id;

  if v_num_matches = 0 then
    raise_application_error(-20201,
      'El responsable (o almacén) de esta operación no es válido.');
  end if;

  insert into operacion
    (operacion_id, fecha_operacion, tipo_evento, responsable_id, almacen_id)
    values (operacion_seq.nextval, sysdate, 'i', p_responsable_id, p_almacen_id);

  for r in cur_cargamento loop
    select count(*) into v_num_matches
      from medicamento_nombre
      where nombre = r.medicamento_nombre;

    if v_num_matches = 0 then
      begin
        select sustancia_activa_id into v_sustancia_id
          from sustancia_activa
          where sustancia = r.sustancia_activa;
          insert into medicamento
            (medicamento_id, sustancia_activa_id, descripcion)
            values (
              medicamento_seq.nextval,
              v_sustancia_id,
              r.medicamento_desc
            );
      exception
        when no_data_found then
          insert into sustancia_activa
            (sustancia_activa_id, sustancia)
            values (sustancia_activa_seq.nextval, r.sustancia_activa);

          insert into medicamento
            (medicamento_id, sustancia_activa_id, descripcion)
            values (
              medicamento_seq.nextval,
              sustancia_activa_seq.currval,
              r.medicamento_desc
            );
      end;

      insert into presentacion
        (presentacion_id, cantidad, unidad, precio, medicamento_id)
        values (
          presentacion_seq.nextval,
          r.cantidad_presentacion,
          r.unidad_presentacion,
          r.precio,
          medicamento_seq.currval
        );

      insert into medicamento_operacion
        (unidades, presentacion_id, operacion_id)
        values (r.unidades, presentacion_seq.currval, operacion_seq.currval);
    else

      begin
        select presentacion_id into v_presentacion_id
          from presentacion p
          join medicamento m on p.medicamento_id = m.medicamento_id
          join medicamento_nombre mn on mn.medicamento_id = m.medicamento_id
          where
            mn.nombre = r.medicamento_nombre
            and p.cantidad = r.cantidad_presentacion
            and p.unidad = r.unidad_presentacion;

        -- Se mantiene el precio que ya se tenía de la presentación
        insert into medicamento_operacion
          (unidades, presentacion_id, operacion_id)
          values (r.unidades, v_presentacion_id, operacion_seq.currval);
      exception
      when no_data_found then
        select medicamento_id into v_medicamento_id
          from medicamento_nombre
          where nombre = r.medicamento_nombre;

        insert into presentacion
          (presentacion_id, cantidad, unidad, precio, medicamento_id)
          values (
            presentacion_seq.nextval,
            r.cantidad_presentacion,
            r.unidad_presentacion,
            r.precio,
            v_medicamento_id
          );

        insert into medicamento_operacion
          (unidades, presentacion_id, operacion_id)
          values (r.unidades, presentacion_seq.currval, operacion_seq.currval);
      end;
    end if;
  end loop;
end;
/
show errors

begin
  ingresa_cargamento(10, 91);
  commit;
end;
/
