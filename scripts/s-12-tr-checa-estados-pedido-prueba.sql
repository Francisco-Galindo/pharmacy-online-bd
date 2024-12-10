--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script para validación del funcionamiento del trigger
--              tr_calcula_import.sql

set serveroutput on

commit;


Prompt =========================================================================
Prompt Prueba 1.
prompt Siguiendo una secuencia normal de entrega.
Prompt =========================================================================

declare
  v_codigo  number;
	v_mensaje varchar2(1000);
begin

  update pedido
    set status_pedido_id = (
      select status_pedido_id from status_pedido
      where clave = 'EN_TRANSITO'
    )
    where pedido_id = 999;


  update pedido
    set status_pedido_id = (
      select status_pedido_id from status_pedido
      where clave = 'ENTREGADO'
    )
    where pedido_id = 999;

  dbms_output.put_line('Prueba 1 exitosa!');
  rollback;

exception
  when others then
    v_codigo := sqlcode;
    v_mensaje := sqlerrm;
    dbms_output.put_line('Codigo:  ' || v_codigo);
    dbms_output.put_line('Mensaje: ' || v_mensaje);
    raise_application_error(-20152,
      'La prueba ha fallado, ocurrió una excepción inesperada');
end;
/

Prompt =========================================================================
Prompt Prueba 2.
prompt Siguiendo una secuencia normal de cancelación.
Prompt =========================================================================

declare
  v_codigo  number;
	v_mensaje varchar2(1000);
begin
  update pedido
    set status_pedido_id = (
      select status_pedido_id from status_pedido
      where clave = 'EN_TRANSITO'
    )
    where pedido_id = 999;


  update pedido
    set status_pedido_id = (
      select status_pedido_id from status_pedido
      where clave = 'CANCELADO'
    )
    where pedido_id = 999;

  dbms_output.put_line('Prueba 2 exitosa!');
  rollback;
exception
  when others then
    v_codigo := sqlcode;
    v_mensaje := sqlerrm;
    dbms_output.put_line('Codigo:  ' || v_codigo);
    dbms_output.put_line('Mensaje: ' || v_mensaje);
    raise_application_error(-20152,
      'La prueba ha fallado, ocurrió una excepción inesperada');
end;
/

Prompt =========================================================================
Prompt Prueba 3.
prompt Siguiendo otra secuencia normal de cancelación.
Prompt =========================================================================

declare
  v_codigo  number;
	v_mensaje varchar2(1000);
begin
  update pedido
    set status_pedido_id = (
      select status_pedido_id from status_pedido
      where clave = 'CANCELADO'
    )
    where pedido_id = 999;

  dbms_output.put_line('Prueba 3 exitosa!');
  rollback;
exception
  when others then
    v_codigo := sqlcode;
    v_mensaje := sqlerrm;
    dbms_output.put_line('Codigo:  ' || v_codigo);
    dbms_output.put_line('Mensaje: ' || v_mensaje);
    raise_application_error(-20152,
      'La prueba ha fallado, ocurrió una excepción inesperada');
end;
/

Prompt =========================================================================
Prompt Prueba 4.
prompt Secuencia en la que se devuelve el pedido
Prompt =========================================================================

declare
  v_codigo  number;
	v_mensaje varchar2(1000);
begin
  update pedido
    set status_pedido_id = (
      select status_pedido_id from status_pedido
      where clave = 'EN_TRANSITO'
    )
    where pedido_id = 999;

  update pedido
    set status_pedido_id = (
      select status_pedido_id from status_pedido
      where clave = 'ENTREGADO'
    )
    where pedido_id = 999;

  update pedido
    set status_pedido_id = (
      select status_pedido_id from status_pedido
      where clave = 'DEVUELTO'
    )
    where pedido_id = 999;

  dbms_output.put_line('Prueba 4 exitosa!');
  rollback;
exception
  when others then
    v_codigo := sqlcode;
    v_mensaje := sqlerrm;
    dbms_output.put_line('Codigo:  ' || v_codigo);
    dbms_output.put_line('Mensaje: ' || v_mensaje);
    raise_application_error(-20152,
      'La prueba ha fallado, ocurrió una excepción inesperada');
end;
/

Prompt =========================================================================
Prompt Prueba 5.
prompt Secuencia INVALIDA donde se devuelve un pedido que no ha sido entregado
Prompt =========================================================================

declare
  v_codigo  number;
	v_mensaje varchar2(1000);
begin
  update pedido
    set status_pedido_id = (
      select status_pedido_id from status_pedido
      where clave = 'EN_TRANSITO'
    )
    where pedido_id = 999;

  update pedido
    set status_pedido_id = (
      select status_pedido_id from status_pedido
      where clave = 'DEVUELTO'
    )
    where pedido_id = 999;

    raise_application_error(-20152,
      'El trigger no está funcionando, permite secuencias inválidas');
exception
  when others then
    v_codigo := sqlcode;
    v_mensaje := sqlerrm;
    dbms_output.put_line('Codigo:  ' || v_codigo);
    dbms_output.put_line('Mensaje: ' || v_mensaje);

    if v_codigo = -20102 then
      dbms_output.put_line('Prueba 5 exitosa!');
    end if;
    rollback;
end;
/

Prompt =========================================================================
Prompt Prueba 5.
prompt Secuencia INVALIDA donde se cancela un pedido que ya se entregó
Prompt =========================================================================

declare
  v_codigo  number;
	v_mensaje varchar2(1000);
begin
  update pedido
    set status_pedido_id = (
      select status_pedido_id from status_pedido
      where clave = 'EN_TRANSITO'
    )
    where pedido_id = 999;

  update pedido
    set status_pedido_id = (
      select status_pedido_id from status_pedido
      where clave = 'ENTREGADO'
    )
    where pedido_id = 999;

  update pedido
    set status_pedido_id = (
      select status_pedido_id from status_pedido
      where clave = 'CANCELADO'
    )
    where pedido_id = 999;

    raise_application_error(-20152,
      'El trigger no está funcionando, permite secuencias inválidas');
exception
  when others then
    v_codigo := sqlcode;
    v_mensaje := sqlerrm;
    dbms_output.put_line('Codigo:  ' || v_codigo);
    dbms_output.put_line('Mensaje: ' || v_mensaje);

    if v_codigo = -20102 then
      dbms_output.put_line('Prueba 6 exitosa!');
    end if;
    rollback;
end;
/
Prompt =========================================================================
Prompt Prueba 7.
prompt Secuencia INVALIDA donde se _reinicia_ un pedido
Prompt =========================================================================

declare
  v_codigo  number;
	v_mensaje varchar2(1000);
begin
  update pedido
    set status_pedido_id = (
      select status_pedido_id from status_pedido
      where clave = 'EN_TRANSITO'
    )
    where pedido_id = 999;

  update pedido
    set status_pedido_id = (
      select status_pedido_id from status_pedido
      where clave = 'CAPTURADO'
    )
    where pedido_id = 999;


    raise_application_error(-20152,
      'El trigger no está funcionando, permite secuencias inválidas');
exception
  when others then
    v_codigo := sqlcode;
    v_mensaje := sqlerrm;
    dbms_output.put_line('Codigo:  ' || v_codigo);
    dbms_output.put_line('Mensaje: ' || v_mensaje);

    if v_codigo = -20102 then
      dbms_output.put_line('Prueba 6 exitosa!');
    end if;
    rollback;
end;
/
