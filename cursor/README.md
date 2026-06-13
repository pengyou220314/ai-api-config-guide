# Cursor 接入第三方 / OpenAI 兼容 API

Cursor 支持自定义 OpenAI 兼容接口,可以把内置的 GPT 换成任意兼容网关(Claude、GPT、Gemini、DeepSeek 等)。

## 配置步骤

1. 打开 Cursor → `Settings`(⌘/Ctrl + `,`)→ 左侧 `Models`
2. 找到 `OpenAI API Key` 区域
3. 填入你的 `api_key`
4. 展开 `Override OpenAI Base URL`,填入网关地址
5. 在模型列表里勾选 / 添加你要用的模型名
6. 点 `Verify` 验证

## 字段对照

| Cursor 字段 | 填什么 | 示例 |
|---|---|---|
| OpenAI API Key | 你的密钥 | `sk-xxxxxxxx` |
| Override OpenAI Base URL | 网关地址(通常带 `/v1`) | `https://api.example.com/v1` |
| Model | 服务商支持的模型名 | `gpt-4o` / `claude-sonnet-4` 等 |

> 用 [hoapi](https://hoapi.top/sign-up?aff=UqqS) 这类国内可直连的网关时,Base URL 填它给的地址、Model 填它支持的名即可。先在网关后台或用 [scripts/list_models.sh](../scripts/list_models.sh) 查清楚可用模型名。

## 常见报错

| 现象 | 原因 | 解决 |
|---|---|---|
| `Verify` 失败 / 红叉 | Base URL 写错或漏了 `/v1` | 对照网关文档确认结尾 |
| `model not found` | 模型名不对 | 用 list_models 脚本查准确名字 |
| 401 Unauthorized | key 错或带了空格 | 重新复制,去掉首尾空白 |
| 能 Verify 但对话报错 | 勾选的模型网关不支持 | 换成支持的模型名 |
| 改了 Base URL 但还连官方 | 没勾 Override / 没保存 | 确认 Override 开关已开 |

## 验证连通性

配置前先在终端验证,避免在 Cursor 里反复试:

```bash
export OPENAI_API_BASE="https://api.example.com/v1"
export OPENAI_API_KEY="sk-xxxx"
bash ../scripts/test_api.sh
```

通了再去 Cursor 填,基本一次成功。
