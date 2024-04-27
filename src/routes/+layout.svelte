<script>
	import { sineIn } from 'svelte/easing';
	import { fly } from 'svelte/transition';

	import PageLoadSlide from '$lib/components/page-load-slide.svelte';
	import Header from '$lib/components/Header.svelte';
	import Footer from '$lib/components/Footer.svelte';

	import '../styles/layout.css';

	// Page fly-in transition effect options.
	const transitionOpts = {
		x: 50,
		duration: 150,
		easing: sineIn,
	};

	export let data;
</script>

<svelte:head>
	<link rel="manifest" href="/manifest.json" />
	<meta name="theme-color" content="#3eaf7c" />
	<meta name="apple-mobile-web-app-capable" content="yes" />
	<meta name="apple-mobile-web-app-status-bar-style" content="black" />
	<meta name="msapplication-TileColor" content="#3eaf7c" />
	<meta name="msapplication-TileImage" content="/img/favicon/msapplication-icon-144x144.png" />
	<link rel="apple-touch-icon" href="/img/favicon/apple-touch-icon-152x152.png" />
	<link rel="apple-touch-icon" href="/img/favicon/apple-touch-icon-120x120.png" />
	<link rel="apple-touch-icon" href="/img/favicon/apple-touch-icon-76x76.png" />
	<link rel="apple-touch-icon" href="/img/favicon/apple-touch-icon-60x60.png" />
</svelte:head>

<PageLoadSlide />

<div class="app">
	<Header url={data.url} />
	<main class="main">
		{#key data.url}
			<div in:fly={transitionOpts}>
				<slot />
			</div>
		{/key}
	</main>
	{#if ! data.url.endsWith('/slides')}
		<Footer />
	{/if}
</div>

<style>
	/* * { outline: 1px solid green; } */

	.app {
		display: flex;
		flex-direction: column;
		justify-content: space-between;
		min-height: 100vh;
	}

	main {
		display: flex;
		box-sizing: border-box;
		width: 100%;
		padding: 4em 4em 0;
		max-width: 54rem;
		min-height: calc(100vh - 195px);
		margin: 24px auto 0;
		overflow: hidden;
	}

	main div {
		width: 100%;
	}

	@media (max-width: 1250px) {
		main:has(.toc) {
			margin-left: 0;
			margin-right: 0;
		}
	}

	@media (max-width: 480px) {
		main {
			padding-left: 1.5em;
			padding-right: 1.5em;
		}
	}
</style>
