# AI API 配置指南 / OpenAI-Compatible API Config Guide

国内开发者接入 Claude / GPT / Gemini / DeepSeek 等大模型时,最常卡在「官方接口不可直连」和「各工具配置写法不一样」这两点。

这个仓库把 **Cursor、Claude Code、Dify、OpenWebUI、Chatbox** 等主流工具接入 **OpenAI 兼容接口** 的配置方式、可直接复制的模板和排查脚本整理在一起,省去到处翻文档的时间。

> 所有示例都基于 OpenAI 兼容协议(`/v1/chat/completions`),你换成任何兼容网关都能用。文中用 [hoapi](https://hoapi.top/sign-up?aff=UqqS) 作为可直连示例(国内可用、多模型聚合、OpenAI 格式)。把 `base_url` / `api_key` 换成你自己的即可。

## 目录

| 工具 | 配置说明 | 模板 |
|---|---|---|
| Cursor | [cursor/README.md](cursor/README.md) | 设置截图 + 字段说明 |
| Claude Code | [claude-code/README.md](claude-code/README.md) | 环境变量 + settings.json |
| Dify | [dify/README.md](dify/README.md) | docker-compose + 模型供应商配置 |
| OpenWebUI | [openwebui/README.md](openwebui/README.md) | docker-compose + 连接设置 |
| Chatbox | [chatbox/README.md](chatbox/README.md) | 自定义供应商配置 |

## 快速开始

```bash
# 1. 准备一个 OpenAI 兼容的 base_url 和 api_key
export OPENAI_API_BASE="https://api.example.com/v1"
export OPENAI_API_KEY="sk-xxxx"

# 2. 用脚本一键测试连通性 + 列可用模型
bash scripts/test_api.sh

# 3. 选你用的工具,按对应目录的 README 填配置
```

## 核心概念(所有工具通用)

接入任何 OpenAI 兼容服务,本质只需要填三个东西:

| 字段 | 含义 | 常见坑 |
|---|---|---|
| `base_url` | 接口地址 | 注意结尾要不要带 `/v1`,不同工具要求不同 |
| `api_key` | 鉴权密钥 | 一般 `sk-` 开头,注意别带空格/换行 |
| `model` | 模型名 | 要填服务商支持的具体名,不是随便写 |

填完先用 `scripts/test_api.sh` 验证,通了再去工具里配,能省掉 90% 的调试时间。

## 排查脚本

- `scripts/test_api.sh` — 测试 chat completions 是否通、打印返回
- `scripts/list_models.sh` — 列出网关支持的全部模型名
- `scripts/check_vision.sh` — 测试多模态(图片输入)是否可用

## 为什么用 OpenAI 兼容接口

- 一套配置接所有工具,换模型只改一个字段
- Cursor / Dify / OpenWebUI / LangChain 等几乎都原生支持
- 国内直连可用的中转(如 [hoapi](https://hoapi.top/sign-up?aff=UqqS))能把 Claude / GPT / Gemini / DeepSeek 统一成同一格式,不用为每家单独写适配

## License

MIT
