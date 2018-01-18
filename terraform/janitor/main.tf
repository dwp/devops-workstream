#
# janitor
# Create the VPC to contain our hosts
# See docs/credits.md for contact/support details; coded by Adrian Wilkins
#
# File structure
# * /terraform/janitor
#   * main.tf - main module file
#   * cloudwatch.tf - cloudwatch event set up
# * /lambda/python/
#   * janitor.py - python script to start/stop instances based on tags
#
# Usage
# * Add a janitor-%action% named tag to your instance with a value of the schedule_table entry
#   * %action% can be 'start' or 'stop'
#   * values can be 'morning' or 'evening'
#   * e.g. {Name="janitor-start", Value="morning"}, {Name="janitor-stop", Value="evening"}

provider "aws" {
  region = "${var.aws_region}"
}

variable "schedule_table" {
  type = "map"
  description = "Map of event schedules expressed as crontab entries"
  default = {
    # NB crontab times are in UTC!
    morning = "cron(0 7 ? * MON-SAT *)" # 0700 every weekday
    evening = "cron(0 19 ? * MON-SAT *)" # 1900 every weekday
  }
}

data "archive_file" "janitor" {
  type = "zip"
  # top-level folder contains /terraform (root) and /lambda
  source_file = "${path.root}/../lambda/janitor/janitor.py"
  output_path = "/tmp/janitor.zip"
}

resource "aws_lambda_function" "janitor" {
  description = "Janitor function"
  function_name = "janitor"
  filename = "/tmp/janitor.zip"
  source_code_hash = "${data.archive_file.janitor.output_base64sha256}"
  handler = "janitor.handler"
  role = "${aws_iam_role.janitor.arn}"
  runtime = "python3.6"
  timeout = 30
}

resource "aws_iam_role_policy" "janitor" {
  name = "JanitorPolicy"
  role = "${aws_iam_role.janitor.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "ec2:StartInstances",
                "ec2:StopInstances",
                "ec2:DescribeInstances"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role" "janitor" {
  name = "Janitor"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal": {
              "Service": "lambda.amazonaws.com"
            }
        }
    ]
}
EOF
}
