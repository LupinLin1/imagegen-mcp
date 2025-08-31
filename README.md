# MCP OpenAI Image Generation Server

[![npm version](https://img.shields.io/npm/v/@lupinlin1/imagegen-mcp)](https://www.npmjs.com/package/@lupinlin1/imagegen-mcp)

> 🚀 **零安装配置！** 直接在MCP客户端中使用，无需任何预安装步骤
>
> ```json
> {
>   "mcpServers": {
>     "imagegen-mcp": {
>       "command": "npx",
>       "args": ["@lupinlin1/imagegen-mcp", "--models", "dall-e-3"],
>       "env": { "OPENAI_API_KEY": "your_api_key" }
>     }
>   }
> }
> ```

This project provides a server implementation based on the [Model Context Protocol (MCP)](https://modelcontextprotocol.io/introduction) that acts as a wrapper around OpenAI's Image Generation and Editing APIs (see [OpenAI documentation](https://platform.openai.com/docs/api-reference/images)).

## Features

*   Exposes OpenAI image generation capabilities through MCP tools.
*   Supports `text-to-image` generation using models like DALL-E 2, DALL-E 3, and gpt-image-1 (if available/enabled).
*   Supports `image-to-image` editing using DALL-E 2 and gpt-image-1 (if available/enabled).
*   Configurable via environment variables and command-line arguments.
*   Handles various parameters like size, quality, style, format, etc.
*   Saves generated/edited images to temporary files and returns the path along with the base64 data.

Here's an example of generating an image directly in Cursor using the `text-to-image` tool integrated via MCP:

<div align="center">
  <img src="https://raw.githubusercontent.com/spartanz51/imagegen-mcp/refs/heads/main/cursor.gif" alt="Example usage in Cursor" width="600"/>
</div>

## 🚀 安装方式

### 🎯 零安装配置 (推荐)

**方式1: NPX自动下载** (需要NPM发布)
```bash
npm install -g @lupinlin1/imagegen-mcp
```

**方式2: GitHub远程执行** (立即可用)
```bash
# 一行命令安装脚本
curl -fsSL https://raw.githubusercontent.com/LupinLin1/imagegen-mcp/main/scripts/install.sh | bash
```

**方式3: 本地脚本** (开发者友好)
```bash
git clone https://github.com/LupinLin1/imagegen-mcp.git
cd imagegen-mcp
npm install && npm run build
```

### 📊 方案对比

| 方式 | 安装步骤 | 网络依赖 | 启动速度 | 适用场景 |
|------|----------|----------|----------|----------|
| NPX自动下载 | 0步 | 首次需要 | 快 | 生产环境 |
| GitHub远程 | 0步 | 每次需要 | 中等 | 快速试用 |
| 本地脚本 | 1步克隆 | 无 | 最快 | 开发测试 |

📁 **更多配置**: 查看 [`examples/mcp-configs/`](./examples/mcp-configs/) 获取所有配置示例

## Prerequisites

*   Node.js (v18 or later recommended)
*   npm or yarn
*   An OpenAI API key

## 🎯 零安装配置 (推荐)

**无需任何预安装步骤！**直接配置即可使用：

### Cursor 编辑器
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

### Claude Desktop
```json
{
  "mcpServers": {
    "imagegen-mcp": {
      "command": "npx",
      "args": ["@lupinlin1/imagegen-mcp"],
      "env": {
        "OPENAI_API_KEY": "your_openai_api_key_here"
      }
    }
  }
}
```

### 💡 零安装原理
- ✅ **首次运行**: `npx` 自动下载并缓存包
- ✅ **后续启动**: 使用缓存，启动快速
- ✅ **自动更新**: 始终使用最新版本
- ✅ **无污染**: 不会全局安装任何包

📁 **更多配置示例**: 查看 [`examples/mcp-configs/`](./examples/mcp-configs/) 目录

## Setup

1.  **Clone the repository:**
    ```bash
    git clone <your-repository-url>
    cd <repository-directory>
    ```

2.  **Install dependencies:**
    ```bash
    npm install
    # or
    yarn install
    ```

3.  **Configure Environment Variables:**
    Create a `.env` file in the project root by copying the example:
    ```bash
    cp .env.example .env
    ```
    Edit the `.env` file and add your OpenAI API key:
    ```
    OPENAI_API_KEY=your_openai_api_key_here
    ```

## Building

To build the TypeScript code into JavaScript:
```bash
npm run build
# or
yarn build
```
This will compile the code into the `dist` directory.

## Running the Server

This section provides details on running the server locally after cloning and setup. For a quick start without cloning, see the [Quick Run with npx](#quick-run-with-npx) section.

**Using ts-node (for development):**
```bash
npx ts-node src/index.ts [options]
```

**Using the compiled code:**
```bash
node dist/index.js [options]
```

**Options:**

*   `--models <model1> <model2> ...`: Specify which OpenAI models the server should allow. If not provided, it defaults to allowing all models defined in `src/libs/openaiImageClient.ts` (currently gpt-image-1, dall-e-2, dall-e-3).
    *   Example using `npx` (also works for local runs): `... --models gpt-image-1 dall-e-3`
    *   Example after cloning: `node dist/index.js --models dall-e-3 dall-e-2`

The server will start and listen for MCP requests via standard input/output (using `StdioServerTransport`).

## MCP Tools

The server exposes the following MCP tools:

### `text-to-image`

Generates an image based on a text prompt.

**Parameters:**

*   `text` (string, required): The prompt to generate an image from.
*   `model` (enum, optional): The model to use (e.g., `gpt-image-1`, `dall-e-2`, `dall-e-3`). Defaults to the first allowed model.
*   `size` (enum, optional): Size of the generated image (e.g., `1024x1024`, `1792x1024`). Defaults to `1024x1024`. Check OpenAI documentation for model-specific size support.
*   `style` (enum, optional): Style of the image (`vivid` or `natural`). Only applicable to `dall-e-3`. Defaults to `vivid`.
*   `output_format` (enum, optional): Format (`png`, `jpeg`, `webp`). Defaults to `png`.
*   `output_compression` (number, optional): Compression level (0-100). Defaults to 100.
*   `moderation` (enum, optional): Moderation level (`low`, `auto`). Defaults to `low`.
*   `background` (enum, optional): Background (`transparent`, `opaque`, `auto`). Defaults to `auto`. `transparent` requires `output_format` to be `png` or `webp`.
*   `quality` (enum, optional): Quality (`standard`, `hd`, `auto`, ...). Defaults to `auto`. `hd` only applicable to `dall-e-3`.
*   `n` (number, optional): Number of images to generate. Defaults to 1. Note: `dall-e-3` only supports `n=1`.

**Returns:**

*   `content`: An array containing:
    *   A `text` object containing the path to the saved temporary image file (e.g., `/tmp/uuid.png`).

### `image-to-image`

Edits an existing image based on a text prompt and optional mask.

**Parameters:**

*   `images` (string, required): An array of *file paths* to local images.
*   `prompt` (string, required): A text description of the desired edits.
*   `mask` (string, optional): A *file path* of mask image (PNG). Transparent areas indicate where the image should be edited.
*   `model` (enum, optional): The model to use. Only `gpt-image-1` and `dall-e-2` are supported for editing. Defaults to the first allowed model.
*   `size` (enum, optional): Size of the generated image (e.g., `1024x1024`). Defaults to `1024x1024`. `dall-e-2` only supports `256x256`, `512x512`, `1024x1024`.
*   `output_format` (enum, optional): Format (`png`, `jpeg`, `webp`). Defaults to `png`.
*   `output_compression` (number, optional): Compression level (0-100). Defaults to 100.
*   `quality` (enum, optional): Quality (`standard`, `hd`, `auto`, ...). Defaults to `auto`.
*   `n` (number, optional): Number of images to generate. Defaults to 1.

**Returns:**

*   `content`: An array containing:
    *   A `text` object containing the path to the saved temporary image file (e.g., `/tmp/uuid.png`).

## Development

*   **Linting:** `npm run lint` or `yarn lint`
*   **Formatting:** `npm run format` or `yarn format` (if configured in `package.json`)

## Contributing

Pull Requests (PRs) are welcome! Please feel free to submit improvements or bug fixes. 