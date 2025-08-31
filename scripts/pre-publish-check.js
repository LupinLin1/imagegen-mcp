#!/usr/bin/env node

/**
 * 发布前检查脚本
 * 确保包可以安全发布到NPM
 */

import { execSync } from 'child_process';
import { readFileSync, existsSync } from 'fs';
import { join } from 'path';

// 颜色输出
const colors = {
  green: '\x1b[32m',
  red: '\x1b[31m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  reset: '\x1b[0m'
};

function log(message, color = 'reset') {
  console.log(colors[color] + message + colors.reset);
}

function checkCommand(command, description) {
  try {
    execSync(command, { stdio: 'pipe' });
    log(`✅ ${description}`, 'green');
    return true;
  } catch (error) {
    log(`❌ ${description}`, 'red');
    log(`   错误: ${error.message}`, 'red');
    return false;
  }
}

function checkFile(filePath, description) {
  if (existsSync(filePath)) {
    log(`✅ ${description}`, 'green');
    return true;
  } else {
    log(`❌ ${description} - 文件不存在: ${filePath}`, 'red');
    return false;
  }
}

async function main() {
  log('\n🔍 NPM发布前检查', 'blue');
  log('='.repeat(50), 'blue');

  let passed = 0;
  let failed = 0;

  // 检查项目文件
  log('\n📁 项目文件检查:', 'yellow');
  
  const fileChecks = [
    ['package.json', '包配置文件'],
    ['README.md', '说明文档'],
    ['LICENSE', '许可证文件'],
    ['dist/index.js', '构建后的主文件'],
    ['bin/imagegen-mcp.js', '可执行文件'],
    ['bin/mcp-imagegen.sh', 'Unix启动脚本'],
    ['bin/mcp-imagegen.cmd', 'Windows启动脚本']
  ];

  fileChecks.forEach(([file, desc]) => {
    if (checkFile(file, desc)) {
      passed++;
    } else {
      failed++;
    }
  });

  // 检查package.json内容
  log('\n📦 包配置检查:', 'yellow');
  
  try {
    const pkg = JSON.parse(readFileSync('package.json', 'utf8'));
    
    if (pkg.name === '@lupinlin1/imagegen-mcp') {
      log('✅ 包名正确', 'green');
      passed++;
    } else {
      log('❌ 包名不正确', 'red');
      failed++;
    }

    if (pkg.version && /^\d+\.\d+\.\d+/.test(pkg.version)) {
      log('✅ 版本号格式正确', 'green');
      passed++;
    } else {
      log('❌ 版本号格式错误', 'red');
      failed++;
    }

    if (pkg.bin && pkg.bin['imagegen-mcp']) {
      log('✅ bin配置正确', 'green');
      passed++;
    } else {
      log('❌ bin配置缺失', 'red');
      failed++;
    }

    if (pkg.files && pkg.files.length > 0) {
      log('✅ files字段已配置', 'green');
      passed++;
    } else {
      log('❌ files字段缺失', 'red');
      failed++;
    }

  } catch (error) {
    log('❌ package.json解析失败', 'red');
    failed++;
  }

  // 检查NPM状态
  log('\n🌐 NPM环境检查:', 'yellow');
  
  const npmChecks = [
    ['node --version', 'Node.js版本检查'],
    ['npm --version', 'NPM版本检查'],
    ['npm whoami', 'NPM登录状态检查']
  ];

  npmChecks.forEach(([cmd, desc]) => {
    if (checkCommand(cmd, desc)) {
      passed++;
    } else {
      failed++;
    }
  });

  // 检查Git状态
  log('\n📝 Git状态检查:', 'yellow');
  
  try {
    const gitStatus = execSync('git status --porcelain', { encoding: 'utf8' });
    if (gitStatus.trim() === '') {
      log('✅ 工作区干净 (所有更改已提交)', 'green');
      passed++;
    } else {
      log('⚠️  有未提交的更改', 'yellow');
      log('   建议: git add . && git commit', 'yellow');
      passed++; // 这不是致命错误
    }
  } catch (error) {
    log('❌ Git状态检查失败', 'red');
    failed++;
  }

  // 模拟打包
  log('\n📦 打包测试:', 'yellow');
  
  try {
    const packResult = execSync('npm pack --dry-run', { encoding: 'utf8' });
    log('✅ 打包模拟成功', 'green');
    passed++;
    
    // 提取包大小
    const sizeMatch = packResult.match(/package size:\s*([^\n]+)/);
    if (sizeMatch) {
      log(`   包大小: ${sizeMatch[1]}`, 'blue');
    }
  } catch (error) {
    log('❌ 打包模拟失败', 'red');
    log(`   错误: ${error.message}`, 'red');
    failed++;
  }

  // 显示结果
  log('\n📊 检查结果:', 'blue');
  log('='.repeat(50), 'blue');
  
  if (failed === 0) {
    log(`🎉 所有检查通过! (${passed}/${passed})`, 'green');
    log('\n🚀 可以开始发布:', 'green');
    log('   npm login', 'blue');
    log('   npm publish', 'blue');
    log('\n或使用发布脚本:', 'green');
    log('   ./scripts/publish.sh', 'blue');
  } else {
    log(`❌ ${failed} 项检查失败，${passed} 项通过`, 'red');
    log('\n🔧 请先解决上述问题再发布', 'red');
  }

  log('\n📖 详细发布指南: docs/PUBLISH-GUIDE.md', 'blue');
  
  process.exit(failed > 0 ? 1 : 0);
}

main().catch(console.error);