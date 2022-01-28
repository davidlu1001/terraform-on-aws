# General
environment           = "test"
account_id            = "500955583076"
region                = "ap-southeast-2"
force_destroy_state   = true
namespace             = "app"
root_domain           = "adroitcreations.org"
zone_id               = "Z04806802JR0EAMPN7QPK"
subnet_octets         = "172.21"
log_retention_in_days = 1

# EC2
ssh_pubkey_file  = "~/.ssh/id_rsa_ac.pub"
instance_type    = "t3a.micro"
root_volume_size = 30

# DB
db_instance_type                      = "db.t3.micro"
multi_az                              = false
db_storage_encrypted                  = false
backup_retention_period               = 0
skip_final_snapshot                   = true
deletion_protection                   = false
performance_insights_enabled          = false
performance_insights_retention_period = 0
