module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  #create_db_instance = false

  identifier = "app"

  engine               = "mysql"
  engine_version       = "8.0.25"
  family               = "mysql8.0"
  major_engine_version = "8.0"
  instance_class       = "db.t3.micro"

  allocated_storage     = 5
  max_allocated_storage = 100
  storage_encrypted     = false

  name     = var.rds_db_name
  username = var.rds_username
  password = aws_ssm_parameter.database_password_parameter.value
  port     = "3306"

  iam_database_authentication_enabled = true
  multi_az                            = false
  subnet_ids                          = module.vpc.private_subnets
  vpc_security_group_ids              = [aws_security_group.rds.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  #performance_insights_enabled          = true
  #performance_insights_retention_period = 7
  performance_insights_enabled = false

  # Enable
  #create_monitoring_role                = true
  #monitoring_interval                   = 60

  # Disable
  create_monitoring_role = false
  monitoring_interval    = 0

  tags = local.tags

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}
