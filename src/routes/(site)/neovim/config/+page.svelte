<script lang="ts">
	let { data } = $props();
</script>

<div class="prose">
	{@html `<style>${data.page.css.code}</style>`}
	{@html data.page.html}
</div>
