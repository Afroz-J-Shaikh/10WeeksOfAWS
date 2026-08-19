# Week 7 - Managed Databases and Caching

## Learner
- Name: Afroz Shaikh
- GitHub: https://github.com/Afroz-J-Shaikh
- LinkedIn: https://www.linkedin.com/in/afroz-j-shaikh/
- Region: Mumbai

## Day 13

- EC2 Database Client

   ![snapshot](./evidence/day13-rds-aurora/ec2-running.png)

- Engine and compatibility decision:

   - The **MySQL Community** engine and version **8.4.10** were selected. This version is confirmed to be under RDS standard support (not flagged for Extended Support), so no additional Extended Support charges apply.

   ![snapshot](./evidence/day13-rds-aurora/config.png)

- Source RDS deployment and security:

   ![snapshot](./evidence/day13-rds-aurora/db.png)

   ![snapshot](./evidence/day13-rds-aurora/db-sg.png)

- Connected DB through EC2

   ![snapshot](./evidence/day13-rds-aurora/connect.png)

- TLS and synthetic-data result:

   ![snapshot](./evidence/day13-rds-aurora/data.png)

   ![snapshot](./evidence/day13-rds-aurora/data1.png)

- Manual snapshot and automated backup result:

   - Manual Snapshot

      ![snapshot](./evidence/day13-rds-aurora/snap-manual.png)

   - Automated Snapshot

      ![snapshot](./evidence/day13-rds-aurora/snap-auto.png)

   - Verify the training table's engine

      ![snapshot](./evidence/day13-rds-aurora/running-engine.png)

- PITR marker window and restore result:

   - Adding record

      ![snapshot](./evidence/day13-rds-aurora/pitr-before-del.png)

   - Deleting record after 2 minutes

      ![snapshot](./evidence/day13-rds-aurora/pitr-after-del.png)

   - PITR created new database and deleted record `PITR Marker` is recovered

      ![snapshot](./evidence/day13-rds-aurora/pitr-created.png)

   - Source still has no record of `PITR Marker`

      ![snapshot](./evidence/day13-rds-aurora/pitr-src.png)

- Read replica and read-only validation:

   - Created Read Replica

      ![snapshot](./evidence/day13-rds-aurora/rep-av.png)

   - Added new record in source db

      ![snapshot](./evidence/day13-rds-aurora/new-rec-src.png)

   - Recorded visible in replica db

      ![snapshot](./evidence/day13-rds-aurora/rep-sync.png)

      ![snapshot](./evidence/day13-rds-aurora/rep1.png)

      ![snapshot](./evidence/day13-rds-aurora/rep2.png)

   - Write fails in replica db

      ![snapshot](./evidence/day13-rds-aurora/rep-fail.png)

- Multi-AZ decision:
 
   ![snapshot](./evidence/day13-rds-aurora/av-du.png)

- Aurora Serverless v2 writer and reader validation:

   - Aurora Database Created

      ![snapshot](./evidence/day13-rds-aurora/aurora.png)

   - Aurora Cluster, Reader Innstance, Writer Instance

      ![snapshot](./evidence/day13-rds-aurora/aurora-all.png)

   - Writer and Reader instance endpoints

      ![snapshot](./evidence/day13-rds-aurora/aurora-endpoints.png)

  - Validate Aurora Writer

     ![snapshot](./evidence/day13-rds-aurora/writer.png)

     ![snapshot](./evidence/day13-rds-aurora/writer1.png)

  - Validate Aurora Reader

     ![snapshot](./evidence/day13-rds-aurora/reader.png)

- Aurora cross-AZ failover result:

   - Writer instance before failover

      ![snapshot](./evidence/day13-rds-aurora/w-before-fail.png)

   - Writer instance after failover

      ![snapshot](./evidence/day13-rds-aurora/writer-cli.png)

      ![snapshot](./evidence/day13-rds-aurora/writer-cli1.png)

   - Reader-Writer instances before fail

      ![snapshot](./evidence/day13-rds-aurora/state-before-fail.png)

   - Reader-Writer instances after fail

      ![snapshot](./evidence/day13-rds-aurora/state-after-fail.png)

- RDS Proxy target health and endpoint validation:

   - Proxy Created

      ![snapshot](./evidence/day13-rds-aurora/proxy.png)

   - Read/Write Endpoints

      ![snapshot](./evidence/day13-rds-aurora/proxy-endpoints.png)

   - Target health

      ![snapshot](./evidence/day13-rds-aurora/proxy-target.png)

