<script lang="ts">
	import { PageNavigation } from '$lib/components/article';

	let { data, children } = $props();
	let uri = $derived(data.url.replace(/^\//, '').split('/'));
	let prefix: string | undefined = $derived(uri[0]);
	let slug: string = $derived(uri.slice(1).join('/'));
	
	
</script>

{@render children?.()}

<PageNavigation {slug} posts={data.posts} {prefix} />
