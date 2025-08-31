#!/bin/bash

# imagegen-mcp 发布脚本

set -e

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

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

echo "🚀 imagegen-mcp 发布流程"
echo "========================"
echo ""

# 检查是否有未提交的更改
if ! git diff --quiet HEAD; then
    log_warning "有未提交的更改，请先提交:"
    git status --short
    echo ""
    read -p "是否继续？ (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# 构建项目
log_info "构建项目..."
npm run build

# 运行测试 (如果有)
if npm run test >/dev/null 2>&1; then
    log_info "运行测试..."
    npm test
fi

# 创建包
log_info "创建 npm 包..."
npm pack

# 显示包信息
PACKAGE_FILE=$(ls -t *.tgz | head -1)
log_success "包已创建: $PACKAGE_FILE"
echo ""

# 显示包内容
log_info "包内容:"
tar -tzf "$PACKAGE_FILE" | head -20
if [ $(tar -tzf "$PACKAGE_FILE" | wc -l) -gt 20 ]; then
    echo "... 和更多文件"
fi
echo ""

# 检查包大小
PACKAGE_SIZE=$(du -h "$PACKAGE_FILE" | cut -f1)
log_info "包大小: $PACKAGE_SIZE"
echo ""

# 询问是否发布到 npm
log_warning "准备发布到 npm registry"
echo "包文件: $PACKAGE_FILE"
echo "大小: $PACKAGE_SIZE"
echo ""
read -p "确定要发布吗？ (y/N): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_info "发布到 npm..."
    if npm publish; then
        log_success "发布成功！"
        echo ""
        log_info "安装命令:"
        echo "npm install -g @lupinlin1/imagegen-mcp"
        echo ""
        log_info "或使用安装脚本:"
        echo "curl -fsSL https://raw.githubusercontent.com/LupinLin1/imagegen-mcp/main/scripts/install.sh | bash"
    else
        log_error "发布失败"
        exit 1
    fi
else
    log_info "发布已取消"
fi

# 清理临时文件
read -p "删除生成的 .tgz 文件吗？ (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -f *.tgz
    log_success "已清理临时文件"
fi

log_success "发布流程完成！"