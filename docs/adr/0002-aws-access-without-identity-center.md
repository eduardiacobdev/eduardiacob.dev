# ADR-0002: AWS human access without IAM Identity Center during the Free plan

- Status: Accepted
- Date: 2026-11-11
- Supersedes: brief v1, phase 4 ("IAM Identity Center admin user")

## Context

IAM Identity Center grants access to AWS accounts only through an organization instance, which needs AWS Organizations. A Free plan account that joins Organizations is converted to Paid, irreversibly, and loses Free Tier credits and the "close instead of bill" safety net.

## Decision

- Free plan phase: root user with hardware/app MFA, used only for the steps that require root. One IAM admin user with MFA enforced by policy. CLI access only through short-lived credentials derived from the console sign-in (`aws login`). No access keys, ever.
- Paid switch (brief phase 11): create the Organization, enable IAM Identity Center (both free), migrate the admin to a permission set, delete the IAM admin user.
- Automation always uses GitHub OIDC roles, never this user.

## Consequences

- Cost: 0 $. Organizations and Identity Center are free services; only the timing changes.
- One extra migration step at the Paid switch, tracked in the phase 11 checklist.
