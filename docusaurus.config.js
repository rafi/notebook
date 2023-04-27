// @ts-check
// Note: type annotations allow type checking and IDEs autocompletion
// See https://docusaurus.io/docs/api/docusaurus-config

const lightCodeTheme = require('prism-react-renderer/themes/github');
const darkCodeTheme = require('prism-react-renderer/themes/dracula');

// See https://docusaurus.io/docs/api/docusaurus-config
/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'Rafi\'s',
  tagline: 'Knowledge is power',
  favicon: 'img/favicon.ico',

  // Set the production url of your site here
  url: 'https://rafi.io',
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: '/',

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  // Even if you don't use internalization, you can use this field to set useful
  // metadata like html lang. For example, if your site is Chinese, you may want
  // to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  // googleAnalytics: {
  //   trackingID: 'UA-129679382-1',
  // },

  // head: [
  //   ['link', { rel: 'icon', href: `/logo.png` }],
  //   ['link', { rel: 'manifest', href: '/manifest.json' }],
  //   ['meta', { name: 'theme-color', content: '#3eaf7c' }],
  //   ['meta', { name: 'apple-mobile-web-app-capable', content: 'yes' }],
  //   ['meta', { name: 'apple-mobile-web-app-status-bar-style', content: 'black' }],
  //   ['link', { rel: 'apple-touch-icon', href: `/icons/apple-touch-icon-152x152.png` }],
  //   ['link', { rel: 'apple-touch-icon', href: `/icons/apple-touch-icon-120x120.png` }],
  //   ['link', { rel: 'apple-touch-icon', href: `/icons/apple-touch-icon-76x76.png` }],
  //   ['link', { rel: 'apple-touch-icon', href: `/icons/apple-touch-icon-60x60.png` }],
  //   ['meta', { name: 'msapplication-TileImage', content: '/icons/msapplication-icon-144x144.png' }],
  //   ['meta', { name: 'msapplication-TileColor', content: '#000000' }],
  // ],

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          // See https://docusaurus.io/docs/api/plugins/@docusaurus/plugin-content-docs
          routeBasePath: '/',
          sidebarPath: require.resolve('./sidebars.js'),
          editUrl: 'https://github.com/rafi/notebook/tree/master',
          showLastUpdateAuthor: true,
          showLastUpdateTime: true,
          // disableVersioning: true,
        },
        blog: {
          showReadingTime: true,
          editUrl: 'https://github.com/rafi/notebook/tree/master',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      }),
    ],
  ],

  // See https://docusaurus.io/docs/api/docusaurus-config#themeConfig
  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      // Replace with your project's social card
      // image: 'img/docusaurus-social-card.jpg',
      navbar: {
        title: 'Rafi\'s',
        logo: {
          alt: 'Rafi\'s Logo',
          src: 'img/logo.png',
        },
        items: [
          {
            type: 'docSidebar',
            sidebarId: 'wikiSidebar',
            position: 'left',
            label: 'Wiki',
          },
          // {to: '/blog', label: 'Blog', position: 'left'},
          {
            href: 'https://github.com/rafi',
            label: 'GitHub',
            position: 'right',
          },
        ],
      },
      footer: {
        style: 'dark',
        links: [
          {
            title: 'Docs',
            items: [
              {
                label: 'Wiki',
                to: '/',
              },
            ],
          },
          {
            title: 'dotfiles',
            items: [
              {
                label: '.config/nvim',
                href: 'https://github.com/rafi/vim-config',
              },
              {
                label: '.config',
                href: 'https://github.com/rafi/.config',
              },
            ],
          },
          {
            title: 'More',
            items: [
              // {
              //   label: 'Blog',
              //   to: '/blog',
              // },
              {
                label: 'GitHub',
                href: 'https://github.com/rafi',
              },
            ],
          },
        ],
        copyright: `Copyright © ${new Date().getFullYear()} Rafael Bodill. Built with Docusaurus.`,
      },
      prism: {
        theme: lightCodeTheme,
        darkTheme: darkCodeTheme,
      },
    }),
};

module.exports = config;
