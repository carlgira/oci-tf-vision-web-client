# ---- Generate a random string to be used as password for ADB admin user
resource random_string adb-password {
  length      = 16
  upper       = true
  min_upper   = 2
  lower       = true
  min_lower   = 2
  numeric     = true
  min_numeric = 2
  special     = true
  min_special = 2
  override_special = "#+-="   # use only special characters in this list
}

resource random_string wallet-password {
  length      = 16
  upper       = true
  min_upper   = 2
  lower       = true
  min_lower   = 2
  numeric     = true
  min_numeric = 2
  special     = true
  min_special = 2
  override_special = "#+-="   # use only special characters in this list
}

resource oci_database_autonomous_database adb {
  db_workload              = var.adb_type
  license_model            = var.adb_license_model
  admin_password           = random_string.adb-password.result
  compartment_id           = var.compartment_ocid
  cpu_core_count           = var.adb_cpu_core_count
  data_storage_size_in_tbs = var.adb_data_storage_tbs
  db_name                  = var.adb_db_name

  #Optional
  display_name             = var.adb_display_name
  #whitelisted_ips          = [ oci_core_vcn.vcn.id ] FIX
}

resource oci_database_autonomous_database_wallet adb-wallet {
  autonomous_database_id = oci_database_autonomous_database.adb.id
  password               = random_string.wallet-password.result
  generate_type          = var.adb_wallet_type
  base64_encode_content  = "true"
}

resource local_file adb-wallet {
  content_base64 = oci_database_autonomous_database_wallet.adb-wallet.content
  filename       = var.adb_wallet_filename
}

