# MCP配置示例

## 🚀 零安装配置方案

这些配置文件展示了如何在不需要预安装的情况下使用imagegen-mcp。

### 📋 可用配置

| 配置文件 | 平台 | 描述 |
|---------|------|------|
| `cursor-zero-install.json` | 通用 | Cursor编辑器零安装配置 |
| `claude-desktop-zero-install.json` | 通用 | Claude Desktop零安装配置 |
| `local-script-unix.json` | macOS/Linux | 使用本地脚本运行 |
| `local-script-windows.json` | Windows | 使用本地批处理文件运行 |
| `advanced-multi-model.json` | 通用 | 多模型高级配置 |

### 🔧 使用方法

1. **选择合适的配置文件**
2. **复制内容到你的MCP客户端配置中**
3. **替换 `your_openai_api_key_here` 为你的真实API密钥**
4. **重启MCP客户端**

### ✨ 零安装原理

- **npx方式**: 使用 `npx @lupinlin1/imagegen-mcp` 自动下载运行
- **本地脚本**: 智能检测本地构建，否则fallback到npx
- **无需全局安装**: 第一次运行时自动下载依赖

### 🎯 推荐配置

**最简单**: 使用 `cursor-zero-install.json` 或 `claude-desktop-zero-install.json`

**最灵活**: 使用 `local-script-unix.json` (支持本地开发)

**最强大**: 使用 `advanced-multi-model.json` (多模型分离)

### 🛠️ 自定义配置

你可以修改 `args` 参数来自定义行为:

```json
"args": [
  "@lupinlin1/imagegen-mcp",
  "--models", "dall-e-3", "gpt-image-1",  // 指定模型
  "--port", "3000"                         // 自定义端口
]
```

### 🚨 注意事项

1. **首次运行较慢**: npx需要下载依赖包
2. **网络依赖**: 需要稳定的网络连接下载包
3. **缓存机制**: npx会缓存下载的包，后续启动更快

---

🔗 **项目地址**: https://github.com/LupinLin1/imagegen-mcp
📖 **完整文档**: 查看项目README获取更多信息
