## Prerequisites

Create a S3 bucket in the **us-east-1** region and upload all files in this folder to your S3 bucket

To upload files to S3 using AWS CLI, run the following command. The dot after `cp` refers to the current directory and so,
you must run this command in the directory where the files are stored. Otherwise, you must provide the full path to your files.
Also, this command uploads the file to the root of the bucket. To upload the files to a folder in the bucket, 
use `s3://mybucketname/foldername`

```bash
aws s3 cp . s3://mybucketname --recursive
```

If needed, copy the S3 object URL for the aws-cfn-iam-role-trust-policy-check-function.yml file and paste in
the **TemplateURL** field in the aws-cfn-iam-role-trust-policy-check-main-stack.yml file.


## Deployment

```bash
cd terraform-example
terraform init
terraform plan
terraform apply
```