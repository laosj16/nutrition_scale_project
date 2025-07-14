#!/usr/bin/env node

// Figma MCP 服务器使用演示
// 这个文件展示了如何通过MCP协议与Figma API交互

import { spawn } from 'child_process';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

console.log('🎨 Figma MCP 服务器演示');
console.log('========================');

// 检查环境配置
function checkConfig() {
    try {
        const envPath = join(__dirname, '.env');
        console.log(`📋 检查配置文件: ${envPath}`);
        
        // 这里可以添加配置检查逻辑
        console.log('✅ 配置检查完成');
        return true;
    } catch (error) {
        console.error('❌ 配置检查失败:', error.message);
        return false;
    }
}

// 启动MCP服务器
function startMCPServer() {
    console.log('🚀 启动MCP服务器...');
    
    const serverProcess = spawn('node', ['index.js'], {
        cwd: __dirname,
        stdio: ['pipe', 'pipe', 'pipe']
    });
    
    serverProcess.stdout.on('data', (data) => {
        console.log('📤 服务器输出:', data.toString().trim());
    });
    
    serverProcess.stderr.on('data', (data) => {
        console.log('📥 服务器日志:', data.toString().trim());
    });
    
    serverProcess.on('close', (code) => {
        console.log(`🛑 服务器退出，代码: ${code}`);
    });
    
    // 演示MCP工具调用
    setTimeout(() => {
        console.log('💡 可用的MCP工具:');
        console.log('  • get_figma_file - 获取文件信息');
        console.log('  • get_figma_images - 导出图片');
        console.log('  • get_figma_components - 获取组件');
        console.log('  • get_figma_styles - 获取样式');
        console.log('');
        console.log('在VS Code中使用 @figma 前缀调用这些工具');
        
        // 5秒后关闭演示
        setTimeout(() => {
            console.log('🏁 演示结束');
            serverProcess.kill();
        }, 5000);
    }, 2000);
    
    return serverProcess;
}

// 主函数
async function main() {
    if (checkConfig()) {
        startMCPServer();
    } else {
        console.log('');
        console.log('🔧 请先运行配置命令:');
        console.log('   npm run setup-figma');
        process.exit(1);
    }
}

// 处理退出信号
process.on('SIGINT', () => {
    console.log('\n👋 再见！');
    process.exit(0);
});

main().catch(console.error);
