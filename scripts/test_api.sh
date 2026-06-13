#!/usr/bin/env bash
# test_api.sh - 测试 OpenAI 兼容接口的 chat completions 是否可用
#
# 用法:
#   export OPENAI_API_BASE="https://api.example.com/v1"
#   export OPENAI_API_KEY="sk-xxxx"
#   bash test_api.sh [模型名]
#
# 不传模型名时默认用 gpt-4o-mini。

set -euo pipefail

BASE="${OPENAI_API_BASE:-}"
KEY="${OPENAI_API_KEY:-}"
MODEL="${1:-gpt-4o-mini}"

if [[ -z "$BASE" || -z "$KEY" ]]; then
  echo "请先设置 OPENAI_API_BASE 和 OPENAI_API_KEY 环境变量。" >&2
  exit 1
fi

# 去掉 BASE 结尾多余的斜杠
BASE="${BASE%/}"

echo ">> 测试 chat completions"
echo ">> endpoint: $BASE/chat/completions"
echo ">> model:    $MODEL"
echo "---"

HTTP_CODE=$(curl -sS -o /tmp/_api_resp.json -w "%{http_code}" \
  "$BASE/chat/completions" \
  -H "Authorization: Bearer $KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"$MODEL\",
    \"messages\": [{\"role\": \"user\", \"content\": \"用一句话回复:连通成功\"}],
    \"max_tokens\": 50
  }")

echo "HTTP $HTTP_CODE"
echo "---"

if [[ "$HTTP_CODE" == "200" ]]; then
  if command -v jq >/dev/null 2>&1; then
    jq -r '.choices[0].message.content // .' /tmp/_api_resp.json
  else
    cat /tmp/_api_resp.json
  fi
  echo ""
  echo ">> ✅ 接口可用"
else
  echo ">> ❌ 调用失败,返回如下:"
  cat /tmp/_api_resp.json
  echo ""
  echo ">> 常见原因: 401=key错; 404=base_url或路径错; model not found=模型名错"
  exit 1
fi
