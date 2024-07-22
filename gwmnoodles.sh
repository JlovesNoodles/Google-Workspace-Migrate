#!bash
#!HomeBrewByChickenNoodles



function reminder(){


echo " "
echo " "
echo " "
echo " ----------------------------------------------------------------"
echo "           HELLO WELCOME TO GWM MIGRATION AUTOMATION             " | lolcat
echo " ----------------------------------------------------------------"

cowsay -c dragon -t "This is a Proud ChickenNoodles Creation Recipe!!!" | lolcat

echo " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "                Before we proceed just a few reminder            " | lolcat
echo "                                                                 "
echo "     *Must already have a project created under your organization"
echo "     *Remember the Project name                                  "
echo "     *Have the service account name ready (compute engine)       "
echo "     *Enabled the API Needed                                     "
echo "     *This automation will ask for 2 Private and 2 Public        "
echo "     Subnets, be sure to have it ready before hand               "
echo "     *This is a straight forward automation, if you messed up    "
echo "     something you have to delete, and start again from top.     "
echo "     Though we recommend to use 172.16.252.0/24 for first Subnet "
echo "     *I'll put looping on the next update. Just bit busy now.    "
echo " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo " "
cowsay -c miki -t "PLEASE READ CAREFULLY AND DONT PROCEED WITH DOUBT"


echo " ----------------------------------------------------------------"
echo "        If you are ready now do you wanna proceed  Y or N        " | lolcat
echo " ----------------------------------------------------------------" 
read choices

#!/bin/bash

while true; do

    if [[ $choices == "Y" || $choices == "y" ]]; then

        echo " ***************************************************************"
        echo "                      AIGHT LETS GO BRUH                        " | lolcat
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

    elif [[ $choices == "N" || $choices == "n" ]]; then

        echo " "
        cowsay -c ghostbusters -t "Bruh, Why You Even Here?"  | lolcat
        exit
        break

    else
        cowsay -c trex -t "Bruh Only Y and N are accepted come on now." | lolcat
        continue

    fi
done

}
reminder




