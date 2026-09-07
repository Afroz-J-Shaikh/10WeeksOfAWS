# AWS Zero To Hero - Day 19

## Security, Governance and Observability - Sunday Live Class

**Live class:** Sunday, 6 September 2026, 8:00 P.M. IST  
**Primary Region:** `ap-south-1`  
**Project:** `CloudAdhar`

Use a non-root administrator role protected by MFA. Never place credentials, real secrets, personal data, or account IDs in screenshots or repositories.

## Learning outcomes

- Distinguish CloudWatch metrics and logs from CloudTrail API auditing.
- Explain EventBridge routing, GuardDuty, AWS Config, Security Hub, Macie, Inspector, and X-Ray.
- Choose between Secrets Manager and Parameter Store.
- Explain Cognito User Pools, Google/Gmail federation, and Identity Pools.
- Publish a custom metric and test S3 object activity safely.
- Use Systems Manager Session Manager instead of opening SSH.

## Deploy the CloudFormation demonstration

The stack creates a small Auto Scaling web workload, CloudWatch logs and dashboard, a private retained S3 bucket, CloudTrail management and S3 data events, EventBridge rules, and an SNS alert path.

Use `SlackIntegrationMode = UseExisting` after the manual Amazon Q Developer in chat applications demonstration. Restrict `AllowedHttpCidr` to your own public IP where possible. The EC2 instance uses Systems Manager and does not require inbound SSH.

The data and CloudTrail audit buckets use `DeletionPolicy: Retain`; deleting the stack does not delete those buckets or their contents. Review and remove retained resources after the class.

## Test 1: custom CloudWatch metric

The stack creates an `ApplicationFailuresAlarm`. Publish one datapoint using the stack's `Environment` value:

```bash
aws cloudwatch put-metric-data \
  --region ap-south-1 \
  --namespace CloudAdhar/Day19 \
  --metric-name ApplicationFailures \
  --dimensions Name=Environment,Value=demo \
  --unit Count \
  --value 1
```

Replace `demo` if another environment was selected. After the one-minute period, the alarm should move to `ALARM` and notify the configured SNS/Amazon Q path. Wait for the datapoint to leave the evaluation window; it should return to `OK`.

## Test 2: S3 object activity

Use the `DataBucketName` stack output:

```bash
printf 'day19 learner test\n' > /tmp/day19-test.txt
aws s3 cp /tmp/day19-test.txt s3://<DataBucketName>/learners/day19-test.txt --region ap-south-1
aws s3 rm s3://<DataBucketName>/learners/day19-test.txt --region ap-south-1
```

`S3ObjectActivityRule` reacts quickly to `Object Created` and `Object Deleted`. CloudTrail data events record actor-level calls such as `PutObject`, `GetObject`, and `DeleteObject`, but delivery can take longer and data events can incur charges. Delete all test objects after the demonstration.

## Optional Terraform smoke test

`day19-metrics-s3-test.tf` is intentionally smaller than the CloudFormation stack. It creates only a private S3 bucket, EventBridge-to-CloudWatch logging, and a custom metric alarm with no notification action. It does not create EC2, IAM users, Slack integration, CloudTrail, GuardDuty, or public access.

```bash
terraform init
terraform apply
terraform output -raw test_bucket_name
terraform destroy
```

Publish `CloudAdhar/Day19` with `Environment=terraform-test` to test the Terraform alarm. Remove test objects before `terraform destroy`.

## Cognito with Gmail/Google

Yes. Cognito integrates with Gmail accounts through **Google federation**. Cognito never needs a learner's Gmail password: the browser redirects to Google, Google authenticates the user, and Cognito issues User Pool tokens.

1. Create a Cognito User Pool and browser app client without a client secret.
2. Add a Cognito domain in `ap-south-1`.
3. In Google Cloud Console, create an OAuth 2.0 Web application client.
4. Add this Cognito callback URL to Google:
   `https://<cognito-domain>.auth.ap-south-1.amazoncognito.com/oauth2/idpresponse`
5. Add the Google client ID and secret to Cognito's Google identity provider with `openid`, `email`, and `profile` scopes.
6. In the app client Hosted UI settings, enable Google and add `http://localhost:8080/` as a local callback URL.

A simple sign-in link is:

```text
https://<cognito-domain>.auth.ap-south-1.amazoncognito.com/oauth2/authorize?client_id=<app-client-id>&response_type=code&scope=openid+email+profile&redirect_uri=http%3A%2F%2Flocalhost%3A8080%2F
```

For a sample application, create an `index.html` with a “Sign in with Google” link to that URL and serve it with `python3 -m http.server 8080`. Use the Authorization Code flow with PKCE and a maintained OIDC library such as AWS Amplify for a real application. Do not put a client secret or token exchange logic in the browser.

- **User Pool:** application users, sign-in, JWT tokens, Hosted UI, and social federation.
- **Identity Pool:** exchanges authenticated identities for temporary AWS credentials. It requires an IAM role mapping and least-privilege permissions; Google sign-in alone does not grant AWS API access.

## Cleanup

- Delete test objects from S3.
- Run `terraform destroy` if the smoke test was used.
- Delete the CloudFormation stack.
- Manually review retained data and audit buckets.
- Remove temporary Google OAuth callback URLs and Cognito test users.
