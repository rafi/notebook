<!--
Table of neovim docs pages (extras or core plugins): name, description and
whether it's enabled by default, grouped under a heading row per category.
With `filterable`, a filter and category chips appear once JavaScript runs,
so without it the full table shows.
-->
<script lang="ts">
	import { onMount } from 'svelte';
	import { resolve } from '$app/paths';
	import type { Post } from '#lib/types/index.ts';

	interface Props {
		posts: Post[];
		filterable?: boolean;
	}

	let { posts, filterable = false }: Props = $props();

	const acronyms: Record<string, string> = { ai: 'AI', lsp: 'LSP', ui: 'UI' };
	const label = (category: string) =>
		acronyms[category] ?? category.charAt(0).toUpperCase() + category.slice(1);

	let hydrated = $state(false);
	let query = $state('');
	let category = $state('');
	onMount(() => (hydrated = true));

	let categories = $derived([
		...new Set(posts.map((p) => p.category).filter((c) => c !== undefined)),
	]);
	let showDefault = $derived(posts.some((p) => p.default_enabled));

	let shown = $derived.by(() => {
		const q = query.trim().toLowerCase();
		return posts.filter(
			(p) =>
				(!category || p.category === category) &&
				(!q ||
					`${p.title ?? ''} ${p.description ?? ''}`.toLowerCase().includes(q))
		);
	});

	// Rows grouped by category, in the order posts come (sorted by name).
	// Posts without a category (core plugins) form one group without heading.
	let groups = $derived.by(() => {
		const out: [string, Post[]][] = [];
		for (const post of shown) {
			const key = post.category ?? '';
			const last = out.at(-1);
			if (last && last[0] === key) last[1].push(post);
			else out.push([key, [post]]);
		}
		return out;
	});
</script>

{#if filterable && hydrated}
	<div class="controls">
		<input
			type="search"
			placeholder="Filter by name or description…"
			aria-label="Filter extras"
			bind:value={query}
		/>
		<div class="chips" role="group" aria-label="Category">
			<button
				type="button"
				aria-pressed={category === ''}
				onclick={() => (category = '')}
			>
				All
			</button>
			{#each categories as c (c)}
				<button
					type="button"
					aria-pressed={category === c}
					onclick={() => (category = c)}
				>
					{label(c)}
				</button>
			{/each}
		</div>
		<p class="count">{shown.length} extras</p>
	</div>
{/if}

<table>
	<tbody>
		{#each groups as [group, rows] (group)}
			{#if group}
				<tr class="category" id={group}>
					<th colspan={showDefault ? 3 : 2}>{label(group)}</th>
				</tr>
			{/if}
			{#each rows as post (post.slug)}
				<tr>
					<td class="name"><a href={resolve(post.slug)}>{post.title}</a></td>
					<td>{post.description}</td>
					{#if showDefault}
						<td class="default">
							{#if post.default_enabled}<span title="Enabled by default">
									✓
								</span>{/if}
						</td>
					{/if}
				</tr>
			{/each}
		{/each}
	</tbody>
</table>

<style>
	.controls {
		margin-bottom: 1rem;
	}

	input {
		box-sizing: border-box;
		width: 100%;
		padding: 0.4rem 0.75rem;
		border: 1px solid var(--border-color);
		border-radius: 0.5rem;
		background: var(--nav-background);
		color: var(--color-text);
		font: inherit;
	}

	.chips {
		display: flex;
		flex-wrap: wrap;
		gap: 0.4rem;
		margin: 0.6rem 0;
	}

	button {
		padding: 0 0.7rem;
		border: 1px solid var(--border-color);
		border-radius: 999px;
		background: none;
		color: var(--color-text);
		font: inherit;
		font-size: 0.8rem;
		cursor: pointer;
	}

	button[aria-pressed='true'] {
		border-color: var(--color-theme-1);
		color: var(--color-theme-1);
	}

	.count {
		margin: 0;
		font-size: 0.8rem;
		color: var(--color-text-dark);
	}

	table {
		width: 100%;
		border-collapse: collapse;
		font-size: 0.9rem;
	}

	td {
		padding: 0.3rem 0.5rem;
		border-bottom: 1px solid var(--border-color);
		vertical-align: top;
	}

	td.name {
		white-space: nowrap;
	}

	td.default {
		text-align: center;
		color: var(--color-theme-1);
	}

	/* Below the fixed site header when linked as #category. */
	tr.category {
		scroll-margin-top: 5rem;
	}

	tr.category th {
		padding: 1.2rem 0.5rem 0.3rem;
		border-bottom: 1px solid var(--border-color);
		font-weight: 400;
		font-size: 0.8rem;
		text-align: left;
		text-transform: uppercase;
		letter-spacing: 0.08em;
	}
</style>
