import json
import boto3
import re

def lambda_handler(event, context):
    data = event['detail']['requestParameters']
    if (data == None):
        print('User did not manage to create role')
    else:
        role_name = event['detail']['requestParameters']['roleName']
        iam_client = boto3.client('iam')
        iam_role = iam_client.get_role(RoleName=role_name)['Role']
        
        # Retrieve ID of the account in which the function is running
        this_account_id = context.invoked_function_arn.split(':')[4]
        
        # Expected AWS and Service Principals i.e., whitelisting
        expected_awsPrincipals = [this_account_id]
        expected_servicePrincipals = ['lambda']
        
        # Permission boundary (Pb) policy to be attached to the non-compliant role
        # Make sure the policy exists in the account where the Lambda function is running
        Pb_policy = 'arn:aws:iam::aws:policy/job-function/ViewOnlyAccess'
        
        # Check the principal in the role's trust policy
        assume_role_policy = iam_role['AssumeRolePolicyDocument']
        assume_role_principal = assume_role_policy['Statement'][0]['Principal']
        if ('AWS' in assume_role_principal):
            if type(assume_role_principal['AWS']) is list:
                awsPrincipals = assume_role_principal['AWS']
            else:
                # If there is only one AWS principal in the role's trust policy, 
                # AWS returns a string instead of a list. Hence, we need to cast
                # string to list.
                awsPrincipals = [assume_role_principal['AWS']]
                
            # Check that the account numbers are in the approved list
            # If the account numbers are not in the approved list, attach that Pb_policy
            for principal in awsPrincipals:
                # AWS principal is typically in the format of arn:aws:iam::${Account_Id}:user/*
                # so we will take the first occurrence of the account id in the AWS principal string
                account_id = re.search(r'[0-9]{12}', principal).group()
                if account_id not in expected_awsPrincipals:
                    iam_client.put_role_permissions_boundary(RoleName=role_name, PermissionsBoundary=Pb_policy)
        else:
            # Define the regex pattern to find. Service principals are usually in the format of
            # <service-name>.amazonaws.com. We don't want .amazonaws.com so we are looking for 
            # everything before the first period. 
            find = re.compile(r"^[^.]*")
            if type(assume_role_principal['Service']) is list:
                servicePrincipals = assume_role_principal['Service']
            else:
                servicePrincipals = [assume_role_principal['Service']]
            
            for principal in servicePrincipals:
                # group() returns the whole match pattern
                service = re.search(find, principal).group()
                if service not in expected_servicePrincipals:
                    iam_client.put_role_permissions_boundary(RoleName=role_name, PermissionsBoundary=Pb_policy)