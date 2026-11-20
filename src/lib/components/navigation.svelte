<script lang="ts">
	/*
	 * TODO: Deprecate?
	 */
	import { onNavigate } from '$app/navigation';

	onNavigate((navigation) => {
		if (navigation.shallow && navigation.type === 'goto') return;

		if (!document.startViewTransition) return;

		return new Promise((resolve) => {
			document.startViewTransition(async () => {
				resolve();
				await navigation.complete;
			});
		});
	});
</script>
