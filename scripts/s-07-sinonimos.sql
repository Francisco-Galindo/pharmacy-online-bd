--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script para la creación de sinónimos

prompt Conectando como usuario gs_proy_admin
connect gs_proy_admin/gs_proy_admin@&p_pdb

/*
 * Se crean sinónimos públicos usando como criterio la longitud del nombre de la tabla
 * seleccionamos aquellas con los nombres más largos
 */

 create or replace public synonym centro_operaciones 
    for  gs_proy_admin.centro_operaciones;

 create or replace public synonym sustancia_activa
    for gs_proy_admin.sustancia_activa;

 create or replace public synonym medicamento_nombre
    for gs_proy_admin.medicamento_nombre;

 create or replace public synonym tarjeta_credito
    for gs_proy_admin.tarjeta_credito;

 create or replace public synonym status_pedido
    for gs_proy_admin.status_pedido;

 create or replace public synonym historial_pedido_status
    for gs_proy_admin.historial_pedido_status;

 create or replace public synonym ubicacion_pedido
    for gs_proy_admin.ubicacion_pedido;

 create or replace public synonym medicamento_pedido
    for gs_proy_admin.medicamento_pedido;

 create or replace public synonym medicamento_operacion
    for gs_proy_admin.medicamento_operacion;

 create or replace public synonym inventario_farmacia
    for gs_proy_admin.inventario_farmacia;

/*
 * Se otorgan permisos de lectura al usuario invitado para consultar
 * el contenido de las tablas
 */

 grant select on centro_operaciones to gs_proy_invitado;

 grant select on sustancia_activa to gs_proy_invitado;

 grant select on medicamento_nombre to gs_proy_invitado;

 grant select on tarjeta_credito to gs_proy_invitado;

 grant select on status_pedido to gs_proy_invitado;

 grant select on historial_pedido_status to gs_proy_invitado;

 grant select on ubicacion_pedido to gs_proy_invitado;

 grant select on medicamento_pedido to gs_proy_invitado;

 grant select on medicamento_operacion to gs_proy_admin;

 grant select on inventario_farmacia to gs_proy_invitado;

/*
 * Se crean los sinónimos utilizando al usuario gs_proy_invitado
 * para las tablas a las que se le dio acceso anteriormente
 */
 
 --Se le otorgan privilegios al invitado para crear sinónimos

 prompt Conectando como el usuario sys
 connect sys/&p_sys_password@&p_pdb as sysdba

 grant create synonym to gs_proy_invitado;

 prompt Conectando como el usuario invitado
 connect gs_proy_invitado/gs_proy_invitado@&p_pdb

 create or replace synonym centro 
    for centro_operaciones;

 create or replace synonym sustancia 
    for sustancia_activa;

 create or replace synonym nombre_med
    for medicamento_nombre;

 create or replace synonym tarjeta
    for tarjeta_credito;

 create or replace synonym estatus
    for status_pedido;

 create or replace synonym hist_status_pedido
    for historial_pedido_status;

 create or replace synonym ubicacion
    for ubicacion_pedido;

 create or replace synonym pedido_med
    for medicamento_pedido;

 create or replace synonym operacion_med
    for medicamento_operacion;

 create or replace synonym inventario
    for inventario_farmacia;

 --Se le retira el privilegio al usuario invitado para crear sinónimos

 prompt Conectando como el usuario sys
 connect sys/&p_sys_password@&p_pdb as sysdba

 revoke create synonym from gs_proy_invitado;

/*
 * Programa anónimo PL/SQL que asigna el prefijo solicitado a
 * todas las tablas.
 */
 
 prompt Conectando como el usuario administrador 
 connect gs_proy_admin/gs_proy_admin@&p_pdb

 declare 

   prefijo varchar2(10) := 'GS' || '_';
   instruccion varchar2(400);

 begin
   
   for tabla in (

      select table_name
      from user_tables

   ) loop

      instruccion := 'create synonym '  || prefijo || tabla.table_name
                     || ' for ' || tabla.table_name;

      execute immediate instruccion;

      end loop; 

   end;

   /

 disconnect