- RDS Proxy Read/Write Endpoint

   ![snapshot](./evidence/day13-rds-aurora/proxy-writer-endpoint1.png)

   ![snapshot](./evidence/day13-rds-aurora/proxy-writer-endpoint.png)

- RDS Proxy Read Endpoint

   ![snapshot](./evidence/day13-rds-aurora/proxy-read-endpoint.png)

   ![snapshot](./evidence/day13-rds-aurora/proxy-read-endpoint1.png)

- Automate a Logical Table Backup with Systems Manager

   - Bucket created

      ![snapshot](./evidence/day13-rds-aurora/bucket.png)

   - Dedicated Backup User and Secret Created

      ![snapshot](./evidence/day13-rds-aurora/secret-created.png)

   - System Manager -> Fleet Manager

      ![snapshot](./evidence/day13-rds-aurora/fleet.png)

   - Managed Node Pre-requisite

      ![snapshot](./evidence/day13-rds-aurora/pre-req.png)

   - The SSM Command Document created

      ![snapshot](./evidence/day13-rds-aurora/doc-created.png)

   - SSM table-backup Run Command result:

      - Command Run Result

         ![snapshot](./evidence/day13-rds-aurora/com-suc.png)

      - Verified S3 contains backup

         ![snapshot](./evidence/day13-rds-aurora/s3-backup.png)

      - Validate in EC2

         ![snapshot](./evidence/day13-rds-aurora/ec2-validate.png)

- State Manager schedule and repeated backup result:

   ![snapshot](./evidence/day13-rds-aurora/state-mng.png)

   - New object created in s3

      ![snapshot](./evidence/day13-rds-aurora/s3-2.png)

   - Manually applied association again

      ![snapshot](./evidence/day13-rds-aurora/state-rerun.png)

   - Total Object count - **3**

      ![snapshot](./evidence/day13-rds-aurora/s3-3.png)

   - `gzip -t` succeeds on a downloaded synthetic backup

      ![snapshot](./evidence/day13-rds-aurora/ec2-s3-cp.png)

- Isolated S3 restore and row-validation result:

   - Download the Backup from S3 to EC2

      ![snapshot](./evidence/day13-rds-aurora/ec2-zip.png)

   - Import the Downloaded Backup into MySQL

      ![snapshot](./evidence/day13-rds-aurora/restore.png)

      ![snapshot](./evidence/day13-rds-aurora/restore1.png)

      ![snapshot](./evidence/day13-rds-aurora/restore2.png)

      ![snapshot](./evidence/day13-rds-aurora/restore3.png)

   - Temporary schema and local files are removed

      ![snapshot](./evidence/day13-rds-aurora/restore4.png)

      ![snapshot](./evidence/day13-rds-aurora/restore5.png)

## Day 14
- Access patterns and key design:
- Base-table Query result:
- GSI and LSI validation:
- On-demand versus provisioned decision:
- TTL configuration and expiry explanation:
- Stream and Lambda old/new image result:
- Temporary UI demonstration:
- Global Tables decision:
- DAX decision:
- Valkey/Redis OSS versus Memcached decision:
- Troubleshooting lesson:

## Architecture Decision
Write 250-400 words.

## Cleanup
- RDS source, replica, and restore:

    ![snapshot](./evidence/cleanup/db.png)

- Snapshots and retained backups:

   ![snapshot](./evidence/cleanup/s-snap.png)

   ![snapshot](./evidence/cleanup/m-snap.png)

- Secrets Manager:
 
   ![snapshot](./evidence/cleanup/secret.png)

- EC2 and Security Groups:

   ![snapshot](./evidence/cleanup/ec2.png)

   ![snapshot](./evidence/cleanup/sg.png)

- Aurora Proxy:

   ![snapshot](./evidence/cleanup/proxy.png)

- SSM document, association, S3 backups, and IAM roles:

   ![snapshot](./evidence/cleanup/document.png)

   ![snapshot](./evidence/cleanup/state.png)

   ![snapshot](./evidence/cleanup/s3.png)

   ![snapshot](./evidence/cleanup/iam.png)

- DynamoDB tables and indexes:
- Lambda functions, trigger, Function URL, and log groups:
- Global Tables, DAX, and ElastiCache:
- Regions checked:

## Reflection
1. Why is Multi-AZ different from a read replica?
2. Which recovery option best matches an accidental row deletion, and why?
3. When would you choose Aurora or DMS instead of basic RDS MySQL?
4. Why must a DynamoDB design begin with access patterns?
5. When should you choose a GSI, an LSI, DAX, or ElastiCache?