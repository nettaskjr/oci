# Busca o namespace do Object Storage, necessário para criar um bucket.
data "oci_objectstorage_namespace" "ns" {
  compartment_id = var.compartment_ocid
}

# Cria o bucket no OCI Object Storage para armazenar o arquivo de estado do Terraform.
resource "oci_objectstorage_bucket" "tf_state_bucket" {
  # O bucket deve estar no mesmo compartimento que os outros recursos.
  compartment_id = var.compartment_ocid
  name           = var.state_bucket_name
  namespace      = data.oci_objectstorage_namespace.ns.namespace

  # Garante que o bucket não seja acessível publicamente.
  access_type = "NoPublicAccess"

  # Habilita o versionamento para proteger o arquivo de estado contra exclusão ou corrupção.
  versioning = "Enabled"
}