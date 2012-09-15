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

Ext.define('Asgard.Flarc.Pilot.Picker', {
  extend: 'Asgard.ObjectPicker',
  requires: [
    'Asgard.Core.Plugin',
    'Asgard.Flarc.Pilot',
    'Asgard.Flarc.Pilot.View',
  ],
  alias: 'widget.flarc_pilot_picker',

  asgardObject: 'Asgard.Flarc.Pilot',

  items: [
   {
    xtype: 'flarc_pilot_view',
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
        xtype: 'flarc_pilot_form',
        formMode: 'create',
        standalone: true,
      }
    });
  },
});

