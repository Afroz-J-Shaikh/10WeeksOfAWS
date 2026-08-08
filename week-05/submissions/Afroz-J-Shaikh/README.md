# Week 5 - Auto Scaling and Elastic Load Balancing

## Learner
- Name: Afroz Shaikh
- GitHub: https://github.com/Afroz-J-Shaikh
- LinkedIn: https://www.linkedin.com/in/afroz-j-shaikh/
- Region: Mumbai

## Day 9
- Launch Template version and security choices:

   - Created 2 security groups

      
      ![snapshot](./evidence/day9-auto-scaling/alb-sg.png)  

      ![snapshot](./evidence/day9-auto-scaling/web-sg.png)

   - Created Launch Template

      ![snapshot](./evidence/day9-auto-scaling/template.png)

- Target group and ALB

   ![snapshot](./evidence/day9-auto-scaling/tg.png)

   ![snapshot](./evidence/day9-auto-scaling/alb.png)

- ASG min/desired/max and AZs:

   ![snapshot](./evidence/day9-auto-scaling/asg1.png)

   ![snapshot](./evidence/day9-auto-scaling/asg2.png)

- One `InService` instance, one `Healthy` target, and a `working` ALB page

   ![snapshot](./evidence/day9-auto-scaling/running-ec2.png)

   ![snapshot](./evidence/day9-auto-scaling/healthy-tg.png)

   ![snapshot](./evidence/day9-auto-scaling/working-alb.png)

- Target tracking metric and target:

   - Created Target Tracking Policy

   ![snapshot](./evidence/day9-auto-scaling/policy.png)

   - Ran a bounded CPU test

   ![snapshot](./evidence/day9-auto-scaling/test.png)

- High CPU alarm triggered

   ![snapshot](./evidence/day9-auto-scaling/alarm-high.png)

- Scale-out result:

   ![snapshot](./evidence/day9-auto-scaling/2-ec2.png)

   ![snapshot](./evidence/day9-auto-scaling/desired.png)

   ![snapshot](./evidence/day9-auto-scaling/activity.png)

   ![snapshot](./evidence/day9-auto-scaling/2-tg.png)

   - The ALB returning two distinct instance IDs across repeated requests

   ![snapshot](./evidence/day9-auto-scaling/ip1.png)

   ![snapshot](./evidence/day9-auto-scaling/ip2.png)

- Scale-in result:
 
   ![snapshot](./evidence/day9-auto-scaling/alarm-low.png)

   ![snapshot](./evidence/day9-auto-scaling/ec2-off.png)

   ![snapshot](./evidence/day9-auto-scaling/desired2.png)

   ![snapshot](./evidence/day9-auto-scaling/activity2.png)

   ![snapshot](./evidence/day9-auto-scaling/1-tg.png)

- Self-healing result:

   - Stopped Nginx

   ![snapshot](./evidence/day9-auto-scaling/stop.png)

   ![snapshot](./evidence/day9-auto-scaling/t-unhealthy.png)

   ![snapshot](./evidence/day9-auto-scaling/unhealthy-activity.png)

   - New EC2 launched and working

   ![snapshot](./evidence/day9-auto-scaling/new-old-ec2.png)

   ![snapshot](./evidence/day9-auto-scaling/new-ec2.png)

- Troubleshooting lesson:
   
   - No issues

## Day 10
- Blue and Green target design:

   - Launched Blue and Green EC2

   ![snapshot](./evidence/day10-load-balancing/blue-ec2.png)

   ![snapshot](./evidence/day10-load-balancing/green-ec2.png)

- Target Groups and ALB

   ![snapshot](./evidence/day10-load-balancing/tgs.png)

   ![snapshot](./evidence/day10-load-balancing/alb.png)

   - Default blue page

   ![snapshot](./evidence/day10-load-balancing/blue-page.png)

- Host and path routing:

   ![snapshot](./evidence/day10-load-balancing/rules.png)

   ![snapshot](./evidence/day10-load-balancing/rule-rt.png)

- Weighted release sample:

   ![snapshot](./evidence/day10-load-balancing/release.png)

> The observed distribution (~80.6% Blue and ~19.4% Green) closely matched the configured 80:20 weighted forwarding rule, demonstrating successful Blue/Green traffic distribution.

- Stickiness result:

   ![snapshot](./evidence/day10-load-balancing/stickiness-en.png)

   ![snapshot](./evidence/day10-load-balancing/stickiness.png)

- Health and draining result:

   - Green Target nhealthy

   ![snapshot](./evidence/day10-load-balancing/nginx-stop.png)
 
   ![snapshot](./evidence/day10-load-balancing/app2-bad.png)

   ![snapshot](./evidence/day10-load-balancing/green-unhealthy.png)

   - Green Target Healthy

   ![snapshot](./evidence/day10-load-balancing/nginx-start.png)
 
   ![snapshot](./evidence/day10-load-balancing/app2-good.png)

   ![snapshot](./evidence/day10-load-balancing/green-healthy.png)

   - Draining

   ![snapshot](./evidence/day10-load-balancing/drain-blue.png)

   ![snapshot](./evidence/day10-load-balancing/err-blue.png)


- NLB TCP result:

   - Created Target Group and NLB

   ![snapshot](./evidence/day10-load-balancing/nlb-tg.png)

   ![snapshot](./evidence/day10-load-balancing/nlb-web.png)

   ![snapshot](./evidence/day10-load-balancing/nlb-traffic.png)

   - **Flow hashing, not round robin** NLB operates at L4 and picks a target using a hash of the 5-tuple (source IP, source port, dest IP, dest port, protocol). Every new TCP connection gets hashed independently — it's not tracking "last target used" and alternating.

   - Zonal Distribution

   ![snapshot](./evidence/day10-load-balancing/zonal.png)

- ALB/NLB/GWLB decisions:

| Hard requirement | Select | Reason |
|---|---|---|
| HTTP/HTTPS host, path, header, query, redirect, authentication, or WAF | ALB | Layer 7 listener rules understand HTTP |
| TCP, TLS, UDP, static zonal IP, optional EIP, or extreme performance | NLB | Layer 4 flow load balancing |
| Transparent firewall, IDS, IPS, or deep-packet inspection | GWLB | Inserts compatible appliances through GENEVE |

## Architecture Decision
Write 250-400 words.

## Cleanup
- Auto Scaling resources:

   ![snapshot](./evidence/cleanup/asg.png)

- Load balancers and target groups:

   ![snapshot](./evidence/cleanup/lb.png)

   ![snapshot](./evidence/cleanup/tg.png)

- Instances:

   ![snapshot](./evidence/cleanup/ec2.png)

- EIPs and public IPv4:

   ![snapshot](./evidence/cleanup/ip.png)

- Optional resources:

   ![snapshot](./evidence/cleanup/sg.png)

   ![snapshot](./evidence/cleanup/vpc.png)

## Reflection
1. Which metric best represents demand for this application?
2. How do grace period, warmup, health checks, and draining differ?
3. Which load balancer requirement was easiest to confuse, and why?