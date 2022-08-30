# ------ Create 2 compute instances for web servers

resource "null_resource" "ReplaceVariables" {

  provisioner "local-exec" {
    command = "cp ${var.BootStrapFile_template_websrv} ${var.BootStrapFile_websrv}"
    working_dir = "${path.module}"
  }
  
  provisioner "local-exec" {
    command = "sed -i'.original' -e s/\\$ENDPOINT/${substr(oci_apigateway_deployment.export_ai-vision-service.endpoint, 8,length(oci_apigateway_deployment.export_ai-vision-service.endpoint) -9)}/g ${var.BootStrapFile_websrv}"
    working_dir = "${path.module}"
  }

  provisioner "local-exec" {
    command = "sed -i'.original' -e s/\\$PATH/${substr(oci_apigateway_deployment.export_ai-vision-service.specification[0].routes[0].path, 1,-1)}/g ${var.BootStrapFile_websrv}"
    working_dir = "${path.module}"
  }

  provisioner "local-exec" {
    command = "sed -i'.original' -e s/\\$MODEL_ID/${var.model_id}/g ${var.BootStrapFile_websrv}"
    working_dir = "${path.module}"
  }

  provisioner "local-exec" {
    command = "sed -i'.original' -e s/\\$LABELS/\"${var.labels}\"/g ${var.BootStrapFile_websrv}"
    working_dir = "${path.module}"
  }
}

resource oci_core_instance tf-demo07c-ws {
  depends_on = [
    null_resource.ReplaceVariables
  ]

  lifecycle {
    ignore_changes = [
      metadata
    ]
  }

  count               = 2
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[var.AD_websrvs[count.index] - 1]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "tf-demo07c-websrv${count.index+1}"
  shape               = "VM.Standard.E2.1"

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ImageOCID-ol7.images[0]["id"]
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.tf-demo07c-private-subnet.id
    hostname_label   = "websrv${count.index+1}"
    private_ip       = var.websrv_private_ips[count.index]  
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_file_websrv)
    user_data           = base64encode(file(var.BootStrapFile_websrv))
  }
}
