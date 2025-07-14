# Figma MCP Server

这是一个为智能食物秤项目定制的Figma MCP（Model Context Protocol）服务器，用于连接和操作Figma设计文件。

## 🚀 快速开始

### 1. 获取Figma访问令牌

1. 访问 [Figma设置页面](https://www.figma.com/settings)
2. 滚动到"Personal access tokens"部分
3. 点击"Create new token"
4. 给令牌起个名字（如"MCP Server Token"）
5. 复制生成的令牌

### 2. 获取Figma文件ID

从Figma文件URL中提取文件ID：
```
https://www.figma.com/file/ABC123456789/My-Design-File
                         ^^^^^^^^^^^^^^^^
                         这部分就是文件ID
```

### 3. 配置环境变量

```bash
# 复制示例配置文件
cp .env.example .env

# 编辑.env文件，填入您的信息
```

在`.env`文件中设置：
```env
FIGMA_ACCESS_TOKEN=your_actual_figma_token
FIGMA_FILE_ID=your_actual_file_id
```

### 4. 安装依赖

```bash
npm install
```

### 5. 启动服务器

```bash
# 开发模式（自动重启）
npm run dev

# 生产模式
npm start
```

## 🛠️ 可用工具

### `get_figma_file`
获取Figma文件的基本信息和页面结构
```json
{
  "name": "get_figma_file",
  "arguments": {
    "fileId": "可选，默认使用环境变量中的文件ID"
  }
}
```

### `get_figma_images` 
导出Figma文件中的图片资源
```json
{
  "name": "get_figma_images",
  "arguments": {
    "fileId": "可选，默认使用环境变量中的文件ID",
    "nodeIds": ["node1", "node2"],
    "format": "png|jpg|svg|pdf",
    "scale": 1
  }
}
```

### `get_figma_components`
获取文件中的组件信息
```json
{
  "name": "get_figma_components",
  "arguments": {
    "fileId": "可选，默认使用环境变量中的文件ID"
  }
}
```

### `get_figma_styles`
获取文件中的样式信息（颜色、字体等）
```json
{
  "name": "get_figma_styles",
  "arguments": {
    "fileId": "可选，默认使用环境变量中的文件ID"
  }
}
```

## 🔗 VS Code集成

要在VS Code中使用此MCP服务器，请在VS Code设置中添加：

```json
{
  "mcp.servers": {
    "figma": {
      "command": "node",
      "args": ["/path/to/nutrition_scale_project/mcp-figma/index.js"],
      "env": {
        "FIGMA_ACCESS_TOKEN": "your_token",
        "FIGMA_FILE_ID": "your_file_id"
      }
    }
  }
}
```

## 📝 使用场景

对于智能食物秤项目，您可以使用此MCP服务器来：

1. **同步设计规范**: 获取Figma中定义的颜色、字体、间距等设计令牌
2. **导出资源**: 自动导出图标、插图等设计资源
3. **检查设计变更**: 监控设计文件的更新
4. **获取组件信息**: 了解设计系统中的组件结构

## 🔧 故障排除

### 令牌无效
- 确认令牌是否正确复制
- 检查令牌是否有足够的权限
- 令牌可能已过期，需要重新生成

### 文件ID错误
- 确认文件ID是否正确
- 检查是否有该文件的访问权限
- 确认文件是否为公开或已共享

### 网络问题
- 检查网络连接
- 确认防火墙没有阻止Figma API访问

## 📄 API参考

基于[Figma REST API](https://www.figma.com/developers/api)构建。
