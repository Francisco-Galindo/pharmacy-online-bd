define p_pdb='fgmbd_s1'
define p_sys_password='system1'
define p_root_dir='/unam/bd/pharmacy-online-bd'

@&p_root_dir/scripts/s-01-usuarios.sql
@&p_root_dir/scripts/s-05-secuencias.sql
@&p_root_dir/scripts/s-02-entidades.sql
-- @./s-03-tablas-temporales.sql
@&p_root_dir/scripts/s-04-tablas-externas.sql
@&p_root_dir/scripts/s-06-indices.sql
@&p_root_dir/scripts/s-09-carga-inicial.sql
@&p_root_dir/scripts/s-13-p-actualiza-inventario.sql
@&p_root_dir/scripts/s-11-tr-checa-estados-pedido.sql
@&p_root_dir/scripts/s-13-p-ingresa-operacion.sql
