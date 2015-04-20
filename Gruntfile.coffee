connectMW = require(require("path").resolve("middleware", "connectMW.coffee"))
remapify = require "remapify"

module.exports = (grunt) ->

    port = 7788
  
    # Project configuration.
    grunt.initConfig
        watch:
            coffee_app:
                files: ['app/coffee/main.coffee']
                tasks: ["browserify"]
            coffee_app_lib:
                files: ['app/coffee/lib/**/**.coffee']
                tasks: ["coffee-compile-app"]
            js:
                files: ["app/js/**/**.js", "build/**/**.js"]
                options:
                    livereload: true

        browserify:
            dist:
                files:
                    'build/module.js': ['app/js/**/*.js', 'app/coffee/**/*.coffee']
            options:
                transform: ['coffeeify']
                preBundleCB: (b) ->
                    b.plugin(remapify, [
                        {
                            cwd: 'app/js/lib/'
                            src: '**/*.js'
                            expose: 'lib'
                        }
                    ])

        coffee:
            app:
                options: {
                    bare: true
                }
                files: [
                    expand: true
                    cwd: 'app/coffee'
                    src: ['**/*.coffee']
                    dest: 'app/js'
                    ext: '.js'
                ]

        connect:
            server:
                options:
                    port: port
                    base: '.'
                    middleware: (connect, options) ->
                        return [
                            connectMW.folderMount(connect, options.base)
                        ]

        # concat:
        #     main:
        #         src: ["app/js/requireConfig.js", "app/js/main.js"]
        #         dest: "app/js/supermain.js"

    # grunt.loadNpmTasks "grunt-contrib-concat"

    grunt.loadNpmTasks "grunt-contrib-watch"
    grunt.loadNpmTasks "grunt-contrib-coffee"
    grunt.loadNpmTasks "grunt-contrib-connect"
    grunt.loadNpmTasks "grunt-browserify"
    grunt.loadNpmTasks "grunt-newer"

    grunt.registerTask "default", ["connect:server", "watch"]

    # compilation
    grunt.registerTask "coffee-compile-app", ["newer:coffee:app"]

    grunt.registerTask "server", ["connect"]



