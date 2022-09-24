# -------- get the list of available ADs
data oci_identity_availability_domains ADs {
  compartment_id = var.tenancy_ocid
}

# --------- Get the OCID for the more recent for Oracle Linux 7.x disk image
data oci_core_images ImageOCID-ol7 {
  compartment_id           = var.compartment_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "7.9"

  # filter to avoid Oracle Linux 7.x images for GPU and ARM
  filter {
    name   = "display_name"
    values = ["^.*Oracle-Linux-7.9-202.*$"]
    regex  = true
  }
}

data "oci_load_balancer_hostnames" "lb_hostnames_ds" {
    load_balancer_id = oci_load_balancer_load_balancer.lb.id
}

data "oci_apigateway_gateway" "api_gateway_ds" {
    gateway_id = oci_apigateway_gateway.export_ai-service-gateway.id
}

data "oci_identity_regions" "oci_regions" {
  filter {
    name = "name" 
    values = [var.region]
  }
}
