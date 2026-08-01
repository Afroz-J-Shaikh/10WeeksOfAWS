# Week 4 - EC2 Essentials, EBS, and Pricing

## Learner
- Name: Afroz Jameel Shaikh
- GitHub: https://github.com/Afroz-J-Shaikh
- LinkedIn: https://www.linkedin.com/in/afroz-j-shaikh/
- Region: mumbai

## Day 7

### Part 1 - Secure nginx Golden AMI

- Instance selection:
   - **Builder EC2** - cloudadhar-ec2-ami-builder-01
   - **Security group** - cloudadhar-sg-nginx-public
   - **IAM role** -	cloudadhar-role-ec2-ssm

    ![snapshot](./evidence/day7-ec2/builder-ec2.png)

    ![snapshot](./evidence/day7-ec2/sg.png)

    ![snapshot](./evidence/day7-ec2/ec2-role.png)

- Nginx Validation:    

   ![snapshot](./evidence/day7-ec2/nginx.png)

- User Data result:

   ![snapshot](./evidence/day7-ec2/web.png)

- IMDSv1 expected-deny:

   ![snapshot](./evidence/day7-ec2/imds-deny.png)

- IMDSv2 result:

   ![snapshot](./evidence/day7-ec2/imds-token.png)

- Golden AMI validation:

   ![snapshot](./evidence/day7-ec2/ami.png)

- Golden AMI validation on EC2:

   ![snapshot](./evidence/day7-ec2/ami-ec2.png)

- Nginx starts from the image without User Data

   ![snapshot](./evidence/day7-ec2/web-test.png)

- Pricing decisions:

| Choice | Requirement | Reason |
|---|---|---|
| On-Demand | Unknown or short-term usage | Pay per second/hour, no commitment, no discount — highest cost per hour |
| Reserved Instance | Steady matching EC2 usage | Commit to 1 or 3 years for a specific instance family/region for up to ~72% discount; billing discount applies even if the instance is stopped |
| Savings Plans | Steady compute spend with flexibility | Commit to a $/hour spend (not a specific instance), discount auto-applies across instance families, sizes, and even Fargate/Lambda depending on plan type |
| Spot | Fault-tolerant, flexible work | Up to 90% discount, but AWS can reclaim capacity with a 2-minute interruption notice — never use for stateful or time-critical workloads |
| Dedicated Instance | Single-tenant instance requirement | Runs on hardware dedicated to your account, but hardware can still be shared with other instances you own; no visibility into physical server |
| Dedicated Host | Host visibility or server-bound licensing | Physical server fully allocated to you, with visibility into sockets/cores — needed for BYOL scenarios tied to physical cores (e.g., Windows Server, SQL Server licensing) |

### Part 2 - EC2 Image Builder Automation

- Role

   ![snapshot](./evidence/day7-ec2/image-builder-role.png)

- Security Group

   ![snapshot](./evidence/day7-ec2/image-builder-sg.png)

- Nginx Build Component

   ![snapshot](./evidence/day7-ec2/nginx-build.png)

- Nginx Test Component

   ![snapshot](./evidence/day7-ec2/nginx-test.png)

- Image Recipe

   ![snapshot](./evidence/day7-ec2/recipe.png)

- Infrastructure configuration   

   ![snapshot](./evidence/day7-ec2/infra.png)

- Distribution configuration

   ![snapshot](./evidence/day7-ec2/distribution-config.png)

- Create pipeline

   ![snapshot](./evidence/day7-ec2/pipeline.png)

   ![snapshot](./evidence/day7-ec2/pipeline.png)

- Workflow completed   

   ![snapshot](./evidence/day7-ec2/workflow.png)

   - Build Workflow

      ![snapshot](./evidence/day7-ec2/build-workflow.png)

   - Test Workflow

      ![snapshot](./evidence/day7-ec2/test-workflow.png)

- AMI available      

   ![snapshot](./evidence/day7-ec2/ami-available.png)

- Image Builder AMI Validation on Test EC2  

   ![snapshot](./evidence/day7-ec2/ami-instance.png)

   ![snapshot](./evidence/day7-ec2/ami-web.png) 

