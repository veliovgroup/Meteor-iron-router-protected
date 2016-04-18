Demo app
=====

 - ~~[See it in action](http://iron-router-protected.meteor.com) at meteor.com~~ (*We are looking for free hosting for this demo*)

Included routes:
 - `/` (`index`) - Protected, available for all authorized users
 - `/signUp` (`signUp`) - Not protected
 - `/public` (`public`) - Not protected
 - `/private` (`private`) - Protected only available for users in role: `admin` and `regular`, without role dependency
 - `/admin` (`admin`) - Protected, only available for users in `admins` group

Default users:
 - Demo app has functionality of creating users, user will be created without any role or group, available routes for such users must be:
    * '/' (`index`)
    * `/signUp` (`signUp`)
    * `/public` (`public`)
 - `user`, username and email is `user@example.com` and password is `user`. This user created with `regular` role, available routes for such users must be:
    * '/' (`index`)
    * `/signUp` (`signUp`)
    * `/public` (`public`)
 - `demo`, username and email is `demo@example.com` and password is `demo`. This user created with `regular` role, available routes for such users must be:
    * '/' (`index`)
    * `/signUp` (`signUp`)
    * `/public` (`public`)
    * `/private` (`private`)
 - `admin`, username and email is `admin@example.com` and password is `admin`. This user created with `regular` and `admin` roles and in `admins` group, available routes for such users must be:
    * '/' (`index`)
    * `/signUp` (`signUp`)
    * `/public` (`public`)
    * `/admin` (`admin`)
 - __Non-authorized__ users has access only to:
    * `/signUp` (`signUp`)
    * `/public` (`public`)
