module.exports = {
  host: {
    local: 'https://firma.local.blee.ch',
    live: 'https://www.schramm-reinigung.de'
  },
  path: {
    root: 'app',
    data: 'data',
    dist: 'dist',
    assets: 'assets',
    base: 'base',
    public: 'public',
    content: 'content',
    site: 'site',
    blueprints: 'blueprints',
    fonts: 'fonts',
    icons: 'icons',
    images: 'images',
    favicons: 'favicons',
    languages: 'languages',
    controllers: 'controllers',
    collections: 'collections',
    templates: 'templates',
    snippets: 'snippets',
    scripts: 'public',
    styles: 'public',
    configs: 'config'
  },
  vendor: {
    dest: 'dist/public',
    head: [
      'node_modules/document-register-element/build/document-register-element.js'
    ],
    src: [
      'node_modules/jquery/dist/jquery.js',
      'node_modules/body-scroll-lock/lib/bodyScrollLock.js'
    ]
  }
}
