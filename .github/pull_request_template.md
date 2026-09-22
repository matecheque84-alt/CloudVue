## Auditable Change Record

- Change ID:
- Mission ID:
- Operational author (human/agent/service):
- Branch:
- Head SHA:
- Risk: LOW / MEDIUM / HIGH / CRITICAL
- Evidence refs:
- Authorization result: ALLOW / DENY / CONCEALED_DENY / QUERY_FAILED
- Policy version:
- Independent reviewer:
- Red Team required: yes / no
- Decision: PROMOTE / HOLD / REJECT / SUPERSEDE

## Authorization boundary checklist

- [ ] Collection filtering and single-resource authorization are separated.
- [ ] No authorization decision is inferred only from an empty related-data array.
- [ ] Query/infrastructure errors remain distinguishable from authorization denial.
- [ ] Sensitive resource existence is concealed where required.
- [ ] The reviewed/tested/evidenced SHA is exactly this PR head SHA.
- [ ] Author is not the sole reviewer/decider.
- [ ] HIGH/CRITICAL has independent Red Team review.
