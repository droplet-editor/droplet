fs = require 'fs'
express = require 'express'
app = express()

filedir = process.argv[2]
files = fs.readdirSync(filedir).filter((x) -> x.match(/.*\.c$/)?)

console.log files

console.log filedir

app.get '/getcode', (req, res) ->
  res.send fs.readFileSync process.argv[2] + files[Math.floor Math.random() * files.length]

app.use express.static __dirname + '/public'

app.listen 3000, ->
  console.log 'Visit htpp://localhost:3000'
