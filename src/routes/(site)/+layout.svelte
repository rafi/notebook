<script>
	import { sineIn } from 'svelte/easing';
	import { fly } from 'svelte/transition';

	import Header from '$lib/components/Header.svelte';
	import Footer from '$lib/components/Footer.svelte';

	import '$styles/layout.css';
	import '$styles/prose.css';
	import '$styles/toc.css';
	import '$styles/admonition.css';

	export let data;

	$: isSlides = data.url.endsWith('/slides');
</script>

<Header
	nav={!isSlides}
	url={isSlides ? data.url.replace(/\/slides$/, '') : ''}
/>

{#key data.url}
	<main
		class={isSlides ? 'main-present' : ''}
		in:fly={{ x: 50, duration: 150, easing: sineIn }}
	>
		<div>
			<slot />
		</div>
	</main>
{/key}
{#if !isSlides}
	<Footer />
{/if}

<style>
	/* * { outline: 1px solid green; } */

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

	.main-present {
		flex: 1 1 auto;
		padding: 0 !important;
		max-width: none !important;
		margin: 0 auto !important;
		overflow: auto !important;
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
