
Ext.define('Asgard.Flarc.Championship.Form', {
  extend: 'Asgard.form.ModelFormPanel',
  requires: [
    'Asgard.Flarc.Plugin',
    'Flarc.Championship',
  ],
  alias: 'widget.flarc_championship_form',
  model: 'Flarc.Championship',

  items: [
   {
    fieldLabel: 'Name',
    name: 'name',
   },
   {
    fieldLabel: 'Icon',
    name: 'icon',
   },
   {
    xtype: 'datefield',
    fieldLabel: 'Valid From',
    name: 'valid_from',
   },
   {
    xtype: 'datefield',
    fieldLabel: 'Valid To',
    name: 'valid_to',
   },
   {
    fieldLabel: 'Driver',
    name: 'driver',
   },
   {
    fieldLabel: 'Symbol',
    name: 'sym',
   },
  ],
});
