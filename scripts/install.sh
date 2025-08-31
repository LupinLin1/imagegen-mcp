#!/bin/bash

# imagegen-mcp 自动安装脚本
# 支持 macOS, Linux, Windows (WSL)

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 输出函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 检查 Node.js 版本
check_node_version() {
    if ! command_exists node; then
        log_error "Node.js 未安装，请先安装 Node.js v18.0.0 或更高版本"
        echo "访问: https://nodejs.org/"
        exit 1
    fi

    local node_version=$(node --version | sed 's/v//')
    local required_version="18.0.0"
    
    if ! command_exists npx; then
        log_error "npm 未正确安装"
        exit 1
    fi

    log_info "检测到 Node.js 版本: v$node_version"
    
    # 简单版本比较
    if [[ "$node_version" < "$required_version" ]]; then
        log_error "Node.js 版本过低，需要 v$required_version 或更高版本"
        exit 1
    fi
}

# 安装包
install_package() {
    log_info "开始安装 @lupinlin1/imagegen-mcp..."
    
    if npm install -g @lupinlin1/imagegen-mcp; then
        log_success "安装成功！"
    else
        log_warning "全局安装失败，尝试使用 sudo..."
        if sudo npm install -g @lupinlin1/imagegen-mcp; then
            log_success "使用 sudo 安装成功！"
        else
            log_error "安装失败，请检查网络连接和权限"
            exit 1
        fi
    fi
}

# 验证安装
verify_installation() {
    log_info "验证安装..."
    
    if command_exists imagegen-mcp; then
        log_success "imagegen-mcp 命令已可用"
        imagegen-mcp --version
    else
        log_error "安装验证失败，命令不可用"
        log_info "请检查 npm 全局 bin 目录是否在 PATH 中:"
        echo "  npm config get prefix"
        exit 1
    fi
}

# 环境配置提示
setup_instructions() {
    echo ""
    echo "🎉 安装完成！"
    echo ""
    echo "📋 接下来的步骤:"
    echo ""
    echo "1. 设置 OpenAI API Key:"
    echo "   export OPENAI_API_KEY=your_api_key_here"
    echo ""
    echo "2. 测试运行:"
    echo "   imagegen-mcp --help"
    echo ""
    echo "3. 集成到 MCP 客户端 (如 Cursor, Claude Desktop):"
    echo "   参考: https://github.com/LupinLin1/imagegen-mcp#integration"
    echo ""
    echo "📖 完整文档: https://github.com/LupinLin1/imagegen-mcp"
    echo ""
}

# 主函数
main() {
    echo "🚀 imagegen-mcp 安装程序"
    echo "========================="
    echo ""
    
    check_node_version
    install_package
    verify_installation
    setup_instructions
}

# 运行主函数
main "$@"