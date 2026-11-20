<script lang="ts">
	// `:::info[Title]` callout in posts. Renders the markup remark-admonitions
	// produced, so src/styles/admonition.css keeps styling it.
	import type { Snippet } from 'svelte';

	interface Props {
		label?: Snippet;
		children?: Snippet;
	}

	let { label, children }: Props = $props();
</script>

<div class="admonition admonition-info alert alert--info">
	<div class="admonition-heading">
		<h5>
			<span class="admonition-icon">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					width="14"
					height="16"
					viewBox="0 0 14 16"
				>
					<path
						fill-rule="evenodd"
						d="M7 2.3c3.14 0 5.7 2.56 5.7 5.7s-2.56 5.7-5.7 5.7A5.71 5.71 0 0 1 1.3 8c0-3.14 2.56-5.7 5.7-5.7zM7 1C3.14 1 0 4.14 0 8s3.14 7 7 7 7-3.14 7-7-3.14-7-7-7zm1 3H6v5h2V4zm0 6H6v2h2v-2z"
					></path>
				</svg>
			</span>{@render label?.()}
		</h5>
	</div>
	<div class="admonition-content">{@render children?.()}</div>
</div>
