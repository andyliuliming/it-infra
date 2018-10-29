#!/usr/bin/env bash

# setup local hook
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $DIR/.pri.sh
export JENKINS_HOME="${JENKINS_ROOT}/jenkins_home"

# first setup the data disks.
ansible-playbook -i inventories/jenkins jenkins.yml \
-e "jenkins_master_domain=${JENKINS_MASTER_DOMAIN}" \
-e "jenkins_slave_0_domain=${JENKINS_SLAVE_0_DOMAIN}" \
-e "ansible_user=${JENKINS_ADMIN}" \
-e "jenkins_root=${JENKINS_ROOT}" \
-e "jenkins_home=${JENKINS_HOME}" \
--tags "setup:datadisk" \
-v

# generate the ssh key for jenkins user on master node
ansible-playbook -i inventories/jenkins jenkins.yml \
-e "jenkins_master_domain=${JENKINS_MASTER_DOMAIN}" \
-e "jenkins_slave_0_domain=${JENKINS_SLAVE_0_DOMAIN}" \
-e "ansible_user=${JENKINS_ADMIN}" \
-e "jenkins_root=${JENKINS_ROOT}" \
-e "jenkins_home=${JENKINS_HOME}" \
-e "jenkins_admin_username=${JENKINS_ADMIN}" \
--tags "setup:jenkinsmastersshkey" \
-v

# then install the docker software.
ansible-playbook -i inventories/jenkins jenkins.yml \
-e "jenkins_master_domain=${JENKINS_MASTER_DOMAIN}" \
-e "jenkins_slave_0_domain=${JENKINS_SLAVE_0_DOMAIN}" \
-e "ansible_user=${JENKINS_ADMIN}" \
-e "jenkins_root=${JENKINS_ROOT}" \
-e "jenkins_home=${JENKINS_HOME}" \
--tags "setup:docker" \
-v

# then install the jenkins software.
ansible-playbook -i inventories/jenkins jenkins.yml \
-e "jenkins_master_domain=${JENKINS_MASTER_DOMAIN}" \
-e "jenkins_slave_0_domain=${JENKINS_SLAVE_0_DOMAIN}" \
-e "ansible_user=${JENKINS_ADMIN}" \
-e "jenkins_root=${JENKINS_ROOT}" \
-e "jenkins_home=${JENKINS_HOME}" \
-e "jenkins_admin_username=${JENKINS_ADMIN}" \
-e "jenkins_admin_password=${JENKINS_PASSWORD}" \
--tags "setup:jenkins" \
-v

# setup the master nginx
ansible-playbook -i inventories/jenkins jenkins.yml \
-e "jenkins_admin_username=${JENKINS_ADMIN}" \
-e "jenkins_admin_password=${JENKINS_PASSWORD}" \
-e "ansible_user=${JENKINS_ADMIN}" \
-e "jenkins_root=${JENKINS_ROOT}" \
-e "jenkins_home=${JENKINS_HOME}" \
-e "jenkins_domain=${JENKINS_DOMAIN}" \
-e "acme_domain=${JENKINS_DOMAIN}" \
-e "acme_key=${ACME_KEY}" \
-e "acme_secret=${ACME_SECRET}" \
-e "jenkins_server_real_nginx_https_cert=/var/www/acme/site/${JENKINS_DOMAIN}/nginx/cert.pem" \
-e "jenkins_server_real_nginx_https_key=/var/www/acme/site/${JENKINS_DOMAIN}/nginx/key.pem" \
-e "jenkins_master_domain=${JENKINS_MASTER_DOMAIN}" \
-e "jenkins_slave_0_domain=${JENKINS_SLAVE_0_DOMAIN}" \
--tags "setup:nginx,setup:acme" \
-v

# then install the slave node.
ansible-playbook -i inventories/jenkins jenkins.yml \
-e "jenkins_master_domain=${JENKINS_MASTER_DOMAIN}" \
-e "jenkins_slave_0_domain=${JENKINS_SLAVE_0_DOMAIN}" \
-e "ansible_user=${JENKINS_ADMIN}" \
-e "jenkins_root=${JENKINS_ROOT}" \
-e "jenkins_home=${JENKINS_HOME}" \
-e "jenkins_master_url=https://${JENKINS_DOMAIN}" \
-e "jenkins_admin_username=${JENKINS_ADMIN}" \
-e "jenkins_node_credentials_id=master-ssh" \
--tags "setup:slave" \
-v