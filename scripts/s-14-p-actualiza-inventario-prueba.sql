--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script para validación del funcionamiento del trigger
--              tr_calcula_importe_pedido_prueba.sql

-- Para este script validador, no se llamará directamente al procedimiento,
-- sino que se realizarán las acciones necesarias para que se ejecute el
-- trigger que invoca a este procedimiento. Probarla así es un poco más fácil
-- porque no es necesario escribir tantas sentencias.

set serveroutput on

commit;

Prompt =========================================================================
Prompt Prueba
prompt Haciendo pedido de seis (unidades) medicamentos
Prompt =========================================================================

Prompt El importe debería ser la suma de los precios de todos los medicamentos

declare
  v_cliente_id                number(10,0);
  v_pedido_id                 number(10,0);
  v_num_disponibles_antes     number(10,0);
  v_num_disponibles_despues   number(10,0);
begin
  v_cliente_id := 1;

  insert into carrito_compras
    (unidades, presentacion_id, cliente_id)
    values (3, 1, v_cliente_id);

  insert into carrito_compras
    (unidades, presentacion_id, cliente_id)
    values (2, 2, v_cliente_id);

  insert into carrito_compras
    (unidades, presentacion_id, cliente_id)
    values (1, 3, v_cliente_id);

  pedir_desde_carrito(v_cliente_id, v_pedido_id);

  select sum(num_disponibles) into v_num_disponibles_antes
    from medicamento_pedido mp
    join inventario_farmacia if2 on mp.farmacia_id = if2.farmacia_id
    where mp.presentacion_id = if2.presentacion_id
      and mp.pedido_id = v_pedido_id;


  dbms_output.put_line(v_pedido_id);

  update pedido
    set status_pedido_id = 2
    where pedido_id = v_pedido_id;

  dbms_output.put_line(v_pedido_id);

  select sum(num_disponibles) into v_num_disponibles_despues
    from medicamento_pedido mp
    join inventario_farmacia if2 on mp.farmacia_id = if2.farmacia_id
    where mp.presentacion_id = if2.presentacion_id
      and mp.pedido_id = v_pedido_id;

  dbms_output.put_line('Stock antes: ' || v_num_disponibles_antes);
  dbms_output.put_line('Stock después: ' || v_num_disponibles_despues);
  dbms_output.put_line('Diferencia' || v_num_disponibles_antes -  v_num_disponibles_despues);


  if v_num_disponibles_antes - v_num_disponibles_despues = 6 then
    dbms_output.put_line('Prueba 1 exitosa!');
  else
    raise_application_error(-20152,' ERROR: El stock no corresponde. Se esperaba una diferencia de 6');
  end if;

  rollback;
end;
/
