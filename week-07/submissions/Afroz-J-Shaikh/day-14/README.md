# Week 7 - Managed Databases and Caching

## Learner
- Name: Afroz Shaikh
- GitHub: https://github.com/Afroz-J-Shaikh
- LinkedIn: https://www.linkedin.com/in/afroz-j-shaikh/
- Region: Mumbai

## Day 14

- Defined Variables

   ![snapshot](../evidence/day14-database-caching/vars.png)

- Access patterns and key design:

   | Access pattern | Key design |
   |---|---|
   | Customer profile | `PK=CUSTOMER#C101`, `SK=PROFILE` |
   | Customer orders | `PK=CUSTOMER#C101`, `SK=ORDER#time#id` |
   | Order by order ID | `GSI1PK=ORDER#id` |
   | Customer orders by status | Same `PK`, `LSI1SK=STATUS#status#time` |
   | Temporary session | `ExpiresAt` numeric TTL |
   | React to update | Stream with old/new images |


### PART A - BUILD

- Base-table Query result:

   ![snapshot](../evidence/day14-database-caching/table.png)

- Data Inserted

   ![snapshot](../evidence/day14-database-caching/data.png)

### PART A - SHOW THE ACCESS PATTERNS

- Access pattern 1: get the customer profile

   ![snapshot](../evidence/day14-database-caching/pk-sk.png)

- Access pattern 2: list customer orders newest first

   ![snapshot](../evidence/day14-database-caching/cus-or.png)

   ![snapshot](../evidence/day14-database-caching/cus-or1.png)

   ![snapshot](../evidence/day14-database-caching/cus-or2.png)

- Access pattern 3: find O9001 using GSI1

  ![snapshot](../evidence/day14-database-caching/gs.png)

  ![snapshot](../evidence/day14-database-caching/gs1.png)

- Access pattern 4: list OPEN orders using LSI1

  ![snapshot](../evidence/day14-database-caching/lsi.png)

  ![snapshot](../evidence/day14-database-caching/lsi1.png)

- Query versus Scan comparison

   - Scan

      ![snapshot](../evidence/day14-database-caching/scan.png)

      ![snapshot](../evidence/day14-database-caching/scan1.png)

   - Query

      ![snapshot](../evidence/day14-database-caching/query.png)

      ![snapshot](../evidence/day14-database-caching/query1.png)

   - Comparision

      - Query targets a known partition. Scan examines the table or index. A filter on Scan does not avoid the underlying read work.
      - In Scan Consumed Capacity was `CapacityUnits: 0.5`
      - In query Consumed Capacity was `CapacityUnits: 2.0`

### PART C — CAPACITY AND TTL

- Main table's `On-demand` capacity

   ![snapshot](../evidence/day14-database-caching/capacity.png)

   - PAY_PER_REQUEST is the API name for on-demand capacity.
   - It is a good starting point for unknown or variable traffic.
   - The console's Warm throughput values describe immediately supportable throughput readiness; they are not a count of requests currently being consumed.
   - Use the Monitor tab and CloudWatch consumed-capacity/throttling metrics to discuss actual activity.

- `Provisioned` capacity table

   ![snapshot](../evidence/day14-database-caching/provisioned-table.png)

- On-demand versus provisioned decision:

   | On-demand | Provisioned |
   |---|---|
   | Pay per request | Configure RCU/WCU |
   | Unknown/spiky workload | Stable/measurable workload |
   | Minimal planning | Capacity planning and Auto Scaling |

- TTL Enabled

   ![snapshot](../evidence/day14-database-caching/ttl-enabled.png)

- Expiring session

   ![snapshot](../evidence/day14-database-caching/expiry.png)

   ![snapshot](../evidence/day14-database-caching/expiry1.png)

   ![snapshot](../evidence/day14-database-caching/ttl.png)

   - Explain:
      - `ExpiresAt` is a Number containing epoch seconds.
      - TTL cleanup is asynchronous.
      - The item may remain visible after expiry until DynamoDB deletes it.

### PART D — STREAMS AND LAMBDA

- Stream Confirmed

   ![snapshot](../evidence/day14-database-caching/stream.png)

