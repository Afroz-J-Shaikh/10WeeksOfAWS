# Week 6 - Amazon S3 Foundations and Security

AWS Zero To Hero - CloudAdhar x TrainWithShubham<br>
Sessions: Aug 8-9, 2026<br>
Course sessions: Day 11-12<br>
Exam focus: SAA-C03 Domains 1, 2, 3, and 4<br>
Main pillars: Security, Reliability, Performance Efficiency, and Cost Optimization

Week 6 begins with Amazon S3 object storage, storage classes, versioning,
encryption, access control, lifecycle management, presigned URLs, and Object
Lock. Day 12 material will be added after the Day 12 class; this draft does not
invent or pre-publish that session.

## Start Here

| Seq | Session | Focus | File |
|---:|---|---|---|
| 01 | Day 11 | S3 foundations, storage classes, security, and cost | [01-s3-foundations-security-cost.md](./01-s3-foundations-security-cost.md) |
| 02 | Day 11 | Build and validate a private, versioned S3 workflow | [02-s3-security-lifecycle-lab.md](./02-s3-security-lifecycle-lab.md) |
| 03 | Day 12 | Replication and additional Week 6 storage topics | Coming after Day 12 class |
| 04 | Day 12 | Day 12 practical | Coming after Day 12 class |
| 05 | Day 11 | Document the S3 architecture and decisions | [05-architecture-exercise.md](./05-architecture-exercise.md) |
| 06 | End | Remove all Day 11 resources safely | [06-cleanup.md](./06-cleanup.md) |
| 07 | End | Submit Week 6 evidence | [07-submission-format.md](./07-submission-format.md) |
| 08 | Daily | Share learning progress | [08-linkedin-post.md](./08-linkedin-post.md) |
| 09 | Review | Revise Day 11 decisions and exam cues | [09-quick-revision.md](./09-quick-revision.md) |

## Day 11 Required Outcomes

- Explain buckets, objects, keys, prefixes, metadata, version IDs, and the
  Regional S3 model.
- Select S3 Standard, Intelligent-Tiering, Standard-IA, One Zone-IA, and
  Glacier storage classes from access, resilience, retrieval, and cost needs.
- Create private General Purpose buckets with ACLs disabled and all four Block
  Public Access settings enabled.
- Compare SSE-S3 and SSE-KMS and explain S3 Bucket Keys.
- Upload objects using Standard and Intelligent-Tiering.
- Create two versions of one key, observe a delete marker, and recover the
  object without deleting its data versions.
- Copy a private object between buckets and validate destination SSE-KMS
  encryption with a customer managed key.
- Prove the normal Object URL is denied and a short-lived presigned URL grants
  narrow temporary access.
- Configure lifecycle transitions, current and noncurrent expiration, and
  incomplete multipart-upload cleanup.
- Use Object Lock Legal Hold to deny deletion safely, then remove the hold and
  clean up the exact object version.

## Day 11 Architecture

```text
                           AWS Account - ap-south-1

Approved user -- presigned GET --> Private source S3 bucket
Anonymous user -- normal URL ----X AccessDenied
                                      |
                                      | CopyObject
                                      v
                              Private destination bucket
                              SSE-KMS + S3 Bucket Key
                                      |
                                      v
                              Customer managed KMS key

Separate Object Lock bucket -- version + Legal Hold --> delete denied
```

The source bucket uses SSE-S3, versioning, lifecycle rules, storage-class
examples, and Block Public Access. The destination bucket uses SSE-KMS with
`alias/cloudadhar-s3-day11`. Manual copy is a Day 11 operation; continuous S3
Replication belongs to Day 12.

## Minimum Submission for Day 11

- Source and destination bucket security settings
- Source SSE-S3 and destination SSE-KMS configuration
- S3 Bucket Key enabled on the destination
- Standard and Intelligent-Tiering object properties
- Two object versions, delete marker, and recovered object
- Successful bucket-to-bucket copy and destination encryption proof
- Normal Object URL denied
- Block Public Access safely rejecting or neutralizing the public-policy test
- Presigned access success without exposing the URL
- Enabled lifecycle rule with the complete timeline
- Object Lock Legal Hold denial and successful cleanup after hold removal
- Architecture decision, cleanup proof, and public learning post

## Cost and Safety

- Use a training role, not the root user.
- Upload only synthetic training data.
- Keep ACLs disabled and all four Block Public Access settings enabled.
- Never make the class bucket public to demonstrate public access.
- Treat a presigned URL as a temporary bearer credential and never publish it.
- Never use Object Lock Compliance mode in a disposable class account.
- Versioning, noncurrent objects, multipart parts, storage transitions, KMS
  requests, and retained locked versions can create cost.
- Empty every object version and delete marker before deleting a bucket.
- Remove S3 dependencies before disabling or scheduling deletion of the KMS
  key.
- Mask account IDs, ARNs, URLs, object names containing private data, access
  keys, session tokens, email addresses, organization data, and billing data.

<div align="center">

[Week 5](../week-05/) | [Home](../README.md)

</div>
