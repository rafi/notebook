<script>
	import { formatDate } from '$lib/util/time'

	export let data
</script>

<svelte:head>
	<title>rafi's blog</title>
</svelte:head>

<h1><small>~</small>/blog</h1>

<section>
	<ul class="posts">
		{#each data.posts as post}
			<li class="post">
				<a href={post.slug} class="title">{post.title}</a>
				<p class="date">{formatDate(post.date)}</p>
				{#if post.description}
					<p class="description">{post.description}</p>
				{/if}
			</li>
		{/each}
	</ul>
</section>
