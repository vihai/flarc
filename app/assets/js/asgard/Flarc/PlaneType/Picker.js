
Ext.define('Asgard.Flarc.PlaneType.Picker', {
  extend: 'Asgard.ObjectPicker',
  alias: 'widget.flarc_planetype_picker',
  requires: [
    'Asgard.Flarc.Plugin',
    'Asgard.Flarc.PlaneType.View',
  ],

  items: [
   {
    xtype: 'flarc_planetype_view',
   }
  ],

  searchIn: [ 'name' ],
  defaultSortField: 'name',
  sortFields: [
    { label: 'Name', field: 'name' },
  ],
});

