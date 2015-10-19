Changelog
=========
 - [[`v1.1.4`](https://github.com/VeliovGroup/Meteor-iron-router-protected/releases/tag/v1.1.4)] *10/19/2015*
    * Support for `iron:router@1.0.12`
 - [[`v1.1.2`](https://github.com/VeliovGroup/Meteor-iron-router-protected/releases/tag/v1.1.2)] *09/27/2015*
    * Support for Meteor@1.2.x
    * Fix user's roles
    * Add support for roles-groups
    * [Demo app](http://iron-router-protected.meteor.com) enhancement
 - [[`v1.1.1`](https://github.com/VeliovGroup/Meteor-iron-router-protected/releases/tag/v1.1.1)] *08/26/2015*
    * Better coffeescript (no functional changes)
 - [[`v1.1.0`](https://github.com/VeliovGroup/Meteor-iron-router-protected/releases/tag/v1.1.0)] *08/20/2015*
    * Add support for `RouteController`
    * Callback __arguments order changed__ to `function(error, result){...}`
 - [[`v1.0.2`](https://github.com/VeliovGroup/Meteor-iron-router-protected/releases/tag/v1.0.2)] *08/11/2015*
    * Fix not protected routes was blocked by protected in `configure()` method
    * Use faster `switch` instead of `if/else` statement
 - [[`v1.0.1`](https://github.com/VeliovGroup/Meteor-iron-router-protected/releases/tag/v1.0.1)] *05/28/2015*
    * Protect and restrict all routes in `Router.configure()` via `protected` and `allowAccess` properties
 - [`v1.0.0`] Initial, please see docs