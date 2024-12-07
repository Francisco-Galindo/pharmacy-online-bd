--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script para la creación de tablas temporales

create private temporary table ora$ptt_carrito_compras (
  presentacion_id,
  cantidad  number(10,0),
  constraint carrito_compras_presentacion_id_uk unique(presentacion_id),
  constraint carrito_compras_presentacion_id_fk
    foreign key (presentacion_id)
    references presentacion(presentacion_id)
) on commit drop definition;
