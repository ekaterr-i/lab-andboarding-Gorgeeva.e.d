@echo off
chcp 65001 > nul
:start
cls
set score_yc=0
set score_sel=0
set score_tw=0
echo   МОДУЛЬ ВЫБОРА ОБЛАЧНОЙ ПЛАТФОРМЫ ДЛЯ СТАРТАПА
echo Контекст: MVP веб-приложения с прогнозируемым ростом нагрузки.
echo Кандидаты: Yandex Cloud, Selectel, Timeweb Cloud.
echo.
:question_1
echo Вопрос 1 : Какой бюджет выделен на инфраструктуру стартапа?
echo 1. Минимальный, нужен простой и предсказуемый тариф без лишних затрат
echo 2. Средний, готовы гибко оплачивать только потребляемые ресурсы
echo 3. Есть гранты для стартапов или бюджет на крупную облачную экосистему
choice /c 123 /n
if errorlevel 3 set /a score_yc+=15 & goto question_2
if errorlevel 2 set /a score_sel+=15 & goto question_2
if errorlevel 1 set /a score_tw+=15 & goto question_2
:question_2
echo.
echo Вопрос 2: Как планируется масштабировать MVP при росте нагрузки?
echo 1. Вертикально (увеличение CPU/RAM) с простым балансировщиком
echo 2. Гибридно: облачные серверы + выделенное железо (Dedicated) под высокие нагрузки
echo 3. Горизонтально с автоскейлингом (Managed Kubernetes, Serverless, управляемые БД)
choice /c 123 /n
if errorlevel 3 set /a score_yc+=20 & goto question_3
if errorlevel 2 set /a score_sel+=20 & goto question_3
if errorlevel 1 set /a score_tw+=20 & goto question_3
:question_3
echo.
echo Вопрос 3 : Насколько критична скорость запуска MVP?
echo 1. Максимально критична — нужно развернуть проект за 15 минут в пару кликов
echo 2. Умеренная — есть несколько дней на настройку сети и серверов
echo 3. Запускаем поэтапно с заделом на сложную микросервисную архитектуру
choice /c 123 /n
if errorlevel 3 set /a score_yc+=10 & goto question_4
if errorlevel 2 set /a score_sel+=10 & goto question_4
if errorlevel 1 set /a score_tw+=15 & goto question_4
:question_4
echo.
echo Вопрос 4 : Какой опыт у вашей команды в DevOps?
echo 1. В команде только разработчики, нужна максимально простая и понятная панель управления
echo 2. Есть системный администратор / DevOps, важна гибкость сетевых настроек и API
echo 3. Команда опытная, планирует активно использовать PaaS-сервисы, ML и облачные брокеры
choice /c 123 /n
if errorlevel 3 set /a score_yc+=15 & goto calculate
if errorlevel 2 set /a score_sel+=15 & goto calculate
if errorlevel 1 set /a score_tw+=15 & goto calculate
:calculate
echo.
echo   РЕЗУЛЬТАТЫ ПРОФИЛИРОВАНИЯ ПРОЕКТА
echo Yandex Cloud:  %score_yc% баллов
echo Selectel:      %score_sel% баллов
echo Timeweb Cloud: %score_tw% баллов
echo.
if %score_yc% gtr %score_sel% if %score_yc% gtr %score_tw% goto win_yc
if %score_sel% gtr %score_yc% if %score_sel% gtr %score_tw% goto win_sel
if %score_tw% gtr %score_yc% if %score_tw% gtr %score_sel% goto win_tw
echo Рекомендация: Несколько платформ набрали равное количество баллов.
echo Для быстрого старта MVP рекомендуем начать с Timeweb Cloud или Yandex Cloud.
set res_ch1=Timeweb Cloud / Yandex Cloud (равный балл)
goto end
:win_yc
echo Рекомендация: Yandex Cloud
echo Обоснование: Оптимально для проектов с автоскейлингом, PaaS-сервисами и грантовой поддержкой.
set res_ch1=Yandex Cloud
goto end
:win_sel
echo Рекомендация: Selectel
echo Обоснование: Лучший выбор при необходимости гибридной инфраструктуры и тонкой настройки сети.
set res_ch1=Selectel
goto end
:win_tw
echo Рекомендация: Timeweb Cloud
echo Обоснование: Идеально для быстрого запуска MVP при ограниченном бюджете и без выделенного DevOps.
set res_ch1=Timeweb Cloud
goto end
:end
echo.
echo Нажмите любую клавишу для завершения работы модуля...
pause > nul

