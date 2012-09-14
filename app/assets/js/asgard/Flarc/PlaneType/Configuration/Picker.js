
Ext.define('Asgard.Flarc.PlaneType.Configuration.Picker', {
  extend: 'Asgard.ObjectPicker',
  alias: 'widget.flarc_planetypeconfiguration_picker',
  requires: [
    'Asgard.Flarc.Plugin',
    'Asgard.Flarc.PlaneType.Configuration.View',
  ],

  items: [
   {
    xtype: 'flarc_planetypeconfiguration_view',
   }
  ],

  searchIn: [ 'name' ],
  defaultSortField: 'name',
  sortFields: [
    { label: 'Name', field: 'name' },
  ],
});

