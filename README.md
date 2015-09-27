Protected and restricted routes within iron-router
========
Create protected and user-roles restricted routes within [iron-router](https://atmospherejs.com/iron/router).
For roles-restricted routes, please see [`meteor-roles`](https://github.com/alanning/meteor-roles), you need to install `meteor-roles` separately to use it.

This package supports `protected` option defined in list below, ordered by prioritization:
 - `Router.route()` [*overrides all*]
 - `RouteController.extend()`
 - `Router.configure()` [*might be overridden by any above*]

Install:
========
```shell
meteor add ostrio:iron-router-protected
```

Demo app
========
 - [Source](https://github.com/VeliovGroup/Meteor-iron-router-protected/tree/master/demo)
 - [Live](http://iron-router-protected.meteor.com)

API:
========
`Router.configure`, `Router.route`, and `RouteController` will use next properties:
 - `protected` {*Boolean*} - Make route explicitly protected for all unauthorized users
 - `authTemplate` {*String*} - Name of the template to render, when access is denied
 - `authRoute` {*String*} - Route where user will be redirected, when access is denied
 - `allowedRoles` {[*String*]} - Array of roles, which have access to route
 - `allowedGroup` {*String*} - Name of the role-group, which have access to route. __Note:__ use only with `allowedRoles` property, if `allowedRoles` is not defined check by `allowedGroup` will be omitted
 - `authCallback` {*Function*} - This function will be triggered on each route, with current route-object as a context and two arguments:
    * `error` {*Object*|*null*} - Object with `error` and `reason` properties, if access is denied
      - `error` - `401` or `403`. `401` when access denied as for unauthorized user (). `403` when access denied by role (Not enough rights).
    * `isGranted` {*Boolean*|*null*} - `true` if access is granted
    * return `false` to prevent further code execution and rendering
    * return `true` to continue default behavior

__Note__: Don't use `authTemplate` and `authRoute` at the same time. If `authTemplate` and `authRoute` is both presented - only `authTemplate` will be used and rendered.


Usage:
========
Create __config__:
```coffeescript
Router.configure
  # Render login form
  authTemplate: 'loginForm' 
  # Redirect to login form, by exact route or route-name
  authRoute:  '/admin/login' 
  # Deny access for unauthorized users on all routes
  protected:    true 
  # Restrict access by array of roles on all routes
  allowedRoles: ['admin'] 
  # Restrict access by role and role-group. 
  # Use only with `allowedRoles` property, otherwise check on group is omitted
  allowedGroup: Roles.GLOBAL_GROUP 
  # This callback triggered each time when access is granted or forbidden for user
  authCallback: (accessGranted, error)->
    console.log accessGranted, error

  # Common options:
  layoutTemplate: '_layout'
  notFoundTemplate: '_404'
  loadingTemplate: 'loading'
```

Create __protected route__:
```coffeescript
Router.route 'admin',
  template: 'admin'
  path: '/admin'
  protected: true # Deny access for unauthorized users
  allowedRoles: ['admin'] # Restrict access by role
```

Override default options:
```coffeescript
Router.route 'admin',
  template: 'admin'
  path: '/admin'
  authTemplate: undefined # Do not render
  authRoute: '/admin/login' # Redirect to login form
  protected: true # Deny access for unauthorized users
```

If __all routes__ is protected, give access to `loginForm`:
```coffeescript
Router.route 'loginForm',
  template: 'loginForm'
  path: '/admin/login'
  protected: false # Allow access to this route
```

Options can be defined on __controllers__:
```coffeescript
LocationController = RouteController.extend(protected: true)
Router.route 'locations',
  controller: LocationController # Will be protected
```

Options on routes will override __controller__ options:
```coffeescript
Router.route 'location',
  controller: 'LocationController'
  protected: false # Won't be protected
```
