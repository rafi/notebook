<script lang="ts">
	import type { Post } from '$lib/types';
	import { formatDate } from '$lib/util/time';
	import { TableOfContents } from '$lib/components/toc';
	import { Images } from 'lucide-svelte';

	export let data: { url: string; slug: string; meta: Post; content: any };
</script>

<svelte:head>
	<title>{data.meta.title}</title>
	<meta name="description" content={data.meta.description} />

	<meta property="og:type" content="article" />
	<meta property="og:title" content={data.meta.title} />
</svelte:head>

<article class="prose">
	<!-- Title -->
	<hgroup>
		<h1>{data.meta.title}</h1>
		<p>
			Published at {formatDate(data.meta.date)}{#if data.meta.updated},
				updated at {formatDate(data.meta.updated)}
			{/if}
			{#if data.meta.slideshow}
				<a href="{data.url.replace(/\/$/, '')}/slides">
					<Images size="16" />
					<span>better viewed as a</span> slideshow
				</a>
			{/if}
		</p>
	</hgroup>

	<!-- Tags -->
	<div class="tags">
		{#each data.meta.categories as category}
			<span>&num;{category}</span>
		{/each}
	</div>

	<!-- Post -->
	<div class="prose">
		<svelte:component this={data.content} />
	</div>
</article>

<TableOfContents />

<style>
	@media (max-width: 480px) {
		hgroup a span {
			display: none;
			visibility: hidden;
		}
	}
</style>
