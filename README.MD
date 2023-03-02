Exemplo seguindo o link  1


##1 
https://github.com/terraform-aws-modules/terraform-aws-eks/tree/v17.1.0/examples/managed_node_groups

terraform init -upgrade
terraform plan
terraform apply --auto-approve

cp project2/test-eks-*_config kubeconfig_test
export KUBECONFIG=$(pwd)/kubeconfig_test
export KUBE_CONFIG_PATH=$(pwd)/kubeconfig_test

##2

Copiar modulo de load balancer
https://github.com/Young-ook/terraform-aws-eks/tree/1.7.3/examples/lb

### Para debugar erro
https://aws.amazon.com/pt/premiumsupport/knowledge-center/eks-load-balancer-webidentityerr/


##3 
Utilizar o repositorio abaixo como workload
kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/examples/2048/2048_full.yaml


Exemplo 2

https://aws.amazon.com/pt/blogs/containers/exposing-kubernetes-applications-part-3-nginx-ingress-controller/


###1
k apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"

###2
k apply -f workloads/1-namespaces.yaml

###3
SERVICE_NAME=first NS=apps envsubst < workloads/2-deployment.yml | k apply -f -
SERVICE_NAME=second NS=apps envsubst < workloads/2-deployment.yml | k apply -f -

SERVICE_NAME=first NS=apps envsubst < workloads/2-deployment.yml | k delete -f -
SERVICE_NAME=second NS=apps envsubst < workloads/2-deployment.yml | k delete -f -

###4
NS=apps envsubst < workloads/3-ingress.yml | k apply -f -

NS=apps envsubst < workloads/3-ingress.yml | k delete -f -

###5
k port-forward -n kube-system svc/ingress-nginx-controller 8080:80


---------------

k apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"


https://verifa.io/blog/aws-load-balancer-controller-with-existing-alb/index.html