# Week 9 - Messaging, Streaming, and Event-Driven Architecture

## Learner
- Name: Afroz Shaikh
- GitHub: https://github.com/Afroz-J-Shaikh
- LinkedIn: https://www.linkedin.com/in/afroz-j-shaikh/
- Region: ap-south-1 (Mumbai)

## Day 17 - Amazon SQS

### Standard Queue and DLQ
- Dead-letter queue creation and configuration:

   ![snapshot](./evidence/sqs-standard-visibility-dlq/dlq.png)

- Standard queue creation and DLQ attachment:

   ![snapshot](./evidence/sqs-standard-visibility-dlq/std.png)

   ![snapshot](./evidence/sqs-standard-visibility-dlq/std1.png)

- Visibility timeout test result (message in flight, becomes visible, receive count increases):

   - Message in flight

   ![snapshot](./evidence/sqs-standard-visibility-dlq/in-flight.png)

   - Message becomes visibile after polling first time > ( `recieve count 1` )

   ![snapshot](./evidence/sqs-standard-visibility-dlq/1st-poll.png)

   - After 30 secs visibility timeout

   ![snapshot](./evidence/sqs-standard-visibility-dlq/visibility-timeout.png)

   - Recieve count increases to 3

   ![snapshot](./evidence/sqs-standard-visibility-dlq/count-3.png)

- DLQ population after exceeding max receives:

   - DLQ recieves 1 message

   ![snapshot](./evidence/sqs-standard-visibility-dlq/dlg-msg1.png)

   ![snapshot](./evidence/sqs-standard-visibility-dlq/dlq-1st-poll.png)

   - Standard queue has `0 messages`

   ![snapshot](./evidence/sqs-standard-visibility-dlq/sts-0-msg.png)

- DLQ redrive result (message returned to source):

   - DLQ redrive complete

   ![snapshot](./evidence/sqs-standard-visibility-dlq/redrive.png)

   - Message back to source queue

   ![snapshot](./evidence/sqs-standard-visibility-dlq/back-to-src.png)

   ![snapshot](./evidence/sqs-standard-visibility-dlq/back-to-src1.png)

- Long polling configuration and benefits:
   - Consumer waits up to configured time for a message.
   - If message arrives, returns immediately.
   - If timeout expires, returns empty.
   - Lower API calls = lower cost.

- Poll settings

   ![snapshot](./evidence/sqs-standard-visibility-dlq/poll-settings.png)

   - **Short polling:** Wait time = 0. Checks only some servers and replies instantly, even with an empty result — cheap per call but you often make many empty calls.
   - **Long polling:** Wait time > 0 (up to 30s). Waits and checks all servers until a message arrives or the timer expires — fewer wasted calls, lower cost, lower latency.

### FIFO Queue
- FIFO queue creation with deduplication ID:
 
   ![snapshot](./evidence/sqs-fifo-ordering/fifo.png)

- Sent Payment received and Order shipped using the same Message Group ID (order-O-2001).

   ![snapshot](./evidence/sqs-fifo-ordering/msg-sent.png)

- The first poll received "Payment received" from the FIFO queue. While the message remained in flight, subsequent polling did not release "Order shipped".

   ![snapshot](./evidence/sqs-fifo-ordering/pay-recieve.png)

   ![snapshot](./evidence/sqs-fifo-ordering/again-pay.png)
 
- After the visibility timeout expired, the newly received Payment received message was successfully deleted using its current receipt handle.

   ![snapshot](./evidence/sqs-fifo-ordering/after-visibility-timeout.png)

   ![snapshot](./evidence/sqs-fifo-ordering/delete-msg.png)

- The next poll then released "Order shipped", confirming that FIFO ordering was maintained within the same message group.

   ![snapshot](./evidence/sqs-fifo-ordering/order-shipped.png)

### Priority Queue

   ![snapshot](./evidence/sns-fanout-filtering/priority.png)

## Day 17 - Amazon SNS

### Topic and Subscriptions
- SNS Standard topic creation:

   ![snapshot](./evidence/sns-fanout-filtering/sns-topic.png)

- Two SQS subscriptions (standard and priority queues):

   ![snapshot](./evidence/sns-fanout-filtering/s-sub.png)

   ![snapshot](./evidence/sns-fanout-filtering/p-sub.png)

