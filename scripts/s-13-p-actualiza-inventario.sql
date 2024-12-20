--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script con la definición de un procedimiento que actualiza la
--              cantidad de medicamentos en los inventarios y almacenes
--              correspondientes al cambiar el status de un pedido

create or replace procedure actualiza_inventario (
  p_pedido_id in pedido.pedido_id%type,
  p_clave_viejo_status in status_pedido.clave%type,
  p_clave_nuevo_status in status_pedido.clave%type
) is

  v_disponibles         inventario_farmacia.num_disponibles%type;
  v_inventario_row      inventario_farmacia%rowtype;

  cursor cur_meds_pedido is
    select * from medicamento_pedido where pedido_id = p_pedido_id;

begin

  for r in cur_meds_pedido loop
    select
      inv.* into v_inventario_row
      from inventario_farmacia inv
        join presentacion p on inv.presentacion_id = p.presentacion_id
        join medicamento_pedido mp on mp.presentacion_id = p.presentacion_id
      where
        mp.pedido_id = p_pedido_id
        and inv.presentacion_id = r.presentacion_id
        and inv.farmacia_id = r.farmacia_id
      fetch first 1 rows only;

    if p_clave_nuevo_status = 'EN_TRANSITO' then
      if v_inventario_row.num_disponibles > r.unidades then
        update inventario_farmacia
          set
            num_disponibles = num_disponibles - r.unidades
          where
            inventario_farmacia_id = v_inventario_row.inventario_farmacia_id;
      else
        -- Nunca se va a llegar a este punto si se utiliza el procedimiento
        -- pedir_desde_carrito. De todas maneras es buena idea para que cambios
        -- manuales no afecten.
        dbms_output.put_line('No hay suficiente stock en esa farmacia.');
        update medicamento_pedido
          set
            es_valido = false
          where
            medicamento_pedido_id = r.medicamento_pedido_id;
      end if;
    elsif p_clave_nuevo_status = 'DEVUELTO'
          or (p_clave_nuevo_status = 'CANCELADO'
              and p_clave_viejo_status = 'EN_TRANSITO')  then

      update inventario_farmacia
        set
          num_disponibles = num_disponibles + r.unidades
        where
          inventario_farmacia_id = v_inventario_row.inventario_farmacia_id;
    end if;

  end loop;

end;
/

show errors
