REM ################################################################################################################  
REM # Nombre      : CL_ConversorRuta                                                                               #
REM # Sistema     : Windows                                                                                        #
REM # Periodicidad: Diaria                                                                                         #
REM # Reprocesable: SI                                                                                             #
REM # Autor       : Vector Chile                                                                                   #
REM # Objetivo    : Definicion de rutas de trabajo                                                                 #
REM # Proposito   : Otorgar rutas de forma parametrizable                                                          #
REM # Parametros  : N/A                                                                                            #
REM #                                                                                                              #
REM # Modificaciones: No aplica.                                                                                   #
REM #--------------------------------------------------------------------------------------------------------------#
REM # Autor                          Fecha                Objetivo                                                 #
REM #--------------------------------------------------------------------------------------------------------------#
REM # XXXXXXXXXXXXXXXXXX           YYYY/MM/DD          XXXXXXXXXXXXXXXXXX                                          #
REM # ------------------           ----------          ------------------                                          #
REM ################################################################################################################ 

@ECHO Off

REM #--------------------------------------------------------------------------------------------------------------#
REM # Rutas interfaces                                                                                             #                                                     
REM #--------------------------------------------------------------------------------------------------------------#

SET HOME=c:\conversor
SET RUTA_IN=\In
SET RUTA_OUT=\Out
SET RUTA_PROCESADOS=\Proc
SET RUTA_PROC_OK=\Proc_OK
SET RUTA_Proc_Error=\Proc_Error
SET RUTA_PROC_ERROR2=\Proc_Error_No_Cont
SET RUTA_ERROR=\Error
SET RUTA_TEMP=\probando\temporal

REM #--------------------------------------------------------------------------------------------------------------#
REM # Rutas ejecutables Y Log                                                                                      #
REM #--------------------------------------------------------------------------------------------------------------#

SET RUTA_JAVA=\Java
SET RUTA_JAVA_FUENTES=\Config\Properties
SET RUTA_BAT=\Bat
SET RUTA_LOG=\Log
set RUTA_BAT_LOG=\Bat_log
set RUTA_JAVA_LOG=\Java_log
SET RUTA_RAR=\Program Files (x86)\WinRAR
