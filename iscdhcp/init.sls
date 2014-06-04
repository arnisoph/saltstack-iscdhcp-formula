# vim: sts=2 ts=2 sw=2 et ai
{% from "iscdhcp/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('iscdhcp:lookup')) %}

iscdhcp:
  pkg:
    - installed
    - pkgs:
{% for p in datamap.pkgs %}
      - {{ p }}
{% endfor %}
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


#TODO create dhcp dir? might be necessary for Redhat family?

{% if datamap.config.defaults_file.manage|default(True) %} {# and salt['file.file_exists'](datamap.config.defaults_file.path) #}

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
{% endif %}

{% if datamap.config.dhcpd.manage|default(True) %}
{{ datamap.config.dhcpd.path }}:
  file:
    - managed
    - source: {{ datamap.config.dhcpd.template_path|default('salt://iscdhcp/files/dhcpd.conf') }}
    - template: {{ datamap.config.dhcpd.template_renderer|default('jinja') }}
    - mode: {{ datamap.config.dhcpd.mode|default('644') }}
    - user: {{ datamap.config.dhcpd.user|default('root') }}
    - group: {{ datamap.config.dhcpd.group|default('root') }}
{% endif %}

{% if datamap.config.hosts.manage|default(True)  %}
{{ datamap.config.hosts.path }}:
  file:
    - managed
    - source: {{ datamap.config.hosts.template_path|default('salt://iscdhcp/files/dhcpd.hosts') }}
    - template: {{ datamap.config.hosts.template_renderer|default('jinja') }}
    - mode: {{ datamap.config.hosts.mode|default('644') }}
    - user: {{ datamap.config.hosts.user|default('root') }}
    - group: {{ datamap.config.hosts.group|default('root') }}
{% endif %}

{% if datamap.config.subnets.manage|default(True) %}
{{ datamap.config.subnets.path }}:
  file:
    - managed
    - source: {{ datamap.config.subnets.template_path|default('salt://iscdhcp/files/dhcpd.subnets') }}
    - template: {{ datamap.config.subnets.template_renderer|default('jinja') }}
    - mode: {{ datamap.config.subnets.mode|default('644') }}
    - user: {{ datamap.config.subnets.user|default('root') }}
    - group: {{ datamap.config.subnets.group|default('root') }}
{% endif %}

