////////////////////////////////////////////////////////////////////////////////
// GULP
////////////////////////////////////////////////////////////////////////////////

const { series, parallel, src, dest, watch } = require('gulp')

const config = require('./config')
const del = require('del')
const minimist = require('minimist')

const ARGS = minimist(process.argv.slice(2))
const PROD = (ARGS['prod']) ? true : false
const DEBUG = (ARGS['debug']) ? true : false

const path = prep(config.path)
const root = path.root
const dist = path.dist

const autoprefixer = require('gulp-autoprefixer')
const imagemin = require('gulp-imagemin')
const favicon = require('gulp-favicons')
const concat = require('gulp-concat')
const gulpif = require('gulp-if')
const rename = require('gulp-rename')
const uglify = require('gulp-uglify')
const debug = require('gulp-debug')
const sass = require('gulp-sass')
const sass_node = require('node-sass')
const sync = require('browser-sync')

////////////////////////////////////////////////////////////////////////////////
// BROWSERSYNC
////////////////////////////////////////////////////////////////////////////////

const browser = sync.create()

function browsersync (done) {
  browser.init({
    host: config.host.local,
    proxy: config.host.local,
    logLevel: DEBUG ? 'debug' : 'info',
    logFileChanges: DEBUG ? true : false,
    logPrefix: 'firma',
    ghostMode: false,
    open: false,
    notify: false,
    ui: false,
    online: false,
    injectChanges: true,
    reloadDelay: 1000
  })
  done()
}

function reload (done) {
  browser.reload()
  done()
}

////////////////////////////////////////////////////////////////////////////////
// VENDOR
////////////////////////////////////////////////////////////////////////////////

const vendor = series(clean__vendor, copy__vendor)

// CLEAN -------------------------------------------------------------

function clean__vendor () {
  return del([config.vendor.dest])
}

// COPY -------------------------------------------------------------

function copy__vendor () {
  return src(config.vendor.src)
    .pipe(gulpif(DEBUG, debug({ title: '## VENDOR:' })))
    .pipe(dest(config.vendor.dest))
}

////////////////////////////////////////////////////////////////////////////////
// LOGIC
////////////////////////////////////////////////////////////////////////////////

const blueprints__src = (root + path.blueprints).replace('//', '/')
const blueprints__dest = (dist + path.blueprints).replace('//', '/')

const collections__src = (root + path.collections).replace('//', '/')
const collections__dest = (dist + path.collections).replace('//', '/')

const controllers__src = (root + path.controllers).replace('//', '/')
const controllers__dest = (dist + path.controllers).replace('//', '/')

const configs__src = (root + path.configs).replace('//', '/')
const configs__dest = (dist + path.configs).replace('//', '/')

const languages__src = (root + path.languages).replace('//', '/')
const languages__dest = (dist + path.languages).replace('//', '/')

const snippets__src = (root + path.snippets).replace('//', '/')
const snippets__dest = (dist + path.snippets).replace('//', '/')

const templates__src = (root + path.templates).replace('//', '/')
const templates__dest = (dist + path.templates).replace('//', '/')

// CLEAN -------------------------------------------------------------

function clean__blueprints () { return del([blueprints__dest]) };
function clean__collections () { return del([collections__dest]) };
function clean__controllers () { return del([controllers__dest]) };
function clean__configs () { return del([configs__dest]) }
function clean__languages () { return del([languages__dest]) }
function clean__snippets () { return del([snippets__dest]) }
function clean__templates () { return del([templates__dest]) }

// LINT -------------------------------------------------------------

function lint__logic () {
  const phpcs = require('gulp-phpcs')
  return src(['./app/{collections,controllers,templates,snippets,site}/**/*.php', '!index.php'])
    .pipe(gulpif(DEBUG, debug({ title: '## LOGIC:' })))
    .pipe(phpcs({ bin: 'app/vendor/bin/phpcs', standard: './phpcs.ruleset.xml' }))
    .pipe(phpcs.reporter('log'))
}

// COPY -------------------------------------------------------------

function copy__blueprints () {
  return src([blueprints__src + '**/*.yml'])
    .pipe(gulpif(DEBUG, debug({ title: '## BLUEPRINTS:' })))
    .pipe(dest(blueprints__dest))
}

function copy__collections () {
  return src([collections__src + '**/*'])
    .pipe(gulpif(DEBUG, debug({ title: '## COLLECTIONS:' })))
    .pipe(dest(collections__dest))
}

function copy__controllers () {
  return src([controllers__src + '**/*'])
    .pipe(gulpif(DEBUG, debug({ title: '## CONTROLLERS:' })))
    .pipe(dest(controllers__dest))
}

function copy__configs () {
  return src([configs__src + '**/*'])
    .pipe(gulpif(DEBUG, debug({ title: '## CONFIGS:' })))
    .pipe(dest(configs__dest))
}

function copy__languages () {
  return src([languages__src + '**/*'])
    .pipe(gulpif(DEBUG, debug({ title: '## LANGUAGES:' })))
    .pipe(dest(languages__dest))
}

