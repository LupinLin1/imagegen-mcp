# 🔄 零安装配置备选方案

## 🎯 如果无法发布到NPM怎么办？

虽然发布到NPM是实现零安装配置的最佳方案，但我们也准备了多种备选方案。

## 📋 方案对比

| 方案 | 用户步骤 | 技术难度 | 维护成本 | 用户体验 |
|------|----------|----------|----------|----------|
| NPM发布 | 0步安装 | 简单 | 极低 | ⭐⭐⭐⭐⭐ |
| GitHub Raw | 1步下载 | 中等 | 低 | ⭐⭐⭐⭐ |
| 本地脚本 | 1步克隆 | 简单 | 中等 | ⭐⭐⭐ |
| Docker容器 | 1步拉取 | 中等 | 中等 | ⭐⭐⭐⭐ |
| 全局安装 | 1步安装 | 简单 | 低 | ⭐⭐⭐ |

## 🚀 方案1: GitHub Raw文件 (推荐备选)

### 原理
直接从GitHub下载并执行脚本文件。

### 配置示例
```json
{
  "mcpServers": {
    "imagegen-mcp": {
      "command": "node",
      "args": [
        "-e",
        "require('https').get('https://raw.githubusercontent.com/LupinLin1/imagegen-mcp/main/dist/index.js', res => { let data = ''; res.on('data', chunk => data += chunk); res.on('end', () => eval(data)); })"
      ],
      "env": {
        "OPENAI_API_KEY": "your_api_key_here"
      }
    }
  }
}
```

### 更优雅的包装脚本
创建一个简单的启动脚本：

```json
{
  "mcpServers": {
    "imagegen-mcp": {
      "command": "bash",
      "args": [
        "-c",
        "curl -fsSL https://raw.githubusercontent.com/LupinLin1/imagegen-mcp/main/scripts/run-remote.sh | bash"
      ],
      "env": {
        "OPENAI_API_KEY": "your_api_key_here"
      }
    }
  }
}
```

## 🐳 方案2: Docker容器

### 创建Dockerfile
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY dist/ ./dist/
COPY bin/ ./bin/
EXPOSE 3000
CMD ["node", "dist/index.js"]
```

### 配置示例
```json
{
  "mcpServers": {
    "imagegen-mcp": {
      "command": "docker",
      "args": [
        "run", "--rm",
        "-e", "OPENAI_API_KEY=${OPENAI_API_KEY}",
        "lupinlin1/imagegen-mcp"
      ],
      "env": {
        "OPENAI_API_KEY": "your_api_key_here"
      }
    }
  }
}
```

### 发布到Docker Hub
```bash
docker build -t lupinlin1/imagegen-mcp .
docker push lupinlin1/imagegen-mcp
```

## 📂 方案3: 本地安装包 (已实现)

用户下载项目后使用本地脚本：

### macOS/Linux
```json
{
  "mcpServers": {
    "imagegen-mcp": {
      "command": "/path/to/imagegen-mcp/bin/mcp-imagegen.sh",
      "env": {
        "OPENAI_API_KEY": "your_api_key_here"
      }
    }
  }
}
```

### Windows
```json
{
  "mcpServers": {
    "imagegen-mcp": {
      "command": "C:\\path\\to\\imagegen-mcp\\bin\\mcp-imagegen.cmd",
      "env": {
        "OPENAI_API_KEY": "your_api_key_here"
      }
    }
  }
}
```

## 🌐 方案4: CDN分发

### 使用jsDelivr
```json
{
  "mcpServers": {
    "imagegen-mcp": {
      "command": "node",
      "args": [
        "-e",
        "require('https').get('https://cdn.jsdelivr.net/gh/LupinLin1/imagegen-mcp@main/dist/index.js', res => { let data = ''; res.on('data', chunk => data += chunk); res.on('end', () => eval(data)); })"
      ],
      "env": {
        "OPENAI_API_KEY": "your_api_key_here"
      }
    }
  }
}
```

### 使用unpkg (如果发布到NPM)
```json
{
  "mcpServers": {
    "imagegen-mcp": {
      "command": "node",
      "args": [
        "-e",
        "require('https').get('https://unpkg.com/@lupinlin1/imagegen-mcp/dist/index.js', res => { let data = ''; res.on('data', chunk => data += chunk); res.on('end', () => eval(data)); })"
      ],
      "env": {
        "OPENAI_API_KEY": "your_api_key_here"
      }
    }
  }
}
```

## 🔧 方案5: 安装脚本自动化

创建一个智能安装脚本，自动选择最佳方案：

```bash
#!/bin/bash
# smart-install.sh

# 检查NPM是否可用
if command -v npm >/dev/null 2>&1; then
    echo "使用NPM安装..."
    npm install -g @lupinlin1/imagegen-mcp
    exit 0
fi

# 检查Docker是否可用
if command -v docker >/dev/null 2>&1; then
    echo "使用Docker运行..."
    docker run --rm lupinlin1/imagegen-mcp --help
    exit 0
fi

# 最后选择：下载脚本
echo "下载本地脚本..."
curl -fsSL https://raw.githubusercontent.com/LupinLin1/imagegen-mcp/main/bin/mcp-imagegen.sh > mcp-imagegen.sh
chmod +x mcp-imagegen.sh
./mcp-imagegen.sh --help
```

## 🎨 创建配置生成器 (已实现)

我们已经创建了交互式配置生成器：

```bash
# 生成所有配置示例
npm run config:generate

# 交互式配置
npm run config:quick
```

## ⚡ 实施建议

### 立即可用的方案排序：

1. **本地脚本** (✅ 已实现) - 用户需要克隆仓库
2. **GitHub Raw** - 需要创建远程执行脚本
3. **Docker容器** - 需要构建和发布Docker镜像
4. **NPM发布** - 需要NPM账户认证

### 推荐实施策略：

1. **短期**: 使用本地脚本 + GitHub Raw方案
2. **中期**: 发布到NPM (最佳用户体验)
3. **长期**: 提供多种选择，满足不同用户需求

## 🛠️ 需要创建的额外文件

### GitHub Raw方案
- `scripts/run-remote.sh` - 远程执行脚本
- `scripts/download-and-run.js` - Node.js下载执行器

### Docker方案
- `Dockerfile` - 容器构建文件
- `docker-compose.yml` - 开发环境配置
- `.dockerignore` - Docker忽略文件

### 统一启动器
- `scripts/universal-launcher.sh` - 智能选择运行方式
- `docs/DEPLOYMENT-OPTIONS.md` - 部署选项说明

---

💡 **结论**: 虽然NPM发布是最佳方案，但通过这些备选方案，我们可以确保用户在任何情况下都能实现"接近零安装"的体验！