function chickengwm(){

echo ""
echo ""

echo " -----------------------------------"
echo " Provide the name for Project Name: " | lolcat
echo " -----------------------------------"
read projectname


echo " -----------------------------------"
echo "    Provide the name for VPC Name:  " | lolcat
echo " -----------------------------------"
read vpcname

echo " "
echo " "
echo " "

:'
echo $projectname
echo $vpcname
'


echo " ---------------------------------"
echo "      Creating the VPC Now        " | lolcat
echo " Please Wait Have Patience Please " | lolcat
echo "----------------------------------"

gcloud compute networks create $vpcname --project=$projectname --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional

echo "----------------------------------"
echo "         Finished the VPC         " | lolcat
echo "    Thank you for your patience   " | lolcat
echo "----------------------------------"
echo " "
echo " "
echo "----------------------------------"
echo "        Now Creating Subnets      " | lolcat
echo "----------------------------------"


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

echo " "
echo " ---------------------------------"
echo "     Creating the subnet Now      " | lolcat
echo " Please Wait Have Patience Please " | lolcat
echo "----------------------------------"

gcloud compute networks subnets create $firstsubnet --project=$projectname --description=Subnet\ with\ private-facing\ configuration --range=$firstipv4range --stack-type=IPV4_ONLY --network=$vpcname --region=asia-southeast1 --enable-private-ip-google-access



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

echo " "
echo " ---------------------------------"
echo "     Creating the subnet Now      " | lolcat
echo " Please Wait Have Patience Please " | lolcat
echo "----------------------------------"


gcloud compute networks subnets create $secondsubnet --project=$projectname --description=Subnet\ with\ private-facing\ configuration --range=$secondipv4range --stack-type=IPV4_ONLY --network=$vpcname --region=asia-southeast2 --enable-private-ip-google-access








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


echo " "
echo " ---------------------------------"
echo "     Creating the subnet Now      " | lolcat
echo " Please Wait Have Patience Please " | lolcat
echo "----------------------------------"

gcloud compute networks subnets create $firstpublicsubnet --project=$projectname --description=Subnet\ with\ public-facing\ configuration --range=$thirdipv4range --stack-type=IPV4_ONLY --network=$vpcname --region=asia-southeast1




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

echo " "
echo " ---------------------------------"
echo "     Creating the subnet Now      " | lolcat
echo " Please Wait Have Patience Please " | lolcat
echo "----------------------------------"

gcloud compute networks subnets create $secondpublicsubnet --project=$projectname --description=Subnet\ with\ public-facing\ configuration --range=$fourthipv4range --stack-type=IPV4_ONLY --network=$vpcname --region=asia-southeast2




echo " "
echo " ---------------------------------"
echo "        Subnets are all Done      " | lolcat
echo "----------------------------------"



echo " "
echo " "
echo " "
echo " ---------------------------------"
echo "  Now Configuring Firewall Rules  " | lolcat
echo "----------------------------------"

echo " "
echo " "
echo " ---------------------------------"
echo "  Provide the Firewall Rule Name  " | lolcat
echo "----------------------------------"
read firewallrulename

echo " ---------------------------------"
echo "     Creating the Firewall Now    " | lolcat
echo " Please Wait Have Patience Please " | lolcat
echo "----------------------------------"

#this will allow the vm to communicate with each other
gcloud compute --project=$projectname firewall-rules create $vpcname-allow-all --direction=INGRESS --priority=1000 --network=$vpcname --action=ALLOW --rules=all --source-ranges=$firstipv4range,$secondipv4range,$thirdipv4range,$fourthipv4range --destination-ranges=$firstipv4range,$secondipv4range,$thirdipv4range,$fourthipv4range

#this will allow to have ping
gcloud compute --project=$projectname firewall-rules create $vpcname-allow-icmp --direction=INGRESS --priority=1000 --network=$vpcname --action=ALLOW --rules=icmp --source-ranges=0.0.0.0/0 --destination-ranges=$firstipv4range,$secondipv4range,$thirdipv4range,$fourthipv4range

#this allows bidirectional access on port 5131
gcloud compute --project=$projectname firewall-rules create $vpcname-allow-bidi-ingress --description="bidirectional access" --direction=INGRESS --priority=1000 --network=$vpcname --action=ALLOW --rules=tcp:5131 --source-ranges=$firstipv4range,$secondipv4range,$thirdipv4range,$fourthipv4range

gcloud compute --project=$projectname firewall-rules create $vpcname-allow-bidi-engress --direction=EGRESS --priority=1000 --network=$vpcname --action=ALLOW --rules=tcp:5131 --destination-ranges=$firstipv4range,$secondipv4range,$thirdipv4range,$fourthipv4range


#this is for the sql port
gcloud compute --project=$projectname firewall-rules create $vpcname-vpc-allow-mysql --description="mysqldb access" --direction=INGRESS --priority=1000 --network=$vpcname --action=ALLOW --rules=tcp:3306 --source-ranges=$firstipv4range,$secondipv4range,$thirdipv4range,$fourthipv4range


#this is for the couchdbport
gcloud compute --project=$projectname firewall-rules create $vpcname-vpc-allow-couchdb --description="couchDB access" --direction=INGRESS --priority=1000 --network=$vpcname --action=ALLOW --rules=tcp:5984 --source-ranges=$firstipv4range,$secondipv4range,$thirdipv4range,$fourthipv4range

#this is to allow apis
gcloud compute --project=$projectname firewall-rules create $vpcname-vpc-allow-apis --description="apis" --direction=INGRESS --priority=1000 --network=$vpcname --action=ALLOW --rules=tcp:443 --source-ranges=$firstipv4range,$secondipv4range,$thirdipv4range,$fourthipv4range


#this is to allow rdp

:'
gcloud compute --project=$projectname firewall-rules create $vpcname-vpc-allow-rdp-internal --direction=EGRESS --priority=1000 --network=$vpcname --action=ALLOW --rules=tcp:3389 --source-ranges=$firstipv4range,$secondipv4range,$thirdipv4range,$fourthipv4range
'

gcloud compute --project=$projectname firewall-rules create $vpcname-vpc-allow-rdp-external --direction=INGRESS --priority=1000 --network=$vpcname --action=ALLOW --rules=tcp:3389 --source-ranges=0.0.0.0/0 --destination-ranges=$firstipv4range,$secondipv4range,$thirdipv4range,$fourthipv4range

echo " "
echo " "
echo " "

echo " ---------------------------------"
echo " Finished with the Firewall Rules " | lolcat
echo "----------------------------------"



echo "-------------------------------------------- "
echo " Will now Commence in creating the VM Needed " | lolcat
echo "-------------------------------------------- "

sleep 3
	echo -n " Hold On While We Ready"
	for i in {1..50}; do
	    echo -n "#"
	    sleep 0.1
	done | pv -lep -s 50 > /dev/null
	echo -e "\nIIIITTTTTSSSSSS TIMEEEEEEEE!!!"
	echo " "
	echo " "
	echo " "


echo "-------------------------------------------- "
echo "      Creating now the Platform Server       " | lolcat
echo "-------------------------------------------- "


echo " "
echo "---------------------------------------------------"
echo "  Please Provide the name for the server to be use " | lolcat
echo " *the name will be GIVENNAME-prod-sea1-vm-platform " | lolcat
echo "---------------------------------------------------"
read platformname


echo " "
echo " "
echo " "
echo "-------------------------------------------- "
echo "        Enter the Service Account            " | lolcat
echo "   *The Compute Engine Service Account*      " | lolcat
echo "-------------------------------------------- "
read serviceaccount




#This will Create a VM Platform Server

: '
gcloud compute instances create $platformname-prod-sea1-vm-platform \
    --project=$projectname \
    --zone=asia-southeast1-a \
    --machine-type=e2-standard-4 \
    --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=$firstsubnet \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --service-account=$serviceaccount \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --create-disk=auto-delete=yes,boot=yes,device-name=instance-20240701-031823,image=projects/windows-cloud/global/images/windows-server-2019-dc-v20240612,mode=rw,size=50,type=projects/$projectname/zones/asia-southeast1-a/diskTypes/pd-ssd \
    --create-disk=device-name=disk-1,mode=rw,name=disk-1,size=200,type=projects/$projectname/zones/asia-southeast1-a/diskTypes/pd-ssd \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any
'

echo " "
echo " "
echo "  -------------------------------------------  "
echo "      Now Creating the Platform Please Wait    " | lolcat
echo "  -------------------------------------------- "
echo " "
echo " "
gcloud compute instances create $platformname-prod-sea1-vm-platform --project=$projectname --zone=asia-southeast1-a --machine-type=e2-standard-4 --network-interface=network-tier=PREMIUM,nic-type=GVNIC,private-network-ip=172.16.252.2,stack-type=IPV4_ONLY,subnet=$firstsubnet --no-restart-on-failure --maintenance-policy=MIGRATE --provisioning-model=STANDARD --service-account=$serviceaccount --scopes=https://www.googleapis.com/auth/cloud-platform --enable-display-device --tags=$platformname-prod-sea1-vm-platform --create-disk=auto-delete=yes,boot=yes,device-name=$projectname-prod-sea1-vm-platform,image=projects/windows-cloud/global/images/windows-server-2019-dc-v20240612,mode=rw,size=200,type=projects/$projectname/zones/asia-southeast1-a/diskTypes/pd-ssd --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any

echo " "
echo " "
echo "  -----------------------------  "
echo "         Platform Finished       "  | lolcat
echo "  -----------------------------  "
echo " "
echo " "



#This will Create a SQL Server
:'
gcloud compute instances create $platformname-prod-sea1-vm-mysqldb \
    --project=bats-solutions-library \
    --zone=asia-southeast1-a \
    --machine-type=e2-standard-16 \
    --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=$firstsubnet \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --service-account=985742192344-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --create-disk=auto-delete=yes,boot=yes,device-name=instance-20240701-031823,image=projects/windows-cloud/global/images/windows-server-2019-dc-v20240612,mode=rw,size=50,type=projects/bats-solutions-library/zones/asia-southeast1-a/diskTypes/pd-ssd \
    --create-disk=device-name=disk-2,mode=rw,name=disk-2,size=1000,type=projects/bats-solutions-library/zones/asia-southeast1-a/diskTypes/pd-ssd \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any
'
echo " "
echo " "
echo "  -------------------------------------------  "
echo "      Now Creating the MySQLDB Please Wait     " | lolcat
echo "  -------------------------------------------- "
echo " "
echo " "

gcloud compute instances create $platformname-prod-sea1-vm-mysqldb --project=$projectname --zone=asia-southeast1-a --machine-type=e2-standard-16 --network-interface=network-tier=PREMIUM,nic-type=GVNIC,private-network-ip=172.16.252.3,stack-type=IPV4_ONLY,subnet=$firstsubnet --no-restart-on-failure --maintenance-policy=MIGRATE --provisioning-model=STANDARD --service-account=$serviceaccount --scopes=https://www.googleapis.com/auth/cloud-platform --enable-display-device --tags=$platformname-prod-sea1-vm-mysqldb --create-disk=auto-delete=yes,boot=yes,device-name=$platformname-prod-sea1-vm-mysqldb,image=projects/windows-cloud/global/images/windows-server-2019-dc-v20240612,mode=rw,size=1000,type=projects/$projectname/zones/asia-southeast1-a/diskTypes/pd-ssd --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any

echo " "
echo " "
echo "  -----------------------------  "
echo "        SQL Server Finished      "  | lolcat
echo "  -----------------------------  "
echo " "
echo " "

#This will Create a CouchDB
:'
gcloud compute instances create $platformname-prod-sea1-vm-coachdb \
    --project=bats-solutions-library \
    --zone=asia-southeast1-a \
    --machine-type=e2-standard-16 \
    --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=$firstsubnet \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --service-account=985742192344-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --create-disk=auto-delete=yes,boot=yes,device-name=instance-20240701-031823,image=projects/windows-cloud/global/images/windows-server-2019-dc-v20240612,mode=rw,size=50,type=projects/bats-solutions-library/zones/asia-southeast1-a/diskTypes/pd-ssd \
    --create-disk=device-name=disk-3,mode=rw,name=disk-3,size=1000,type=projects/bats-solutions-library/zones/asia-southeast1-a/diskTypes/pd-ssd \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any
'

echo " "
echo " "
echo "  -------------------------------------------  "
echo "      Now Creating the CouchDB Please Wait     " | lolcat
echo "  -------------------------------------------- "
echo " "
echo " "

gcloud compute instances create $platformname-prod-sea1-vm-couchdb --project=$projectname --zone=asia-southeast1-a --machine-type=e2-standard-16 --network-interface=network-tier=PREMIUM,nic-type=GVNIC,private-network-ip=172.16.252.4,stack-type=IPV4_ONLY,subnet=$firstsubnet --no-restart-on-failure --maintenance-policy=MIGRATE --provisioning-model=STANDARD --service-account=$serviceaccount --scopes=https://www.googleapis.com/auth/cloud-platform --enable-display-device --tags=$platformname-prod-sea1-vm-couchdb --create-disk=auto-delete=yes,boot=yes,device-name=$platformname-prod-sea1-vm-couchdb,image=projects/windows-cloud/global/images/windows-server-2019-dc-v20240612,mode=rw,size=1000,type=projects/$projectname/zones/asia-southeast1-a/diskTypes/pd-ssd --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any


echo " "
echo " "
echo "  -----------------------------  "
echo "     CouchDB Server Finished     "  | lolcat
echo "  -----------------------------  "
echo " "
echo " "

#This will Create a Node Server
:'
gcloud compute instances create $platformname-prod-sea1-vm-nodeserver01 \
    --project=$projectname \
    --zone=asia-southeast1-a \
    --machine-type=e2-standard-8 \
    --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=$firstsubnet \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --service-account=$serviceaccount \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --create-disk=auto-delete=yes,boot=yes,device-name=instance-20240701-031823,image=projects/windows-cloud/global/images/windows-server-2019-dc-v20240612,mode=rw,size=50,type=projects/$projectname/zones/asia-southeast1-a/diskTypes/pd-ssd \
    --create-disk=device-name=disk-4,mode=rw,name=disk-4,size=200,type=projects/$projectname/zones/asia-southeast1-a/diskTypes/pd-ssd \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any
'


echo " "
echo " "
echo "  -------------------------------------------  "
echo "    Now Creating the Node Server Please Wait   " | lolcat
echo "  -------------------------------------------- "
echo " "
echo " "


gcloud compute instances create $platformname-prod-sea1-vm-nodesvr01 --project=$projectname --zone=asia-southeast1-a --machine-type=e2-standard-8 --network-interface=network-tier=PREMIUM,nic-type=GVNIC,private-network-ip=172.16.252.5,stack-type=IPV4_ONLY,subnet=$firstsubnet --no-restart-on-failure --maintenance-policy=MIGRATE --provisioning-model=STANDARD --service-account=$serviceaccount --scopes=https://www.googleapis.com/auth/cloud-platform --enable-display-device --tags=$platformname-prod-sea1-vm-nodesvr --create-disk=auto-delete=yes,boot=yes,device-name=$platformname-prod-sea1-vm-nodesvr,image=projects/windows-cloud/global/images/windows-server-2019-dc-v20240612,mode=rw,size=200,type=projects/$projectname/zones/asia-southeast1-a/diskTypes/pd-ssd --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any


echo " "
echo " "
echo "  -----------------------------  "
echo "       Node Server Finished      "  | lolcat
echo "  -----------------------------  "
echo " "
echo " "


sleep 3
	echo -n " SETTING EVERYTHING UP FOR YOU COZ YOU SPECIAL DAWG" | lolcat
	for i in {1..50}; do
	    echo -n "#"
	    sleep 0.1
	done | pv -lep -s 50 > /dev/null
	echo " "
	echo " "
	cowsay -c cheese -t "I WISH YOU ALL THE BEST I BELIEVE IN YOU BROTHA"  | lolcat
	echo " "

}
chickengwm




