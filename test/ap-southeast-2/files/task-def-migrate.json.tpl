[
    {
        "name": "migrate",
        "image": "${docker_image}:${image_tag}",
        "essential": true,
        "cpu": 64,
        "memory": 64,
        "command": [
            "python3",
            "manage.py",
            "migrate",
            "--no-input"
        ],
        "environment": [
            {
                "name": "DJANGO_SETTINGS_MODULE",
                "value": "todobackend.settings_release"
            },
            {
                "name": "MYSQL_HOST",
                "value": "${rds_hostname}"
            },
            {
                "name": "MYSQL_USER",
                "value": "${rds_username}"
            },
            {
                "name": "MYSQL_DATABASE",
                "value": "${rds_db_name}"
            }
        ],
        "secrets": [
            {
                "name": "MYSQL_PASSWORD",
                "valueFrom": "${rds_password}"
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/${name}",
                "awslogs-region": "${region}",
                "awslogs-stream-prefix": "ecs-docker-${name}"
            }
        }
    }
]