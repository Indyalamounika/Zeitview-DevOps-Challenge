 
# Zeitview DevOps Challenge — Repro steps

## Prereqsites
- DockerFile to build images
- k8s cluster creates with terraform
	VPC
	IGW
	Public subnets in us-east-1a and us-east-1b AZ
	Private subnets in us-east-1a and us-east-1b AZ
	Database subnets in us-east-1a and us-east-1b AZ
	Public Route table
	Private Route table
	Database Route table
	EIP for NAT
	NAT Gateway in public subnet 1a az
	IGW route is added to public route table
	NAT gateway route to private and database route tables
	Route table association with subnets
	VPC to default VPC peering
	Public route table to default VPC route
	Default VPC main route table to created VPC route
	Inputs
	vpc_cidr - (Required). User must supply the CIDR for VPC.
	project_name - (Required). User must supply the project nae.
- kubectl to insert the kubernets cluster
- HPA componetes installed with metrics dashboard
- VPA components if you want vertical autoscaling to work


### I have stated the work, but due to office commitments today,I wasn't able to finish it.
	If you can give me some additional time. I will completete the task.


