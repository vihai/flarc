
Ext.define('Asgard.Flarc.PlaneType.View', {
  extend: 'Asgard.ObjectView',
  alias: 'widget.flarc_planetype_view',
  requires: [
    'Asgard.Flarc.Plugin',
    'Flarc.PlaneType',
    'Asgard.Flarc.PlaneType',
  ],
  asgardObject: 'Asgard.Flarc.PlaneType',
  store: {
    model: 'Flarc.PlaneType',
    params: { view: 'grid' },
    remoteSort: true,
    remoteFilter: true,
  },
});

