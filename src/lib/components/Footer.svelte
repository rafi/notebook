<script lang="ts">
	import { onMount } from 'svelte';
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
	<div>
		<p>
			{getTime(dt)}
			<img class="bob" src="/img/icon/bob.png" alt="1st dog name Bob" />
			<img class="lucy" src="/img/icon/lucy.png" alt="2nd dog named Lucy" />
		</p>
		<hgroup>
			<p>© {config.sinceYear}-{dt.getFullYear()} {config.name}</p>
		</hgroup>
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

	footer div {
		display: flex;
		flex-direction: column;
		border-top: 1px solid var(--border-color);

		width: 100%;
		max-width: 48rem;
		margin: 0 auto;
	}

	footer p {
		font-size: 0.8rem;
		margin: 1em 0 0 1em;
	}

	footer hgroup {
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
