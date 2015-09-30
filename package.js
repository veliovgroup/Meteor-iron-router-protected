Package.describe({
  name: 'ostrio:iron-router-protected',
  version: '1.1.3',
  summary: 'Create protected and meteor-roles restricted routes within iron-router',
  git: 'https://github.com/VeliovGroup/Meteor-iron-router-protected',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use(['coffeescript', 'iron:router@1.0.9', 'ostrio:iron-router-helper-class@1.0.0'], 'client');
  api.addFiles('iron-router-protected.coffee', 'client');
  api.imply('ostrio:iron-router-helper-class@1.0.0');
});
