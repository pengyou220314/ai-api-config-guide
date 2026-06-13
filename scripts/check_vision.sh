#!/usr/bin/env bash
# check_vision.sh - 测试网关的多模态(图片输入)能力是否可用
#
# 用法:
#   export OPENAI_API_BASE="https://api.example.com/v1"
#   export OPENAI_API_KEY="sk-xxxx"
#   bash check_vision.sh [模型名]
#
# 默认用 gpt-4o。会发一张 1x1 像素的内置图片做最小测试。

set -euo pipefail

BASE="${OPENAI_API_BASE:-}"
KEY="${OPENAI_API_KEY:-}"
MODEL="${1:-gpt-4o}"

if [[ -z "$BASE" || -z "$KEY" ]]; then
  echo "请先设置 OPENAI_API_BASE 和 OPENAI_API_KEY 环境变量。" >&2
  exit 1
fi

BASE="${BASE%/}"

# 1x1 红色像素 PNG 的 base64,纯做连通性测试
PIXEL="iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg=="

echo ">> 测试多模态 vision: $BASE/chat/completions"
echo ">> model: $MODEL"
echo "---"

HTTP_CODE=$(curl -sS -o /tmp/_vision_resp.json -w "%{http_code}" \
  "$BASE/chat/completions" \
  -H "Authorization: Bearer $KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"$MODEL\",
    \"messages\": [{
      \"role\": \"user\",
      \"content\": [
        {\"type\": \"text\", \"text\": \"这张图是什么颜色?一个词回答\"},
        {\"type\": \"image_url\", \"image_url\": {\"url\": \"data:image/png;base64,$PIXEL\"}}
      ]
    }],
    \"max_tokens\": 30
  }")

echo "HTTP $HTTP_CODE"
echo "---"

if [[ "$HTTP_CODE" == "200" ]]; then
  if command -v jq >/dev/null 2>&1; then
    jq -r '.choices[0].message.content // .' /tmp/_vision_resp.json
  else
    cat /tmp/_vision_resp.json
  fi
  echo ""
  echo ">> ✅ 多模态可用"
else
  echo ">> ❌ 失败:"
  cat /tmp/_vision_resp.json
  echo ""
  echo ">> 注意: 不是所有模型都支持图片输入,确认用的是 vision 模型(如 gpt-4o)。"
  exit 1
fi
