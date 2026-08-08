# Week 6 Day 11 Quick Revision

## Recall

1. S3 is Regional object storage; console folders are key prefixes.
2. Bucket names must be unique in their selected namespace, and bucket name
   and Region cannot be changed after creation.
3. Keep ACLs disabled, Bucket owner enforced, and all four BPA controls on.
4. S3 Standard fits frequent access; Intelligent-Tiering fits unknown access.
5. Standard-IA is multi-AZ; One Zone-IA stores data in one AZ.
6. Glacier Flexible Retrieval and Deep Archive require a restore before use.
7. Versioning creates independent versions of the same key.
8. A normal delete in a versioned bucket creates a delete marker.
9. Lifecycle actions are configuration-driven and asynchronous.
10. SSE-S3 is simple S3-managed encryption; SSE-KMS adds KMS control, policy,
    auditability, permissions, and request cost.
11. An S3 Bucket Key reduces supported KMS request traffic.
12. A presigned URL grants temporary signed access; it does not make the bucket
    public.
13. Object Lock protects exact object versions.
14. Legal Hold has no fixed expiry; Compliance retention cannot be bypassed.
15. A manual copy creates an independent object; it is not ongoing replication.

## Decision Table

| Requirement | Best direction |
|---|---|
| Frequent access | S3 Standard |
| Unknown or changing access | Intelligent-Tiering |
| Infrequent resilient data | Standard-IA |
| Recreatable single-AZ data | One Zone-IA |
| Archive with millisecond access | Glacier Instant Retrieval |
| Archive restored in minutes to hours | Glacier Flexible Retrieval |
| Lowest-cost long-term archive | Glacier Deep Archive |
| Simple default encryption | SSE-S3 |
| Customer-controlled key and audit events | SSE-KMS |
| Reduce supported S3 KMS requests | S3 Bucket Key |
| Recover normal deletion | Versioning and remove delete marker |
| Temporary private download | Presigned GET URL |
| Prevent deletion indefinitely until released | Legal Hold |
| Automatic transition and expiration | Lifecycle |
| Selected one-time object transfer | Manual copy |

## Important Traps

- A lower storage price can be offset by retrieval, request, minimum-duration,
  minimum-size, and transfer charges.
- Objects under 128 KB do not auto-tier in Intelligent-Tiering.
- Versioning does not remove old bytes; noncurrent versions still cost money.
- Suspending versioning does not delete existing versions.
- Current-version expiration in a versioned bucket normally creates a delete
  marker; configure noncurrent cleanup separately.
- S3 permission alone does not decrypt an SSE-KMS object.
- A presigned URL is a bearer credential until expiry.
- Block Public Access does not replace least-privilege IAM and bucket policies.
- Object Lock protects versions, not only the visible object key.
- Do not use Compliance mode in a temporary lab.
- Emptying only the normal object list does not empty a versioned bucket.
- Manual copy does not automatically copy future object versions.

## Scenarios

### Scenario 1

An application has unpredictable object access and cannot tolerate retrieval
fees. Start with Intelligent-Tiering and evaluate object sizes and monitoring
cost.

### Scenario 2

A private object must be downloadable for five minutes without issuing AWS
credentials. Generate a short-lived presigned GET URL from a principal already
authorized to read the object.

### Scenario 3

A versioned object disappears after a normal delete. Show versions and remove
only the current delete marker to reveal the previous version.

### Scenario 4

A role has `s3:GetObject` but receives `AccessDenied` on an SSE-KMS object.
Check `kms:Decrypt`, the key policy, Region, explicit denies, and encryption
context conditions.

### Scenario 5

Logs should move to Standard-IA at day 30, Glacier Flexible Retrieval at day
90, expire at day 365, and abandon incomplete multipart uploads at day 7. Use
a prefix-scoped lifecycle rule and include noncurrent-version handling.

### Scenario 6

An object must not be deleted until an investigation ends, but no end date is
known. Use Object Lock Legal Hold on the required version.

## Final Check

- [ ] I can describe bucket, object, key, prefix, metadata, and version ID.
- [ ] I can choose an S3 storage class from access and cost requirements.
- [ ] I can explain BPA, Object Ownership, IAM policy, and bucket policy.
- [ ] I can compare SSE-S3, SSE-KMS, and S3 Bucket Keys.
- [ ] I can recover a delete marker without deleting a data version.
- [ ] I can explain lifecycle behavior for current and noncurrent versions.
- [ ] I can explain presigned URL scope, permission, and expiry.
- [ ] I can distinguish Legal Hold, Governance, and Compliance retention.
- [ ] I can distinguish manual copy from S3 Replication.
- [ ] I know every Day 11 resource and hidden version that must be cleaned up.
