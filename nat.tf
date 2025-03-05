resource "hcloud_primary_ip" "natipv4" {
  name              = "nat"
  datacenter        = var.ip_location
  type              = "ipv4"
  auto_delete       = false
  delete_protection = false
  assignee_type     = "server"
}

resource "hcloud_primary_ip" "natipv6" {
  name              = "nat ipv6"
  datacenter        = var.ip_location
  type              = "ipv6"
  auto_delete       = false
  delete_protection = false
  assignee_type     = "server"
}

resource "hcloud_server" "nat" {
  name        = "nat"
  server_type = var.nat_server_type
  image       = "ubuntu-24.04"
  location    = var.location

  user_data = <<-EOF
    #!/bin/bash
    set -e

    echo "Creating networkd-dispatcher script..."
    cat << 'EOT' > /etc/networkd-dispatcher/routable.d/10-eth0-post-up
    #!/bin/bash

    echo 1 > /proc/sys/net/ipv4/ip_forward
    iptables -t nat -A POSTROUTING -s '${var.private_network_range}' -o eth0 -j MASQUERADE
    EOT

    chmod 0755 /etc/networkd-dispatcher/routable.d/10-eth0-post-up

    echo "Applying ip_forward settings..."
    sysctl -w net.ipv4.ip_forward=1

    echo "Restarting networkd-dispatcher to apply changes..."
    systemctl restart networkd-dispatcher
  EOF

  network {
    network_id = hcloud_network.network.id
    ip         = cidrhost(hcloud_network_subnet.control_plane.ip_range, 2)
    alias_ips  = []
  }

  depends_on = [
    hcloud_primary_ip.natipv4,
    hcloud_primary_ip.natipv6
  ]

  public_net {
    ipv4 = hcloud_primary_ip.natipv4.id
    ipv6 = hcloud_primary_ip.natipv6.id
  }
}

resource "hcloud_network_route" "nat" {
  network_id  = hcloud_network.network.id
  destination = "0.0.0.0/0"
  gateway     = cidrhost(hcloud_network_subnet.control_plane.ip_range, 2)

  depends_on = [
    hcloud_server.nat
  ]
}

resource "hcloud_firewall" "nat" {
  name = "nat"
  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_firewall_attachment" "nat" {
  firewall_id = hcloud_firewall.nat.id
  server_ids  = [hcloud_server.nat.id]
}
