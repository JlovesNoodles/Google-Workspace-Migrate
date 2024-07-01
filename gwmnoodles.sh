#!bash
#!HomeBrewByChickenNoodles



function reminder(){

echo " "
echo " "
echo " "
echo " ----------------------------------------------------------------"
echo "           HELLO WELCOME TO GWM MIGRATION AUTOMATION             "
echo " ----------------------------------------------------------------"

echo " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "                Before we proceed just a few reminder            "
echo "                                                                 "
echo "     *Remember to have created a project the project name        "
echo "     *Have the service account name ready                        "
echo "     *Enable the API Needed                                      "
echo " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"


echo " ----------------------------------------------------------------"
echo "        If you are ready now do you wanna proceed  Y or N        "
echo " ----------------------------------------------------------------" 
read choices

if [[ $choices == "Y" || $choices == "y" ]]; then


echo " ***************************************************************"
echo "                      AIGHT LETS GO BRUH                        "
echo " ***************************************************************"

sleep 3
	echo -n "STARTING THE PROGRAM PLEASE WAIT " 
	for i in {1..50}; do
	    echo -n "#"
	    sleep 0.1
	done | pv -lep -s 50 > /dev/null
	echo -e "\nProgram has loaded Goodluck Migrating!" 
	echo " "
	echo " "
	echo " "
else 
echo " "
echo "Goodbye Amigo"
exit
fi







}
reminder


