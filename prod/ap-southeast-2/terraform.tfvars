# General
environment           = "prod"
account_id            = "542859091916"
region                = "ap-southeast-2"
force_destroy_state   = false
namespace             = "app"
root_domain           = "adroitcreations.org"
zone_id               = "Z06712471MKT0QE4UZNT7"
subnet_octets         = "172.18"
log_retention_in_days = 7

# EC2
ssh_pubkey_file  = "~/.ssh/id_rsa_ac.pub"
instance_type    = "t3a.small"
root_volume_size = 50

# ECR
ecr_image_days_untagged = 14
ecr_image_count_tagged  = 30

# DB
db_instance_type                      = "db.t3.large"
multi_az                              = true
db_storage_encrypted                  = true
backup_retention_period               = 7
skip_final_snapshot                   = false
deletion_protection                   = true
performance_insights_enabled          = true
performance_insights_retention_period = 7
