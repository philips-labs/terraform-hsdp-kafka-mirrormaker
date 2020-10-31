terraform {
  required_version = ">= 0.13.0"
  required_providers {
    hsdp = {
      source  = "philips-software/hsdp"
      version = ">= 0.6.6"
    }
    random = {
      source  = "random"
      version = ">= 2.2.1"
    }
    null = {
      source  = "null"
      version = ">= 2.1.1"
    }
  }
}
