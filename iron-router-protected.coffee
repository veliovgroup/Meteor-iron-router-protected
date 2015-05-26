###
@description
Listen for Router.onBeforeAction and Router.onRun to deny access to protected routers, for cases then:
 - current route has 'protected' property
 - current route has 'protected' and 'allowAccess' properties additionally it restricted by user role
###
protectRoute = ->
  authTemplate = @route.options.authTemplate or Router.options.authTemplate
  authRoute    = @route.options.authRoute or Router.options.authRoute or '/'
  authCallback = @route.options.authCallback or Router.options.authCallback

  authFail = ->
    if authTemplate
      @render authTemplate
    else
      @redirect authRoute

  if !Meteor.user() and @route.options.protected
    authCallback.call @, null, {error:401, reason: 'Unauthorized. Only for authenticated users.'} if authCallback
    authFail.call(@)
  else if Meteor.user() and @route.options.protected and !@route.options.allowAccess
    authCallback.call @, true, null if authCallback
    @next()
  else if (Package['alanning:roles'] and @route.options.allowAccess) and (@route.options.protected and !Meteor.user().roles.diff(@route.options.allowAccess, true))
    authCallback.call @, null, {error:403, reason: 'Forbidden. Not enough rights.'} if authCallback
    authFail.call(@)
  else
    authCallback.call @, true, null if authCallback
    @next()

Router.onRun ->
  protectRoute.call @

Router.onBeforeAction ->
  protectRoute.call @