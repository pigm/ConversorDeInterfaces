REM ################################################################################################################                                   
REM # Nombre      : procesaNominas.bat                                                                             #                                   
REM # Sistema     : Windows                                                                                        #                                   
REM # Periodicidad: Diaria                                                                                         #                                   
REM # Reprocesable: SI                                                                                             #                                   
REM # Autor       : Vector Chile                                                                                   #                                   
REM # Objetivo    : Ejecutar los siguientes procesos:                                                              #                                   
REM #                procesaNominas.jar                                                                            #                                   
REM #                                                                                                              #                                   
REM # Proposito   : Validar existencia de interfaces dentro del servidor del cliente,                              #                                   
REM #               para luego ejecutar un fuente java el cual va a procesar estas                                 #                                   
REM #               interfaces, creando un nueva con el formato correspondiente al                                 #                                   
REM #               del banco                                                                                      #                                   
REM #                                                                                                              #                                   
REM # Parametros  : %1%               - parametro de entrada (Fecha )                                              #                                   
REM # Cod. Retorno: 0 (Proceso exitoso).                                                                           #
REM #               1 (Error grave, faltan directorios, fuente java o archivos esenciales para el proceso).        #
REM #               2 (Error grave, datos, estructura o excede maximo de nominas diarias).                         #
REM #               3 (Error grave, fecha invalida o no informada, mala configuracion archivo de propiedades).     #
REM #               4 (Error no grave, conversor en ejecucion por otro usuario o no existen interfaces a procesar).#
REM #               5 (Error grave, problemas con la ejecucion del fuente java).                                   #
REM #               6 (Error grave, error no controlado por el conversor).                                         #
REM # Modificaciones: No aplica.                                                                                   #                                   
REM #--------------------------------------------------------------------------------------------------------------#                                   
REM # Autor                          Fecha                Objetivo                                                 #                                   
REM #--------------------------------------------------------------------------------------------------------------#                                   
REM # XXXXXXXXXXXXXXXXXX           YYYY/MM/DD          XXXXXXXXXXXXXXXXXX                                          #                                   
REM # ------------------           ----------          ------------------                                          #                                   
REM ################################################################################################################                                   

@ECHO Off
SETLOCAL ENABLEEXTENSIONS
SETLOCAL enabledelayedexpansion

REM #--------------------------------------------------------------------------------------------------------------#
REM # Fecha de sistema , fecha ejecucion (Parametro)                                                               #
REM #--------------------------------------------------------------------------------------------------------------#

SET dd=%date:~0,2%
SET mm=%date:~3,2%
SET yyyy=%date:~6,4%
SET hour=%time:~0,2%
SET min=%time:~3,2%
SET ss=%time:~6,2%
SET dt=%yyyy%%mm%%dd%%hour%%min%%ss%
SET odate=""


REM #--------------------------------------------------------------------------------------------------------------#
REM # Archivo Log                                                                                                  #
REM #--------------------------------------------------------------------------------------------------------------#

SET LogProcesaNomina=\ProcesaNominaBat_%dt%.log
SET LogProcesadosError=\LogProcesadosError_%dt%.log
SET V_LOG_PARM=c:\conversor\Bat\LogParametria_%dt%.log
SET ARCH_PAR=c:\conversor\Bat\procesaNominas_ini.bat

IF NOT EXIST "%ARCH_PAR%" (
ECHO %dt% : Error :                                                                            > %V_LOG_PARM%
ECHO %dt% : No existe el archivo parametrico.                                                 >> %V_LOG_PARM%
ECHO %dt% : Se debe instalar el archivo parametrico:                                          >> %V_LOG_PARM%
ECHO %dt% : %ARCH_PAR%                                                                        >> %V_LOG_PARM%
ECHO %dt% : Fin de la ejecucion                                                               >> %V_LOG_PARM%

exit 1
)

CALL %ARCH_PAR%

