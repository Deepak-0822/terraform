1. What is AWS Identity and Access Management (IAM)?
IAM is AWS's system for controlling who can do what in your AWS account.

What: A free service to manage users, groups, roles, and permissions.

Why: You don’t want everyone to have full access. IAM keeps things secure.

Use case: Only let developers access EC2, while admins access billing and S3.

2. How does IAM work and what can I do with it?
IAM works by:

Creating users (people or services)

Defining roles (identities with specific permissions)

Applying policies (rules that allow/deny actions)

You can:

Restrict access to services (like S3, EC2)

Enable temporary access using IAM roles

Enforce MFA, IP-based access

3. What are least-privilege permissions?
Least privilege means giving only the permissions needed to do a job—no more.

Why: Prevent accidental or malicious changes.

Use case: Give a developer permission to s3:GetObject, not full access to delete buckets.

4. What are IAM policies?
IAM policies are JSON documents that define permissions.

What they do: Allow or deny actions on resources

Attached to: Users, roles, or groups

Example:

json
Copy code
{
  "Effect": "Allow",
  "Action": "s3:ListBucket",
  "Resource": "arn:aws:s3:::my-bucket"
}
5. Why should I use IAM roles?
Roles are temporary permission sets, great for services and cross-account access.

Why: Better than sharing credentials.

Use case: EC2 instance assumes a role to access S3; no need to hard-code credentials.

6. How to create policies using AWS CLI?
bash
Copy code
aws iam create-policy \
  --policy-name MyEC2Policy \
  --policy-document file://ec2-policy.json
Where ec2-policy.json is your JSON file with the policy definition.

7. What types of IAM policies?
Identity-based policies – Attached to users, roles, or groups

Resource-based policies – Attached directly to resources (e.g., S3 buckets)

Permission boundaries – Limit max permissions a role/user can have

Session policies – Temporary session-based permissions

Service control policies (SCPs) – Org-level restrictions via AWS Organizations

8. IAM Best Practices
Use least privilege

Enable MFA for all users

Use IAM roles instead of long-term credentials

Rotate credentials regularly

Monitor changes using CloudTrail

Don’t use the root account for day-to-day tasks

9. Which policy is attached to a role to perform ECS task?
To run ECS tasks, attach the AmazonECSTaskExecutionRolePolicy to the role.

Use case: Lets ECS tasks pull images from ECR, write logs to CloudWatch.

10. How to assign User/Admin IAM policy for ECS management?
Use these managed policies:

Developer-level ECS access:

AmazonECSReadOnlyAccess

Admin-level ECS access:

AmazonECS_FullAccess

Optional: Combine with AmazonEC2FullAccess if tasks run on EC2

11. IAM policies to manage EKS?
To fully manage EKS:

AmazonEKSClusterPolicy

AmazonEKSServicePolicy

AmazonEKSVPCResourceController

AmazonEKSWorkerNodePolicy (for nodes)

AmazonEKS_CNI_Policy (for networking)

IAM role for service accounts (IRSA) — for in-cluster pods needing AWS access

12. What is the use of iam:PassRole permission?
iam:PassRole lets a user/service assign a role to another AWS service.

Why: Without it, even admins can't attach roles to services.

Use case: User wants to launch an EC2 instance using a role; they need iam:PassRole.

13. What is a Trust Policy?
A trust policy defines who can assume a role.

Use case: Allow EC2 to assume a role, or allow a user in another AWS account to do so.

Example:

json
Copy code
{
  "Effect": "Allow",
  "Principal": {"Service": "ec2.amazonaws.com"},
  "Action": "sts:AssumeRole"
}
14. Can you restrict IAM user access by IP address?
Yes — use condition block in the policy:

json
Copy code
"Condition": {
  "IpAddress": {
    "aws:SourceIp": "203.0.113.0/24"
  }
}
Use case: Allow access only from your corporate network.

15. How to audit IAM changes?
Enable CloudTrail to log all IAM changes (user creation, policy attachment)

Use AWS Config to track IAM resource history

Run IAM Access Analyzer for permissions insights

16. Restrict IAM role to S3 only if MFA is enabled + from specific VPC
Use condition blocks with aws:MultiFactorAuthPresent and aws:SourceVpc:

json
Copy code
"Condition": {
  "Bool": {"aws:MultiFactorAuthPresent": "true"},
  "StringEquals": {"aws:SourceVpc": "vpc-0123456789abcdef0"}
}
17. IAM roles typically used for common AWS services:
Service	IAM Role Example	Purpose
S3	S3AccessRole	Read/write S3 buckets
ECS	ecsTaskExecutionRole	Pull ECR images, write logs
EKS	EKSNodeRole, IRSA Role	Node permissions, pod permissions
Lambda	LambdaExecutionRole	Access to other AWS services (e.g. S3, DynamoDB)
ALB (via Target Groups)	ALBControllerRole	For AWS Load Balancer Controller to manage ingress
EC2	EC2InstanceRole	Attach permissions to instances (e.g., access S3, send logs to CloudWatch)# terraform
