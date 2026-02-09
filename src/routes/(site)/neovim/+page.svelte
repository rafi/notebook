<script lang="ts">
	import { formatDate } from '$lib/util/time';

	let { data } = $props();
</script>

<svelte:head>
	<title>rafi/neovim</title>
</svelte:head>

<h1>
	<small>~</small>/neovim config
	<a href="https://github.com/rafi/vim-config">
		<img
			class="badge"
			src="https://badgen.net/github/stars/rafi/vim-config"
			alt="GitHub repo stars"
		/>
	</a>
</h1>

<div class="prose">
	<data.content />

	<section>
		<h2>News</h2>
		<ul class="neovim">
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
			{/await}
		</ul>
	</section>
</div>

<style>
	.badge {
		height: 20px;
	}
</style>
