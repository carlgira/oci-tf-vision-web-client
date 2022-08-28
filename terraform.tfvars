# ============== UPDATE INFORMATION BELOW BEFORE USE

# ---- List of authorized public IPs for security ingress rules
authorized_ips_list = [ 
    { cidr = "0.0.0.0/0", desc = "Access from everywhere" }
]

# ---- SSH key pairs
ssh_public_key_file_websrv   = "./certs/instance/key.pem.pub"
ssh_private_key_file_websrv  = "./certs/instance/key.pem"
ssh_public_key_file_bastion  = "./certs/instance/key.pem.pub"
ssh_private_key_file_bastion = "./certs/instance/key.pem"

# ---- Certificate for Load Balancer listener in HTTPS mode
# false: create and use a "Load Balancer Managed Certificate"
# true:  use an exising "Certificate Service Managed Certificate" (already created/imported)
use_cert_cs    = "false"

# ---- Create certificate at LB level (only used if use_cert_cs = false)
file_lb_cert = "./certs/load-balancer/loadbalancer.crt"
file_ca_cert = "./certs/load-balancer/ca.crt"
file_lb_key  = "./certs/load-balancer/loadbalancer.key"

# ============== NO UPDATE NEEDED BELOW

# ---- IP addresses
cidr_vcn             = "10.0.0.0/16"
cidr_public_subnet   = "10.0.0.0/24"
cidr_private_subnet  = "10.0.1.0/24"
bastion_private_ip   = "10.0.0.2"
websrv_private_ips   = [ "10.0.1.2", "10.0.1.3" ]

# ---- IP addresses
AD_bastion           = "1"
AD_websrvs           = [ "1", "2" ]

# ---- Cloud-init post-provisioning scripts
BootStrapFile_websrv         = "scripts/bootstrap_websrv.sh"
BootStrapFile_bastion        = "scripts/bootstrap_bastion.sh"

# ---- Verify certificate on Client browser
verify_peer_certificate = "false"
