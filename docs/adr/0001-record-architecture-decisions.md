# ADR-0001: Record architecture decisions

- Status: Accepted
- Date: 2026-11-11

## Context

The project is built and run by an AI agent on behalf of the owner. Decisions must survive across sessions and be reviewable by recruiters and collaborators.

## Decision

Every decision not already in the infrastructure brief (private) is recorded as a short ADR in `docs/adr/NNNN-title.md` with Context, Decision, Consequences. Superseded ADRs keep their file and point to the replacement.

## Consequences

- The brief plus the ADR list is the full source of truth for architecture.
- Changes to "closed" decisions in the brief need an ADR **and** owner approval.
