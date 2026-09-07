terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "Region for the classroom smoke test."
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = "Metric dimension used by the test alarm."
  type        = string
  default     = "terraform-test"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "test" {
  bucket        = "cloudadhar-day19-test-${random_id.suffix.hex}"
  force_destroy = true

  tags = {
    Project     = "CloudAdhar"
    Environment = var.environment
    Purpose     = "Day 19 learner smoke test"
  }
}

resource "aws_s3_bucket_public_access_block" "test" {
  bucket = aws_s3_bucket.test.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "test" {
  bucket = aws_s3_bucket.test.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "test" {
  bucket = aws_s3_bucket.test.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "test" {
  bucket = aws_s3_bucket.test.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_notification" "eventbridge" {
  bucket      = aws_s3_bucket.test.id
  eventbridge = true
}

resource "aws_cloudwatch_log_group" "s3_activity" {
  name              = "/cloudadhar/day19/terraform-s3-activity-${random_id.suffix.hex}"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_resource_policy" "events" {
  policy_name = "cloudadhar-day19-events-${random_id.suffix.hex}"
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "events.amazonaws.com"
      }
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
      ]
      Resource = "${aws_cloudwatch_log_group.s3_activity.arn}:*"
    }]
  })
}

resource "aws_cloudwatch_event_rule" "s3_activity" {
  name        = "cloudadhar-day19-s3-activity-${random_id.suffix.hex}"
  description = "Learner-only S3 object activity smoke test"

  event_pattern = jsonencode({
    source      = ["aws.s3"]
    detail-type = ["Object Created", "Object Deleted"]
    detail = {
      bucket = {
        name = [aws_s3_bucket.test.id]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "s3_activity_log" {
  rule = aws_cloudwatch_event_rule.s3_activity.name
  arn  = aws_cloudwatch_log_group.s3_activity.arn
}

resource "aws_cloudwatch_metric_alarm" "application_failures" {
  alarm_name          = "cloudadhar-day19-terraform-application-failures-${random_id.suffix.hex}"
  alarm_description   = "Learner-triggered custom metric alarm; no notification action is configured."
  namespace           = "CloudAdhar/Day19"
  metric_name         = "ApplicationFailures"
  dimensions          = { Environment = var.environment }
  statistic           = "Sum"
  period              = 60
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"
}

output "test_bucket_name" {
  description = "Private S3 bucket for the object activity test."
  value       = aws_s3_bucket.test.id
}

output "s3_activity_log_group" {
  description = "CloudWatch log group receiving EventBridge object events."
  value       = aws_cloudwatch_log_group.s3_activity.name
}

output "application_failures_alarm" {
  description = "Custom metric alarm name."
  value       = aws_cloudwatch_metric_alarm.application_failures.alarm_name
}
