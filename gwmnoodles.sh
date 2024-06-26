#!bash
#!HomeBrewByChickenNoodles


function createvpc(){

echo ""
echo ""
echo "Provide the name for Project Name: "
read projectname
echo "Provide the name for VPC Name: "
read vpcname




echo $projectname
echo $vpcname
gcloud compute networks create $vpcname --project=$projectname --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional


echo "Finished with VPC"
echo " "
echo " "
echo " "
echo " "
echo " Now Creating Subnets" 



#THIS IS FOR THE SECOND FIRST  PRIVATE SUBNET

echo "Provide name for First PRIVATE Subnet"
read firstsubnet

echo "Enter the  IPv4 Range"
read firstipv4range

gcloud compute networks subnets create $firstsubnet --project=$projectname --description=Subnet\ with\ private-facing\ configuration --range=$firstipv4range --stack-type=IPV4_ONLY --network=$vpcname --region=asia-southeast1 --enable-private-ip-google-access


echo " Please Wait Have Patience Please "







#THIS IS FOR THE SECOND PRIVATE SUBNET
echo "Provide name for Second PRIVATE Subnet"
read secondsubnet

echo "Provide the IPv4 Range"
read secondipv4range

gcloud compute networks subnets create $secondsubnet --project=$projectname --description=Subnet\ with\ private-facing\ configuration --range=$secondipv4range --stack-type=IPV4_ONLY --network=$vpcname --region=asia-southeast2 --enable-private-ip-google-access


echo " Please Wait Have Patience Please "







#THIS IS FOR THE FIRST PUBLIC SUBNET

echo "Provide the name for the First PUBLIC Subnet"
read firstpublicsubnet

echo "Provide the IPv4 Range"
read thirdipv4range

gcloud compute networks subnets create $firstpublicsubnet --project=$projectname --description=Subnet\ with\ public-facing\ configuration --range=$thirdipv4range --stack-type=IPV4_ONLY --network=$vpcname --region=asia-southeast1

echo " Please Wait Have Patience Please "







#THIS IS FOR THE SECOND PUBLIC SUBNET


echo "Provide the name for the Second PUBLIC Subnet"
read secondpublicsubnet

echo "Provide the IPv4 Range"
read fourthipv4range

gcloud compute networks subnets create $secondpublicsubnet --project=$projectname --description=Subnet\ with\ public-facing\ configuration --range=$fourthipv4range --stack-type=IPV4_ONLY --network=$vpcname --region=asia-southeast2




echo " Please Wait Have Patience Please "
echo " "
echo " "
echo " "
echo "Finished with the subnets"



echo " "
echo " "
echo " "
echo "Now Configuring Firewall Rules"

echo " "
echo " "
echo " "
echo "Provide the Firewall Rule name"
read firewallrulename

echo " Please Wait Have Patience Please "

gcloud compute --project=$firewallrulename firewall-rules create $vpcname-allow-bidi-ingress --description="bidirectional access" --direction=INGRESS --priority=1000 --network=$vpcname --action=ALLOW --rules=tcp:5131 --source-ranges=$firstipv4range,$secondipv4range,$thirdipv4range,$fourthipv4range

gcloud compute --project=$firewallrulename firewall-rules create $vpcname-allow-bidi-engress --direction=EGRESS --priority=1000 --network=$vpcname --action=ALLOW --rules=tcp:5131 --destination-ranges=$firstipv4range,$secondipv4range,$thirdipv4range,$fourthipv4range


gcloud compute --project=$firewallrulename firewall-rules create $vpcname-vpc-allow-mysql --description="mysqldb access" --direction=INGRESS --priority=1000 --network=g$vpcname --action=ALLOW --rules=tcp:3306 --source-ranges=$firstipv4range,$secondipv4range,$thirdipv4range,$fourthipv4range

gcloud compute --project=$firewallrulename firewall-rules create $vpcname-vpc-allow-couchdb --description="couchDB access" --direction=INGRESS --priority=1000 --network=$vpcname --action=ALLOW --rules=tcp:5984 --source-ranges=$firstipv4range,$secondipv4range,$thirdipv4range,$fourthipv4range


gcloud compute --project=$firewallrulename firewall-rules create $vpcname-vpc-allow-apis --description="apis" --direction=INGRESS --priority=1000 --network=$vpcname --action=ALLOW --rules=tcp:443 --source-ranges=$firstipv4range,$secondipv4range,$thirdipv4range,$fourthipv4range

gcloud compute --project=$firewallrulename firewall-rules create $vpcname-vpc-allow-rdp --direction=INGRESS --priority=1000 --network=$vpcname --action=ALLOW --rules=tcp:3389 --source-ranges=$firstipv4range,$secondipv4range,$thirdipv4range,$fourthipv4range


echo "Finished with Firewall"






}
createvpc


