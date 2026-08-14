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

- Optional Make-Up A - Object Lock Compliance

   - Created bucket and enabled Object Lock Retention
   
   ![snapshot](./evidence/day12-storage/lock-retention.png)

   - Normal delete succeeds by creating a delete marker

   ![snapshot](./evidence/day12-storage/lock-delete.png)

   ![snapshot](./evidence/day12-storage/lock-delete-marker.png)

   - `Access Denied`, zero successfully deleted versions

   ![snapshot](./evidence/day12-storage/lock-delete-denied.png)

- Optional Make-Up B - Native S3 Static Website

   - Bucket created content added, normal URL `ObjectDenied`

   ![snapshot](./evidence/day12-storage/website-bucket.png)

   ![snapshot](./evidence/day12-storage/url-denied.png)

   - Enabled **Static Website Hosting**, still returns 403 before public-read permission is configured

   ![snapshot](./evidence/day12-storage/website-denied.png)

   - Turn off only the two public-policy blockers required at the account level and bucket level

   ![snapshot](./evidence/day12-storage/bpa-account.png)

   ![snapshot](./evidence/day12-storage/bpa-bucket.png)

   - Added bucket policy

   ![snapshot](./evidence/day12-storage/policy.png)

   - Website Accessable (Home Page + Error Page)

   ![snapshot](./evidence/day12-storage/url-acessed.png)

   ![snapshot](./evidence/day12-storage/url-error.png)

- Source, SRR destination, and CRR destination Regions:

   - Replication Source Bucket Verification

   ![snapshot](./evidence/day12-storage/source.png)

   ![snapshot](./evidence/day12-storage/source1.png)

   ![snapshot](./evidence/day12-storage/source2.png)

   - SRR Destination Bucket Verification

   ![snapshot](./evidence/day12-storage/srr-dest.png)

   ![snapshot](./evidence/day12-storage/srr-dest1.png)

   ![snapshot](./evidence/day12-storage/srr-dest2.png)

   - CRR Destination Bucket Verification

   ![snapshot](./evidence/day12-storage/crr-dest.png)

   ![snapshot](./evidence/day12-storage/crr-dest1.png)

   ![snapshot](./evidence/day12-storage/crr-dest2.png)

- Object uploaded in source bucket before any rule creation

   ![snapshot](./evidence/day12-storage/srr-before.png)

   ![snapshot](./evidence/day12-storage/crr-before.png)

- SRR rule and version results:

   - Replication Rule Created
   
   ![snapshot](./evidence/day12-storage/srr-rule.png)

   - Object uploaded to key `srr/` and object showed replication status `PENDING` then `COMPLETED`

   ![snapshot](./evidence/day12-storage/src-srr-rep.png)

   - The destination object report `REPLICA`

   ![snapshot](./evidence/day12-storage/srr-replica.png)

   ![snapshot](./evidence/day12-storage/srr-replica-data.png)

- CRR rule and version results:

   - Replication Rule Created

   ![snapshot](./evidence/day12-storage/crr-rule.png)

   - Object uploaded to key `crr/` and object showed replication status `PENDING` then `COMPLETED`

   ![snapshot](./evidence/day12-storage/src-crr-rep.png)

   - The destination object report `REPLICA`

   ![snapshot](./evidence/day12-storage/crr-replica.png)

   ![snapshot](./evidence/day12-storage/crr-replica-data.png)

- Pre-rule object result:

   - Data existing pre-rule is not replicated in both SRR and CRR

   - Validation of source `srr/` and SRR bucket data

   ![snapshot](./evidence/day12-storage/src-srr-data.png)

   ![snapshot](./evidence/day12-storage/srr-data.png)

   - Validation of source `crr/` and CRR bucket data

   ![snapshot](./evidence/day12-storage/src-crr-data.png)

   ![snapshot](./evidence/day12-storage/crr-data.png)

- Unmatched-prefix result:

   - Created and uploaded object in `other/` in source bucket and confirmed no replication occured

   ![snapshot](./evidence/day12-storage/other-data.png)

   ![snapshot](./evidence/day12-storage/other-rep-status.png)

   - Not replicated in either **SRR** nor **CRR**

   ![snapshot](./evidence/day12-storage/srr-no-rep.png)

   ![snapshot](./evidence/day12-storage/crr-no-rep.png)

- Review Existing-Object Replication

   ![snapshot](./evidence/day12-storage/batch.png)

   ![snapshot](./evidence/day12-storage/batch1.png)

- Transfer Acceleration review:

   - Transfer Acceleration endpoint created

   ![snapshot](./evidence/day12-storage/transfer-endpoint.png)

   - Configured to user endpoint for transfering 

   ![snapshot](./evidence/day12-storage/transfer-cli.png)

   - Speed Comparision

   ![snapshot](./evidence/day12-storage/transfer-comp.png)

   - Enabling Transfer Acceleration on a bucket doesn't automatically speed anything up. It just turns on the capability. The client (CLI, SDK, or app) has to explicitly target the accelerated endpoint — otherwise every request still goes to the regular regional endpoint and you get zero benefit despite paying for it.

