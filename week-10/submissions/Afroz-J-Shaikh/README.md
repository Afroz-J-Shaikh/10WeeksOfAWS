# Week 10 - Serverless, Workflows, and Infrastructure as Code

## Learner
- Name: Afroz Shaikh
- GitHub: https://github.com/Afroz-J-Shaikh
- LinkedIn: https://www.linkedin.com/in/afroz-j-shaikh/
- Region: ap-south-1 (Mumbai)

## Lambda
- Function name and runtime:

   ![snapshot](./evidence/lambda/lambda.png)

   ![snapshot](./evidence/lambda/runtime.png)

- Accepted invocation result:

   ![snapshot](./evidence/lambda/accepted.png)

- Business rejection result:

   ![snapshot](./evidence/lambda/rejected.png)

- Technical failure result:

   ![snapshot](./evidence/lambda/deliberate.png)

- Invocation model comparison:
- Concurrency and cold-start lesson:
- VPC decision:

## Async Failure Handling
- SQS destination:

   ![snapshot](./evidence/lambda/dest.png)

- Maximum event age and retry attempts:

   ![snapshot](./evidence/lambda/config.png)

- Destination record fields:

   ![snapshot](./evidence/lambda/sqs-msg.png)

- Approximate invoke count:
- Destination versus DLQ explanation:

## API Gateway
- API type and reason:

   ![snapshot](./evidence/api-gateway/http-api.png)

- Route:

   ![snapshot](./evidence/api-gateway/route.png)

- Accepted request status:

```txt
API_URL="https://kbdi3jnymd.execute-api.ap-south-1.amazonaws.com"

curl -i -X POST "${API_URL}/orders" \
-H "content-type: application/json" \
-d '{"orderId":"O-API-1801","amount":3500}'
```

   ![snapshot](./evidence/api-gateway/post-acc.png)

- Rejected request status:

```txt
curl -i -X POST "${API_URL}/orders" \
-H "content-type: application/json" \
-d '{"orderId":"O-API-1802","amount":0}'
```

   ![snapshot](./evidence/api-gateway/post-rej.png)

- Authentication, throttling, logging, and CORS decisions:

## Step Functions
- Workflow type:

   ![snapshot](./evidence/step-functions/step-func.png)

   ![snapshot](./evidence/step-functions/func.png)

- Accepted path:

   ![snapshot](./evidence/step-functions/acc-input.png)

   ![snapshot](./evidence/step-functions/acc.png)

   ![snapshot](./evidence/step-functions/acc1.png)

- Business rejection path:

   ![snapshot](./evidence/step-functions/rej-input.png)

   ![snapshot](./evidence/step-functions/rej.png)

   ![snapshot](./evidence/step-functions/rej.png)

- Technical failure retry and Catch path:

   ![snapshot](./evidence/step-functions/fail-input.png)

   ![snapshot](./evidence/step-functions/fail.png)

   ![snapshot](./evidence/step-functions/fail1.png)

- Standard versus Express decision:
- Idempotency design:

## CloudFormation
- Stack name and parameters:

   ![snapshot](./evidence/cloudformation/stack.png)

   ![snapshot](./evidence/cloudformation/para.png)

- Stack outputs:

   ![snapshot](./evidence/cloudformation/outputs1.png)

   ![snapshot](./evidence/cloudformation/outputs2.png)

- Change set preview:

   ![snapshot](./evidence/cloudformation/cs.png)

- Update result and replacement behavior:

   - Before ChangeSet Apply

   ![snapshot](./evidence/cloudformation/before-cs.png)

   - After ChangeSet Apply

   ![snapshot](./evidence/cloudformation/after-cs.png)

- Drift creation and detection:

   - Changed SG inbound rule to only `MY_IP`

   ![snapshot](./evidence/cloudformation/sg.png)

   - Drift Detected

   ![snapshot](./evidence/cloudformation/drift.png)

   ![snapshot](./evidence/cloudformation/drift1.png)

- Drift reconciliation:

   ![snapshot](./evidence/cloudformation/updated.png)

   ![snapshot](./evidence/cloudformation/in-sync.png)

- S3 Retention and Replacement Behavior:

   * Reviewed the deletion and replacement behavior of the retained S3 archive bucket managed through the CloudFormation lifecycle template.

   * Deleted the stack and verified the bucket (cf-templates-1k6tmp4xd31be-ap-south-1) survived deletion due to `DeletionPolicy: Retain` and `UpdateReplacePolicy: Retain`.

   ![snapshot](./evidence/cloudformation/s3.png)

## End to End Order Application

   ![snapshot](./evidence/app/app.png)

   - Accepted Order

   ![snapshot](./evidence/app/cmpleted.png)

   ![snapshot](./evidence/app/cmpleted-graph.png)

   ![snapshot](./evidence/app/cmpleted-table.png)

   - Business-Rejected Order

   ![snapshot](./evidence/app/rejected.png)

   ![snapshot](./evidence/app/rejected-graph.png)

   ![snapshot](./evidence/app/rejected-table.png)

   - Technical-Failure Order

   ![snapshot](./evidence/app/failed.png)

   ![snapshot](./evidence/app/failed-graph.png)

   ![snapshot](./evidence/app/failed-table.png)


## Architecture Decision
Write 250-400 words.

## Cleanup
- APIs, state machines, Lambda functions, SQS:

   ![snapshot](./evidence/cleanup/sm.png)

   ![snapshot](./evidence/cleanup/api.png)

   ![snapshot](./evidence/cleanup/lambda.png)

   ![snapshot](./evidence/cleanup/sqs.png)

- CloudFormation stack:

   ![snapshot](./evidence/cleanup/stack.png)

- Retained S3 bucket and versions:

   ![snapshot](./evidence/cleanup/s3.png)

- DynamoDB:

   ![snapshot](./evidence/cleanup/table.png)

- EC2 and security group:

   ![snapshot](./evidence/cleanup/ec2.png)

   ![snapshot](./evidence/cleanup/sg.png)

- IAM roles and policies:

   ![snapshot](./evidence/cleanup/roles.png)

- CloudWatch logs and alarms:

   ![snapshot](./evidence/cleanup/cw.png)

## Reflection
1. Who owns retries for synchronous, asynchronous, and event source mapping Lambda?
2. When is HTTP API better than REST API?
3. Why choose Standard rather than Express Step Functions for an order workflow?
4. Why is a Lambda public subnet not enough for internet access?
5. What does a change set show, and what can it not guarantee?
6. How does drift happen and how should it be reconciled?
7. What is the difference between DeletionPolicy and UpdateReplacePolicy?
8. Why must Lambda tasks be idempotent?