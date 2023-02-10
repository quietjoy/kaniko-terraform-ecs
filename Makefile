ecr-login:
	aws ecr get-login-password | docker login \
   --username AWS \
   --password-stdin \
    637267677553.dkr.ecr.us-east-1.amazonaws.com/kaniko-builder:latest

kaniko-build:
	docker build -t 637267677553.dkr.ecr.us-east-1.amazonaws.com/kaniko-builder:latest ./kaniko

kaniko-push:
	docker push 637267677553.dkr.ecr.us-east-1.amazonaws.com/kaniko-builder:latest

infra-build:
	cd terraform; terraform init; terraform apply -auto-approve; cd ../

infra-destroy:
	cd terraform; terraform destroy -auto-approve; cd ../