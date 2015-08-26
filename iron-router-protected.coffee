###
@description
Listen for Router.onBeforeAction and Router.onRun to deny access to protected routers, for cases then:
 - current route has 'protected' property
 - current route has 'protected' and 'allowAccess' properties additionally it restricted by user role
###

class IronRouterProtected extends IronRouterHelper
  constructor: (@router) -> 
    super @router
    self = @
    @router.onRun ->
      self.protectRoute()
    @router.onBeforeAction ->
      self.protectRoute()

  forbidden: ->
    if @authTemplate
      @currentRoute.render @authTemplate
    else
      @currentRoute.redirect @authRoute

  getIronParam: (param) ->
    switch
      when _.has @currentRoute.route.options, param then @currentRoute.route.options[param]
      when @currentController and _.has @currentController::, param then @currentController::[param]
      when _.has @router.options, param then @router.options[param]
      else false

  protectRoute: ->
    @authTemplate = @getIronParam('authTemplate')  or undefined
    @authRoute    = @getIronParam('authRoute')     or '/'
    @authCallback = @getIronParam('authCallback')  or undefined
    @allowedRoles = @getIronParam('allowedRoles')  or undefined
    @isProtected  = @getIronParam('protected')

    switch
      when not Meteor.userId() and @isProtected
        @authCallback.call @currentRoute, {error: 401, reason: 'Unauthorized. Only for authenticated users.'} if @authCallback
        @forbidden()
      when Meteor.userId() and @isProtected and not @allowedRoles
        @authCallback.call @currentRoute, null, true if @authCallback
        @currentRoute.next()
      when (Package['alanning:roles'] and @allowedRoles) and (@isProtected and Meteor.userId() and not Meteor.user().roles.diff(@allowedRoles, true))
        @authCallback.call @currentRoute, {error: 403, reason: 'Forbidden. Not enough rights.'} if @authCallback
        @forbidden()
      else
        @authCallback.call @currentRoute, null, true if @authCallback
        @currentRoute.next()

Meteor.startup -> new IronRouterProtected Router


