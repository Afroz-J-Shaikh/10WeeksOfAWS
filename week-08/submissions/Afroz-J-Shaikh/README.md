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

      ![snapshot](./evidence/day15-edge-and-dns/primary-seconary.png)

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
- VPN versus Direct Connect decision:
- Transit Gateway and hybrid DNS decision:
- Private endpoint decision:
- Workload RTO and RPO:
- DR strategy and reason:
- Source backup result:
- Cross-Region copy result:
- Restore and application-validation result:
- `/health` result and IMDSv2 Region/instance-ID proof:
- Source versus restored instance ID:
- AWS Backup service-role policy check:
- Measured recovery observations:
- Achieved RTO milestone calculation:
- Achieved RPO recovery-point calculation:
- Target-Region dependency/quota finding:
- Troubleshooting lesson:

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
- KMS, IAM, Security Groups and optional network resources:
- Regions and global consoles checked:

## Reflection
1. Why are the ACM validation record and CloudFront application record different?
2. Why can DNS failover take longer than the health-check failure threshold?
3. When would signed cookies be more suitable than a signed URL?
4. How do VPN, Direct Connect and Transit Gateway solve different problems?
5. Why does a completed recovery point not prove the workload RTO?