#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# CloudVue — Single Source of Truth + hardening (idempotente)
# Uso:
#   ./github-hardening.sh --repo OWNER/REPO [--gov-branch BRANCH] [--ir-branch BRANCH] [--apply]
#
# Padrão: DRY-RUN (não aplica mudanças). Use --apply para executar.
# Requer: gh autenticado -> gh auth status
# ============================================================

REPO=""
GOV_BRANCH="copilot/auto-close-duplicates"
IR_BRANCH="copilot/monte-anti-attack-cybernetico"
DRY_RUN=true

usage() {
  echo "Uso: $0 --repo OWNER/REPO [--gov-branch BRANCH] [--ir-branch BRANCH] [--apply]"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)
      REPO="${2:-}"; shift 2 ;;
    --gov-branch)
      GOV_BRANCH="${2:-}"; shift 2 ;;
    --ir-branch)
      IR_BRANCH="${2:-}"; shift 2 ;;
    --apply)
      DRY_RUN=false; shift ;;
    -h|--help)
      usage; exit 0 ;;
    *)
      echo "Parâmetro inválido: $1" >&2
      usage
      exit 1 ;;
  esac
done

if [[ -z "$REPO" ]]; then
  echo "Erro: informe --repo OWNER/REPO" >&2
  usage
  exit 1
fi

run() {
  if $DRY_RUN; then
    echo "[DRY-RUN] $*"
  else
    eval "$@"
  fi
}

ensure_ref() {
  local ref="$1"
  if gh api "repos/$REPO/git/refs/heads/$ref" >/dev/null 2>&1; then
    return 0
  fi
  return 1
}

echo "==> Verificando pré-requisitos..."
command -v gh >/dev/null || { echo "gh não encontrado" >&2; exit 1; }
gh auth status >/dev/null

echo "==> Verificando acesso ao repo..."
gh repo view "$REPO" --json name,visibility,defaultBranchRef -q '"repo: \(.name) | visibilidade: \(.visibility) | default: \(.defaultBranchRef.name)"'

echo "==> Tornando o repositório PRIVADO..."
run "gh repo edit '$REPO' --visibility private --accept-visibility-change-consequences"

echo "==> Criando legacy/2017 a partir de master..."
if ensure_ref "legacy/2017"; then
  echo "   legacy/2017 já existe"
else
  MASTER_SHA=$(gh api "repos/$REPO/git/refs/heads/master" -q '.object.sha')
  run "gh api -X POST 'repos/$REPO/git/refs' -f ref='refs/heads/legacy/2017' -f sha='$MASTER_SHA'"
fi

echo "==> Criando main a partir de $GOV_BRANCH..."
if ensure_ref "main"; then
  echo "   main já existe"
else
  GOV_SHA=$(gh api "repos/$REPO/git/refs/heads/$GOV_BRANCH" -q '.object.sha')
  run "gh api -X POST 'repos/$REPO/git/refs' -f ref='refs/heads/main' -f sha='$GOV_SHA'"
fi

echo "==> Definindo main como default..."
run "gh api -X PATCH 'repos/$REPO' -f default_branch='main'"

echo "==> Aplicando branch protection em main..."
if $DRY_RUN; then
  echo "[DRY-RUN] gh api -X PUT repos/$REPO/branches/main/protection <payload>"
else
  gh api -X PUT "repos/$REPO/branches/main/protection" \
    -H "Accept: application/vnd.github+json" \
    --input - <<'JSON'
{
  "required_status_checks": { "strict": true, "contexts": [] },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1,
    "dismiss_stale_reviews": true
  },
  "restrictions": null,
  "required_linear_history": true,
  "allow_force_pushes": false,
  "allow_deletions": false
}
JSON
fi

echo "==> Ativando alertas de vulnerabilidade e Dependabot security updates..."
run "gh api -X PUT 'repos/$REPO/vulnerability-alerts' || true"
run "gh api -X PUT 'repos/$REPO/automated-security-fixes' || true"

echo "==> Abrindo PR (rascunho) de IR para main..."
run "gh pr create --repo '$REPO' --base main --head '$IR_BRANCH' --title 'Incorporar incident response / hardening (revisão)' --body 'Merge do material de IR na nova fonte de verdade (main). Revisar antes de integrar.' --draft || true"

echo
echo "============================================================"
echo "OK. Estado alvo:"
echo "  main          -> fonte de verdade, protegido, default"
echo "  legacy/2017   -> baseline antigo preservado"
echo "  IR            -> aguardando PR revisado (não mergeado)"
echo
echo "AÇÃO MANUAL RESTANTE:"
echo "  - Ative 2FA na conta GitHub: Settings > Password and authentication"
echo "============================================================"
