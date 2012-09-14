
Ext.define('Asgard.Flarc.Plane.Form', {
  extend: 'Asgard.form.ModelFormPanel',
  requires: [
    'Asgard.Flarc.Plugin',
    'Flarc.Plane',
    'Flarc.PlaneType',
    'Asgard.Flarc.PlaneType.ReferenceField',
  ],
  alias: 'widget.flarc_plane_form',
  model: 'Flarc.Plane',

  items: [
   {
    fieldLabel: 'Registration',
    name: 'registration',
   },
   {
    xtype: 'flarc_planetype',
    fieldLabel: 'Type',
    name: 'plane_type_id',
   },
  ],
});
