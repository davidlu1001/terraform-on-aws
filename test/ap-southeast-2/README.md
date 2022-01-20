<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.72.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.dynamodb_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_resourcegroups_group.resourcegroups_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourcegroups_group) | resource |
| [aws_s3_bucket.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_kms_alias.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_alias) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [terraform_remote_state.dns-test](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.test-adroitcreations-org](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | n/a | `string` | `"500955583076"` | no |
| <a name="input_adroitcreations-org-root"></a> [adroitcreations-org-root](#input\_adroitcreations-org-root) | n/a | `string` | `"adroitcreations.org"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | `"test"` | no |
| <a name="input_force_destroy_state"></a> [force\_destroy\_state](#input\_force\_destroy\_state) | Force destroy the s3 bucket containing state files? | `bool` | `true` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The project namespace to use for unique resource naming | `string` | `"app"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"ap-southeast-2"` | no |
| <a name="input_subnet_octets"></a> [subnet\_octets](#input\_subnet\_octets) | n/a | `string` | `"172.21"` | no |
| <a name="input_test-adroitcreations-org"></a> [test-adroitcreations-org](#input\_test-adroitcreations-org) | n/a | `string` | `"test.adroitcreations.org"` | no |
| <a name="input_vpc_subnet"></a> [vpc\_subnet](#input\_vpc\_subnet) | n/a | `string` | `"172.21.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config"></a> [config](#output\_config) | n/a |
<!-- END_TF_DOCS -->