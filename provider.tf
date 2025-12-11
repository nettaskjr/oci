terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 4.0"
    }
  }
}

# Configuração do provedor OCI
provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.api_private_key_path
  region           = var.region
}

# Configuração do provedor Cloudflare
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
