<img src="https://cdn.rawgit.com/hashicorp/terraform-website/master/content/source/assets/images/logo-hashicorp.svg" width="500px">

# HSDP Kafka mirror maker module

Module to create an Apache kafka mirror maker2 cluster deployed
on the HSDP Container Host infrastructure. 
Please take a look at kafka mirror maker 2 documentation

```hcl
module "kafka" {
  source = "github.com/philips-labs/terraform-hsdp-kafka-connect"

  nodes             = 3
  bastion_host      = "bastion.host"
  user              = "ronswanson"
  private_key       = file("~/.ssh/dec.key")
  user_groups       = ["ronswanson", "poc"]
  mm2_properties   = "~/mm2.properties"

  trust_store   = {
    truststore = "./kafkatruststore.jks"
    password   = "somepass"
  }

  key_store     = {
    keystore   = "./kafkakeystore.jks"
    password   = "somepass"
  }
}
```

__IMPORTANT SECURITY INFORMATION__
> This module currently **enables** only mTLS-SSL
> for source and target kafka clusters. 
> Operating and maintaining applications on Container Host is always
> your responsibility. This includes ensuring any security 
> measures are in place in case you need them.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| hsdp | >= 0.9.4 |
| null | >= 2.1.1 |
| random | >= 2.2.1 |

## Providers

| Name | Version |
|------|---------|
| hsdp | >= 0.9.4 |
| random | >= 2.2.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bastion\_host | Bastion host to use for SSH connections | `string` | n/a | yes |
| host\_name | Middle name for the host, default is random | `string` | `""` | no |
| image | The docker image to use | `string` | `"bitnami/kafka:latest"` | no |
| instance\_type | The instance type to use | `string` | `"t3.large"` | no |
| iops | IOPS to provision for EBS storage | `number` | `500` | no |
| key\_store | Akey store for SSL | <pre>object(<br>    { keystore  = string ,<br>      password  = string }<br>  )</pre> | n/a | yes |
| mm2\_properties | mm2 properties file path | `string` | n/a | yes |
| nodes | Number of nodes | `number` | `1` | no |
| private\_key | Private key for SSH access | `string` | n/a | yes |
| tld | The tld for your host default is a dev | `string` | `"dev"` | no |
| trust\_store | Akey store for SSL | <pre>object(<br>    { truststore  = string ,<br>      password    = string }<br>  )</pre> | n/a | yes |
| user | LDAP user to use for connections | `string` | n/a | yes |
| user\_groups | User groups to assign to cluster | `list(string)` | `[]` | no |
| volume\_size | The volume size to use in GB | `number` | `50` | no |



## Key Store object
This object has two properties that needs to be filled
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| keystore | The path of the keystore file in JKS format| `string` | none | yes |
| password | The password to be used for the key store | `string` | none | yes |

## trust Store object
This object has two properties that needs to be filled
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| truststore | The path of the truststore file in JKS format| `string` | none | yes |
| password | The password to be used for the trust store | `string` | none | yes |

## mm2.properties
Here is an example mm2.properties file
```
clusters = hsdp, openline
hsdp.bootstrap.servers=172.30.16.195:8282
openline.bootstrap.servers=ec2-3-237-7-189.compute-1.amazonaws.com:80
hsdp->openline.emit.heartbeats = false
hsdp->openline.enabled=true
openline->hsdp.enabled=false
config.storage.replication.factor = 1
offset.storage.replication.factor = 1
status.storage.replication.factor = 1
replication.factor = 1

```

Do not add the below keys to your mm2.properties file, these are auto added. 
```
security.protocol = 
ssl.endpoint.identification.algorithm =
ssl.truststore.location = /bitnami/kafka/config/certs/truststore.jks
ssl.truststore.password = ******
ssl.truststore.type = JKS
ssl.keystore.location = /bitnami/kafka/config/certs/mm.keystore.jks
ssl.keystore.password = ****
```


## Outputs

| Name | Description |
|------|-------------|
| kafka\_connect\_name\_nodes | Container Host DNS names of Kafka instances |
| kafka\_connect\_nodes | Container Host IP addresses of Kafka instances |

# Contact / Getting help

Krishna Prasad Srinivasan <krishna.prasad.srinivasan@philips.com>

# License

License is MIT
