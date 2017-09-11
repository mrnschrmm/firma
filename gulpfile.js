'use strict';

var gulp                = require('gulp');
var gutil               = require('gulp-util');
var connect             = require('gulp-connect-php');
var sass                = require('gulp-sass');
var cssnano             = require('gulp-cssnano');
var sourcemaps          = require('gulp-sourcemaps');
var autoprefixer        = require('gulp-autoprefixer');
var rename              = require('gulp-rename');
var concat              = require('gulp-concat');
var gulpIf              = require('gulp-if');
var imagemin            = require('gulp-imagemin');
var cache               = require('gulp-cache');
var plugins             = require('gulp-load-plugins')();
var browserSync         = require('browser-sync').create();
var runSequence         = require('run-sequence');
var ftp                 = require('vinyl-ftp');
var del                 = require('del');

//  development

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
        proxy: 'portfolio-h.dev:8011',
        port: 8081,

        open: 'external',
        browser: 'google chrome',
        logLevel: 'warn',

        ui: false,
        notify: false,
        injectChanges: false,
        ghostMode: false,
        scrollProportionally: false,

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
gulp.task('js', function () {
    gulp.src([
        'node_modules/jquery/dist/jquery.slim.min.js',
        'node_modules/popper.js/dist/popper.min.js',
        'node_modules/bootstrap/dist/js/bootstrap.js',
        './src/assets/js/**/*.js'
    ])
    .pipe(concat('main.min.js'))
    .pipe(gulp.dest('./src/assets/js'));
});
gulp.task('watch', ['browserSync', 'sass'], function () {
    gulp.watch('./src/assets/sass/**/*.scss', ['sass'])
    gulp.watch('./src/site/**/*.php', browserSync.reload);
    gulp.watch('./src/content/**/*.txt', browserSync.reload);
});

//  production

gulp.task('clear:cache', function (callback) {
    return cache.clearAll(callback);
});
gulp.task('clean:dist', function() {
    return del.sync('dist');
});
gulp.task('assets-avatars', function() {
    return gulp.src('./src/assets/avatars/*')
    .pipe(gulp.dest('dist/assets/avatars'));
});
gulp.task('assets-css', function() {
    return gulp.src('./src/assets/css/*')
    .pipe(gulp.dest('dist/assets/css'));
});
gulp.task('assets-fonts', function() {
    return gulp.src('./src/assets/fonts/*')
    .pipe(gulp.dest('dist/assets/fonts'));
});
gulp.task('assets-images', function() {
    return gulp.src('./src/assets/images/*')
    .pipe(gulp.dest('dist/assets/images'));
});
gulp.task('assets-js', function() {
    return gulp.src('./src/assets/js/*')
    .pipe(gulp.dest('dist/assets/js'));
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
gulp.task('base', function() {
    return gulp.src([
        './src/.htaccess',
        './src/index.php',
    ])
    .pipe(gulp.dest('dist'));
});

//  sequences

gulp.task('default', function (callback) {
    runSequence('clear:cache',['sass','js','connect','browserSync','watch'],callback);
});
gulp.task('build', function (callback) {
    runSequence('clean:dist','clear:cache',['sass','js','assets-avatars','assets-css','assets-fonts','assets-images','assets-js','content','kirby','panel','site','thumbs','base'],callback);
});
gulp.task('deploy', require('./glp/deploy')(gulp, plugins));
