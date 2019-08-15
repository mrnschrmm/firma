module.exports = {
  host: {
    local: 'firma.local.blee.ch',
    live: 'schramm-reinigung.de'
  },
  path: {
    root: 'app',
    dist: 'app/dist',
    assets: 'base/assets',
    fonts: 'fonts',
    icons: 'icons',
    images: 'images',
    favicons: 'favicons',
    languages: 'site/languages',
    controllers: 'controllers',
    collections: 'collections',
    blueprints: 'blueprints',
    templates: 'templates',
    snippets: 'snippets',
    scripts: 'base',
    styles: 'base',
    configs: 'site/config',
    content: 'access/content'
  },
  vendor: {
    dest: 'app/dist/base/vendor',
    src: [
      'node_modules/jquery/dist/jquery.js',
      'node_modules/body-scroll-lock/lib/bodyScrollLock.js'
    ]
  }
}
