:Sorry for shit code windows batch scripting is shit
:Made by pidjan
:Thanks to BoringBoredom for .jsx code of proper fps cap calculator.
@echo off
title Proper Fps Cap Calculator
setlocal enabledelayedexpansion
set /p hz=Your current monitor refresh rate:
set /p max=Max FPS Limit:

SET "nan1="&for /f "delims=0123456789" %%i in ("%hz%") do set nan1=%%i
SET "nan2="&for /f "delims=0123456789" %%i in ("%max%") do set nan2=%%i
if defined nan1 ( goto :incorrect )
if defined nan2 ( goto :incorrect )
if !hz! leq 1 ( goto :incorrect )
if !max! leq 1 ( goto :incorrect )

del /f /s /q viableFpsCaps.temp_var >nul 2>&1

set multiplier=1
set divider=1
set cap=
:loop1

set /a cap=%hz% * %multiplier%

if %cap% gtr %max% (
  goto :loop2
)
if !cap! geq 1 (
  echo %cap% >> viableFpsCaps.temp_var
)
set /a multiplier=%multiplier% + 1

goto :loop1
set executed=0
:loop2
set /a modulus=%hz% %% %divider%
if %modulus% equ 0 (
  set /a cap=%hz% / %divider%
  
  if !cap! lss 1 (
    goto :finish
  )

  if %cap% leq %max% (
    echo %cap% >> viableFpsCaps.temp_var
  )

  if !cap! equ 1 (
    goto :finish
  ) 
)

set /a divider = %divider% + 1
goto :loop2

:finish 
sort /UNIQUE viableFpsCaps.temp_var /O viableFpsCaps.temp_var2
del /f /s /q viableFpsCaps.temp_var >nul 2>&1 
for /f %%i in (viableFpsCaps.temp_var2) do (
  set FpsCaps=!FpsCaps! %%i
)
del /f /s /q viableFpsCaps.temp_var2 >nul 2>&1

set i=0
for %%n in (%FpsCaps%) do (
    set /a i+=1
    set "num[!i!]=%%n"
)
set "sortedFpsCaps="
for /l %%i in (1,1,%i%) do (
    for /l %%j in (%%i,1,%i%) do (
        if !num[%%i]! gtr !num[%%j]! (
            set "temp=!num[%%i]!"
            set "num[%%i]=!num[%%j]!"
            set "num[%%j]=!temp!"
        )
    )
    set "sortedFpsCaps=!sortedFpsCaps! !num[%%i]!"
)
set "sortedFpsCaps=%sortedFpsCaps:~1%"
set "sortedFpsCaps=%sortedFpsCaps: =, %"
echo.
echo Viable FPS Caps:
echo %sortedFpsCaps%
echo.
pause
exit


:incorrect
echo. Incorrect refresh rate and/or max fps limit passed.
timeout /t 3 >nul 2>&1
exit
