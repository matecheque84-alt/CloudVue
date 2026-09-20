# Anti-ataque cibernético (resposta a incidente)

Objetivo: conter rapidamente, preservar evidências e habilitar atribuição técnica com confiança.

## 1) Resposta imediata

### 1.1 Isolar workloads suspeitos
1. Aplicar política de isolamento de namespace e bloqueio de egress.
2. Bloquear tráfego externo de pods suspeitos.
3. Evitar reinício/poda antes da coleta forense.

### 1.2 Isolar nodes suspeitos
1. `kubectl cordon <node>`
2. `kubectl drain <node> --ignore-daemonsets --delete-emptydir-data` (apenas após snapshot de evidências)
3. Remover node do balanceamento externo.

### 1.3 Revogar credenciais expostas
1. Rotacionar tokens de serviço e chaves de API.
2. Invalidar sessões ativas de usuários/sistemas suspeitos.
3. Reemitir credenciais com TTL curto e escopo mínimo.

### 1.4 Preservar evidências
- Exportar logs de pods/nodes e eventos do cluster.
- Preservar artefatos de CI/CD e auditoria de repositório.
- Registrar hash, origem e horário UTC dos arquivos coletados.

## 2) EVIDENCE_LEDGER mínimo

Use `/home/runner/work/CloudVue/CloudVue/security/incident-response/evidence-ledger.template.yaml`.

Campos obrigatórios:
- `IDENTITY_EVENTS` (IAM/SSO/RBAC/kube-audit)
- `CI_CD_EVENTS` (pipelines/runners/artefatos/deploys)
- `REPOSITORY_EVENTS` (commits/PRs/workflows/secrets)
- `CREDENTIAL_EVENTS` (uso, rotação e origem)
- `PRIOR_FINDINGS` (incidentes e alertas anteriores)

## 3) Kill chain

1. Trabalhar em UTC em todos os registros.
2. Correlacionar identidade → commit/pipeline → deploy → execução no cluster.
3. Identificar vetor inicial provável (phishing, credencial vazada, supply chain, CI).

Templates:
- Linha do tempo: `/home/runner/work/CloudVue/CloudVue/security/incident-response/timeline.template.csv`
- Matriz de hipóteses: `/home/runner/work/CloudVue/CloudVue/security/incident-response/hypothesis-matrix.template.md`

## 4) Atribuição técnica ("pegar o invasor")

Para cada hipótese, exigir no mínimo 2 fontes independentes de evidência.
Entidade atribuída deve incluir, quando possível: usuário/token, runner, IP, ASN, user-agent e TTP.

## 5) Erradicação e recuperação

1. Remover persistência (cronjobs, backdoors, imagens alteradas).
2. Reconstruir imagens e segredos de origem confiável.
3. Reimplantar com verificação/assinatura de artefatos.
4. Ativar monitoramento reforçado pós-incidente.

## 6) Blindagem permanente

- Kubernetes: RBAC mínimo, NetworkPolicy default deny, PSA/OPA, runtime security.
- CI/CD: runners isolados, ambientes efêmeros, proteção de branch, assinatura de artefato.
- Identidade/segredos: MFA forte, rotação automática, tokens de curta duração, vault.
- Detecção: SIEM com alertas de comportamento anômalo em IAM/CI/cluster.

Checklist operacional: `/home/runner/work/CloudVue/CloudVue/security/incident-response/eradication-recovery-hardening.checklist.md`

## Automação de governança GitHub

Script: `/home/runner/work/CloudVue/CloudVue/security/incident-response/github-hardening.sh`

Uso:
- Dry-run (padrão): `./security/incident-response/github-hardening.sh --repo OWNER/REPO`
- Aplicar mudanças: `./security/incident-response/github-hardening.sh --repo OWNER/REPO --apply`

Parâmetros opcionais:
- `--gov-branch` (default: `copilot/auto-close-duplicates`)
- `--ir-branch` (default: `copilot/monte-anti-attack-cybernetico`)
