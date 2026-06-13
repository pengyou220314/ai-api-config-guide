# OpenWebUI 接入第三方 / OpenAI 兼容 API

OpenWebUI 是开源的本地大模型 Web 界面,原生支持 OpenAI 兼容接口,几分钟就能接入 Claude / GPT / Gemini / DeepSeek。

## 一键启动(docker-compose)

用本目录的 [docker-compose.yml](docker-compose.yml),把里面的 `base_url` 和 `api_key` 换成你自己的:

```bash
cd openwebui
# 编辑 docker-compose.yml,填入 OPENAI_API_BASE_URL 和 OPENAI_API_KEY
docker compose up -d
# 访问 http://localhost:3000 ,首次注册的账号即管理员
```

## 配置步骤(Web 界面)

如果不想写进 compose,也可以启动后在界面配:

1. 进入 OpenWebUI → 右上头像 → `Settings` → `Admin Settings` → `Connections`
2. 在 `OpenAI API` 区域:

| 字段 | 填什么 |
|---|---|
| API Base URL | 网关地址,带 `/v1`,如 `https://api.example.com/v1` |
| API Key | 你的密钥 `sk-xxxx` |

3. 保存后,模型下拉里会自动拉取网关支持的模型列表。

> 用 [hoapi](https://hoapi.top/sign-up?aff=UqqS) 这类网关时,Base URL 填它的 OpenAI 兼容地址即可,模型列表会自动出现。

## 常见报错

| 现象 | 原因 | 解决 |
|---|---|---|
| 模型列表为空 | Base URL 错或网关不支持 `/models` | 用 list_models.sh 确认 |
| `Network Problem` | 容器访问不到网关 | 检查网络 / 代理 |
| 401 | key 错 | 重新填 |
| 对话无响应 | 选了不支持的模型 | 换可用模型 |

## 验证

```bash
export OPENAI_API_BASE="https://api.example.com/v1"
export OPENAI_API_KEY="sk-xxxx"
bash ../scripts/list_models.sh   # 确认能拉到模型列表
```
