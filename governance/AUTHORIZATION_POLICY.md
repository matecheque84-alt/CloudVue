# NORTE Authorization Boundary

## Invariants

1. Collection reads may omit resources the actor cannot read.
2. Single-resource reads MUST make an explicit authorization decision.
3. Missing related data MUST NOT be treated as proof of authorization denial.
4. Infrastructure/query failures MUST NOT be converted into authorization denials.
5. Field selection is not authorization policy.
6. Where resource existence is sensitive, single-resource endpoints SHOULD conceal existence with the endpoint-appropriate not-found response.
7. Authorization decisions MUST be attributable to actor, resource, action, policy version, and exact commit SHA.

## Required result classes

- ALLOW
- DENY
- CONCEALED_DENY
- QUERY_FAILED

The expression `empty == unauthorized` is forbidden.

## Single-resource contract

A strict single-resource wrapper MUST know which related fields were requested; evaluate membership against the requested resource ID rather than array length; return a typed authorization result; preserve genuine database/infrastructure errors; and leave endpoint-specific mapping (403, concealed 404, SSE forbidden event) at the transport boundary.

## Collection contract

Batch/list operations MAY preserve RBAC filtering and skip unreadable resources. They MUST NOT fail an entire list merely because one resource was filtered unless policy explicitly requires fail-closed behavior.

## Separation of duties

AUTHOR != REVIEWER != DECIDER. HIGH/CRITICAL changes require independent Red Team review before PROMOTE.

## Merge authorization

A change is merge-eligible only when the exact PR head SHA equals the SHA represented by evidence, checks, reviews, and the recorded decision.

CODE_VALID && TESTS_PASS && SECURITY_PASS && EVIDENCE_COMPLETE && REVIEW_COMPLETE && POLICY_PASS && DECISION_PROMOTE
