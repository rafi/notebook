<script lang="ts">
	import { PageNavigation } from '#lib/components/article/index.ts';

	let { data, children } = $props();
	let slug: string = $derived(data.url.replace(/^\//, ''));
	// Previous/next among pages of the same kind: core with core, extras with
	// extras. Keymaps and customize have none.
	let kind = $derived(
		slug.startsWith('neovim/core/')
			? 'core'
			: slug.startsWith('neovim/extras/')
				? 'extra'
				: undefined
	);
</script>

{@render children?.()}

{#if kind}
	{#await data.posts then posts}
		<PageNavigation {slug} posts={posts.filter((p) => p.kind === kind)} />
	{/await}
{/if}