function copy__snippets () {
  return src([snippets__src + '**/*.php'])
    .pipe(gulpif(DEBUG, debug({ title: '## SNIPPETS:' })))
    .pipe(dest(snippets__dest))
}

function copy__templates () {
  return src([templates__src + '**/*.php'])
    .pipe(gulpif(DEBUG, debug({ title: '## TEMPLATES:' })))
    .pipe(dest(templates__dest))
}

// WATCH -------------------------------------------------------------

function watch__logic () {
  watch(blueprints__src + '**/*.yml', series(blueprints, reload))
  watch(collections__src + '**/*.php', series(collections, reload))
  watch(controllers__src + '**/*.php', series(controllers, reload))
  watch(configs__src + '**/*.php', series(configs, reload))
  watch(languages__src + '**/*.php', series(languages, reload))
  watch(snippets__src + '**/*.php', series(snippets, reload))
  watch(templates__src + '**/*.php', series(templates, reload))
}

// COMPOSITION -------------------------------------------------------------

const blueprints = series(clean__blueprints, copy__blueprints)
const collections = series(clean__collections, copy__collections)
const controllers = series(clean__controllers, copy__controllers)
const configs = series(clean__configs, copy__configs)
const languages = series(clean__languages, copy__languages)
const snippets = series(clean__snippets, copy__snippets)
const templates = series(clean__templates, copy__templates)

////////////////////////////////////////////////////////////////////////////////
// ASSETS
////////////////////////////////////////////////////////////////////////////////

const assets__images__src = (root + path.assets + path.images).replace('//', '/')
const assets__images__dest = (dist + path.assets + path.images).replace('//', '/')

const assets__icons__src = (root + path.assets + path.icons).replace('//', '/')
const assets__icons__dest = (dist + path.assets + path.icons).replace('//', '/')

const assets__favicons__src = (root + path.assets + path.favicons).replace('//', '/')
const assets__favicons__dest = (dist + path.assets + path.favicons).replace('//', '/')

const assets__fonts__src = (root + path.assets + path.fonts).replace('//', '/')
const assets__fonts__dest = (dist + path.assets + path.fonts).replace('//', '/')

// CLEAN -------------------------------------------------------------

function clean__images () { return del([assets__images__dest]) }
function clean__icons () { return del([assets__icons__dest]) }
function clean__favicons () { return del([assets__favicons__dest]) }
function clean__fonts () { return del([assets__fonts__dest]) }

// PROCESS -------------------------------------------------------------

function process__images () {
  return src(assets__images__src + '**/*.{png,jpg,jpeg,gif}')
    .pipe(gulpif(DEBUG, debug({ title: '## IMAGES:' })))
    .pipe(imagemin([
      imagemin.gifsicle({ interlaced: true }),
      imagemin.jpegtran({ progressive: true }),
      imagemin.optipng({ optimizationLevel: 7 })
    ]))
    .pipe(dest(assets__images__dest))
}

function process__icons () {
  return src(assets__icons__src + '**/*.svg')
    .pipe(gulpif(DEBUG, debug({ title: '## ICONS:' })))
    .pipe(imagemin([
      imagemin.svgo({
        plugins: [
          { removeTitle: true },
          { removeViewBox: false },
          { cleanupIDs: true },
          { removeXMLNS: false }
        ],
        verbose: DEBUG ? true : false
      })
    ]))
    .pipe(dest(assets__icons__dest))
}

function process__favicons () {
  return src([assets__favicons__src + 'favicon_src.png'])
    .pipe(favicon({
      background: '#FFFFFF',
      path: assets__favicons__dest,
      url: config.host.live,
      display: 'standalone',
      orientation: 'portrait',
      logging: DEBUG ? true : false,
      online: false,
      replace: true,
      icons: {
        android: PROD ? true : false,
        appleIcon: PROD ? true : false,
        appleStartup: PROD ? true : false,
        coast: PROD ? true : false,
        favicons: true,
        firefox: PROD ? true : false,
        windows: PROD ? true : false,
        yandex: PROD ? true : false
      }
    }))
    .pipe(dest(assets__favicons__dest))
}

function copy__fonts () {
  return src([assets__fonts__src + '**/*.{woff,woff2}'])
    .pipe(gulpif(DEBUG, debug({ title: '## FONTS:' })))
    .pipe(dest(assets__fonts__dest))
}

// WATCH -------------------------------------------------------------

function watch__assets () {
  watch(assets__images__src + '**/*.{png,jpg,jpeg,gif}', series(images, reload))
  watch(assets__icons__src + '**/*.svg', series(icons, reload))
  watch(assets__favicons__src + '**/favicon_src.png', series(favicons, reload))
  watch(assets__images__src + '**/*.{woff,woff2}', series(fonts, reload))
}

// COMPOSITION -------------------------------------------------------------

const images = series(clean__images, process__images)
const icons = series(clean__icons, process__icons)
const favicons = series(clean__favicons, process__favicons)
const fonts = series(clean__fonts, copy__fonts)

////////////////////////////////////////////////////////////////////////////////
// SCRIPT
////////////////////////////////////////////////////////////////////////////////

const scripts__src = (root + path.scripts).replace('//', '/')
const scripts__dest = (dist + path.scripts).replace('//', '/')

