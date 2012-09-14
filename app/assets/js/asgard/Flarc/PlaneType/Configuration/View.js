
Ext.define('Asgard.Flarc.PlaneType.Configuration.View', {
  extend: 'Asgard.ObjectView',
  requires: [
    'Asgard.Flarc.Plugin',
    'Flarc.PlaneType',
    'Asgard.Flarc.PlaneType.Configuration',
  ],
  alias: 'widget.flarc_planetypeconfiguration_view',

  asgardObject: 'Asgard.Flarc.PlaneType.Configuration',
  store: {
    model: 'Flarc.PlaneType.Configuration',
  },
});

