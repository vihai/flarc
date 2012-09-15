/*
 * Copyright (C) 2012-2012, Intercom Srl, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *          Lele Forzani <lele@windmill.it>
 *          Alfredo Cerutti <acerutti@intercom.it>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Asgard.Flarc.Pilot.Form', {
  extend: 'Asgard.form.ModelFormPanel',
  requires: [
    'Asgard.Core.Plugin',
    'Asgard.Core.Location',
    'Asgard.Core.Identity.CollectionField',
    'Asgard.Core.Channel.CollectionField',
    'Asgard.Flarc.Championship.Pilot.CollectionField',
  ],
  alias: 'widget.flarc_pilot_form',

  model: 'Flarc.Pilot',

  items: [
   {
    xtype: 'displayfield',
    fieldLabel: 'Handle',
    name: 'handle'
   },
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
    xtype: 'datefield',
    fieldLabel: 'Birth date',
    name: 'birth_date',
   },
   {
    xtype: 'fieldcontainer',
    fieldLabel: 'Contacts',
    items:
     {
      xtype: 'core_channels',
      name: 'channels',
      anchor: '100%',
      height: 100,
     },
   },
   {
    xtype: 'fieldcontainer',
    fieldLabel: 'Identities',
    items:
     {
      xtype: 'core_identities',
      name: 'identities',
      height: 100,
     },
   },
   {
    xtype: 'fieldcontainer',
    fieldLabel: 'Championships',
    items:
     {
      xtype: 'flarc_championshippilots',
      name: 'championship_pilots',
      height: 200,
     },
   },
  ],
});