function chickengwm(){

echo ""
echo ""
echo "Provide the name for Project Name: "
read projectname
echo "Provide the name for VPC Name: "
read vpcname

echo " "
echo " "
echo " "


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
echo " "
echo " "
echo " "
echo "Provide name for First PRIVATE Subnet"
read firstsubnet
echo " "
echo " "
echo " "
echo "Enter the  IPv4 Range"
read firstipv4range

gcloud compute networks subnets create $firstsubnet --project=$projectname --description=Subnet\ with\ private-facing\ configuration --range=$firstipv4range --stack-type=IPV4_ONLY --network=$vpcname --region=asia-southeast1 --enable-private-ip-google-access


echo " Please Wait Have Patience Please "







#THIS IS FOR THE SECOND PRIVATE SUBNET
echo " "
echo " "
echo " "
echo "Provide name for Second PRIVATE Subnet"
read secondsubnet
echo " "
echo " "
echo " "
echo "Provide the IPv4 Range"
read secondipv4range

gcloud compute networks subnets create $secondsubnet --project=$projectname --description=Subnet\ with\ private-facing\ configuration --range=$secondipv4range --stack-type=IPV4_ONLY --network=$vpcname --region=asia-southeast2 --enable-private-ip-google-access


echo " Please Wait Have Patience Please "







#THIS IS FOR THE FIRST PUBLIC SUBNET
echo " "
echo " "
echo " "
echo "Provide the name for the First PUBLIC Subnet"
read firstpublicsubnet
echo " "
echo " "
echo " "
echo "Provide the IPv4 Range"
read thirdipv4range

gcloud compute networks subnets create $firstpublicsubnet --project=$projectname --description=Subnet\ with\ public-facing\ configuration --range=$thirdipv4range --stack-type=IPV4_ONLY --network=$vpcname --region=asia-southeast1

echo " Please Wait Have Patience Please "







#THIS IS FOR THE SECOND PUBLIC SUBNET
echo " "
echo " "
echo " "

echo "Provide the name for the Second PUBLIC Subnet"
read secondpublicsubnet
echo " "
echo " "
echo " "
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

echo "  -----------------------------  "
echo "  -----------------------------  "
echo " Please Wait Have Patience Please "

gcloud compute --project=$projectname firewall-rules create $vpcname-allow-bidi-ingress --description="bidirectional access" --direction=INGRESS --priority=1000 --network=$vpcname --action=ALLOW --rules=tcp:5131 --source-ranges=$firstipv4range,$secondipv4range,$thirdipv4range,$fourthipv4range

gcloud compute --project=$projectname firewall-rules create $vpcname-allow-bidi-engress --direction=EGRESS --priority=1000 --network=$vpcname --action=ALLOW --rules=tcp:5131 --destination-ranges=$firstipv4range,$secondipv4range,$thirdipv4range,$fourthipv4range


gcloud compute --project=$projectname firewall-rules create $vpcname-vpc-allow-mysql --description="mysqldb access" --direction=INGRESS --priority=1000 --network=$vpcname --action=ALLOW --rules=tcp:3306 --source-ranges=$firstipv4range,$secondipv4range,$thirdipv4range,$fourthipv4range

gcloud compute --project=$projectname firewall-rules create $vpcname-vpc-allow-couchdb --description="couchDB access" --direction=INGRESS --priority=1000 --network=$vpcname --action=ALLOW --rules=tcp:5984 --source-ranges=$firstipv4range,$secondipv4range,$thirdipv4range,$fourthipv4range


gcloud compute --project=$projectname firewall-rules create $vpcname-vpc-allow-apis --description="apis" --direction=INGRESS --priority=1000 --network=$vpcname --action=ALLOW --rules=tcp:443 --source-ranges=$firstipv4range,$secondipv4range,$thirdipv4range,$fourthipv4range

gcloud compute --project=$projectname firewall-rules create $vpcname-vpc-allow-rdp --direction=INGRESS --priority=1000 --network=$vpcname --action=ALLOW --rules=tcp:3389 --source-ranges=$firstipv4range,$secondipv4range,$thirdipv4range,$fourthipv4range

echo " "
echo " "
echo " "

echo "Finished with Firewall"



echo "Creating Now the VM Instance"
echo " Creating the Platform Server"
echo " "
echo " "
echo " "
echo "Provide the name for the server"
echo "  *the name will be GIVENNAME-prod-sea1-vm-platform" 
read platformname


echo " "
echo " "
echo " "
echo "Enter Service Account "
read serviceaccount




#This will Create a VM Platform Server
gcloud compute instances create $platformname-prod-sea1-vm-platform \
    --project=$projectname \
    --zone=asia-southeast1-a \
    --machine-type=e2-standard-4 \
    --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=$firstsubnet \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --service-account=$serviceaccount \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --create-disk=auto-delete=yes,boot=yes,device-name=gmecsample,image=projects/windows-cloud/global/images/windows-server-2019-dc-v20240612,mode=rw,size=50,type=projects/$projectname/zones/asia-southeast1-a/diskTypes/pd-balanced \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-gcp-marketplace=,goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any

echo "  -----------------------------  "
echo "         Platform Finished       " 
echo "  -----------------------------  "




#This will Create a SQL Server
gcloud compute instances create $platformname-prod-sea1-vm-mysqldb \
    --project=$projectname \
    --zone=asia-southeast1-a \
    --machine-type=e2-standard-16 \
    --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=$firstsubnet \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --service-account=$serviceaccount \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --create-disk=auto-delete=yes,boot=yes,device-name=instance-20240701-024701,image=projects/debian-cloud/global/images/debian-12-bookworm-v20240617,mode=rw,size=1000,type=projects/$projectname/zones/asia-southeast1-a/diskTypes/pd-ssd \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any


echo "  -----------------------------  "
echo "        SQL Server Finished      " 
echo "  -----------------------------  "


#This will Create a CouchDB
gcloud compute instances create $platformname-prod-sea1-vm-couchdb \
    --project=$projectname \
    --zone=asia-southeast1-a \
    --machine-type=e2-standard-16 \
    --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=$firstsubnet \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --service-account=$serviceaccount \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --create-disk=auto-delete=yes,boot=yes,device-name=instance-20240701-024701,image=projects/debian-cloud/global/images/debian-12-bookworm-v20240617,mode=rw,size=1000,type=projects/$projectname/zones/asia-southeast1-a/diskTypes/pd-ssd \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any


echo "  -----------------------------  "
echo "      Couch Server Finished      " 
echo "  -----------------------------  "


#This will Create a Node Server
gcloud compute instances create $platformname-prod-sea1-vm-nodeserver01 \
    --project=$projectname \
    --zone=asia-southeast1-a \
    --machine-type=e2-standard-4 \
    --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=$firstsubnet \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --service-account=$serviceaccount \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --create-disk=auto-delete=yes,boot=yes,device-name=windows-server-2019-20240701-025926,image=projects/windows-cloud/global/images/windows-server-2019-dc-v20231213,mode=rw,size=200,type=projects/$projectname/zones/asia-southeast1-a/diskTypes/pd-balanced \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-gcp-marketplace=,goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any



echo "  -----------------------------  "
echo "       Node Server Finished      " 
echo "  -----------------------------  "

}
chickengwm


