# Week 8 - Global Edge, Hybrid Connectivity, and Disaster Recovery

## Learner
- Name: Afroz Shaikh
- GitHub: https://github.com/Afroz-J-Shaikh
- LinkedIn: https://www.linkedin.com/in/afroz-j-shaikh/
- Learner resource prefix: afroz-w8
- Domain/DNS provider used: GoDaddy
- Primary Region: Mumbai
- DR Region: N. Virginia

## Day 15

### Part A - Request and Validate ACM from Scratch

   ![snapshot](./evidence/day15-edge-and-dns/issued.png)

   ![snapshot](./evidence/day15-edge-and-dns/dig-cname.png)

### Part B - Create Two Regional HTTP Endpoints

   - Mumbai Endpoint

      ![snapshot](./evidence/day15-edge-and-dns/mumbai.png)

   - N. Virginia Endpoint

      ![snapshot](./evidence/day15-edge-and-dns/virginia.png)

### Part C - Create the Private S3 Origin

   ![snapshot](./evidence/day15-edge-and-dns/s3.png)

   ![snapshot](./evidence/day15-edge-and-dns/s3-1.png)

   - private/learner-proof.txt returns `Access Denied`

   ![snapshot](./evidence/day15-edge-and-dns/learner-proof.png)

### Part D - Create CloudFront with OAC

   ![snapshot](./evidence/day15-edge-and-dns/cloud-front.png)

   ![snapshot](./evidence/day15-edge-and-dns/policy.png)

   ![snapshot](./evidence/day15-edge-and-dns/cdn-v1.png)

### Part E - Prove Cache Behavior

   - CloudFront Hit-Miss

      ![snapshot](./evidence/day15-edge-and-dns/hit-miss.png)

   - Uploaded index.html `v2`

      ![snapshot](./evidence/day15-edge-and-dns/upload-v2.png)

   - Cache still showing `v1`

      ![snapshot](./evidence/day15-edge-and-dns/cdn-v1.png)

    - Created `invalidation`

       ![snapshot](./evidence/day15-edge-and-dns/invalid.png)

    - CloudFront showing `v2`

       ![snapshot](./evidence/day15-edge-and-dns/cdn-v2.png)

### Part F - Protect a Path with a Signed URL

   - Created the signing keys
      
      ![snapshot](./evidence/day15-edge-and-dns/key-gen.png)

   - Without Key

      ![snapshot](./evidence/day15-edge-and-dns/without-key.png)

   - Without Key

      ![snapshot](./evidence/day15-edge-and-dns/with-key.png)

   - Expired

      ![snapshot](./evidence/day15-edge-and-dns/expired.png)

### Part G - Attach Your ACM Certificate and DNS Name

   ![snapshot](./evidence/day15-edge-and-dns/dig-cdn.png)

### Part H - Create Route 53 Health Checks and Records

   - Lab Hosted Zone

      ![snapshot](./evidence/day15-edge-and-dns/hosted-zone.png)

      ![snapshot](./evidence/day15-edge-and-dns/lab-records.png)

   - Endpoint Records

      ![snapshot](./evidence/day15-edge-and-dns/primary-secondary.png)

   - Route53 health checks

      ![snapshot](./evidence/day15-edge-and-dns/hc.png)

   - `80/20` weighted records

      ![snapshot](./evidence/day15-edge-and-dns/weighted.png)

   - `50/50` weighted records

      ![snapshot](./evidence/day15-edge-and-dns/weighted-50.png)

   - Active-passive failover 

      - Primary Healthy

      ![snapshot](./evidence/day15-edge-and-dns/primary-healthy.png)

      - Failed Primary

      ![snapshot](./evidence/day15-edge-and-dns/failed-primary.png)

      ![snapshot](./evidence/day15-edge-and-dns/failed-primary1.png)

      - Secondary responded when failover

      ![snapshot](./evidence/day15-edge-and-dns/secondary.png)

      - Making Primary Active Again

      ![snapshot](./evidence/day15-edge-and-dns/active-primary.png)

      ![snapshot](./evidence/day15-edge-and-dns/failed-primary1.png)

      - Primary Serving Again

      ![snapshot](./evidence/day15-edge-and-dns/primary-again.png)

