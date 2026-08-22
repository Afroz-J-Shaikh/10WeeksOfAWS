## Reflection

1. Why is Multi-AZ different from a read replica?

Multi-AZ is a synchronous standby for availability, not scale. Writes go to the primary, and RDS synchronously replicates to the standby in another AZ before the write is acknowledged. The standby isn't queryable — you can't send read traffic to it. It exists purely so that on primary failure, RDS can automatic-failover the DNS endpoint to the standby with minimal downtime.

A read replica is asynchronous and built for read scaling. It lags behind the primary by some replication delay, but you can query it directly — you point read-heavy traffic at its own endpoint. Promoting a read replica to standalone is a manual action, not an automatic failover.

2. Which recovery option best matches an accidental row deletion, and why?

Point-in-time recovery (PITR), not a snapshot restore in the naive sense. A row deletion happened at a specific timestamp, and PITR replays transaction logs up to just before that timestamp — giving you the database state one second before the bad DELETE ran, without losing every other write that happened after your last daily snapshot.

3. When would you choose Aurora or DMS instead of basic RDS MySQL?

Aurora — when you need higher throughput (Aurora's storage layer decouples compute from a distributed, self-healing storage volume), faster read replica lag, near-instant failover, or you want Aurora-specific features like Global Database, up to 15 read replicas, or Serverless v2 for spiky workloads. It's still MySQL/PostgreSQL-wire-compatible, so app code doesn't change — you're paying more for a materially better storage engine.

DMS (Database Migration Service) — You reach for DMS when migrating an existing database — on-prem, EC2-hosted, or a different engine entirely — into RDS/Aurora with minimal downtime, using its continuous replication (CDC) to keep source and target in sync until cutover. You'd also use it for heterogeneous migrations (e.g. Oracle → Aurora PostgreSQL) paired with the Schema Conversion Tool.

4. Why must a DynamoDB design begin with access patterns?

Because DynamoDB has no query planner and no cheap ad-hoc joins — unlike RDS, you can't just add an index later and run a new WHERE clause efficiently. Every access pattern you'll ever need (get order by ID, list orders by customer, list orders by status) has to be baked into your key structure — PK, SK, GSI, LSI — before you write data, because:
Queries only work efficiently against the exact key structure they were designed for; anything else means a full table scan.

5. When should you choose a GSI, an LSI, DAX, or ElastiCache?

| Need | Choice	| Why |
|---|---|---|
| Query by a different attribute than your table's PK	| GSI | New, independent partition key (+ optional sort key); has its own throughput/capacity; eventually consistent by default. |
| Alternate sort order within the same partition key | LSI | Same PK as the base table, different sort key; supports strongly consistent reads; but must be created at table creation time and is capped at 10GB per partition — inflexible after the fact. |
| Microsecond-latency reads on a DynamoDB table under heavy, repeated read load	| DAX | In-memory cache sitting in front of DynamoDB, API-compatible with the DynamoDB SDK, write-through — good for read-heavy, cache-friendly access patterns on DynamoDB specifically. |
| General-purpose caching, session store, or leaderboard-style data structures, independent of DynamoDB	| ElastiCache (Redis/Valkey/Memcached) | Used to cache query results from any data source (RDS, API calls, computed values), or for pub/sub, rate limiting, sorted sets for leaderboards, etc. Broader tool, more ops responsibility than DAX. |

