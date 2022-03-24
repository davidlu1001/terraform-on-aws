module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = var.namespace

  engine               = "mysql"
  engine_version       = "8.0.25"
  family               = "mysql8.0"
  major_engine_version = "8.0"
  instance_class       = var.db_instance_type

  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage
  storage_encrypted     = var.db_storage_encrypted

  name     = var.rds_db_name
  username = var.rds_username
  password = aws_ssm_parameter.database_password_parameter.value
  port     = "3306"

  iam_database_authentication_enabled = true
  multi_az                            = var.multi_az
  subnet_ids                          = module.vpc.private_subnets
  vpc_security_group_ids              = [aws_security_group.rds.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period

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