### Part I - Test WAF Safely

   - Sampled requests `Action = Count`

      ![snapshot](./evidence/day15-edge-and-dns/sample.png)

   - Sampled requests `Action = Block`

      ![snapshot](./evidence/day15-edge-and-dns/block.png)

      ![snapshot](./evidence/day15-edge-and-dns/sample-block.png)

   - Rule deleted

      ![snapshot](./evidence/day15-edge-and-dns/working.png)

## Day 16

## Part A - Record the Recovery Design

Before building, state:

```text
Chosen workload RTO: 30-60 mins
Chosen workload RPO: 6 hours
DR strategy: Backup and restore
Reason this strategy fits: Lower cost, non-critical workloads where some data loss are acceptable
Target-Region quotas checked: 32vCPU
Dependencies required after restore: correct KMS access, subnet routing, Security Group rules, IAM role, DNS updates, secrets, monitoring and application-level validation
```
- Explain why a completed backup alone does not prove the RTO.

   - Completed backup only proves data is captured, it says nothing about how long it will take to copy it cross-Region, restore it into a new instance, reconfigure networking/KMS/IAM in that Region, validate the app is actually healthy, and cut traffic over.
   - RTO is the sum of all those stages (detection + declaration + orchestration + restore + configuration + validation + cutover).

### Part B - Launch the Mumbai Workload 

   ![snapshot](./evidence/day16-hybrid-and-dr/mumbai-ec2.png)

### Part C - Prepare the N. Virginia Recovery Region

#### Check recovery capacity first

   - On-Demand vCPU quota

      ![snapshot](./evidence/day16-hybrid-and-dr/quota.png)

   - Available CIDR addresses, and Network ACL behavior

      ![snapshot](./evidence/day16-hybrid-and-dr/available-ip.png)

      ![snapshot](./evidence/day16-hybrid-and-dr/acl.png)

   - VPC, public subnet, route table, internet gateway all available, public IPv4 automatic assignment

      ![snapshot](./evidence/day16-hybrid-and-dr/vpc-data.png)

#### The destination KMS key

   ![snapshot](./evidence/day16-hybrid-and-dr/dest-kms.png)

#### The destination vault

   ![snapshot](./evidence/day16-hybrid-and-dr/vault.png)

#### Destination network access

   - Public subnet's route table reaches an internet gateway

     ![snapshot](./evidence/day16-hybrid-and-dr/igw.png)

   - VPC ID - `vpc-04d001b175ba54323`
   - subnet ID - `subnet-06359a9a92628ed2b` 
   - SG ID - `sg-015daa2cc66f58252` 
   - Auto-assign public IPv4 address

### Part D - Create the Source Recovery Point

   ![snapshot](./evidence/day16-hybrid-and-dr/backup-job.png)

   - Backup job ID - `6b98e02e-c344-4b1b-a6f4-0b81eeac3b5e` 
   - Completion time - `2mins 3secs`
   - Recovery-point ARN suffix - `arn:aws:ec2:ap-south-1::image/ami-0444e5217c33aaa67`
   - resource ID - ` instance/i-0aaa9d0b18317dd1d` 
   - vault - `afroz-week8-day16-primary-vault`
   - expiry - `7 days`

### Part E - Copy the Recovery Point Cross-Region

   ![snapshot](./evidence/day16-hybrid-and-dr/copy-job.png)

   - Job ID - `82e37311-4cee-4e84-b498-49f232efd524` 
   - Source Region - `Asia Pacific (Mumbai)`
   - destination Region - `United States (N. Virginia)`
   - Source Vault - `afroz-week8-day16-primary-vault` 
   - destination Vault - `afroz-week8-day16-dr-vault` 
   - Completion time - `2 mins 31 secs` 
   - Destination recovery point - `arn:aws:ec2:us-east-1::image/ami-0b7d0dbf401eb24e4`

   - Destination Recovery Point

      ![snapshot](./evidence/day16-hybrid-and-dr/dst-recovery.png)

      ![snapshot](./evidence/day16-hybrid-and-dr/encryp.png)

