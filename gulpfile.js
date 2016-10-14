var fs = require('fs');
var gulp = require('gulp');
var minifyHTML = require('gulp-minify-html');
var uncss = require('gulp-uncss');
var uglify = require('gulp-uglify');
var cleanCSS = require('gulp-clean-css');
var autoprefixer = require('gulp-autoprefixer');
var replace = require('gulp-replace');
var concat = require('gulp-concat');
var runSequence = require('run-sequence');
var cp = require('child_process');
var serve = require('gulp-serve');
var watch = require('gulp-watch');

gulp.task('optimize-js', function() {
    return gulp.src([
        'assets/js/skel.min.js',
        'assets/js/jquery.min.js',
        'assets/js/jquery.scrollex.min.js',
        'assets/js/util.js',
        'assets/js/main.js',
    ])
    .pipe(concat('assets/js/main.min.js'))
    .pipe(uglify())
    .pipe(gulp.dest('_site'));
});

gulp.task('optimize-css', function() {
   return gulp.src('_site/css/*.css')
       .pipe(autoprefixer())
       .pipe(uncss({
           html: ['_site/**/*.html'],
           ignore: []
       }))
       .pipe(cleanCSS({compatability: '*'}))
       .pipe(gulp.dest('_site/css/'));
});

gulp.task('optimize-html', function() {
    return gulp.src('_site/**/*.html')
        .pipe(minifyHTML({
            quotes: true
        }))
        .pipe(replace(/<link.*href=\"\/css\/main.css\"[^>]*>/, function(s) {
            var style = fs.readFileSync('_site/css/main.css', 'utf8');
            return '<style>\n' + style + '\n</style>';
        }))
        .pipe(replace(/<link.*href=\"\/css\/gruvbox.css\"[^>]*>/, function(s) {
            var style = fs.readFileSync('_site/css/gruvbox.css', 'utf8');
            return '<style>\n' + style + '\n</style>';
        }))
        .pipe(gulp.dest('_site/'));
});

gulp.task('jekyll-build', function(done) {
    return cp.spawn('bundle', ['exec', 'jekyll', 'build'], {stdio: 'inherit'})
        .on('close', done);
});

gulp.task('watch', function() {
    gulp.watch('*', ['build']);
});

gulp.task('serve', ['watch'], serve('_site'));

gulp.task('build', function() {
  runSequence(
        'jekyll-build',
        'optimize-js',
        'optimize-css',
        'optimize-html'
	);
});

gulp.task('default', ['build']);
