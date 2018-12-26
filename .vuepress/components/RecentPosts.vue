<template>
	<div>
		<ul>
			<li v-for="post in recentPosts">
				<router-link :to="post.path">{{ post.title }}</router-link>
			</li>
		</ul>
	</div>
</template>

<script>
export default {
	props: ['featured', 'children'],

	data() {
		return {};
	},

	computed: {
		recentPosts() {
			let posts = this.$site.pages;

			if (this.featured) {
				posts = posts.filter(a => {
					return !!a.frontmatter.featured
				})
			}

			if (this.children) {
				let current = this.$page.path;
				posts = posts.filter(a => {
					if (a.path == current) return false
					return a.path.indexOf(current) >= 0;
				})
			}

			posts = posts.sort((a,b) => {
				return new Date(b.frontmatter.date) - new Date(a.frontmatter.date);
			});

			return posts;
		}
	}
}
</script>
