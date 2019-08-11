const { series, parallel, src, dest, watch } = require('gulp');

const config = require('./config');
const rename = require('gulp-rename');
const del = require('delete');
const bs = require('browser-sync');

// BROWSERSYNC
// -------------------------------------------------------------

function browsersync(done) {
  const sync = bs.create();

  sync.init({
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
  })
  done();
};

function reload(done) {
  bs.reload()
  done();
};

// CONTENT
// -------------------------------------------------------------

function watch__content() {
  watch(config.paths.content + '**/*', reload)
};

// CONFIG
// -------------------------------------------------------------

function clean__config() {
  return del([config.paths.dist.config]);
};

function copy__config() {
  return src([config.paths.src.config + '**/*'])
    .pipe(dest(config.paths.dist.config));
};

function watch__config() {
  watch(config.paths.src.config + '**/*.php', series(update__config, reload))
};

update__config = series(clean__config, copy__config);

// LANGUAGES
// -------------------------------------------------------------

function clean__languages() {
  return del([config.paths.dist.languages]);
};

function copy__languages() {
  return src([config.paths.src.languages + '**/*'])
    .pipe(dest(config.paths.dist.languages));
};

function watch__languages() {
  watch(config.paths.src.languages + '**/*.php', series(update__languages, reload))
};

update__languages = series(clean__languages, copy__languages);

// BLUEPRINTS
// -------------------------------------------------------------

function clean__blueprints() {
  return del([config.paths.dist.blueprints]);
};

function copy__blueprints() {
  return src([config.paths.src.blueprints + '**/*.yml'])
    .pipe(dest(config.paths.dist.blueprints));
};

function watch__blueprints() {
  watch(config.paths.src.blueprints + '**/*.yml', series(update__blueprints, reload))
};

update__blueprints = series(clean__blueprints, copy__blueprints);

// COLLECTIONS
// -------------------------------------------------------------

function clean__collections() {
  return del([config.paths.dist.collections]);
};

function copy__collections() {
  return src([config.paths.src.collections + '**/*'])
    .pipe(dest(config.paths.dist.collections));
};

function watch__collections() {
  watch(config.paths.src.collections + '**/*.php', series(update__collections, reload))
};

update__collections = series(clean__collections, copy__collections);

// CONTROLLERS
// -------------------------------------------------------------

function clean__controllers() {
  return del([config.paths.dist.controllers]);
};

function copy__controllers() {
  return src([config.paths.src.controllers + '**/*'])
    .pipe(dest(config.paths.dist.controllers));
};

function watch__controllers() {
  watch(config.paths.src.controllers + '**/*.php', series(update__controllers, reload))
};

update__controllers = series(clean__controllers, copy__controllers);

// SNIPPETS
// -------------------------------------------------------------

function clean__snippets() {
  return del([config.paths.dist.snippets]);
};

function copy__snippets() {
  return src([config.paths.src.snippets + '**/*.php'])
    .pipe(dest(config.paths.dist.snippets));
};

function watch__snippets__php() {
  watch(config.paths.src.snippets + '**/*.php', series(update__snippets, reload))
};

function watch__snippets__scss() {
  watch(config.paths.src.snippets + '**/*.scss', series(update__styles, reload))
};

update__snippets = series(clean__snippets, copy__snippets);

// TEMPLATES
// -------------------------------------------------------------

function clean__templates() {
  return del([config.paths.dist.templates]);
};

function copy__templates() {
  return src([config.paths.src.templates + '**/*.php'])
    .pipe(dest(config.paths.dist.templates));
};

function watch__templates() {
  watch(config.paths.src.templates + '**/*.php', series(update__templates, reload))
};

update__templates = series(clean__templates, copy__templates);

// VENDOR
// -------------------------------------------------------------

function clean__vendor() {
  return del([config.paths.dist.vendor]);
};

function copy__vendor() {
  return src(config.paths.vendor)
    .pipe(dest(config.paths.dist.vendor));
};

update__vendor = series(clean__vendor, copy__vendor);

// FONTS
// -------------------------------------------------------------

function clean__fonts() {
  return del([config.paths.dist.fonts]);
};

function copy__fonts() {
  return src([config.paths.src.fonts + '**/*.{eot,ttf,woff,woff2}'])
    .pipe(dest(config.paths.dist.fonts));
};

update__fonts = series(clean__fonts, copy__fonts);

// ICONS
// -------------------------------------------------------------

function clean__icons() {
  return del([config.paths.dist.icons]);
};

function copy__icons() {
  return src([config.paths.src.icons + '**/*.svg'])
    .pipe(dest(config.paths.dist.icons));
};

function watch__icons() {
  watch(config.paths.src.icons + '**/*.svg', series(update__icons, reload))
};

update__icons = series(clean__icons, copy__icons);

