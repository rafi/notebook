module.exports = {
  title: 'Rafi\'s Knowledge',
  description: 'Knowledge Base of Rafael Bodill',
  dest: './dist',
  plugins: {
    '@vuepress/back-to-top': true,
    '@vuepress/medium-zoom': true,
    '@vuepress/google-analytics': { ga: 'UA-129679382-1' },
  },
  themeConfig: {
    repo: 'rafi/notebook',
    repoLabel: '',
    editLinks: false,
    lastUpdated: 'Last Updated',
    updatePopup: true,
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Blog', link: '/blog/' },
    ],
    sidebar: [
      '/',
      '/blog/',
      {
        title: 'Wiki',
        collapsable: false,
        children: [
          '/bash/',
          '/containers/',
          '/filesystem/',
          '/git/',
          '/go/',
          '/music/',
          '/perl/',
          '/php/',
          '/python/',
          '/server/',
          '/snippets/',
          '/storage/',
          '/terminal/',
          '/tmux/',
          '/gui/',
          '/vim/',
          '/workstation/',
        ]
      }
    ]
  }
}
