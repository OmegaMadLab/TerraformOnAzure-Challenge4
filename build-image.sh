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
docker tag tfonazure-challenge4:latest omegamadlabtfonaz4acr.azurecr.io/tfonazure/tfonazure-challenge4

# Push the image to ACR
docker push omegamadlabtfonaz4acr.azurecr.io/tfonazure/tfonazure-challenge4

# Show the image in ACR
az acr repository list --name omegamadlabtfonaz4acr

## Deploy with Help
cd ../../Deploy/helm/
AKSHOST=$(az aks show --name "omegamadlab-tfonaz-4-aks" \
            --resource-group "tfonazure-challenge4-RG" \
            --query "addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName" -o tsv)
echo $AKSHOST

# Connect to AKS
az aks get-credentials --resource-group "tfonazure-challenge4-RG" --name $AKSHOST

helm upgrade --install "tfonazure-challenge4" \
    -f "gvalues.yaml" \
    -f "values.b2c.yaml" \
    --set ingress.hosts={$AKSHOST} \
    --set ingress.protocol=http \
    --set image.repository=omegamadlabtfonaz4acr.azurecr.io/tfonazure/tfonazure-challenge4 \
    --set image.tag=latest \
    --verify \
    --wait \
    ./web 
#helm upgrade --install tailwindtraders-web ./Deploy/helm/web -f ./Deploy/helm/gvalues.yaml -f ./Deploy/helm/values.b2c.yaml  --set ingress.hosts={challenge4-aks1}  --set ingress.protocol=https --set ingress.tls[0].hosts={challenge4-aks1}  --set image.repository=challenge4acrbrkuhlma.azurecr.io --set image.tag=gh-${{ github.sha }}

helm uninstall "tfonazure-challenge4"