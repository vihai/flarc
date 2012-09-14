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

Ext.define('Asgard.Flarc.Championship.Flight.Csvva2011.Form', {
  extend: 'Asgard.form.ModelFormPanel',
  requires: [
    'Asgard.Flarc.Plugin',
    'Flarc.Championship',
  ],
  model: 'Flarc.Chapionship.Flight',
  record: {
    _type: 'Flarc::Championship::Flight::Csvva2011',
  },

  items: [
   {
    xtype: 'combobox',
    fieldLabel: 'Status',
    name: 'status',
    width: 370,
    queryMode: 'local',
    store: [
     [ 'pending', 'Pending' ],
     [ 'approved', 'Approved' ],
     [ 'invalid', 'Invalid' ],
    ],
   },
   {
    xtype: 'engnumberfield',
    name: 'distance',
    fieldLabel: 'Distance',
    anchor: '100%',
    allowBlank: false,
    unit: 'm',
   },
  ],
});
