#!/bin/bash

# 远程执行脚本 - GitHub Raw方案
# 从GitHub直接下载并运行imagegen-mcp

set -e

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" >&2
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" >&2
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" >&2
}

# 检查依赖
check_dependencies() {
    if ! command -v node >/dev/null 2>&1; then
        log_error "Node.js not found. Please install Node.js v18+ first."
        exit 1
    fi

    if ! command -v curl >/dev/null 2>&1; then
        log_error "curl not found. Please install curl first."
        exit 1
    fi
}

# GitHub仓库信息
GITHUB_REPO="LupinLin1/imagegen-mcp"
GITHUB_BRANCH="${GITHUB_BRANCH:-main}"
BASE_URL="https://raw.githubusercontent.com/${GITHUB_REPO}/${GITHUB_BRANCH}"

# 临时目录
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

log_info "🚀 Starting imagegen-mcp remote execution..."
log_info "📂 Repository: https://github.com/${GITHUB_REPO}"
log_info "🔀 Branch: ${GITHUB_BRANCH}"
log_info "📁 Temp directory: ${TEMP_DIR}"

# 检查依赖
check_dependencies

# 下载必要文件
log_info "📥 Downloading files..."

# 下载主执行文件
log_info "   Downloading dist/index.js..."
if ! curl -fsSL "${BASE_URL}/dist/index.js" -o "${TEMP_DIR}/index.js"; then
    log_error "Failed to download index.js"
    exit 1
fi

# 下载package.json (用于依赖信息)
log_info "   Downloading package.json..."
if ! curl -fsSL "${BASE_URL}/package.json" -o "${TEMP_DIR}/package.json"; then
    log_error "Failed to download package.json"
    exit 1
fi

# 创建临时的package.json，只包含运行时依赖
log_info "📦 Preparing dependencies..."
cd "${TEMP_DIR}"

# 提取运行时依赖并安装
node -e "
const pkg = require('./package.json');
const newPkg = {
  name: 'temp-imagegen-mcp',
  version: '1.0.0',
  type: 'module',
  dependencies: pkg.dependencies
};
require('fs').writeFileSync('package.json', JSON.stringify(newPkg, null, 2));
"

# 安装依赖
log_info "   Installing dependencies..."
if ! npm install --silent >/dev/null 2>&1; then
    log_warning "Failed to install dependencies, trying without them..."
fi

# 执行主程序
log_success "✅ Setup complete, starting imagegen-mcp..."
log_info "🔗 Passing arguments: $@"

# 设置NODE_PATH以找到依赖
export NODE_PATH="${TEMP_DIR}/node_modules:${NODE_PATH}"

# 执行程序
exec node "${TEMP_DIR}/index.js" "$@"