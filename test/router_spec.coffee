expect  = require('chai').expect

Snouter = require('../src/router')


describe 'router', ->

  describe '#register', ->

    it 'should add to stored routes', ->
      router = new Snouter
      router.register '/dogs/:name', (name) ->

      expect(router.routes).to.have.length 1

    describe 'routes storage', ->

      beforeEach ->
        @router = new Snouter
        @router.register '/dogs/:name/s/:dog_size', (name, size) ->

      it 'should add initial string pattern to object', ->
        {stringPattern, accept, paramNames, action} = @router.routes[0]

        expect(stringPattern)
          .to.equal '/dogs/:name/s/:dog_size'

      it 'should compile a regex for matching', ->
        {stringPattern, accept, paramNames, action} = @router.routes[0]
        match = accept.test('/dogs/stro/s/144')

        expect(accept).to.be.an.instanceOf RegExp
        expect(match).to.be.true

      it 'should add parameter names', ->
        {stringPattern, accept, paramNames, action} = @router.routes[0]

        expect(paramNames[0]).to.equal 'name'
        expect(paramNames[1]).to.equal 'dog_size'

      it 'should add the function as action', ->
        {stringPattern, accept, paramNames, action} = @router.routes[0]

        expect(action).to.be.an.instanceOf  Function

      it 'should make a regex that will match the route', ->
        router = new Snouter
        f = (name, size) ->

        router.register '/dogs/:name/s/:somewhat_large', f
        {stringPattern, accept, action} = router.routes[0]

        route = '/dogs/strodog/s/medium'
        matches = route.match(accept)

        expect(accept.test(route)).to.be.true

  describe '#get', ->

    it 'should return undefined if no match', ->
      router = new Snouter
      result = router.get('/dogs/strodog')

      expect(result).to.be.undefined

    it 'should return an object with args', ->
      router = new Snouter
      f = (name, size) ->
      route = '/dogs/:name/s/:somewhat_large'

      router.register route, f

      [args, func] = router.get '/dogs/strodog/s/medium_dog'

      expect(args.name).to.equal 'strodog'
      expect(args.somewhat_large).to.equal 'medium_dog'

    it 'should return a curried function with args', ->
      router = new Snouter
      f = (name, size, three, four) ->
        expect(name).to.equal 'strodog'
        expect(size).to.equal 'medium'
        expect(three).to.equal 3
        expect(four).to.equal  4
        expect(this).to.equal router

      route = '/dogs/:name/s/:somewhat_large'
      router.register route, f

      [args, func] = router.get '/dogs/strodog/s/medium'

      func(3,4)

  describe '#unregister', ->

    it 'should remove route from routes', ->
      router = new Snouter
      router.register '/dogs/:name', (name) ->
      router.register '/dogs/:name/sizes', (name) ->
      router.register '/dogs/:name/sizes/:how_big', (name) ->

      router.unregister '/dogs/:name'

      expect(router.routes).to.have.length 2

      expect(router.get('/dogs/stro')).to.be.undefined

    it 'should return undefined for matching routes after removal', ->
      router = new Snouter
      router.register '/dogs/:name/sizes', (name) ->
      router.register '/dogs/:name', (name) ->

      router.unregister '/dogs/:name'

      expect(router.get('/dogs/stro')).to.be.undefined
