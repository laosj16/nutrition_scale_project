# 🎨 Figma MCP 使用示例

## 实际使用场景演示

### 1. 获取设计文件信息

在VS Code中，您可以这样使用：

```
@figma 请获取我的设计文件信息
```

MCP会调用 `get_figma_file` 工具，返回：
```json
{
  "name": "智能食物秤UI设计",
  "lastModified": "2025-07-14T10:30:00Z",
  "pages": [
    {
      "id": "0:1",
      "name": "主界面",
      "type": "CANVAS",
      "children": 5
    },
    {
      "id": "0:2", 
      "name": "设置页面",
      "type": "CANVAS",
      "children": 3
    }
  ]
}
```

### 2. 导出图标资源

```
@figma 请导出页面中的所有图标为PNG格式，2倍分辨率
```

MCP会：
1. 扫描设计文件找到图标组件
2. 调用 `get_figma_images` 导出高分辨率图片
3. 提供下载链接

### 3. 获取设计令牌

```
@figma 获取设计系统中的颜色和字体样式
```

返回的样式信息可以直接用于CSS：
```css
/* 从Figma获取的颜色 */
:root {
  --primary-blue: #007AFF;
  --text-primary: #1a1a1a;
  --text-secondary: #4b5563;
}

/* 从Figma获取的字体 */
.heading {
  font-family: 'Inter', sans-serif;
  font-weight: 700;
  font-size: 28px;
}
```

### 4. 同步组件库

```
@figma 检查组件库是否有更新
```

MCP会比较组件版本，提示哪些组件需要更新。

## 智能食物秤项目的实际应用

### 同步UI组件
- 获取按钮、卡片、输入框等组件的精确样式
- 导出图标用于HTML页面
- 确保设计与代码的一致性

### 自动化资源管理
- 批量导出不同分辨率的图片
- 生成CSS变量文件
- 更新色彩和字体配置

### 设计系统维护
- 监控设计文件变更
- 验证组件规范
- 生成设计文档

## 高级用法示例

### 批量处理
```javascript
// 通过MCP获取所有页面的组件
const pages = await figma.get_figma_file();
for (const page of pages.pages) {
  const components = await figma.get_figma_components(page.id);
  // 处理每个页面的组件
}
```

### 条件导出
```javascript
// 只导出特定类型的图标
const components = await figma.get_figma_components();
const icons = components.filter(c => c.name.includes('icon'));
const images = await figma.get_figma_images({
  nodeIds: icons.map(i => i.node_id),
  format: 'svg'
});
```

### 样式同步
```javascript
// 生成CSS变量文件
const styles = await figma.get_figma_styles();
const cssVars = styles.colors.map(color => 
  `--${color.name}: ${color.value};`
).join('\n');
```

## 最佳实践

### 1. 文件组织
- 在Figma中使用清晰的命名规范
- 组织好页面和组件层级
- 使用组件库管理可复用元素

### 2. 权限管理
- 使用专门的API令牌
- 定期轮换访问令牌
- 限制令牌权限范围

### 3. 自动化工作流
- 设置定时同步任务
- 集成到CI/CD流程
- 建立设计变更通知机制

### 4. 版本控制
- 跟踪设计文件版本
- 记录重要变更
- 维护设计与代码的对应关系

---

💡 **提示**: 这些示例展示了MCP的强大功能，实际使用时可以根据项目需求进行调整和扩展。
