<script lang="ts">
	import { run } from 'svelte/legacy';

	import type { Post } from '$lib/types';
	import { formatDate } from '$lib/util/time';

	let { data } = $props();

	let categories: Record<string, Post[]> = $state({});

	run(() => {
		data.posts.map((p) => {
			const category = p.slug.split('/')[1];
			if (!categories[category]) categories[category] = [];
			categories[category].push(p);
		});
	});
</script>

<div class="prose">
	{@html `<style>${data.page.css.code}</style>`}
	{@html data.page.html}

	<section>
		{#each Object.keys(categories) as category}
			<h2>{category.charAt(0).toUpperCase() + category.slice(1)}</h2>
			<ul>
				{#each categories[category] as post}
					<li class="post">
						<a href={post.slug} class="title">{post.title}</a>
						{#if post.date}
							<p class="date">{formatDate(post.date)}</p>
						{/if}
						{#if post.description}
							<p class="description">{post.description}</p>
						{/if}
					</li>
				{/each}
			</ul>
		{/each}
	</section>
</div>

<ul class="cards page-nav">
<li><a href="./plugins">← Plugins</a></li>
<li><a href="./packages">Packages →</a></li>
</ul>