- Multipart cleanup rule:

   ![snapshot](./evidence/day12-storage/multipart-rule.png)

- EFS review:

   ![snapshot](./evidence/day12-storage/efs-general.png)

   ![snapshot](./evidence/day12-storage/regional.png)
   
- FSx review:

   ![snapshot](./evidence/day12-storage/netapp.png)

   ![snapshot](./evidence/day12-storage/zfs.png)

   ![snapshot](./evidence/day12-storage/windows.png)

   ![snapshot](./evidence/day12-storage/luster.png)


## Architecture Decision
Write 250-400 words.

## Cleanup

- All buckets emptied and deleted except Object Lock Compliance:

   ![snapshot](./evidence/cleanup/s3.png)

- KMS key scheduled for deletion:

   ![snapshot](./evidence/cleanup/kms.png)

- Public-access controls:
  
   ![snapshot](./evidence/cleanup/pba.png)

## Reflection
1. Which S3 control protects confidentiality, and which protects recovery?

   - **Confidentiality:** SSE-S3 / SSE-KMS (encryption at rest) + access-control layers (Block Public Access, bucket owner enforced, IAM/bucket policies). SSE-KMS adds separate key polic and requires kms:GenerateDataKey/kms:Decrypt on top of S3 permissions.

   - **Recovery:** Versioning + delete-marker removal. A normal delete just adds a delete marker — removing that marker restores the previous version. Permanent deletion of a specific version is normally irreversible, so recovery depends entirely on versioning being enabled beforehand.

2. Why is a presigned URL different from making a bucket public?

   - A presigned URL grants a single signed operation on one specific object, tied to an expiry time, and scoped to whatever the signer's own IAM permissions already allow .

   - A public bucket exposes access to anyone with no expiry check.

   - The bucket itself stays private in presigned URL. Anyone holding the link before it expires can use it, so short expiry and not publishing the full URL are the practical safeguards.

3. Which storage-class or lifecycle decision is easiest to get wrong on cost?

   1. The Retrieval Fee Trap (Standard-IA & Glacier)
      - Moving to `Standard-IA` without checking how often app reads the data.
      - S3 standard doesn't charge for data retrievals only for storage.
      - If your app reads more than `-55%` of your total data volume than retrieval fees will cost more than S3 standard.

   2. Deleting/overwriting file shortly after a lifecycle policy moves them to a colder tier.
      - If you delete or replace your file 5 days later after it has been moved to Standard-IA,
      AWS will still bill you for remaining 25 days as a prorated early-deletion fee..

4. Why did pre-rule objects remain only in the source?

   - Live replication is forward-looking — it only applies to eligible object versions created after the replication rule becomes active. Anything uploaded before the rule existed has no rule to match against, so S3 never queues it for replication.
   - We can use S3 Batch Replication as the separate mechanism for pre-existing or previously-failed objects.

5. When would you choose DataSync instead of Snow Family?

   - **DataSync** 
      - Small-medium data, decent bandwidth, needs to run regularly
      - Keeping on-prem and S3/EFS continuously in sync

   - **Snow Family** 
      - Huge data (many TB/PB), weak/no network, one-time migration
      - Remote location with no reliable internet, need local compute too

## Day 11 Evidence Checklist

- [x] Source: Bucket owner enforced, BPA on, versioning, and SSE-S3
- [x] Destination: BPA on, versioning, SSE-KMS, correct KMS key, and Bucket Key
- [x] Standard and Intelligent-Tiering object properties
- [x] Two version IDs and a delete marker
- [x] Recovered object after deleting only the delete marker
- [x] Successful manual copy into `copied/private-report.txt`
- [x] Destination-object SSE-KMS validation
- [x] Normal private Object URL denied
- [x] Controlled public-policy denial while BPA remains on
- [x] Presigned access success without showing the URL
- [x] Presigned access failure after expiry
- [x] Enabled `logs-transition-and-cleanup` lifecycle timeline
- [x] Object Lock enabled and Legal Hold on the exact version
- [x] Controlled delete denial and successful cleanup after Legal Hold off
- [x] Day 11 architecture and decision table
- [x] Complete cleanup evidence and Day 11 LinkedIn link

## Day 12 Evidence Checklist

- [x] Three private, versioned SSE-S3 buckets in the intended Regions
- [x] Enabled `srr-prefix-rule` and `crr-prefix-rule`
- [x] SRR source `COMPLETED` and destination `REPLICA` evidence
- [x] SRR destination contains Versions 1 and 2
- [x] CRR source `COMPLETED` and destination `REPLICA` evidence
- [x] CRR destination contains Versions 1 and 2
- [x] `srr/before-rule.txt` and `crr/before-rule.txt` remain source-only
- [x] `other/no-replication-demo.txt` remains source-only
- [x] Transfer Acceleration configuration reviewed
- [x] Seven-day incomplete multipart cleanup rule
- [x] Existing EFS configuration and TCP `2049` review
- [x] FSx family and hybrid-storage decision table
- [x] Optional Compliance denial and pending-cleanup note, if performed
- [x] Optional website and error page plus restored BPA, if performed
- [x] Complete Day 12 cleanup and LinkedIn link