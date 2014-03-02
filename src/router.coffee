argsRegex = /:\w+/g
argsReplaceRegex = "(\\w+)"


class Router

  constructor: ->
    # list of objects
    # {stringPattern, accept, paramNames, action}
    @routes = []

  register: (pattern, func) ->
    @routes.push(
      stringPattern:  pattern
      accept:         @_compile(pattern)
      paramNames:     @_paramNames(pattern)
      action:         func
    )

  unregister: (pattern) ->
    routeIndex = do (pattern) =>
      for r, i in @routes
        return i if r.stringPattern is pattern

    if routeIndex? then @routes.splice(routeIndex, 1)

  get: (requestedRoute) ->
    route = do (requestedRoute) =>
      for r in @routes
        return r if r.accept.test(requestedRoute)

    return undefined unless route

    params = @_extractParams(route.accept, requestedRoute)
    args   = {}
    for name, i in route.paramNames
      args[name] = params[i]

    [args, @_curry(route.action, params...)]

  _extractParams: (regex, routeString) ->
    new RegExp(regex).exec(routeString).slice(1)

  _paramNames: (routeInit) ->
    re = new RegExp(argsRegex)
    for name in routeInit.match(re)
      name.replace(':','')

  _compile: (routeInit) ->
    route = routeInit.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')
      .replace(argsRegex, argsReplaceRegex)
    new RegExp("^#{route}", 'g')

  _curry: (fn) ->
    slice = [].slice
    args = slice.call(arguments, 1)
    =>
      args.push(slice.call(arguments)...)
      fn.apply(this, args)


module.exports = Router
