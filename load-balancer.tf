resource oci_load_balancer_load_balancer tf-demo07c-lb {
  compartment_id = var.compartment_ocid

  shape          = "flexible"
  shape_details {
    maximum_bandwidth_in_mbps = "100"
    minimum_bandwidth_in_mbps = "10"
  }

  subnet_ids = [
    oci_core_subnet.tf-demo07c-public-subnet.id
  ]

  display_name = "tf-demo07c-public-lb-ssl-termination"
}

# -- Load Balancer Managed Certificate
resource oci_load_balancer_certificate tf-demo07c-lb-certificate {
  count              = var.use_cert_cs == "false" ? 1 : 0  
  certificate_name   = "tf-demo07c-cert"
  load_balancer_id   = oci_load_balancer_load_balancer.tf-demo07c-lb.id
  ca_certificate     = file(var.file_ca_cert)
  passphrase         = ""
  private_key        = file(var.file_lb_key)
  public_certificate = file(var.file_lb_cert)

  lifecycle {
      create_before_destroy = true
  }
}

# -- Listener using Load Balancer Managed Certificate
resource oci_load_balancer_listener tf-demo07c-lb-listener1 {
  depends_on = [ oci_load_balancer_certificate.tf-demo07c-lb-certificate ]
  count                    = var.use_cert_cs == "false" ? 1 : 0  
  load_balancer_id         = oci_load_balancer_load_balancer.tf-demo07c-lb.id
  name                     = "tf-demo07c-lb-listener"
  default_backend_set_name = oci_load_balancer_backendset.tf-demo07c-lb-bes.name
  port                     = 443
  protocol                 = "HTTP"
  ssl_configuration {
    certificate_name        = "tf-demo07c-cert" 
    verify_peer_certificate = var.verify_peer_certificate
    verify_depth            = 5
    protocols               = [ "TLSv1.2" ]
  }
}
