var html = require('./index.html')

var Elm = require('./Main.elm')
Elm.embed(Elm.Main, document.querySelector('#mount-point'))