// IMAGES
// -------------------------------------------------------------

function clean__img() {
  return del([config.paths.dist.img]);
};

function copy__img() {
  return src([config.paths.src.img + '**/*.{png,jpg,jpeg,gif}'])
    .pipe(dest(config.paths.dist.img));
};

function copy__img__min() {
  const imagemin = require('gulp-imagemin');

  return src([config.paths.src.img + '**/*.{png,jpg,jpeg,gif}'])
    .pipe(imagemin({
      progressive: true,
      interlaced: true,
      optimizationLevel: 7
    }))
    .pipe(dest(config.paths.dist.img));
};

function watch__img() {
  watch(config.paths.src.img + '**/*', series(update__img, reload))
};

update__img__min = series(clean__img, copy__img__min);
update__img = series(clean__img, copy__img);

// FAVICONS
// -------------------------------------------------------------

function clean__favicons() {
  return del([config.paths.dist.favicons]);
};

function generate__favicons() {
  const favicons = require('gulp-favicons');

  return src([config.paths.src.favicons + 'favicon_src.png'])
    .pipe(favicons({
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
};

function watch__favicons() {
  watch(config.paths.src.favicons + '**/*', series(update__favicons, reload))
};

update__favicons = series(clean__favicons, generate__favicons);

// SCRIPTS
// -------------------------------------------------------------

function clean__scripts() {
  return del(config.paths.dist.scripts + '*.{js,js.map}');
};

function generate__scripts() {
  const uglify = require('gulp-uglify')

  return src(config.paths.src.scripts + '{main,panel}.js', { sourcemaps: true })
    .pipe(uglify())
    .pipe(rename({suffix: '.min'}))
    .pipe(dest(config.paths.dist.scripts, { sourcemaps: '.' }));
};

function watch__scripts() {
  watch(config.paths.src.scripts + '**/*.js', series(update__scripts, reload))
};

update__scripts = series(clean__scripts, generate__scripts);

// STYLES
// -------------------------------------------------------------

function clean__styles() {
  return del(config.paths.dist.styles + '*.{css,css.map}');
};

function generate__styles() {
  const autoprefixer = require('gulp-autoprefixer');
  const sass = require('gulp-sass');

  sass.compiler = require('node-sass');

  return src(config.paths.src.styles + '{main,panel}.scss', { sourcemaps: true })
    .pipe(sass({
      outputStyle: 'expanded'
    })
    .on('error', sass.logError))
    .pipe(autoprefixer())
    .pipe(rename({suffix: '.min'}))
    .pipe(dest(config.paths.dist.styles, { sourcemaps: '.' }));
};

function lint__styles() {
  const lint = require('gulp-stylelint');

  return src(config.paths.src.styles + '**/*.scss', config.paths.src.snippets + '**/*.scss')
    .pipe(lint({
      failAfterError: false,
      syntax: "scss",
      reporters: [{
        formatter: 'string',
        console: true
      }]
    }));
};

function lint__styles__strict() {
  const lint = require('gulp-stylelint');

  return src(config.paths.src.styles + '**/*.scss', config.paths.src.snippets + '**/*.scss')
    .pipe(lint({
      failAfterError: true,
      syntax: "scss",
      reporters: [{
        formatter: 'string',
        console: true
      }]
    }));
};

function watch__styles() {
  watch(config.paths.src.styles + '**/*.scss', series(update__styles, reload))
};

update__styles = series(clean__styles, generate__styles);

// COMPOSITIONS
// -------------------------------------------------------------

CORE_BUILD = series(
  parallel(
    update__config,
    update__languages,
    update__blueprints,
    update__collections,
    update__controllers,
    update__snippets,
    update__templates,
  ),
  parallel(
    update__scripts,
    update__styles
  )
);

ASSET_BUILD = series(
  update__icons,
  update__favicons,
  update__fonts,
  update__img,
);

ASSET_OPTIMIZED_BUILD = series(
  update__icons,
  update__favicons,
  update__fonts,
  update__img__min,
);

RUN = series(
  browsersync,

  parallel(
    watch__config,
    watch__content,
    watch__favicons,
    watch__languages,
    watch__blueprints,
    watch__collections,
    watch__controllers,
    watch__templates,
    watch__snippets__php,
    watch__snippets__scss,
    watch__scripts,
    watch__styles,
    watch__icons,
    watch__img
));

LINT_DEVELOPMENT = series(
  lint__styles,
);

LINT_PRODUCTION = series(
  lint__styles__strict,
);

// EXPORT
// -------------------------------------------------------------

exports.default = series(
  LINT_DEVELOPMENT,
  CORE_BUILD,
  ASSET_BUILD,
  RUN
);

exports.build = series(
  LINT_PRODUCTION,
  CORE_BUILD,
  ASSET_OPTIMIZED_BUILD
);
