<script lang="ts">
	import { Article } from '$lib/components/article';

	let { data } = $props();
</script>

<Article data={data.post} url={data.url} />
