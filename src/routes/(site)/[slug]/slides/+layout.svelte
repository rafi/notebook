<script lang="ts">
	// Reveal style-sheets
	import 'reveal.js/dist/reveal.css';
	import 'reveal.js/dist/theme/league.css';
	import 'reveal.js/plugin/highlight/monokai.css';

	import '$styles/reveal.css';
	interface Props {
		children?: import('svelte').Snippet;
	}

	let { children }: Props = $props();
</script>

{@render children?.()}

<style>
	/*
	See all Reveal's parameters at
	https://github.com/hakimel/reveal.js/blob/master/css/theme/template/exposer.scss
	*/
	:root {
		--r-code-font: var(--font-mono);
	}
</style>
