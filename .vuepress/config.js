module.exports = {
  title: 'Rafi\'s Knowledge',
  description: 'Knowledge Base of Rafael Bodill',
  dest: './dist',
  plugins: {
    '@vuepress/back-to-top': true,
    '@vuepress/medium-zoom': true,
    '@vuepress/google-analytics': { ga: 'UA-129679382-1' },
  },
  head: [
    ['link', { rel: 'icon', href: `/logo.png` }],
    ['link', { rel: 'manifest', href: '/manifest.json' }],
    ['meta', { name: 'theme-color', content: '#3eaf7c' }],
    ['meta', { name: 'apple-mobile-web-app-capable', content: 'yes' }],
    ['meta', { name: 'apple-mobile-web-app-status-bar-style', content: 'black' }],
    ['link', { rel: 'apple-touch-icon', href: `/icons/apple-touch-icon-152x152.png` }],
    ['link', { rel: 'apple-touch-icon', href: `/icons/apple-touch-icon-120x120.png` }],
    ['link', { rel: 'apple-touch-icon', href: `/icons/apple-touch-icon-76x76.png` }],
    ['link', { rel: 'apple-touch-icon', href: `/icons/apple-touch-icon-60x60.png` }],
    ['meta', { name: 'msapplication-TileImage', content: '/icons/msapplication-icon-144x144.png' }],
    ['meta', { name: 'msapplication-TileColor', content: '#000000' }]
  ],
  themeConfig: {
    repo: 'rafi/notebook',
    repoLabel: '',
    editLinks: false,
    lastUpdated: 'Last Updated',
    updatePopup: true,
    nav: [
      { text: 'Home', link: '/' },
    ],
    sidebar: [
      '/',
      {
        title: 'Wiki',
        collapsable: false,
        children: [
          '/bash/',
          '/containers/',
          '/filesystem/',
          '/git/',
          '/go/',
          '/gui/',
          '/music/',
          '/perl/',
          '/php/',
          '/python/',
          '/server/',
          '/shell/',
          '/snippets/',
          '/storage/',
          '/terminal/',
          '/tmux/',
          '/vim/',
          '/workstation/',
        ]
      }
    ]
  }
}
