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
			// TODO: Slides won't appear when clicking back button
			//       probably due to hash change. Avoid using `history.pushState(...)`
			//       and `history.replaceState(...)` as these will conflict with
			//       SvelteKit's router. Use the `pushState` and `replaceState`
			//       imports from `$app/navigation` instead.
			hash: false,
		});

		deckRef.initialize();

		// Cleanup reveal.js when unmounting
		return () => {
			if (deckRef) {
				deckRef.destroy();
				deckRef = null;
			}
			document.body.classList.remove('reveal-scroll');
			document.querySelector('.scrollbar')?.remove();
		};
	});

	interface Props {
		url?: string;
		external?: boolean;
		children?: import('svelte').Snippet;
	}

	let { url = '', external = false, children }: Props = $props();
</script>

<div class="reveal">
	<div class="slides">
		{#if external}
			<section data-markdown={url}></section>
		{:else}
			<section data-markdown>
				<div data-template>
					{@render children?.()}
				</div>
			</section>
		{/if}
	</div>
</div>
