# Day 16 Lab - Cross-Region EC2 Backup and Disaster Recovery

Build a disposable Mumbai workload, protect it with AWS Backup, copy its
recovery point to N. Virginia, restore a new instance, and validate the
recovered application. Use only your AWS account and synthetic data.

## Scope and Cost Guardrails

Mandatory: EC2, encrypted EBS, two backup vaults, cross-Region recovery-point
copy, restore, and validation.

Optional: private hosted zone, S3 gateway endpoint, and Route 53 DR failover.

Explain only: Site-to-Site VPN, Direct Connect, Transit Gateway, Resolver
endpoints, interface endpoints, and PrivateLink. Do not create these billable
connectivity resources just for evidence.

Choose the same learner prefix used on Day 15:

| Placeholder | Example | Rule |
|---|---|---|
| `<LEARNER>` | `anita` | Short lowercase name or GitHub username |
| `<PREFIX>` | `anita-w8` | Unique learner prefix; never use instructor names |
| `<SOURCE-PUBLIC-IP>` | Runtime value | Keep private and mask in evidence |
| `<RESTORED-PUBLIC-IP>` | Runtime value | Keep private and mask in evidence |

| Purpose | Region | Name |
|---|---|---|
| Source EC2 | `ap-south-1` | `<PREFIX>-day16-primary` |
| Source SG | `ap-south-1` | `<PREFIX>-day16-primary-sg` |
| Source vault | `ap-south-1` | `<PREFIX>-day16-primary-vault` |
| Destination KMS alias | `us-east-1` | `alias/<PREFIX>-day16-dr-backup-key` |
| Destination vault | `us-east-1` | `<PREFIX>-day16-dr-vault` |
| Destination SG | `us-east-1` | `<PREFIX>-day16-dr-sg` |
| Restored EC2 | `us-east-1` | `<PREFIX>-day16-dr-restored` |

Do not use root. Confirm both Regions have suitable VPCs/subnets and enough EC2
quota. EC2, EBS snapshots, public IPv4, backup storage/copy, and a
customer-managed KMS key can generate charges.

## Part A - Record the Recovery Design

Before building, state:

```text
Chosen workload RTO: ______________________
Chosen workload RPO: ______________________
DR strategy: Backup and restore
Reason this strategy fits: ________________
Target-Region quotas checked: _____________
Dependencies required after restore: ______
```

Explain why a completed backup alone does not prove the RTO.

## Part B - Launch the Mumbai Workload

### Create the source Security Group

1. Select **Asia Pacific (Mumbai), `ap-south-1`**.
2. Open **EC2 → Security Groups → Create security group**.
3. Name it `<PREFIX>-day16-primary-sg` and select the default or approved VPC.
4. Allow HTTP TCP 80 only from your current public IP `/32` where practical.
5. Keep default outbound access for package installation.
6. Do not open SSH globally. Use Session Manager or a temporary My-IP rule.

If you later perform the optional public Route 53 health-check exercise,
temporarily allow the documented Route 53 health-checker source ranges or
another approved narrowly scoped rule.

### Launch the source instance

Open **EC2 → Instances → Launch instances** and configure:

Launch a small Amazon Linux 2023 instance:

| Setting | Value |
|---|---|
| Name | `<PREFIX>-day16-primary` |
| Network | Public subnet in the selected VPC |
| Public IPv4 | Enabled only for this lab |
| Security Group | `<PREFIX>-day16-primary-sg` |
| Root volume | 8 GiB `gp3`, encrypted |
| Tag | `Backup=Day16` |

Select an approved key-pair/administration method. Under **Advanced details →
User data**, paste:

User data:

```bash
#!/bin/bash
dnf install -y nginx
cat <<'HTML' > /usr/share/nginx/html/index.html
<!doctype html><html><body style="font-family:Arial;text-align:center;padding:80px">
<h1>&lt;YOUR-NAME&gt; - Production</h1>
<h2>Mumbai - ap-south-1</h2>
<p>Protected using AWS Backup</p>
<p id="marker">Synthetic recovery marker: DAY16</p>
</body></html>
HTML
systemctl enable --now nginx
```

Wait for both EC2 status checks. Validate `http://<SOURCE-PUBLIC-IP>/` and from
inside the instance:

