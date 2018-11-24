module.exports = {
  title: 'Rafael Bodill Knowledge Base',
  description: 'Knowledge Base of Rafael Bodill',
  dest: './dist',
  plugins: [
    '@vuepress/back-to-top',
    '@vuepress/medium-zoom',
  ],
  themeConfig: {
    // repo: 'rafi/notebook',
    repoLabel: '',
    editLinks: false,
    lastUpdated: 'Last Updated',
    updatePopup: true,
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Blog', link: '/blog/' },
      { text: 'GitHub', link: 'https://github.com/rafi' },
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
