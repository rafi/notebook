<!-- @migration task: review uses of `navigating` -->
<script lang="ts">
	import { navigating } from '$app/state';
	import { expoOut } from 'svelte/easing';
	import { slide, type SlideParams } from 'svelte/transition';

	/**
	 * Transition for "loading animation" when resolving next page.
	 * - 100ms delay because most page loads are instant, and we don't want to
	 *   flash.
	 * - Long 12s duration because we don't actually know how long it will take.
	 * - Exponential easing so fast loads (>100ms and <1s) still see enough
	 *   progress, while slow networks see it moving for a full 12 seconds.
	 */
	const transitionOpts: SlideParams = {
		delay: 100,
		duration: 12000,
		easing: expoOut,
		axis: 'x',
	};
</script>

{#if navigating}
	<div class="navigation-loader" in:slide={transitionOpts}></div>
{/if}

<style>
	.navigation-loader {
		position: fixed;
		top: 0;
		right: 0;
		left: 0;
		height: 4px;
		z-index: 50;
		background-color: var(--color-theme-1);
	}
</style>
