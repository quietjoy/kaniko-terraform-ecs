ecr-login:
	aws ecr get-login-password | docker login \
   --username AWS \
   --password-stdin \
    637267677553.dkr.ecr.us-east-1.amazonaws.com/kaniko-builder:latest

kaniko-build:
	docker build -t														\
		`terraform output -state=./terraform/terraform.tfstate -json 	\
		| jq -r .kaniko_ecr_repository_url.value`:latest 				\
		./kaniko

kaniko-push:
	docker push													\
		`terraform output -state=./terraform/terraform.tfstate -json 	\
		| jq -r .kaniko_ecr_repository_url.value`:latest 				\

infra-build:
	cd terraform; terraform init; terraform apply -auto-approve; cd ../

infra-destroy:
	cd terraform; terraform destroy -auto-approve; cd ../