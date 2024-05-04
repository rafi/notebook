<script lang="ts">
	import { Presentation } from '$lib/components/presentation';

	export let data;
</script>

<svelte:head>
	<link rel="canonical" href={data.url.replace(/\/slides$/, '')} />
</svelte:head>

<Presentation>
	{data.raw}
</Presentation>
