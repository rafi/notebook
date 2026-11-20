<script lang="ts">
	import { Presentation } from '#lib/components/presentation/index.ts';

	let { data } = $props();
</script>

<svelte:head>
	<link rel="canonical" href={data.url.replace(/\/slides$/, '')} />
</svelte:head>

<Presentation title={data.post.meta.title ?? ''}>
	<data.post.content />
</Presentation>
