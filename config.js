module.exports = {
  host: {
    local: 'http://firma.local.run:8080',
    live: 'https://www.schramm-reinigung.de'
  },
  path: {
    root: './',
    root_src: 'app',
    root_dist: 'dist',
    root_public: 'public',
    root_secure: 'D:/Tools/__configs/M-1/sites/firma',
    env: 'config',
    license: 'license',
    enviroments: 'enviroments',
    configs: 'config',
    index: 'index',
    site: 'site',
    assets: 'assets',
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
    head: [],
    src: [
      'node_modules/jquery/dist/jquery.js',
      'node_modules/headroom.js/dist/headroom.js',
      'node_modules/body-scroll-lock/lib/bodyScrollLock.js'
    ]
  },
  plugins: []
}
