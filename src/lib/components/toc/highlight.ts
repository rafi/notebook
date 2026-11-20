import type { Attachment } from 'svelte/attachments';

/**
 * Marks the TOC link of every heading whose section is on screen with
 * `data-active`. A section runs from its heading to the next listed heading
 * (the last one to the end of the article). The top of the viewport is taken
 * as the headings' `scroll-margin-top`, so text under the fixed header
 * doesn't count as visible.
 */
export const highlightVisibleSections: Attachment<HTMLElement> = (nav) => {
	const sections = [...nav.querySelectorAll<HTMLAnchorElement>('a[href^="#"]')]
		.map((link) => ({
			link,
			heading: document.getElementById(decodeURIComponent(link.hash.slice(1))),
		}))
		.filter(
			(s): s is { link: HTMLAnchorElement; heading: HTMLElement } =>
				s.heading !== null
		);
	if (sections.length === 0) return;
	const article = sections[0].heading.closest('article') ?? document.body;

	let frame = 0;
	function update() {
		frame = 0;
		const top =
			parseFloat(getComputedStyle(sections[0].heading).scrollMarginTop) || 0;
		const bottom = window.innerHeight;
		const end = article.getBoundingClientRect().bottom;
		sections.forEach(({ link, heading }, i) => {
			const start = heading.getBoundingClientRect().top;
			const stop = sections[i + 1]?.heading.getBoundingClientRect().top ?? end;
			link.toggleAttribute('data-active', stop > top && start < bottom);
		});
	}
	function schedule() {
		if (!frame) frame = requestAnimationFrame(update);
	}

	update();
	window.addEventListener('scroll', schedule, { passive: true });
	window.addEventListener('resize', schedule);
	return () => {
		cancelAnimationFrame(frame);
		window.removeEventListener('scroll', schedule);
		window.removeEventListener('resize', schedule);
	};
};
