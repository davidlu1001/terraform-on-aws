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
| [aws_eip_association.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association) | resource |
| [aws_instance.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_route53_record.main_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_eip.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eip) | data source |
| [template_cloudinit_config.cloud_config](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/cloudinit_config) | data source |
| [template_file.cloud_config](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | n/a | `bool` | `false` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | AZ where the instance should be placed. Should match the same subnet AZ | `any` | n/a | yes |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Cost Center to tag | `string` | `"Platform"` | no |
| <a name="input_ebs_delete_on_termination"></a> [ebs\_delete\_on\_termination](#input\_ebs\_delete\_on\_termination) | n/a | `bool` | `true` | no |
| <a name="input_ebs_device_name"></a> [ebs\_device\_name](#input\_ebs\_device\_name) | ebs volume device name | `string` | `"/dev/xvdb"` | no |
| <a name="input_ebs_volume_size"></a> [ebs\_volume\_size](#input\_ebs\_volume\_size) | ebs volume size in GB | `number` | `1` | no |
| <a name="input_ebs_volume_type"></a> [ebs\_volume\_type](#input\_ebs\_volume\_type) | ebs volume device type | `string` | `"gp2"` | no |
| <a name="input_eip_allocation_id"></a> [eip\_allocation\_id](#input\_eip\_allocation\_id) | Elastic IP ID to allocate to the instance. | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `any` | n/a | yes |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Extra tags assigned to the EC2 instance. | `map` | `{}` | no |
| <a name="input_iam_instance_profile_arn"></a> [iam\_instance\_profile\_arn](#input\_iam\_instance\_profile\_arn) | Instance profile arn | `string` | `""` | no |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | AMI Image ID | `any` | n/a | yes |
| <a name="input_instance_ebs_optimized"></a> [instance\_ebs\_optimized](#input\_instance\_ebs\_optimized) | When set to true the instance will be launched with EBS optimized turned on | `bool` | `true` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type to use, e.g t3a.small | `any` | n/a | yes |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | SSH key name to use | `any` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The instance name | `any` | n/a | yes |
| <a name="input_private_ip"></a> [private\_ip](#input\_private\_ip) | The private IP address to associate to the instance, e.g. 10.0.1.0 | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `any` | n/a | yes |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | Root volume size in GB | `number` | `50` | no |
| <a name="input_route53_record_prefix"></a> [route53\_record\_prefix](#input\_route53\_record\_prefix) | DNS prefix to be used when creating a custom route53 record for instances created by the autoscaling group. This should match whatever is defined in our ansible inventory, e.g: ecs-consumer | `string` | `""` | no |
| <a name="input_router53_allow_overwrite"></a> [router53\_allow\_overwrite](#input\_router53\_allow\_overwrite) | Allows TF to overwrite any prior record, to become the source-of-truth. | `bool` | `true` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | List of security groups | `list(string)` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | subnet\_id | `any` | n/a | yes |
| <a name="input_vpc_domain"></a> [vpc\_domain](#input\_vpc\_domain) | n/a | `any` | n/a | yes |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Hosted Zone id | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | n/a |
| <a name="output_instance_private_dns"></a> [instance\_private\_dns](#output\_instance\_private\_dns) | n/a |
| <a name="output_instance_private_ip"></a> [instance\_private\_ip](#output\_instance\_private\_ip) | n/a |
| <a name="output_instance_public_dns"></a> [instance\_public\_dns](#output\_instance\_public\_dns) | n/a |
| <a name="output_instance_public_ip"></a> [instance\_public\_ip](#output\_instance\_public\_ip) | n/a |
| <a name="output_instance_security_groups"></a> [instance\_security\_groups](#output\_instance\_security\_groups) | n/a |
<!-- END_TF_DOCS -->
