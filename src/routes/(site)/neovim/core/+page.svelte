<script lang="ts">
	import { resolve } from '$app/paths';
	import { neovimCommit } from '#lib/posts.ts';
	import GeneratedFrom from '#lib/components/neovim/generated-from.svelte';

	let { data } = $props();
</script>

<svelte:head>
	<title>rafi/neovim: core plugins</title>
</svelte:head>

<h1><small>~</small>/neovim/core</h1>

<div class="prose">
	<p>
		These plugins always load. Each can be turned off by adding its name to
		<code>disabled</code> in your <code>rafi.json</code>, except
		<code>snacks</code>.
	</p>
</div>

<ul class="cards">
	{#each data.posts as post (post.slug)}
		<li>
			<a href={resolve(post.slug)}>
				{post.title}
				<span>{post.description}</span>
			</a>
		</li>
	{/each}
</ul>

<GeneratedFrom commit={neovimCommit} />
