---
title: Home
---
# Rafael Bodill's Knowledge-Base

My goals for this knowledge-base is laying down all I know about the Unix ecosystem.

## Featured Posts <Badge text="latest" />

<ul>
	<li v-for="page in this.$site.pages" v-if="page.frontmatter.featured">
		<router-link :to="page.path">{{ page.title }}</router-link>
	</li>
</ul>
