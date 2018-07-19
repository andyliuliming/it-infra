#!/usr/bin/env bash

# setup local hook
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $DIR/.pri.sh

ansible-playbook -i inventories/jenkins jenkins.yml \
-e "jenkins_domain=azurecpi.gugagaga.fun" \
-e "acme_domain=azurecpi.gugagaga.fun" \
-e "ansible_user=${JENKINS_ADMIN}" \
-e "jenkins_admin_username=${JENKINS_ADMIN}" \
-e "jenkins_admin_password=${JENKINS_PASSWORD}" \
-e "acme_key=${ACME_KEY}" \
-e "acme_secret=${ACME_SECRET}" --tags "nginx" \
-v