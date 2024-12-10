--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script con la definición de una función que devuelve un
--              responsable aleatorio para un pedido.

create or replace function elegir_responsable_random
return presentacion.precio%type is
  v_responsable_id    empleado.empleado_id%type;
begin
  select empleado_id into v_responsable_id
    from empleado
    where centro_operaciones_id in (
      select centro_operaciones_id
      from centro_operaciones co
      where es_almacen = true
    )
    order by dbms_random.random
    fetch first 1 rows only;

  return v_responsable_id;
end;
/
show errors
