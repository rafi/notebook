module.exports = {
  root: true,
  parserOptions: {
    sourceType: 'script',
  },
  "env": {
    "node": true,
    "browser": true
  },
  extends: [
    "eslint:recommended",
    "plugin:vue/recommended"
  ],
  "rules": {
    "no-console": "off",
  }
}
