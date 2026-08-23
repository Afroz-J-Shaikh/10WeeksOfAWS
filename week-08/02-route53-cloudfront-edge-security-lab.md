# Day 15 Lab - Route 53, CloudFront, ACM, and Edge Security

Build this challenge in your own AWS account from a blank starting point. The
instructor may already have a certificate or domain configuration for the live
demonstration; learners must complete the ACM request and DNS validation steps
below themselves.

Use the AWS Management Console for resource creation. CloudShell is used only
for verification and CloudFront URL signing.

## Before You Begin

You need administrative lab permissions and a public domain or delegated
subdomain whose authoritative DNS you can edit. Replace every placeholder;
never copy an instructor's account ID, domain, IP address, distribution ID, or
certificate.

| Placeholder | Your value |
|---|---|
| `<ACCOUNT-ID>` | Current AWS account ID |
| `<ROOT-DOMAIN>` | Domain whose DNS you control |
| `<CDN-NAME>` | For example `cdn.<ROOT-DOMAIN>` |
| `<LAB-ZONE>` | For example `lab.<ROOT-DOMAIN>` |
| `<BUCKET>` | Globally unique Day 15 bucket name |

Regions and scope:

| Resource | Location |
|---|---|
| S3 origin and primary EC2 | Mumbai, `ap-south-1` |
| Secondary EC2 | N. Virginia, `us-east-1` |
| CloudFront viewer certificate | ACM `us-east-1`—required |
| CloudFront, Route 53, health checks | Global |
| CloudFront WAF web ACL | CloudFront scope |

Do not use the root user. Route 53 hosted zones and health checks, EC2, public
IPv4, CloudFront, WAF, and data transfer may generate charges.

## Part A - Request and Validate ACM from Scratch

Do this first because DNS validation can take time.

1. Select **US East (N. Virginia), `us-east-1`**.
2. Open **AWS Certificate Manager → Request a certificate**.
3. Choose **Request a public certificate**.
4. Enter `<CDN-NAME>`, select **DNS validation**, and use RSA 2048.
5. Request the certificate. Its initial status should be **Pending validation**.
6. Open its **Domains** section and copy the exact validation `CNAME` name and
   value.
7. Create that `CNAME` at the authoritative DNS provider:
   - If the domain is hosted in Route 53, use **Create records in Route 53**.
   - Otherwise add the record at your DNS provider. Follow its rules for
     relative versus fully qualified record names so the suffix is not doubled.
8. Confirm publicly that the validation name resolves to the ACM
   `acm-validations.aws` target.
9. Refresh ACM until status is **Issued**. Do not submit duplicate requests
   while validation is pending.
10. Keep the validation `CNAME`; ACM uses it for managed renewal.

Record sanitized proof of the requested name, `us-east-1`, validation method,
and **Issued** status. Do not continue to custom-domain attachment until it is
issued, but the default CloudFront-domain work can proceed while you wait.

The ACM validation record and the later application record are different:

```text
_<random-token>.<CDN-NAME> -> ACM validation target
<CDN-NAME>                 -> CloudFront distribution
```

## Part B - Create Two Regional HTTP Endpoints

Create dedicated Security Groups in each Region named
`cloudadhar-day15-primary-sg` and `cloudadhar-day15-secondary-sg`. Allow HTTP
TCP `80` from `0.0.0.0/0` for public Route 53 health checks. Do not add SSH; use
Session Manager or EC2 Instance Connect with a temporary My-IP rule if needed.

Launch a small Amazon Linux 2023 instance named
`cloudadhar-day15-primary-mumbai` in a public Mumbai subnet. Enable a public
IPv4 only for the lab and use:

```bash
#!/bin/bash
dnf install -y nginx
cat <<'HTML' > /usr/share/nginx/html/index.html
<!doctype html><html><body style="font-family:Arial;text-align:center;padding:80px">
<h1>Primary - Mumbai</h1><p>Day 15 Route 53 endpoint</p>
</body></html>
HTML
systemctl enable --now nginx
```

