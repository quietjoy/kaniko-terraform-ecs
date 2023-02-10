[
  {
    "name": "${identifier}",
    "image": "${kankio_ecr_url}:latest",
    "portMappings": [
      {
        "containerPort": 80
      }
    ],
    "logDriver": "awslogs",
    "options": {
        "awslogs-group": "kaniko-builder",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "kaniko"
      }
    "command": [
        "--context", "git://${repo_url}",
        "--context-sub-path", "./app",
        "--dockerfile", "Dockerfile",
        "--destination", "${ecr_url_app}",
        "--force"
      ]
    }
  }
]