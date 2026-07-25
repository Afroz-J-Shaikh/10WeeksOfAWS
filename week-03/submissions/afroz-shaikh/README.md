# Week 3 - Amazon VPC

## Name
froz Shaikh

## Architecture

   * WS tTw-Tier

   ![snapshot](./diagrams/week-03-vpc-two-az.png)

## CIDR Plan
List the VPC and four subnet CIDRs. Calculate total and usable addresses.

## Public vs Private
Complete: A subnet is public when...

## Day 5 Result
Explain the VPC, subnet, IGW, and route-table validation.

## Day 6 Result
Explain NAT egress, SG/NACL behavior, endpoints, and Flow Logs evidence.

## Architecture Decisions
- Why NAT per AZ?
- Why an S3 Gateway Endpoint?
- When would you use Transit Gateway instead of Peering?

## Where I Got Stuck
Write one problem and how you investigated it, or write "No blocker".

## Cleanup
List the resources you deleted.

## LinkedIn Posts
- Day 5: URL
- Day 6: URL


## Required Written Work

- CIDR table for all four `/24` subnets
- NAT Gateway versus NAT Instance comparison
- Security Group versus NACL comparison
- Gateway versus Interface Endpoint comparison
- VPC Peering versus Transit Gateway decision table
- One packet example explaining an ephemeral NACL return port
