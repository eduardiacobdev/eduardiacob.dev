# Runbook: Cloudflare billing alert

R2 has no spending cap, so the Cloudflare side of the cost ceiling (ADR-0005) is guarded by a spend alert (TASKS T1.12). Expected cost is 0 USD a month: any spend at all is an anomaly.

## Current setup (2026-11-12)

Dashboard > Manage account > Notifications.

| Name | Type | Threshold | Sends to | Origin |
|---|---|---|---|---|
| `eduardiacob-dev spend over 1 USD` | Billing budget alert | 1 USD | `ops@eduardiacob.dev` (Gmail label `eduardiacob.dev/ops`) | Created by hand [human-approved] |
| `Default budget alert (auto-created)` | Billing budget alert | 10 USD | account default | Created by Cloudflare, left as a second line |

- A budget alert fires once per billing cycle, when actual or forecast spend goes over the threshold.
- It does not stop spending. The real cap is staying inside the R2 free quota (10 GB, 1M Class A, 10M Class B per month); the state bucket is far below it.

## Why it is not in Terraform

Bootstrap exception to "everything as code", approved by the owner on 2026-11-12:

- The Cloudflare provider 5.28.1 (latest on 2026-11-12) has no `billing_budget_alert` alert type and no `total_spend_dollars` filter in `cloudflare_notification_policy`.
- The alternative, `billing_usage_alert`, is documented for Professional plans or higher and its R2 product values are undocumented.
- Managing notifications through Terraform would also need `Notifications Write` on the API token, which is kept least-privilege.

**To do:** when the provider supports `billing_budget_alert`, add a `cloudflare_notification_policy` with `filters.total_spend_dollars = ["1"]` and the `ops@` email, add the permission to the token, `terraform import` the existing policy, and delete this exception.

## Recreate by hand

1. Notifications > Create a notification > Account & billing > Billing budget alert.
2. Account budget: `1`.
3. Name `eduardiacob-dev spend over 1 USD`, description: why it exists (ADR-0005, T1.12).
4. Notification email: `ops@eduardiacob.dev` > Save.
5. Check the list shows it as Enabled.

## When it fires

1. Billing > Billable usage: find the product that is charging.
2. R2: check bucket size and operation counts against the free quota; look for a leaked key (rotate per `local-secrets.md`).
3. Record the cause and the fix in `docs/reviews/` or a new ADR.
