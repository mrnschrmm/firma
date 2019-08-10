const { watch, src, dest, series } = require('gulp');

const config = require('./config')
const del = require('delete');
const sass = require('gulp-sass');
const autoprefixer = require('gulp-autoprefixer');
const uglify = require('gulp-uglify');
const rename = require('gulp-rename');
const favicon = require('gulp-favicons');
const imagemin = require('gulp-imagemin');
const browserSync = require('browser-sync').create();

sass.compiler = require('node-sass');

// FILES
// -------------------------------------------------------------

function copy_vendor() {
  return src(config.paths.vendor).pipe(dest(config.paths.dist.vendor));
}

function copy_fonts() {
  return src(config.paths.src.fonts + '**/*.{eot,ttf,woff,woff2}').pipe(dest(config.paths.dist.fonts));
}

function copy_site() {
  return src(config.paths.src.site + '**/*').pipe(dest(config.paths.dist.site));
}

function copy_blueprints() {
  return src(config.paths.src.blueprints + '**/*').pipe(dest(config.paths.dist.blueprints));
}

function copy_config() {
  return src(config.paths.src.config + '**/*').pipe(dest(config.paths.dist.config));
}

function copy_languages() {
  return src(config.paths.src.languages + '**/*').pipe(dest(config.paths.dist.languages));
}

function copy_snippets() {
  return src(config.paths.src.snippets + '**/*').pipe(dest(config.paths.dist.snippets));
}

function copy_templates() {
  return src(config.paths.src.templates + '**/*').pipe(dest(config.paths.dist.templates));
}

function copy_collections() {
  return src(config.paths.src.collections + '**/*').pipe(dest(config.paths.dist.collections));
}

function copy_controllers() {
  return src(config.paths.src.controllers + '**/*').pipe(dest(config.paths.dist.controllers));
}

function copy_icons() {
  return src(config.paths.src.icons + '**/*').pipe(dest(config.paths.dist.icons));
}

// ASSETS - IMAGES
// -------------------------------------------------------------

function copy_images() {
  return src([config.paths.src.images + '**/*.{png,jpg,jpeg,gif}'])
  .pipe(imagemin({
    progressive: true,
    interlaced: true,
    optimizationLevel: 7,
  }))
  .pipe(dest(config.paths.dist.images));
}

// ASSET - FAVICONS
// -------------------------------------------------------------

function favicons() {
  return src(config.paths.src.favicons + 'favicon_src.png').pipe(favicon({
    background: '#FFFFFF',
    path: config.paths.dist.favicons,
    url: config.urls.local,
    display: 'standalone',
    orientation: 'portrait',
    logging: true,
    online: false,
    replace: true,
    icons: {
      android: false,
      appleIcon: false,
      appleStartup: false,
      coast: false,
      favicons: true,
      firefox: false,
      windows: false,
      yandex: false
    }
  }))
  .pipe(dest(config.paths.dist.favicons));
}

// ASSET - SCRIPTS
// -------------------------------------------------------------

function scripts() {
  return src(config.paths.src.scripts + '{main,panel}.js', { sourcemaps: true })
    .pipe(uglify())
    .pipe(rename({suffix: '.min'}))
    .pipe(dest(config.paths.dist.scripts, { sourcemaps: '.' }));
}

// ASSET - STYLES
// -------------------------------------------------------------

function style() {
  return src(config.paths.src.style + '{main,panel}.scss', { sourcemaps: true })
    .pipe(sass({
      outputStyle: 'expanded'
    })
    .on('error', sass.logError))
    .pipe(autoprefixer())
    .pipe(rename({suffix: '.min'}))
    .pipe(dest(config.paths.dist.style, { sourcemaps: '.' }));
}

// CLEAN - DIST
// -------------------------------------------------------------

function clean_dist(cb) {
  del(['app/dist/**/*', '!app/dist/kirby/**', '!app/dist/plugins/**'])
  cb();
}

// WATCH
// -------------------------------------------------------------

function watch_files() {
  browserSync.init({
    proxy: {
      target: config.urls.local,
      ws: false
    },
    ghostMode: false,
    open: false,
    notify: false,
    ui: false,
    injectChanges: true,
    reloadDebounce: 1000
  }),

  watch(config.paths.src.style + '**/*.scss', series(style, reload)),
  watch(config.paths.src.snippets + '**/*.scss', series(style, reload)),
  watch(config.paths.src.scripts + '**/*.js', series(scripts, reload)),
  watch(config.paths.src.favicons + '**/*', series(favicons, reload));
  watch(config.paths.src.config + '**/*.php', series(copy_config, reload)),
  watch(config.paths.src.snippets + '**/*.php', series(copy_snippets, reload)),
  watch(config.paths.src.blueprints + '**/*.yml', series(copy_blueprints, reload)),
  watch(config.paths.src.collections + '**/*.php', series(copy_collections, reload));
  watch(config.paths.src.controllers + '**/*.php', series(copy_controllers, reload));
  watch(config.paths.src.languages + '**/*.php', series(copy_languages, reload)),
  watch(config.paths.src.templates + '**/*.php', series(copy_templates, reload));
  watch(config.paths.src.images + '**/*', series(copy_images, reload));
  watch(config.paths.src.icons + '**/*', series(copy_icons, reload));
  watch(config.paths.content + '**/*', reload);
}

function reload(done) {
  browserSync.reload();
  done();
}

// COMPOSITION - DEFAULT
// -------------------------------------------------------------

exports.default = series(
  clean_dist,
  copy_vendor,
  copy_fonts,
  copy_images,
  copy_icons,
  copy_site,
  copy_collections,
  copy_controllers,
  copy_blueprints,
  copy_templates,
  copy_snippets,
  favicons,
  scripts,
  style,
  watch_files,
);

// COMPOSITION - BUILD
// -------------------------------------------------------------

exports.build = series(
  clean_dist,
  copy_vendor,
  copy_fonts,
  copy_images,
  copy_icons,
  copy_site,
  copy_collections,
  copy_controllers,
  copy_blueprints,
  copy_templates,
  copy_snippets,
  favicons,
  scripts,
  style,
);
