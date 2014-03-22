{% from "iscdhcp/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('iscdhcp:lookup')) %}

iscdhcp:

