Protected and restricted routes within iron-router
========
Create protected and user-roles restricted routes within [iron-router](https://atmospherejs.com/iron/router).
For roles-restricted routes, please see [`meteor-roles`](https://github.com/alanning/meteor-roles), you need to install `meteor-roles` separately to use it.

This package supports `protected` option defined in, list ordered by prioritization:
 - `Router.route()` [*overrides all*]
 - `RouteController.extend()`
 - `Router.configure()` [*might be overridden by any above*]

Install:
========
```shell
meteor add ostrio:iron-router-protected
```

API:
========
`Router.configure`, `Router.route`, and `RouteController` will use next properties:
 - `authTemplate` {*String*} - Name of the template to render, when access is denied
 - `authRoute` {*String*} - Route where user will be redirected, when access is denied
 - `authCallback` {*Function*} - This function will be triggered on each route, with current route-object as a context and two arguments:
    * `accessGranted` {*Boolean*|*null*} - `true` if access is granted
    * `error` {*Object*|*null*} - Object with `error` and `reason` properties, if access is denied
      - `error` - `401` or `403`. `401` when access denied as for unauthorized user (). `403` when access denied by role (Not enough rights).

__Note__: Don't use `authTemplate` and `authRoute` at the same time. If `authTemplate` and `authRoute` is both presented - only `authTemplate` will be used and rendered.


Usage:
========
Create __config__:
```coffeescript
Router.configure
  authTemplate: 'loginForm' # Render login form
  # authRoute: '/admin/login' # Redirect to login form
  protected: true # Deny access for unauthorized users on all routes
  allowAccess: ['admin'] # Restrict access by role on all routes
  authCallback: (accessGranted, error)->
    console.log accessGranted, error
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
  allowAccess: ['admin'] # Restrict access by role
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
