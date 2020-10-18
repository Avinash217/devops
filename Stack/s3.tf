# Create S3 Bucket
resource "aws_s3_bucket" "bucket" {
 bucket = "omramterra"                     # Bucket Name
 acl    = "private"                            #ACL [Access Control]

 tags = {
   Name   = "terra"                     # Tag
 }
}

resource "aws_iam_user" "useriam" {
 name = "omramterra"
}

resource "aws_iam_policy" "policy" {
 name        = "test_policy"
 description = "My-policy"

 policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Sid": "VisualEditor0",
           "Effect": "Allow",
           "Action": [
               "s3:PutObject",
               "s3:GetObject",
               "s3:ListBucket"
           ],
           "Resource": [
               "arn:aws:s3:::omramterra/*",
               "arn:aws:s3:::omramterra"
           ]
       },
       {
           "Sid": "VisualEditor1",
           "Effect": "Allow",
           "Action": [
               "s3:ListAllMyBuckets",
               "s3:HeadBucket"
           ],
           "Resource": "*"
       }
   ]
}
EOF
}

resource "aws_iam_policy_attachment" "test-attach" {
 name       = "test-attachment"
 users      = ["${aws_iam_user.useriam.name}"]
 policy_arn = "${aws_iam_policy.policy.arn}"
}

