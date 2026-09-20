# Checklist de erradicação, recuperação e blindagem

## 5) Erradicação e recuperação
- [ ] Confirmar remoção de cronjobs/pods/containers maliciosos.
- [ ] Revogar e rotacionar credenciais associadas ao incidente.
- [ ] Rebuild de imagens a partir de source confiável.
- [ ] Reimplantar com assinatura/verificação de artefatos.
- [ ] Validar integridade pós-deploy (hash, SBOM, provenance).
- [ ] Ativar monitoramento reforçado por no mínimo 72h.

## 6) Blindagem permanente
### Kubernetes
- [ ] Aplicar `default deny` para namespaces críticos.
- [ ] Forçar RBAC de privilégio mínimo.
- [ ] Habilitar PSA/OPA para políticas obrigatórias.
- [ ] Habilitar proteção runtime (detecção de comportamento anômalo).

### CI/CD
- [ ] Isolar runners e reduzir privilégios de execução.
- [ ] Garantir ambientes efêmeros para jobs sensíveis.
- [ ] Exigir proteção de branch (reviews, checks obrigatórios).
- [ ] Assinar e verificar artefatos em todo deploy.

### Identidade e segredos
- [ ] Exigir MFA forte para contas administrativas.
- [ ] Rotação automática de chaves e tokens.
- [ ] Usar credenciais de curta duração.
- [ ] Centralizar segredos em vault.

### Detecção e resposta
- [ ] Integrar IAM + CI + cluster em SIEM.
- [ ] Criar alertas para uso anômalo de token/chave.
- [ ] Criar alertas para deploy fora de pipeline aprovado.
- [ ] Criar alertas para execução suspeita no cluster.
