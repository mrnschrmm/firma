module.exports = {
  host: {
    live: 'schramm-reinigung.de',
    local: 'firma.local.blee.ch'
  },
  path: {
    root: 'app',
    dist: 'app/dist',
    configs: 'site/config',
    languages: 'site/languages',
    fonts: 'base/assets/fonts',
    icons: 'base/assets/icons',
    images: 'base/assets/images',
    favicons: 'base/assets/favicons',
    controllers: 'controllers',
    collections: 'collections',
    blueprints: 'blueprints',
    templates: 'templates',
    snippets: 'snippets',
    scripts: 'base',
    styles: 'base',
    content: 'access/content'
  },
  vendor: {
    dest: 'base/vendor',
    src: [
      'node_modules/jquery/dist/jquery.min.{js,map}'
    ]
  }
}
