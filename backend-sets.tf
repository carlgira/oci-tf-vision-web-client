resource oci_load_balancer_backendset lb-bes {
  name             = "lb-bes"
  load_balancer_id = oci_load_balancer_load_balancer.lb.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = "80"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/index.php"
    retries             = 1
    interval_ms         = "10000"
  }
}

resource oci_load_balancer_backend lb-be {
  count            = 2
  load_balancer_id = oci_load_balancer_load_balancer.lb.id
  backendset_name  = oci_load_balancer_backendset.lb-bes.name
  ip_address       = oci_core_instance.ws[count.index].private_ip
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}