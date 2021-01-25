## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| hsdp | >= 0.9.1 |
| random | >= 2.2.1 |

## Providers

| Name | Version |
|------|---------|
| hsdp | >= 0.9.1 |
| random | >= 2.2.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bastion\_host | Bastion host to use for SSH connections | `string` | n/a | yes |
| host\_name | Middle name for the host, default is random | `string` | `""` | no |
| image | The docker image to use | `string` | `"bitnami/kafka:latest"` | no |
| instance\_type | The instance type to use | `string` | `"t3.large"` | no |
| iops | IOPS to provision for EBS storage | `number` | `500` | no |
| key\_store | Akey store for SSL | <pre>object(<br>    { keystore = string,<br>    password = string }<br>  )</pre> | n/a | yes |
| mm2\_properties | mm2 properties file path | `string` | n/a | yes |
| nodes | Number of nodes | `number` | `1` | no |
| private\_key | Private key for SSH access | `string` | n/a | yes |
| tld | The tld for your host default is a dev | `string` | `"dev"` | no |
| trust\_store | Akey store for SSL | <pre>object(<br>    { truststore = string,<br>    password = string }<br>  )</pre> | n/a | yes |
| user | LDAP user to use for connections | `string` | n/a | yes |
| user\_groups | User groups to assign to cluster | `list(string)` | `[]` | no |
| volume\_size | The volume size to use in GB | `number` | `50` | no |

## Outputs

| Name | Description |
|------|-------------|
| kafka\_connect\_name\_nodes | Container Host DNS names of Kafka instances |
| kafka\_connect\_nodes | Container Host IP addresses of Kafka instances |