## Day 8
- Instance and volume AZ:

   ![snapshot](./evidence/day8-storage/ec2-storage.png)

   ![snapshot](./evidence/day8-storage/sg-storage.png)

   ![snapshot](./evidence/day8-storage/root-storage.png)

   ![snapshot](./evidence/day8-storage/root1-storage.png)

- Filesystem and mount:

   - gp3 storage created

   ![snapshot](./evidence/day8-storage/gp3-storage.png)

   - storage attached to instance

   ![snapshot](./evidence/day8-storage/attach-storage.png)

   ![snapshot](./evidence/day8-storage/attach1-storage.png)

   - xfs filesystem mounted

   ![snapshot](./evidence/day8-storage/mount-storage.png)

- Stop/start persistence:

   - Configuring persistent mounting

   ![snapshot](./evidence/day8-storage/configure-persistent-storage.png)

   - Validate

   ![snapshot](./evidence/day8-storage/validate-configure-persistent-storage.png)

   - Data before stopping instance

   ![snapshot](./evidence/day8-storage/proof-storage.png)

   - Stopping instance

   ![snapshot](./evidence/day8-storage/stop-storage.png)

   - Data after starting instance

   ![snapshot](./evidence/day8-storage/valid-storage.png)

- Resize and XFS growth:

   - Modifying storage from 2GB to 4GB

   ![snapshot](./evidence/day8-storage/modify-storage.png)

   - EBS block shows 4GB, filesystem shows 2GB

   ![snapshot](./evidence/day8-storage/beforexfsgrow-storage.png)

   - Grow xfs. filesystem increases

   ![snapshot](./evidence/day8-storage/afterxfsgrow-storage.png)

- Snapshot recovery:

   - Create snapshot

   ![snapshot](./evidence/day8-storage/snapshot.png)

   - Data changed after snapshot created

   ![snapshot](./evidence/day8-storage/change-after-snap.png)

   - Volume created from snapshot

   ![snapshot](./evidence/day8-storage/snap-volume.png)

   - Volume attached to instance

   ![snapshot](./evidence/day8-storage/snap-vol-attach.png)

   ![snapshot](./evidence/day8-storage/snap-vol-attach1.png)

   - Mount filesystem

   ![snapshot](./evidence/day8-storage/mount-snap-vol.png)

- Cross-Region encrypted copy:

   - Snapshot copy created in sydney region

   ![snapshot](./evidence/day8-storage/sydney-snap.png)

   - The Sydney copied snapshot is encrypted 

- DLM policy or review:

   ![snapshot](./evidence/day8-storage/vol-policy.png)

- Fast Snapshot Restore

   - Fast Snapshot Restore (FSR) is tied  to a single snapshot and a single Availability Zone (AZ).
   - FSR configuration: When you enable FSR, any EBS volumes you create from it in that AZ are immediately performant (no lazy loading).
   - Snapshot copy behavior: If you copy a snapshot (to another region, account, or even within the same region), the copied snapshot does not inherit the FSR settings.

   ![snapshot](./evidence/day8-storage/fsr.png)

- io2 Multi Attach

   - Created volume of io2 type and attached to 2 instances 

   ![snapshot](./evidence/day8-storage/io2.png)

   - Working on multiple instances

   ![snapshot](./evidence/day8-storage/io2-1.png)

   ![snapshot](./evidence/day8-storage/io2-2.png)

   - io2 Multi-Attach volumes let multiple EC2 instances access the same EBS volume at once, but safe production use requires strict coordination:

       - Cluster-aware application: The app must be designed to run across multiple nodes and handle shared storage safely.

      - Clustered filesystem: Use a multi-node filesystem (like Oracle ASM or GFS2), not single-host ones like ext4/XFS.

      - Coordinated writes: Nodes must synchronize I/O so data isn’t corrupted.

      - I/O fencing: Failed or misbehaving nodes must be blocked from writing to protect data integrity.

- Placement Groups

   - Created 3 placement groups

   ![snapshot](./evidence/day8-storage/pg.png)

   ![snapshot](./evidence/day8-storage/pg1.png)

