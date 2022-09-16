variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "region" {
  default = "eu-frankfurt-1"
}
variable "authorized_ips_list" {}
variable "ssh_public_key_file_websrv" {}
variable "ssh_private_key_file_websrv" {}
variable "ssh_public_key_file_bastion" {}
variable "ssh_private_key_file_bastion" {}
variable "use_cert_cs" {}
variable "file_lb_cert" {}
variable "file_ca_cert" {}
variable "file_lb_key" {}
variable "cidr_vcn" {}
variable "cidr_public_subnet" {}
variable "cidr_private_subnet" {}
variable "bastion_private_ip" {}
variable "websrv_private_ips" {}
variable "AD_bastion" {}
variable "AD_websrvs" {}
variable "BootStrapFile_websrv" {}
variable "BootStrapFile_bastion" {}
variable "BootStrapFile_template_websrv" {}
variable "verify_peer_certificate" {}
variable "ocir_user_name" {}
variable "labels" {
  default = ""
}
variable "model_id" {
  default = ""
}
variable "ocir_user_auth_token" {}
variable "ocir_repo_name" {
  default = "ai-vision-functions"
}

variable "adb_username" {}
variable "adb_type" {}
variable "adb_cpu_core_count" {}
variable "adb_data_storage_tbs" {}
variable "adb_db_name" {}
variable "adb_display_name" {}

variable "adb_wallet_type" {}
variable "adb_wallet_filename" {}
variable "adb_license_model" {}

variable "vault_type" {}
variable "vault_display_name" {}
variable "key_key_shape_algorithm" {}
variable "key_key_shape_length" {}
variable "key_display_name" {}

data "oci_objectstorage_namespace" "get_namespace" {
  compartment_id = var.tenancy_ocid
}

locals {
  ocir_docker_repository = join("", [lower(lookup(data.oci_identity_regions.oci_regions.regions[0], "key" )), ".ocir.io"])
  ocir_namespace = lookup(data.oci_objectstorage_namespace.get_namespace, "namespace")
}

