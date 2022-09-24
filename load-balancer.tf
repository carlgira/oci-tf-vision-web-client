resource oci_load_balancer_load_balancer lb {
  compartment_id = var.compartment_ocid

  shape          = "flexible"
  shape_details {
    maximum_bandwidth_in_mbps = "100"
    minimum_bandwidth_in_mbps = "10"
  }

  subnet_ids = [
    oci_core_subnet.public-subnet.id
  ]

  display_name = "public-lb-ssl-termination"
}

# -- Load Balancer Managed Certificate
resource oci_load_balancer_certificate lb-certificate {
  count              = var.use_cert_cs == "false" ? 1 : 0  
  certificate_name   = "cert"
  load_balancer_id   = oci_load_balancer_load_balancer.lb.id
  ca_certificate     = file(var.file_ca_cert)
  passphrase         = ""
  private_key        = file(var.file_lb_key)
  public_certificate = file(var.file_lb_cert)

  lifecycle {
      create_before_destroy = true
  }
}

# -- Listener using Load Balancer Managed Certificate
resource oci_load_balancer_listener lb-listener1 {
  depends_on = [ oci_load_balancer_certificate.lb-certificate ]
  count                    = var.use_cert_cs == "false" ? 1 : 0  
  load_balancer_id         = oci_load_balancer_load_balancer.lb.id
  name                     = "lb-listener"
  default_backend_set_name = oci_load_balancer_backendset.lb-bes.name
  port                     = 443
  protocol                 = "HTTP"
  ssl_configuration {
    certificate_name        = "cert" 
    verify_peer_certificate = var.verify_peer_certificate
    verify_depth            = 5
    protocols               = [ "TLSv1.2" ]
  }
}
