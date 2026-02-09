<script lang="ts">
	import { PageNavigation } from '$lib/components/article';

	let { data, children } = $props();
	let slug: string = $derived(uri.join('/'));
	let prefix: string | undefined = $derived(uri.shift());

	let uri = $derived(data.url.replace(/^\//, '').split('/'));
	
	
</script>

{@render children?.()}

<PageNavigation {slug} posts={data.posts} {prefix} />
