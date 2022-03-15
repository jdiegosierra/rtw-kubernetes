1. Desplegar la infraestructura -> terraform apply --auto-approve 
2. Aprovisionar hosts en el control plane -> AWS_PROFILE=development ansible-playbook './playbooks/kubernetes/play.yaml'