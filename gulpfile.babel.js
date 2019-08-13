////////////////////////////////////////////////////////////////////////////////
// GULPFILE.JS
////////////////////////////////////////////////////////////////////////////////

import { series, parallel, src, dest, watch } from 'gulp'

import config from './config'
import del from 'del'
import yargs from 'yargs'
import autoprefixer from 'gulp-autoprefixer'
import stylelint from 'gulp-stylelint'
import imagemin from 'gulp-imagemin'
import favicon from 'gulp-favicons'
import eslint from 'gulp-eslint'
import uglify from 'gulp-uglify'
import concat from 'gulp-concat'
import rename from 'gulp-rename'
import gulpif from 'gulp-if'
import phpcs from 'gulp-phpcs'
import debug from 'gulp-debug'
import sass from 'gulp-sass'
import sass_node from 'node-sass'
import bs from 'browser-sync'

const path = prep(config.path)
const root = path.root
const dist = path.dist

const DEBUG = false
const PROD = yargs.argv.prod

////////////////////////////////////////////////////////////////////////////////
// BROWSERSYNC
////////////////////////////////////////////////////////////////////////////////

function browsersync (done) {
  const sync = bs.create()

  sync.init({
    proxy: {
      target: config.host.local,
      ws: false
    },
    ghostMode: false,
    open: false,
    notify: false,
    logFileChanges: false,
    ui: false,
    injectChanges: true,
    reloadDebounce: 1000
  })
  done()
}

function reload (done) {
  bs.reload()
  done()
}

////////////////////////////////////////////////////////////////////////////////
// CONTENT
////////////////////////////////////////////////////////////////////////////////

const content__src = (root + path.content).replace('//', '/')

// TASKS -------------------------------------------------------------

function w__content () {
  watch(content__src + '**/*', reload)
}

////////////////////////////////////////////////////////////////////////////////
// LOGIC
////////////////////////////////////////////////////////////////////////////////

function lint__logic () {
  return src(['app/{collections,controllers,templates,snippets}/**/*.php', '!index.php'])
    .pipe(gulpif(DEBUG, debug({ title: '## LOGIC:' })))
    .pipe(phpcs({ bin: 'app/vendor/bin/phpcs', standard: './phpcs.ruleset.xml' }))
    .pipe(phpcs.reporter('log'))
};

////////////////////////////////////////////////////////////////////////////////
// CONFIGS
////////////////////////////////////////////////////////////////////////////////

const configs = series(clean__configs, copy__configs)

const configs__src = (root + path.configs).replace('//', '/')
const configs__dest = (dist + path.configs).replace('//', '/')

// TASKS -------------------------------------------------------------

function clean__configs () {
  return del([configs__dest])
}

function copy__configs () {
  return src([configs__src + '**/*'])
    .pipe(gulpif(DEBUG, debug({ title: '## CONFIGS:' })))
    .pipe(dest(configs__dest))
}

function w__configs () {
  watch(configs__src + '**/*.php', series(configs, reload))
}

////////////////////////////////////////////////////////////////////////////////
// LANGUAGES
////////////////////////////////////////////////////////////////////////////////

const languages = series(clean__languages, copy__languages)

const languages__src = (root + path.languages).replace('//', '/')
const languages__dest = (dist + path.languages).replace('//', '/')

// TASKS -------------------------------------------------------------

function clean__languages () {
  return del([languages__dest])
};

function copy__languages () {
  return src([languages__src + '**/*'])
    .pipe(gulpif(DEBUG, debug({ title: '## LANGUAGES:' })))
    .pipe(dest(languages__dest))
};

function w__languages () {
  watch(languages__src + '**/*.php', series(languages, reload))
};

////////////////////////////////////////////////////////////////////////////////
// BLUEPRINTS
////////////////////////////////////////////////////////////////////////////////

const blueprints = series(clean__blueprints, copy__blueprints)

const blueprints__src = (root + path.blueprints).replace('//', '/')
const blueprints__dest = (dist + path.blueprints).replace('//', '/')

// TASKS -------------------------------------------------------------

