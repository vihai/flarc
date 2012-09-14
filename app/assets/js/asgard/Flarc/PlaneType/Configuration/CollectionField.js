/*
 * Copyright (C) 2008-2012, Intercom Srl, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *          Lele Forzani <lele@windmill.it>
 *          Alfredo Cerutti <acerutti@intercom.it>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Asgard.Flarc.PlaneType.Configuration.CollectionField', {
  extend: 'Asgard.form.field.CollectionView',
  requires: [
    'Asgard.Flarc.Plugin',
    'Flarc.PlaneType',
    'Asgard.Flarc.PlaneType.Configuration.Picker',
  ],
  alias: 'widget.flarc_planetypeconfigurations',

  dataview: {
    xtype: 'objectview',
    multiSelect: true,
    tpl: [
      '<tpl for=".">',
        '<div class="item asgard_object asgard_flarc_planetypeconfiguration">',
          '{name}<br/> ',
          '<b>{handicap}</b>',
        '</div>',
      '</tpl>',
    ],
    store: {
      model: 'Flarc.PlaneType.Configuration',
    },
  },

  form: {
    xtype: 'modelform',
    model: 'Flarc.PlaneType.Configuration',
    formMode: 'create',

    items: [
     {
      xtype: 'textfield',
      fieldLabel: 'Name',
      name: 'name',
      minLength: 1,
     },
     {
      xtype: 'numberfield',
      fieldLabel: 'Handicap',
      name: 'handicap',
     },
     {
      xtype: 'numberfield',
      fieldLabel: 'Club Handicap',
      name: 'club_handicap',
     },
    ],
  },
});
