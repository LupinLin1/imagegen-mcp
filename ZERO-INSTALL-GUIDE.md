# 🚀 零安装使用指南

## ✨ 什么是零安装？

**零安装**意味着您可以直接在MCP客户端配置中使用imagegen-mcp，无需任何预安装步骤！

## 🎯 支持的配置方式

### 方式1: NPX自动下载 (推荐)

**适用于**: 所有MCP客户端 (Cursor, Claude Desktop等)

```json
{
  "mcpServers": {
    "imagegen-mcp": {
      "command": "npx",
      "args": ["@lupinlin1/imagegen-mcp", "--models", "dall-e-3"],
      "env": {
        "OPENAI_API_KEY": "your_openai_api_key_here"
      }
    }
  }
}
```

**优势**:
- ✅ 真正的零安装
- ✅ 自动使用最新版本
- ✅ 跨平台兼容

**注意**:
- 📦 首次启动需要下载包 (约10-15秒)
- 🌐 需要网络连接进行首次下载
- 💾 后续启动使用缓存，速度很快

### 方式2: 本地脚本 (开发者推荐)

**适用于**: 下载了项目源码的用户

#### macOS/Linux:
```json
{
  "mcpServers": {
    "imagegen-mcp": {
      "command": "/path/to/imagegen-mcp/bin/mcp-imagegen.sh",
      "args": ["--models", "dall-e-3", "gpt-image-1"],
      "env": {
        "OPENAI_API_KEY": "your_openai_key"
      }
    }
  }
}
```

#### Windows:
```json
{
  "mcpServers": {
    "imagegen-mcp": {
      "command": "C:\\path\\to\\imagegen-mcp\\bin\\mcp-imagegen.cmd",
      "args": ["--models", "dall-e-3", "gpt-image-1"],
      "env": {
        "OPENAI_API_KEY": "your_openai_key"
      }
    }
  }
}
```

**优势**:
- 🚀 启动最快 (使用本地构建)
- 🔄 自动fallback到npx
- 🛠️ 支持本地开发

## 📋 详细配置步骤

### Cursor 编辑器

1. **打开设置**: `Ctrl/Cmd + ,`
2. **搜索MCP**: 在设置搜索栏输入"MCP"
3. **编辑配置**: 点击"Edit in settings.json"
4. **添加配置**: 复制上面的JSON配置
5. **保存重启**: 保存文件并重启Cursor

### Claude Desktop

1. **找到配置文件**:
   - macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
   - Windows: `%APPDATA%\\Claude\\claude_desktop_config.json`
2. **编辑配置**: 添加mcpServers配置
3. **重启应用**: 重新启动Claude Desktop

### VS Code (如果支持MCP)

1. **打开设置**: `Ctrl/Cmd + ,`
2. **搜索扩展**: 查找MCP相关扩展
3. **配置MCP**: 按扩展说明添加服务器

## 🔧 自定义参数

### 模型选择
```json
"args": ["@lupinlin1/imagegen-mcp", "--models", "dall-e-3"]        // 仅DALL-E 3
"args": ["@lupinlin1/imagegen-mcp", "--models", "gpt-image-1"]    // 仅GPT-Image
"args": ["@lupinlin1/imagegen-mcp", "--models", "dall-e-3", "dall-e-2", "gpt-image-1"] // 全部模型
```

### 其他选项
```json
"args": [
  "@lupinlin1/imagegen-mcp",
  "--models", "dall-e-3",
  "--verbose",                    // 详细日志
  "--port", "3000"               // 自定义端口 (如果适用)
]
```

## 🚨 故障排除

### 问题1: "command not found"
**原因**: npx或Node.js未安装
**解决**:
```bash
# 安装Node.js (包含npx)
# 访问: https://nodejs.org/

# 验证安装
node --version
npx --version
```

### 问题2: 首次启动慢
**原因**: npx正在下载包
**解决**: 等待下载完成，后续启动会很快

### 问题3: "OPENAI_API_KEY required"
**原因**: API密钥未设置或无效
**解决**: 
1. 获取API密钥: https://platform.openai.com/api-keys
2. 替换配置中的"your_openai_api_key_here"

### 问题4: 权限错误 (macOS/Linux)
**原因**: 脚本没有执行权限
**解决**:
```bash
chmod +x /path/to/imagegen-mcp/bin/mcp-imagegen.sh
```

## 📊 性能对比

| 方式 | 首次启动 | 后续启动 | 网络依赖 | 维护成本 |
|------|----------|----------|----------|----------|
| NPX自动下载 | 10-15秒 | 2-3秒 | 首次需要 | 零 |
| 本地脚本 | 1-2秒 | 1-2秒 | 无 | 需要更新 |
| 全局安装 | 2-3秒 | 2-3秒 | 无 | 需要手动更新 |

## 🎉 推荐配置

**普通用户**: 使用NPX配置 - 简单、自动更新
**开发者**: 使用本地脚本 - 速度快、支持开发
**企业用户**: 可能需要全局安装 - 更好的控制

---

📖 **需要帮助?** 
- [项目文档](https://github.com/LupinLin1/imagegen-mcp#readme)
- [问题反馈](https://github.com/LupinLin1/imagegen-mcp/issues)
- [更多配置示例](./examples/mcp-configs/)