:Sorry for shit code windows batch scripting is shit
:Made by pidjan
:Thanks to BoringBoredom for .jsx code of proper fps cap calculator.
@echo off
title viable fps limit calc
setlocal enabledelayedexpansion
set /p hz=current monitor refresh rate:
set /p max=max FPS limit:
echo %hz%%max% | findstr /r "^[1-9][0-9]*$">nul
if %errorlevel% neq 0 ( call :incorrect "argument is NaN" )
if !hz! leq 1 ( call :incorrect "invalid monitor refresh rate passed" )
if !max! leq 1 ( call  :incorrect "invalid max fps limit passed" )
if !hz! geq 1000 ( call :incorrect "invalid monitor refresh rate passed" )
if !max! geq 10000 ( call :incorrect "invalid max fps limit passed")
del /f /s /q table.tmp >nul 2>&1

set multiplier=1
set divider=1
set cap=
:loop1

set /a cap=%hz% * %multiplier%

if %cap% gtr %max% (
  goto :loop2
)
if !cap! geq 1 (
  echo %cap% >> table.tmp
)
set /a multiplier=%multiplier% + 1

goto :loop1
:loop2
set /a modulus=%hz% %% %divider%
if %modulus% equ 0 (
  set /a cap=%hz% / %divider%
  
  if !cap! lss 1 (
    goto :finish
  )

  if %cap% leq %max% (
    echo %cap% >> table.tmp
  )

  if !cap! equ 1 (
    goto :finish
  ) 
)

set /a divider = %divider% + 1
goto :loop2

:finish 
sort /UNIQUE table.tmp /O table_sorted.tmp
del /f /s /q table.tmp >nul 2>&1 
for /f %%i in (table_sorted.tmp) do (
  set table=!table! %%i
)
del /f /s /q table_sorted.tmp >nul 2>&1

set i=0
for %%n in (%table%) do (
    set /a i+=1
    set "num[!i!]=%%n"
)
set "sorted_table="
for /l %%i in (1,1,%i%) do (
    for /l %%j in (%%i,1,%i%) do (
        if !num[%%i]! gtr !num[%%j]! (
            set "temp=!num[%%i]!"
            set "num[%%i]=!num[%%j]!"
            set "num[%%j]=!temp!"
        )
    )
    set "sorted_table=!sorted_table! !num[%%i]!"
)
set "sorted_table=%sorted_table:~1%"
set "sorted_table=%sorted_table: = ^| %"
echo.
echo viable fps limit table:
echo [ 1 ^| %sorted_table% ]
echo.
pause
exit


:incorrect "error"
echo error: %~1
timeout /t 3 >nul 2>&1
exit
