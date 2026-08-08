# Week 6 Submission Format

Day 11 can be submitted now. Add Day 12 evidence after that class and keep both
days in the same Week 6 submission.

```text
week-06/submissions/<github-username>/
├── README.md
├── architecture.png
└── evidence/
    ├── day11-s3/
    ├── day12-storage/
    └── cleanup/
```

## README Template

```markdown
# Week 6 - Amazon S3 and Storage

## Learner
- Name:
- GitHub:
- LinkedIn:
- Primary Region:

## Day 11
- Source-bucket security controls:
- Destination SSE-KMS and Bucket Key:
- Storage-class decisions:
- Version and delete-marker recovery:
- Manual copy and encryption result:
- Normal URL denial:
- Presigned URL result and expiry:
- Lifecycle rule:
- Object Lock Legal Hold result:
- Troubleshooting lesson:

## Day 12
- Complete after Day 12 material is published.

## Architecture Decision
Write 250-400 words.

## Cleanup
- Source bucket and versions:
- Destination bucket and versions:
- Object Lock bucket and protected versions:
- Multipart uploads:
- KMS key:
- Public-access controls:

## Reflection
1. Which S3 control protects confidentiality, and which protects recovery?
2. Why is a presigned URL different from making a bucket public?
3. Which storage-class or lifecycle decision is easiest to get wrong on cost?
```

## Day 11 Evidence Checklist

- [ ] Source: Bucket owner enforced, BPA on, versioning, and SSE-S3
- [ ] Destination: BPA on, versioning, SSE-KMS, correct KMS key, and Bucket Key
- [ ] Standard and Intelligent-Tiering object properties
- [ ] Two version IDs and a delete marker
- [ ] Recovered object after deleting only the delete marker
- [ ] Successful manual copy into `copied/private-report.txt`
- [ ] Destination-object SSE-KMS validation
- [ ] Normal private Object URL denied
- [ ] Controlled public-policy denial while BPA remains on
- [ ] Presigned access success without showing the URL
- [ ] Presigned access failure after expiry
- [ ] Enabled `logs-transition-and-cleanup` lifecycle timeline
- [ ] Object Lock enabled and Legal Hold on the exact version
- [ ] Controlled delete denial and successful cleanup after Legal Hold off
- [ ] Day 11 architecture and decision table
- [ ] Complete cleanup evidence and Day 11 LinkedIn link

Mask account IDs, ARNs, bucket/object URLs, presigned URLs, access keys, session
tokens, email addresses, organization data, private object contents, and
billing information.
