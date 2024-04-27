module.exports = async function myPlugin(context, options) {
  // ...
  return {
    name: 'featured-posts',
    async loadContent() {
      /* ... */
    },
    async contentLoaded({content, actions}) {
      /* ... */
    },
    /* other lifecycle API */
  };
};