// CLEAN -------------------------------------------------------------

function clean__scripts__main () { return del(scripts__dest + 'main.min.{js,js.map}') }
function clean__scripts__panel () { return del(scripts__dest + 'panel.min.{js,js.map}') }

// LINT -------------------------------------------------------------

function lint__scripts () {
  const eslint = require('gulp-eslint')
  return src([scripts__src + 'main.js', scripts__src + 'panel.js', snippets__src + '**/script.js'])
    .pipe(gulpif(DEBUG, debug({ title: '## MAIN:' })))
    .pipe(eslint())
    .pipe(eslint.format())
    .pipe(gulpif(PROD, eslint.failAfterError()))
}

// PROCESS -------------------------------------------------------------

function process__scripts__main () {
  return src([scripts__src + 'main.js', snippets__src + '**/script.js'], { sourcemaps: !PROD ? true : false })
    .pipe(gulpif(DEBUG, debug({ title: '## MAIN:' })))
    .pipe(concat('main.js'))
    // .pipe(gulpif(PROD, uglify()))
    .pipe(rename({ suffix: '.min' }))
    .pipe(dest(scripts__dest, { sourcemaps: !PROD ? '.' : false }))
};

function process__scripts__panel () {
  return src(scripts__src + 'panel.js', { sourcemaps: !PROD ? true : false })
    .pipe(gulpif(DEBUG, debug({ title: '## PANEL:' })))
    .pipe(gulpif(PROD, uglify()))
    .pipe(rename({ suffix: '.min' }))
    .pipe(dest(scripts__dest, { sourcemaps: !PROD ? '.' : false }))
};

// WATCH -------------------------------------------------------------

function watch__scripts () {
  watch([scripts__src + 'main.js', snippets__src + '**/script.js'], series(scripts__main, reload))
  watch(scripts__src + 'panel.js', series(scripts__panel, reload))
};

// COMPOSITION -------------------------------------------------------------

const scripts__main = series(clean__scripts__main, process__scripts__main)
const scripts__panel = series(clean__scripts__panel, process__scripts__panel)

////////////////////////////////////////////////////////////////////////////////
// STYLE
////////////////////////////////////////////////////////////////////////////////

const styles__src = (root + path.styles).replace('//', '/')
const styles__dest = (dist + path.styles).replace('//', '/')

// CLEAN -------------------------------------------------------------

function clean__styles () { return del(styles__dest + '*.min.{css,css.map}') }

// LINT -------------------------------------------------------------

function lint__styles () {
  const stylelint = require('gulp-stylelint')
  return src([styles__src + '**/*.scss', snippets__src + '**/*.scss'])
    .pipe(gulpif(DEBUG, debug({ title: '## STYLE:' })))
    .pipe(stylelint({ syntax: 'scss', reporters: [{ formatter: 'string', console: true }], failAfterError: PROD ? true : false }))
}

// PROCESS -------------------------------------------------------------

function process__styles () {
  sass.compiler = sass_node

  return src(styles__src + '{main,panel}.scss', { sourcemaps: !PROD ? true : false })
    .pipe(gulpif(DEBUG, debug({ title: '## STYLE:' })))
    .pipe(sass({ outputStyle: PROD ? 'compressed' : 'expanded' }).on('error', sass.logError))
    .pipe(gulpif(PROD, autoprefixer())).pipe(rename({ suffix: '.min' }))
    .pipe(dest(styles__dest, { sourcemaps: !PROD ? '.' : false }))
}

// WATCH -------------------------------------------------------------

function watch__styles () {
  watch(snippets__src + '**/*.scss', series(styles, reload))
  watch(styles__src + '**/*.scss', series(styles, reload))
}

// COMPOSITION -------------------------------------------------------------

const styles = series(clean__styles, process__styles)

////////////////////////////////////////////////////////////////////////////////
// CONTENT
////////////////////////////////////////////////////////////////////////////////

const content__src = (root + path.content).replace('//', '/')

// WATCH -------------------------------------------------------------

function watch__content () {
  watch(content__src + '**/*', reload)
}

////////////////////////////////////////////////////////////////////////////////
// COMPOSITION
////////////////////////////////////////////////////////////////////////////////

const LOGIC = series(parallel(blueprints, configs, collections, controllers, languages, snippets, templates), vendor)
const STYLE = series(parallel(styles, scripts__main, scripts__panel))
const ASSET = series(images, icons, favicons, fonts)
const LINT = series(lint__logic, lint__styles, lint__scripts)
const RUN = series(browsersync, parallel(watch__logic, watch__assets, watch__styles, watch__scripts, watch__content))

if (PROD) {
  exports.default = series(LINT, LOGIC, STYLE, ASSET)
} else {
  exports.default = series(LOGIC, STYLE, ASSET, RUN)
}

////////////////////////////////////////////////////////////////////////////////
// HELPER
////////////////////////////////////////////////////////////////////////////////

function prep (paths) {
  for (var p in paths) {
    var value = paths[p]
    paths[p] = value.length ? value.replace(/\/?$/, '/') : value
  }
  return paths
}
