---
layout: default
---

Logbook:
{% assign logbooks =  site.static_files | where: "type", "logbook" %}

<ul>
{% for logbook in logbooks %}
<li>
	<a href="{{logbook.basename}}">{{logbook.basename}}</a>
</li>
{% endfor %}
</ul>

Walks:
{% assign walks =  site.static_files | where: "type", "walk" %}

<ul>
{% for walk in walks %}
<li>
	<a href="{{walk.basename}}">{{walk.basename}}</a>
</li>
{% endfor %}
</ul>