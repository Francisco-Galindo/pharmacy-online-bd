--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script con la definición de una función que devuelve el precio
--              de una presentación de un medicamento.

create or replace function get_precio_presentacion (
  p_presentacion_id presentacion.presentacion_id%type
) return presentacion.precio%type is
  v_precio    presentacion.precio%type;
begin
  begin
    select precio into v_precio
      from presentacion
      where presentacion_id = p_presentacion_id;
    return v_precio;

  exception
    when no_data_found then
    return -1;

  end;
end;
/
show errors
