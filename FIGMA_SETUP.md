# 🎨 Figma MCP 快速使用指南

## 🚀 立即开始

### 1. 获取Figma访问令牌
1. 访问 https://www.figma.com/settings
2. 找到 "Personal access tokens" 部分
3. 点击 "Create new token"
4. 复制生成的令牌

### 2. 运行配置向导
```bash
npm run setup-figma
```
按提示输入您的Figma令牌和文件ID

### 3. 启动MCP服务器
```bash
# 开发模式（自动重启）
npm run dev-figma

# 生产模式
npm run start-figma
```

### 4. 在VS Code中使用
重启VS Code后，您可以使用以下工具：

- `@figma get_figma_file` - 获取设计文件信息
- `@figma get_figma_images` - 导出图片资源
- `@figma get_figma_components` - 获取组件库
- `@figma get_figma_styles` - 获取设计令牌

## 🔧 常用命令

```bash
# 配置Figma连接
npm run setup-figma

# 启动服务器
npm run start-figma
npm run dev-figma

# 运行演示
cd mcp-figma && npm run demo

# 测试配置
cd mcp-figma && npm test
```

## 💡 使用场景

### 同步设计规范
```javascript
// 获取颜色和字体样式
await figma.get_figma_styles({
  fileId: "your-design-system-file"
});
```

### 导出图标资源
```javascript
// 导出特定组件为PNG
await figma.get_figma_images({
  nodeIds: ["icon-node-id"],
  format: "png",
  scale: 2
});
```

### 检查设计更新
```javascript
// 获取文件的最新版本信息
await figma.get_figma_file({
  fileId: "your-file-id"
});
```

## 🛠️ 故障排除

### 令牌问题
- 确认令牌是否正确
- 检查令牌权限
- 重新生成令牌

### 文件访问
- 确认文件ID正确
- 检查文件共享权限
- 确认您有访问权限

### 网络问题
- 检查网络连接
- 确认防火墙设置
- 尝试使用VPN

## 📞 获取帮助

- 查看 [完整文档](./mcp-figma/README.md)
- 检查 [VS Code设置](./.vscode/settings.json)
- 运行 `npm run demo-figma` 测试连接

---

💡 **提示**: 首次使用建议先运行演示来熟悉功能！
