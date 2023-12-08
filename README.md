### Getting Started
1. Install Terraform
    - ```brew tap hashicorp/tap```
    - ```brew install hashicorp/tap/terraform```
    - ```terraform -install-autocomplete```

2. Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
    - Setup ```AWS_ACCESS_KEY_ID``` and ```AWS_SECRET_ACCESS_KEY```
3. Create VPC, the only thing important here is CIDR
4. Create an internet gateway, this is required from private subnet.
5. You need to create 4 subnets, 2 private and 2 public on a given availability zone
    - Important tags on private subnet resources required by EKS
        - ```Name```
        - ```kubernetes.io/role/internal-elb```: This is for kubernetes to discover subnets where internal load balancers will be created.
        - ```kubernetes.io/cluster/sample```: This tag indicates the subset ownership. The value equal ```owned``` means the resources are execlusively owned by the cluster and are not shared
    - For public subnet, you need to set the property ```map_public_ip_on_launch``` to ```true`` and the following tags:
        - ```Name```
        - ```kubernetes.io/role/elb```: This tells Kubernetes to create an extrernal load balancers this subnet  
        - ```kubernetes.io/cluster/sample```: Same as above
6. Create NAT Gateway. This is used for providing internet egress to private subnet. This needs an Elastic IP first before you create the terraform resource. Need to associate the NAT gateway to the public subnet that has internet gateway configured.
7. Create route tables
    - One public and one private route table. The public route table will have internet gateway and private route table will have nat gateway.
    - Associate route tables with subnets
8. Now the fun part, creating the EKS
    - Step 1: Create an IAM Role and role policy so that clutser can assume role for service eks.amazonaws.com
    - Step 2: Create a policy attachement with the role created in the previous step
    - Step 3: Create AWS EKS resource with the following
        - Role
        - VPC config with subnets for networking so that EKS cluster can create nodes and load balancer
        - Policy
9. Create IAM role and policies for EC2 nodes and attach the following policies
    - ```AmazonEKSWorkerNodePolicy```: This grant access to EC2 and EKS
    - ```AmazonEKS_CNI_Policy```: For networking
10. Configure managed node groups - AWS will manage the life cycle, auto scaling group uses it to scale the cluster
    - Important component is ```scaling_config```: Define min and max number of nodes
    - ```max_unavailable```: Maximum number of allowed unavailable nodes during upgrade
    - Mind you this configuration is not enough for auto scaling, you need to intall cluster autoscaler
    - You can also create some label and taints if required
11. Create OIDC (OpenID) which will allow IAM permissions for service accounts
    - Get the certificate associated with EKS
    - Create OpenID connect provider
12. Test the provider
    - Create a policy document this role will be associated with EKS service account
    - Create IAM role associated with the policy document
    - Give permissions to do something
    - Create policy attachement
    - Output something to test
13. Perform ```terraform init``` to download the plugins and providers
14. Perform ```terraform apply``` to create the infrastructure