REM #--------------------------------------------------------------------------------------------------------------#
REM # Validacion parametro entrada                                                                                 #
REM #--------------------------------------------------------------------------------------------------------------#                                    

if %1%.==. (goto error_parm) else (goto exe_correcta)

:exe_correcta
set odate=%1%
rem @ECHO %dt%

REM #--------------------------------------------------------------------------------------------------------------#
REM # Validacion si java esta en ejecucion                                                                         #
REM #--------------------------------------------------------------------------------------------------------------#

IF EXIST "%HOME%%RUTA_JAVA%\javaEjecuta.txt" (
echo %dt% : Existen ejecuciones en curso  		 >  %V_LOG_PARM%               
echo %dt% : El proceso no puede continuar ....   >> %V_LOG_PARM%                                 
exit 4
)

rem tasklist | find "procesaNominas.jar"
rem echo %errorlevel%

REM #--------------------------------------------------------------------------------------------------------------#
REM # Validacion de directorios                                                                                    #
REM #--------------------------------------------------------------------------------------------------------------#                                    
set v_1=0

ECHO ********************************************************************              >  %V_LOG_PARM%                    
ECHO %dt% : Validando existencia de directorios ...                                    >> %V_LOG_PARM%                    
ECHO.                                                                                  >> %V_LOG_PARM%                    


IF NOT EXIST "%HOME%%RUTA_BAT%" (
ECHO %dt% : No existe directorio %HOME%%RUTA_BAT%                                      >> %V_LOG_PARM%
set v_1=1 
)

IF NOT EXIST "%HOME%%RUTA_ERROR%" (
ECHO %dt% : No existe directorio %HOME%%RUTA_ERROR%                                    >> %V_LOG_PARM%
set v_1=1
)

IF NOT EXIST "%HOME%%RUTA_IN%" (
ECHO %dt% : No existe directorio %HOME%%RUTA_IN%                                       >> %V_LOG_PARM%
set v_1=1
)

IF NOT EXIST "%HOME%%RUTA_JAVA%" (
ECHO %dt% : No existe directorio %HOME%%RUTA_JAVA%                                     >> %V_LOG_PARM%
set v_1=1
)

IF NOT EXIST "%HOME%%RUTA_JAVA%%RUTA_JAVA_FUENTES%" (
ECHO %dt% : No existe directorio %HOME%%RUTA_JAVA%%RUTA_JAVA_FUENTES%                  >> %V_LOG_PARM%
set v_1=1
)

IF NOT EXIST "%HOME%%RUTA_LOG%" (
ECHO %dt% : No existe directorio %HOME%%RUTA_LOG%                                      >> %V_LOG_PARM%
set v_1=1 
)

IF NOT EXIST "%HOME%%RUTA_OUT%" (
ECHO %dt% : No existe directorio %HOME%%RUTA_OUT%                                      >> %V_LOG_PARM%
set v_1=1
)

IF NOT EXIST "%HOME%%RUTA_PROCESADOS%" (
ECHO %dt% : No existe directorio %HOME%%RUTA_PROCESADOS%                               >> %V_LOG_PARM%
set v_1=1
)

IF NOT EXIST "%HOME%%RUTA_PROCESADOS%%RUTA_Proc_Error%" (
ECHO %dt% : No existe directorio %HOME%%RUTA_PROCESADOS%%RUTA_Proc_Error%              >> %V_LOG_PARM%
set v_1=1
)

IF NOT EXIST "%HOME%%RUTA_PROCESADOS%%RUTA_PROC_ERROR2%" (
ECHO %dt% : No existe directorio %HOME%%RUTA_PROCESADOS%%RUTA_PROC_ERROR2%             >> %V_LOG_PARM%
set v_1=1
)


IF NOT EXIST "%HOME%%RUTA_PROCESADOS%%RUTA_PROC_OK%" (
ECHO %dt% : No existe directorio %HOME%%RUTA_PROCESADOS%%RUTA_PROC_OK%                 >> %V_LOG_PARM%
set v_1=1
)

