--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script con la definición de un procedimiento que ingresa los
--              detalles de una operación recibida de un cargamento a la base
--              de datos

/*
 * Este procedimiento busca que, a partir de un carrito de compras. Elegirá los
 * medicamentos de la farmacia que tenga más en stock. Como se quiere tener
 * suficiente stock para los clientes físicos, se busca que si ninguna farmacia
 * tiene más de 5 unidades del medicamento que se quiere comprar, el
 * medicamento vendrá de un almacén aleatorio. El almacén hará lo necesario
 * para obtener el medicamento en caso de no tenerlo (esto no está modelado en
 * la base).
 *
 * - El responsable del pedido es un trabajador random de algún almacén.
 * - El responsable de cada medicamento será un trabajador random de la farmacia
 *   o almacén correspondiente.
 */

set serveroutput on

create or replace procedure pedir_desde_carrito (
  p_cliente_id in cliente.cliente_id%type,
  p_pedido_id out pedido.pedido_id%type
) is

  cursor cur_carrito is
    select * from carrito_compras
    where cliente_id = cliente_id;

  v_inventario_farmacia_row   inventario_farmacia%rowtype;
  v_responsable_id            empleado.empleado_id%type;
  v_farmacia_id               farmacia.centro_operaciones_id%type;
  v_i                         number(10,0);

begin
  v_responsable_id := elegir_responsable_random();

  dbms_output.put_line('asdf');

  v_i := 0;
  for r in cur_carrito loop
    if v_i = 0 then
      insert into pedido
        (pedido_id, folio, cliente_id, responsable_id, status_pedido_id)
        values (
          pedido_seq.nextval,
          crear_folio_pedido(p_cliente_id, v_responsable_id, sysdate),
          p_cliente_id,
          v_responsable_id,
          (select status_pedido_id from status_pedido where clave = 'CAPTURADO')
        );
      p_pedido_id := pedido_seq.currval;
    end if;


    begin
      select
        farmacia_id into v_farmacia_id
        from
          inventario_farmacia if2
        where
          presentacion_id = 1
          and num_disponibles >= r.unidades
        order by
          num_disponibles desc
        fetch first
          1 rows only;
    exception
      when no_data_found then
        select centro_operaciones_id into v_farmacia_id
          from empleado
          where empleado_id = v_responsable_id;
    end;


    insert into medicamento_pedido
      (unidades, presentacion_id, responsable_id, pedido_id, farmacia_id)
      values (
        r.unidades,
        r.presentacion_id,
        v_responsable_id,
        pedido_seq.currval,
        v_farmacia_id
      );

    v_i := v_i + 1;
  end loop;

  if v_i != 0 then
    delete from carrito_compras where cliente_id = p_cliente_id;
  end if;

end;
/
show errors

disconnect
