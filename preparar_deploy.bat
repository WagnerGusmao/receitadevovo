@echo off
rem Script para preparar os arquivos de Deploy da Receita de Vovo (Hostinger)
rem Autor: Antigravity AI

echo =======================================================
echo PREPARANDO PACOTE DE DEPLOY - RECEITA DE VOVO
echo =======================================================
echo.

set ROOT_DIR=%~dp0
set DEPLOY_DIR=%ROOT_DIR%deploy
set BACKEND_DEPLOY=%DEPLOY_DIR%\api
set FRONTEND_DEPLOY=%DEPLOY_DIR%\frontend

echo [1/5] Executando instalacao de dependencias e compilacao local...
echo.
echo [1.1] Rodando composer install no Backend (Laravel)...
cd /d "%ROOT_DIR%backend"
call composer install --no-dev --optimize-autoloader

echo.
echo [1.2] Rodando npm run build no Frontend (Next.js)...
cd /d "%ROOT_DIR%frontend"
set NEXT_PUBLIC_API_URL=https://api.receitadevovoem.com.br/api
call npm run build

cd /d "%ROOT_DIR%"

echo.
echo [2/5] Limpando e criando estrutura de pastas de deploy...
if exist "%DEPLOY_DIR%" rd /s /q "%DEPLOY_DIR%"
mkdir "%DEPLOY_DIR%"
mkdir "%BACKEND_DEPLOY%"
mkdir "%FRONTEND_DEPLOY%"

echo.
echo [3/5] Copiando arquivos do Backend (Laravel com Vendor)...
robocopy "%ROOT_DIR%backend" "%BACKEND_DEPLOY%" /E /XD "%ROOT_DIR%backend\node_modules" "%ROOT_DIR%backend\.git" "%ROOT_DIR%backend\storage\framework\cache" "%ROOT_DIR%backend\storage\framework\sessions" "%ROOT_DIR%backend\storage\framework\views" "%ROOT_DIR%backend\storage\logs" "%ROOT_DIR%backend\tests" /XF "%ROOT_DIR%backend\.env" "%ROOT_DIR%backend\phpunit.xml" "%ROOT_DIR%backend\.phpunit.result.cache" "%ROOT_DIR%backend\test_mp.php" > nul

echo [3.1] Criando arquivo .env de Producao para o Backend...
echo APP_NAME="Receita de Vovo" > "%BACKEND_DEPLOY%\.env"
echo APP_ENV=production >> "%BACKEND_DEPLOY%\.env"
echo APP_KEY=base64:U7JIsISPKi80Z1ALkvyYAlOZxYx2csw6ypvM36Grh4w= >> "%BACKEND_DEPLOY%\.env"
echo APP_DEBUG=false >> "%BACKEND_DEPLOY%\.env"
echo APP_URL=https://api.receitadevovoem.com.br >> "%BACKEND_DEPLOY%\.env"
echo DB_CONNECTION=mysql >> "%BACKEND_DEPLOY%\.env"
echo DB_HOST=127.0.0.1 >> "%BACKEND_DEPLOY%\.env"
echo DB_PORT=3306 >> "%BACKEND_DEPLOY%\.env"
echo DB_DATABASE=u746854799_receitadevovo >> "%BACKEND_DEPLOY%\.env"
echo DB_USERNAME=u746854799_receitadevovo >> "%BACKEND_DEPLOY%\.env"
echo DB_PASSWORD=Telito@w2 >> "%BACKEND_DEPLOY%\.env"
echo LOG_CHANNEL=stack >> "%BACKEND_DEPLOY%\.env"
echo LOG_LEVEL=error >> "%BACKEND_DEPLOY%\.env"
echo BROADCAST_CONNECTION=log >> "%BACKEND_DEPLOY%\.env"
echo FILESYSTEM_DISK=local >> "%BACKEND_DEPLOY%\.env"
echo QUEUE_CONNECTION=database >> "%BACKEND_DEPLOY%\.env"
echo SESSION_DRIVER=database >> "%BACKEND_DEPLOY%\.env"
echo CACHE_STORE=database >> "%BACKEND_DEPLOY%\.env"
echo GEMINI_API_KEY=AIzaSyCgaQMq9t1APi5gzpERo0NFkbpczPT0QHI >> "%BACKEND_DEPLOY%\.env"
echo GEMINI_MODEL=gemini-flash-latest >> "%BACKEND_DEPLOY%\.env"
echo MERCADOPAGO_PUBLIC_KEY=APP_USR-28f45eb9-3d6b-4da5-8336-f3532e8f03a5 >> "%BACKEND_DEPLOY%\.env"
echo MERCADOPAGO_ACCESS_TOKEN=APP_USR-731575087499911-061209-3cf2b417578d973ab77ce1d4c93738ba-3468656142 >> "%BACKEND_DEPLOY%\.env"
echo MELHORENVIO_ACCESS_TOKEN=fictitious-melhorenvio-access-token >> "%BACKEND_DEPLOY%\.env"
echo MELHORENVIO_ENV=production >> "%BACKEND_DEPLOY%\.env"
echo MELHORENVIO_FROM_ZIPCODE=01001000 >> "%BACKEND_DEPLOY%\.env"