```bash
sudo systemctl status nginx --no-pager
sudo ss -ltnp | grep ':80'
curl -I http://localhost
curl http://localhost | grep 'Synthetic recovery marker: DAY16'
```

Record privately the instance, VPC, subnet, private IP, public IP, AMI,
architecture, IAM profile, and SG. Open the root volume details and confirm
**Encrypted = Yes** before creating a backup.

## Part C - Prepare the N. Virginia Recovery Region

In `us-east-1`:

### Check recovery capacity first

1. Open **Service Quotas → AWS services → Amazon Elastic Compute Cloud**.
2. Inspect the On-Demand vCPU quota for the planned instance family.
3. Open **VPC** and confirm the target VPC, public subnet, route table, internet
   gateway, available CIDR addresses, and Network ACL behavior.
4. Record whether public IPv4 assignment is automatic or must be configured.
5. Confirm the Region supports the source AMI architecture and planned instance
   type.

### Create the destination KMS key

1. Open **KMS → Customer managed keys → Create key**.
2. Choose **Symmetric**, **Encrypt and decrypt**, and KMS key material generated
   by KMS.
3. Configure approved key administrators and usage permissions.
4. Set alias `alias/<PREFIX>-day16-dr-backup-key` and enable rotation.
5. Do not schedule deletion while any destination recovery point uses the key.

### Create the destination vault

1. Open **AWS Backup → Backup vaults → Add backup vault**.
2. Name it `<PREFIX>-day16-dr-vault`.
3. Select the customer-managed KMS key created above.
4. Create the vault and confirm its encryption key.
5. Do not enable Backup Vault Lock for this disposable challenge.

### Prepare destination network access

1. Create `<PREFIX>-day16-dr-sg` in the target VPC.
2. Allow temporary HTTP TCP 80 from your current public IP `/32` where
   practical.
3. Select the intended public subnet and confirm its route table reaches an
   internet gateway.
4. Record the VPC ID, subnet ID, SG ID, and public-IP behavior privately for the
   restore form.

Do not enable Vault Lock for this disposable lab. Preserve the KMS permissions
required by AWS Backup and the restore role.

## Part D - Create the Source Recovery Point

Return to Mumbai.

1. Open **AWS Backup → Settings → Service opt-in** and ensure EC2 resource
   protection is enabled for the account/Region.
2. Open **Backup vaults → Add backup vault**.
3. Create `<PREFIX>-day16-primary-vault` with the default or approved encryption
   key. Do not enable Vault Lock.
4. Choose **Protected resources → Create on-demand backup**.
5. Configure:

```text
Resource type:       EC2
Instance ID:         exact <PREFIX>-day16-primary instance
Backup window:       Create backup now
Backup vault:        <PREFIX>-day16-primary-vault
IAM role:            Default AWS Backup role or approved existing role
Lifecycle/retention: short deliberate lab value allowed by policy
```

6. Choose **Create on-demand backup** once; do not repeatedly click while the
   job is starting.
7. Open **Jobs → Backup jobs**, select the job, and monitor until **Completed**.
8. Open the source vault and confirm the EC2 recovery point is visible.

Record the backup job ID, completion time, recovery-point ARN suffix, resource
ID, vault, and expiry. A running or completed-with-issues job is not acceptable
evidence.

## Part E - Copy the Recovery Point Cross-Region

From the completed source recovery point:

1. Open **AWS Backup → Backup vaults → `<PREFIX>-day16-primary-vault>`**.
2. Select the completed EC2 recovery point and choose **Copy**.
3. Configure:

```text
Destination Region: US East (N. Virginia), us-east-1
Destination vault:  <PREFIX>-day16-dr-vault
IAM role:            Default copy role or approved existing role
Retention:           deliberate disposable-lab value
```

4. Start the copy once.
5. Monitor **Jobs → Copy jobs** until **Completed**.
6. Switch the console Region to `us-east-1`, open the destination vault, and
   confirm the copied EC2 recovery point exists and uses the intended
   destination encryption.

Record the copy job ID, source/destination Regions and vaults, completion time,
and destination recovery point. Cross-Region copy contributes to RPO only after
the copy is complete.