Repeat in `us-east-1` as `cloudadhar-day15-secondary-virginia`, changing the
page heading to `Secondary - N. Virginia`. Verify `http://<PUBLIC-IP>/` for
both and record the temporary IPs privately.

## Part C - Create the Private S3 Origin

In Mumbai, create `<BUCKET>` with:

- Block all public access enabled;
- Bucket owner enforced;
- versioning enabled; and
- default encryption enabled.

Do not enable S3 static website hosting. You may use the included
[sample origin page](./index.html), or create and upload `index.html`:

```html
<!doctype html>
<html lang="en"><head><meta charset="utf-8"><title>Day 15</title></head>
<body style="font-family:Arial;text-align:center;padding:80px">
  <h1>AWS Day 15</h1>
  <p>Private S3 → CloudFront OAC → ACM → Route 53 → WAF</p>
  <strong>Page Version: 1</strong>
</body></html>
```

Create `private/learner-proof.txt` containing only synthetic text. Confirm its
direct S3 object URL returns `403 AccessDenied`.

## Part D - Create CloudFront with OAC

Create `cloudadhar-day15-edge` with:

| Setting | Value |
|---|---|
| Origin | `<BUCKET>` S3 REST endpoint, not website endpoint |
| Private origin access | Origin Access Control enabled |
| Viewer protocol | Redirect HTTP to HTTPS |
| Methods | `GET`, `HEAD` |
| Cache policy | Managed `CachingOptimized` |
| Compression | Enabled |
| Certificate initially | Default CloudFront certificate |
| Default root object | `index.html` |

Allow CloudFront to update the bucket policy. Inspect it and confirm the
principal is `cloudfront.amazonaws.com`, access is `s3:GetObject`, and the
condition restricts `AWS:SourceArn` to your exact distribution ARN.

Validate:

```text
Direct S3 index URL                         -> 403
https://<DISTRIBUTION-DOMAIN>/              -> Version 1
https://<DISTRIBUTION-DOMAIN>/index.html    -> Version 1
```

## Part E - Prove Cache Behavior

Run twice from a terminal or CloudShell:

```bash
curl -I "https://<DISTRIBUTION-DOMAIN>/index.html"
curl -I "https://<DISTRIBUTION-DOMAIN>/index.html"
```

Record `X-Cache`, `Age`, `Via`, and `X-Amz-Cf-Pop`. A first miss is not
guaranteed if the object is already cached at that edge.

Change the page to `Version: 2` and upload it to the same key. Observe that the
old version may remain cached. Create an invalidation for `/index.html`, wait
for completion, and verify Version 2.

## Part F - Protect a Path with a Signed URL

In CloudShell, create the signing keys:

```bash
openssl genrsa -out cloudfront-private-key.pem 2048
openssl rsa -pubout -in cloudfront-private-key.pem -out cloudfront-public-key.pem
chmod 600 cloudfront-private-key.pem
cat cloudfront-public-key.pem
```

Never display, upload, or commit the private key.

1. In CloudFront, create public key `cloudadhar-day15-public-key` by pasting the
   complete public PEM.
2. Create key group `cloudadhar-day15-key-group` containing that public key.
3. Add behavior `private/*` using the S3 origin, `GET/HEAD`, HTTPS redirect,
   `CachingOptimized`, **Restrict viewer access = Yes**, and the trusted key
   group.
4. Wait for deployment.
5. Open `https://<DISTRIBUTION-DOMAIN>/private/learner-proof.txt` without a
   signature. Expect `403`/`MissingKey`.
6. Record the CloudFront public-key ID and choose an expiry no more than 15
   minutes in the future, in UTC.

```bash
aws cloudfront sign \
  --url "https://<DISTRIBUTION-DOMAIN>/private/learner-proof.txt" \
  --key-pair-id "<PUBLIC-KEY-ID>" \
  --private-key file://cloudfront-private-key.pem \
  --date-less-than "<FUTURE-UTC-TIME>"
```

