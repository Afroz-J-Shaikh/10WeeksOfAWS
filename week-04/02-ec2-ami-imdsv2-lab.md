# Day 7 Lab - Secure nginx Golden AMI

## Resources

| Resource | Exact name |
|---|---|
| Builder EC2 | `cloudadhar-ec2-ami-builder-01` |
| Security group | `cloudadhar-sg-nginx-public` |
| IAM role | `cloudadhar-role-ec2-ssm` |
| Golden AMI v1 | `cloudadhar-ami-nginx-golden-v1-20260725` |
| Patched AMI v2 | `cloudadhar-ami-nginx-golden-v2-20260725` |
| Test EC2 | `cloudadhar-ec2-ami-test-v2-01` |

Tag resources with `Project=AWS-Zero-to-Hero`,
`Module=EC2 Fundamentals`, `Environment=Training`,
`Owner=CloudAdhar`, `ManagedBy=Manual`,
`CleanupAfter=25 July 2026`, and `DataClassification=Training-Only`.

## Build

1. Create `cloudadhar-role-ec2-ssm` for EC2 and attach
   `AmazonSSMManagedInstanceCore`.
2. Create `cloudadhar-sg-nginx-public`. Prefer HTTP from your public `/32`.
   Do not add public SSH.
3. Launch Amazon Linux 2023 as `cloudadhar-ec2-ami-builder-01`.
4. Attach the SSM role and security group.
5. Set metadata to **V2 only (token required)**.
6. Use this User Data:

```bash
#!/bin/bash
set -euxo pipefail
dnf install -y nginx
systemctl enable --now nginx
cat > /usr/share/nginx/html/index.html <<'HTML'
<h1>CloudAdhar Week 4 Golden AMI</h1>
<p>nginx was installed by EC2 User Data.</p>
HTML
```

## Validate Bootstrap

Connect with Session Manager:

```bash
sudo cloud-init status --wait
sudo systemctl status nginx --no-pager
curl -I http://localhost
sudo tail -n 40 /var/log/cloud-init-output.log
```

## Validate IMDSv2

Tokenless request:

```bash
curl -sS -o /dev/null \
  -w 'IMDSv1 HTTP status: %{http_code}\n' \
  --max-time 3 \
  http://169.254.169.254/latest/meta-data/instance-id
```

Expected: `IMDSv1 HTTP status: 401`.

Token-based requests:

```bash
TOKEN=$(curl -sS -X PUT \
  -H 'X-aws-ec2-metadata-token-ttl-seconds: 21600' \
  http://169.254.169.254/latest/api/token)

curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id

curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/placement/availability-zone

unset TOKEN
```

Do not query or publish role credential endpoints. Mask the dynamic output.

## Patch and Image

Check and apply only the release update tested for class:

```bash
cat /etc/os-release
sudo dnf check-update || test $? -eq 100
sudo dnf upgrade -y
sudo systemctl restart nginx
curl -I http://localhost
sudo dnf clean all
```

Remove secrets, host-specific content, and temporary files. Confirm nginx is
enabled and active. Create
`cloudadhar-ami-nginx-golden-v2-20260725` with reboot enabled and wait for
`Available`.

Launch `cloudadhar-ec2-ami-test-v2-01` from v2 with:

- The SSM role and IMDSv2 required
- No User Data

Validate:

```bash
sudo systemctl is-enabled nginx
sudo systemctl is-active nginx
curl -I http://localhost
cat /etc/os-release
```

Success means nginx starts from the image without User Data.

## Evidence

- Builder role, security group, AMI, and IMDSv2 setting
- nginx and cloud-init success
- Tokenless `401`
- Token-based safe metadata success
- Golden AMI v2 `Available`
- Test instance serving nginx without User Data
