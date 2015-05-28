###
@description
Listen for Router.onBeforeAction and Router.onRun to deny access to protected routers, for cases then:
 - current route has 'protected' property
 - current route has 'protected' and 'allowAccess' properties additionally it restricted by user role
###
protectRoute = ->
  authTemplate = @route.options.authTemplate  or Router.options.authTemplate  or undefined
  authRoute    = @route.options.authRoute     or Router.options.authRoute     or '/'
  authCallback = @route.options.authCallback  or Router.options.authCallback  or undefined
  isProtected  = @route.options.protected     or Router.options.protected     or false
  allowedRoles = @route.options.allowAccess   or Router.options.allowAccess   or undefined

  authFail = ->
    if authTemplate
      @render authTemplate
    else
      @redirect authRoute

  if !Meteor.user() and isProtected
    authCallback.call @, null, {error: 401, reason: 'Unauthorized. Only for authenticated users.'} if authCallback
    authFail.call @
  else if Meteor.user() and isProtected and !allowedRoles
    authCallback.call @, true, null if authCallback
    @next()
  else if (Package['alanning:roles'] and allowedRoles) and (isProtected and !Meteor.user().roles.diff(allowedRoles, true))
    authCallback.call @, null, {error: 403, reason: 'Forbidden. Not enough rights.'} if authCallback
    authFail.call @
  else
    authCallback.call @, true, null if authCallback
    @next()

Router.onRun ->
  protectRoute.call @

Router.onBeforeAction ->
  protectRoute.call @