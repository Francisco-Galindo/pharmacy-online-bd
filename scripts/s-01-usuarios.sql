--@Autor(es): Francisco Galindo, Andrea Saldaña
--@Fecha creación: 03/12/2024
--@Descripción: Script para la creación de los usuarios utilizados en el proyecto


prompt Conectando a la pdb
connect sys/&p_sys_password@&p_pdb as sysdba


prompt Creando roles

drop role if exists rol_admin;
create role rol_admin;
grant
  create session,
  create table,
  create view,
  create synonym,
  create sequence,
  create procedure,
  create trigger
to rol_admin;

drop role if exists rol_invitado;
create role rol_invitado;
grant create session to rol_invitado;


prompt Creando usuarios

drop user if exists gs_proy_invitado cascade;
create user gs_proy_invitado identified by gs_proy_invitado quota unlimited on users;
grant rol_invitado to gs_proy_invitado;

drop user if exists gs_proy_admin cascade;
create user gs_proy_admin identified by gs_proy_admin quota unlimited on users;
grant rol_admin to gs_proy_admin;
