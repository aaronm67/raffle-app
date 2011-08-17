express = require 'express'
stylus = require 'stylus'
config = require './config.js'
app = module.exports = express.createServer()

app.configure ->
  publicDir = "#{__dirname}/public"
  viewsDir  = "#{__dirname}/views"
  coffeeDir = "#{viewsDir}/coffeescript"

  app.set "views", viewsDir
  app.set "view engine", "jade"
  app.use app.router
  app.use express.compiler(
    src: viewsDir, 
    dest: publicDir, 
    enable: ['coffeescript'])
  app.use(stylus.middleware debug: true, src: viewsDir, dest: publicDir, compile: compileMethod)
  app.use express.static(publicDir)



compileMethod = (str, path) ->
  stylus(str)
    .set('filename', path)
    .set('compress', true)


app.get "/", (req, res) ->
  res.render "index", title: "Twitter Raffle", subtitle: "By <a href='http://comorichweb.posterous.com/'>Como Rich Web</a>"

app.listen config.port
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
