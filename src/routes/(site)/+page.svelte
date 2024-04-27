<script lang="ts">
	import * as config from '$lib/config';
	import Profile from '$lib/components/profile-card.svelte';
	import { RecentTracks } from '$lib/components/lastfm';

	import { Mailbox, GitCommitHorizontal, CassetteTape } from 'lucide-svelte';
</script>

<svelte:head>
	<title>{config.title}</title>
	<meta name="description" content={config.description} />

	<meta property="og:title" content={config.title} />
	<meta property="og:site_name" content={config.title} />
	<meta property="og:image" content={config.image} />
	<meta property="og:url" content={config.url} />
	<meta property="og:description" content={config.description} />

	<meta name="twitter:card" content="summary_large_image" />
	<meta name="twitter:creator" content={'@' + config.social.twitter} />
	<meta name="twitter:title" content={config.title} />
	<meta name="twitter:description" content={config.description} />
	<meta name="twitter:image" content={config.image} />
</svelte:head>

<Profile href="/about">Senior Software Engineer @ qwilt</Profile>

<h2>Profile</h2>
<p>
	Rafael is a programming veteran, highly motivated and passionate about software development.
	Long-time PC enthusiast, pcboard sysop in the early 90s, web developer in the 00s, DevOps
	aficionado, and perpetual backend developer. Currently using Go and Python.
</p>

<p>
	During the 25+ years I've been <i>professionally</i> programming, I've been doing:
</p>
<ul class="resume">
	<li>
		<time>2022-2024:</time>
		Cloud-native specialist working on Kubernetes and virtualization.
	</li>
	<li>
		<time>2017-2021:</time>
		Developed Cloud-native controllers & operators with Golang and led large-scale Kubernetes adoption.
	</li>
	<li>
		<time>2015-2017:</time>
		Tech lead in the user-behavior analytics team. Large-scale Python development using queues, containers
		cloud-computing.
	</li>
	<li>
		<time>2010-2015:</time>
		Sole architect and led development & team on various bespoke CMS/CRM'es for vendors.
	</li>
	<li>
		<time>2007-2010:</time>
		Led team and development on multiple e-commerce site network.
	</li>
	<li>
		<time>2005-2006:</time>
		Developed cross-platform single-page apps for CRM's in New Jersey.
	</li>
	<li>
		<time>2001-2004:</time>
		Freelancer developing multi-tier business backends in Dallas, Texas.
	</li>
	<li>
		<time>1997-2000:</time>
		Developed an e-commerce platform (ShopMind), analyzing, defining and developing modules in a DNA2000
		(XML/XSL, Com+, Asp, Ado) environment.
	</li>
</ul>

<h2>Projects</h2>
<ul>
	<!-- <li><a href="/neovim">neovim config</a></li> -->
	<li><a href="https://github.com/rafi/gits">gits</a></li>
	<li><a href="https://nester.co.il">nester</a></li>
</ul>

<h2>Contact</h2>
<ul class="contact">
	{#if config.social.email}
		<li>
			<Mailbox size="24" />
			<a href={`email:${config.social.email}@g`}>
				{config.social.email.split('@').join(' at ')}
			</a>
		</li>
	{/if}
	{#if config.social.github}
		<li>
			<GitCommitHorizontal size="24" />
			<a href={'https://github.com/' + config.social.github}>
				github.com/{config.social.github}
			</a>
		</li>
	{/if}
	{#if config.social.listenbrainz}
		<li>
			<CassetteTape size="24" />
			<a href={'https://listenbrainz.org/user/' + config.social.listenbrainz}>
				listenbrainz.org/user/{config.social.listenbrainz}
			</a>
		</li>
	{/if}
</ul>

<h2>Last Played</h2>

<RecentTracks />

<style>
	ul.resume li {
		list-style: none;
	}

	ul.contact,
	ul.resume {
		padding-left: 1.5em;
	}

	ul.contact li {
		display: flex;
		align-items: center;
		list-style: none;
	}

	ul.contact li a {
		margin-left: 0.5em;
	}
</style>
