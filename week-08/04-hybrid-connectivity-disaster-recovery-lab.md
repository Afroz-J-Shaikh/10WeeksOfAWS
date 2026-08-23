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

| Purpose | Region | Name |
|---|---|---|
| Source EC2 | `ap-south-1` | `cloudadhar-day16-primary` |
| Source SG | `ap-south-1` | `cloudadhar-day16-primary-sg` |
| Source vault | `ap-south-1` | `cloudadhar-day16-primary-vault` |
| Destination KMS alias | `us-east-1` | `alias/cloudadhar-day16-dr-backup-key` |
| Destination vault | `us-east-1` | `cloudadhar-day16-dr-vault` |
| Destination SG | `us-east-1` | `cloudadhar-day16-dr-sg` |
| Restored EC2 | `us-east-1` | `cloudadhar-day16-dr-restored` |

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

In `ap-south-1`, create `cloudadhar-day16-primary-sg` in the intended VPC.
Allow HTTP TCP 80 only from your current public IP `/32` where practical. Do
not open SSH globally. If you later perform the optional public Route 53
health-check exercise, temporarily allow the documented Route 53 health-checker
source ranges or another approved narrowly scoped rule.

Launch a small Amazon Linux 2023 instance:

| Setting | Value |
|---|---|
| Name | `cloudadhar-day16-primary` |
| Network | Public subnet in the selected VPC |
| Public IPv4 | Enabled only for this lab |
| Security Group | `cloudadhar-day16-primary-sg` |
| Root volume | 8 GiB `gp3`, encrypted |
| Tag | `Backup=Day16` |

User data:

```bash
#!/bin/bash
dnf install -y nginx
cat <<'HTML' > /usr/share/nginx/html/index.html
<!doctype html><html><body style="font-family:Arial;text-align:center;padding:80px">
<h1>CloudAdhar - Production</h1>
<h2>Mumbai - ap-south-1</h2>
<p>Protected using AWS Backup</p>
<p id="marker">Synthetic recovery marker: DAY16</p>
</body></html>
HTML
systemctl enable --now nginx
```

Validate `http://<SOURCE-PUBLIC-IP>/`. Record privately the instance, VPC,
subnet, private IP, public IP, AMI, architecture, IAM profile, and SG. Confirm
the root EBS volume reports encryption enabled.

## Part C - Prepare the N. Virginia Recovery Region

In `us-east-1`:

1. Inspect EC2 On-Demand quota, VPC/subnet availability, and required service
   dependencies.
2. Create a symmetric customer-managed KMS key for AWS Backup, enable rotation,
   and set alias `alias/cloudadhar-day16-dr-backup-key`.
3. Create backup vault `cloudadhar-day16-dr-vault` encrypted with that key.
4. Create `cloudadhar-day16-dr-sg` in the target VPC with temporary HTTP TCP 80
   from your current public IP `/32` where practical.
5. Select a target public subnet and confirm its route table reaches an internet
   gateway and that public IPv4 assignment is understood.

Do not enable Vault Lock for this disposable lab. Preserve the KMS permissions
required by AWS Backup and the restore role.

## Part D - Create the Source Recovery Point

Return to Mumbai.

1. Open **AWS Backup → Settings** and ensure EC2 resource protection is enabled
   for the account/Region.
2. Create vault `cloudadhar-day16-primary-vault` with the default or approved
   encryption key.
3. Choose **Protected resources → Create on-demand backup**.
4. Select **EC2**, the exact source instance, the source vault, **Create backup
   now**, and the default AWS Backup service role (or an approved existing role).
5. Use a short disposable retention period permitted by the console and your
   policy; never set retention shorter than the challenge needs.
6. Monitor **Jobs → Backup jobs** until status is **Completed**.

Record the backup job ID, completion time, recovery-point ARN suffix, resource
ID, vault, and expiry. A running or completed-with-issues job is not acceptable
evidence.

## Part E - Copy the Recovery Point Cross-Region

From the completed source recovery point:

1. Choose **Copy**.
2. Destination Region: `us-east-1`.
3. Destination vault: `cloudadhar-day16-dr-vault`.
4. Select a deliberate retention period and start the copy.
5. Monitor **Jobs → Copy jobs** until **Completed**.
6. Switch to `us-east-1`, open the destination vault, and confirm the copied EC2
   recovery point exists and uses the intended destination encryption.

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
- `cloudadhar-day16-dr-sg`;
- an approved IAM instance profile or none if the app does not require it;
- the default AWS Backup restore role or an approved restore role; and
- no SSH key unless it is genuinely required.

Start the restore and monitor **Restore jobs** until **Completed**. Restore
creates a new EC2 instance and volumes; it does not move or overwrite the
source.

Tag the new instance `Name=cloudadhar-day16-dr-restored`. If it has no public
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

For private DNS, create a private hosted zone such as
`cloudadhar.internal`, associate only the intended VPC, create an `A` record
for an internal endpoint, and test it from inside an associated VPC. It should
not resolve publicly.

For S3 private routing, create an S3 **gateway** VPC endpoint in the intended
VPC, associate the correct route tables, inspect the new prefix-list route, and
test S3 access from a private workload. An endpoint route alone does not prove
the instance avoided another egress path; explain how you would prove it.

## Optional Part J - Route 53 DR Failover

If you control a public hosted zone, create health checks and primary/secondary
failover records for the source and restored endpoints. With the source Nginx
stopped, query a Route 53 authoritative name server and confirm the secondary
answer. Restart source Nginx, wait for its health check to become Healthy, and
prove failback. Explain why DNS failover does not perform the backup, restore,
or application validation. Remove any temporary health-check ingress rules
immediately afterward.

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
