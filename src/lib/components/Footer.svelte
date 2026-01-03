<script lang="ts">
	import { onMount } from 'svelte';
	import { GitMerge, RssIcon, NotebookPen } from 'lucide-svelte';
	import * as config from '$lib/config';

	let dt = $state(new Date());

	// Update time every minute
	onMount(() => {
		const interval = setInterval(() => {
			dt = new Date();
		}, 1000 * 60);

		return () => {
			clearInterval(interval);
		};
	});

	// Get my personal GMT time.
	function getTime(dt: Date) {
		let t = '';
		let c = dt.toLocaleString('en-US', {
			timeZone: 'Asia/Jerusalem',
			timeStyle: 'long',
			hour12: true,
		});
		let parts = c.split(' ');
		if (parts.length > 2) {
			t += parts[2] + ', ';
		}
		if (parts.length > 0) {
			let e = parts[0].split(':');
			t += e[0] + ':' + e[1];
		}
		if (parts.length > 1) {
			t += ' ' + parts[1];
		}
		return t;
	}
</script>

<footer>
	<div class="footer-wrap">
		<hgroup>
			<p>
				{getTime(dt)}
				<img class="bob" src="/img/icon/bob.png" alt="1st dog name Bob" />
				<img class="lucy" src="/img/icon/lucy.png" alt="2nd dog named Lucy" />
			</p>
			<p>
				<a
					target="_blank"
					href="https://github.com/rafi/notebook"
					data-sveltekit-preload-code="false"
				>
					<NotebookPen size="12" />
				</a>
				{#if config.social.github}
					<a
						href={'https://github.com/' + config.social.github}
						data-sveltekit-preload-code="false"
					>
						<GitMerge size="12" />
					</a>
				{/if}
				<a
					target="_blank"
					href="/rss.xml"
					data-sveltekit-preload-code="false"
				>
					<RssIcon size="12" />
				</a>
			</p>
		</hgroup>
		<div class="footer-bottom">
			<p>
				© {config.sinceYear}-{dt.getFullYear()}
				All rights reserved
				<a href="https://github.com/{config.social.github}">{config.name}</a>
			</p>
		</div>
	</div>
</footer>

<style>
	/* * { outline: 1px solid blue; } */

	footer {
		display: flex;
		flex-direction: column;
		padding: 0;
		margin: 3rem 0 0;
	}

	footer div.footer-wrap {
		display: flex;
		flex-direction: column;
		border-top: 1px solid var(--border-color);
		color: var(--color-text-dark);

		width: 100%;
		max-width: 48rem;
		margin: 0 auto;
	}

	footer a {
		color: var(--color-text-dark);
		text-decoration: none;
	}

	footer a:hover {
		color: var(--color-theme-3);
	}

	footer hgroup {
		display: flex;
		justify-content: space-between;
		padding: 0;
	}

	footer p {
		font-size: 0.8rem;
		margin: 1em 1em 0 1em;
	}

	footer div.footer-bottom {
		display: flex;
		justify-content: space-between;
		padding: 0 0 1em;
	}

	footer img.bob {
		margin-left: 1em;
		width: 18px;
		transform: rotateY(180deg);
	}
	footer img.lucy {
		width: 20px;
		transform: rotate(2deg);
	}
</style>
