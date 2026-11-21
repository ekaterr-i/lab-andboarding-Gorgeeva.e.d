@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

REM ============================================================================
REM Тема работы: Диагностика клиентского компьютера (Практическая работа 8)
REM Выполнил: Фамилия Имя
REM Дата: 21.11.2026
REM ============================================================================

set "REPORT=%~dp0pc_report.txt"

echo ==================================================
echo Диагностика компьютера
echo ==================================================
echo.

echo ================================================== > "%REPORT%"
echo Диагностика компьютера >> "%REPORT%"
echo ================================================== >> "%REPORT%"
echo. >> "%REPORT%"

REM --- 1. Сведения об операционной системе ---
echo [Операционная система]
echo [Операционная система] >> "%REPORT%"
for /f "usebackq delims=" %%I in (`powershell -NoProfile -Command "$os = Get-CimInstance Win32_OperatingSystem; '{0} (Версия: {1})' -f $os.Caption, $os.Version"`) do (
    echo %%I
    echo %%I >> "%REPORT%"
)
echo.
echo. >> "%REPORT%"

REM --- 2. Сведения о процессоре ---
echo [Процессор]
echo [Процессор] >> "%REPORT%"
for /f "usebackq delims=" %%I in (`powershell -NoProfile -Command "(Get-CimInstance Win32_Processor | Select-Object -First 1).Name"`) do (
    echo %%I
    echo %%I >> "%REPORT%"
)
echo.
echo. >> "%REPORT%"

REM --- 3. Сведения об оперативной памяти ---
echo [Оперативная память]
echo [Оперативная память] >> "%REPORT%"
for /f "usebackq tokens=1,2 delims=;" %%A in (`powershell -NoProfile -Command "$os = Get-CimInstance Win32_OperatingSystem; '{0};{1}' -f [math]::Round($os.TotalVisibleMemorySize / 1MB, 1), [math]::Round($os.FreePhysicalMemory / 1MB, 1)"`) do (
    echo Всего памяти: %%A ГБ
    echo Свободно памяти: %%B ГБ
    echo Всего памяти: %%A ГБ >> "%REPORT%"
    echo Свободно памяти: %%B ГБ >> "%REPORT%"
)
echo.
echo. >> "%REPORT%"

REM --- 4. Свободное место на диске C ---
echo [Диск C]
echo [Диск C] >> "%REPORT%"
for /f "usebackq tokens=1,2 delims=;" %%A in (`powershell -NoProfile -Command "$d = Get-CimInstance Win32_LogicalDisk -Filter \"DeviceID='C:'\"; '{0};{1}' -f [math]::Round($d.Size / 1GB, 1), [math]::Round($d.FreeSpace / 1GB, 1)"`) do (
    echo Общий размер: %%A ГБ
    echo Свободно места: %%B ГБ
    echo Общий размер: %%A ГБ >> "%REPORT%"
    echo Свободно места: %%B ГБ >> "%REPORT%"
)
echo.
echo. >> "%REPORT%"

REM --- 5. Список установленных программ ---
echo [Установленные программы]
echo [Установленные программы] >> "%REPORT%"
echo Идёт сбор списка программ из реестра...

set "TEMP_LIST=%TEMP%\raw_apps.txt"
if exist "%TEMP_LIST%" del /f /q "%TEMP_LIST%"

for /f "tokens=1,2,*" %%A in ('reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName 2^>nul ^| findstr /i "DisplayName"') do (
    if not "%%C"=="" echo %%C >> "%TEMP_LIST%"
)
for /f "tokens=1,2,*" %%A in ('reg query "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName 2^>nul ^| findstr /i "DisplayName"') do (
    if not "%%C"=="" echo %%C >> "%TEMP_LIST%"
)

for /f "usebackq delims=" %%I in (`powershell -NoProfile -Command "Get-Content '%TEMP_LIST%' | Sort-Object -Unique"`) do (
    echo - %%I
    echo - %%I >> "%REPORT%"
)
if exist "%TEMP_LIST%" del /f /q "%TEMP_LIST%"

echo.
echo ==================================================
echo Отчёт сохранён в файл: %REPORT%
echo ==================================================
pause



