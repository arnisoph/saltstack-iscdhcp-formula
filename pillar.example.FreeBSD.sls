iscdhcp:
  lookup:
    config:
      dhcpd:
        options:
          - domain-name "test.lan"
          - domain-name-servers 172.16.16.1
        ddns_update_style: interim
        ddns_updates: "on"
        update_static_leases: "on"
        use_host_decl_names: "on"
        zones:
          - name: test.lan.
            primary: ns1.test.lan
            key: core_dhcp
          - name: 100.16.172.in-addr.arpa.
            primary: ns1.test.lan
            key: core_dhcp
        file_prepend: |
          key core_dhcp {
              algorithm HMAC-MD5.SIG-ALG.REG.INT;
              secret "ArOiJz0sTJTOCxjfZlS6jA==";
          };
  listen_interfaces:
    - bridge0
    - wlan0
  subnets:
    - network: 172.16.100.0
      netmask: 255.255.255.0
      pools:
        - settings:
          - range 172.16.100.50 172.16.100.150
      additional:
        - option routers 172.16.100.1
        - option broadcast-address 172.16.100.255
        - option domain-name-servers 172.16.100.1
        - option domain-name "test.lan"
    - network: 172.16.16.0
      netmask: 255.255.255.0
      pools:
        - settings:
          - range 172.16.16.10 172.16.16.150
      additional:
        - option routers 172.16.16.1
        - option broadcast-address 172.16.16.255
        - option domain-name-servers 172.16.16.1
        - option domain-name "test.lan"
