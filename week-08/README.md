# Week 8 - Global Edge, Hybrid Connectivity, and Disaster Recovery

AWS Zero To Hero - CloudAdhar x TrainWithShubham<br>
Sessions: Aug 22-23, 2026<br>
Course sessions: Day 15-16<br>
Exam focus: SAA-C03 Domains 1-4<br>
Main pillars: Security, Reliability, Performance Efficiency, and Cost Optimization

Week 8 joins global application delivery with recovery planning. Day 15 covers
Route 53 routing, health checks, private S3 delivery through CloudFront OAC,
cache behavior, signed URLs, ACM, AWS WAF, Shield, and Global Accelerator. Day
16 covers hybrid connectivity, private DNS and endpoints, RTO/RPO, DR
strategies, and a cross-Region EC2 backup, copy, and restore.

## Start Here

| Seq | Session | Focus | File |
|---:|---|---|---|
| 01 | Day 15 | Route 53, CloudFront, ACM, WAF, Shield, and Global Accelerator | [01-route53-cloudfront-edge-security.md](./01-route53-cloudfront-edge-security.md) |
| 02 | Day 15 | Build private edge delivery and health-based DNS from scratch | [02-route53-cloudfront-edge-security-lab.md](./02-route53-cloudfront-edge-security-lab.md) |
| 03 | Day 16 | Hybrid networking, private connectivity, RTO/RPO, and DR patterns | [03-hybrid-connectivity-and-disaster-recovery.md](./03-hybrid-connectivity-and-disaster-recovery.md) |
| 04 | Day 16 | Back up, copy, restore, and validate an EC2 workload cross-Region | [04-hybrid-connectivity-disaster-recovery-lab.md](./04-hybrid-connectivity-disaster-recovery-lab.md) |
| 05 | Week 8 | Document the global delivery, hybrid, and DR architecture | [05-architecture-exercise.md](./05-architecture-exercise.md) |
| 06 | End | Remove Day 15 and Day 16 resources safely | [06-cleanup.md](./06-cleanup.md) |
| 07 | End | Submit Week 8 evidence | [07-submission-format.md](./07-submission-format.md) |
| 08 | Daily | Share learning progress | [08-linkedin-post.md](./08-linkedin-post.md) |
| 09 | Review | Revise Week 8 decisions and practice questions | [09-quick-revision.md](./09-quick-revision.md) |

Architecture references:

- [CloudFront private content and edge security](./%23%20CloudFront%20Private%20Content%20and%20Edge%20Security.png)
- [Route 53 multi-Region active-passive failover](./%23%20Route%2053%20Multi-Region%20Active-Passive%20Failover.png)
- [Day 15 sample origin page](./index.html)

## Day 15 Required Outcomes

- Select DNS record types and Route 53 routing policies from requirements.
- Build two Regional HTTP endpoints and validate weighted and failover routing.
- Create a private S3 origin and allow reads only through CloudFront OAC.
- Observe cache headers, update content, and create an invalidation.
- Protect `private/*` with a trusted key group and test a signed URL.
- Request an ACM public certificate in `us-east-1` from scratch, create its DNS
  validation CNAME, wait for `Issued`, and attach it to CloudFront.
- Create the application DNS record separately from the ACM validation record.
- Test a WAF rule in Count mode, briefly validate Block, and restore access.
- Explain signed cookies, Shield Standard/Advanced, and Global Accelerator.

## Day 16 Required Outcomes

- Choose Site-to-Site VPN or Direct Connect and explain resilient designs.
- Explain Transit Gateway attachments, associations, propagation, and routes.
- Select private hosted zones, Resolver endpoints, gateway/interface endpoints,
  and PrivateLink correctly.
- Define RTO and RPO and compare backup/restore, pilot light, warm standby, and
  active-active DR.
- Check target-Region quotas and dependencies before declaring a DR design.
- Create an encrypted EC2 workload and on-demand AWS Backup recovery point.
- Copy the recovery point from Mumbai to N. Virginia.
- Restore a new EC2 instance and validate the recovered application and data.
- Explain optional Route 53 failover to the recovered workload.

## Minimum Submission

- Day 15 private-origin denial and CloudFront success
- Cache miss/hit evidence and invalidation result
- Signed URL denial/success comparison
- ACM request, DNS validation, `Issued` status, custom-domain HTTPS proof
- Route 53 weighted and active-passive failover evidence
- WAF Count/Block evidence with access restored
- Day 16 source workload, completed recovery point, cross-Region copy, restore
  job, recovered content, and target-Region dependency validation
- Hybrid-connectivity and DR decision tables
- Separate Day 15 edge and Day 16 hybrid/DR diagrams
- A 300-500 word architecture explanation, cleanup proof, and two public posts

## Cost and Safety

- Use a non-root training identity, MFA, synthetic data, and your own account.
- Never copy trainer account IDs, IP addresses, hosted zones, certificate names,
  distribution IDs, or ARNs from a demonstration.
- Use a domain/subdomain you control for ACM and Route 53 custom-domain work.
- Learners are expected to request ACM themselves. If no authorized domain or
  delegated subdomain is available, obtain instructor approval for a
  design-only exception and document the blocker; the default CloudFront
  certificate is not evidence that the ACM challenge was completed.
- CloudFront viewer certificates must be requested or imported in `us-east-1`.
- Route 53 hosted zones and health checks, public IPv4, EC2, WAF, AWS Backup,
  cross-Region copies, and customer-managed KMS keys may generate charges.
- Do not create Shield Advanced, Global Accelerator, Direct Connect, Transit
  Gateway, Resolver endpoints, interface endpoints, or Site-to-Site VPN only
  for a screenshot.
- Delete lab resources in both Regions after collecting sanitized evidence.

<div align="center">

[Week 7](../week-07/) | [Home](../README.md)

</div>
