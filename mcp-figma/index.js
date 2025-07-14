#!/usr/bin/env node

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
import fetch from 'node-fetch';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// 加载环境变量
dotenv.config({ path: join(__dirname, '.env') });

const FIGMA_ACCESS_TOKEN = process.env.FIGMA_ACCESS_TOKEN;
const FIGMA_FILE_ID = process.env.FIGMA_FILE_ID;

if (!FIGMA_ACCESS_TOKEN) {
  console.error('请在.env文件中设置FIGMA_ACCESS_TOKEN');
  process.exit(1);
}

class FigmaMCPServer {
  constructor() {
    this.server = new Server(
      {
        name: 'figma-mcp-server',
        version: '1.0.0',
      },
      {
        capabilities: {
          tools: {},
        },
      }
    );

    this.setupToolHandlers();
  }

  setupToolHandlers() {
    // 列出可用工具
    this.server.setRequestHandler(ListToolsRequestSchema, async () => {
      return {
        tools: [
          {
            name: 'get_figma_file',
            description: '获取Figma文件信息和页面结构',
            inputSchema: {
              type: 'object',
              properties: {
                fileId: {
                  type: 'string',
                  description: 'Figma文件ID（可选，默认使用环境变量）',
                },
              },
            },
          },
          {
            name: 'get_figma_images',
            description: '导出Figma文件中的图片资源',
            inputSchema: {
              type: 'object',
              properties: {
                fileId: {
                  type: 'string',
                  description: 'Figma文件ID（可选，默认使用环境变量）',
                },
                nodeIds: {
                  type: 'array',
                  items: { type: 'string' },
                  description: '要导出的节点ID列表',
                },
                format: {
                  type: 'string',
                  enum: ['jpg', 'png', 'svg', 'pdf'],
                  default: 'png',
                  description: '导出格式',
                },
                scale: {
                  type: 'number',
                  default: 1,
                  description: '导出缩放比例',
                },
              },
              required: ['nodeIds'],
            },
          },
          {
            name: 'get_figma_components',
            description: '获取Figma文件中的组件信息',
            inputSchema: {
              type: 'object',
              properties: {
                fileId: {
                  type: 'string',
                  description: 'Figma文件ID（可选，默认使用环境变量）',
                },
              },
            },
          },
          {
            name: 'get_figma_styles',
            description: '获取Figma文件中的样式信息（颜色、字体等）',
            inputSchema: {
              type: 'object',
              properties: {
                fileId: {
                  type: 'string',
                  description: 'Figma文件ID（可选，默认使用环境变量）',
                },
              },
            },
          },
        ],
      };
    });

    // 处理工具调用
    this.server.setRequestHandler(CallToolRequestSchema, async (request) => {
      const { name, arguments: args } = request.params;

      try {
        switch (name) {
          case 'get_figma_file':
            return await this.getFigmaFile(args.fileId);
          case 'get_figma_images':
            return await this.getFigmaImages(args.fileId, args.nodeIds, args.format, args.scale);
          case 'get_figma_components':
            return await this.getFigmaComponents(args.fileId);
          case 'get_figma_styles':
            return await this.getFigmaStyles(args.fileId);
          default:
            throw new Error(`未知工具: ${name}`);
        }
      } catch (error) {
        return {
          content: [
            {
              type: 'text',
              text: `错误: ${error.message}`,
            },
          ],
        };
      }
    });
  }

  async makeApiRequest(endpoint, options = {}) {
    const url = `https://api.figma.com/v1/${endpoint}`;
    const response = await fetch(url, {
      headers: {
        'X-Figma-Token': FIGMA_ACCESS_TOKEN,
        'Content-Type': 'application/json',
        ...options.headers,
      },
      ...options,
    });

    if (!response.ok) {
      throw new Error(`Figma API错误: ${response.status} ${response.statusText}`);
    }

    return response.json();
  }

  async getFigmaFile(fileId = FIGMA_FILE_ID) {
    if (!fileId) {
      throw new Error('请提供Figma文件ID');
    }

    const fileData = await this.makeApiRequest(`files/${fileId}`);
    
    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify({
            name: fileData.name,
            lastModified: fileData.lastModified,
            thumbnailUrl: fileData.thumbnailUrl,
            version: fileData.version,
            pages: fileData.document.children.map(page => ({
              id: page.id,
              name: page.name,
              type: page.type,
              children: page.children?.length || 0,
            })),
          }, null, 2),
        },
      ],
    };
  }

  async getFigmaImages(fileId = FIGMA_FILE_ID, nodeIds, format = 'png', scale = 1) {
    if (!fileId) {
      throw new Error('请提供Figma文件ID');
    }

    if (!nodeIds || nodeIds.length === 0) {
      throw new Error('请提供要导出的节点ID');
    }

    const params = new URLSearchParams({
      ids: nodeIds.join(','),
      format,
      scale: scale.toString(),
    });

    const response = await this.makeApiRequest(`images/${fileId}?${params}`);

    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(response, null, 2),
        },
      ],
    };
  }

  async getFigmaComponents(fileId = FIGMA_FILE_ID) {
    if (!fileId) {
      throw new Error('请提供Figma文件ID');
    }

    const response = await this.makeApiRequest(`files/${fileId}/components`);

    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(response, null, 2),
        },
      ],
    };
  }

  async getFigmaStyles(fileId = FIGMA_FILE_ID) {
    if (!fileId) {
      throw new Error('请提供Figma文件ID');
    }

    const response = await this.makeApiRequest(`files/${fileId}/styles`);

    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(response, null, 2),
        },
      ],
    };
  }

  async run() {
    const transport = new StdioServerTransport();
    await this.server.connect(transport);
    console.error('Figma MCP服务器已启动');
  }
}

const server = new FigmaMCPServer();
server.run().catch(console.error);
