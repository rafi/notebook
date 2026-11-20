<script lang="ts">
	// Replaces `pre` in mdsvex-compiled posts: wraps each highlighted code
	// block with its language or title label and a copy button.
	import { CopyIcon, CheckIcon } from '@lucide/svelte';

	interface Props {
		lang?: string;
		title?: string;
		// Fence meta flag: hide the copy button
		nocopy?: boolean;
		// The code's text as a reader sees it
		code?: string;
		children?: import('svelte').Snippet;
	}

	let {
		lang = '',
		title = '',
		nocopy = false,
		code = '',
		children,
	}: Props = $props();

	let copied = $state(false);

	function copy() {
		navigator.clipboard.writeText(code);
		copied = true;
	}

	$effect(() => {
		if (copied) {
			const t = setTimeout(() => (copied = false), 1000);
			return () => clearTimeout(t);
		}
	});
</script>

<div>
	{#if title}
		<span class="title">{title}</span>
	{:else if lang}
		<span class="lang">{lang}</span>
	{/if}

	{#if !nocopy}
		<button class="copy" onclick={copy} aria-label="copy">
			{#if !copied}
				<CopyIcon size="18" />
			{:else}
				<CheckIcon size="18" />
			{/if}
		</button>
	{/if}

	{@render children?.()}
</div>

<style>
	div {
		position: relative;
		background-color: var(--code-block-background);
	}

	span {
		display: flex;
		font-size: 0.9rem;
		color: var(--color-text-light);
		-webkit-user-select: none;
		user-select: none;
	}
	span.title {
		padding: 1rem;
	}
	span.lang {
		flex-direction: row-reverse;
		position: relative;
		right: 0.8rem;
		top: 0.8rem;
		font-size: 0.7rem;
	}

	div:hover button.copy {
		display: flex;
	}
	button.copy {
		display: none;
		cursor: pointer;
		position: absolute;
		right: 0.8rem;
		top: 0.8rem;
		height: 28px;
		width: 28px;
		padding: 0;
		justify-content: space-around;
		align-items: center;
	}
</style>
