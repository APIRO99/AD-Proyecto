/*
IMPORTANTE!!!
-------------
ESTE SCRIPT ASUME QUE CUENTA CON UN DIRECTORIO EN SU COMPUTADORA
UBICADO EN "C:\TEMP" DONDE ESTA EL ARCHIVO DE BACKUP Y DONDE
SE CREARAN LAS BASES DE DATOS, SI NO EXISTE ASEGURESE DE CREARLO PREVIAMENTE!!!!
*/
Restore database RepuestosWebDWH from disk = 'c:\temp\RepuestosWebDWH.bak' WITH 
MOVE 'RepuestosWebDWH' to 'c:\temp\RepuestosWebDWH.mdf',
MOVE 'RepuestosWebDWH_log' to 'c:\temp\RepuestosWebDWH_log.ldf'
