###
@description
Listen for Router.onBeforeAction and Router.onRun to deny access to protected routers, for cases then:
 - current route has 'protected' property
 - current route has 'protected' and 'allowAccess' properties additionally it restricted by user role
###

getController = (route) ->
  if route.findControllerConstructor # for IR 1.0
    route.findControllerConstructor()
  else if route.findController # for IR 0.9
    route.findController()
  else
    null

getIronParam = (route, param) ->
  if _.has route.options, param
    route.options[param]
  else if _.has getController(route)::, param # check the prototype
    getController(route)::[param]
  else if Router.options[param]
    Router.options[param]
  else
    false


protectRoute = ->
  authTemplate = getIronParam(@route, 'authTemplate')  or undefined
  authRoute    = getIronParam(@route, 'authRoute')  or '/'
  authCallback = getIronParam(@route, 'authCallback')  or undefined
  allowedRoles = getIronParam(@route, 'allowedRoles')  or undefined
  isProtected  = getIronParam(@route, 'protected')

  authFail = ->
    if authTemplate
      @render authTemplate
    else
      @redirect authRoute

  switch
    when !Meteor.user() and isProtected
      authCallback.call @, null, {error: 401, reason: 'Unauthorized. Only for authenticated users.'} if authCallback
      authFail.call @
    when Meteor.user() and isProtected and !allowedRoles
      authCallback.call @, true, null if authCallback
      @next()
    when (Package['alanning:roles'] and allowedRoles) and (isProtected and !Meteor.user().roles.diff(allowedRoles, true))
      authCallback.call @, null, {error: 403, reason: 'Forbidden. Not enough rights.'} if authCallback
      authFail.call @
    else
      authCallback.call @, true, null if authCallback
      @next()

Router.onRun ->
  protectRoute.call @

Router.onBeforeAction ->
  protectRoute.call @
