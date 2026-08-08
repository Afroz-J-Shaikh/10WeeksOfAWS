# Week 6 Day 11 Cleanup

Capture sanitized evidence first. Cleanup must include every object version,
delete marker, multipart upload, bucket, and KMS dependency.

## 1. Expire Temporary Access

1. Allow the short-lived presigned URL to expire.
2. Remove it from local notes, shell history, chat, and screenshots.
3. Delete any disposable object used only for URL testing.
4. Confirm the source bucket contains no public bucket policy.
5. Confirm all four account- and bucket-level BPA settings remain enabled.

## 2. Empty and Delete the Object Lock Bucket

1. Open `cloudadhar-s3-day11-lock-<unique-suffix>`.
2. Remove every Legal Hold.
3. If Governance retention was optionally used, wait for expiry or use only a
   pre-approved and pre-tested authorized bypass.
4. Turn **Show versions** on.
5. Permanently delete every data version and delete marker.
6. Confirm no protected version remains.
7. Empty and delete the lock bucket.

Object Lock Compliance retention cannot be bypassed before expiry. The lab
must not use Compliance mode.

## 3. Empty and Delete the Destination Bucket

1. Open `cloudadhar-s3-day11-copy-<unique-suffix>`.
2. Turn **Show versions** on.
3. Permanently delete all data versions and delete markers.
4. Abort any incomplete multipart uploads.
5. Confirm the bucket is empty and delete it.

## 4. Empty and Delete the Source Bucket

1. Remove any remaining controlled test policy text.
2. Delete the lifecycle rule if the bucket will not be deleted immediately.
3. Turn **Show versions** on.
4. Permanently delete all current and noncurrent versions and delete markers.
5. Abort incomplete multipart uploads.
6. Confirm the bucket is empty and delete it.

Deleting only the visible current objects is insufficient in a versioned
bucket.

## 5. Remove the KMS Key Safely

Only after the destination bucket and every SSE-KMS object are gone:

1. Open **KMS -> Customer managed keys**.
2. Select `alias/cloudadhar-s3-day11`.
3. Confirm no non-lab resource uses the key.
4. Disable it or schedule deletion according to the training account policy.
5. Use the minimum approved waiting period only when the account owner permits
   scheduled deletion.

KMS keys cannot be deleted immediately. Scheduling deletion is destructive;
never schedule a shared or production key.

## Final Check

- [ ] No Day 11 S3 bucket remains.
- [ ] No current or noncurrent training object remains.
- [ ] No delete marker remains.
- [ ] No Legal Hold or retention-protected version remains.
- [ ] No incomplete multipart upload remains.
- [ ] No public bucket policy remains.
- [ ] All four account-level BPA controls remain on.
- [ ] The lab-only KMS key is disabled or scheduled according to policy.
- [ ] The bucket list and correct AWS account were checked.
- [ ] Billing and Cost Management will be reviewed after usage data arrives.

S3 storage, versions, incomplete multipart parts, retrieval, requests, data
transfer, and KMS can continue to create charges until dependencies are
removed.
