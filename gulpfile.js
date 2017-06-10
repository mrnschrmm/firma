'use strict';

// gulp with plugins

var gulp            = require('gulp');
var gutil           = require('gulp-util');
var connect         = require('gulp-connect-php');
var gnf             = require('gulp-npm-files');
var rename          = require('gulp-rename');
var sass            = require('gulp-sass');
var cssnano         = require('gulp-cssnano');
var sourcemaps      = require('gulp-sourcemaps');
var autoprefixer    = require('gulp-autoprefixer');
var useref          = require('gulp-useref');
var gulpIf          = require('gulp-if');
var uglify          = require('gulp-uglify');
var imagemin        = require('gulp-imagemin');
var cache           = require('gulp-cache');
var del             = require('del');
var ftp             = require('vinyl-ftp');
var plugins         = require('gulp-load-plugins')();
var runSequence     = require('run-sequence');
var browserSync     = require('browser-sync').create();
var watch = require('gulp-watch');

//  development

gulp.task('sync', function() {
  console.log('Watching files located in mountedFolder');
  return watch('./dist/content/**', function(datos){
      console.log('Kind of event: ' + datos.event);
      for(var i=0; i<datos.history.length; i++){
          var archivoLocal = datos.history[i];
          var archivoRel = datos.history[i].replace(datos.base,'');
          var archivoRemoto = '/content' + archivoRel;
          var valid = true;
          if(archivoLocal.indexOf('/.') >= 0)
            valid=false; //ignore .git, .ssh folders and the like
          console.log('File [' +(i+1) + '] ' + (valid?'valid':'INVALID') + ' localFile: ' + archivoLocal + ', relativeFile: ' + archivoRel + ', remoteFile: ' + archivoRemoto);
          var comando = "lftp";
          var comando_params = "-c \"open −−user ftp1177004-firma −−password nEfU87!x ftp://wp1177004.server-he.de; put " + archivoLocal + " -o " + archivoRemoto + "\" ";
          if(valid){
              console.log('Performing in shell: ' + comando + ' ' + comando_params);
              var exec = require('child_process').exec;
              exec(comando + ' ' + comando_params);
          }
      }//end for
  });//end watch
});//end task

gulp.task('connect', function() {
    connect.server({
        base: './src',
        hostname: 'firma.dev',
        port: 8011,

        keepalive: false,
        open: false,

        bin: '/usr/local/bin/php',
        ini: '/usr/local/etc/php/7.1/php.ini'
  });
});
gulp.task('browserSync',['connect'], function() {
    browserSync.init({
        host: 'firma.dev',
        proxy: 'firma.dev',
        port: 8011,

        open: 'external',
        browser: 'google chrome',
        logLevel: 'warn',

        ui: false,
        notify: false,
        injectChanges: false,
        ghostMode: false,
        scrollProportionally: false,

        snippetOptions: {
          ignorePaths: ['panel/**', 'site/accounts/**']
        },
        routes: {
            '/node_modules': 'node_modules',
            '/browser-sync': 'browser-sync'
        }
    });
});
gulp.task('sass', function () {
    gulp.src('./src/assets/sass/**/*.scss')
    .pipe(sourcemaps.init())
    .pipe(sass().on('error', sass.logError))
    .pipe(autoprefixer({
        browsers: ['last 2 versions'],
        cascade: false
    }))
    .pipe(cssnano())
    .pipe(rename('main.min.css'))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest('./src/assets/css'))
    .pipe(browserSync.reload({
        stream: true
    }));
});
gulp.task('watch', ['browserSync', 'sass'], function () {
    gulp.watch('./src/assets/sass/**/*.scss', ['sass'])
    gulp.watch('./src/*.php', browserSync.reload);
    gulp.watch('./src/content/**/*.txt', browserSync.reload);
});

//  production

gulp.task('clear:cache', function (callback) {
    return cache.clearAll(callback);
});
gulp.task('clean:dist', function() {
    return del.sync('dist');
});
gulp.task('base', function() {
    return gulp.src(['./src/*','./src/.htaccess'])
    .pipe(gulpIf(['index.php','.htaccess','!licence.md','!readme.md'], gulp.dest('dist')));
});
gulp.task('assets', function() {
    return gulp.src('./src/assets/**/*')
    .pipe(gulp.dest('dist/assets'));
});
gulp.task('content', function() {
    return gulp.src('./src/content/**/*')
    .pipe(gulp.dest('dist/content'));
});
gulp.task('kirby', function() {
    return gulp.src('./src/kirby/**/*')
    .pipe(gulp.dest('dist/kirby'));
});
gulp.task('panel', function() {
    return gulp.src('./src/panel/**/*')
    .pipe(gulp.dest('dist/panel'));
});
gulp.task('site', function() {
    return gulp.src('./src/site/**/*')
    .pipe(gulp.dest('dist/site'));
});
gulp.task('thumbs', function() {
    return gulp.src('./src/thumbs/**/*')
    .pipe(gulp.dest('dist/thumbs'));
});

//  sequences

gulp.task('default', function (callback) {
    runSequence('clear:cache',['sass','connect','browserSync','watch'],callback);
});
gulp.task('build', function (callback) {
    runSequence('clean:dist','clear:cache',['sass','base','assets','content','kirby','panel','site','thumbs'],callback);
});
gulp.task('deploy:build', function (callback) {
    runSequence('clean:dist','clear:cache','sync',['sass','base','assets','content','kirby','panel','site','thumbs'],callback);
});
gulp.task('deploy', require('./glp/deploy')(gulp, plugins));
