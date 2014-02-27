expect = require('chai').expect
Snouter = require('../src/router')


describe 'router', ->

  describe '#register', ->

    it 'should add to stored routes', ->
      router = new Snouter
      router.register '/dogs/:name', (name) ->

      expect(router.routes).to.have.length 1

    it 'should add assocated function to stored routes', ->
      router = new Snouter
      f = (name) ->

      router.register '/dogs/:name', f

      [pattern, func] = router.routes[0]

      expect(func).to.be.an.instanceOf Function
      expect(func).to.equal f

  describe '#get', ->

    it 'should return undefined if no match', ->
      router = new Snouter
      result = router.get('/dogs/strodog')

      expect(result).to.be.undefined
