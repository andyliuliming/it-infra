#!/usr/bin/env bash

# setup local hook
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cp $DIR/pre-commit $DIR/../.git/hooks/pre-commit
chmod +x $DIR/../.git/hooks/pre-commit

source $DIR/.pri.sh

# ansible-galaxy install geerlingguy.jenkins

pushd tf/jenkins
terraform init

export RESOURCE_GROUP=${PREFIX}-rg

terraform apply -var prefix="${PREFIX}" \
-var subscription_id="${SUBSCRIPTION_ID}" \
-var client_id="${CLIENT_ID}" \
-var client_secret="${CLIENT_SECRET}" \
-var tenant_id="${TENANT_ID}"  \
-var location="${LOCATION}" \
-var ssh_user_username="${JENKINS_ADMIN}" \
-var ssh_public_key_filename="${SSH_PUBLIC_KEY_FILENAME}"
popd


echo "Please update the dns to the ip in the outputs."