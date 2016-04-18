Package.describe({
  name: 'ostrio:iron-router-protected',
  version: '1.1.5',
  summary: 'Create protected and meteor-roles restricted routes within iron-router',
  git: 'https://github.com/VeliovGroup/Meteor-iron-router-protected',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use(['coffeescript', 'ostrio:iron-router-helper-class@1.0.1'], 'client');
  api.addFiles('iron-router-protected.coffee', 'client');
});
