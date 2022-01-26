{
    "Statement": [
        {
            "Action": [
                "ecs:CreateCluster",
                "ecs:DeregisterContainerInstance",
                "ecs:DiscoverPollEndpoint",
                "ecs:Poll",
                "ecs:RegisterContainerInstance",
                "ecs:Submit*",
                "ecs:StartTelemetrySession",
                "ecs:UpdateService",
                "ecs:DescribeTaskDefinition",
                "ecs:DescribeServices",
                "ecs:RegisterTaskDefinition",
                "ecr:BatchCheckLayerAvailability",
                "ecr:BatchGetImage",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetAuthorizationToken",
                "ec2:DescribeTags",
                "ec2:DescribeInstances",
                "autoscaling:DescribeTags",
                "autoscaling:DescribeAutoScalingInstances"
            ],
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags",
                "ec2:DeleteTags"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:volume/*",
                "arn:aws:ec2:*:*:instance/*"
            ]
        },
        {
            "Action": [
                "xray:PutTraceSegments",
                "xray:PutTelemetryRecords"
            ],
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        },
        {
            "Action": [
                "cloudwatch:Describe*",
                "cloudwatch:GetMetricData",
                "cloudwatch:PutMetricData",
                "cloudwatch:ListMetrics",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        },
        {
            "Action": [
                "autoscaling:SetInstanceHealth"
            ],
            "Effect": "Allow",
            "Resource": [
                "*"
            ],
            "Condition": {
                "StringEquals": {
                    "autoscaling:ResourceTag/Name": "${asg_name}"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:ListUsers",
                "iam:GetGroup"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:GetSSHPublicKey",
                "iam:ListSSHPublicKeys"
            ],
            "Resource": [
                "arn:aws:iam:::user/*"
            ]
        }
    ],
    "Version": "2012-10-17"
}