function clean__blueprints () {
  return del([blueprints__dest])
};

function copy__blueprints () {
  return src([blueprints__src + '**/*.yml'])
    .pipe(gulpif(DEBUG, debug({ title: '## BLUEPRINTS:' })))
    .pipe(dest(blueprints__dest))
};

function w__blueprints () {
  watch(blueprints__src + '**/*.yml', series(blueprints, reload))
};

////////////////////////////////////////////////////////////////////////////////
// COLLECTIONS
////////////////////////////////////////////////////////////////////////////////

const collections = series(clean__collections, copy__collections)

const collections__src = (root + path.collections).replace('//', '/')
const collections__dest = (dist + path.collections).replace('//', '/')

// TASKS -------------------------------------------------------------

function clean__collections () {
  return del([collections__dest])
};

function copy__collections () {
  return src([collections__src + '**/*'])
    .pipe(gulpif(DEBUG, debug({ title: '## COLLECTIONS:' })))
    .pipe(dest(collections__dest))
};

function w__collections () {
  watch(collections__src + '**/*.php', series(collections, reload))
};

////////////////////////////////////////////////////////////////////////////////
// CONTROLLERS
////////////////////////////////////////////////////////////////////////////////

const controllers = series(clean__controllers, copy__controllers)

const controllers__src = (root + path.controllers).replace('//', '/')
const controllers__dest = (dist + path.controllers).replace('//', '/')

// TASKS -------------------------------------------------------------

function clean__controllers () {
  return del([controllers__dest])
};

function copy__controllers () {
  return src([controllers__src + '**/*'])
    .pipe(gulpif(DEBUG, debug({ title: '## CONTROLLERS:' })))
    .pipe(dest(controllers__dest))
};

function w__controllers () {
  watch(controllers__src + '**/*.php', series(controllers, reload))
};

////////////////////////////////////////////////////////////////////////////////
// SNIPPETS
////////////////////////////////////////////////////////////////////////////////

const snippets = series(clean__snippets, copy__snippets)

const snippets__src = (root + path.snippets).replace('//', '/')
const snippets__dest = (dist + path.snippets).replace('//', '/')

// TASKS -------------------------------------------------------------

function clean__snippets () {
  return del([snippets__dest])
};

function copy__snippets () {
  return src([snippets__src + '**/*.php'])
    .pipe(gulpif(DEBUG, debug({ title: '## SNIPPETS:' })))
    .pipe(dest(snippets__dest))
};

function w__snippets__php () {
  watch(snippets__src + '**/*.php', series(snippets, reload))
};

function w__snippets__scss () {
  watch(snippets__src + '**/*.scss', series(styles, reload))
};

////////////////////////////////////////////////////////////////////////////////
// TEMPLATES
////////////////////////////////////////////////////////////////////////////////

const templates = series(clean__templates, copy__templates)

const templates__src = (root + path.templates).replace('//', '/')
const templates__dest = (dist + path.templates).replace('//', '/')

// TASKS -------------------------------------------------------------

function clean__templates () {
  return del([templates__dest])
};

function copy__templates () {
  return src([templates__src + '**/*.php'])
    .pipe(gulpif(DEBUG, debug({ title: '## TEMPLATES:' })))
    .pipe(dest(templates__dest))
};

function w__templates () {
  watch(templates__src + '**/*.php', series(templates, reload))
};

////////////////////////////////////////////////////////////////////////////////
// VENDOR
////////////////////////////////////////////////////////////////////////////////

const vendor = series(clean__vendor, copy__vendor)

// TASKS -------------------------------------------------------------

function clean__vendor () {
  return del([config.vendor.dest])
};

function copy__vendor () {
  return src(config.vendor.src)
    .pipe(gulpif(DEBUG, debug({ title: '## VENDOR:' })))
    .pipe(dest(config.vendor.dest))
};

////////////////////////////////////////////////////////////////////////////////
// FONTS
////////////////////////////////////////////////////////////////////////////////

const fonts = series(clean__fonts, copy__fonts)

const fonts__src = (root + path.fonts).replace('//', '/')
const fonts__dest = (dist + path.fonts).replace('//', '/')

