var fs = require('fs');
var gulp = require('gulp');
var minifyHTML = require('gulp-minify-html');
var uglify = require('gulp-uglify');
var cleanCSS = require('gulp-clean-css');
var autoprefixer = require('gulp-autoprefixer');
var replace = require('gulp-replace');
var concat = require('gulp-concat');
var runSequence = require('run-sequence');
var cp = require('child_process');
var serve = require('gulp-serve');
var watch = require('gulp-watch');
var gutil = require('gulp-util');

var config = {
    drafts: !!gutil.env.drafts,
    production: !!gutil.env.production,
};

gulp.task('optimize-js', function() {
    return gulp.src([
        'assets/js/main.min.js',
    ])
    .pipe(uglify())
    .pipe(gulp.dest('_site'));
});

gulp.task('concat-js', function() {
	return gulp.src('_assets/js/**/*.js')
    .pipe(concat('main.min.js'))
    //.pipe(gulp.dest('_site'));
    .pipe(gulp.dest('_site/assets/js/'));
});

gulp.task('optimize-css', function() {
   return gulp.src('_site/css/*.css')
       .pipe(autoprefixer())
       .pipe(cleanCSS({compatability: '*'}))
       .pipe(gulp.dest('_site/css/'));
});

gulp.task('optimize-html', function() {
    return gulp.src('_site/**/*.html')
        .pipe(minifyHTML({
            quotes: true
        }))
        .pipe(gulp.dest('_site/'));
});

gulp.task('jekyll-build', function(done) {
		args = ['exec', 'jekyll', 'build']
		if (config.drafts) {
			// we need this as the first argument after `build`
			args.push('--drafts')
		}
		args.push('--incremental')

    return cp.spawn('bundle', args, {stdio: 'inherit'})
        .on('close', done);
});

gulp.task('watch', function() {
    // via https://robwise.github.io/blog/jekyll-and-gulp
    gulp.watch(['**/*.html', '!_site/**/*.*'], ['build']);
    gulp.watch('**/*.md', ['build']);
    gulp.watch('feed.xml', ['build']);
    gulp.watch('_data/*', ['build']);
    gulp.watch('projects/*', ['build']);
    gulp.watch('_drafts/*', ['build']);
    // gulp.watch(['_*'], ['build']);
});

gulp.task('serve', ['watch'], serve({
		root: '_site',
		port: process.env.PORT || 4000
}));

gulp.task('build', function() {
		// if we're deploying this to production, we want to optimise our output,
		// otherwise, it's just going to slow us down
		if (config.production) {
				runSequence(
						'jekyll-build',
						'concat-js',
						'optimize-js',
						'optimize-css',
						'optimize-html'
				);
		} else {
				runSequence(
						'jekyll-build',
						'concat-js'
				);
		}
});

gulp.task('default', ['build']);
