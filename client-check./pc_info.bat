@echo off
chcp 65001 > nul

echo =========================================
echo           ДИАГНОСТИКА КОМПЬЮТЕРА
echo =========================================
echo.

:: 3. Сведения об операционной системе
echo [Операционная система]
for /f "tokens=2 delims==" %%i in ('wmic os get Caption /value 2^>nul') do (
    if not "%%i"=="" echo Название: %%i
)
for /f "tokens=2 delims==" %%i in ('wmic os get Version /value 2^>nul') do (
    if not "%%i"=="" echo Версия:   %%i
)
echo.

:: 4. Сведения о процессоре
echo [Процессор]
for /f "tokens=2 delims==" %%i in ('wmic cpu get Name /value 2^>nul') do (
    if not "%%i"=="" echo Модель:   %%i
)
echo.

:: 5. Сведения об оперативной памяти
echo [Оперативная память]
for /f "tokens=2 delims==" %%i in ('wmic os get TotalVisibleMemorySize /value 2^>nul') do set "total_kb=%%i"
for /f "tokens=2 delims==" %%i in ('wmic os get FreePhysicalMemory /value 2^>nul') do set "free_kb=%%i"

set /a total_gb=%total_kb% / 1048576
set /a free_gb=%free_kb% / 1048576

echo Всего памяти:    %total_gb% ГБ
echo Свободно памяти: %free_gb% ГБ
echo.

:: 6. Свободное место на диске
echo [Диск C]
for /f "tokens=2 delims==" %%i in ('wmic logicaldisk where "DeviceID='C:'" get Size /value 2^>nul') do set "disk_size_b=%%i"
for /f "tokens=2 delims==" %%i in ('wmic logicaldisk where "DeviceID='C:'" get FreeSpace /value 2^>nul') do set "disk_free_b=%%i"

:: Из-за ограничений 32-битной арифметики в BAT (макс. 2 млрд), делим большие числа в два этапа
set "disk_size_kb=%disk_size_b:~0,-3%"
set "disk_free_kb=%disk_free_b:~0,-3%"

set /a disk_size_gb=%disk_size_kb% / 1073742
set /a disk_free_gb=%disk_free_kb% / 1073742

echo Общий размер:    %disk_size_gb% ГБ
echo Свободно места:  %disk_free_gb% ГБ
echo.

:: 7. Список установленных программ
echo [Список установленных программ]
echo Пожалуйста, подождите, идет сбор данных...
echo -----------------------------------------

:: Проверка 64-битных программ
for /f "tokens=2*" %%a in ('reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /v DisplayName /s 2^>nul') do (
    if not "%%b"=="" echo %%b
)

:: Проверка 32-битных программ на 64-битной системе
for /f "tokens=2*" %%a in ('reg query "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /v DisplayName /s 2^>nul') do (
    if not "%%b"=="" echo %%b
)

echo.
echo =========================================
echo Диагностика завершена.
pause
