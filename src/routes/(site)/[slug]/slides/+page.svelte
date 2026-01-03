<script lang="ts">
	import { Presentation } from '$lib/components/presentation';

	let { data } = $props();
</script>

<svelte:head>
	<link rel="canonical" href={data.url.replace(/\/slides$/, '')} />
</svelte:head>

<Presentation>
	{data.raw}
</Presentation>
