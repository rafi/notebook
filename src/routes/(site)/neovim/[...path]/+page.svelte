<script lang="ts">
	import { Article } from '#lib/components/article/index.ts';

	let { data } = $props();
</script>

<Article data={data.post} url={data.url} />
