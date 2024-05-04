<script>
	import { formatDate } from '$lib/util/time';

	export let data;
</script>

<svelte:head>
	<title>rafi's blog</title>
</svelte:head>

<h1><small>~</small>/blog</h1>

<section>
	<ul class="cards">
		{#await data.posts}
			Loading posts...
		{:then posts}
			{#each posts as post}
				<li>
					<a href={post.slug}>
						{post.title}
						{#if post.date}
							<span class="date">{formatDate(post.date)}</span>
						{/if}
					</a>
					{#if post.description}
						<span class="description">{post.description}</span>
					{/if}
				</li>
			{/each}
		{:catch error}
			<p>error loading comments: {error.message}</p>
		{/await}
	</ul>
</section>