- Subscription confirmation status:

   ![snapshot](./evidence/sns-fanout-filtering/status.png)
   
### Message Filtering
- Filter policy added to priority queue subscription:

   ![snapshot](./evidence/sns-fanout-filtering/poilcy.png)

- Test 1 result (NORMAL order: standard queue 1, priority queue 0):

   ![snapshot](./evidence/sns-fanout-filtering/std-1.png)

- Test 2 result (HIGH order: standard queue 1, priority queue 1):

   ![snapshot](./evidence/sns-fanout-filtering/high.png)

- SNS envelope structure explanation:

   When you send a message through Amazon SNS, the default JSON payload sent to endpoints (like HTTP/HTTPS or SQS) typically contains these fields: 
   - **Type:** The type of message (e.g., Notification, SubscriptionConfirmation).
   - **MessageId:** A unique universal identifier (UUID) for that specific message.
   - **TopicArn:** The Amazon Resource Name of the SNS topic the message was published to.
   - **Subject:** The subject header included during publishing (if provided).
   - **Message:** The actual content you published, usually formatted as a stringified JSON object.
   - **Timestamp:** The exact date and time when the message was published.
   - **SignatureVersion / Signature / SigningCertURL:** Cryptographic data used to validate the authenticity of the message.

## Day 17 - Amazon EventBridge

### Custom Event Bus
- Custom event bus `cloudadhar-orders-bus-day17` created:

   ![snapshot](./evidence/eventbridge-routing/event-bus.png)

- Event bus configuration (encryption, logging, archiving):

   ![snapshot](./evidence/eventbridge-routing/encryp.png)

   ![snapshot](./evidence/eventbridge-routing/log.png)

   ![snapshot](./evidence/eventbridge-routing/archive.png)

### High-Value Orders Rule
- High-Value Order Rule

   ![snapshot](./evidence/eventbridge-routing/rule.png)

- Event pattern with numeric condition (amount > 5000):

   ![snapshot](./evidence/eventbridge-routing/event-pattern.png)

- Rule target: SQS priority queue:

   ![snapshot](./evidence/eventbridge-routing/target.png)

### Event Testing
- Negative test: amount 2500 (priority queue 0):

   ![snapshot](./evidence/eventbridge-routing/neg-test.png)

   ![snapshot](./evidence/eventbridge-routing/not-recieved.png)

- Positive test: amount 7500 (priority queue 1):

   ![snapshot](./evidence/eventbridge-routing/pos-test.png)

   ![snapshot](./evidence/eventbridge-routing/recieved.png)

   ![snapshot](./evidence/eventbridge-routing/msg.png)

## Day 17 - EventBridge Scheduler

### One-Time Payment Reminder
- Schedule name and date/time (5-10 minutes in future):

   ![snapshot](./evidence/scheduler-reminder/scheduler.png)

- Target: SQS SendMessage to priority queue and Payload:

   ![snapshot](./evidence/scheduler-reminder/target.png)

- Execution result (message arrived at scheduled time):

   ![snapshot](./evidence/scheduler-reminder/priority.png)

   ![snapshot](./evidence/scheduler-reminder/body.png)

- Schedule status after completion (automatically deleted):

   ![snapshot](./evidence/scheduler-reminder/delete.png)

- Difference between Scheduler DLQ and SQS DLQ:

   - The Scheduler DLQ would capture a failure to invoke the target. 
   - The SQS source-queue DLQ demonstrated earlier captures repeated consumer-processing failures. 
   They solve different problems.

## Day 17 - Kinesis and Firehose

### Kinesis Data Stream
- Stream name `cloudadhar-clickstream-day17` `Capacity mode: On-demand`

   ![snapshot](./evidence/kinesis-firehose-s3/stream.png)

- Record production (put-record with partition key `customer-C101`):

   ![snapshot](./evidence/kinesis-firehose-s3/put-record.png)

- Data viewer result (both records on same shard, increasing sequence numbers):

   ![snapshot](./evidence/kinesis-firehose-s3/view-data.png)

- Partition key distribution explanation:

   - Both records should be on the same shard because they use the same partition key. They have increasing sequence numbers. Ordering is guaranteed within a shard, not across an entire multi-shard stream.

