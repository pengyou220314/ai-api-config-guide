# Dify 接入第三方 / OpenAI 兼容 API

Dify 支持添加自定义 OpenAI 兼容模型供应商,把 Claude / GPT / Gemini / DeepSeek 统一接进来做应用编排。

## 配置步骤(Web 界面)

1. 进入 Dify → 右上角头像 → `设置` → `模型供应商`
2. 找到 `OpenAI-API-compatible`,点 `添加模型`
3. 填写:

| 字段 | 填什么 |
|---|---|
| 模型类型 | LLM |
| 模型名称 | 服务商支持的模型名,如 `gpt-4o` / `claude-sonnet-4` |
| API Key | 你的密钥 `sk-xxxx` |
| API endpoint URL | 网关地址,带 `/v1`,如 `https://api.example.com/v1` |
| Completion mode | Chat |

4. 保存。每个要用的模型都重复添加一次。

> 用 [hoapi](https://hoapi.top/sign-up?aff=UqqS) 这类网关时,API endpoint 填它的 OpenAI 兼容地址,模型名用它支持的具体名(先用 [list_models 脚本](../scripts/list_models.sh) 查)。

## 自托管 Dify(docker-compose)

如果你要本地跑 Dify,用本目录的 [docker-compose.yml](docker-compose.yml):

```bash
cd dify
docker compose up -d
# 访问 http://localhost/install 完成初始化
```

启动后按上面的「配置步骤」在 Web 界面加模型即可。模型的 key 和 base_url 是在界面填的,不写进 compose 文件。

## 常见报错

| 现象 | 原因 | 解决 |
|---|---|---|
| 保存模型时校验失败 | endpoint 漏 `/v1` 或模型名错 | 对照网关文档 |
| `Connection error` | 网关地址不可达 | 先用 test_api.sh 验证 |
| 调用扣费异常 | 选错模型档位 | 确认模型名对应的计费 |
| embedding 报错 | 文本向量模型没单独配 | 另加一个 Text Embedding 模型 |

## 验证

```bash
export OPENAI_API_BASE="https://api.example.com/v1"
export OPENAI_API_KEY="sk-xxxx"
bash ../scripts/test_api.sh
```
