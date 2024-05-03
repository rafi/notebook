<script>
	import { formatDate } from '$lib/util/time';

	export let data;
</script>

<svelte:head>
	<title>rafi's blog</title>
</svelte:head>

<h1><small>~</small>/blog</h1>

<section>
	<ul class="posts">
		{#await data.posts}
			Loading posts...
		{:then posts}
			{#each posts as post}
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
		{:catch error}
			<p>error loading comments: {error.message}</p>
		{/await}
	</ul>
</section>
