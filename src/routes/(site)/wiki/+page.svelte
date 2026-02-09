<script lang="ts">
	import { formatDate } from '$lib/util/time';

	let { data } = $props();
</script>

<svelte:head>
	<title>rafi's wiki</title>
</svelte:head>

<h1><small>~</small>/wiki</h1>

<section>
	<ul class="wiki">
		{#each data.posts as post}
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
</section>
