--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script con la definición de un trigger para cumplir con las
--              reglas de negocio referentes a los status de un pedido.

connect gs_proy_admin/gs_proy_admin@&p_pdb

create or replace trigger tr_calcula_importe_pedido
  before
    insert or
    update of es_valido
  on medicamento_pedido
  for each row
declare
  v_precio              presentacion.precio%type;
  v_descuento_cliente   cliente.descuento%type;
begin
  v_precio := get_precio_presentacion(:new.presentacion_id);

  case
  when inserting then
    if :new.es_valido = true then
      update pedido
        set importe = importe + (v_precio * (1 - v_descuento_cliente))
        where pedido_id = :new.pedido_id;
    end if;
  when updating then
    if :old.es_valido = true and :new.es_valido = false then
      update pedido
        set importe = importe - (v_precio * (1 - v_descuento_cliente))
        where pedido_id = :new.pedido_id;
    elsif :old.es_valido = false and :new.es_valido = true then
      update pedido
        set importe = importe + (v_precio * (1 - v_descuento_cliente))
        where pedido_id = :new.pedido_id;
    end if;
  end case;
end;
/

show errors

disconnect;
