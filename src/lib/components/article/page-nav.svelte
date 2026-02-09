<script lang="ts">
	import type { Post } from '$lib/types';

	interface Props {
		slug: string;
		prefix?: string | undefined;
		posts: Post[];
	}

	let { slug, prefix, posts }: Props = $props();

	let prev = $derived(posts.find((_, i) => posts[i + 1]?.slug === slug));
	let next = $derived(posts.find((_, i) => posts[i - 1]?.slug === slug));
	let normalizedPrefix = $derived(prefix ? `/${prefix}/` : '');
	let gap = $derived(!prev && next);
</script>

{#if prev || next}
	<ul class="cards page-nav">
		{#if prev}
			<li>
				<a href={normalizedPrefix + prev.slug}>← {prev.title}</a>
			</li>
		{/if}
		{#if next}
			<li class:gap>
				<a href={normalizedPrefix + next.slug}>{next.title} →</a>
			</li>
		{/if}
	</ul>
{/if}
