<!-- Footer line naming the vim-config commit the docs were generated from. -->
<script lang="ts">
	interface Props {
		commit: string;
	}

	let { commit }: Props = $props();
</script>

{#if commit}
	<p class="generated">
		Generated from
		<a
			href={`https://github.com/rafi/vim-config/commit/${commit}`}
			rel="external"
		>
			vim-config@{commit}
		</a>
	</p>
{/if}

<style>
	.generated {
		margin-top: 3rem;
		text-align: center;
		font-size: 0.875rem;
		color: var(--color-text-dark);
	}
</style>
