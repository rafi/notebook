<script lang="ts">
	import { PageNavigation } from '#lib/components/article/index.ts';

	let { data, children } = $props();
	let slug: string = $derived(data.url.replace(/^\//, ''));
</script>

{@render children?.()}

{#await data.posts then posts}
	<PageNavigation {slug} {posts} />
{/await}
