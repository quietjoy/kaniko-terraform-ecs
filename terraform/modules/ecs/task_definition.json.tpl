[
  {
    "name": "kaniko-builder",
    "image": "${ecr_url}:latest",
    "port_mappings": [
      {
        "container_port": "80"
      }
    ]
  }
]