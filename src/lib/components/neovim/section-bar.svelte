<!-- Links to the sections of the neovim docs, the current one outlined. -->
<script lang="ts">
	import { resolve } from '$app/paths';

	interface Props {
		pathname: string;
	}

	let { pathname }: Props = $props();

	const sections = [
		{ path: 'neovim', label: 'Install' },
		{ path: 'neovim/keymaps', label: 'Keymaps' },
		{ path: 'neovim/customize', label: 'Customize' },
		{ path: 'neovim/core', label: 'Core' },
		{ path: 'neovim/extras', label: 'Extras' },
	] as const;

	// Install is the landing page itself; other sections include their
	// subpages (/neovim/extras/editor/harpoon2 is in Extras).
	function current(path: string) {
		const p = pathname.replace(/\/$/, '');
		return path === 'neovim'
			? p === '/neovim'
			: p === `/${path}` || p.startsWith(`/${path}/`);
	}
</script>

<nav class="sections" aria-label="Neovim docs">
	<span class="home">~/neovim</span>
	{#each sections as section (section.path)}
		<a
			href={resolve(section.path)}
			aria-current={current(section.path) ? 'page' : undefined}
		>
			{section.label}
		</a>
	{/each}
</nav>

<style>
	.sections {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.25rem;
		margin-bottom: 0.5rem;
	}

	.home {
		margin-right: 0.75rem;
		font-weight: 700;
	}

	a {
		padding: 0.2rem 0.75rem;
		border: 1px solid transparent;
		border-radius: 999px;
		color: var(--color-text);
		text-decoration: none;
	}

	a:hover {
		color: var(--color-theme-1);
	}

	a[aria-current='page'] {
		border-color: var(--color-theme-1);
		color: var(--color-theme-1);
	}
</style>
