<script lang="ts">
	import { Article } from '$lib/components/article';

	let { data } = $props();
</script>

<Article {data} url={data.url} />
