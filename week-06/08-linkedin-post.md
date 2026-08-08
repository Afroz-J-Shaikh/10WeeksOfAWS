# Week 6 Learn-in-Public Posts

Write in your own voice and publish only sanitized evidence.

## Day 11

```text
Week 6, Day 11 of #10WeeksOfAWS

Today I built a private, versioned Amazon S3 workflow for training reports.

I compared S3 Standard and Intelligent-Tiering, recovered an object by removing
a delete marker, copied an SSE-S3 object into an SSE-KMS destination, and
validated a short-lived presigned URL without making the bucket public.

My most important security lesson:
<BPA, ACLs, bucket policy, KMS, presigned URL, or Object Lock observation>

My storage or lifecycle decision:
<Requirement -> choice -> reason>

My recovery proof:
<Versioning or Legal Hold result>

I removed all object versions, delete markers, buckets, and lab-only KMS
dependencies after collecting evidence.

#AWS #AmazonS3 #CloudSecurity #CloudArchitecture #CloudAdhar #TrainWithShubham
```

## Day 12

Add the Day 12 post after the Day 12 guide is published.

Do not show bucket names that identify you, account IDs, ARNs, normal object
URLs, presigned URLs, KMS identifiers, access credentials, private object
contents, organization information, or billing data.
