'use strict';

var gulp = require('gulp');
var gutil = require('gulp-util');
var connect = require('gulp-connect-php');
var gnf = require('gulp-npm-files');
var rename = require("gulp-rename");
var sass = require('gulp-sass');
var cssnano = require('gulp-cssnano');
var sourcemaps = require('gulp-sourcemaps');
var autoprefixer = require('gulp-autoprefixer');
var useref = require('gulp-useref');
var gulpIf = require('gulp-if');
var uglify = require('gulp-uglify');
var imagemin = require('gulp-imagemin');
var cache = require('gulp-cache');
var del = require('del');
var ftp = require('vinyl-ftp');
var plugins = require('gulp-load-plugins')();
var runSequence = require('run-sequence');
var browserSync = require('browser-sync').create();

//  development

gulp.task('connect', function() {
    connect.server({
        base: './src',
        hostname: '127.0.0.1',
        keepalive: false,
        open: false,
        port: 8011,

        bin: '/usr/local/bin/php',
        ini: '/usr/local/etc/php/7.1/php.ini'
  });
});
gulp.task('browserSync',['connect'], function() {
    browserSync.init({
        proxy: "127.0.0.1:8011",
        port: 8011,
        routes: {
            "/node_modules": "node_modules",
            "/browser-sync": "browser-sync"
        },
        ghostMode: false,
        logLevel: 'warn',
        browser: 'google chrome',
        notify: false,
        scrollProportionally: false,
        injectChanges: false
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
    .pipe(rename("main.min.css"))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest('./src/assets/css'))
    .pipe(browserSync.reload({
        stream: true
    }));
});
gulp.task('watch', ['browserSync', 'sass'], function () {
    gulp.watch('./src/assets/sass/**/*.scss', ['sass'])
    gulp.watch("./src/*.php", browserSync.reload);
    gulp.watch("./src/content/**/*.txt", browserSync.reload);
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
    runSequence('clean:dist','clear:cache',['base','assets','content','kirby','panel','site','thumbs'],callback);
});
gulp.task('deploy', require('./glp/deploy')(gulp, plugins));
