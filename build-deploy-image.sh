## Build the image
cd sampleApp/AzureEats-Website-master/Source/Tailwind.Traders.Web/  
docker build --tag tfonazure-challenge4 .

# Show the image
docker image ls tfonazure-challenge4

# Test it locally and then remove it
docker run --publish 8000:80 --detach --name tfonazure tfonazure-challenge4:latest
docker rm --force tfonazure

## push it to ACR
az acr login --name omegamadlabtfonaz4acr

# Tag the image
docker tag tfonazure-challenge4 omegamadlabtfonaz4acr.azurecr.io/tfonazure:v1

# Push the image to ACR
docker push omegamadlabtfonaz4acr.azurecr.io/tfonazure:v1

# Show the image in ACR
az acr repository list --name omegamadlabtfonaz4acr

ACRLOGIN=$(az acr show --name "omegamadlabtfonaz4acr" \
            --resource-group "tfonazure-challenge4-RG" \
            --query "loginServer" -o tsv)

docker images $ACRLOGIN/tfonazure

## Deploy with Help
cd ../../Deploy/helm/
AKSHOST=$(az aks show --name "omegamadlab-tfonaz-4-aks" \
            --resource-group "tfonazure-challenge4-RG" \
            --query "addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName" -o tsv)
echo $AKSHOST

# Connect to AKS
az aks get-credentials --resource-group "tfonazure-challenge4-RG" --name $AKSHOST

# Integrate AKS with ACR
az aks update --name "omegamadlab-tfonaz-4-aks" \
    --resource-group "tfonazure-challenge4-RG" \
    --attach-acr "omegamadlabtfonaz4acr"

# Deploy Helm chart
helm upgrade --install tfonazure \
    ./web \
    -f ./gvalues.yaml \
    -f ./values.b2c.yaml \
    --set ingress.hosts={$AKSHOST} \
    --set ingress.protocol=http \
    --set image.repository=$ACRLOGIN/tfonazure \
    --set image.tag=v1 
