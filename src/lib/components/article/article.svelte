<script lang="ts">
	import type { ImportedFile } from '$lib/types';
	import { formatDate } from '$lib/util/time';
	import { TableOfContents } from '$lib/components/toc';
	import { ImagesIcon } from 'lucide-svelte';

	export let data: { url: string } & ImportedFile;
</script>

<svelte:head>
	<title>{data.meta.title}</title>
	<meta name="description" content={data.meta.description} />

	<meta property="og:type" content="article" />
	<meta property="og:title" content={data.meta.title} />
</svelte:head>

<article class="prose">
	<hgroup>
		<h1>{data.meta.title}</h1>
		<p>
			{#if data.meta.date}
				Published at {formatDate(data.meta.date)}{#if data.meta.updated},
					updated at {formatDate(data.meta.updated)}
				{/if}
			{/if}
			{#if data.meta.presentation}
				<a href="{data.url.replace(/\/$/, '')}/slides">
					<ImagesIcon size="16" />
					<span>better viewed as a</span> slideshow
				</a>
			{/if}
		</p>
	</hgroup>

	{#if data.meta.categories}
		<div class="tags">
			{#each data.meta.categories as category}
				<span>&num;{category}</span>
			{/each}
		</div>
	{/if}

	<svelte:component this={data.content} />
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