- Lambda Function

   - IAM Role Attach

      ![snapshot](../evidence/day14-database-caching/lambda-role.png)

   - Code

      ![snapshot](../evidence/day14-database-caching/code.png)

   - DynamoDB Trigger

      ![snapshot](../evidence/day14-database-caching/trigger.png)

      ![snapshot](../evidence/day14-database-caching/trigger1.png)

- Follow Lambda logs

   ![snapshot](../evidence/day14-database-caching/logs.png)

- Update the status and LSI sort key

   ![snapshot](../evidence/day14-database-caching/update.png)

- Stream and Lambda old/new image result:

   - DynamoDB current item

      ![snapshot](../evidence/day14-database-caching/shipped.png)

      > The item explorer shows the current version. It no longer shows PAID as the current status.

   - Index Maintenance

      - Indexes `GSI1` and `LSI1`

         ![snapshot](../evidence/day14-database-caching/indexes.png)

      - Query LSI1 again with the `STATUS#SHIPPED#` prefix to prove that changing LSI1SK changed the indexed access path.

         ![snapshot](../evidence/day14-database-caching/lsi-shipped.png)

   - Stream Configuration

      ![snapshot](../evidence/day14-database-caching/stream-config.png)

   - Event delivery

      ![snapshot](../evidence/day14-database-caching/trigger-result.png)

   - Old and new values

      ![snapshot](../evidence/day14-database-caching/old-image.png)

      ![snapshot](../evidence/day14-database-caching/new-image.png)

   - Monitoring

      ![snapshot](../evidence/day14-database-caching/lambda-monitor.png) 

      > Monitoring shows aggregated request, latency, throttling and error behavior—not complete item values.
   
### PART E — TEMPORARY UI DEMO

- Lambda UI function created

   ![snapshot](../evidence/day14-database-caching/lambda-ui.png)

- Temporary Function URL

   ![snapshot](../evidence/day14-database-caching/func-url.png)

- UI access paths

   - Base table query

      ![snapshot](../evidence/day14-database-caching/all-orders.png)

   - LSI query

      ![snapshot](../evidence/day14-database-caching/lsi1-ui.png)

   - GSI query

      ![snapshot](../evidence/day14-database-caching/gsi1-ui.png)

   - Status update

      ![snapshot](../evidence/day14-database-caching/update-ui.png)

      - Cloud Watch Logs (Old/New)

         ![snapshot](../evidence/day14-database-caching/old-img-ui.png)

         ![snapshot](../evidence/day14-database-caching/new-img-ui.png)

### Complete UI-to-Stream demonstration

1. Show Status=PAID in DynamoDB item explorer.

   ![snapshot](../evidence/day14-database-caching/status-paid.png)

2. In the UI, change PAID → SHIPPED.

   ![snapshot](../evidence/day14-database-caching/ui-status-shipped.png)

3. Refresh item explorer and show Status=SHIPPED.

   ![snapshot](../evidence/day14-database-caching/item-status-shipped.png)

4. Show LSI1SK changed to STATUS#SHIPPED#...

   ![snapshot](../evidence/day14-database-caching/item-lsi1-status-shipped.png)

5. Show the CloudWatch log with oldImage=PAID.

   ![snapshot](../evidence/day14-database-caching/log-old-image-ui.png)

6. Show the CloudWatch log with newImage=SHIPPED.

   ![snapshot](../evidence/day14-database-caching/log-new-image-ui.png)

7. Filter SHIPPED orders in the UI to invoke LSI1.

   ![snapshot](../evidence/day14-database-caching/shipped-ui-lsi1.png)

8. Search O9001 in the UI to invoke GSI1.

   ![snapshot](../evidence/day14-database-caching/shipped-ui-gsi1.png)

9. Lambda Logs

   ![snapshot](../evidence/day14-database-caching/log-trail.png)

### PART F — GLOBAL TABLES, DAX AND ELASTICACHE

