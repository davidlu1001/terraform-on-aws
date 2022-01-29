<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.73.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_lifecycle_hook.graceful_shutdown_asg_hook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_lifecycle_hook) | resource |
| [aws_iam_role.autoscaling_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_launch_template.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [template_cloudinit_config.cloud_config](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/cloudinit_config) | data source |
| [template_file.cloud_config](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ansible_branch"></a> [ansible\_branch](#input\_ansible\_branch) | Ansible default's branch | `string` | `"master"` | no |
| <a name="input_ansible_play"></a> [ansible\_play](#input\_ansible\_play) | Ansible play path to run | `string` | `""` | no |
| <a name="input_asg_cooldown"></a> [asg\_cooldown](#input\_asg\_cooldown) | The amount of time, in seconds, after a scaling activity completes before another scaling activity can start | `number` | `300` | no |
| <a name="input_asg_termination_policy"></a> [asg\_termination\_policy](#input\_asg\_termination\_policy) | n/a | `list(string)` | <pre>[<br>  "OldestLaunchTemplate",<br>  "OldestLaunchConfiguration",<br>  "AllocationStrategy",<br>  "OldestInstance",<br>  "Default"<br>]</pre> | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | n/a | `bool` | `false` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Cost Center to tag | `string` | `"Platform"` | no |
| <a name="input_credit_specification"></a> [credit\_specification](#input\_credit\_specification) | Specifies the credit option for CPU usage of a T2 or T3 instance. | `map` | <pre>{<br>  "cpu_credits": "standard"<br>}</pre> | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Desired instance count | `number` | `2` | no |
| <a name="input_disable_api_termination"></a> [disable\_api\_termination](#input\_disable\_api\_termination) | If `true`, enables EC2 Instance Termination Protection | `bool` | `false` | no |
| <a name="input_ebs_delete_on_termination"></a> [ebs\_delete\_on\_termination](#input\_ebs\_delete\_on\_termination) | n/a | `bool` | `true` | no |
| <a name="input_ebs_device_name"></a> [ebs\_device\_name](#input\_ebs\_device\_name) | ebs volume device name | `string` | `"/dev/xvdb"` | no |
| <a name="input_ebs_partition_type"></a> [ebs\_partition\_type](#input\_ebs\_partition\_type) | ebs volume partition type | `string` | `"ext4"` | no |
| <a name="input_ebs_snapshot"></a> [ebs\_snapshot](#input\_ebs\_snapshot) | snapshot ID to mount | `string` | `""` | no |
| <a name="input_ebs_volume_size"></a> [ebs\_volume\_size](#input\_ebs\_volume\_size) | ebs volume size in GB | `number` | `1` | no |
| <a name="input_ebs_volume_type"></a> [ebs\_volume\_type](#input\_ebs\_volume\_type) | ebs volume device type | `string` | `"gp2"` | no |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | ECS cluster name | `string` | `""` | no |
| <a name="input_enable_lifecycle_hook"></a> [enable\_lifecycle\_hook](#input\_enable\_lifecycle\_hook) | Should lifecycle hook be enabled? | `bool` | `false` | no |
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | Enable/disable detailed monitoring | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | `"prod"` | no |
| <a name="input_extra_cloud_config_content"></a> [extra\_cloud\_config\_content](#input\_extra\_cloud\_config\_content) | Extra cloud config content | `string` | `""` | no |
| <a name="input_extra_cloud_config_type"></a> [extra\_cloud\_config\_type](#input\_extra\_cloud\_config\_type) | Extra cloud config type | `string` | `"text/cloud-config"` | no |
| <a name="input_health_check_grace_period"></a> [health\_check\_grace\_period](#input\_health\_check\_grace\_period) | Time (in seconds) after instance comes into service before checking health | `number` | `600` | no |
| <a name="input_iam_instance_profile_arn"></a> [iam\_instance\_profile\_arn](#input\_iam\_instance\_profile\_arn) | Instance profile arn | `any` | n/a | yes |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | AMI Image ID | `any` | n/a | yes |
| <a name="input_instance_ebs_optimized"></a> [instance\_ebs\_optimized](#input\_instance\_ebs\_optimized) | When set to true the instance will be launched with EBS optimized turned on | `bool` | `true` | no |
| <a name="input_instance_initiated_shutdown_behavior"></a> [instance\_initiated\_shutdown\_behavior](#input\_instance\_initiated\_shutdown\_behavior) | Shutdown behavior for the instances. Can be `stop` or `terminate` | `string` | `"terminate"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type to use, e.g t2.small | `any` | n/a | yes |
| <a name="input_instance_types_override"></a> [instance\_types\_override](#input\_instance\_types\_override) | n/a | `list(string)` | `[]` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | SSH key name to use | `any` | n/a | yes |
| <a name="input_lifecycle_hook_heartbeat_timeout"></a> [lifecycle\_hook\_heartbeat\_timeout](#input\_lifecycle\_hook\_heartbeat\_timeout) | n/a | `number` | `1800` | no |
| <a name="input_load_balancers"></a> [load\_balancers](#input\_load\_balancers) | A list of elastic load balancer names to add to the autoscaling group names. | `list(string)` | `[]` | no |
| <a name="input_max_instance_lifetime"></a> [max\_instance\_lifetime](#input\_max\_instance\_lifetime) | The maximum amount of time, in seconds, that an instance can be in service, values must be either equal to 0 or between 604800 and 31536000 seconds. | `number` | `0` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Maxmimum instance count | `number` | `2` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum instance count | `number` | `2` | no |
| <a name="input_name"></a> [name](#input\_name) | The autoscaling group name, e.g cdn (the term asg will be prefixed) | `any` | n/a | yes |
| <a name="input_on_demand_base_capacity"></a> [on\_demand\_base\_capacity](#input\_on\_demand\_base\_capacity) | defining the number of OnDemand instances that you want as a basis (our minimum of instances to be safe with your minimum traffic for example). | `number` | `3` | no |
| <a name="input_on_demand_percentage_above_base_capacity"></a> [on\_demand\_percentage\_above\_base\_capacity](#input\_on\_demand\_percentage\_above\_base\_capacity) | defining the percentage of OnDemand instances compared to Spot instances beyond the base capacity (0 : 0% Spot, 100% On-demand). | `number` | `100` | no |
| <a name="input_protect_from_scale_in"></a> [protect\_from\_scale\_in](#input\_protect\_from\_scale\_in) | n/a | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `any` | n/a | yes |
| <a name="input_root_delete_on_termination"></a> [root\_delete\_on\_termination](#input\_root\_delete\_on\_termination) | n/a | `bool` | `true` | no |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | Root volume size in GB | `number` | `30` | no |
| <a name="input_route53_record_prefix"></a> [route53\_record\_prefix](#input\_route53\_record\_prefix) | DNS prefix to be used when creating a custom route53 record for instances created by the autoscaling group. This should match whatever is defined in our ansible inventory, e.g: ecs-consumer | `any` | n/a | yes |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | List of security groups | `list(string)` | n/a | yes |
| <a name="input_spot_allocation_strategy"></a> [spot\_allocation\_strategy](#input\_spot\_allocation\_strategy) | How to allocate capacity across the Spot pools. Valid values: lowest-price, capacity-optimized. | `string` | `"lowest-price"` | no |
| <a name="input_spot_instance_pools"></a> [spot\_instance\_pools](#input\_spot\_instance\_pools) | Number of Spot pools per availability zone to allocate capacity. EC2 Auto Scaling selects the cheapest Spot pools and evenly allocates Spot capacity across the number of Spot pools that you specify | `number` | `1` | no |
| <a name="input_spot_max_price"></a> [spot\_max\_price](#input\_spot\_max\_price) | Max spot price based on instance type | `map` | <pre>{<br>  "c5.2xlarge": 0.204,<br>  "c5.large": 0.051,<br>  "c5.xlarge": 0.102,<br>  "i3.2xlarge": 0.406,<br>  "i3.large": 0.102,<br>  "i3.xlarge": 0.202,<br>  "m5.large": 0.058,<br>  "r5.large": 0.076<br>}</pre> | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs | `list(string)` | n/a | yes |
| <a name="input_suspended_processes"></a> [suspended\_processes](#input\_suspended\_processes) | n/a | `list(string)` | <pre>[<br>  "AZRebalance"<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A list of tag blocks. Each element should have keys named key, value, and propagate\_at\_launch. | `list(any)` | `[]` | no |
| <a name="input_target_group_arns"></a> [target\_group\_arns](#input\_target\_group\_arns) | A list of aws\_alb\_target\_group ARNs, for use with Application Load Balancing. | `list(string)` | `[]` | no |
| <a name="input_vpc_domain"></a> [vpc\_domain](#input\_vpc\_domain) | n/a | `any` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `any` | n/a | yes |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | The zone ID to tag ecs instances | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_asg_arn"></a> [asg\_arn](#output\_asg\_arn) | n/a |
| <a name="output_asg_id"></a> [asg\_id](#output\_asg\_id) | n/a |
| <a name="output_asg_launch_template_arn"></a> [asg\_launch\_template\_arn](#output\_asg\_launch\_template\_arn) | n/a |
| <a name="output_asg_launch_template_default_version"></a> [asg\_launch\_template\_default\_version](#output\_asg\_launch\_template\_default\_version) | n/a |
| <a name="output_asg_launch_template_id"></a> [asg\_launch\_template\_id](#output\_asg\_launch\_template\_id) | n/a |
| <a name="output_asg_launch_template_latest_version"></a> [asg\_launch\_template\_latest\_version](#output\_asg\_launch\_template\_latest\_version) | n/a |
| <a name="output_name"></a> [name](#output\_name) | The cluster name, e.g cdn |
<!-- END_TF_DOCS -->
