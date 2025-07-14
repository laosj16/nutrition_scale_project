#!/bin/bash

echo "🎨 Figma MCP 服务器配置向导"
echo "================================="

# 检查是否已有配置文件
if [ -f "mcp-figma/.env" ]; then
    echo "✅ 发现现有配置文件"
    read -p "是否要重新配置？(y/N): " reconfigure
    if [[ $reconfigure != [Yy] ]]; then
        echo "保持现有配置"
        exit 0
    fi
fi

echo ""
echo "📝 请按提示输入配置信息："
echo ""

# 获取Figma访问令牌
echo "1️⃣ Figma访问令牌"
echo "   获取方法：https://www.figma.com/settings -> Personal access tokens"
echo ""
read -p "请输入您的Figma访问令牌: " figma_token

if [ -z "$figma_token" ]; then
    echo "❌ 错误：访问令牌不能为空"
    exit 1
fi

echo ""
echo "2️⃣ Figma文件ID"
echo "   从URL中提取：https://www.figma.com/file/ABC123/Design -> ABC123"
echo ""
read -p "请输入Figma文件ID (可选，稍后也可设置): " figma_file_id

# 创建.env文件
cat > mcp-figma/.env << EOF
# Figma API配置
FIGMA_ACCESS_TOKEN=$figma_token
FIGMA_FILE_ID=$figma_file_id

# MCP服务器配置
MCP_PORT=3001
EOF

echo ""
echo "✅ 配置已保存到 mcp-figma/.env"
echo ""

# 测试连接
echo "🔍 测试Figma API连接..."
cd mcp-figma

if [ -n "$figma_file_id" ]; then
    # 如果提供了文件ID，测试获取文件信息
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
            }
        })
        .catch(err => console.log('ERROR: ' + err.message));
    " 2>/dev/null)
    
    if [[ $test_result == SUCCESS:* ]]; then
        echo "✅ 连接成功！文件名: ${test_result#SUCCESS: }"
    else
        echo "❌ 连接失败: ${test_result#ERROR: }"
        echo "   请检查令牌和文件ID是否正确"
    fi
else
    # 只测试令牌有效性
    test_result=$(node -e "
        import fetch from 'node-fetch';
        const token = '$figma_token';
        
        fetch('https://api.figma.com/v1/me', {
            headers: { 'X-Figma-Token': token }
        })
        .then(res => res.json())
        .then(data => {
            if (data.error) {
                console.log('ERROR: ' + data.error);
            } else {
                console.log('SUCCESS: ' + data.email);
            }
        })
        .catch(err => console.log('ERROR: ' + err.message));
    " 2>/dev/null)
    
    if [[ $test_result == SUCCESS:* ]]; then
        echo "✅ 令牌有效！用户: ${test_result#SUCCESS: }"
        echo "ℹ️  稍后可以通过重新运行此脚本来设置文件ID"
    else
        echo "❌ 令牌无效: ${test_result#ERROR: }"
        echo "   请检查令牌是否正确"
    fi
fi

cd ..

echo ""
echo "🚀 接下来的步骤："
echo "1. 运行 'npm run start-figma' 启动MCP服务器"
echo "2. 在VS Code中重启以加载MCP配置"
echo "3. 使用Copilot命令调用Figma工具"
echo ""
echo "📚 查看完整文档：./mcp-figma/README.md"
