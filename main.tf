data "aws_caller_identity" "current" {}

module "dynamo_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.3"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.name}"
  delimiter  = "${var.delimiter}"
  attributes = "${var.attributes}"
  tags       = "${var.tags}"
}

resource "aws_dynamodb_table" "default" {
  name           = "${module.dynamo_label.id}"
  read_capacity  = "${var.autoscale_min_read_capacity}"
  write_capacity = "${var.autoscale_min_write_capacity}"
  hash_key       = "${var.hash_key}"
  range_key      = "${var.range_key}"

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute {
    name = "${var.hash_key}"
    type = "S"
  }

  attribute {
    name = "${var.range_key}"
    type = "S"
  }

  ttl {
    attribute_name = "${var.ttl_attribute}"
    enabled        = true
  }

  tags = "${module.dynamo_label.tags}"
}

// Autoscaler scales up/down the provisioned ops for DynamoDB table based on the load
resource "aws_iam_role" "autoscaler" {
  name = "${module.dynamo_label.id}-autoscaler"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {"Service": "application-autoscaling.amazonaws.com"},
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "autoscaler_dynamo" {
  name = "${module.dynamo_label.id}-autoscaler-dynamo"
  role = "${aws_iam_role.autoscaler.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:DescribeTable",
                "dynamodb:UpdateTable"
            ],
            "Resource": "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${module.dynamo_label.id}"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "autoscaler_cloudwatch" {
  name = "${module.dynamo_label.id}-autoscaler-cloudwatch"
  role = "${aws_iam_role.autoscaler.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricAlarm",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:DeleteAlarms"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_appautoscaling_target" "read_target" {
  max_capacity       = "${var.autoscale_max_read_capacity}"
  min_capacity       = "${var.autoscale_min_read_capacity}"
  resource_id        = "table/${module.dynamo_label.id}"
  role_arn           = "${aws_iam_role.autoscaler.arn}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "read_policy" {
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.read_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.read_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.read_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.read_target.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = "${var.autoscale_read_target}"
  }
}

resource "aws_appautoscaling_target" "write_target" {
  max_capacity       = "${var.autoscale_max_write_capacity}"
  min_capacity       = "${var.autoscale_min_write_capacity}"
  resource_id        = "table/${module.dynamo_label.id}"
  role_arn           = "${aws_iam_role.autoscaler.arn}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "write_policy" {
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.write_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.write_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.write_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.write_target.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = "${var.autoscale_write_target}"
  }
}
