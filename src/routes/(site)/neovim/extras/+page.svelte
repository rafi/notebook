<script lang="ts">
	import type { Post } from '$lib/types';
	import { formatDate } from '$lib/util/time';

	let { data } = $props();

	const categories = $derived.by(() => {
		const cats: Record<string, Post[]> = {};
		for (const p of data.posts) {
			const category = p.slug.split('/')[1];
			if (!cats[category]) cats[category] = [];
			cats[category].push(p);
		}
		return cats;
	});
</script>

<div class="prose">
	<data.content />

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
