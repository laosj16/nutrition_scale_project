# 智能食物秤 Pro - 交互原型

> 一个高保真的智能食物秤交互原型，用于展示产品设计和用户操作流程

## 📱 项目概述

这是一个使用 Web 技术实现的智能食物秤交互原型，主要用于：

- **可视化展示**产品设计和用户操作流程
- **验证UI/UX设计**的合理性与易用性  
- **为嵌入式固件开发**提供前端界面和交互逻辑参考

## 🚀 快速开始

1. 克隆仓库到本地
```bash
git clone https://github.com/laosj16/nutrition_scale_project.git
cd nutrition_scale_project
```

2. 在浏览器中打开 `index.html` 文件即可开始体验

无需安装任何依赖或本地服务器！

### 🎨 连接Figma（可选）

如果您想连接Figma设计文件来同步设计资源：

```bash
# 运行配置向导
npm run setup-figma

# 启动Figma MCP服务器
npm run start-figma
```

详细配置说明请查看 [Figma MCP文档](./mcp-figma/README.md)

## 🎯 功能特性

### 核心功能
- **通用称重**：基础称重功能，支持多种单位切换
- **营养秤**：食物选择、营养成分计算、App连接引导
- **设置系统**：语言设置、恢复出厂设置、设备信息

### 系统状态模拟
- 电池状态（低电量警告、充电状态）
- 设备保护（超载提示）
- 电源管理（关机演示）

### 交互特色
- **横屏显示**：模拟4:3宽屏设备界面
- **单旋钮交互**：旋转选择、短按确认、长按返回/关机
- **统一交互逻辑**：
  - 1秒内松开：取消长按操作
  - 1-5秒间松开：返回上一级菜单
  - 5秒及以上：直接关机

## 📁 项目结构

```
nutrition_scale_project/
├── index.html                      # 主导航页面
├── main_menu.html                   # 主菜单
├── general_weighing.html            # 通用称重
├── nutrition_scale.html             # 营养秤
├── nutrition_scale_connect_app.html # 营养秤连接App
├── settings_menu.html               # 设置菜单
├── settings_language.html           # 语言设置
├── settings_factory_reset.html      # 恢复出厂设置
├── settings_about.html              # 关于设备
├── low_battery.html                 # 低电量警告
├── Power_off.html                   # 返回与关机演示
├── charging_status.html             # 充电状态
├── overload_prompt.html             # 超载提示
├── mcp-figma/                       # Figma MCP服务器
│   ├── index.js                     # MCP服务器主文件
│   ├── package.json                 # 依赖配置
│   ├── README.md                    # MCP详细文档
│   └── .env.example                 # 配置示例
├── .vscode/                         # VS Code配置
├── setup-figma.sh                   # Figma配置向导
├── test-figma.sh                    # 测试脚本
├── FIGMA_SETUP.md                   # 快速使用指南
└── FIGMA_EXAMPLES.md                # 使用示例
```

## 🎮 使用说明

### 🖥️ 基本使用
1. 从 `index.html` 开始，查看完整的功能导航
2. 点击链接进入各功能模块
3. 使用底部控制按钮模拟设备交互
4. 通过"返回目录"按钮随时回到导航页面

### 🎨 Figma集成使用
```bash
# 快速配置
npm run setup-figma

# 启动MCP服务器
npm run start-figma

# 测试配置
npm run test-figma
```

详细说明请查看：
- [快速使用指南](./FIGMA_SETUP.md)
- [使用示例](./FIGMA_EXAMPLES.md)
- [完整文档](./mcp-figma/README.md)

### 交互控制
每个页面底部都有模拟控制按钮：
- **← 旋转 / 旋转 →**：模拟旋钮左右旋转
- **确认/TARE/停止**：短按功能（根据上下文动态变化）
- **长按（返回/关机）**：长按旋钮操作
- **返回目录**：直接回到导航页面

## 🎨 技术实现

- **HTML5 + CSS3 + JavaScript**：原生Web技术
- **TailwindCSS**：现代化UI框架
- **FontAwesome**：图标库
- **响应式设计**：适配不同屏幕尺寸
- **深色主题**：模拟真实设备外观
- **Figma MCP集成**：可选的设计文件同步功能

## 🔗 Figma集成

项目包含了一个自定义的Figma MCP（Model Context Protocol）服务器，可以：

- 📄 获取Figma设计文件信息
- 🖼️ 导出设计资源和图片
- 🎨 同步设计令牌（颜色、字体等）
- 📦 获取组件和样式信息

### 配置Figma连接

```bash
# 运行配置向导
npm run setup-figma

# 启动MCP服务器
npm run start-figma
```

更多详情请查看 [mcp-figma/README.md](./mcp-figma/README.md)

## 👤 作者

**产品中心 - 胡中华**

## 📄 许可证

本项目仅供内部产品开发参考使用

---

> 💡 这个原型完美展现了硬件设备的交互体验，为产品开发提供了极有价值的参考！
