terraform {
    required_version = "~>1.3.1"
    
    required_providers {
        aws = {
            source: "hashicorp/aws"
            version: "~>4.6"
        }
    }
}

variable "aws_region" {
    type = string
    default = "us-east-1"
}

provider "aws" {
    region = var.aws_region
}

data "archive_file" "myzip" {
    type = "zip"
    source_file = "main.py"
    output_path = "main.zip"
}

resource "aws_lambda_function" "python_lambda" {
    filename = "main.zip"
    function_name = "python_lambda_test"
    role = aws_iam_role.python_lambda_role.arn
    handler = "main.lamdba_handler"
    runtime = "python3.8"
    source_code_hash = "data.archive_file.myzip.output.basg64sha256"
}

resource "aws_iam_role" "python_lambda_role" {
    name = "python_lambda_role"

    assume_role_policy = <<EOF
{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": "sts:AssumeRole",
                "Principal": {
                    "Service": "lambda.amazomaws.com"
                },
                "Effect": "Allow",
                "Sid": ""
        }

    ]
}
EOF
}

// SOS Queue

