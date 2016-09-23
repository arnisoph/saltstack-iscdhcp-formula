#!jinja|yaml

{% from "iscdhcp/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('iscdhcp:lookup')) %}

iscdhcp:
  pkg:
    - installed
    - pkgs: {{ datamap.pkgs }}
  service:
    - {{ datamap.service.state|default('running') }}
    - name: {{ datamap.service.name }}
    - enable: {{ datamap.service.enable|default(True) }}
    - watch:
{% for c in datamap.config.manage|default([]) %}
      - file: {{ datamap.config[c].path }} #TODO that doesn't look nice
{% endfor %}
    - require:
      - pkg: iscdhcp


#TODO create dhcp dir? might be necessary for RedHat family?

{% if 'defaults_file' in datamap.config.manage %} {# and salt['file.file_exists'](datamap.config.defaults_file.path) #}

# FreeBSD does not create dir /etc/rc.conf.d/
{{ datamap.config.defaults_file.path }}:
  file:
    - managed
    - makedirs: True
    - source: {{ datamap.config.defaults_file.template_path|default('salt://iscdhcp/files/defaults_file.' ~ salt['grains.get']('os_family')) }}
    - template: {{ datamap.config.defaults_file.template_renderer|default('jinja') }}
    - mode: {{ datamap.config.defaults_file.mode|default('644') }}
    - user: {{ datamap.config.defaults_file.user|default('root') }}
    - group: {{ datamap.config.defaults_file.group|default('root') }}
    - require_in:
      - pkg: iscdhcp
{% endif %}

{% if 'systemd_file' in datamap.config.manage %}
{{ datamap.config.systemd_file.path }}:
  file:
    - managed
    - makedirs: True
    - source: {{ datamap.config.systemd_file.template_path|default('salt://iscdhcp/files/systemd_file.' ~ salt['grains.get']('os_family')) }}
    - template: {{ datamap.config.systemd_file.template_renderer|default('jinja') }}
    - mode: {{ datamap.config.systemd_file.mode|default('644') }}
    - user: {{ datamap.config.systemd_file.user|default('root') }}
    - group: {{ datamap.config.systemd_file.group|default('root') }}
service.systemctl_reload:
  module:
    - wait
    - watch:
      - file: {{ datamap.config.systemd_file.path }}
    - require_in:
      - service: iscdhcp
{% endif %}

{% if 'dhcpd' in datamap.config.manage %}
{{ datamap.config.dhcpd.path }}:
  file:
    - managed
    - source: {{ datamap.config.dhcpd.template_path|default('salt://iscdhcp/files/dhcpd.conf') }}
    - template: {{ datamap.config.dhcpd.template_renderer|default('jinja') }}
    - mode: {{ datamap.config.dhcpd.mode|default('644') }}
    - user: {{ datamap.config.dhcpd.user|default('root') }}
    - group: {{ datamap.config.dhcpd.group|default('root') }}
{% endif %}

{% if 'failover' in datamap.config.manage %}
{{ datamap.config.failover.path }}:
  file:
    - managed
    - source:   {{ datamap.config.failover.template_path|default('salt://iscdhcp/files/dhcpd.failover') }}
    - template: {{ datamap.config.failover.template_renderer|default('jinja') }}
    - mode:     {{ datamap.config.failover.mode|default('644') }}
    - user:     {{ datamap.config.failover.user|default('root') }}
    - group:    {{ datamap.config.failover.group|default('root') }}
{% endif %}

{% if 'hosts' in datamap.config.manage %}
{{ datamap.config.hosts.path }}:
  file:
    - managed
    - source: {{ datamap.config.hosts.template_path|default('salt://iscdhcp/files/dhcpd.hosts') }}
    - template: {{ datamap.config.hosts.template_renderer|default('jinja') }}
    - mode: {{ datamap.config.hosts.mode|default('644') }}
    - user: {{ datamap.config.hosts.user|default('root') }}
    - group: {{ datamap.config.hosts.group|default('root') }}
{% endif %}

{% if 'subnets' in datamap.config.manage %}
{{ datamap.config.subnets.path }}:
  file:
    - managed
    - source: {{ datamap.config.subnets.template_path|default('salt://iscdhcp/files/dhcpd.subnets') }}
    - template: {{ datamap.config.subnets.template_renderer|default('jinja') }}
    - mode: {{ datamap.config.subnets.mode|default('644') }}
    - user: {{ datamap.config.subnets.user|default('root') }}
    - group: {{ datamap.config.subnets.group|default('root') }}
{% endif %}

{% if 'pxe_subnets' in datamap.config.manage %}
{{ datamap.config.pxe_subnets.path }}:
  file:
    - managed
    - source: {{ datamap.config.subnets.template_path|default('salt://iscdhcp/files/dhcpd.subnets.pxe') }}
    - template: {{ datamap.config.subnets.template_renderer|default('jinja') }}
    - mode: {{ datamap.config.subnets.mode|default('644') }}
    - user: {{ datamap.config.subnets.user|default('root') }}
    - group: {{ datamap.config.subnets.group|default('root') }}
{% endif %}

