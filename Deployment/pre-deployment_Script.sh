# This is a pre deployment script developed by K.Janarthana
# This script will create 2 service accounts 1 for Terraform deployment and another for accessing GCP storage for wordpress
# Fine grained access control was given to service account accessing Wordpress bucket
# This script also download the json key of the service accounts and copies to destination folder
# Also, this script enabled APIs for GCP services 
# Finally this script build the docker image and push to artifactory
# Date - 6/6/2023

#!/bin/sh

PROJECT_ID=""
SERVICE_ACCOUNT_NAME="bucket-test-svc"


# Set the desired region and storage class
BUCKET_NAME="upwork-jana-wp"
REGION="us-central1"       # e.g., us-central1
STORAGE_CLASS="standard"   # or choose from options like multi_regional, regional, nearline, coldline
KEY_FILE_PATH="svc.json"

TF_SERVICE_ACCOUNT_NAME="bucket-test-svc"
TF_KEY_FILE_PATH="tf.json"


#############################################################
##### 		Script Starts 				#####
#############################################################

gcloud config set project $PROJECT_ID

# Create the bucket with fine-grained ACL and public access granted
echo "Creating Storage Bucket.........."
gsutil mb -p $PROJECT_ID -c $STORAGE_CLASS -l $REGION -b on gs://$BUCKET_NAME

# Enable fine-grained access control
gsutil bucketpolicyonly set off gs://$BUCKET_NAME

# Add public read access to the bucket
#gsutil iam ch allAuthenticatedUsers:objectViewer gs://$BUCKET_NAME
gsutil -m acl set -R -a public-read gs://${BUCKET_NAME}

# Create the service account
echo "Creating Service Account for accessing Storage Bucket........"
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
    --display-name "Service Account for $SERVICE_ACCOUNT_NAME" \
    --project $PROJECT_ID

# Add storage admin role to the service account
gcloud projects add-iam-policy-binding $PROJECT_ID    \
 --member "serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com"   \
  --role "roles/storage.admin"  --condition=expression="resource.name.startsWith('projects/_/buckets/$BUCKET_NAME')",\
title="Access to $BUCKET_NAME",description="Access only to $BUCKET_NAME"

# Generate key for the service account and save it to a file
echo "Downloading the storage key .........."
gcloud iam service-accounts keys create $KEY_FILE_PATH \
    --iam-account "$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com"

# Create the service account for Terraform
echo "Creating service Account for Terraform .........."
gcloud iam service-accounts create $TF_SERVICE_ACCOUNT_NAME \
    --display-name "Service Account for $TF_SERVICE_ACCOUNT_NAME" \
    --project $PROJECT_ID

# Add storage admin role to the service account
gcloud projects add-iam-policy-binding $PROJECT_ID    \
 --member "serviceAccount:$TF_SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com"   \
  --role "roles/owner" --condition=None

# Generate key for the service account and save it to a file
echo "Downloading the Terraform key .........."
gcloud iam service-accounts keys create $TF_KEY_FILE_PATH \
    --iam-account "$TF_SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com"

#Enable APIs
echo "Enabling the APIs .........."
gcloud services enable \
    vpcaccess.googleapis.com \
    sql-component.googleapis.com \
    servicenetworking.googleapis.com \
    secretmanager.googleapis.com \
    cloudresourcemanager.googleapis.com \
    redis.googleapis.com \
    sqladmin.googleapis.com \
    run.googleapis.com \
    cloudbuild.googleapis.com \
    containerregistry.googleapis.com


echo "Copying json files to destination"
mv $KEY_FILE_PATH ./cloudrun/svc.json
mv $TF_KEY_FILE_PATH ./Terraform/tf.json

echo "Starting docker build"
sudo chmod -R 777 cloudrun/wp-content/
cd cloudrun 
sudo chmod a+rw svc.json
gcloud builds submit --tag gcr.io/$PROJECT_ID/customwordpress

echo "Pre-Deployment Script completed successfully"