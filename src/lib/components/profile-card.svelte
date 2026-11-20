<script lang="ts">
	import { resolve } from '$app/paths';
	import type { Path } from '$app/types';
	import * as config from '#lib/config.js';

	interface Props {
		href: Path;
		children?: import('svelte').Snippet;
	}

	let { href, children }: Props = $props();
</script>

<div class="profile">
	<a href={resolve(href)}><img src={config.image} alt="Me" /></a>
	<div class="info">
		<h1>{config.name}</h1>
		<p>{@render children?.()}</p>
	</div>
</div>

<style>
	div.profile {
		display: flex;
		justify-content: center;
		align-items: center;
		padding-bottom: 2em;
	}

	div.profile div {
		padding-left: 1rem;
	}
	div.profile a {
		border-radius: 100%;
	}

	div h1 {
		display: flex;
		font-size: 1rem;
		margin: 4px 0 0;
	}

	div img {
		width: 3.5em;
		border-radius: 100%;
	}

	div p {
		font-size: 0.9em;
		margin: 0;
	}
</style>
