#### Install Halyard #####

sudo chmod +x /InstallHalyard.sh

sudo sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/hosts

echo "Y" | sudo bash /InstallHalyard.sh --user $USER

##### GCE ######
# https://cloud.google.com/sdk/downloads#apt-get
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get -y update && sudo apt-get install -y \
    google-cloud-sdk \
    kubectl \
    google-cloud-sdk-app-engine-python \
    google-cloud-sdk-app-engine-java \
    google-cloud-sdk-app-engine-go

gcloud init


###### Halyard Settings ########

hal config version edit --version "1.4.2"
###### Storage #################
gcloud config provider kubernetes account delete
hal config storage edit --type redis

###### Cloud Provider ##########
# GCE
# https://www.spinnaker.io/setup/providers/gce/
GCE_SERVICE_ACCOUNT_NAME=spinnaker-gce-account
GCE_SERVICE_ACCOUNT_DEST=~/.gcp/gce-account.json

gcloud config set account $GCE_SERVICE_ACCOUNT_NAME
gcloud iam service-accounts create \
    $GCE_SERVICE_ACCOUNT_NAME \
    --display-name $GCE_SERVICE_ACCOUNT_NAME

GCE_SA_EMAIL=$(gcloud iam service-accounts list \
    --filter="displayName:$GCE_SERVICE_ACCOUNT_NAME" \
    --format='value(email)')

GCE_PROJECT=$(gcloud info --format='value(config.project)')

# permission to create/modify instances in your project
gcloud projects add-iam-policy-binding $GCE_PROJECT \
    --member serviceAccount:$GCE_SA_EMAIL \
    --role roles/compute.instanceAdmin

# permission to create/modify network settings in your project
gcloud projects add-iam-policy-binding $GCE_PROJECT \
    --member serviceAccount:$GCE_SA_EMAIL \
    --role roles/compute.networkAdmin

# permission to create/modify firewall rules in your project
gcloud projects add-iam-policy-binding $GCE_PROJECT \
    --member serviceAccount:$GCE_SA_EMAIL \
    --role roles/compute.securityAdmin

# permission to create/modify images & disks in your project
gcloud projects add-iam-policy-binding $GCE_PROJECT \
    --member serviceAccount:$GCE_SA_EMAIL \
    --role roles/compute.storageAdmin

# permission to download service account keys in your project
# this is needed by packer to bake GCE images remotely
gcloud projects add-iam-policy-binding $GCE_PROJECT \
    --member serviceAccount:$GCE_SA_EMAIL \
    --role roles/iam.serviceAccountActor

mkdir -p $(dirname $GCE_SERVICE_ACCOUNT_DEST)

gcloud iam service-accounts keys create $GCE_SERVICE_ACCOUNT_DEST \
    --iam-account $GCE_SA_EMAIL

hal config provider google enable

hal config provider google account add my-gce-account --project $GCE_PROJECT \
    --json-path $GCE_SERVICE_ACCOUNT_DEST

###### Kubernetes ######
    ####### Docker Registry ########
    # Dockerhub
    # https://www.spinnaker.io/setup/providers/docker-registry/
    CR_ADDRESS=index.docker.io
    CR_REPOSITORIES=snavien/spin-kub-demo
    CR_USERNAME=snavien

    hal config provider docker-registry enable
    hal config provider docker-registry account add my-docker-registry \
        --address $CR_ADDRESS \
        --repositories $CR_REPOSITORIES \
        --username $CR_USERNAME \
        --password

gcloud container clusters get-credentials spinnaker-cluster --zone us-west1-b --project spinnaker-project-181018

hal config provider kubernetes enable
hal config provider kubernetes account add \
  gke_spinnaker-project-181018_us-west1-b_spinnaker-cluster \
  --docker-registries my-docker-registry

###### Deploy ##################
hal deploy apply

###### Networking ##############
#sudo "host: 0.0.0.0" | tee \
#    ~/.hal/default/service-settings/gate.yml \
#    ~/.hal/default/service-settings/deck.yml

#hal config security ui edit \
#    --override-base-url http://192.168.33.10:9000

#hal config security api edit \
#    --override-base-url http://192.168.33.10:8084


###### Apply ###################
sudo hal deploy apply
sudo hal deploy connect
sudo apt-get autoremove
