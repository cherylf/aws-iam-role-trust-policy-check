## Prerequisites

Create a S3 bucket in the *us-east-1* region and upload all files in this folder to your S3 bucket

To upload files to S3 using AWS CLI, run the following command. The dot after <code>cp</code> refers to the current directory and so,
you must run this command in the directory where the files are stored. Otherwise, you must provide the full path to your files.
Also, this command uploads the file to the root of the bucket. To upload the files to a folder in the bucket, 
use <code>s3://mybucketname/foldername</code>

```bash
aws s3 cp . s3://mybucketname --recursive
```

If needed, copy the S3 object URL for the aws-cfn-iam-role-trust-policy-check-function.yml file and paste in
the *TemplateURL* field in the aws-cfn-iam-role-trust-policy-check-main-stack.yml file.

## Deployment

1. Copy the S3 object URL for the aws-cfn-iam-role-trust-policy-check-main-stack.yml
2. In your AWS account, go to the CloudFormation console (us-east-1)
3. Click *Create Stack* and paste the S3 object URL into the *Amazon S3 URL* field
4. Follow the onscreen instructions and choose *Create Stack* to launch the stack