// TASKS -------------------------------------------------------------

function clean__fonts () {
  return del([fonts__dest])
};

function copy__fonts () {
  return src([fonts__src + '**/*.{eot,ttf,woff,woff2}'])
    .pipe(gulpif(DEBUG, debug({ title: '## FONTS:' })))
    .pipe(dest(fonts__dest))
};

////////////////////////////////////////////////////////////////////////////////
// ICONS
////////////////////////////////////////////////////////////////////////////////

const icons = series(clean__icons, copy__icons)

const icons__src = (root + path.icons).replace('//', '/')
const icons__dest = (dist + path.icons).replace('//', '/')

// TASKS -------------------------------------------------------------

function clean__icons () {
  return del([icons__dest])
};

function copy__icons () {
  return src([icons__src + '**/*.svg'])
    .pipe(gulpif(DEBUG, debug({ title: '## ICONS:' })))
    .pipe(dest(icons__dest))
};

function w__icons () {
  watch(icons__src + '**/*.svg', series(icons, reload))
};

////////////////////////////////////////////////////////////////////////////////
// IMAGES
////////////////////////////////////////////////////////////////////////////////

const images = series(clean__images, copy__images)

const images__src = (root + path.images).replace('//', '/')
const images__dest = (dist + path.images).replace('//', '/')

// TASKS -------------------------------------------------------------

function clean__images () {
  return del([images__dest])
};

function copy__images () {
  return src([images__src + '**/*.{png,jpg,jpeg,gif}'])
    .pipe(gulpif(DEBUG, debug({ title: '## IMAGES:' })))
    .pipe(gulpif(PROD, imagemin({ progressive: true, interlaced: true, optimizationLevel: 7 })))
    .pipe(dest(images__dest))
};

function w__images () {
  watch(images__src + '**/*', series(images, reload))
};

////////////////////////////////////////////////////////////////////////////////
// FAVICONS
////////////////////////////////////////////////////////////////////////////////

const favicons = series(clean__favicons, generate__favicons)

const favicons__src = (root + path.favicons).replace('//', '/')
const favicons__dest = (dist + path.favicons).replace('//', '/')

// TASKS -------------------------------------------------------------

function clean__favicons () {
  return del([favicons__dest])
};

