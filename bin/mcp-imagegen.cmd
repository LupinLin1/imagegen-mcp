@echo off
REM Self-contained MCP ImageGen Server for Windows
REM 自包含的MCP图像生成服务器 (Windows版本)

REM 检查Node.js是否可用
where node >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ❌ Error: Node.js not found. Please install Node.js v18+ first. >&2
    echo Visit: https://nodejs.org/ >&2
    exit /b 1
)

REM 检查npm是否可用
where npm >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ❌ Error: npm not found. Please install npm first. >&2
    exit /b 1
)

REM 获取脚本所在目录
set SCRIPT_DIR=%~dp0
set PROJECT_DIR=%SCRIPT_DIR%\..

REM 如果在项目目录中且已构建，直接使用
if exist "%PROJECT_DIR%\dist\index.js" if exist "%PROJECT_DIR%\package.json" (
    echo 🚀 Using local build... >&2
    cd /d "%PROJECT_DIR%"
    node dist\index.js %*
    goto :EOF
)

REM 否则使用npx自动下载运行
echo 📦 Using npx to run @lupinlin1/imagegen-mcp... >&2
npx @lupinlin1/imagegen-mcp %*