---
layout: page
title: Blog Archives
sitemap: true
---

<div class="archives" itemscope itemtype="http://schema.org/Blog">
{% for post in site.posts %}
{% if post.layout == 'post' %}
	{% include archive_post.html %}
{% endif %}
{% endfor %}
  </ul>
</div>
