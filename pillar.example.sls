iscdhcp:
  lookup:
    config:
      dhcpd:
        options:
          - domain-name "prod.be1-net.local"
          - domain-name-servers 8.8.8.8, 8.4.4.4
          - fqdn.no-client-update on
          - fqdn.rcode2 255
          - pxegrub code 150 = text
        next_server: 172.16.34.10
        filename: pxelinux.0
        allow:
          - booting
          - bootp
        omapi_port: 7911
        ddns_update_style: interim
        ddns_updates: "on"
        update_static_leases: "on"
        use_host_decl_names: "on"
        zones:
          - name: prod.be1-net.local.
            primary: 8.8.8.8
          - name: dev.be1-net.local.
            primary: 8.8.4.4
        file_prepend: |
            #a
            #b
            #c
            include "/etc/bind/rndc.key";
        file_append: "# some code"
  listen_interfaces:
    - eth0
  hosts:
    - name: anyhost
      mac: 00:50:56:2f:98:56
      ipaddr: 172.16.34.10
      domain: foreman.prod.be1-net.local
    - name: hisbrother
      mac: 00:50:56:2f:98:57
      ipaddr: 172.16.34.11
      domain: foremansp.prod.be1-net.local
      comment: brother of anyhost
      additional:
        - "#other settings"
        - "#here"
  subnets:
    - network: 172.16.34.0
      netmask: 255.255.255.0
      pools:
        - settings:
            - range 172.16.34.100 172.16.34.125
            - "#Foobar"
        - comment: This is a comment
          settings:
            - range 172.16.34.126 172.16.34.150
      additional:
        - option routers 172.16.34.1
    - network: 172.16.35.0
      netmask: 255.255.255.0
      pools:
        - settings:
            - range 172.16.35.100 172.16.35.125
