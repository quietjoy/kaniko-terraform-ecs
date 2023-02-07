# Kaniko demo project

This project is a case study in how you can build containers in ecs fargate. In addition, the project also includes an integration with cloudwatch, so that the container is built and deployed once a day. This is meant to simulate applying the latest security updates with no downtime to the container.

The infrastructure is built in terraform and leverages the kaniko project for building containers in ecs fargate.

## Features

+ A simple nginx container image with example html
+ Cloudwatch events to regularly build the containers
+ Github webhooks for building and deploying container on any change to the `app/` directory
+ Slack notifications for container builds and ecs deployments
+ Email notifications that include container vuln scan information

## Resources

+ https://aws.amazon.com/blogs/containers/building-container-images-on-amazon-ecs-on-aws-fargate/
+ https://github.com/GoogleContainerTools/kaniko

