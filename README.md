1. Desplegar la infraestructura -> terraform apply --auto-approve 
2. Aprovisionar hosts en el control plane -> AWS_PROFILE=development ansible-playbook './playbooks/kubernetes/play.yaml'

TODO: Los puertos de los grupos de destino del balanceador de carga son: 2379, 2380, 6443, 10250
Ademas, en el grupo de seguridad hay que abrir otros puertos como el 53 TCP


----------

Usando Kops

kops create cluster \
    --node-count 3 \
    --zones eu-west-1a,eu-west-1b,eu-west-1c \
    --master-zones eu-west-1a,eu-west-1b,eu-west-1c \
    --discovery-store s3://talento-development-clusters-oidc-store/${NAME}/discovery${NAME} \
    --topology private \
    --api-loadbalancer-class network \
    --container-runtime containerd \
    --networking calico \
    --bastion=true \
    --state s3://talento-development-clusters-state-store \
    --api-ssl-certificate arn:aws:acm:eu-west-1:782886332900:certificate/1c06120e-456d-4eb2-972a-3eafd539fcf6 \
    --name ${NAME} \
    --yes

 kops edit cluster --name development.talentomobile.com --state s3://talento-development-clusters-state-store

 kops update cluster development.talentomobile.com --state s3://talento-development-clusters-state-store --yes

 kops export kubecfg --admin --state s3://talento-development-clusters-state-store

 kops rolling-update cluster --name development.talentomobile.com --state s3://talento-development-clusters-state-store

 kops upgrade cluster ${NAME} —-yes

 Suggestions:
 * validate cluster: kops validate cluster --wait 10m
 * list nodes: kubectl get nodes --show-labels
 * ssh to the bastion: ssh -A -i ~/.ssh/id_rsa ubuntu@bastion.development.talentomobile.com
 * the ubuntu user is specific to Ubuntu. If not using Ubuntu please use the appropriate user based on your OS.
 * read about installing addons at: https://kops.sigs.k8s.io/addons.


 Kubernetes

 kubectl create secret docker-registry aws-ecr \
  --docker-server=782886332900.dkr.ecr.eu-west-1.amazonaws.com \
  --docker-username=AWS \
  --docker-password=$(aws ecr get-login-password) \
  --namespace=masmovil

kubectl get secret aws-ecr -o json | jq '.data | map_values(@base64d)'