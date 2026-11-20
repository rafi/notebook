<script lang="ts">
	/*
	 * TODO: Deprecate?
	 */
	import { onNavigate } from '$app/navigation';

	onNavigate((navigation) => {
		if (navigation.shallow && navigation.type === 'goto') return;

		// @ts-ignore
		if (!document.startViewTransition) return;

		return new Promise((resolve) => {
			// @ts-ignore
			document.startViewTransition(async () => {
				resolve();
				await navigation.complete;
			});
		});
	});
</script>
