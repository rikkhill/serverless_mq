resource "aws_lambda_function" "pacemaker" {
    filename = "../lambdas/pacemaker.zip"
    function_name = "pacemaker"
    handler = "pacemaker.handler"
    runtime = "python3.6"
    role = "${aws_iam_role.mq_writer.arn}"

    environment {
      variables = {
      	bucket_name = "${var.collection_name}-bucket"
      }
    }
}

resource "aws_cloudwatch_event_rule" "every_minute" {
    name = "every-minute"
    description = "Fires every minute"
    schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "check_foo_every_minute" {
    rule = "${aws_cloudwatch_event_rule.every_minute.name}"
    target_id = "pacemaker"
    arn = "${aws_lambda_function.pacemaker.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_pacemaker" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.pacemaker.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.every_minute.arn}"
}