IF NOT EXIST "%HOME%%RUTA_LOG%%RUTA_BAT_LOG%" (
ECHO %dt% : No existe directorio %HOME%%RUTA_PROCESADOS%%RUTA_PROC_OK%                 >> %V_LOG_PARM%
set v_1=1
)

IF NOT EXIST "%HOME%%RUTA_LOG%%RUTA_JAVA_LOG%" (
ECHO %dt% : No existe directorio %HOME%%RUTA_PROCESADOS%%RUTA_PROC_OK%                 >> %V_LOG_PARM%
set v_1=1
)

IF %V_1%==1 (
ECHO.                                                                                  >> %V_LOG_PARM%                    
ECHO %dt% : No es posible continuar ejecucion                                          >> %V_LOG_PARM%                    
ECHO %dt% : Estructura de directorios no corresponde...                                >> %V_LOG_PARM%                    
ECHO ****************************************************************                  >> %V_LOG_PARM%                    
exit 1
)


IF NOT EXIST "%HOME%%RUTA_JAVA%\procesaNominas.jar" (
ECHO .                                                                                 >> %V_LOG_PARM%                    
ECHO %dt% : No existe fuente java:                                                     >> %V_LOG_PARM%                    
ECHO %dt% : %HOME%%RUTA_JAVA%\procesaNominas.jar                                       >> %V_LOG_PARM%                    
ECHO %dt% : Fin de la ejecucion                                                        >> %V_LOG_PARM%                    
exit 1
)

REM #------------------------------------------------------------------------------------------------------------#
REM # Validacion existencia de interfaces a procesar                                                             #    
REM #------------------------------------------------------------------------------------------------------------#
echo .                                                                                 >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
echo ***************************************************************                   >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
echo %dt% : Validacion de ficheros                                                     >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
                
                 
IF EXIST "%HOME%%RUTA_IN%\*.txt" (
echo %dt% : Archivos de nominas encontrados para procesar                              >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
) else (
echo %dt% : No existen archivos de nominas a procesar                                  >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
exit 4
)
                   
REM #------------------------------------------------------------------------------------------------------------#
REM # Ejecucion JAVA                                                                                             #    
REM #------------------------------------------------------------------------------------------------------------#

echo .                                                                                 >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
echo ***************************************************************                   >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
echo %dt% : Inicio de ejecucion de Java                                                >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
echo .                                                                                 >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    

cd %HOME%%RUTA_IN%
set variable=1

