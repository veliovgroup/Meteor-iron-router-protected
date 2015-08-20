###
@description
Listen for Router.onBeforeAction and Router.onRun to deny access to protected routers, for cases then:
 - current route has 'protected' property
 - current route has 'protected' and 'allowAccess' properties additionally it restricted by user role
###

getController = (route) ->
  switch
    when route.findControllerConstructor then route.findControllerConstructor()
    when route.findController then route.findController()
    else null

getIronParam = (route, param) ->
  switch
    when _.has route.options, param then route.options[param]
    when _.has getController(route)::, param then getController(route)::[param]
    when !!Router.options[param] then Router.options[param]
    else false


protectRoute = ->
  authTemplate = getIronParam(@route, 'authTemplate')  or undefined
  authRoute    = getIronParam(@route, 'authRoute')     or '/'
  authCallback = getIronParam(@route, 'authCallback')  or undefined
  allowedRoles = getIronParam(@route, 'allowedRoles')  or undefined
  isProtected  = getIronParam(@route, 'protected')

  authFail = ->
    if authTemplate
      @render authTemplate
    else
      @redirect authRoute

  switch
    when !Meteor.userId() and isProtected
      authCallback.call @, {error: 401, reason: 'Unauthorized. Only for authenticated users.'} if authCallback
      authFail.call @
    when Meteor.userId() and isProtected and !allowedRoles
      authCallback.call @, null, true if authCallback
      @next()
    when (Package['alanning:roles'] and allowedRoles) and (isProtected and Meteor.userId() and !Meteor.user().roles.diff(allowedRoles, true))
      authCallback.call @, {error: 403, reason: 'Forbidden. Not enough rights.'} if authCallback
      authFail.call @
    else
      authCallback.call @, null, true if authCallback
      @next()

Router.onRun ->
  protectRoute.call @

Router.onBeforeAction ->
  protectRoute.call @
