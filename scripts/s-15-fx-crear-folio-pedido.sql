--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script con la definición de una función que crea un folio para
--              un nuevo pedido. Se asegura de que este folio no esté repetido

create or replace function crear_folio_pedido (
  p_cliente_id      number,
  p_responsable_id  number,
  p_fecha           date
) return varchar2 is
  v_folio             pedido.folio%type;
  v_cliente_curp      cliente.curp%type;
  v_responsable_rfc   empleado.rfc%type;
  v_count             number(10,0);
begin
  select curp into v_cliente_curp
    from cliente
    where cliente_id = p_cliente_id;
  select rfc into v_responsable_rfc
    from empleado
    where empleado_id = p_responsable_id;

  v_folio := substr(v_cliente_curp, 1, 4) || '-' ||
             to_char(p_fecha, 'ddyy') ||
             substr(v_responsable_rfc, 1, 4);

  select count(*) into v_count from pedido where folio = v_folio;
  while v_count > 0 loop

    v_folio := substr(v_cliente_curp, 1, 4) || '-' ||
             dbms_random.string('X', 4) ||
             substr(v_responsable_rfc, 1, 4);
    select count(*) into v_count from pedido where folio = v_folio;
  end loop;

  return v_folio;
end;
/
show errors
