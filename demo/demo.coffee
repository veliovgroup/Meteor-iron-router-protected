Router.configure
  layoutTemplate: '_layout'
  authTemplate: 'login'
  protected: true #All routes is protected
  authCallback: (error, isGranted) ->
    if error and error?.error is 403
      @render('_403')
      @stop()
      false
    else
      true

signUpController = RouteController.extend
  template: 'signUp'
  path: '/signUp'
  protected: false #Make this route-controller accessible for all users

Router.map ->
  @route 'index',
    template: 'index'
    path: '/'

  @route 'private',
    template: 'private'
    path: '/private'
    allowedRoles: ['regular', 'admin']

  @route 'signUp', 
    controller: signUpController

  @route 'public', 
    template: 'public'
    path: '/public'
    protected: false #Make this route accessible for all users

  @route 'admin',
    template: 'admin'
    path: '/admin'
    allowedRoles: ['admin']
    allowedGroup: 'admins'


serializeForm = (formNode) ->
  form = {}
  (form[input.name] = input.value for input in formNode.serializeArray())
  form

if Meteor.isClient
  Template.signUp.helpers
    formError: ->
      Template.instance().formError.get()

  Template.signUp.events
    'submit form#signUp': (e, template) ->
      template.formError.set false
      e.preventDefault()
      form = serializeForm $ e.currentTarget
      
      check form.email, String
      check form.password, String

      Accounts.createUser 
        username: form.email
        password: form.password
      , 
        (error) ->
          return template.formError.set error.reason if error
      false
  Template.signUp.onCreated ->
    @formError ?= new ReactiveVar false
    Tracker.autorun ->
      Router.go 'index' if Meteor.userId() #Redirect logged-in users


  Template.login.helpers
    formError: ->
      Template.instance().formError.get()
  Template.login.events
    'submit form#login': (e, template) ->
      e.preventDefault()
      template.formError.set false
      form = serializeForm $ e.currentTarget
      
      check form.email, String
      check form.password, String

      Meteor.loginWithPassword form.email, form.password, (error) ->
        return template.formError.set error.reason if error
      false
  Template.login.onCreated ->
    @formError ?= new ReactiveVar false

if Meteor.isServer
  Accounts.onCreateUser (options, user) ->
    user.profile = {}
    user.emails = [{address: options.username, verified: false}]
    return user 

  Meteor.startup ->
    if Meteor.users.find({}).count() is 0
      Accounts.createUser
        username: 'user@example.com'
        password: 'user'

      demo = Accounts.createUser
        username: 'demo@example.com'
        password: 'demo'

      Roles.addUsersToRoles demo, ['regular'], Roles.GLOBAL_GROUP

      admin = Accounts.createUser
        username: 'admin@example.com'
        password: 'admin'

      Roles.addUsersToRoles admin, ['regular', 'admin'], 'admins'