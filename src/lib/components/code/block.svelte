<script lang="ts">
	import { run } from 'svelte/legacy';

	import { CopyIcon, CheckIcon } from 'lucide-svelte';


	
	interface Props {
		lang?: string;
		title?: string;
		// Whether to display copy button
		nocopy?: boolean;
		children?: import('svelte').Snippet;
	}

	let {
		lang = '',
		title = '',
		nocopy = false,
		children
	}: Props = $props();

	let copyButton: HTMLButtonElement = $state();
	let copiedTimeout: NodeJS.Timeout | undefined = $state();
	let copied = $state(false);

	function copy() {
		const preElement = copyButton.nextElementSibling;
		if (preElement instanceof HTMLElement) {
			navigator.clipboard.writeText(preElement.innerText);
			copied = true;
		}
	}

	run(() => {
		if (copied) {
			clearTimeout(copiedTimeout);
			copiedTimeout = setTimeout(() => (copied = false), 1000);
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
		<button
			class="copy"
			bind:this={copyButton}
			onclick={copy}
			aria-label="copy"
		>
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
		background-color: var(--code-background);
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
