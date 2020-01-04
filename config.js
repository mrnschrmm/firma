module.exports = {
  host: {
    local: 'http://firma.local.run:8080',
    live: 'https://www.schramm-reinigung.de'
  },
  path: {
    root_src: 'app',
    root_dist: 'dist',
    root_public: 'public',
    site: 'site',
    assets: 'assets',
    configs: 'config',
    plugins: 'plugins',
    resources: 'resources',
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
    content: 'content',
    db: 'db'
  },
  vendor: {
    dest: 'dist/public',
    head: [
      'node_modules/document-register-element/build/document-register-element.js'
    ],
    src: [
      'node_modules/jquery/dist/jquery.js',
      'node_modules/headroom.js/dist/headroom.js',
      'node_modules/body-scroll-lock/lib/bodyScrollLock.js'
    ]
  },
  plugins: [
    'options'
  ]
}