function generate__favicons () {
  return src([favicons__src + 'favicon_src.png'])
    .pipe(favicon({
      background: '#FFFFFF',
      path: favicons__dest,
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
    .pipe(dest(favicons__dest))
};

function w__favicons () {
  watch(favicons__src + '**/*', series(favicons, reload))
};

////////////////////////////////////////////////////////////////////////////////
// SCRIPT
////////////////////////////////////////////////////////////////////////////////

const scripts__main = series(clean__scripts__main, generate__scripts__main)
const scripts__panel = series(clean__scripts__panel, generate__scripts__panel)

const scripts__src = (root + path.scripts).replace('//', '/')
const scripts__dest = (dist + path.scripts).replace('//', '/')

// TASKS -------------------------------------------------------------

function clean__scripts__main () {
  return del(scripts__dest + 'main.min.{js,js.map}')
};

function clean__scripts__panel () {
  return del(scripts__dest + 'panel.min.{js,js.map}')
};

function generate__scripts__main () {
  return src([scripts__src + 'main.js', snippets__src + '**/script.js'], { sourcemaps: !PROD ? true : false })
    .pipe(gulpif(DEBUG, debug({ title: '## MAIN:' })))
    .pipe(concat('main.js'))
    .pipe(gulpif(PROD, uglify()))
    .pipe(rename({ suffix: '.min' }))
    .pipe(dest(scripts__dest, { sourcemaps: !PROD ? '.' : false }))
};

function generate__scripts__panel () {
  return src(scripts__src + 'panel.js', { sourcemaps: !PROD ? true : false })
    .pipe(gulpif(DEBUG, debug({ title: '## PANEL:' })))
    .pipe(gulpif(PROD, uglify()))
    .pipe(rename({ suffix: '.min' }))
    .pipe(dest(scripts__dest, { sourcemaps: !PROD ? '.' : false }))
};

function lint__scripts__main () {
  return src([scripts__src + 'main.js', snippets__src + '**/script.js'])
    .pipe(gulpif(DEBUG, debug({ title: '## MAIN:' })))
    .pipe(eslint())
    .pipe(eslint.format())
    .pipe(gulpif(PROD, eslint.failAfterError()))
};

function lint__scripts__panel () {
  return src([scripts__src + 'panel.js'])
    .pipe(gulpif(DEBUG, debug({ title: '## PANEL:' })))
    .pipe(eslint())
    .pipe(eslint.format())
    .pipe(gulpif(PROD, eslint.failAfterError()))
};

function w__scripts__main () {
  watch([scripts__src + 'main.js', snippets__src + '**/script.js'], series(scripts__main, reload))
};

function w__scripts__panel () {
  watch(scripts__src + 'panel.js', series(scripts__panel, reload))
};

////////////////////////////////////////////////////////////////////////////////
// STYLE
////////////////////////////////////////////////////////////////////////////////

const styles = series(clean__styles, generate__styles)

const styles__src = (root + path.styles).replace('//', '/')
const styles__dest = (dist + path.styles).replace('//', '/')

// TASKS -------------------------------------------------------------

function clean__styles () {
  return del(styles__dest + '*.min.{css,css.map}')
};

function generate__styles () {
  sass.compiler = sass_node

  return src(styles__src + '{main,panel}.scss', { sourcemaps: !PROD ? true : false })
    .pipe(gulpif(DEBUG, debug({ title: '## STYLE:' })))
    .pipe(sass({ outputStyle: PROD ? 'compressed' : 'expanded' }).on('error', sass.logError))
    .pipe(gulpif(PROD, autoprefixer())).pipe(rename({ suffix: '.min' }))
    .pipe(dest(styles__dest, { sourcemaps: !PROD ? '.' : false }))
};

function lint__styles () {
  return src(styles__src + '**/*.scss', snippets__src + '**/*.scss')
    .pipe(gulpif(DEBUG, debug({ title: '## STYLE:' })))
    .pipe(stylelint({ syntax: 'scss', reporters: [{ formatter: 'string', console: true }], failAfterError: !PROD ? true : false }))
};

function w__styles () {
  watch(styles__src + '**/*.scss', series(styles, reload))
};

////////////////////////////////////////////////////////////////////////////////
// COMPOSITIONS
////////////////////////////////////////////////////////////////////////////////

const LOGIC = series(parallel(configs, languages, blueprints, collections, controllers, snippets, templates))
const STYLE = series(parallel(scripts__main, scripts__panel, styles))
const ASSET = series(images, fonts, icons, favicons)
const LINT = series(lint__logic, lint__styles, lint__scripts__main, lint__scripts__panel)
const RUN = series(browsersync, parallel(w__configs, w__content, w__favicons, w__languages, w__blueprints, w__collections, w__controllers, w__templates, w__snippets__php, w__snippets__scss, w__scripts__main, w__scripts__panel, w__styles, w__icons, w__images))

if (PROD) {
  exports.default = series(LINT, LOGIC, STYLE, ASSET)
} else {
  exports.default = series(LINT, LOGIC, STYLE, ASSET, RUN)
}

////////////////////////////////////////////////////////////////////////////////
// HELPER
////////////////////////////////////////////////////////////////////////////////

function error (error) {
  const message = error.message
  const plugin = error.plugin
  const code = error.code
  const stack = error.stack
  const file = (error.fileName ? error.fileName : (error.file ? error.file : (error.relativePath ? error.relativePath : ''))).replace(process.cwd(), '')

  let note = `############### Error in ${plugin}: \n ${message ? message.replace(process.cwd(), '') : error.toString()} \n File: ${file} \n Code: ${code} \n Code: ${stack}`

  console.log(error)
}

function prep (paths) {
  for (let p in paths) {
    let value = paths[p]
    paths[p] = value.length ? value.replace(/\/?$/, '/') : value
  }
  return paths
}
