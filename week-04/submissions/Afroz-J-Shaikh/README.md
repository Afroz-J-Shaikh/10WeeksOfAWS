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
- Filesystem and mount:
- Stop/start persistence:
- Resize and XFS growth:
- Snapshot recovery:
- Cross-Region encrypted copy:
- DLM policy or review:
- EFS clients and shared-file proof:
- Storage decisions:
- Placement decisions:

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
- Volumes:
- EFS:
- AMIs:
- Snapshots:
- DLM policies:
- Fast Snapshot Restore:
- Placement groups:
- Regions checked:

## Reflection
1. What EC2 decision mattered most?
2. What makes the formatting step dangerous?
3. What would you automate in production?