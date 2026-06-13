# Claude Code 接入第三方中转(国内可直连)

Claude Code 官方按 Anthropic 账号计费,国内开发者常卡在两点:**账号/支付难搞**、**额度贵且容易触发限流**。好在 Claude Code 支持通过环境变量指向任意 Anthropic 兼容端点,把模型换成国内可直连的中转网关即可正常使用。

本文以 [hoapi](https://hoapi.top/sign-up?aff=UqqS) 为例(它基于 New API 搭建,提供 Anthropic 与 OpenAI 两种兼容格式),换成其他兼容网关思路完全一样。

## 一、为什么用中转跑 Claude Code

- 国内直连,不折腾代理/外卡
- 一个 key 覆盖 Claude **全系列**:`claude-opus-4-8`、`claude-sonnet-4-6`、`claude-sonnet-4-5-20250929`、`claude-haiku-4-5`
- 按量计费,用多少扣多少,先小额测试再决定
- 同一个 key 还能用 GPT-5 全系列和 `gpt-5.3-codex`,在工具里随时切

## 二、拿到三要素

注册并进控制台后([注册入口](https://hoapi.top/sign-up?aff=UqqS)),你需要三样东西:

```text
ANTHROPIC_BASE_URL = 网关的 Anthropic 兼容地址
ANTHROPIC_AUTH_TOKEN = 控制台创建的令牌(API Key)
模型名 = 比如 claude-sonnet-4-6
```

> 提示:控制台一般有「每日签到送额度」,注册当天先签到,拿到的额度足够把整条链路跑通再说,不用一上来就充值。

## 三、配置 Claude Code

### 方式 A:环境变量(推荐,临时/脚本场景)

macOS / Linux:

```bash
export ANTHROPIC_BASE_URL="https://hoapi.top"
export ANTHROPIC_AUTH_TOKEN="你的令牌"
export ANTHROPIC_MODEL="claude-sonnet-4-6"
claude
```

Windows PowerShell:

```powershell
$env:ANTHROPIC_BASE_URL="https://hoapi.top"
$env:ANTHROPIC_AUTH_TOKEN="你的令牌"
$env:ANTHROPIC_MODEL="claude-sonnet-4-6"
claude
```

### 方式 B:写进 settings.json(推荐,长期使用)

编辑 `~/.claude/settings.json`:

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://hoapi.top",
    "ANTHROPIC_AUTH_TOKEN": "你的令牌",
    "ANTHROPIC_MODEL": "claude-sonnet-4-6",
    "ANTHROPIC_SMALL_FAST_MODEL": "claude-haiku-4-5"
  }
}
```

`ANTHROPIC_SMALL_FAST_MODEL` 设成 haiku,可以让 Claude Code 的后台小任务走更便宜的模型,省钱。

## 四、验证是否接通

```bash
claude -p "用一句话说明这个仓库是干什么的"
```

能正常返回就说明链路通了。也可以用仓库里的 [`scripts/test_api.sh`](../scripts/test_api.sh) 先单独测端点。

## 五、模型怎么选(按真实场景)

| 场景 | 推荐模型 | 说明 |
|---|---|---|
| 复杂重构 / 难题 | `claude-opus-4-8` | 最强,贵,关键时刻用 |
| 日常写代码 | `claude-sonnet-4-6` | 性价比主力,默认就用它 |
| 批量小任务 / 补全 | `claude-haiku-4-5` | 便宜快,跑量首选 |
| 想试 Codex 风格 | `gpt-5.3-codex` | 同一个 key 直接切 |

## 六、常见报错

| 报错 | 原因 | 解决 |
|---|---|---|
| 401 / invalid token | 令牌错或没复制全 | 重新到控制台复制完整令牌 |
| model not found | 模型名写错或该 key 分组没开通 | 用控制台「可用模型」里的准确名字 |
| 余额不足 | 额度用完 | 签到领额度或小额充值 |
| 连接超时 | base_url 写错 | 确认是 `https://hoapi.top`,无多余路径 |

---

完整的 Cursor / Dify / OpenWebUI / Chatbox 配置见[仓库主页](../README.md)。中转网关用的 [hoapi 注册入口在这](https://hoapi.top/sign-up?aff=UqqS),注册可签到领额度,够把流程全程跑通。
