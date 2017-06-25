#noinspection NodeJsCodingAssistanceForCoreModules
fs = require('fs')
gulp = require('gulp')
yaml = require('js-yaml')
browserSync = require('browser-sync')
reload = browserSync.reload
$ = require('gulp-load-plugins')({pattern: ['gulp-*', 'gulp.*'], replaceString: /\bgulp[\-.]/})

getYamlData = (lang) =>
  $.data (file) =>
    myModelPath = './src/yaml/' + lang + '.yml'
    pageData = yaml.safeLoad(fs.readFileSync(myModelPath))
    commonData = yaml.safeLoad(fs.readFileSync('./src/yaml/_common.yml'))
    data = Object.assign({}, commonData, pageData)
    data.lang = lang
    return data

gulp.task 'pug:build', () ->
# TODO: quarry language default settings.
  for lang in ['en', 'zh']
    destination = if lang == 'en' then 'public' else 'public/' + lang
    gulp.src ['src/*.pug']
      .pipe $.plumber()
      .pipe getYamlData(lang)
      .pipe $.pug({pretty: true})
      .pipe gulp.dest destination

gulp.task 'watch', ['pug:build', 'browser-sync'], () ->
  gulp.watch('./src/*.pug', ['pug:build', reload])
  gulp.watch('./src/yaml/*.yml', ['pug:build', reload])

gulp.task 'browser-sync', ->
# webpack-dev-server
  browserSync.init proxy: 'localhost:8080'
