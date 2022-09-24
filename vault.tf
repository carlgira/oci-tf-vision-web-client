resource "oci_kms_vault" ai_model_vault {
    compartment_id = var.compartment_ocid
    display_name = var.vault_display_name
    vault_type = var.vault_type 
}

resource "oci_kms_key" ai_model_vault_key {
    compartment_id = var.compartment_ocid
    display_name = var.key_display_name
    key_shape {
        algorithm = var.key_key_shape_algorithm
        length = var.key_key_shape_length
    }
    management_endpoint = oci_kms_vault.ai_model_vault.management_endpoint
}

resource oci_vault_secret ai_model_atp_password {
    compartment_id = var.compartment_ocid
    key_id = oci_kms_key.ai_model_vault_key.id
    secret_content {
        content_type = "BASE64"
        content = base64encode(random_string.adb-password.result)
    }
    secret_name    = "atp_password"
    vault_id       = oci_kms_vault.ai_model_vault.id
}

resource oci_vault_secret ai_model_atp_wallet_password {
    compartment_id = var.compartment_ocid
    key_id = oci_kms_key.ai_model_vault_key.id
    secret_content {
        content_type = "BASE64"
        content = base64encode(random_string.wallet-password.result)
    }
    secret_name    = "atp_wallet_password"
    vault_id       = oci_kms_vault.ai_model_vault.id
}
