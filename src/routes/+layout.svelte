<script lang="ts">
	import { links } from 'unplugin-fonts/head';
	import PageLoadSlide from '$lib/components/page-load-slide.svelte';

	import '$styles/layout.css';
	import 'unfonts.css';
	interface Props {
		children?: import('svelte').Snippet;
	}

	let { children }: Props = $props();
</script>

<svelte:head>
	{#each links as link}
		<link {...link?.attrs || {}} />
	{/each}
	<link rel="manifest" href="/manifest.json" />
	<link rel="alternate" type="application/atom+xml" href="/rss.xml" />
	<meta name="theme-color" content="#3eaf7c" />
	<meta name="apple-mobile-web-app-capable" content="yes" />
	<meta name="apple-mobile-web-app-status-bar-style" content="black" />
	<meta name="msapplication-TileColor" content="#3eaf7c" />
	<meta
		name="msapplication-TileImage"
		content="/img/favicon/msapplication-icon-144x144.png"
	/>
	<link
		rel="apple-touch-icon"
		href="/img/favicon/apple-touch-icon-152x152.png"
	/>
	<link
		rel="apple-touch-icon"
		href="/img/favicon/apple-touch-icon-120x120.png"
	/>
	<link rel="apple-touch-icon" href="/img/favicon/apple-touch-icon-76x76.png" />
	<link rel="apple-touch-icon" href="/img/favicon/apple-touch-icon-60x60.png" />
</svelte:head>

<PageLoadSlide />

<div class="app">
	{@render children?.()}
</div>

<style>
	.app {
		display: flex;
		flex-direction: column;
		justify-content: space-between;
		min-height: 100vh;
	}
</style>
