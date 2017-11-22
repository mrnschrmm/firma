"use strict";

const pkg                       = require('./package.json');

const gulp                      = require('gulp');

const $                         = require('gulp-load-plugins')({

    pattern: ['*'],
    scope: ['devDependencies']
    
});

var gutil                       = require('gulp-util');
var connect                     = require('gulp-connect-php');
var browserSync                 = require('browser-sync').create();
var ftp                         = require('vinyl-ftp');
var gulpftp                     = require('./glp/config.js');

//  development

gulp.task('connect', function() {
    return connect.server({
        base:                   pkg.paths.src.base,
        hostname:               'firma.dev',
        port:                   8030,

        keepalive:              false,
        open:                   false,

        bin:                    '/usr/local/bin/php',
        ini:                    '/usr/local/etc/php/7.1/php.ini'
    });
});

gulp.task('browserSync', function () {
    browserSync.init({
        host:                   'firma.dev',
        proxy:                  'firma.dev:8030',
        port:                   8090,

        open:                   false,
        logLevel:               'info',
        logPrefix:              'firma',

        ui:                     false,
        notify:                 false,
        injectChanges:          false,
        ghostMode:              false,
        scrollProportionally:   false,
        reloadOnRestart:        true,

        routes: {
            '/node_modules':    'node_modules',
            '/browser-sync':    'browser-sync'
        }
    });
});

gulp.task('scss', () => {
    return gulp.src(pkg.paths.src.scss + pkg.vars.scssName)
    .pipe($.sourcemaps.init({loadMaps: true}))
    .pipe($.sass().on('error', $.sass.logError))
    .pipe($.autoprefixer())
    .pipe($.cssnano({
        discardComments: {
            removeAll: true
        },
        discardDuplicates: true,
        discardEmpty: true,
        minifyFontValues: true,
        minifySelectors: true
    }))
    .pipe($.rename(pkg.vars.cssName))
    .pipe($.sourcemaps.write('./'))
    .pipe($.size({gzip: true, showFiles: true}))
    .pipe(gulp.dest(pkg.paths.src.css))
    .pipe(browserSync.stream());
});

gulp.task('plugin:js', function () {
    return gulp.src(pkg.globs.pluginJs).pipe(gulp.dest(pkg.paths.src.js))
});

gulp.task('js', () => {
    return gulp.src(pkg.paths.src.js + pkg.vars.jsName)
    .pipe($.uglify())
    .pipe($.rename({suffix: '.min'}))
    .pipe($.size({gzip: true, showFiles: true}))
    .pipe(gulp.dest(pkg.paths.src.js))
    .pipe(browserSync.stream());    
});

