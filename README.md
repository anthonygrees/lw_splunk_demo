# Splunk Demo for Lacework SplunkBase App
   
### About  
This repo creates a Splunk Enterprise demo environment on AWS, installs the Lacework app / add-on and then creates data.  
  
The following Lacework apps are installed from SplunkBase:  
- [SplunkBase Lacework App](https://splunkbase.splunk.com/app/5591/)  
- [SplunkBase Add-on for Splunk](https://splunkbase.splunk.com/app/5701/)  
- [SplunkBase Lacework Events Add-on](https://splunkbase.splunk.com/app/5073/)  
  
To set up Alerts, you will need to configure the Splunk HEC and Lacework Alert Channel:  
- [Setup Lacework Alerts to Splunk](https://support.lacework.com/hc/en-us/articles/360007889274-Splunk)
  
Additional documentation:  
- [Documentation - Set up the Splunk HEC](https://docs.splunk.com/Documentation/Splunk/8.2.0/Data/UsetheHTTPEventCollector)  
-  [Documentation - Send Lacework Events to Splunk](https://support.lacework.com/hc/en-us/articles/360007889274-Splunk)  
  
### What you need to run the Terraform
You will need the following:  
 - AWS access  
 - A `pem` key in the AWS IAM  - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html
 - Terraform installed  
 - AWS CLI  - https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html
 - A code editor like VS Code  
  
Here is a script to set up you laptop using `Brew` - https://github.com/anthonygrees/laptop_setup
  
### Setup the Terraform
First you need the code !  
  
```bash
git clone https://github.com/anthonygrees/lw_splunk_demo

cd lw_splunk_demo
cd terraform
```
  
Next, create yourself a `terraform.tfvars` file with the following:  
 - node_counter: Is the number of demo VM's you need   
 - splunk_password: Is the password to set on Splunk `admin` account  
  
Here is an example `tfvars` file:  
```bash
aws_profile = "default"
aws_key_pair_file = "/Users/yourName/.ssh/yourPEMfile.pem"
aws_key_pair_name = "yourPEMfile"
aws_availability_zone = "a"
tag_customer = "testing"
tag_project = "project"
tag_name = "name"
tag_dept = "department"
tag_contact = "yourName@splunk.com"
tag_application = "demo"
tag_ttl = "4"
splunk_password = "SetApassword55"
linux_node_instance_type = "t3.large"
```
  
### Initiate your Terraform
Execute the terraform. First run the initialise to ensure the plugins you need are installed:  
  
```bash
terraform init
```
  
Before you run Terraform to create your infrastructure, it's a good idea to see what resources it would create. It also helps you verify that Terraform can connect to your AWS account.  
  
```bash
terraform plan
```
  
### Run your Terraform
  
Now run the apply to create the infrastructure.  
  
```bash
terraform apply -auto-approve
```
  
### Apply Complete !
Once the run is complete you will get a list of the `splunk_server_ip` addresses.  
  
```bash
Apply complete! Resources: 9 added, 0 changed, 0 destroyed.

Outputs:

image_id = ami-091127048df1f044d
route_internet_access_id = rtb-0c8293a365ad2c956
security_group_splunk_id = sg-0a81b14c168fc98fb
security_group_ssh_id = sg-0d6d8b4effe83c007
splunk_server_id = [
  [
    "i-077bc45345e48aca7",
    "i-08f792a8324121942",
  ],
]
splunk_server_public_ip = [
  [
    "52.33.117.188",
    "54.148.76.388",
  ],
]
subnet_private_id = subnet-0132085bfe976b75f
subnet_public_id = subnet-0aefe221eb5ffaf77
vpc_id = vpc-081791ad1bf742a05
```
  
### Access Splunk
You can access Splunk Enterprise using the `splunk_server_public_ip` like this:
  
http://<splunk_server_public_ip>:8000  
  
Username: `admin`  
  
  
### Configure the Lacework App
The [SplunkBase Lacework App](https://splunkbase.splunk.com/app/5591/) is already installed.  Click on the app in Splunk and complete the configuration settings.  
  
This app hits the Lacework API so you will need to download the API key on a `json` format. It will look like this.
```json
{
  "keyId": "EXAMPLE_999HHHH8888SDSDSDS777777DSDSSSD",
  "secret": "_0000000000000000000000000000000000",
  "account": "example.lacework.net"
}
```
  
##### Compliance Screen   
![Lacework Logo](/images/lw_compliance.png)
  
  
##### CVE Screen   
![Lacework Logo](/images/lw_cve.png)
  
  
##### Vulnerability Discovery Screen   
![Lacework Logo](/images/lw_vul.png)
  

### Debug the Lacework Add-on
To find the logs, search in Splunk for the following:
```
index = _internal source=* sourcetype="*lacework*"
```
  