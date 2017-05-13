var gulp        = require('gulp'),
	plumber     = require('gulp-plumber'),
	browserSync = require('browser-sync'),
	uglify      = require('gulp-uglify'),
	concat      = require('gulp-concat'),
	jeet        = require('jeet'),
	rupture     = require('rupture'),
	koutoSwiss  = require('kouto-swiss'),
	imagemin    = require('gulp-imagemin'),
	cp          = require('child_process'),
	minifyHTML  = require('gulp-minify-html'),
	cleanCSS   = require('gulp-clean-css'),
	cleanCSS    = require('gulp-clean-css'),
	autoprefixer = require('gulp-autoprefixer'),
	runSequence = require('run-sequence'),
	gutil       = require('gulp-util');

var messages = {
	jekyllBuild: '<span style="color: grey">Running:</span> $ jekyll build'
};

var config = {
	drafts: !!gutil.env.drafts,
	production: !!gutil.env.production,
};

gulp.task('optimise-html', function() {
	return gulp.src('_site/**/*.html')
		.pipe(minifyHTML({
			quotes: true
		}))
		.pipe(gulp.dest('_site/'));
});


gulp.task('optimise-css', function() {
	return gulp.src('_site/assets/css/**/*.css')
		.pipe(autoprefixer())
		.pipe(cleanCSS({compatability: '*'}))
		.pipe(gulp.dest('_site/assets/css/'));
});

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
	return cp.spawn('bundle', args, {stdio: 'inherit'})
		.on('close', done);
});

/**
 * Rebuild Jekyll & do page reload
 */
gulp.task('jekyll-rebuild', ['do-build'], function () {
	browserSync.reload();
});

/**
 * Wait for jekyll-build, then launch the Server
 */
gulp.task('browser-sync', ['do-build'], function() {
	browserSync({
		server: {
			baseDir: '_site'
		}
	});
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
	return gulp.src('assets/img/**/*.{jpg,png,gif}')
		.pipe(plumber())
		.pipe(imagemin({ optimizationLevel: 3, progressive: true, interlaced: true }))
		.pipe(gulp.dest('assets/img/'));
});

/**
 * Watch html/md files, run jekyll & reload BrowserSync
 */
gulp.task('watch', function () {
	gulp.watch('src/js/**/*.js', ['js']);
	gulp.watch('assets/img/**/*.{jpg,png,gif}', ['imagemin']);
	gulp.watch(['_sass/**/*',
		'assets/css/**/*',
		'search/*',
		'_config*.yml',
		'_data/*',
		'*.md',
		'*.html',
		'_includes/**/*.html',
		'_layouts/**/*.html',
		'_posts/*',
		'_projects/*',
		'_plugins/*',
		'_talks/*'],
		['jekyll-rebuild']);
	if (config.drafts) {
		gulp.watch('_drafts/*', ['jekyll-rebuild']);
	}
});

gulp.task('optimise', ['optimise-css', 'optimise-html'], function() {
});

gulp.task('do-build', function(done) {
	runSequence('js', 'jekyll-build', 'optimise', done);
});

/**
 * Default task, running just `gulp` will compile the sass,
 * compile the jekyll site, launch BrowserSync & watch files.
 */
gulp.task('default', ['browser-sync','watch']);
// TODO what can we do in parallel?
gulp.task('build', ['do-build']);
