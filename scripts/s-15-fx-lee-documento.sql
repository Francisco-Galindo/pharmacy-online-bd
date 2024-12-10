--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script con la definición de una función que crea un folio para
--              un nuevo pedido. Se asegura de que este folio no esté repetido


commit;
connect sys/&p_sys_password@&p_pdb as sysdba

create or replace directory data_dir as '/unam/bd/pharmacy-online-bd/scripts/carga-de-datos/documentos';
grant read on directory data_dir to gs_proy_admin;

connect gs_proy_admin/gs_proy_admin@&p_pdb

!mkdir -p &p_root_dir/scripts/carga-de-datos/documentos
-- !echo 'Este es un texto de prueba hola hola' > /tmp/data_dir/10.txt

set serveroutput on

create or replace function get_blob (
  p_nombre_archivo  varchar2
)
return blob
as
  v_dest_blob   blob;
  v_bfile       bfile;
  v_src_offset  number := 1;
  v_dest_offset number:= 1;
  v_src_length  number;
  v_dest_length number;
begin
  dbms_lob.createtemporary(v_dest_blob, false);
  v_bfile := bfilename('DATA_DIR', p_nombre_archivo);
  if dbms_lob.fileexists(v_bfile) = 1 and not
    dbms_lob.isopen(v_bfile) = 1 then
    dbms_lob.open(v_bfile,dbms_lob.lob_readonly);
  else
    dbms_lob.freetemporary (v_dest_blob);
    raise_application_error(-20001,'El archivo '
      ||p_nombre_archivo
      ||' no existe en el directorio DATA_DIR'
      ||' o el archivo esta abierto');
  end if;

  dbms_lob.fileopen (v_bfile, dbms_lob.file_readonly);
  dbms_lob.loadblobfromfile(
    dest_lob => v_dest_blob,
    src_bfile => v_bfile,
    amount => dbms_lob.getlength(v_bfile),
    dest_offset => v_dest_offset,
    src_offset => v_src_offset);
  dbms_lob.fileclose (v_bfile);

  v_src_length := dbms_lob.getlength(v_bfile);
  v_dest_length := dbms_lob.getlength(v_dest_blob);

  if v_src_length != v_dest_length then
    raise_application_error(-20002,'Error al escribir datos.\n'
      ||' Se esperaba escribir '||v_src_length
      ||' Pero solo se escribio '||v_dest_length);
  end if;

  return v_dest_blob;
end get_blob;
/
show errors
