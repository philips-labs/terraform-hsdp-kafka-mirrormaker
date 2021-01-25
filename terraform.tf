terraform {
  required_version = ">= 0.13.0"
  required_providers {
    hsdp = {
      source  = "philips-software/hsdp"
      version = ">= 0.9.1"
    }
    random = {
      source  = "random"
      version = ">= 2.2.1"
    }
  }
}
