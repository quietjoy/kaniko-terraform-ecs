[{
	"name": "${identifier}",
	"image": "${kankio_ecr_url}:latest",
	"portMappings": [{
		"containerPort": 80
	}],
	"logConfiguration": {
		"logDriver": "awslogs",
		"options": {
			"awslogs-group": "kaniko-builder",
			"awslogs-region": "us-east-1",
			"awslogs-stream-prefix": "kaniko",
			"awslogs-create-group": "true"
		}
	},
	"command": [
		"--context", "git://${repo_url}",
		"--context-sub-path", "./app",
		"--dockerfile", "Dockerfile",
		"--destination", "${app_ecr_url}",
		"--force"
	]
}]