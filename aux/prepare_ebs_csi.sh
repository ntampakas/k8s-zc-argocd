#!/bin/bash
set -e

CLUSTER_NAME="testautomation-eks"
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
OIDC=$(aws eks describe-cluster --name $CLUSTER_NAME --query "cluster.identity.oidc.issuer" --output text)

REGION=$(echo $OIDC | awk -F. '{ print $3 }')
OIDC_RAND=$(echo $OIDC | awk -F/ '{ print $5 }')

# Prepare trust policy
cp aws-ebs-csi-driver-trust-policy-template.json aws-ebs-csi-driver-trust-policy.json
sed -i "s/111XXX111/$ACCOUNT_ID/g" aws-ebs-csi-driver-trust-policy.json
sed -i "s/region-XXX-code/$REGION/g" aws-ebs-csi-driver-trust-policy.json
sed -i "s/EXAMPLEXXXEXAMPLE/$OIDC_RAND/g" aws-ebs-csi-driver-trust-policy.json

# Create role
aws iam create-role --role-name AmazonEKS_EBS_CSI_DriverRole_$CLUSTER_NAME --assume-role-policy-document file://"aws-ebs-csi-driver-trust-policy.json"

# Attach policy
aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy --role-name AmazonEKS_EBS_CSI_DriverRole_$CLUSTER_NAME

# Annotate the ebs-csi-controller-sa Kubernetes service account 
aws eks create-addon --cluster-name $CLUSTER_NAME --addon-name aws-ebs-csi-driver --service-account-role-arn arn:aws:iam::$ACCOUNT_ID:role/AmazonEKS_EBS_CSI_DriverRole_$CLUSTER_NAME

rm aws-ebs-csi-driver-trust-policy.json
