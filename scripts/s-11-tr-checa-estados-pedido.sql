--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script con la definición de un trigger para cumplir con las
--              reglas de negocio referentes a los status de un pedido.

connect gs_proy_admin/gs_proy_admin@&p_pdb

create or replace trigger tr_checa_estados_pedido
for insert or update of status_pedido_id
  on pedido
  compound trigger


  type pedido_a_fechar_type is record (
    pedido_id   pedido.pedido_id%type
  );
  type pedidos_lista_type is table of pedido_a_fechar_type;
  pedidos_lista pedidos_lista_type := pedidos_lista_type();

  type pedido_a_fechar_type2 is record (
    pedido_id     pedido.pedido_id%type,
    viejo_status  status_pedido.clave%type,
    nuevo_status  status_pedido.clave%type
  );
  type pedidos_lista_type2 is table of pedido_a_fechar_type2;
  pedidos_lista2 pedidos_lista_type2 := pedidos_lista_type2();

  var_es_invalido   boolean;
  var_nuevo_estado  status_pedido.clave%type;
  var_viejo_estado  status_pedido.clave%type;

  before each row is
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

    end case;

  end before each row;


  after each row is
      v_index number;
      v_index2 number;
  begin
    case
    when inserting then
      insert into historial_pedido_status
        (fecha_status, status_pedido_id, pedido_id)
        values (:new.fecha_status, :new.status_pedido_id, :new.pedido_id);

      update cliente
        set puntaje_lealtad = least(puntaje_lealtad + 5, 100)
        where cliente_id = :new.cliente_id;

    else
      -- Inserta en el historial
      if :new.fecha_status = :old.fecha_status then
        pedidos_lista.extend;
        v_index := pedidos_lista.last;
        pedidos_lista(v_index).pedido_id := :new.pedido_id;

        insert into historial_pedido_status
          (fecha_status, status_pedido_id, pedido_id)
          values (sysdate, :new.status_pedido_id, :old.pedido_id);

      else
        insert into historial_pedido_status
          (fecha_status, status_pedido_id, pedido_id)
          values (:new.fecha_status, :new.status_pedido_id, :old.pedido_id);
      end if;

      if var_nuevo_estado in ('EN_TRANSITO', 'DEVUELTO', 'CANCELADO') then
        pedidos_lista2.extend;
        v_index2 := pedidos_lista2.last;
        pedidos_lista2(v_index2).pedido_id := :new.pedido_id;
        pedidos_lista2(v_index2).viejo_status := var_viejo_estado;
        pedidos_lista2(v_index2).nuevo_status := var_nuevo_estado;

        -- actualiza_inventario(:new.pedido_id, var_viejo_estado, var_nuevo_estado);
      end if;

      if var_nuevo_estado = 'CANCELADO' and var_viejo_estado = 'EN_TRANSITO' then
        update cliente
          set puntaje_lealtad = greatest(puntaje_lealtad - 1, 0)
          where cliente_id = :new.cliente_id;
      end if;

    end case;
  end after each row;


  after statement is
  begin
    for i in 1 .. pedidos_lista2.count loop
      actualiza_inventario(
        pedidos_lista2(i).pedido_id,
        pedidos_lista2(i).viejo_status,
        pedidos_lista2(i).nuevo_status
      );
    end loop;
    forall i in pedidos_lista.first .. pedidos_lista.last
    update pedido
      set fecha_status = sysdate
      where pedido_id = pedidos_lista(i).pedido_id;
  end after statement;
end;
/
show errors;
