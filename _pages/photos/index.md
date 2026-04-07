---
layout: default
---

{% for photo in site.photos %}
<li>
	<a href="{{photo.url}}">
		<img src="/assets/photos/thumbs/{{photo.File | split: "." | first %}}-thumb.webp" width="200" />
	</a>
</li>
{% endfor %}