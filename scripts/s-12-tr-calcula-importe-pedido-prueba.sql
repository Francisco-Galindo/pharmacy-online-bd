--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script para validación del funcionamiento del trigger
--              tr_calcula_importe_pedido_prueba.sql

set serveroutput on

commit;

Prompt =========================================================================
Prompt Prueba 1.
prompt Ingresando un nuevo pedido con una unidad de cada medicamento
Prompt =========================================================================

Prompt El importe debería ser la suma de los precios de todos los medicamentos

declare
  v_cliente_id      number(10,0);
  v_total_esperado  number(8,2);
  v_total_obtenido  number(8,2);
  v_descuento       number(8,2);
  v_pedido_id       number(10,0);
begin
  v_cliente_id := 1;

  insert into carrito_compras
    (unidades, presentacion_id, cliente_id)
    values (1, 1, v_cliente_id);

  insert into carrito_compras
    (unidades, presentacion_id, cliente_id)
    values (1, 2, v_cliente_id);

  insert into carrito_compras
    (unidades, presentacion_id, cliente_id)
    values (1, 3, v_cliente_id);

  select sum(precio) into v_total_esperado
    from presentacion
    where presentacion_id in (1, 2, 3);

  pedir_desde_carrito(v_cliente_id, v_pedido_id);


  select importe into v_total_obtenido from pedido where pedido_id = v_pedido_id;

  select descuento into v_descuento from cliente where cliente_id = v_cliente_id;

  v_total_esperado := v_total_esperado * (1 - v_descuento);

  dbms_output.put_line('importe obtenido: ' || v_total_obtenido);
  dbms_output.put_line('importe esperado: ' || v_total_esperado);
  if v_total_obtenido - v_total_esperado = 0 then
    dbms_output.put_line('Prueba 1 exitosa!');
  else
    raise_application_error(-20151,' ERROR: Los importes no corresponden');
  end if;

  rollback;
end;
/

Prompt =========================================================================
Prompt Prueba 2.
prompt Ingresando un nuevo pedido con diferentes cantidades por medicamento
Prompt =========================================================================

Prompt El importe debería ser la suma de los precios de todos los medicamentos

declare
  v_cliente_id      number(10,0);
  v_total_esperado  number(8,2);
  v_total_obtenido  number(8,2);
  v_descuento       number(8,2);
  v_pedido_id       number(10,0);
begin
  v_cliente_id := 1;

  insert into carrito_compras
    (unidades, presentacion_id, cliente_id)
    values (2, 1, v_cliente_id);

  insert into carrito_compras
    (unidades, presentacion_id, cliente_id)
    values (1, 2, v_cliente_id);

  insert into carrito_compras
    (unidades, presentacion_id, cliente_id)
    values (3, 3, v_cliente_id);

  select sum(precio*unidades) into v_total_esperado
    from presentacion p
    join carrito_compras c on p.presentacion_id = c.presentacion_id
    where p.presentacion_id in (1, 2, 3)
      and cliente_id = v_cliente_id;

  pedir_desde_carrito(v_cliente_id, v_pedido_id);
  select importe into v_total_obtenido from pedido where pedido_id = v_pedido_id;

  select descuento into v_descuento from cliente where cliente_id = v_cliente_id;

  v_total_esperado := v_total_esperado * (1 - v_descuento);

  dbms_output.put_line('importe obtenido: ' || v_total_obtenido);
  dbms_output.put_line('importe esperado: ' || v_total_esperado);
  if v_total_obtenido - v_total_esperado = 0 then
    dbms_output.put_line('Prueba 2 exitosa!');
  else
    raise_application_error(-20151,' ERROR: Los importes no corresponden');
  end if;

  rollback;
end;
/
