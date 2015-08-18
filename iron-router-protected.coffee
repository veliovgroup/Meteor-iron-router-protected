###
@description
Listen for Router.onBeforeAction and Router.onRun to deny access to protected routers, for cases then:
 - current route has 'protected' property
 - current route has 'protected' and 'allowAccess' properties additionally it restricted by user role
###
protectRoute = ->
  authTemplate = @route.options.authTemplate  or @route.findControllerConstructor().prototype.authTemplate or Router.options.authTemplate  or undefined
  authRoute    = @route.options.authRoute     or @route.findControllerConstructor().prototype.authRoute or Router.options.authRoute     or '/'
  authCallback = @route.options.authCallback  or @route.findControllerConstructor().prototype.authCallback or Router.options.authCallback  or undefined
  allowedRoles = @route.options.allowAccess   or @route.findControllerConstructor().prototype.allowAccess or Router.options.allowAccess   or undefined
  isProtected  = if _.has @route.options, 'protected' then @route.options.protected else if  _.has @route.findControllerConstructor().prototype, 'protected' then @route.findControllerConstructor().prototype.protected else Router.options.protected or false

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