echo.
echo [3.2] Criando arquivo .htaccess para Redirecionamento da API...
echo ^<IfModule mod_rewrite.c^> > "%BACKEND_DEPLOY%\.htaccess"
echo     RewriteEngine On >> "%BACKEND_DEPLOY%\.htaccess"
echo     RewriteRule ^^(.*)$ public/$1 [L] >> "%BACKEND_DEPLOY%\.htaccess"
echo ^</IfModule^> >> "%BACKEND_DEPLOY%\.htaccess"

echo.
echo [4/5] Copiando arquivos do Frontend (Next.js Standalone)...
robocopy "%ROOT_DIR%frontend\.next\standalone" "%FRONTEND_DEPLOY%" /E > nul
robocopy "%ROOT_DIR%frontend\public" "%FRONTEND_DEPLOY%\public" /E > nul
robocopy "%ROOT_DIR%frontend\.next\static" "%FRONTEND_DEPLOY%\.next\static" /E > nul

echo [4.1] Criando arquivos .env de Producao para o Frontend...
echo NEXT_PUBLIC_API_URL=https://api.receitadevovoem.com.br/api > "%FRONTEND_DEPLOY%\.env"
echo NEXT_PUBLIC_API_URL=https://api.receitadevovoem.com.br/api > "%FRONTEND_DEPLOY%\.env.production"

echo.
echo [5/5] Compactando pacotes para ZIP (Aguarde)...
powershell -Command "Compress-Archive -Path '%BACKEND_DEPLOY%' -DestinationPath '%DEPLOY_DIR%\api.zip' -Force"
powershell -Command "Compress-Archive -Path '%FRONTEND_DEPLOY%' -DestinationPath '%DEPLOY_DIR%\frontend.zip' -Force"

echo.
echo =======================================================
echo DEPLOY PREPARADO COM SUCESSO!
echo =======================================================
echo Os arquivos estao organizados na pasta:
echo   %DEPLOY_DIR%
echo.
echo Opcao 1: Enviar as pastas descompactadas diretamente via FTP:
echo   - Copie o conteudo de 'deploy\api' para a pasta do seu subdomain da API
echo   - Copie o conteudo de 'deploy\frontend' para a pasta principal (ex: public_html)
echo.
echo Opcao 2: Enviar os arquivos ZIP (RECOMENDADO - MUITO MAIS RAPIDO):
echo   - Envie 'deploy\api.zip' e extraia no gerenciador de arquivos da Hostinger na pasta do subdomain
echo   - Envie 'deploy\frontend.zip' e extraia no gerenciador de arquivos da Hostinger na pasta principal
echo.
echo Configuracao do Node.js na Hostinger (Frontend):
echo   - Aponte o "Startup file" ou "Arquivo de inicializacao" para: server.js
echo   - Nao e necessario rodar 'npm install' no servidor, as dependencias estao inclusas!
echo =======================================================
pause
