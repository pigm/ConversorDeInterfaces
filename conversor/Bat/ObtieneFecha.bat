REM ################################################################################################################   
REM # Nombre      : ObtieneFecha.bat                                                                               #   
REM # Sistema     : Windows                                                                                        #   
REM # Periodicidad: Diaria                                                                                         #   
REM # Reprocesable: SI                                                                                             #   
REM # Autor       : Vector Chile                                                                                   #   
REM # Objetivo    : Entregar fecha                                                                                 #   
REM # Proposito   : Entregar fecha de procesamiento menos 7 dias (Ejemplo : 20170801 - 7 = 20180725)               #
REM #               Este proceso es capaz de restar o sumar dias a la fecha de procesamiento entregada             #                                                                                               #   
REM # Parametros  : %1  - Fecha de procesamiento                                                                   #   
REM #               %2  - Dias a sumar o restar a la fecha de procesamiento
REM # Modificaciones: No aplica.                                                                                   #   
REM #--------------------------------------------------------------------------------------------------------------#   
REM # Autor                          Fecha                Objetivo                                                 #   
REM #--------------------------------------------------------------------------------------------------------------#   
REM # XXXXXXXXXXXXXXXXXX           YYYY/MM/DD          XXXXXXXXXXXXXXXXXX                                          #   
REM # ------------------           ----------          ------------------                                          #   
REM ################################################################################################################   

@echo off

setlocal ENABLEEXTENSIONS
call :dias %1
set /a j+=%2
call :inc %j%
echo %dd%/%mm%/%yy%
endlocal
goto :EOF

:dias
for /f "tokens=1,2,3 delims=-/." %%a in ("%1") do (
   set dd=%%a&set mm=%%b&set yy=%%c)
set /a dd=100%dd%%%100,mm=100%mm%%%100
set /a z=14-mm,z/=12,y=yy+4800-z,m=mm+12*z-3,j=153*m+2
set /a j=j/5+dd+y*365+y/4-y/100+y/400-2472633
goto :EOF

:inc
set /a a=%1+2472632,b=4*a+3,b/=146097,c=-b*146097,c/=4,c+=a
set /a d=4*c+3,d/=1461,e=-1461*d,e/=4,e+=c,m=5*e+2,m/=153,dd=153*m+2,dd/=5
set /a dd=-dd+e+1,mm=-m/10,mm*=12,mm+=m+3,yy=b*100+d-4800+m/10
(if %mm% LSS 10 set mm=0%mm%)&(if %dd% LSS 10 set dd=0%dd%)
goto :EOF


