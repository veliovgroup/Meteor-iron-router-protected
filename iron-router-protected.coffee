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
    @allowedGroup = @getIronParam('allowedGroup')  or undefined
    @isProtected  = @getIronParam('protected')     or false

    if (@allowedRoles or @allowedGroup) and not Package['alanning:roles']
      throw new Meteor.Error 404, 'Package "alanning:roles" is not installed, but required to use `allowedRoles` and/or allowedGroup properties within "ostrio:iron-router-protected package"'

    unless @isProtected
      @currentRoute.next()
      return

    switch
      when not Meteor.userId()
        acbRes = true
        acbRes = @authCallback.call @currentRoute, {error: 401, reason: 'Unauthorized. Only for authenticated users.'} if @authCallback
        @forbidden() if acbRes
      when Meteor.userId() and not @allowedRoles
        acbRes = true
        acbRes = @authCallback.call @currentRoute, null, true if @authCallback
        @currentRoute.next() if acbRes
      when Package['alanning:roles'] and Meteor.userId() and not Roles.userIsInRole(Meteor.userId(), @allowedRoles, @allowedGroup)
        acbRes = true
        acbRes = @authCallback.call @currentRoute, {error: 403, reason: 'Forbidden. Not enough rights.'} if @authCallback
        @forbidden() if acbRes
      else
        acbRes = true
        acbRes = @authCallback.call @currentRoute, null, true if @authCallback
        @currentRoute.next() if acbRes

Meteor.startup -> new IronRouterProtected Router