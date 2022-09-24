# ------ Create a SSH config file
resource local_file sshconfig {
  content = <<EOF
Host d07c-bastion
          Hostname ${oci_core_instance.bastion.public_ip}
          User opc
          IdentityFile ${var.ssh_private_key_file_bastion}
          StrictHostKeyChecking no
Host d07c-ws1
          Hostname ${oci_core_instance.ws[0].private_ip}
          User opc
          IdentityFile ${var.ssh_private_key_file_websrv}
          StrictHostKeyChecking no
          proxycommand /usr/bin/ssh -F sshcfg -W %h:%p d07c-bastion
Host d07c-ws2
          Hostname ${oci_core_instance.ws[1].private_ip}
          User opc
          IdentityFile ${var.ssh_private_key_file_websrv}
          StrictHostKeyChecking no
          proxycommand /usr/bin/ssh -F sshcfg -W %h:%p d07c-bastion
EOF

  filename = "sshcfg"
}

output ADB {
  value = <<EOF
  service console URL = ${oci_database_autonomous_database.adb.service_console_url}
        user      = ${var.adb_username}
        password  = ${random_string.adb-password.result}

  walltet-password: ${random_string.wallet-password.result}
EOF
}

# ------ Display the complete ssh commands needed to connect to the compute instances
output CONNECTIONS {
  value = <<EOF

  Wait a few minutes so that post-provisioning scripts can run on the compute instances
  Then you can use instructions below to connect

  1) ---- SSH connection to compute instances
     Run one of following commands on your Linux/MacOS desktop/laptop

     ssh -F sshcfg d07c-bastion             to connect to bastion host
     ssh -F sshcfg d07c-ws1                 to connect to Web server #1
     ssh -F sshcfg d07c-ws2                 to connect to Web server #2

  2) ---- Load balancer
    https://${oci_load_balancer_load_balancer.lb.ip_address_details[0].ip_address}/oci-vision-web-client/index.html
EOF
}
