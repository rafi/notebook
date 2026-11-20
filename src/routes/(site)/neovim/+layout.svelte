<script lang="ts">
	import { page } from '$app/state';
	import SectionBar from '#lib/components/neovim/section-bar.svelte';
	import Breadcrumbs from '#lib/components/neovim/breadcrumbs.svelte';

	let { children } = $props();
</script>

<SectionBar pathname={page.url.pathname} />
<Breadcrumbs pathname={page.url.pathname} />

{@render children?.()}
