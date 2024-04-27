<script lang="ts">
	import { onMount } from 'svelte';

	import Reveal from 'reveal.js';
	import Highlight from 'reveal.js/plugin/highlight/highlight';
	import Markdown from 'reveal.js/plugin/markdown/markdown';
	import Notes from 'reveal.js/plugin/notes/notes';

	let deckRef: Reveal.Api | null = null;

	onMount(() => {
		if (deckRef !== null) {
			return;
		}
		deckRef = new Reveal({
			plugins: [Markdown, Highlight, Notes],
			autoAnimateEasing: 'ease',
			autoAnimateDuration: 1,
			controls: true,
			progress: true,
			// TODO: Slides won't appear when clicking back button?
			hash: true,
		});

		const main = document.querySelector('main');
		if (main) {
			main.classList.add('main-present');
		}

		deckRef.initialize();

		return () => {
			if (deckRef) {
				deckRef.destroy();
				deckRef = null;
			}
			document.body.classList.remove('reveal-scroll');
			document.querySelector('.scrollbar')?.remove();
			const main = document.querySelector('main');
			if (main) {
				main.classList.remove('main-present');
			}
		};
	});

	export let url = '';
	export let external = false;
</script>

<div class="reveal">
	<div class="slides">
		{#if external}
			<section data-markdown={url} />
		{:else}
			<section data-markdown>
				<div data-template>
					<slot />
				</div>
			</section>
		{/if}
	</div>
</div>
