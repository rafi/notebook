<script lang="ts">
	import { page } from '$app/state';
	import SectionBar from '#lib/components/neovim/section-bar.svelte';
	import Breadcrumbs from '#lib/components/neovim/breadcrumbs.svelte';

	let { children } = $props();
</script>

<SectionBar pathname={page.url.pathname} />
<Breadcrumbs pathname={page.url.pathname} />

<div class="neovim">
	{@render children?.()}
</div>

<style>
	/* Page titles are extra and plugin names (editor.harpoon2): show them as
	   written, not capitalized like post titles. */
	.neovim :global(.prose h1) {
		text-transform: none;
	}
</style>
