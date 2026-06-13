# Claude Code 接入第三方 / OpenAI 兼容 API

Claude Code 默认连官方 `api.anthropic.com`。国内可以通过设置环境变量或 `settings.json`,让它走 Anthropic 兼容的中转网关。

## 方式一:环境变量(临时 / 单次会话)

```bash
export ANTHROPIC_BASE_URL="https://api.example.com"
export ANTHROPIC_API_KEY="sk-xxxx"
claude
```

> 注意:Anthropic 兼容接口的 Base URL 通常**不带** `/v1`(SDK 会自己拼 `/v1/messages`),和 OpenAI 兼容接口的写法不一样,别填错。

## 方式二:settings.json(永久)

编辑 `~/.claude/settings.json`(Windows 在 `C:\Users\<你>\.claude\settings.json`):

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://api.example.com",
    "ANTHROPIC_API_KEY": "sk-xxxx"
  }
}
```

保存后重启 Claude Code 生效。

## 已知坑:onboarding 绕过 Base URL

首次交互启动时,如果 `hasCompletedOnboarding` 没设置,Claude Code 会**绕过** `ANTHROPIC_BASE_URL` 直连官方,报 `ERR_BAD_REQUEST`。

解决:在 `C:\Users\<你>\.claude.json` 写入:

```json
{ "hasCompletedOnboarding": true }
```

然后重启即可走中转。

## 验证

```bash
claude auth status --text   # 确认 Base URL 是你的网关
claude -p "hello"           # 一次性测试,通了说明配好了
```

如果 `claude -p` 通但交互窗口仍连官方,基本就是上面的 onboarding 坑。

## 字段对照

| 变量 | 填什么 | 注意 |
|---|---|---|
| `ANTHROPIC_BASE_URL` | 网关地址 | 通常不带 `/v1` |
| `ANTHROPIC_API_KEY` | 密钥 | `sk-` 开头,无空格 |

> 用 [hoapi](https://hoapi.top/sign-up?aff=UqqS) 这类支持 Anthropic 格式的网关时,按它文档给的 Base URL 填即可。注意区分它的 OpenAI 兼容端点和 Anthropic 端点。
