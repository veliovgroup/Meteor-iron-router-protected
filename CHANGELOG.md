Changelog
=========

 - [[`v1.1.0`](https://github.com/VeliovGroup/Meteor-iron-router-protected/releases/tag/v1.1.0)] 08/20/2015
    * Add support for `RouteController`
    * Callback __arguments order changed__ to `function(error, result){...}`
 - [[`v1.0.2`](https://github.com/VeliovGroup/Meteor-iron-router-protected/releases/tag/v1.0.2)] 08/11/2015
    * Fix not protected routes was blocked by protected in `configure()` method
    * Use faster `switch` instead of `if/else` statement
 - [[`v1.0.1`](https://github.com/VeliovGroup/Meteor-iron-router-protected/releases/tag/v1.0.1)] 05/28/2015
    * Protect and restrict all routes in `Router.configure()` via `protected` and `allowAccess` properties
 - [`v1.0.0`] Initial, please see docs