FOR %%x in (*.txt) DO  (
cd %HOME%%RUTA_JAVA%
Set ERRORLEVEL=
java -jar procesaNominas.jar %%x %odate%

echo variable=1 >> %HOME%%RUTA_JAVA%\javaEjecuta.txt

if !errorlevel!==0 (
echo .                                                                                 >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina% 
echo %dt% : Ejecucion java con exito                                                   >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
echo %dt% : Archivo %%x procesado                                                      >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
echo %dt% : No hay error en datos de archivo %%x                                       >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
echo %dt% : No hay error en estructura en archivo %%x                                  >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
echo %dt% : Moviendo archivo de entrada a ruta %HOME%%RUTA_PROCESADOS%%RUTA_PROC_OK%   >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
move /Y "%HOME%%RUTA_IN%\%%x" "%HOME%%RUTA_PROCESADOS%%RUTA_PROC_OK%"
)

if !errorlevel!==1 (
echo %variable% >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%\variable.txt
echo .                                                                                  >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina% 
echo %dt% : Error en ejecucion java...                                                  >> %HOME%%RUTA_LOG%%LogProcesadosError%
echo %dt% : Datos de procesamiendo incorrectos en archivo %%x                           >> %HOME%%RUTA_LOG%%LogProcesadosError%
echo %dt% : Codigo de error  : !errorlevel!                                             >> %HOME%%RUTA_LOG%%LogProcesadosError%
echo %dt% : Moviendo archivo a ruta %HOME%%RUTA_PROCESADOS%%RUTA_Proc_Error%            >> %HOME%%RUTA_LOG%%LogProcesadosError%
echo %dt% : Existen errores en la ejecucion                                             >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina% 
echo %dt% : Archivo %%x con problemas                                                   >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina% 
)

if !errorlevel!==2 (
echo %variable% >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%\variable.txt
echo .                                                                                  >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina% 
echo %dt% : Error en ejecucion java...                                                  >> %HOME%%RUTA_LOG%%LogProcesadosError%
echo %dt% : Estructura incorrecta en archivo  %%x                                       >> %HOME%%RUTA_LOG%%LogProcesadosError%
echo %dt% : Codigo de error  : !errorlevel!                                             >> %HOME%%RUTA_LOG%%LogProcesadosError%
echo %dt% : Moviendo archivo a ruta %HOME%%RUTA_PROCESADOS%%RUTA_Proc_Error%            >> %HOME%%RUTA_LOG%%LogProcesadosError%
echo %dt% : Existen errores en la ejecucion                                             >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina% 
echo %dt% : Archivo %%x con problemas                                                   >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina% 
)

if !errorlevel!==3 (
echo .                                                                                  >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina% 
echo %dt% : Ejecucion finalizada                                                        >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
echo %dt% : Se han procesado 999 nominas diaras                                         >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    

IF EXIST "%HOME%%RUTA_IN%\*.txt" (
echo %dt% : Moviendo archivos restantes a ruta %HOME%%RUTA_PROCESADOS%%RUTA_Proc_Error% >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                   
move /Y "%HOME%%RUTA_IN%\*.txt" "%HOME%%RUTA_PROCESADOS%%RUTA_Proc_Error%"
)
del %HOME%%RUTA_JAVA%\javaEjecuta.txt
exit 2
)

if !errorlevel!==4 (
echo %dt% : Error en ejecucion java...                                                  >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
echo %dt% : Fecha ingresada incorrecta                                                  >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
echo %dt% : Formato debe ser YYYYMMDD                                                   >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
del %HOME%%RUTA_JAVA%\javaEjecuta.txt
exit 3
)

if !errorlevel!==5 (
echo %dt% : Error en la ejecucion -> Archivo de parametro mal configurado               >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
echo %dt% : %ARCH_PAR%                                                                  >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
echo %dt% : Codigo 5                                                                    >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
del %HOME%%RUTA_JAVA%\javaEjecuta.txt
exit 3
)

if !errorlevel!==6 (
echo %dt% : Ejecucion java con error                                                    >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%    
del %HOME%%RUTA_JAVA%\javaEjecuta.txt 
exit 5
)

if !errorlevel! GTR 6 (
echo Error en la ejecucion del fuente java                                      >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                        
echo Error no controlado en la ejecucion del fuente java                        >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%        
echo CODIGO: !errorlevel!                                                       >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                     
                                                                                                                                                            
echo *************************************************************************  >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%
echo  Moviendo archivos NO PROCESADO al directorio:                             >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%
echo  %HOME%%RUTA_PROCESADOS%%RUTA_PROC_ERROR2%                                 >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%
echo *************************************************************************  >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%
                                                                                                                                                             
move /Y  "%HOME%%RUTA_IN%\%%x" "%HOME%%RUTA_PROCESADOS%%RUTA_PROC_ERROR2%"  >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%
del %HOME%%RUTA_JAVA%\javaEjecuta.txt 
exit 6
)

IF EXIST "%HOME%%RUTA_LOG%%RUTA_BAT_LOG%\variable.txt" ( 
move /Y "%HOME%%RUTA_IN%\%%x" "%HOME%%RUTA_PROCESADOS%%RUTA_Proc_Error%"
echo .                                                                                   >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina% 
echo *******************************************************************                 >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina% 
echo %dt% : Revisar archivo  %HOME%%RUTA_LOG%%LogProcesadosError%                      >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina% 
echo *******************************************************************                 >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
) 

)
 

