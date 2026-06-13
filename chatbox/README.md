# Chatbox 接入第三方 / OpenAI 兼容 API

Chatbox 是跨平台(Win/Mac/Linux/手机)的桌面 AI 客户端,支持自定义 OpenAI 兼容供应商,适合不想折腾命令行的人。

## 配置步骤

1. 打开 Chatbox → 左下角 `设置`(Settings)
2. `模型`(Model)→ 模型提供方选 `OpenAI API` 或 `添加自定义提供方`
3. 填写:

| 字段 | 填什么 |
|---|---|
| API 域名 / API Host | 网关地址,如 `https://api.example.com` |
| API 路径 | 一般默认 `/v1/chat/completions`,无需改 |
| API Key | 你的密钥 `sk-xxxx` |
| 模型 | 服务商支持的模型名 |

4. 保存后回到对话界面,顶部选模型即可。

> Chatbox 的 API Host 填法和别的工具略不同:有的版本要填到域名(`https://api.example.com`),有的要带 `/v1`。如果连不上,两种都试一下。用 [hoapi](https://hoapi.top/sign-up?aff=UqqS) 这类网关时按它文档给的地址填。

## 常见报错

| 现象 | 原因 | 解决 |
|---|---|---|
| 请求失败 / 404 | API Host 带不带 `/v1` 不对 | 切换两种写法试 |
| 401 | key 错 | 重新填 |
| 模型无响应 | 模型名不对 | 换支持的模型 |
| 流式输出卡住 | 网关不支持 stream | 关掉流式输出选项 |

## 验证

配置前先终端验证网关:

```bash
export OPENAI_API_BASE="https://api.example.com/v1"
export OPENAI_API_KEY="sk-xxxx"
bash ../scripts/test_api.sh
```
