<script lang="ts">
	// Slideshow of a compiled post: a title slide, then one slide per part of
	// the post between top-level thematic breaks (`---`, rendered as <hr>).
	import { onMount, type Snippet } from 'svelte';

	import Reveal, { type RevealApi } from 'reveal.js';
	import Notes from 'reveal.js/plugin/notes';

	interface Props {
		title: string;
		children?: Snippet;
	}

	let { title, children }: Props = $props();

	let slides: HTMLElement;
	let source: HTMLElement;
	let deckRef: RevealApi | null = null;

	// Move the post's top-level nodes into <section>s, starting a new one at
	// each <hr>, because reveal.js needs one <section> per slide. Nodes are
	// moved, not copied, so components inside them (such as code block copy
	// buttons) keep working and Svelte still removes them on unmount.
	function splitIntoSections() {
		let section = document.createElement('section');
		for (const node of [...source.childNodes]) {
			if (node instanceof HTMLHRElement) {
				// eslint-disable-next-line svelte/no-dom-manipulating -- see above
				slides.append(section);
				section = document.createElement('section');
			} else {
				section.append(node);
			}
		}
		// eslint-disable-next-line svelte/no-dom-manipulating -- see above
		slides.append(section);
	}

	onMount(() => {
		if (deckRef !== null) {
			return;
		}
		splitIntoSections();
		deckRef = new Reveal({
			plugins: [Notes],
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
</script>

<div class="reveal">
	<div class="slides" bind:this={slides}>
		<section><h1>{title}</h1></section>
	</div>
</div>

<div hidden bind:this={source}>{@render children?.()}</div>
