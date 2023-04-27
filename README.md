# Website

## Plugins

- theme: https://github.com/rowfishjs/rowfish
- theme: https://github.com/dailydotdev/docs
- https://github.com/saucelabs/docusaurus-theme-github-codeblock
- https://github.com/rdilweb/docusaurus-plugin-remote-content
- https://github.com/praveenn77/docusaurus-lunr-search
- https://github.com/cmfcmf/docusaurus-search-local
- https://github.com/easyops-cn/docusaurus-search-local

This website is built using [Docusaurus 2](https://docusaurus.io/), a modern
static website generator.

### Installation

```sh
yarn
```

### Local Development

```sh
yarn start
```

This command starts a local development server and opens up a browser window.
Most changes are reflected live without having to restart the server.

### Build

```sh
yarn build
```

This command generates static content into the `build` directory and can be
served using any static contents hosting service.

### Deployment

Using SSH:

```sh
USE_SSH=true yarn deploy
```

Not using SSH:

```sh
GIT_USER=<Your GitHub username> yarn deploy
```

If you are using GitHub pages for hosting, this command is a convenient way to
build the website and push to the `gh-pages` branch.
