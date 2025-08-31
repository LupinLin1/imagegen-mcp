# 🚀 imagegen-mcp 安装指南

## 快速安装

### 方法1: 全局安装 (推荐)
```bash
npm install -g @lupinlin1/imagegen-mcp
```

### 方法2: 使用 npx (无需安装)
```bash
npx @lupinlin1/imagegen-mcp [options]
```

### 方法3: 从源码安装
```bash
git clone https://github.com/LupinLin1/imagegen-mcp.git
cd imagegen-mcp
npm install
npm run build
npm link
```

## 前置要求

- **Node.js**: v18.0.0 或更高版本
- **OpenAI API Key**: 从 [OpenAI Platform](https://platform.openai.com/api-keys) 获取

## 配置

1. **创建环境变量文件**:
```bash
cp .env.example .env
```

2. **设置 OpenAI API Key**:
```bash
echo "OPENAI_API_KEY=your_api_key_here" > .env
# 或者设置环境变量
export OPENAI_API_KEY=your_api_key_here
```

## 使用方法

### 基本用法
```bash
imagegen-mcp
```

### 指定模型
```bash
imagegen-mcp --models dall-e-3
imagegen-mcp --models gpt-image-1 dall-e-2
```

### 帮助信息
```bash
imagegen-mcp --help
```

## 集成到 Cursor

在 Cursor 设置中添加以下配置:

```json
{
  "mcpServers": {
    "imagegen-mcp": {
      "command": "imagegen-mcp",
      "args": ["--models", "dall-e-3"],
      "env": {
        "OPENAI_API_KEY": "your_api_key_here"
      }
    }
  }
}
```

## 集成到 Claude Desktop

在 Claude Desktop 配置文件中添加:

```json
{
  "mcpServers": {
    "imagegen-mcp": {
      "command": "imagegen-mcp",
      "env": {
        "OPENAI_API_KEY": "your_api_key_here"
      }
    }
  }
}
```

## 验证安装

```bash
# 检查版本
imagegen-mcp --version

# 测试连接
imagegen-mcp --test
```

## 故障排除

### 常见问题

1. **命令未找到**:
   - 确保 npm 全局 bin 目录在 PATH 中
   - 运行 `npm config get prefix` 检查路径

2. **权限错误**:
   ```bash
   sudo npm install -g @lupinlin1/imagegen-mcp
   ```

3. **Node.js 版本过低**:
   ```bash
   node --version  # 应该 >= 18.0.0
   ```

4. **OpenAI API 错误**:
   - 检查 API key 是否正确
   - 确认账户有足够余额
   - 验证模型访问权限

### 卸载

```bash
npm uninstall -g @lupinlin1/imagegen-mcp
```

## 支持

- 📖 [项目文档](https://github.com/LupinLin1/imagegen-mcp#readme)
- 🐛 [问题反馈](https://github.com/LupinLin1/imagegen-mcp/issues)
- 💬 [讨论区](https://github.com/LupinLin1/imagegen-mcp/discussions)

---

✨ **欢迎贡献代码和反馈！**