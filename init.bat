set /P ACC_ID=Enter AWS RegistryID: 

aws ecr get-login-password | docker login --username AWS --password-stdin %ACC_ID%.dkr.ecr.us-east-1.amazonaws.com
docker build -t go-serv-aws .
docker tag go-serv-aws  %ACC_ID%.dkr.ecr.us-east-1.amazonaws.com/go-ecs-app-repo:latest
aws ecr create-repository --repository-name go-ecs-app-repo
docker push  %ACC_ID%.dkr.ecr.us-east-1.amazonaws.com/go-ecs-app-repo:latest
cd infraestructure
del .terraform.lock.hcl
del terraform.tfstate
del terraform.tfstate.backup

PAUSE