cd %HOME%%RUTA_BAT%

REM #------------------------------------------------------------------------------------------------------------#
REM # Los archivos procesador con mas de 7 dias se comprimen en un .rar                                          #
REM # Se borran del directorio Proc, todos los archivos que tenga una antiguedad mayor a 14 dias                 #
REM #------------------------------------------------------------------------------------------------------------#

echo .                                                         >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
echo **********************************************************>> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
echo %dt% : Comprimiendo archivos con antiguedad mayor a 7 dias>> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    

SET GUION=-

call %HOME%%RUTA_BAT%\ObtieneFecha.bat %date% -7 > %HOME%%RUTA_LOG%\fechaRar.txt

FOR /F "tokens=1,2,3 delims=/" %%A IN (%HOME%%RUTA_LOG%\fechaRar.txt) DO ( 
set dia=%%A
set mes=%%B
set ano=%%C
)

forfiles /p "%HOME%%RUTA_PROCESADOS%%RUTA_PROC_OK%" /m *.txt /d -%dia%%GUION%%mes%%GUION%%ano%

if %errorlevel%==0 (
IF NOT EXIST "%HOME%%RUTA_TEMP%" MD "%HOME%%RUTA_TEMP%"
forfiles /p "%HOME%%RUTA_PROCESADOS%%RUTA_PROC_OK%" /m *.txt /d -%dia%%GUION%%mes%%GUION%%ano% /c "cmd /c move @file \"%HOME%%RUTA_TEMP%"" 
goto Comprimir
) else (
 echo %dt% : No hay archivos con antiguedad mayor a 7 dias      >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
 echo %dt% : No se realiza compresion                           >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
 del %HOME%%RUTA_LOG%\fechaRar.txt
 rd /Q %HOME%%RUTA_TEMP% 
goto Continua
)

:Comprimir
cd %RUTA_RAR%

FOR %%x in (%HOME%%RUTA_TEMP%\*.txt) DO  (

RAR a %%x.rar "%%x"

)

move /-Y "%HOME%%RUTA_TEMP%\*.rar" "%HOME%%RUTA_PROCESADOS%%RUTA_PROC_OK%"

del %HOME%%RUTA_LOG%\fechaRar.txt
del %HOME%%RUTA_TEMP%\*.txt
rd /Q %HOME%%RUTA_TEMP%
goto Continua

:Continua
echo .                                                                   >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
echo *****************************************************************   >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
echo %dt% : Borrando archivos con antiguedad mayor a 14 dias             >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    

Forfiles /p %HOME%%RUTA_PROCESADOS%%RUTA_PROC_OK% /m *.rar /s /d -15 /c "cmd /c del /q @path"

if %ERRORLEVEL%==0 (goto borraRar) else (goto noBorraRar)

:borraRar 
 echo %dt% : Se han borrado los archivos .rar                            >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
 echo %dt% : con una antiguedad mayor a 14 dias                          >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
 

:noBorraRar
 echo %dt% : No existen archivos .rar por borrar                         >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
 
IF EXIST "%HOME%%RUTA_LOG%%RUTA_BAT_LOG%\variable.txt" (          
  del %HOME%%RUTA_LOG%%RUTA_BAT_LOG%\variable.txt
  del %HOME%%RUTA_JAVA%\javaEjecuta.txt 
  exit 2
)

 del %HOME%%RUTA_JAVA%\javaEjecuta.txt
 echo .                                                                  >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
 echo %dt% : Proceso finalizado                                          >> %HOME%%RUTA_LOG%%RUTA_BAT_LOG%%LogProcesaNomina%                    
 exit 0
 
:error_parm  
 echo .                                                                  >> %V_LOG_PARM%                    
 echo %dt% : Proceso abortado                                            >> %V_LOG_PARM%                    
 echo %dt% : No se ha ingresado parametro de entrada                     >> %V_LOG_PARM%                    
 exit 3
