--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script con la definición de un trigger para cumplir con las
--              reglas de negocio referentes a los status de un pedido.

connect gs_proy_admin/gs_proy_admin@&p_pdb

create or replace trigger tr_checa_estados_pedido_before
  before
    insert or
    update of status_pedido_id
  on pedido
  for each row
declare
  var_nuevo_estado  status_pedido.clave%type;
  var_viejo_estado  status_pedido.clave%type;
  var_es_invalido   boolean;
begin

  select clave into var_nuevo_estado
    from status_pedido
    where status_pedido_id = :new.status_pedido_id;

  case
  when inserting then
    -- Todos los pedidosdeben empezar como CAPTURADO
    if var_nuevo_estado != 'CAPTURADO' then
      raise_application_error(-20101,
        'Todos los pedidos nuevos deben empezar como CAPTURADO.');
    end if;

  when updating then
    select clave into var_viejo_estado
      from status_pedido
      where status_pedido_id = :old.status_pedido_id;

    var_es_invalido := :new.fecha_status < :old.fecha_status or
                       (var_viejo_estado = 'CAPTURADO' and
                        var_nuevo_estado not in ('EN_TRANSITO', 'CANCELADO')) or
                       (var_viejo_estado = 'EN_TRANSITO' and
                        var_nuevo_estado not in ('ENTREGADO', 'CANCELADO')) or
                       (var_viejo_estado = 'ENTREGADO' and
                        var_nuevo_estado not in ('DEVUELTO')) or
                       var_nuevo_estado = 'CAPTURADO' or
                       var_viejo_estado in ('DEVUELTO', 'CANCELADO');


    if var_es_invalido then
      raise_application_error(-20102,
        'El nuevo status del pedido no sigue una secuencia lógica.');
    end if;

    -- Inserta en el historial
    insert into historial_pedido_status
      (fecha_status, status_pedido_id, pedido_id)
      values (:new.fecha_status, :new.status_pedido_id, :old.pedido_id);

    if var_nuevo_estado in ('DEVUELTO', 'CANCELADO') then
      actualiza_inventario(:new.pedido_id, var_viejo_estado, var_nuevo_estado);
    end if;

    if var_nuevo_estado = 'CANCELADO' and var_viejo_estado = 'EN_TRANSITO' then
      update cliente
        set puntaje_lealtad = greatest(puntaje_lealtad - 1, 0)
        where cliente_id = :new.cliente_id;
    end if;
  end case;
end;
/
show errors;

create or replace trigger tr_checa_estados_pedido_after
  after
    insert
  on pedido
  for each row
begin

  insert into historial_pedido_status
    (fecha_status, status_pedido_id, pedido_id)
    values (:new.fecha_status, :new.status_pedido_id, :new.pedido_id);

  update cliente
    set puntaje_lealtad = least(puntaje_lealtad + 5, 100)
    where cliente_id = :new.cliente_id;

end;
/
show errors

disconnect;
