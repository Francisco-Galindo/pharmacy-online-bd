--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script con la definición de un procedimiento que ingresa los
--              documentos de cada almacén.

connect gs_proy_admin/gs_proy_admin@&p_pdb

set serveroutput on

create or replace procedure carga_archivo_almacen is
  v_blob   blob;
  cursor cur_almacenes is select centro_operaciones_id from almacen;
begin
  for r in cur_almacenes loop
    begin
      v_blob := get_blob (r.centro_operaciones_id || '.pdf');
      dbms_output.put_line(dbms_lob.getlength(v_blob));
      update almacen
        set documento = v_blob
        where centro_operaciones_id = r.centro_operaciones_id;
    exception
      when others then
        continue;
    end;
  end loop;
end;
/
show errors

begin
  carga_archivo_almacen();
end;
/

select centro_operaciones_id, documento from almacen;
