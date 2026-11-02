REM Тема: Диагностика клиентского компьютера | Автор: [Ваша Фамилия] | Дата: 02.11.2026
@echo off
chcp 65001 > nul

REM 8. Настройка путей для файла отчета
set "report_file=%~dp0pc_report.txt"

REM Инициализация/очистка старого отчета при новом запуске
echo ========================================= > "%report_file%"

REM 2. Каркас программы и заголовок
echo =========================================
echo           ДИАГНОСТИКА КОМПЬЮТЕРА
echo =========================================
echo           ДИАГНОСТИКА КОМПЬЮТЕРА >> "%report_file%"
echo ========================================= >> "%report_file%"
echo.
echo. >> "%report_file%"

REM 3. Сведения об операционной системе
echo [Операционная система]
echo [Операционная система] >> "%report_file%"
for /f "tokens=2 delims==" %%i in ('wmic os get Caption /value 2^>nul') do (
    if not "%%i"=="" (
        echo Название: %%i
        echo Название: %%i >> "%report_file%"
    )
)
for /f "tokens=2 delims==" %%i in ('wmic os get Version /value 2^>nul') do (
    if not "%%i"=="" (
        echo Версия:   %%i
        echo Версия:   %%i >> "%report_file%"
    )
)
echo.
echo. >> "%report_file%"

REM 4. Сведения о процессоре
echo [Процессор]
echo [Процессор] >> "%report_file%"
for /f "tokens=2 delims==" %%i in ('wmic cpu get Name /value 2^>nul') do (
    if not "%%i"=="" (
        echo Модель:   %%i
        echo Модель:   %%i >> "%report_file%"
    )
)
echo.
echo. >> "%report_file%"

REM 5. Сведения об оперативной памяти
echo [Оперативная память]
echo [Оперативная память] >> "%report_file%"
for /f "tokens=2 delims==" %%i in ('wmic os get TotalVisibleMemorySize /value 2^>nul') do set "total_kb=%%i"
for /f "tokens=2 delims==" %%i in ('wmic os get FreePhysicalMemory /value 2^>nul') do set "free_kb=%%i"

set /a total_gb=%total_kb% / 1048576
set /a free_gb=%free_kb% / 1048576

echo Всего памяти:    %total_gb% ГБ
echo Всего памяти:    %total_gb% ГБ >> "%report_file%"
echo Свободно памяти: %free_gb% ГБ
echo Свободно памяти: %free_gb% ГБ >> "%report_file%"
echo.
echo. >> "%report_file%"

REM 6. Свободное место на диске
echo [Диск C]
echo [Диск C] >> "%report_file%"
for /f "tokens=2 delims==" %%i in ('wmic logicaldisk where "DeviceID='C:'" get Size /value 2^>nul') do set "disk_size_b=%%i"
for /f "tokens=2 delims==" %%i in ('wmic logicaldisk where "DeviceID='C:'" get FreeSpace /value 2^>nul') do set "disk_free_b=%%i"

set "disk_size_kb=%disk_size_b:~0,-3%"
set "disk_free_kb=%disk_free_b:~0,-3%"

set /a disk_size_gb=%disk_size_kb% / 1073742
set /a disk_free_gb=%disk_free_kb% / 1073742

echo Общий размер:    %disk_size_gb% ГБ
echo Общий размер:    %disk_size_gb% ГБ >> "%report_file%"
echo Свободно места:  %disk_free_gb% ГБ
echo Свободно места:  %disk_free_gb% ГБ >> "%report_file%"
echo.
echo. >> "%report_file%"

REM 7. Список установленных программ
echo [Список установленных программ]
echo [Список установленных программ] >> "%report_file%"
echo Пожалуйста, подождите, идет сбор данных...
echo -----------------------------------------
echo ----------------------------------------- >> "%report_file%"

REM Проверка 64-битных программ
for /f "tokens=2*" %%a in ('reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /v DisplayName /s 2^>nul') do (
    if not "%%b"=="" (
        echo %%b
        echo %%b >> "%report_file%"
    )
)

REM Проверка 32-битных программ на 64-битной системе
for /f "tokens=2*" %%a in ('reg query "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /v DisplayName /s 2^>nul') do (
    if not "%%b"=="" (
        echo %%b
        echo %%b >> "%report_file%"
    )
)

REM 8. Финал и сообщение о сохранении отчета
echo.
echo. >> "%report_file%"
echo =========================================
echo ========================================= >> "%report_file%"
echo Диагностика завершена. Отчёт сохранён.
echo Диагностика завершена. >> "%report_file%"
echo.

pause

