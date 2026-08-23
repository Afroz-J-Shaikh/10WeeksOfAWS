# Hybrid Connectivity and Disaster Recovery

Day 16 separates connectivity decisions from recovery decisions. A network
path does not create a recovery copy, and a backup does not provide routing,
capacity, identity, or application dependencies in the recovery Region.

## Site-to-Site VPN and Direct Connect

| Requirement | Direction |
|---|---|
| Fast setup over the internet, encryption by default | Site-to-Site VPN |
| Predictable private circuit and sustained bandwidth | Direct Connect |
| Private circuit plus encrypted transport | Direct Connect plus VPN |
| Many VPCs and on-premises networks | Transit Gateway hub |

An AWS Site-to-Site VPN uses a customer gateway resource, a virtual private
gateway or Transit Gateway, and two tunnels for availability. Resilient hybrid
designs use redundant customer devices, paths, and—where required—locations.

Direct Connect provides private connectivity but is not encrypted by default.
Private VIFs reach VPC resources, public VIFs reach AWS public endpoints, and
transit VIFs connect through a Direct Connect gateway to Transit Gateway.

## Transit Gateway

Transit Gateway is a Regional routing hub. Attachments connect VPCs, VPNs, or
other supported networks. An attachment associates with one TGW route table
for ingress routing and may propagate routes into one or more route tables.
Static and blackhole routes support deliberate segmentation and failure
control. VPC route tables must also send the intended CIDRs to the TGW.

## Hybrid DNS and Private AWS Access

| Need | Service |
|---|---|
| Private names for associated VPCs | Route 53 private hosted zone |
| On-premises queries AWS private names | Resolver inbound endpoint |
| VPC queries forwarded to on-prem DNS | Resolver outbound endpoint + rule |
| Private S3/DynamoDB path in route tables | Gateway VPC endpoint |
| Private ENIs for supported services | Interface endpoint |
| Publish a service privately to consumers | AWS PrivateLink |

Resolver endpoints and interface endpoints have hourly and usage costs. A
gateway endpoint has no additional endpoint hourly charge, but service usage
still costs money.

## RTO, RPO, and DR Strategies

- Recovery Time Objective (RTO): maximum acceptable time to restore service.
- Recovery Point Objective (RPO): maximum acceptable data loss measured in time.

| Strategy | Running in DR Region | Relative cost | Typical recovery |
|---|---|---:|---|
| Backup and restore | Backups and templates | Lowest | Slowest |
| Pilot light | Core data/services | Low-medium | Rebuild/scale application |
| Warm standby | Reduced full stack | Medium-high | Scale and route |
| Active-active | Full serving stack | Highest | Fastest, most complex |

These labels do not guarantee an RTO or RPO. Measure backup frequency,
replication lag, copy completion, infrastructure deployment, data restore,
DNS behavior, validation, and operational decision time.

## AWS Backup Cross-Region Recovery

```text
EC2 + encrypted EBS (Mumbai)
          |
          v
source vault and recovery point
          |
          | cross-Region copy
          v
encrypted destination vault (N. Virginia)
          |
          v
new restored EC2 + validation
```

A completed backup job is not the same as a tested recovery. The target Region
also needs compatible KMS access, subnet routing, Security Groups, IAM roles,
instance capacity, service quotas, DNS, secrets, observability, and dependent
services. Restore creates new resources; validate data and application
behavior before routing production traffic.

## Exam Cues

- Quick encrypted hybrid path -> Site-to-Site VPN
- Consistent high-bandwidth private circuit -> Direct Connect
- Many VPCs/networks -> Transit Gateway
- On-prem resolves private hosted-zone names -> Resolver inbound endpoint
- Private access to S3 without NAT -> gateway endpoint
- Lowest-cost DR with relaxed objectives -> backup and restore
- Minimal core always running -> pilot light
- Reduced full environment -> warm standby
- Near-zero interruption and multi-Region serving -> active-active

## Official AWS References

- [Site-to-Site VPN architecture](https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html)
- [Direct Connect resiliency](https://docs.aws.amazon.com/directconnect/latest/UserGuide/Welcome.html)
- [Transit Gateway route tables](https://docs.aws.amazon.com/vpc/latest/tgw/tgw-route-tables.html)
- [Route 53 Resolver endpoints](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver.html)
- [VPC endpoints](https://docs.aws.amazon.com/vpc/latest/privatelink/concepts.html)
- [AWS disaster recovery strategies](https://docs.aws.amazon.com/whitepapers/latest/disaster-recovery-workloads-on-aws/disaster-recovery-options-in-the-cloud.html)
- [AWS Backup cross-Region copies](https://docs.aws.amazon.com/aws-backup/latest/devguide/cross-region-backup.html)
- [Restoring EC2 with AWS Backup](https://docs.aws.amazon.com/aws-backup/latest/devguide/restoring-ec2.html)
