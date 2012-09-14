
Ext.define('Asgard.Flarc.PlaneType.Form', {
  extend: 'Asgard.form.ModelFormPanel',
  requires: [
    'Asgard.Flarc.Plugin',
    'Flarc.PlaneType',
    'Asgard.Flarc.PlaneType.Configuration.CollectionField',
  ],
  alias: 'widget.flarc_planetype_form',
  model: 'Flarc.PlaneType',

  items: [
   {
    fieldLabel: 'Name',
    name: 'name',
    width: 350,
   },
   {
    fieldLabel: 'Manufacturer',
    name: 'manufacturer',
    width: 350,
   },
   {
    fieldLabel: 'Link',
    name: 'link_wp',
    width: 500,
   },
   {
    xtype: 'numberfield',
    fieldLabel: 'Handicap',
    name: 'handicap',
    width: 160,
   },
   {
    xtype: 'numberfield',
    fieldLabel: 'Handicap Club',
    name: 'club_handicap',
    width: 160,
   },
   {
    xtype: 'combobox',
    fieldLabel: 'Seats',
    name: 'seats',
    width: 180,
    queryMode: 'local',
    forceSelection: true,
    editable: false,
    store: [
     [ '1', '1 seat' ],
     [ '2', '2 seats' ],
    ],
   },
   {
    xtype: 'combobox',
    fieldLabel: 'Motor',
    name: 'motor',
    width: 250,
    queryMode: 'local',
    forceSelection: true,
    editable: false,
    store: [
     [ '0', 'None' ],
     [ '1', 'Self-Sustaining' ],
     [ '2', 'Self-Launching' ],
    ],
   },
   {
    xtype: 'fieldcontainer',
    fieldLabel: 'Configurations',
    items: {
      xtype: 'flarc_planetypeconfigurations',
      fieldLabel: 'Configurations',
      name: 'configurations',
      height: 250,
      width: 400,
     }
   },
  ],
});
