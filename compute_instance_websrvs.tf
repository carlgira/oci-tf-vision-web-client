# ------ Create 2 compute instances for web servers

resource oci_core_instance ws {
  lifecycle {
    ignore_changes = [
      metadata
    ]
  }

  count               = 2
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[var.AD_websrvs[count.index] - 1]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "websrv${count.index+1}"
  shape               = "VM.Standard.E2.1"

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ImageOCID-ol7.images[0]["id"]
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.private-subnet.id
    hostname_label   = "websrv${count.index+1}"
    private_ip       = var.websrv_private_ips[count.index]  
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_file_websrv)
  }

  provisioner "file" {
    source      = var.BootStrapFile_websrv
    destination = "/tmp/script.sh"
  }

  connection {
    type        = "ssh"
    host        = "${self.private_ip}"
    user        = "opc"
    private_key = "${file(var.ssh_private_key_file_websrv)}"

    bastion_host        = "${oci_core_instance.bastion.public_ip}"
    bastion_user        = "opc"
    bastion_private_key = "${file(var.ssh_private_key_file_bastion)}"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh ${substr(oci_apigateway_deployment.export_ai-vision-service.endpoint, 8,length(oci_apigateway_deployment.export_ai-vision-service.endpoint) -9)} ${substr(oci_apigateway_deployment.export_ai-vision-service.specification[0].routes[0].path, 1,-1)} ${var.model_id}  '${var.labels}' ",
    ]
  }
}