Open the complete returned URL. Expect `200`. Do not publish the URL. After
expiry, confirm the same URL returns `403`, then securely remove the private
key from CloudShell before cleanup.

## Part G - Attach Your ACM Certificate and DNS Name

After the certificate is **Issued**:

1. Edit the CloudFront distribution.
2. Add alternate domain `<CDN-NAME>`.
3. Select your issued ACM certificate from `us-east-1`.
4. Choose the current recommended TLS 1.2 security policy and deploy.
5. At authoritative DNS, create the separate application record:
   - Route 53: alias `A`/`AAAA` to the CloudFront distribution; or
   - another provider: `CNAME <CDN-NAME> -> <DISTRIBUTION-DOMAIN>`.
6. Keep the random-token validation `CNAME` as well.
7. Verify `https://<CDN-NAME>/` without a certificate warning.

If the certificate is not offered by CloudFront, confirm it is `Issued`, is in
`us-east-1`, and covers the exact alternate name.

## Part H - Create Route 53 Health Checks and Records

Create a public hosted zone for `<LAB-ZONE>` only if it does not exist. If the
parent domain is hosted elsewhere, delegate the subdomain by adding all four
Route 53 `NS` values at the parent. Do not replace the parent domain's name
servers.

Create HTTP health checks on `/`, TCP 80, for both EC2 public IPs:

- `cloudadhar-day15-primary-hc`
- `cloudadhar-day15-secondary-hc`

Wait until both are healthy. Create two weighted `A` records with the same
name `weighted.<LAB-ZONE>`, TTL 30: primary weight 90 and secondary weight 10,
each associated with its health check. Query an authoritative name server:

```bash
for i in {1..20}; do
  dig +short weighted.<LAB-ZONE> @<ROUTE53-NAME-SERVER>
done | sort | uniq -c
```

Weights influence DNS-answer proportions; they do not guarantee an exact
request ratio because resolver caching affects viewers.

Change the weights to `50/50`, repeat the authoritative queries, and compare
the observations. A small sample will not always be exactly proportional.

Create two failover `A` records named `app.<LAB-ZONE>`, TTL 30:

- primary -> Mumbai IP + primary health check;
- secondary -> N. Virginia IP + secondary health check.

Prove the healthy baseline against the authoritative name server. Stop Nginx
on the primary through an approved management path, wait until its health
check is unhealthy, and query again. The answer must change to the secondary.
Restart Nginx, wait for Healthy, and prove failback. DNS TTLs and health-check
thresholds mean the transition is not instantaneous.

## Part I - Test WAF Safely

Use your own current public IPv4 only; keep it out of screenshots.

1. Create a CloudFront-scope IP set `cloudadhar-day15-learner-ip` with your
   address as `/32`.
2. Associate or open the distribution's CloudFront-scope web ACL.
3. Add a custom IP-set rule named `Block-Learner-IP` in **Count** mode.
4. Request the public root page and verify a counted request in sampled
   requests/metrics.
5. Change only this test rule to **Block**, wait for propagation, and verify
   the root returns `403`.
6. Immediately return the rule to Count or delete it and verify access works.

Do not enable Shield Advanced or create Global Accelerator for evidence.

## Validation Checklist

- [ ] ACM certificate was requested by the learner in `us-east-1`
- [ ] ACM validation `CNAME` resolves and certificate is `Issued`
- [ ] Direct S3 access fails and CloudFront OAC access succeeds
- [ ] Cache headers and invalidation behavior are recorded
- [ ] Unsigned private path fails and short-lived signed URL succeeds
- [ ] Custom HTTPS hostname works with the learner's certificate
- [ ] Both Route 53 health checks are healthy at baseline
- [ ] Weighted authoritative queries return both endpoints
- [ ] `90/10` and `50/50` weighted observations are compared
- [ ] Primary failure changes failover answer; recovery produces failback
- [ ] WAF Count and Block are proven and normal access is restored
- [ ] All evidence is sanitized and cleanup is complete

Continue with [Week 8 cleanup](./06-cleanup.md).
