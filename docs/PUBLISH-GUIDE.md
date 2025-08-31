# 📦 NPM发布指南

## 🎯 发布目标

将 `@lupinlin1/imagegen-mcp` 发布到NPM公开仓库，使零安装配置生效：

```json
{
  "command": "npx",
  "args": ["@lupinlin1/imagegen-mcp", "--models", "dall-e-3"]
}
```

## 🚀 快速发布流程

### 步骤1: 准备NPM账户

如果没有NPM账户：
```bash
# 访问 https://www.npmjs.com/signup 注册账户
# 验证邮箱 (重要!)
```

### 步骤2: 登录NPM
```bash
npm login
# 输入用户名、密码、邮箱
# 如果启用了2FA，还需要输入验证码
```

### 步骤3: 检查包配置
```bash
# 检查package.json配置
cat package.json | grep -E '"name"|"version"'

# 当前应该显示:
# "name": "@lupinlin1/imagegen-mcp",
# "version": "1.0.5",
```

### 步骤4: 构建项目
```bash
npm run build
```

### 步骤5: 发布包
```bash
# 方式1: 直接发布
npm publish

# 方式2: 使用我们的发布脚本
./scripts/publish.sh
```

## 🔍 发布前检查清单

- [ ] NPM账户已注册并验证邮箱
- [ ] 本地已登录NPM (`npm whoami` 有输出)
- [ ] 包名 `@lupinlin1/imagegen-mcp` 未被占用
- [ ] 版本号符合语义化版本规范
- [ ] 项目已构建 (`dist/` 目录存在)
- [ ] 所有文件已提交到Git
- [ ] README.md包含完整使用说明

## ⚡ 验证发布成功

### 检查NPM仓库
```bash
npm info @lupinlin1/imagegen-mcp
```

### 测试npx安装
```bash
# 清除本地缓存
npm cache clean --force

# 测试npx执行
npx @lupinlin1/imagegen-mcp --help
```

### 测试零安装配置
在MCP客户端中使用以下配置测试：
```json
{
  "mcpServers": {
    "imagegen-mcp": {
      "command": "npx",
      "args": ["@lupinlin1/imagegen-mcp", "--models", "dall-e-3"],
      "env": {
        "OPENAI_API_KEY": "test_key"
      }
    }
  }
}
```

## 🛠️ 常见问题解决

### 问题1: 403 Forbidden
**原因**: 包名被占用或权限不足
**解决**: 
```bash
# 检查包名
npm info @lupinlin1/imagegen-mcp

# 如果不存在，检查作用域权限
npm access ls-collaborators @lupinlin1/imagegen-mcp
```

### 问题2: ENEEDAUTH
**原因**: 未登录NPM
**解决**:
```bash
npm login
npm whoami  # 验证登录状态
```

### 问题3: 2FA验证
**原因**: 账户启用了双因素认证
**解决**: 使用认证应用提供的6位数验证码

### 问题4: 邮箱未验证
**原因**: NPM要求验证邮箱才能发布
**解决**: 检查邮箱并点击验证链接

## 🔄 版本管理

### 发布新版本
```bash
# 修改版本号
npm version patch  # 1.0.5 -> 1.0.6
npm version minor  # 1.0.5 -> 1.1.0
npm version major  # 1.0.5 -> 2.0.0

# 发布新版本
npm publish
```

### 撤回发布 (谨慎使用)
```bash
# 只能撤回72小时内的发布
npm unpublish @lupinlin1/imagegen-mcp@1.0.5
```

## 📊 发布后的维护

### 监控下载量
```bash
npm info @lupinlin1/imagegen-mcp
```

### 更新依赖
```bash
npm audit
npm audit fix
```

### 用户反馈
- 关注GitHub Issues
- 回应NPM评论
- 更新文档

## 🎉 发布成功后

1. **更新README徽章**:
   ```markdown
   [![npm version](https://img.shields.io/npm/v/@lupinlin1/imagegen-mcp)](https://www.npmjs.com/package/@lupinlin1/imagegen-mcp)
   ```

2. **通知用户**:
   - 发布GitHub Release
   - 更新社交媒体
   - 通知相关社区

3. **测试零安装配置**:
   确保所有配置示例都能正常工作

## 🚨 安全注意事项

- 启用NPM账户的2FA
- 不要在包中包含敏感信息
- 定期检查和更新依赖
- 使用 `.npmignore` 排除不必要的文件

---

📋 **发布检查**: 完成上述步骤后，零安装配置就完全可用了！