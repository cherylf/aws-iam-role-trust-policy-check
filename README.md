# AWS IAM Role Trust Policy Check

## Architecture


## Deployment

The solution must be deployed in the **us-east-1** region because the Eventbridge rule pattern for IAM events only works in the us-east-1 region.
You also must have an AWS CloudTrail trail in the us-east-1 region for this solution to work. 

Three different ways to deploy the solution and the lessons learnt from each deployment method
1. AWS CloudFormation
    - How to deploy a Lambda function using a deployment package stored in a S3 bucket
    - How to use nested stacks
2. AWS Serverless Application Model (SAM)
3. Terraform