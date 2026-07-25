# Week 3 - Amazon VPC

## Name
Afroz Shaikh

## Architecture

   * AWS two-tier architecture - Secure and highly available
   * In this acrchitecture 1 public and private subnet is created in on AZ and 1 more public and private subnet is created in other AZ.
   * Secure connection of user accessing an application is shown.

   ![snapshot](./diagrams/week-03-vpc-two-az.png)

## CIDR Plan

| Resource | CIDR Block | Total address | Usable Address |
|----------|------------|---------------|----------------|
| VPC | `10.10.0.0/16` | 65,536 | 65,531 |
| Public Subnet A | `10.10.1.0/24` | 256 | 251 |
| Private Subnet A | `10.10.11.0/24` | 256 | 251 |
| Public Subnet B | `10.10.2.0/24` | 256 | 251 |
| Private Subnet B | `10.10.12.0/24` | 256 | 251 |

## Public vs Private

* A subnet is **public** when it:
   * IGW(Internet Gateway) is attached to it.
   * Can automatically assign public IP address to resources created inside it.

* A subnet is **private** when it:
   * Does not have IGW attached to it.
   * Does not assign public IP address.
   * It only contains local route.

## Day 5 Result
Explain the VPC, subnet, IGW, and route-table validation.

   * VPC

   ![snapshot](./screenshots/vpc.png)

   * Subnets

   ![snapshot](./screenshots/subnet.png)

   * Internet Gateway

   ![snapshot](./screenshots/igw.png)

   * Main Route Table

   ![snapshot](./screenshots/main-rt.png)

   * Public Route Table

    ![snapshot](./screenshots/public-rt.png)

   * Private Route Table

   ![snapshot](./screenshots/private-rt.png)
   



## Day 6 Result

### Part - 1
   
   * NAT created in public subnet A

   ![snapshot](./screenshots/nat.png)

   * Route table created and private subnet A associated
   * Added route 0.0.0.0/0 -> nat gw

   ![snapshot](./screenshots/private-a-rt.png)

### Part - 2

   * Launched ec2 instance in private A subnet with no public IPV4 address
   * Attached role with required permission policies

   ![snapshot](./screenshots/private-ec2.png)

   ![snapshot](./screenshots/policy.png)

   * Connected through SSM Session Manager

   ![snapshot](./screenshots/ssm.png)

   * curl -I https://aws.amazon.com
   * aws sts get-caller-identity

   ![snapshot](./screenshots/curl.png)
   
### Part - 3
 
   * Launched ec2 in public subnet A with nginx userdata

   ![snapshot](./screenshots/public-ec2.png)

   * Security Group

   ![snapshot](./screenshots/sg.png)

   * Web Page Works

   ![snapshot](./screenshots/web-works.png)

   * Created custom NACL for public sunbnet A with inbound and bound rules
   
   ![snapshot](./screenshots/nacl-inbound.png)

   ![snapshot](./screenshots/nacl-outbound.png)

   * Web page blocked after NACL applied

   ![snapshot](./screenshots/nacl-blocked.png)

   * Worked after NACl allowed port 80

   ![snapshot](./screenshots/nacl-allowed.png)

   ![snapshot](./screenshots/nacl-worked.png)

### Part - 4

   * Create an S3 gateway endpoint

   ![snapshot](./screenshots/s3-gw.png)

   * S3 prefix list route

   ![snapshot](./screenshots/s3-route.png)

   * List s3 buckets - `aws s3api list-buckets`
   
   ![snapshot](./screenshots/s3-ls.png)

### Part - 5

   * Created Interface Endpoint for EC2 with SG allowing TCP 443

   ![snapshot](./screenshots/interface-endpoint.png)

   * Private DNS resolution

   ![snapshot](./screenshots/ns-lookup.png)

   ![snapshot](./screenshots/nic.png)

### Part - 6

   * Created Flow logs for VPC

   ![snapshot](./screenshots/flow-log.png)

   * Flow Logs - Reject Traffic

   ![snapshot](./screenshots/reject.png)

## VPC Resource Map

   ![snapshot](./screenshots/vpc-map.png)

   ![snapshot](./screenshots/vpc-map1.png)

## Architecture Decisions
- Why NAT per AZ?
  
   - Improves high availability by avoiding a single point of failure.
   - Keeps traffic within the same Availability Zone, helping reduce cross-AZ data transfer costs.
   - Ensures private instances in each AZ can continue accessing the internet even if another AZ becomes unavailable.
   - Follows AWS best practices for production workloads.

- Why an S3 Gateway Endpoint?

   - Enables private instances to access Amazon S3 without using the public internet.
   - Reduces NAT Gateway data processing costs by routing S3 traffic through the Gateway Endpoint.
   - Keeps S3 traffic on the AWS network, improving security.
   - Add the endpoint to your route tables, and traffic destined for S3 automatically flows through it.
   - Supports endpoint policies to control access to specific S3 buckets.

- When would you use Transit Gateway instead of Peering?

   - If there are more than 3 vpc, Transit Gateway simplifies management compared to dozens of peering links.
   - Needed when VPC A must talk to VPC C through VPC B — peering doesn’t allow this.

## Where I Got Stuck
"No blocker"

## Cleanup

- Terminate the Day 6 EC2 instances.
- Delete the Interface Endpoint.
- Delete NAT-A and wait for deletion.
- Release the Elastic IP.
- Delete the S3 Gateway Endpoint if not needed.
- Delete the VPC Flow Log.
- Delete the dedicated CloudWatch log group if not needed.
- Delete the custom NACL.
- Remove temporary route tables and Security Groups.


## LinkedIn Posts

https://www.linkedin.com/feed/update/urn:li:ugcPost:7486801204723965953/