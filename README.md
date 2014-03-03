# snout-route

![Snout:  Route!](http://i.imgur.com/tu7IGHX.jpg)

[![Build Status](https://travis-ci.org/natlownes/snout-route.png?branch=master)](https://travis-ci.org/natlownes/snout-route)

tiny routing for the browser, and for your snout, and go lay down, and okay good
boy c'mere.

still kinda pissing around with this for fun; it's only an api for defining
routes and currying functions with the args for that route.  no html5 pushState
or anything like that.  that would be in a separate lib

```coffeescript

assert = require 'assert'

Router = require('snout-route')


router = new Router

router.register "/dogs/:name/size/:size_number", (name, size_number, addl) ->
  assert name        is 'strodog'
  assert size_number is '14'
  assert addl        is 'tacking additional args'
  console.log 'snouting complete!'

func = router.get("/dogs/strodog/size/14")
miss = router.get("/food/20000")

console.log func.args
# => { name: 'strodog', size: '14' }
assert func.args.name is 'strodog'
assert func.args.size_number is '14'

func?('tacking additional args')

assert miss is undefined

```

