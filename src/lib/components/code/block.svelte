<script lang="ts">
	import { CopyIcon, CheckIcon } from 'lucide-svelte';

	export let lang = '';
	export let title = '';

	// Whether to display copy button
	export let nocopy = false;

	let copyButton: HTMLButtonElement;
	let copiedTimeout: NodeJS.Timeout | undefined;
	let copied = false;

	function copy() {
		const preElement = copyButton.nextElementSibling;
		if (preElement instanceof HTMLElement) {
			navigator.clipboard.writeText(preElement.innerText);
			copied = true;
		}
	}

	$: if (copied) {
		clearTimeout(copiedTimeout);
		copiedTimeout = setTimeout(() => (copied = false), 1000);
	}
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
			on:click={copy}
			aria-label="copy"
		>
			{#if !copied}
				<CopyIcon size="18" />
			{:else}
				<CheckIcon size="18" />
			{/if}
		</button>
	{/if}

	<slot />
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
