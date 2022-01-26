[
    {
        "name": "${name}",
        "image": "${docker_image}:${image_tag}",
        "essential": true,
        "cpu": 128,
        "memory": 512,
        "portMappings": [
            {
                "containerPort": 8000,
                "hostPort": 0,
                "protocol": "tcp"
            }
        ],
        "mountPoints": [
            {
                "sourceVolume": "public",
                "containerPath": "/public"
            }
        ],
        "command": [
            "uwsgi",
            "--http=0.0.0.0:8000",
            "--module=todobackend.wsgi",
            "--master",
            "--check-static=/public",
            "--die-on-term",
            "--processes=4",
            "--threads=2"
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
                "name": "MYSQL_PASSWORD",
                "value": "${rds_password}"
            },
            {
                "name": "MYSQL_DATABASE",
                "value": "${rds_db_name}"
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
    },
    {
        "name": "collectstatic",
        "image": "${docker_image}:${image_tag}",
        "essential": false,
        "cpu": 10,
        "memory": 64,
        "mountPoints": [
            {
                "sourceVolume": "public",
                "containerPath": "/public"
            }
        ],
        "command": [
            "python3",
            "manage.py",
            "collectstatic",
            "--no-input"
        ],
        "environment": [
            {
                "name": "DJANGO_SETTINGS_MODULE",
                "value": "todobackend.settings_release"
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