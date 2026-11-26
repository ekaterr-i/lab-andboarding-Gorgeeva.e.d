@echo off
chcp 65001 > nul
:start_ch2
cls
set correct=0
set score=0
set total=5
echo   МОДУЛЬ ИНСПЕКЦИИ КОДА (CLOUD & MVP INFRASTRUCTURE)
echo Правила: за верный ответ +10 очков, за неверный -5 очков.
echo.
:frag_1
echo Фрагмент 1 (Загрузка пользовательских файлов MVP в S3-бакет):
echo 10: def upload_to_s3(file_path, bucket_name):
echo 11:     client = CloudStorageClient(API_KEY)
echo 12:     client.upload(file_path, bucket_name)
echo 13:     return True
echo.
echo Какой дефект здесь скрыт?
echo 1. Магическое число
echo 2. Утечка ресурса (соединение client не закрывается)
echo 3. Неинициализированная переменная
choice /c 123 /n
if errorlevel 3 goto f1_wrong
if errorlevel 2 (
    echo [+] Верно! Сессия client остается открытой, что приведет к утечке сокетов.
    set /a correct+=1
    set /a score+=10
    goto frag_2
)
if errorlevel 1 goto f1_wrong
:f1_wrong
echo [-] Неверно. Правильный ответ: 2 (Утечка ресурса).
set /a score-=5
:frag_2
echo.
echo Фрагмент 2 (Прогноз расходов на облачные серверы при росте нагрузки):
echo 20: def calc_monthly_budget(instances, hourly_rate):
echo 21:     raw_cost = instances * hourly_rate * 730
echo 22:     total_cost = raw_cost * 1.15
echo 23:     return total_cost
echo.
echo Какой дефект здесь скрыт?
echo 1. Магическое число (730 и 1.15 без поясняющих констант)
echo 2. Мёртвое присваивание
echo 3. Отсутствие обработки ошибок
choice /c 123 /n
if errorlevel 3 goto f2_wrong
if errorlevel 2 goto f2_wrong
if errorlevel 1 (
    echo [+] Верно! Числа 730 (часов в месяце) и 1.15 (запас) нужно вынести в константы.
    set /a correct+=1
    set /a score+=10
    goto frag_3
)
:f2_wrong
echo [-] Неверно. Правильный ответ: 1 (Магическое число).
set /a score-=5
:frag_3
echo.
echo Фрагмент 3 (Автоматическое масштабирование нод через Cloud API):
echo 30: def scale_up_cluster(cluster_id, new_nodes):
echo 31:     response = cloud_api.post(f"/clusters/{cluster_id}/scale", count=new_nodes)
echo 32:     return response.json()["status"]
echo.
echo Какой дефект здесь скрыт?
echo 1. Мёртвое присваивание
echo 2. Утечка ресурса
echo 3. Отсутствие обработки ошибок (нет try/except при таймауте или 502 от API)
choice /c 123 /n
if errorlevel 3 (
    echo [+] Верно! При сбое сети или лимитах API приложение упадет с исключением.
    set /a correct+=1
    set /a score+=10
    goto frag_4
)
:f3_wrong
echo [-] Неверно. Правильный ответ: 3 (Отсутствие обработки ошибок).
set /a score-=5
:frag_4
echo.
echo Фрагмент 4 (Настройка таймаута облачного балансировщика нагрузки):
echo 40: def setup_load_balancer(target_group):
echo 41:     health_check_timeout = 5
echo 42:     health_check_timeout = 15
echo 43:     return create_alb(target_group, timeout=health_check_timeout)
echo.
echo Какой дефект здесь скрыт?
echo 1. Неинициализированная переменная
echo 2. Мёртвое присваивание (значение 5 перезаписывается сразу на строке 42)
echo 3. Магическое число
choice /c 123 /n
if errorlevel 3 goto f4_wrong
if errorlevel 2 (
    echo [+] Верно! Переменная перезаписывается до первого использования.
    set /a correct+=1
    set /a score+=10
    goto frag_5
)
if errorlevel 1 goto f4_wrong
:f4_wrong
echo [-] Неверно. Правильный ответ: 2 (Мёртвое присваивание).
set /a score-=5
:frag_5
echo.
echo Фрагмент 5 (Выбор региона развертывания для стартапа):
echo 50: def get_deploy_region(is_primary):
echo 51:     if is_primary:
echo 52:         region = "ru-central1-a"
echo 53:     return region
echo.
echo Какой дефект здесь скрыт?
echo 1. Неинициализированная переменная (при is_primary=False будет UnboundLocalError)
echo 2. Утечка ресурса
echo 3. Мёртвое присваивание
choice /c 123 /n
if errorlevel 3 goto f5_wrong
if errorlevel 2 goto f5_wrong
if errorlevel 1 (
    echo [+] Верно! Ветка else отсутствует, переменная region не определена при False.
    set /a correct+=1
    set /a score+=10
    goto report
)
:f5_wrong
echo [-] Неверно. Правильный ответ: 1 (Неинициализированная переменная).
set /a score-=5
:report
echo.
echo ========================================================
echo   ИТОГОВЫЙ ОТЧЁТ ИНСПЕКЦИИ КОДА
echo ========================================================
echo Просмотрено фрагментов: %total%
echo Правильных ответов:     %correct% из %total%
echo Итоговый счёт (очки):   %score%
set /a percentage=correct*100/total
echo Точность ревью:         %percentage%%%
if %percentage% geq 80 (
    set res_ch2=Senior Reviewer
) else if %percentage% geq 50 (
    set res_ch2=Middle Reviewer
) else (
    set res_ch2=Junior Reviewer
)
echo Уровень ревьюера:       %res_ch2%
echo ========================================================
echo.
echo Нажмите любую клавишу для завершения работы модуля...
pause > nul