- Global Tables

   ![snapshot](../evidence/day14-database-caching/rep-dis.png)

   - The table currently has one region, as the replication is disabled.

   1. Multi-Region availability -
     Global Tables replicate your table across multiple Regions (e.g., ap-south-1(Mumbai replica) + ap-southeast-1(Singapore replica)). If a whole Region goes down, the app can fail over to a replica elsewhere — protection beyond just AZ-level failure.

   2. Local access for global users -
     Without replication, all users hit one Region, so distant users pay cross-Region latency on every request. A local replica lets nearby users read/write to a nearby copy, cutting latency significantly.

   3. Multi-Region writes -
     Unlike typical "read replica" setups, Global Tables accept writes in every Region. A user in Mumbai and one in Singapore can both write locally, and DynamoDB propagates changes across all replicas automatically.

   4. Replicated write, storage and data-transfer considerations -
     Every write gets copied to every replica Region — multiplying write-capacity cost (N Regions ≈ N× writes). You also pay storage in each Region plus inter-Region data-transfer fees. A 3-Region table isn't "free" multi-Region — it's roughly 3x cost.

   5. MREC vs MRSC -

     | Mode |	Full name | Behavior |
     |---|---|---|
     | MREC | Multi-Region Eventual Consistency | Default; writes propagate async, replicas may briefly lag |
     | MRSC | Multi-Region Strong Consistency | Newer; strongly consistent cross-Region reads, but doesn't support TTL/LSI — use a separate empty table |

- DAX decision:

   ![snapshot](../evidence/day14-database-caching/dax.png)

   **What DAX is** -
     DAX (DynamoDB Accelerator) is an in-memory cache that sits in front of DynamoDB — purpose-built specifically for DynamoDB, not a general-purpose cache like Redis.

   **Request path** -

   ```
   Application → DAX cache hit  → result (microsecond latency, no DynamoDB call)
   Application → DAX cache miss → DynamoDB → cache the result → return result
   ```

   - On a hit, DAX returns the item directly from memory — no round trip to DynamoDB at all.
   - On a miss, DAX fetches from DynamoDB, stores a copy in its cache, then returns the result. The next request for that same item becomes a hit.

   **When to choose DAX** -
     - `DynamoDB is your underlying database` (DAX only works with DynamoDB — not a general cache).
     - `The same items get read repeatedly` (hot-read pattern) — caching only helps if reads repeat.
     - `Eventual consistency is acceptable` — cached data can be briefly stale after a write, since DAX doesn't guarantee it reflects the very latest write instantly.
     - `You need microsecond-level read latency`, faster than DynamoDB's own millisecond reads.

   **When DAX is the wrong fix** -
     - `Hot partition keys` — DAX caches items, but if your access pattern itself concentrates traffic on one partition key, that's a schema/key-design problem. Caching doesn't fix bad key distribution.
     - `Table scans from missing access patterns` — if you're Scanning because you don't have the right GSI/LSI, DAX won't turn a Scan into a Query. Fix the index design instead.
     - `Write-heavy workloads` — DAX accelerates reads. It doesn't help writes; heavy write traffic still hits DynamoDB directly.
     - `General Redis-style data structures` — if you need sorted sets, pub/sub, or other Redis-specific structures, DAX doesn't provide that.

- Valkey/Redis OSS versus Memcached decision:

   ![snapshot](../evidence/day14-database-caching/valkey.png)

   ![snapshot](../evidence/day14-database-caching/memcached.png)

   ![snapshot](../evidence/day14-database-caching/redis.png)

   | Requirement | Choose |
   |---|---|
   | Leaderboard or sorted sets | Redis OSS/Valkey |
   | Sessions | Redis OSS/Valkey |
   | Counters or rate limiting | Redis OSS/Valkey |
   | Pub/sub | Redis OSS/Valkey |
   | Simple disposable object cache | Memcached |
   | DynamoDB-native read acceleration | DAX |

   > DAX is specialized for DynamoDB. Redis OSS/Valkey provides richer cache data structures and messaging features. Memcached is a simpler distributed object cache.

### PART G — TROUBLESHOOTING

   **NO BLOCKER**

### PART H — CLEANUP

- Lambda Functions

   ![snapshot](../evidence/cleanup/functions.png)

- DynamoDB tables

   ![snapshot](../evidence/cleanup/tables.png)

- Verification

   ![snapshot](../evidence/cleanup/cli.png)

- Cloud Watch Logs

   ![snapshot](../evidence/cleanup/cloudwatch.png)

- IAM Roles

   ![snapshot](../evidence/cleanup/roles.png)

## Architecture Decision
Write 250-400 words.

