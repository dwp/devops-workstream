# The janitor is powered by Cloudwatch events

resource "aws_cloudwatch_event_rule" "janitor" {
  count = "${length(var.schedule_table)}"
  name = "janitor-event-${element(keys(var.schedule_table), count.index)}"
  schedule_expression = "${element(values(var.schedule_table), count.index)}"
}

resource "aws_lambda_permission" "janitor" {
  count = "${length(var.schedule_table)}"
  statement_id = "AllowJanitorExecution-${element(keys(var.schedule_table), count.index)}"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.janitor.function_name}"
  principal = "events.amazonaws.com"
  source_arn = "${element(aws_cloudwatch_event_rule.janitor.*.arn, count.index)}"
}

resource "aws_cloudwatch_event_target" "janitor" {
  count = "${length(var.schedule_table)}"
  rule = "${element(aws_cloudwatch_event_rule.janitor.*.name, count.index)}"
  arn = "${aws_lambda_function.janitor.arn}"
  input = <<EOF
{
  "scheduleEvent": "${element(keys(var.schedule_table), count.index)}"
}
EOF
}
