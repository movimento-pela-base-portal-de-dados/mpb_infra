#!/usr/bin/env bash
set -euo pipefail
PLAN_JSON="${1:-tfplan.json}"
if jq -e '[.resource_changes[]? | select(.change.actions | index("delete"))] | length > 0' "$PLAN_JSON" >/dev/null; then
  echo "ERRO: plano contem acao de delecao. Interrompendo conforme guardrails do cliente." >&2
  exit 1
fi
BAD=$(grep -R --include='*.tf' -nE 'Project[[:space:]]*=' . 2>/dev/null | grep -v 'Base_dos_Dados_Datalake' || true)
if [ -n "$BAD" ]; then
  echo "ERRO: encontrada tentativa de sobrescrever a tag Project:" >&2
  echo "$BAD" >&2
  exit 1
fi
