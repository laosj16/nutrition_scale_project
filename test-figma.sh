#!/bin/bash

echo "🧪 Figma MCP 测试脚本"
echo "===================="

# 检查Node.js
echo "📋 检查Node.js..."
if command -v node &> /dev/null; then
    echo "✅ Node.js: $(node --version)"
else
    echo "❌ Node.js 未安装"
    exit 1
fi

# 检查项目结构
echo ""
echo "📂 检查项目结构..."

required_files=(
    "mcp-figma/package.json"
    "mcp-figma/index.js"
    "mcp-figma/.env.example"
    "mcp-figma/README.md"
    ".vscode/settings.json"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file 缺失"
    fi
done

# 检查依赖
echo ""
echo "📦 检查MCP依赖..."
cd mcp-figma
if [ -f "package.json" ] && [ -d "node_modules" ]; then
    echo "✅ 依赖已安装"
    echo "📋 已安装的包:"
    npm list --depth=0 2>/dev/null | grep -E '@modelcontextprotocol|node-fetch|dotenv' || echo "   正在检查..."
else
    echo "⚠️  需要安装依赖: npm install"
fi

# 测试语法
echo ""
echo "🔍 测试代码语法..."
if node -c index.js 2>/dev/null; then
    echo "✅ MCP服务器代码语法正确"
else
    echo "❌ MCP服务器代码有语法错误"
fi

cd ..

# 检查配置
echo ""
echo "⚙️  检查配置..."
if [ -f "mcp-figma/.env" ]; then
    echo "✅ 找到配置文件 .env"
    if grep -q "FIGMA_ACCESS_TOKEN=" mcp-figma/.env; then
        token_value=$(grep "FIGMA_ACCESS_TOKEN=" mcp-figma/.env | cut -d'=' -f2)
        if [ -n "$token_value" ] && [ "$token_value" != "your_figma_token_here" ]; then
            echo "✅ Figma令牌已配置"
        else
            echo "⚠️  Figma令牌未配置"
        fi
    fi
else
    echo "⚠️  配置文件不存在，运行: npm run setup-figma"
fi

echo ""
echo "🏁 测试完成"
echo ""
echo "📋 下一步:"
echo "1. 如果需要配置: npm run setup-figma"
echo "2. 启动服务器: npm run start-figma"
echo "3. 在VS Code中重启以加载MCP配置"
