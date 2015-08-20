Router.configure
  layoutTemplate: '_layout'
  authTemplate: 'login'
  protected: true #All routes is protected

signUpController = RouteController.extend
  protected: false #Make this route accessible for all users
  template: 'signUp'
  path: '/signUp'

Router.map ->
  @route 'index',
    template: 'index'
    path: '/'

  @route 'signUp', 
    controller: signUpController

  @route 'public', 
    template: 'public'
    path: '/public'
    protected: false #Make this route accessible for all users

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
    user = _.extend user, options
    user.profile = {}
    user.emails = [{address: user.username, verified: false}]
    return user 