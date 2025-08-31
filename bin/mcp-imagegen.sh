#!/bin/bash

# Self-contained MCP ImageGen Server
# 自包含的MCP图像生成服务器
# 无需预安装，直接在配置中使用

set -e

# 检查Node.js是否可用
if ! command -v node >/dev/null 2>&1; then
    echo "❌ Error: Node.js not found. Please install Node.js v18+ first." >&2
    echo "Visit: https://nodejs.org/" >&2
    exit 1
fi

# 检查npm是否可用
if ! command -v npm >/dev/null 2>&1; then
    echo "❌ Error: npm not found. Please install npm first." >&2
    exit 1
fi

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# 如果在项目目录中且已构建，直接使用
if [ -f "$PROJECT_DIR/dist/index.js" ] && [ -f "$PROJECT_DIR/package.json" ]; then
    echo "🚀 Using local build..." >&2
    cd "$PROJECT_DIR"
    exec node dist/index.js "$@"
fi

# 否则使用npx自动下载运行
echo "📦 Using npx to run @lupinlin1/imagegen-mcp..." >&2
exec npx @lupinlin1/imagegen-mcp "$@"