### Part F - Simulate Failure Safely

   ![snapshot](./evidence/day16-hybrid-and-dr/pri-fail.png)

 ``` text
   Incident time   :  2026-08-28 23:11:28 UTC (2026-08-29 04:41:28 IST)
   Detection time  :  2026-08-28 23:11:37 UTC (2026-08-29 04:41:37 IST)
   Declaration time:  2026-08-28 23:15:42 UTC (2026-08-29 04:45:42 IST)
```

### Part G - Restore in N. Virginia

   ![snapshot](./evidence/day16-hybrid-and-dr/restore-job.png)

### Part H - Validate the Recovered Workload

   - EC2 instance and system status checks pass

      ![snapshot](./evidence/day16-hybrid-and-dr/restore-ec2.png)

      ![snapshot](./evidence/day16-hybrid-and-dr/pass.png)

   - Restore EBS volume encrypted

      ![snapshot](./evidence/day16-hybrid-and-dr/restore-encryp.png)

   - The page displays **DR Recovery Successful**, N. Virginia, `us-east-1`, the new instance ID, and the exact synthetic recovery marker

      ![snapshot](./evidence/day16-hybrid-and-dr/site.png)

   - The restored endpoint returns `HTTP 200` and /health returns `healthy`

      ![snapshot](./evidence/day16-hybrid-and-dr/restore-healthy.png)

   - IMDSv2 independently reports us-east-1 and the same restored instance ID

      ![snapshot](./evidence/day16-hybrid-and-dr/restore-imds.png)

   - Source and restored instance IDs differ

      - Source Instance

         ![snapshot](./evidence/day16-hybrid-and-dr/src.png)

      - Restored Instance

         ![snapshot](./evidence/day16-hybrid-and-dr/restore.png)

### Calculate achieved objectives from recorded UTC timestamps:

```text
Achieved RTO = detection + declaration + orchestration + restore
               + configuration + validation
             = 23:11:37 + 23:15:42 + 23:20:16 + 23:21:33 + 23:46:45 + 23:50:03
             = 04:41:37 + 04:45:42 + 04:50:16 + 04:51:33 + 05:16:45 + 05:20:03
             = 38 min 35 sec

Achieved RPO = incident time - latest usable copied recovery-point time
             = 23:11:28 UTC − 23:03:47 UTC
             = 04:41:28 IST − 04:33:47 IST
             = 7 minutes 41 seconds
```

## Architecture Explanation
Write 300-500 words.

## Cleanup
- Day 15 EC2, DNS, health checks, CloudFront, WAF, S3 and signing keys:

  ![snapshot](./evidence/cleanup/ec2.png)

  ![snapshot](./evidence/cleanup/hc.png)

  ![snapshot](./evidence/cleanup/dst.png)

  ![snapshot](./evidence/cleanup/acl.png)

  ![snapshot](./evidence/cleanup/s3.png)

  ![snapshot](./evidence/cleanup/key.png)

  ![snapshot](./evidence/cleanup/zone.png)

  ![snapshot](./evidence/cleanup/ip-set.png)

- ACM certificate and validation-record decision:

   - Deleted All

   ![snapshot](./evidence/cleanup/cert.png)

- Day 16 EC2, EBS, backup recovery points and vaults:

   ![snapshot](./evidence/cleanup/ec21.png)

   ![snapshot](./evidence/cleanup/sg.png)

   ![snapshot](./evidence/cleanup/dr-vault.png)

   ![snapshot](./evidence/cleanup/vault.png)

- KMS:

   ![snapshot](./evidence/cleanup/kms.png) 

- Regions and global consoles checked:

## Reflection
1. Why are the ACM validation record and CloudFront application record different?
2. Why can DNS failover take longer than the health-check failure threshold?
3. When would signed cookies be more suitable than a signed URL?
4. How do VPN, Direct Connect and Transit Gateway solve different problems?
5. Why does a completed recovery point not prove the workload RTO?