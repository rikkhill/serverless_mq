resource "aws_iam_role" "mq_writer" {
  name = "serverless_example_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "s3-access-rw" {
    statement {
        actions = [
            "s3:*",

        ]
        resources = [
            "arn:aws:s3:::*",
        ]
    }
}

resource "aws_iam_policy" "s3-access-rw" {
    name = "s3-access-rw"
    path = "/"
    policy = "${data.aws_iam_policy_document.s3-access-rw.json}"
}

resource "aws_iam_role_policy_attachment" "s3-access-rw" {
    role       = "${aws_iam_role.mq_writer.name}"
    policy_arn = "${aws_iam_policy.s3-access-rw.arn}"
}