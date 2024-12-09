--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script para llenar el historial de status de los pedidos

/*
 * Como no encontramos a tiempo una manera buena y rápida de poblar el
 * historico con valores que tuvieran sentido, lo hicimos con fuerza bruta. Nos
 * estamos apoyando en un trigger que garantiza el cumplimiento de las reglas
 * de negocio para que de muchos valores aleatorios, sólo se acepten nuevos
 * registros válidos.
 */

set serveroutput on

prompt Poblando historico de status de pedidos...

declare
  var_pedido_id         number(10,0);
  var_status_pedido_id  number(10,0);
  var_fecha_status      date;
begin
  -- LOL
  for i in 1..20000 loop
    begin

      select dbms_random.value(1,1000) into var_pedido_id;
      -- Sesgando a valores menores
      select least(dbms_random.value(2,5), dbms_random.value(2,5),
        dbms_random.value(3,5)) into var_status_pedido_id;
      select timestamp '2024-12-01 08:00:00' +
         dbms_random.value * (timestamp '2024-12-07 17:59:59' -
                     timestamp '2024-12-01 08:00:00') into var_fecha_status;

      update pedido
        set status_pedido_id = var_status_pedido_id,
          fecha_status = var_fecha_status
        where pedido_id = var_pedido_id;

    exception
      when others then
        continue;
    end;
  end loop;
end;
/

prompt Se ha poblado la tabla historico_status_pedido