gulp.task('favicons:base', () => {
    return gulp.src(pkg.paths.favicon.src).pipe($.favicons({
        appName: pkg.name,
        appDescription: pkg.description,
        developerName: pkg.author,
        developerURL: pkg.urls.live,
        background: '#FFFFFF',
        path: pkg.paths.favicon.basepath,
        url: pkg.urls.live,
        display: 'standalone',
        orientation: 'portrait',
        version: pkg.version,
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
    .pipe(gulp.dest(pkg.paths.favicon.basedest));
});

gulp.task('favicons:platforms', () => {
    return gulp.src(pkg.paths.favicon.src).pipe($.favicons({
        appName: pkg.name,
        appDescription: pkg.description,
        developerName: pkg.author,
        developerURL: pkg.urls.live,
        background: '#FFFFFF',
        path: pkg.paths.favicon.platformspath,
        url: pkg.urls.live,
        display: 'standalone',
        orientation: 'portrait',
        version: pkg.version,
        logging: true,
        online: false,
        html: pkg.paths.src.favicons + 'platforms.html',
        replace: true,
        icons: {
            android: true, 
            appleIcon: true, 
            appleStartup: true, 
            coast: true, 
            favicons: false,
            firefox: true, 
            windows: true, 
            yandex: true 
        }
    }))  
    .pipe(gulp.dest(pkg.paths.favicon.platformsdest));
});

//  production


gulp.task('dist:base', function() {
    return gulp.src(pkg.globs.src).pipe(gulp.dest(pkg.paths.dist.base));
});

gulp.task('dist:js', function() {
    return gulp.src(pkg.globs.js).pipe(gulp.dest(pkg.paths.dist.js));
});

gulp.task('dist:css', function() {
    return gulp.src(pkg.paths.src.css + '*.css').pipe(gulp.dest(pkg.paths.dist.css));
});

gulp.task('dist:fonts', () => {
    return gulp.src(pkg.paths.src.fonts + '**/*.{eot,ttf,woff,woff2}').pipe(gulp.dest(pkg.paths.dist.fonts));
});

gulp.task('dist:avatars', function() {
    return gulp.src(pkg.paths.src.avatars + '*').pipe(gulp.dest(pkg.paths.dist.avatars));
});

gulp.task('dist:kirby', function() {
    return gulp.src(pkg.paths.src.kirby + '**/*').pipe(gulp.dest(pkg.paths.dist.kirby));
});

gulp.task('dist:panel', function() {
    return gulp.src(pkg.paths.src.panel + '**/*').pipe(gulp.dest(pkg.paths.dist.panel));
});

gulp.task('dist:site', function() {
    return gulp.src(pkg.paths.src.site + '**/*').pipe(gulp.dest(pkg.paths.dist.site));
});

gulp.task('dist:favicons', () => {
    return gulp.src(pkg.paths.src.favicons + '*').pipe(gulp.dest(pkg.paths.dist.favicons));
});

gulp.task('dist:img', () => {
    return gulp.src(pkg.paths.src.img + '*').pipe(gulp.dest(pkg.paths.dist.img));
});

gulp.task('dist:thumbs', function() {
    return gulp.src(pkg.paths.src.thumbs + '**/*').pipe(gulp.dest(pkg.paths.dist.thumbs));
});

gulp.task('dist:content', function() {
    return gulp.src(pkg.paths.src.content + '**/*')
    .pipe($.if('*.{png,jpg,jpeg,gif,svg}', $.imagemin({
        progressive: true,
        interlaced: true,
        optimizationLevel: 7,
        svgoPlugins: [{removeViewBox: false}],
        verbose: true,
        use: []
    })))
    .pipe(gulp.dest(pkg.paths.dist.content));
});

//  deploy

gulp.task('clean:ftp', function (cb) {
    var conn                = ftp.create( {
        host:               gulpftp.config.host,
        user:               gulpftp.config.user,
        password:           gulpftp.config.pass,
        parallel:           2,
        maxConnections:     2,
        secure:             false,
        // debug:              gutil.log,
        log:                gutil.log
    })
    conn.rmdir('.', cb);
});

gulp.task('upload:ftp', function () {
    var conn                = ftp.create( {
        host:               gulpftp.config.host,
        user:               gulpftp.config.user,
        password:           gulpftp.config.pass,
        parallel:           2,
        maxConnections:     2,
        secure:             false,
        log:                gutil.log
    })
    return gulp.src(pkg.globs.serverDeploy, {base:'./dist', buffer: false}).pipe(conn.dest('/'));
});

gulp.task('content:ftp', function () {
    var conn                = ftp.create( {
        host:               gulpftp.config.host,
        user:               gulpftp.config.user,
        password:           gulpftp.config.pass,
        parallel:           2,
        maxConnections:     2,
        secure:             false,
        log:                gutil.log
    })
    return conn.src(pkg.globs.serverContent, {base:'/content/', buffer: false}).pipe(gulp.dest(pkg.paths.src.content));
});

//  cleanup


gulp.task('clean:dist', function() {
    return $.del.sync('dist');
});

gulp.task('clean:content', function() {
    return $.del.sync('src/content/**/*');
});

//  watch

gulp.task('watch', ['browserSync'], () => {
    gulp.watch([pkg.paths.src.scss + '*.scss'], ['scss']);
    gulp.watch([pkg.paths.src.js + 'main.js'], ['js']);
    gulp.watch([pkg.paths.src.site + '**/*.{php, yml}'], browserSync.reload);
});

//  sequences

gulp.task('content:sync', function (cb) {
    $.runSequence('clean:content', ['content:ftp'], cb);
});

gulp.task('favicons', function (cb) {
    $.runSequence('favicons:base', ['favicons:platforms'], cb);
});

gulp.task('build', function (cb) {
    $.runSequence('clean:dist', ['dist:base', 'dist:js', 'dist:css', 'dist:favicons', 'dist:fonts', 'dist:avatars', 'dist:kirby', 'dist:panel', 'dist:site', 'dist:img', 'dist:thumbs', 'dist:content'], cb);
});

gulp.task('deploy', function (cb) {
    $.runSequence('clean:ftp', ['upload:ftp'], cb);
});

gulp.task('default', function (cb) {
    $.runSequence('connect', 'plugin:js', ['scss', 'js', 'watch'], cb);
});