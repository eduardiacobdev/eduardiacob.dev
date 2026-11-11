# ADR-0004: Async contact notifications via DynamoDB Streams instead of SQS

- Status: Accepted
- Date: 2026-11-11
- Supersedes: brief v1, "SQS standard for async contact form jobs"

## Context

A Lambda SQS event source mapping long-polls the queue even when it is empty (about 130k requests/month per queue, five parallel pollers after idle periods). The API would also have to write to DynamoDB and to SQS: a dual write that can diverge.

## Decision

- The API writes the contact message to DynamoDB only (single write).
- A DynamoDB Streams trigger (`NEW_IMAGE`, filter on new contact items) invokes the notification worker, which sends the email through Brevo.
- Retries: bisect on error, max 3 retries, max record age 1 h.
- Failures go to an **SQS on-failure destination** acting as DLQ. Nothing polls it; a CloudWatch alarm watches its depth.

## Consequences

- Cost: 0 $. Streams reads made by Lambda triggers are free; the DLQ sees traffic only on failure.
- Native outbox pattern: a message is never notified without being stored, or stored without being notified (after retries, it lands in the DLQ).
- The brief's guarantee "dead-letter queue empty" still applies.
