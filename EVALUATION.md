# Evaluation Rubric

This document is used internally to score candidate submissions. It is published openly — we believe
transparency about what we value leads to better submissions and a fairer process.

---

## Scoring

Each area is scored **0–3**:

| Score | Meaning |
|---|---|
| 0 | Not attempted or fundamentally incorrect |
| 1 | Attempted but with significant gaps or errors |
| 2 | Solid — meets expectations with minor issues |
| 3 | Excellent — exceeds expectations |

---

## Areas

### 1. Terraform Code Quality

- Variables have types and descriptions; no unexplained hardcoded values
- Consistent resource naming convention throughout
- Code is DRY — loops (`for_each`, `count`) used where appropriate; no copy-pasted blocks
- `terraform fmt` passes with no changes
- Resources are logically ordered; non-obvious decisions are commented

### 2. Module Design

- Clean, well-defined input interface (variables with types, descriptions, sensible defaults)
- Outputs expose what consumers need without leaking implementation detail
- Module is genuinely reusable — no environment-specific logic inside the module

### 3. AWS Resource Correctness

- VPC routing is correct: public subnets route via IGW; private subnets have a local route
- Lambda is in a private subnet with the correct handler reference and runtime
- *(L2)* API Gateway integration uses `AWS_PROXY` type with `integration_http_method = "POST"` and the correct Lambda `invoke_arn`
- *(L2)* Deployment has `depends_on` the method and integration; Lambda permission is correctly scoped

### 4. IAM & Security

- Lambda execution role uses least privilege — no wildcard actions or resources without justification
- Role trust policy allows only `lambda.amazonaws.com` to assume it
- No real credentials committed to the repository

### 5. Git Hygiene

- Commits are atomic and have meaningful messages — not "fix", "wip", "update", "changes"
- A branching strategy is evident (feature branch → PR → merge, not all commits directly to main)
- No build artefacts, state files, `.terraform/` directories, or secrets are committed at any point
  in the history

### 6. Debugging *(L2 only)*

- All three errors in `tasks/extended/broken/` are correctly identified
- Each fix is accurately applied and does not introduce new issues
- `FIXES.md` clearly explains the error, when it manifests (plan / apply / runtime), and the fix

---

## Level weighting

| Tasks | Areas assessed | Max score |
|---|---|---|
| Primary | Areas 1–5 | 15 |
| Primary + Extended | All areas | 18 |

Scores are a guide for structured discussion — not a hard cutoff. A candidate scoring 2 across
every area is strong. Particularly good signal for this role: high scores in areas 4 (IAM & Security)
and 5 (Git Hygiene).
