
Ext.define('Asgard.Flarc.Championship.Picker', {
  extend: 'Asgard.ObjectPicker',
  requires: [
    'Asgard.Flarc.Plugin',
    'Asgard.Flarc.Championship.View',
  ],
  alias: 'widget.flarc_championship_picker',

  items: [
   {
    xtype: 'flarc_championship_view',
   }
  ],

  searchIn: [ 'name' ],
  defaultSortField: 'name',
  sortFields: [
    { label: 'Name', field: 'name' },
  ],
});

