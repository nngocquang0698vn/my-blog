var gulp        = require('gulp'),
	plumber     = require('gulp-plumber'),
	browserSync = require('browser-sync'),
	stylus      = require('gulp-stylus'),
	uglify      = require('gulp-uglify'),
	concat      = require('gulp-concat'),
	jeet        = require('jeet'),
	rupture     = require('rupture'),
	koutoSwiss  = require('kouto-swiss'),
	prefixer    = require('autoprefixer-stylus'),
	imagemin    = require('gulp-imagemin'),
	cp          = require('child_process'),
	gutil       = require('gulp-util');

var messages = {
	jekyllBuild: '<span style="color: grey">Running:</span> $ jekyll build'
};

var jekyllCommand = (/^win/.test(process.platform)) ? 'jekyll.bat' : 'bundle';

var config = {
	drafts: !!gutil.env.drafts,
	production: !!gutil.env.production,
};

/**
 * Build the Jekyll Site
 */
gulp.task('jekyll-build', function (done) {
	browserSync.notify(messages.jekyllBuild);
	args = ['exec', 'jekyll', 'build'];
	if (config.drafts) {
		// we need this as the first argument after `build`
		args.push('--drafts');
	}
	args.push('--incremental');
	return cp.spawn('bundle', args, {stdio: 'inherit'})
		.on('close', done);
});

/**
 * Rebuild Jekyll & do page reload
 */
gulp.task('jekyll-rebuild', ['jekyll-build'], function () {
	browserSync.reload();
});

/**
 * Wait for jekyll-build, then launch the Server
 */
gulp.task('browser-sync', ['jekyll-build'], function() {
	browserSync({
		server: {
			baseDir: '_site'
		}
	});
});

/**
 * Stylus task
 */
gulp.task('stylus', function(){
		gulp.src('src/styl/main.styl')
		.pipe(plumber())
		.pipe(stylus({
			use:[koutoSwiss(), prefixer(), jeet(),rupture()],
			compress: true
		}))
		.pipe(gulp.dest('_site/assets/css/'))
		.pipe(browserSync.reload({stream:true}))
    .pipe(gulp.dest('assets/css'));
});

/**
 * Javascript Task
 */
gulp.task('js', function(){
	return gulp.src('src/js/**/*.js')
		.pipe(plumber())
		.pipe(concat('main.js'))
		.pipe(uglify())
		.pipe(gulp.dest('assets/js/'))
		.pipe(browserSync.reload({stream:true}))
    .pipe(gulp.dest('_site/assets/js/'));
});

/**
 * Imagemin Task
 */
gulp.task('imagemin', function() {
	return gulp.src('src/img/**/*.{jpg,png,gif}')
		.pipe(plumber())
		.pipe(imagemin({ optimizationLevel: 3, progressive: true, interlaced: true }))
		.pipe(gulp.dest('assets/img/'));
});

/**
 * Watch stylus files for changes & recompile
 * Watch html/md files, run jekyll & reload BrowserSync
 */
gulp.task('watch', function () {
	gulp.watch('src/styl/**/*.styl', ['stylus']);
	gulp.watch('src/js/**/*.js', ['js']);
	gulp.watch('src/img/**/*.{jpg,png,gif}', ['imagemin']);
	gulp.watch(['search/*', '_config*.yml', '_data/*', '*.md','*.html', '_includes/*.html', '_layouts/*.html', '_posts/*'], ['jekyll-rebuild']);
	if (config.drafts) {
		gulp.watch('_drafts/*', ['jekyll-rebuild']);
	}
});

/**
 * Default task, running just `gulp` will compile the sass,
 * compile the jekyll site, launch BrowserSync & watch files.
 */
gulp.task('default', ['build', 'browser-sync', 'watch']);
gulp.task('build', ['js', 'stylus', 'jekyll-build']);