- EFS clients and shared-file proof:

   - EFS security group

   ![snapshot](./evidence/day8-storage/efs-sg.png)

   - Create efs

   ![snapshot](./evidence/day8-storage/efs.png)

   - Mount efs and write from ec2 client 1

   ![snapshot](./evidence/day8-storage/efs-client1.png)

   - Mount efs and read & write from ec2 client 2

   ![snapshot](./evidence/day8-storage/efs-client2.png)

   ![snapshot](./evidence/day8-storage/efs-c22.png)

   - Reading from client 1, written by client 2

   ![snapshot](./evidence/day8-storage/efs-c11.png)

   - Reading from both client simultaneously

   ![snapshot](./evidence/day8-storage/efs-same1.png)  ![snapshot](./evidence/day8-storage/efs-same2.png)

- Persistent EFS mounting

   ![snapshot](./evidence/day8-storage/efs-unmount-c1.png)

   ![snapshot](./evidence/day8-storage/efs-unmount-c2.png)

   ![snapshot](./evidence/day8-storage/efs-c11.png)

   ![snapshot](./evidence/day8-storage/efs-c22.png)

- Storage decisions :

| Requirement | Best fit | Important boundary |
|---|---|---|
| Boot disk or persistent block device for EC2 | EBS | Volume is scoped to one AZ |
| Shared files for multiple Linux instances | EFS | Uses NFS and VPC mount targets |
| Temporary host-local cache or scratch data | Instance Store | Data can be lost after stop/start or host failure |
| Shared block device for a cluster-aware application | io2 Multi-Attach | Same AZ; application coordinates writes |

- Placement decisions:

| Requirement |	Best fit |	Important boundary |
|---|---|---|
| Low-latency, high-throughput networking between instances (HPC, tightly coupled workloads)|	Cluster placement group |	Single AZ; if a rack fails, all instances can be affected — no isolation |
| Spread critical instances to minimize simultaneous hardware failure	| Spread placement group |	Max 7 instances per group per AZ; each instance on distinct hardware |
| Large distributed workloads needing partial isolation (Hadoop, Cassandra, Kafka)	|Partition placement group |	Instances grouped into partitions (up to 7 per AZ) on separate racks; partition failure isolated from others |

## Architecture Decision

### Day 7 - Pipeline Architecture

  ![snapshot](./evidence/day7-ec2/pipeline-architecture.png) 

   ### Architecture Overview

   - **Amazon EC2 Image Builder** automates the creation, testing, and distribution of versioned Golden AMIs.
   - An **Image Pipeline** orchestrates the entire workflow using an **Image Recipe**, **Infrastructure Configuration**, and **Distribution Configuration**.
   - The **Image Recipe** combines AWS-managed components with custom build and test components to configure and validate the image.
   - A temporary **Build EC2** instance creates the Golden AMI, and a temporary **Test EC2** instance validates the image before publication.
   - **Amazon Inspector** performs vulnerability assessment on the generated AMI to  improve security and compliance.
   - The validated **Private Golden AMI** is distributed and can be shared across **multiple AWS Regions and AWS accounts** using the configured Distribution Configuration.
   - The architecture provides **automated image creation, security validation, versioning, and consistent Golden AMI deployments**.


## Cleanup
- Instances:

   ![snapshot](./evidence/cleanup/ec2.png)

- Volumes:

   ![snapshot](./evidence/cleanup/vol.png)

- EFS:

   ![snapshot](./evidence/cleanup/efs.png)

- AMIs:

   ![snapshot](./evidence/cleanup/ami.png)
   
- Snapshots:

   ![snapshot](./evidence/cleanup/snap.png)

- DLM policies:

   ![snapshot](./evidence/cleanup/dlm.png)

- Placement groups:

   ![snapshot](./evidence/cleanup/pg.png)

- Regions checked:

   ![snapshot](./evidence/cleanup/snap-syd.png)

## Reflection
1. What EC2 decision mattered most?
   - Adding strict security rules.
   - Ataching SSMInstanceCore role.
   - Creating ec2 in same AZ.

2. What makes the formatting step dangerous?
   - Formatting is irreversible, once formatted existing data is gone.
   - Risk of formatting the wrong device or the root volume, especially since Linux device naming (/dev/xvdf vs /dev/nvme1n1) isn't always predictable.

3. What would you automate in production?
   - Automate golden image creation, creating a pipeline that would automatically build, test and validate AMIs.