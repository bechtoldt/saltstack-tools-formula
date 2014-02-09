{% import_yaml "tools/defaults.yaml" as rawmap %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('tools:lookup')) %}

{% for t in salt['pillar.get']('tools:manage') %}
tool-{{ t['name'] }}:
  pkg:
    - installed
  {% if datamap['tools'][t['name']] is not defined or datamap['tools'][t['name']]['pkgs'] is not defined %}
    - name: {{ t['name'] }}
  {% else %}
    - pkgs:
  {% for p in datamap['tools'][t['name']]['pkgs'] %}
      - {{ p }}
  {% endfor %}
  {% endif %}
{% endfor %}