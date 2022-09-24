resource oci_functions_application export_pythonapp {
  compartment_id = var.compartment_ocid
  display_name = "pythonapp"
  subnet_ids = [
    oci_core_subnet.private-subnet.id
  ]
  config = {
    "ATP_USERNAME" = var.adb_username
    "DB_DNS" = [for profile in oci_database_autonomous_database.adb.connection_strings[0].profiles : profile.display_name  if upper(profile.consumer_group) == "HIGH"][0]
    "PASSWORD_SECRET_OCID" = oci_vault_secret.ai_model_atp_password.id
    "WALLET_PASSWORD_SECRET_OCID" = oci_vault_secret.ai_model_atp_wallet_password.id
    "TNS_ADMIN": "/function/wallet"
  }
}

resource oci_functions_function export_pythonfn {
  depends_on = [null_resource.function_Push2OCIR]
  application_id = oci_functions_application.export_pythonapp.id
  display_name = "pythonfn"
  image = "${local.ocir_docker_repository}/${local.ocir_namespace}/${var.ocir_repo_name}/ai-vision-func:0.0.1"
  memory_in_mbs      = "256"
  config = { 
      "REGION" : "${var.region}"
    }
  timeout_in_seconds = "30"
}
# oci_functions_function.export_pythonfn