### Firehose Delivery Stream
- FireHose 
   
   ![snapshot](./evidence/kinesis-firehose-s3/firehose.png)

- Source: Kinesis data stream:

   ![snapshot](./evidence/kinesis-firehose-s3/firehose-src.png)

- Destination: S3 bucket:

   ![snapshot](./evidence/kinesis-firehose-s3/firehose-dest.png)

- Buffer size: 5 MiB, Buffer interval: 300 seconds, Compression: Uncompressed:

   ![snapshot](./evidence/kinesis-firehose-s3/firehose-buffer.png)


### S3 Delivery Validation
- S3 bucket creation and encryption (SSE-S3):

   ![snapshot](./evidence/kinesis-firehose-s3/s3.png)

   ![snapshot](./evidence/kinesis-firehose-s3/sse-s3.png)

- CloudShell `put-record` commands with new partition key:

   ![snapshot](./evidence/kinesis-firehose-s3/new-put-record.png)

- S3 object listing after buffer interval:

   ![snapshot](./evidence/kinesis-firehose-s3/s3-ls.png)

   ![snapshot](./evidence/kinesis-firehose-s3/new-record.png)

- S3 object path structure (YYYY/MM/dd/HH):

> s3://cloudadhar-day17-streaming-879158037164-ap-south-1-an`/2026/09/04/16/`cloudadhar-clickstream-firehose-day17-1-2026-09-04-16-19-16-9ec67c3c-7cc6-4067-a578-8694ddf11a03

- Object content inspection (JSON records):

   ![snapshot](./evidence/kinesis-firehose-s3/s3-cp.png)

- UTC versus IST time explanation:

## Day 17 - Service Selection

### Amazon MQ Walkthrough
- Engines inspected (RabbitMQ, ActiveMQ):
- Configuration options reviewed:
- Use case: When existing application depends on RabbitMQ or ActiveMQ:  

### Amazon MSK Walkthrough
- Provisioned and Serverless options inspected:
- Kafka versions and topics reviewed:
- Use case: When applications require Kafka consumer groups and offsets:

## Architecture Decision
Write 250-400 words covering:

- **SQS versus SNS:** When to choose queue versus topic pub/sub.
- **Visibility timeout:** Why it must be longer than processing time; recovery after failure.
- **FIFO ordering:** Trade-off between ordering guarantee and throughput (300 vs 1000s per second).
- **Dead-letter queues:** Why retention is 14 days for DLQ versus 4 days for source.
- **SNS filter policies:** How to reduce message volume versus routing all to queue.
- **EventBridge patterns:** Content-based routing advantage over SNS attribute filtering.
- **Scheduler versus Cron:** Replacement of cron jobs and automatic cleanup of one-time schedules.
- **Kinesis partitioning:** Why customer ID as partition key distributes records across shards.
- **Firehose buffering:** Trade-off between 5 MiB / 300 seconds and real-time ingestion.
- **Idempotent consumers:** How to handle duplicate messages safely.
- **Cost estimation:** SQS API calls, SNS deliveries, EventBridge invocations, Kinesis shards, Firehose GB, S3 storage.

## Cleanup Verification
- Firehose stream deleted:

   ![snapshot](./evidence/cleanup/firehose.png)

- Kinesis stream deleted:

   ![snapshot](./evidence/cleanup/kinesis.png)

- S3 bucket emptied and deleted:

   ![snapshot](./evidence/cleanup/s3.png)

- EventBridge rule deleted:

   ![snapshot](./evidence/cleanup/rules.png)

- Custom event bus deleted:

   ![snapshot](./evidence/cleanup/event-bus.png)

- Scheduler schedule automatically removed:

   ![snapshot](./evidence/cleanup/schedule.png)

- SNS topic and subscriptions deleted:

   ![snapshot](./evidence/cleanup/topic.png)

   ![snapshot](./evidence/cleanup/subscription.png)

- All four SQS queues purged and deleted:

   ![snapshot](./evidence/cleanup/queue.png)

- Execution roles cleaned up:

   ![snapshot](./evidence/cleanup/roles.png)

