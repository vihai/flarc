
Ext.define('Asgard.Core.Person.Picker', {
  extend: 'Asgard.ObjectPicker',
  alias: 'widget.person_picker',
  requires: [
    'Asgard.Flarc.Plugin',
    'Asgard.Core.Person.View',
  ],

  items: [
   {
    xtype: 'person_view',
   }
  ],

  searchIn: [ 'first_name', 'last_name' ],
  defaultSortField: 'last_name',
  sortFields: [
    { label: 'First Name', field: 'first_name' },
    { label: 'Last Name', field: 'last_name' },
  ],

  createCreateWindow: function() {
    return Ext.create('Asgard.ObjectCreateWindow', {
      width: 600,
      height: 300,
      modal: true,
      items: {
        xtype: 'core_person_form',
        formMode: 'create',
        standalone: true,
      }
    });
  },
});

