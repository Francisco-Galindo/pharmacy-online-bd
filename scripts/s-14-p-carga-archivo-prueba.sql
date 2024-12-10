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
prompt Leyendo los archivos de los almacenes
Prompt =========================================================================

Prompt La lista de archivos encontrados es:

begin
  carga_archivo_almacen();
end;
/

column documento format a60
select centro_operaciones_id as almacen_id, documento from almacen;

rollback;
