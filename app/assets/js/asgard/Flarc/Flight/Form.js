
Ext.define('Asgard.Flarc.Flight.Form', {
  extend: 'Asgard.form.ModelFormPanel',
  requires: [
    'Asgard.Core.Css',
    'Flarc.Flight',
  ],
  alias: 'widget.flarc_flight_form',
  model: 'Flarc.Flight',

  items: [
   {
    xtype: 'datetimefield',
    fieldLabel: 'Takeoff',
    name: 'takeoff_time',
   },
   {
    xtype: 'datetimefield',
    fieldLabel: 'Landing',
    name: 'landing_time',
   },
   {
    xtype: 'numberfield',
    fieldLabel: 'Distance',
    name: 'distance',
   },



/*
   {
    xtype: 'textfield',
    fieldLabel: 'First name',
    name: 'name.first',
   },
   {
    xtype: 'textfield',
    fieldLabel: 'Middle name',
    name: 'name.middle',
   },
   {
    xtype: 'textfield',
    fieldLabel: 'Last name',
    name: 'name.last',
   },
   {
    xtype: 'textfield',
    fieldLabel: 'Nickname',
    name: 'nickname',
   },
   {
    xtype: 'fieldset',
    title: 'Addresses',
    items: [
     {
      xtype: 'location',
      name: 'birth_location',
      fieldLabel: 'Born location',
      minAccuracy: 200000,
     },
     {
      xtype: 'location',
      name: 'residence_location',
      fieldLabel: 'Residence location',
      minAccuracy: 5000,
     },
     {
      xtype: 'location',
      name: 'invoicing_location',
      fieldLabel: 'Invoicing location',
      minAccuracy: 5000,
     },
    ]
   },
   {
    xtype: 'combo',
    fieldLabel: 'Gender',
    name: 'gender',
    store: [
      [ 'M', 'Male' ],
      [ 'F', 'Female' ],
    ],
    queryMode: 'local',
   },
   {
    xtype: 'textfield',
    fieldLabel: 'Codice fiscale',
    name: 'italian_fiscal_code',
   },
   {
    xtype: 'textfield',
    fieldLabel: 'Partita IVA',
    name: 'vat_number'
   },
   {
    xtype: 'fieldset',
    title: 'Identification',
    items: [
     {
      xtype: 'textfield',
      fieldLabel: 'Document Type',
      name: 'document_type'
     },
     {
      xtype: 'textfield',
      fieldLabel: 'Document Number',
      name: 'document_number'
     },
    ]
   },
   {
    xtype: 'core_channels',
    name: 'channels',
    fieldLabel: 'Channels',
    anchor: '100%'
   },
   {
    xtype: 'core_identities',
    name: 'identities',
    fieldLabel: 'Identities',
   },
   {
    xtype: 'shop_agreements_grid',
    name: 'agreements_as_customer',
    fieldLabel: 'Agreements',
    anchor: '100%',
    acl: { default: 'H', display: 'V' },
   },
*/
  ],
});
