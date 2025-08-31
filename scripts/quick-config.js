#!/usr/bin/env node

/**
 * 快速配置生成器
 * 交互式生成MCP配置
 */

import readline from 'readline';
import { existsSync, writeFileSync } from 'fs';
import { join } from 'path';

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// ANSI颜色
const colors = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  green: '\x1b[32m',
  blue: '\x1b[34m',
  yellow: '\x1b[33m',
  red: '\x1b[31m'
};

function colorize(text, color) {
  return colors[color] + text + colors.reset;
}

function question(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

async function main() {
  console.log(colorize('\n🚀 imagegen-mcp 快速配置生成器', 'bright'));
  console.log(colorize('=====================================\n', 'blue'));

  try {
    // 1. 选择客户端
    console.log(colorize('1. 选择你的MCP客户端:', 'green'));
    console.log('   1) Cursor 编辑器');
    console.log('   2) Claude Desktop');
    console.log('   3) 其他MCP客户端');
    console.log('   4) 自定义配置\n');

    const clientChoice = await question('请选择 (1-4): ');
    
    // 2. 选择安装方式
    console.log(colorize('\n2. 选择安装方式:', 'green'));
    console.log('   1) NPX自动下载 (推荐) - 零安装');
    console.log('   2) 本地脚本 - 需要项目源码');
    console.log('   3) 全局安装 - 需要npm install -g\n');

    const installChoice = await question('请选择 (1-3): ');

    // 3. 选择模型
    console.log(colorize('\n3. 选择OpenAI模型:', 'green'));
    console.log('   1) DALL-E 3 (推荐)');
    console.log('   2) GPT-Image-1');
    console.log('   3) DALL-E 2');
    console.log('   4) 全部模型\n');

    const modelChoice = await question('请选择 (1-4): ');

    // 4. API密钥
    console.log(colorize('\n4. OpenAI API 配置:', 'green'));
    const hasApiKey = await question('你已经有OpenAI API密钥了吗? (y/N): ');
    
    let apiKey = 'your_openai_api_key_here';
    if (hasApiKey.toLowerCase() === 'y' || hasApiKey.toLowerCase() === 'yes') {
      const inputKey = await question('请输入API密钥 (或按Enter使用占位符): ');
      if (inputKey.trim()) {
        apiKey = inputKey.trim();
      }
    } else {
      console.log(colorize('   💡 请访问 https://platform.openai.com/api-keys 获取API密钥', 'yellow'));
    }

    // 生成配置
    const config = generateConfig({
      client: clientChoice,
      install: installChoice,
      model: modelChoice,
      apiKey: apiKey
    });

    // 显示配置
    console.log(colorize('\n✨ 生成的配置:', 'green'));
    console.log(colorize('='.repeat(50), 'blue'));
    console.log(JSON.stringify(config, null, 2));
    console.log(colorize('='.repeat(50), 'blue'));

    // 保存选项
    const saveConfig = await question('\n是否保存到文件? (y/N): ');
    if (saveConfig.toLowerCase() === 'y') {
      const filename = `mcp-config-${Date.now()}.json`;
      writeFileSync(filename, JSON.stringify(config, null, 2));
      console.log(colorize(`✅ 配置已保存到: ${filename}`, 'green'));
    }

    // 使用说明
    console.log(colorize('\n📋 使用说明:', 'bright'));
    if (clientChoice === '1') {
      console.log('1. 在Cursor中按 Ctrl/Cmd + ,');
      console.log('2. 搜索 "MCP"');
      console.log('3. 点击 "Edit in settings.json"');
      console.log('4. 将上面的配置复制到mcpServers部分');
      console.log('5. 保存并重启Cursor');
    } else if (clientChoice === '2') {
      console.log('1. 找到Claude Desktop配置文件:');
      console.log('   macOS: ~/Library/Application Support/Claude/claude_desktop_config.json');
      console.log('   Windows: %APPDATA%\\Claude\\claude_desktop_config.json');
      console.log('2. 将上面的配置添加到文件中');
      console.log('3. 重启Claude Desktop');
    } else {
      console.log('1. 将配置添加到你的MCP客户端配置文件');
      console.log('2. 重启客户端应用');
    }

    if (apiKey === 'your_openai_api_key_here') {
      console.log(colorize('\n⚠️  记得替换API密钥!', 'red'));
    }

  } catch (error) {
    console.error(colorize(`❌ 错误: ${error.message}`, 'red'));
  } finally {
    rl.close();
  }
}

function generateConfig({ client, install, model, apiKey }) {
  // 生成命令和参数
  let command, args;

  switch (install) {
    case '1': // NPX
      command = 'npx';
      args = ['@lupinlin1/imagegen-mcp'];
      break;
    case '2': // 本地脚本
      if (process.platform === 'win32') {
        command = './bin/mcp-imagegen.cmd';
      } else {
        command = './bin/mcp-imagegen.sh';
      }
      args = [];
      break;
    case '3': // 全局安装
      command = 'imagegen-mcp';
      args = [];
      break;
    default:
      command = 'npx';
      args = ['@lupinlin1/imagegen-mcp'];
  }

  // 添加模型参数
  const modelMap = {
    '1': ['dall-e-3'],
    '2': ['gpt-image-1'],
    '3': ['dall-e-2'],
    '4': ['dall-e-3', 'gpt-image-1', 'dall-e-2']
  };

  if (modelMap[model]) {
    args.push('--models', ...modelMap[model]);
  }

  // 生成配置对象
  const config = {
    mcpServers: {
      "imagegen-mcp": {
        command: command,
        env: {
          "OPENAI_API_KEY": apiKey
        }
      }
    }
  };

  if (args.length > 0) {
    config.mcpServers["imagegen-mcp"].args = args;
  }

  // 如果是本地脚本，添加cwd
  if (install === '2') {
    config.mcpServers["imagegen-mcp"].cwd = process.platform === 'win32' 
      ? 'C:\\path\\to\\imagegen-mcp' 
      : '/path/to/imagegen-mcp';
  }

  return config;
}

// 运行主函数
main().catch(console.error);