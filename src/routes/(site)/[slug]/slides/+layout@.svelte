<script>
	// Reveal style-sheets
	import 'reveal.js/dist/reveal.css';
	import 'reveal.js/dist/theme/league.css';
	import 'reveal.js/plugin/highlight/monokai.css';

	import '../../../../styles/reveal.css';
</script>

<slot />

<style>
	:global(.main-present) {
		padding: 0 !important;
		max-width: none !important;
		flex: 1 1 auto;
		overflow: auto !important;
	}

	/*
	See all Reveal's parameters at
	https://github.com/hakimel/reveal.js/blob/master/css/theme/template/exposer.scss
	*/
	:root {
		--r-code-font: var(--font-mono);
	}
</style>
