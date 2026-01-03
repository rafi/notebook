<script lang="ts">
	import { run } from 'svelte/legacy';

	import type { Post } from '$lib/types'
	interface Props {
		slug: string;
		prefix?: string | undefined;
		posts: Post[];
	}

	let { slug, prefix = $bindable(undefined), posts }: Props = $props();

	let prev = $derived(posts.find((_, i) => posts[i + 1]?.slug === slug));
	let next = $derived(posts.find((_, i) => posts[i - 1]?.slug === slug));

	run(() => {
		prefix = prefix ? `/${prefix}/` : '';
	});
	
	
	let gap = $derived(!prev && next);
</script>

{#if prev || next}
	<ul class="cards page-nav">
		{#if prev}
			<li>
				<a href={prefix + prev.slug}>← {prev.title}</a>
			</li>
		{/if}
		{#if next}
			<li class:gap>
				<a href={prefix + next.slug}>{next.title} →</a>
			</li>
		{/if}
	</ul>
{/if}
