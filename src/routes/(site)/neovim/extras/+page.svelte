<script lang="ts">
	import { resolve } from '$app/paths';
	import type { Post } from '#lib/types/index.ts';
	import { neovimCommit } from '#lib/posts.ts';
	import GeneratedFrom from '#lib/components/neovim/generated-from.svelte';

	let { data } = $props();

	// Extras by category, in the order the API lists them (sorted by name).
	const categories = $derived.by(() => {
		const groups: Record<string, Post[]> = {};
		for (const post of data.posts) {
			const category = post.category ?? 'other';
			(groups[category] ??= []).push(post);
		}
		return Object.entries(groups);
	});

	const acronyms: Record<string, string> = { ai: 'AI', lsp: 'LSP', ui: 'UI' };
	const label = (category: string) =>
		acronyms[category] ?? category.charAt(0).toUpperCase() + category.slice(1);
</script>

<svelte:head>
	<title>rafi/neovim: extras</title>
</svelte:head>

<h1><small>~</small>/neovim/extras</h1>

<div class="prose">
	<p>
		Extras are opt-in plugins. Toggle them with <code>:RafiExtras</code>
		(<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>) or in your
		<code>rafi.json</code>. The ones marked <em>default</em> are enabled on a fresh
		install.
	</p>
</div>

{#each categories as [category, posts] (category)}
	<h2 id={category}>{label(category)}</h2>
	<ul class="cards">
		{#each posts as post (post.slug)}
			<li>
				<a href={resolve(post.slug)}>
					{post.title}
					{#if post.default_enabled}<em class="default">default</em>{/if}
					<span>{post.description}</span>
				</a>
			</li>
		{/each}
	</ul>
{/each}

<GeneratedFrom commit={neovimCommit} />

<style>
	.default {
		margin-left: 0.5em;
		font-size: 0.75rem;
		color: var(--color-theme-1);
	}
</style>
