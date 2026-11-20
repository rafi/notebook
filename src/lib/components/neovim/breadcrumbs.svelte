<!--
Path of the current neovim docs page, each part linking to its page. An
extra's category links to its heading in the extras table.
-->
<script lang="ts">
	import { resolve } from '$app/paths';

	interface Props {
		pathname: string;
	}

	let { pathname }: Props = $props();

	let crumbs = $derived.by(() => {
		const parts = pathname.replace(/^\/|\/$/g, '').split('/');
		return parts.map((name, i) => {
			const last = i === parts.length - 1;
			// /neovim/extras/<category>/<name>: no page per category.
			const href =
				parts[1] === 'extras' && i === 2
					? `${resolve('neovim/extras')}#${name}`
					: resolve(parts.slice(0, i + 1).join('/'));
			return { name, href: last ? undefined : href };
		});
	});
</script>

{#if crumbs.length > 1}
	<nav class="crumbs" aria-label="Breadcrumbs">
		{#each crumbs as crumb, i (i)}
			{#if i > 0}<span class="sep">/</span>{/if}
			{#if crumb.href}
				<!-- eslint-disable-next-line svelte/no-navigation-without-resolve -- href is built with resolve() -->
				<a href={crumb.href}>{crumb.name}</a>
			{:else}
				<span aria-current="page">{crumb.name}</span>
			{/if}
		{/each}
	</nav>
{/if}

<style>
	.crumbs {
		margin-bottom: 1rem;
		font-size: 0.875rem;
		color: var(--color-text-dark);
	}

	.sep {
		margin: 0 0.4em;
	}

	a {
		color: var(--color-text-dark);
	}
</style>
