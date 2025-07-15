#!/bin/bash

echo "🎨 配置智能食物秤设计文件连接"
echo "================================="
echo "文件: 设备相关设计"
echo "ID: ERC9CODVdzEDqjEx0beLox"
echo ""

# 检查是否已有配置
if [ -f "mcp-figma/.env" ]; then
    echo "✅ 发现现有配置文件"
    read -p "是否要使用预设的文件ID配置？(Y/n): " use_preset
    if [[ $use_preset == [Nn] ]]; then
        echo "保持现有配置"
        exit 0
    fi
fi

echo "📝 请输入您的Figma访问令牌："
echo "   获取方法：https://www.figma.com/settings -> Personal access tokens"
echo ""
read -p "Figma访问令牌: " figma_token

if [ -z "$figma_token" ]; then
    echo "❌ 错误：访问令牌不能为空"
    exit 1
fi

# 使用预设的文件ID
figma_file_id="ERC9CODVdzEDqjEx0beLox"
figma_node_id="1761-2"

# 创建.env文件
cat > mcp-figma/.env << EOF
# Figma API配置 - 智能食物秤设备相关设计
FIGMA_ACCESS_TOKEN=$figma_token
FIGMA_FILE_ID=$figma_file_id

# 特定节点ID (您分享的具体页面)
FIGMA_NODE_ID=$figma_node_id

# MCP服务器配置
MCP_PORT=3001

# 文件信息
FIGMA_FILE_NAME=设备相关设计
FIGMA_URL=https://www.figma.com/design/ERC9CODVdzEDqjEx0beLox/设备相关设计
EOF

echo ""
echo "✅ 配置已保存"
echo ""

# 测试连接
echo "🔍 测试Figma API连接..."
cd mcp-figma

test_result=$(node -e "
import fetch from 'node-fetch';
const token = '$figma_token';
const fileId = '$figma_file_id';

fetch(\`https://api.figma.com/v1/files/\${fileId}\`, {
    headers: { 'X-Figma-Token': token }
})
.then(res => res.json())
.then(data => {
    if (data.error) {
        console.log('ERROR: ' + data.error);
    } else {
        console.log('SUCCESS: ' + data.name);
        console.log('PAGES: ' + data.document.children.length);
    }
})
.catch(err => console.log('ERROR: ' + err.message));
" 2>/dev/null)

if [[ $test_result == SUCCESS:* ]]; then
    echo "✅ 连接成功！"
    echo "   ${test_result}"
    echo ""
    echo "🎯 您现在可以："
    echo "1. 运行 'npm run start-figma' 启动MCP服务器"
    echo "2. 在VS Code中使用 @figma 命令"
    echo "3. 获取设计文件信息和资源"
else
    echo "❌ 连接失败: ${test_result#ERROR: }"
    echo "   请检查令牌是否正确，或者文件是否有访问权限"
fi

cd ..

echo ""
echo "📚 可用功能:"
echo "• @figma get_figma_file - 获取整个设计文件信息"
echo "• @figma get_figma_images - 导出特定组件图片"
echo "• @figma get_figma_components - 获取所有组件"
echo "• @figma get_figma_styles - 获取颜色和字体样式"