## Part F - Simulate Failure Safely

Do not terminate the source yet. Simulate application failure by stopping Nginx
through Session Manager/Instance Connect:

```bash
sudo systemctl stop nginx
curl --max-time 5 http://localhost || true
```

Confirm the public HTTP request fails. This preserves the instance for safe
comparison and avoids making a destructive assumption before recovery succeeds.

## Part G - Restore in N. Virginia

In `us-east-1`, open the copied recovery point and choose **Restore**.

Configure the restore explicitly rather than accepting unknown source defaults:

- a compatible small instance type;
- the selected target VPC and public subnet;
- `<PREFIX>-day16-dr-sg`;
- an approved IAM instance profile or none if the app does not require it;
- the default AWS Backup restore role or an approved restore role; and
- the source key-pair behavior and an approved management path.

AWS Backup restores the same EC2 key-pair association used by the protected
instance; the restore workflow does not let you select a different key pair.
Ensure that key still exists if it is required, or use an approved Systems
Manager path. AWS Backup also does not back up and restore launch user data.
The Nginx page in this challenge is recovered because the installed files are
on the backed-up EBS volume, not because the original user-data script reruns.

Start the restore and monitor **Restore jobs** until **Completed**. Restore
creates a new EC2 instance and volumes; it does not move or overwrite the
source.

Console sequence:

1. Open **AWS Backup → Backup vaults → `<PREFIX>-day16-dr-vault>`**.
2. Select the copied EC2 recovery point and choose **Restore**.
3. Select the compatible instance type.
4. Choose the planned destination VPC, subnet, and
   `<PREFIX>-day16-dr-sg`—not a source-Region identifier.
5. Review IAM instance profile, termination protection, shutdown behavior,
   monitoring, key pair, and user-data behavior.
6. Select the default AWS Backup restore role or approved equivalent.
7. Choose **Restore backup** once and record the restore job ID/start time.
8. Open **Jobs → Restore jobs**, select the job, and wait for **Completed**.

Tag the new instance `Name=<PREFIX>-day16-dr-restored`. If it has no public
IPv4, assign one only through an approved target-subnet/launch configuration or
validate privately from a managed client. Do not confuse an AWS Backup restore
success with application readiness.

## Part H - Validate the Recovered Workload

Confirm:

1. EC2 instance and system status checks pass.
2. The restored EBS volume is encrypted.
3. Nginx is running; start it if the simulated stopped-service state was
   captured in the backup or if boot behavior requires it.
4. `http://<RESTORED-PUBLIC-IP>/` displays the Mumbai page and the exact
   synthetic recovery marker.
5. Source and restored instance IDs differ.
6. Region, VPC, subnet, SG, public/private IP, IAM, and monitoring settings are
   reviewed for the DR environment.
7. The measured restore elapsed time is compared with the stated RTO.
8. The recovery-point completion time is compared with failure time and RPO.

Only after successful validation may you terminate the disposable source during
cleanup.

## Optional Part I - Private DNS and S3 Gateway Endpoint

For private DNS:

1. Open **Route 53 → Hosted zones → Create hosted zone**.
2. Enter `<LEARNER>.internal`, choose **Private hosted zone**, and associate the
   intended Mumbai VPC.
3. Create `app.<LEARNER>.internal` as an `A` record containing the source private
   IP.
4. From an EC2 instance inside the associated VPC, run:

```bash
getent hosts app.<LEARNER>.internal
curl "http://app.<LEARNER>.internal/"
```

5. Confirm it does not resolve from a normal public-internet client.

For S3 private routing:

1. Open **VPC → Endpoints → Create endpoint**.
2. Select **AWS services** and the Regional S3 service whose type is **Gateway**.
3. Select the intended VPC and route table used by the test instance.
4. Use Full access only for the short lab or an approved constrained endpoint
   policy.
5. Create the endpoint and inspect the route table for the S3 managed prefix
   list targeting the endpoint.
6. Test S3 access from the workload. An endpoint route alone does not prove the
   instance avoided another egress path; document how flow logs, routing, and
   removal of NAT/public egress could prove it.

## Optional Part J - Route 53 DR Failover

