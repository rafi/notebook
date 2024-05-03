<script>
	import Profile from '$lib/components/profile-card.svelte';
	import { RecentTracks } from '$lib/components/lastfm';
</script>

<svelte:head>
	<title>me | rafi</title>
	<meta name="description" content="About me" />
</svelte:head>

<Profile href="/blog">thinker, coder, mentor</Profile>

<h2>What I do now</h2>

<p>
	I enjoy thinking about software architecture, history, and human psychology.
	<br />
	And listen to a lot of music.
</p>

<p>
	This site happily lives at <a href="https://vercel.com">Vercel</a>
	and powered by <a href="https://kit.svelte.dev/">SvelteKit</a>.
</p>

<p>
	Throughout the years the site had many iterations, but I didn't contribute any
	worthy reading material, nevertheless, I enjoyed keeping up with front-end
	technologies and evolution of static-site-generators (SSG).
</p>

<h2>SSGs I've tried</h2>

<p>
	Jekyll, GitBook, Hugo, Gatsby, mdBook, GitBook, VuePress, Docusaurus,
	SvelteKit, ... who knows what the future holds ...
</p>

<p>
	I've come to enjoy the simplicity of <a href="https://svelte.dev/">Svelte</a>
	and "No Batteries Included" approach of SvelteKit. It's a great fit for my character;
	I like to tinker and configure things to my liking. It's like
	<a href="https://archlinux.org/">Arch Linux</a>, but for web. :)
</p>

<h2>Tech Stack</h2>

<ul>
	<li>
		<a href="https://kit.svelte.dev/">SvelteKit</a>
		and <a href="https://www.typescriptlang.org/">TypeScript</a> languages.
	</li>
	<li>
		<a href="https://github.com/pngwn/mdsvex">MDsveX</a>,
		<a href="https://github.com/remarkjs/remark">remark</a>,
		<a href="https://github.com/rehypejs/rehype">rehype</a>, and
		<a href="https://github.com/shikijs/shiki">Shiki</a>.
	</li>
	<li>
		<a href="https://github.com/melt-ui/melt-ui">MeltUI</a>,
		<a href="https://github.com/lucide-icons/lucide">Lucide</a>, and
		<a href="https://levien.com/type/myfonts/inconsolata.html">Inconsolata</a> font.
	</li>
	<li><a href="https://github.com/hakimel/reveal.js">reveal.js</a></li>
	<li>Custom CSS.</li>
</ul>

<h2>Last Played</h2>

<RecentTracks />
