#!/usr/bin/env bash
# list_models.sh - 列出 OpenAI 兼容网关支持的全部模型名
#
# 用法:
#   export OPENAI_API_BASE="https://api.example.com/v1"
#   export OPENAI_API_KEY="sk-xxxx"
#   bash list_models.sh
#
# 配工具前先用这个查准确的模型名,避免填错导致 model not found。

set -euo pipefail

BASE="${OPENAI_API_BASE:-}"
KEY="${OPENAI_API_KEY:-}"

if [[ -z "$BASE" || -z "$KEY" ]]; then
  echo "请先设置 OPENAI_API_BASE 和 OPENAI_API_KEY 环境变量。" >&2
  exit 1
fi

BASE="${BASE%/}"

echo ">> 拉取模型列表: $BASE/models"
echo "---"

HTTP_CODE=$(curl -sS -o /tmp/_models_resp.json -w "%{http_code}" \
  "$BASE/models" \
  -H "Authorization: Bearer $KEY")

if [[ "$HTTP_CODE" != "200" ]]; then
  echo ">> ❌ HTTP $HTTP_CODE"
  cat /tmp/_models_resp.json
  echo ""
  echo ">> 注意: 部分网关不开放 /models 端点,这不代表不能用,直接用文档给的模型名即可。"
  exit 1
fi

if command -v jq >/dev/null 2>&1; then
  echo ">> 可用模型:"
  jq -r '.data[].id' /tmp/_models_resp.json | sort
  echo "---"
  echo ">> 共 $(jq '.data | length' /tmp/_models_resp.json) 个模型"
else
  cat /tmp/_models_resp.json
fi