If you control a public hosted zone, create health checks and primary/secondary
failover records for the source and restored endpoints. With the source Nginx
stopped, query a Route 53 authoritative name server and confirm the secondary
answer. Restart source Nginx, wait for its health check to become Healthy, and
prove failback. Explain why DNS failover does not perform the backup, restore,
or application validation. Remove any temporary health-check ingress rules
immediately afterward.

Use the Day 15 domain/provider instructions. Do not create records under an
instructor's domain. The restored endpoint must pass application validation
before it becomes a failover target.

## Required Decision Notes

Complete these without creating the services:

| Scenario | Your choice and reason |
|---|---|
| Rapid encrypted hybrid connection | Site-to-Site VPN / other |
| Predictable high bandwidth | Direct Connect / other |
| Many VPC and VPN attachments | Transit Gateway / other |
| On-prem resolves AWS private names | Resolver inbound endpoint / other |
| VPC forwards a domain to on-prem DNS | Resolver outbound endpoint / other |
| Private S3 access | Gateway endpoint / other |
| Private access to a supported AWS API | Interface endpoint / other |
| Lowest-cost relaxed DR | Backup and restore / other |
| Core services always running | Pilot light / other |
| Reduced complete environment | Warm standby / other |
| Both Regions serve traffic | Active-active / other |

## Troubleshooting Order

### Source webpage does not open

Check both EC2 status checks, Nginx status, TCP 80 listener, user-data logs,
Security Group source, subnet route table, public IPv4, and Network ACL.

### Backup job remains Pending or fails

Confirm EC2 service opt-in, exact Region, AWS Backup service role, source
instance state, KMS permissions, and the job's Status message. Do not delete the
source while the backup is incomplete.

### Cross-Region copy fails

Check destination Region/vault, KMS key state and policy, AWS Backup role,
recovery-point state, and whether the source encryption/key arrangement
supports the copy. Read the copy job's Status message before retrying.

### Restore job is Completed but no webpage is reachable

1. Find the new EC2 instance from the restore job's resource link.
2. Confirm the target VPC, subnet, SG, and public/private IP behavior.
3. Confirm both EC2 status checks.
4. Use an approved management path to inspect Nginx and port 80.
5. Remember that restore does not automatically adapt page text, DNS, secrets,
   or configuration to the new Region.

### Restored instance has no public IPv4

This can be valid. Validate privately from a managed client, or deliberately
associate an approved public endpoint/EIP path for the lab. Do not replace the
Security Group with an unrestricted one merely to make the page reachable.

### Destination vault or KMS key cannot be deleted

Delete only lab recovery points through AWS Backup, wait for deletion, confirm
the vault is empty, remove all dependencies, and schedule KMS deletion last.
Never delete a key needed by a retained recovery point.

## Official References

- [AWS Backup cross-Region copies](https://docs.aws.amazon.com/aws-backup/latest/devguide/cross-region-backup.html)
- [Restore an EC2 instance with AWS Backup](https://docs.aws.amazon.com/aws-backup/latest/devguide/restoring-ec2.html)
- [AWS Backup service opt-in](https://docs.aws.amazon.com/aws-backup/latest/devguide/assigning-resources.html)
- [Route 53 private hosted zones](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-private.html)
- [VPC gateway endpoints](https://docs.aws.amazon.com/vpc/latest/privatelink/gateway-endpoints.html)
- [Disaster recovery strategies](https://docs.aws.amazon.com/whitepapers/latest/disaster-recovery-workloads-on-aws/disaster-recovery-options-in-the-cloud.html)

## Validation Checklist

- [ ] Source instance, page, marker, and EBS encryption are proven
- [ ] Target-Region network, quota, KMS, and SG dependencies are checked
- [ ] Source recovery point is Completed
- [ ] Cross-Region copy job is Completed
- [ ] Destination vault contains the encrypted copied recovery point
- [ ] Restore job is Completed and creates a different EC2 instance
- [ ] Restored page contains the expected synthetic marker
- [ ] Actual RTO and RPO observations are recorded
- [ ] Hybrid and DR strategy decisions are completed
- [ ] Cleanup is completed in Mumbai and N. Virginia

Continue with [Week 8 cleanup](./06-cleanup.md).
