
Ext.define('Asgard.Flarc.Plane.View', {
  extend: 'Asgard.ObjectView',
  alias: 'widget.flarc_plane_view',
  requires: [
    'Asgard.Flarc.Plugin',
    'Flarc.Plane',
    'Flarc.PlaneType',
    'Asgard.Flarc.Plane',
  ],
  asgardObject: 'Asgard.Flarc.Plane',
  store: {
    model: 'Flarc.Plane',
    params: { view: 'grid' },
    remoteSort: true,
    remoteFilter: true,
  },
});

