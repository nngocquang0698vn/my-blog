var fs = require('fs');
var gulp = require('gulp');
var minifyHTML = require('gulp-minify-html');
var uncss = require('gulp-uncss');
var minifyCss = require('gulp-minify-css');
var autoprefixer = require('gulp-autoprefixer');
var replace = require('gulp-replace');
var runSequence = require('run-sequence');




gulp.task('optimize-css', function() {
   return gulp.src('_site/css/main.css')
       .pipe(autoprefixer())
       .pipe(uncss({
           html: ['_site/**/*.html'],
           ignore: []
       }))
       .pipe(minifyCss({keepBreaks: false}))
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

gulp.task('default', function(callback) {
  runSequence(
        'optimize-css',
        'optimize-html'
	);
});
