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
+ https://aws.amazon.com/blogs/containers/metrics-and-traces-collection-from-amazon-ecs-using-aws-distro-for-opentelemetry-with-dynamic-service-discovery/

## Left Off

```
Resourceinitializationerror: unable to pull secrets or registry auth: execution resource retrieval failed: unable to retrieve ecr registry auth: service call has been retried 3 time(s): RequestError: send request failed caused by: Post "https://api.ecr.us-east-1.amazonaws.com/": dial tcp 67.220.240.139:443: i/o timeout
```

## TODO

- ensure that terraform infrastructure deploys
- create kaniko container and deploy to ecr
+ go through aws blog and create intial build on kaniko
+ create nginx container and deploy to ecr
+ deploy aws distro for open telemetry next to nginx
+ register services on aws cloud map
+ add cloudwatch events and github webhook - ensure that e2e completes
+ add slack and email notifications
+ Finish documentation