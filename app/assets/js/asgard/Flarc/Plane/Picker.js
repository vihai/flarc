
Ext.define('Asgard.Flarc.Plane.Picker', {
  extend: 'Asgard.ObjectPicker',
  alias: 'widget.flarc_plane_picker',
  requires: [
    'Asgard.Flarc.Plugin',
    'Asgard.Flarc.Plane.View',
  ],

  items: [
   {
    xtype: 'flarc_plane_view',
   }
  ],

  searchIn: [ 'registration' ],
  defaultSortField: 'registration',
  sortFields: [
    { label: 'Registration', field: 'registration' },
  ],
});

