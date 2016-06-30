// Adapted from http://github.com/HackSocNotts/wit
module.exports = function (grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json')
  });

  grunt.initConfig({
    concat: { // JS concat
      options: {
        separator: ';'
      },
      dist: {
        src: [
        'assets/js/skel.min.js',
        'assets/js/jquery.min.js',
        'assets/js/jquery.scrollex.min.js',
        'assets/js/util.js',
        'assets/js/main.js',
		], // In order of concat
        dest: 'assets/js/main.min.js'
      }
    },

    uglify: { // Minify JS
      options: {
        mangle: false
      },
      my_target: {
        files: {
          'assets/js/main.min.js': ['assets/js/main.min.js']
        }
      }
    },

    watch: {
      javascript: { // On .js part file change, merge then minify
        files: ['assets/js/*.js', 'assets/js/ie/*.js'],
        tasks: ['concat', 'uglify']
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-concat'); // Concat JS
  grunt.loadNpmTasks('grunt-contrib-uglify'); // Minify JS
  grunt.loadNpmTasks('grunt-contrib-watch'); // On file update, do task

  grunt.registerTask('default', [
    'concat', 'uglify'
  ]);
};