## Reflection
1. Why must SQS visibility timeout be longer than the expected processing time?

   - When a consumer receives a message, SQS doesn't delete it — it just hides it from other consumers for the visibility timeout window. If that window is shorter than how long processing actually takes, the message becomes visible again while it's still being worked on, so a second consumer picks it up and processes it too. That's duplicate processing.

2. What is the difference between SQS Standard queue and SQS FIFO queue?

| **Standard Queue** | **FIFO Queue** |
|---|---|
| Best-effort FIFO ordering (not guaranteed) | Strict FIFO ordering (messages processed in order) |
| At-least-once delivery (duplicates possible) | Exactly-once processing (with deduplication)|
| Nearly unlimited throughput (1000s per second) | Lower throughput (300 per second without batching, 3000 with batching) |
| Use for: Most applications where order doesn't matter | Use for: Order-critical workflows (payment processing, inventory updates) |

3. When would you use SNS filter policy versus EventBridge pattern matching?

   - **SNS Filter Policy:** Best for low-latency, high-volume pub/sub fanout on a single topic, filtering strictly by header attributes (metadata key-value pairs) to keep costs low and throughput high.

   - **EventBridge Pattern Matching:** Best for complex event-driven routing across microservices, AWS services, and SaaS apps, filtering by the full JSON body content (nested fields, numeric ranges, wildcards) with built-in features like event replay and payload transformation.

4. How does EventBridge Scheduler automatically delete one-time schedules?

   - When you create a schedule with an `at()` expression (a single fixed time) instead of a `rate()/cron()` expression, you can set `ActionAfterCompletion` to `DELETE`. Once the schedule fires and its target invocation completes, EventBridge Scheduler automatically deletes the schedule resource itself

5. Why is the partition key important for Kinesis record distribution?

   - Kinesis uses the partition key to hash records into shards. If your partition key has low cardinality (e.g., a constant, or a boolean), all records land in the same shard, creating a hot shard — you lose parallelism and can hit throughput limits even though other shards sit idle. A well-distributed key (e.g., customer ID or order ID) spreads records evenly across shards, letting you actually use the parallel read/write capacity you're paying for.

6. How does Firehose buffering affect S3 delivery latency and cost?

   - Firehose buffers incoming records and flushes to S3 based on whichever threshold hits first: `buffer size (MB)` or `buffer interval (seconds)`. 
   - A short interval (e.g., 60s) means near-real-time delivery but produces many small S3 objects — more PUT requests, more files to manage. 
   - A longer interval or larger buffer size batches more data per file, reducing S3 request costs and improving downstream read efficiency, at the cost of higher end-to-end latency.

7. What makes a consumer idempotent, and why is it critical?

   - An idempotent consumer produces the same end result no matter how many times it processes the same message — usually by checking a unique identifier (order ID, message ID) against a store (DynamoDB, a processed-IDs table) before acting, or by using conditional writes/upserts instead of blind inserts. 
   - This matters because SQS Standard queues, retries, and DLQ redrives all mean a message can be delivered more than once. Without idempotency, a duplicate delivery might double-ship an order, double-charge a customer, or double-decrement inventory.

8. How would you monitor queue depth, message age, and DLQ messages in CloudWatch?

   - **Queue depth:** `ApproximateNumberOfMessagesVisible` — alarm if it climbs steadily, meaning consumers can't keep up.
   - **Message age:** `ApproximateAgeOfOldestMessage` — a more direct signal of processing lag than depth alone; alarm if it exceeds your SLA.
   - **DLQ messages:** `ApproximateNumberOfMessagesVisible` on the DLQ itself — any non-zero value usually deserves an alarm, since DLQ messages mean something failed after all retries.

9. What is the difference between SQS DLQ and EventBridge Scheduler DLQ?

   - An `SQS DLQ` catches messages that a consumer repeatedly failed to process from a source queue, after exceeding maxReceiveCount — it's about consumption failures. 
   - An `EventBridge Scheduler DLQ` catches failures to invoke the target when a schedule fires — it's about invocation failures, not message consumption.
   - They protect different stages of the pipeline: one guards "did the worker succeed," the other guards "did the trigger even reach its target."

10. How would you scale this architecture to handle millions of orders per day?

## Troubleshooting Lessons
Document any issues you encountered:
- Problem:
- Root cause:
- Resolution:
- Prevention for next time: