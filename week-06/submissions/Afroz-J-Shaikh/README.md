# Week 6 - Amazon S3 and Storage

## Learner
- Name: Afroz Shaikh
- GitHub: https://github.com/Afroz-J-Shaikh
- LinkedIn: https://www.linkedin.com/in/afroz-j-shaikh/
- Region: Mumbai

## Day 11

- Customer Managed KMS key

   ![snapshot](./evidence/day11-s3/kms-key.png)
   
- Source-bucket security controls:

   ![snapshot](./evidence/day11-s3/src-bucket.png)

   ![snapshot](./evidence/day11-s3/src-bucket1.png)

   ![snapshot](./evidence/day11-s3/src-bucket2.png)

- Destination SSE-KMS and Bucket Key:

   ![snapshot](./evidence/day11-s3/dest-bucket.png)

   ![snapshot](./evidence/day11-s3/dest-bucket1.png)

- S3 Prefixes and Storage-classe decisions:

   ![snapshot](./evidence/day11-s3/src-prefix.png)

   - Uploaded the required demonstration objects and verified their storage classes, including `standard-demo.txt` using `S3 Standard` and `intelligent-tiering-demo.txt` using `S3 Intelligent-Tiering`.

   ![snapshot](./evidence/day11-s3/src-standard.png)

   ![snapshot](./evidence/day11-s3/src-intelligent.png)

- Version and delete-marker recovery:

   - Version 1
   
   ![snapshot](./evidence/day11-s3/src-v1.png)

   - Version 2

   ![snapshot](./evidence/day11-s3/src-v2.png)

   - Delete `version-demo.txt`

   ![snapshot](./evidence/day11-s3/src-delete1.png)

   - Show versions

   ![snapshot](./evidence/day11-s3/src-show-version.png)

   - After deleting marker

   ![snapshot](./evidence/day11-s3/src-delete-marker.png)

   - Version 2 is current version again

   ![snapshot](./evidence/day11-s3/src-v2-back.png)

   ![snapshot](./evidence/day11-s3/src-v2-data.png)

- Manual copy and encryption result:

   - Copied from source to destination

   ![snapshot](./evidence/day11-s3/report-copied.png)

   ![snapshot](./evidence/day11-s3/copied1.png)

   ![snapshot](./evidence/day11-s3/copied2.png)

- Normal URL denial:

   ![snapshot](./evidence/day11-s3/src-private-err.png)

   ![snapshot](./evidence/day11-s3/block-access.png)

   - Create below plicy

   ![snapshot](./evidence/day11-s3/create-policy.png)

   ![snapshot](./evidence/day11-s3/policy-reject.png)

- Presigned URL result and expiry:

   - Accessed using presigned URL

   ![snapshot](./evidence/day11-s3/private-url.png)

   - Normal Object URL still returns AccessDenied

   ![snapshot](./evidence/day11-s3/normal-denied.png)

   - Presigned URL failed after expiry

   ![snapshot](./evidence/day11-s3/expired.png)

- Lifecycle rule:

   ![snapshot](./evidence/day11-s3/lifecycle.png)

- Object Lock Legal Hold result:

   - New Bucket created with object lock `enabled`

   ![snapshot](./evidence/day11-s3/lock-bucket1.png)

   - `Object Lock Legal Hold` enabled

   ![snapshot](./evidence/day11-s3/lock-object-hold.png)

   - Deletion is denied while Legal Hold in ON

   ![snapshot](./evidence/day11-s3/lock-denied-delete.png)

   - Set Legal Hold to OFF

   ![snapshot](./evidence/day11-s3/lock-hold-disabled.png)

   - Deletion successful

   ![snapshot](./evidence/day11-s3/lock-object-deleted.png)


## Day 12
- Source, SRR destination, and CRR destination Regions:
- SRR rule and version results:
- CRR rule and version results:
- Pre-rule object result:
- Unmatched-prefix result:
- Transfer Acceleration review:
- Multipart cleanup rule:
- EFS and FSx review:
- Hybrid-storage decisions:
- Optional Compliance or website result:

## Architecture Decision
Write 250-400 words.

## Cleanup
- Source bucket and versions:
- Destination bucket and versions:
- Object Lock bucket and protected versions:
- Multipart uploads:
- KMS key:
- Replication rules and IAM role:
- Transfer Acceleration:
- Optional website and Compliance cleanup:
- Public-access controls:

## Reflection
1. Which S3 control protects confidentiality, and which protects recovery?
2. Why is a presigned URL different from making a bucket public?
3. Which storage-class or lifecycle decision is easiest to get wrong on cost?
4. Why did pre-rule objects remain only in the source?
5. When would you choose DataSync instead of Snow Family?


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

## Day 12 Evidence Checklist

- [ ] Three private, versioned SSE-S3 buckets in the intended Regions
- [ ] Enabled `srr-prefix-rule` and `crr-prefix-rule`
- [ ] SRR source `COMPLETED` and destination `REPLICA` evidence
- [ ] SRR destination contains Versions 1 and 2
- [ ] CRR source `COMPLETED` and destination `REPLICA` evidence
- [ ] CRR destination contains Versions 1 and 2
- [ ] `srr/before-rule.txt` and `crr/before-rule.txt` remain source-only
- [ ] `other/no-replication-demo.txt` remains source-only
- [ ] Transfer Acceleration configuration reviewed
- [ ] Seven-day incomplete multipart cleanup rule
- [ ] Existing EFS configuration and TCP `2049` review
- [ ] FSx family and hybrid-storage decision table
- [ ] Optional Compliance denial and pending-cleanup note, if performed
- [ ] Optional website and error page plus restored BPA, if performed
- [ ] Complete Day 12 cleanup and LinkedIn link