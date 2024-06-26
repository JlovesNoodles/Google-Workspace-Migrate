#!bash
#!HomeBrewByChickenNoodles


function createvpc()

echo ""
echo ""
echo "Provide the name for Project Name: "
echo ""
echo ""
read projectname
echo ""
echo ""
echo "Provide the name for Project Name: "
echo ""
echo ""
read vpcname




gcloud compute networks create vpcname --project=projectname --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional


createvpc
