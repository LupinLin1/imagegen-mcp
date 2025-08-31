# imagegen-mcp Windows PowerShell 安装脚本

param(
    [switch]$Force
)

# 设置错误处理
$ErrorActionPreference = "Stop"

# 颜色输出函数
function Write-ColorOutput($Message, $Color = "White") {
    Write-Host $Message -ForegroundColor $Color
}

function Write-Info($Message) {
    Write-ColorOutput "[INFO] $Message" "Blue"
}

function Write-Success($Message) {
    Write-ColorOutput "[SUCCESS] $Message" "Green"
}

function Write-Warning($Message) {
    Write-ColorOutput "[WARNING] $Message" "Yellow"
}

function Write-Error($Message) {
    Write-ColorOutput "[ERROR] $Message" "Red"
}

# 检查命令是否存在
function Test-Command($Command) {
    try {
        Get-Command $Command -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

# 检查 Node.js 版本
function Test-NodeVersion {
    Write-Info "检查 Node.js 安装..."
    
    if (-not (Test-Command "node")) {
        Write-Error "Node.js 未安装，请先安装 Node.js v18.0.0 或更高版本"
        Write-Host "访问: https://nodejs.org/"
        exit 1
    }
    
    if (-not (Test-Command "npm")) {
        Write-Error "npm 未正确安装"
        exit 1
    }
    
    $nodeVersion = node --version
    $versionNumber = $nodeVersion -replace "v", ""
    $requiredVersion = [version]"18.0.0"
    $currentVersion = [version]$versionNumber
    
    Write-Info "检测到 Node.js 版本: $nodeVersion"
    
    if ($currentVersion -lt $requiredVersion) {
        Write-Error "Node.js 版本过低，需要 v18.0.0 或更高版本"
        exit 1
    }
    
    Write-Success "Node.js 版本符合要求"
}

# 安装包
function Install-Package {
    Write-Info "开始安装 @lupinlin1/imagegen-mcp..."
    
    try {
        npm install -g @lupinlin1/imagegen-mcp
        Write-Success "安装成功！"
    }
    catch {
        Write-Error "安装失败: $($_.Exception.Message)"
        Write-Info "请尝试以管理员权限运行此脚本"
        exit 1
    }
}

# 验证安装
function Test-Installation {
    Write-Info "验证安装..."
    
    if (Test-Command "imagegen-mcp") {
        Write-Success "imagegen-mcp 命令已可用"
        try {
            $version = imagegen-mcp --version
            Write-Info "版本: $version"
        }
        catch {
            Write-Warning "无法获取版本信息，但命令已安装"
        }
    }
    else {
        Write-Error "安装验证失败，命令不可用"
        Write-Info "请检查 npm 全局路径是否在 PATH 中"
        Write-Info "运行: npm config get prefix"
        exit 1
    }
}

# 设置说明
function Show-SetupInstructions {
    Write-Host ""
    Write-Success "🎉 安装完成！"
    Write-Host ""
    Write-ColorOutput "📋 接下来的步骤:" "Cyan"
    Write-Host ""
    Write-Host "1. 设置 OpenAI API Key:"
    Write-Host "   `$env:OPENAI_API_KEY = 'your_api_key_here'"
    Write-Host "   # 或者在系统环境变量中设置"
    Write-Host ""
    Write-Host "2. 测试运行:"
    Write-Host "   imagegen-mcp --help"
    Write-Host ""
    Write-Host "3. 集成到 MCP 客户端 (如 Cursor, Claude Desktop):"
    Write-Host "   参考: https://github.com/LupinLin1/imagegen-mcp#integration"
    Write-Host ""
    Write-ColorOutput "📖 完整文档: https://github.com/LupinLin1/imagegen-mcp" "Blue"
    Write-Host ""
}

# 主函数
function Main {
    Write-Host "🚀 imagegen-mcp Windows 安装程序" -ForegroundColor Magenta
    Write-Host "=================================" -ForegroundColor Magenta
    Write-Host ""
    
    Test-NodeVersion
    Install-Package
    Test-Installation
    Show-SetupInstructions
}

# 运行主函数
try {
    Main
}
catch {
    Write-Error "安装过程中出现错误: $($_.Exception.Message)"
    exit 1
}